require("strict")

--Helper functions
local function startswith(text, subtext)
	return string.sub(text, 1, #subtext) == subtext
end
local function endswith(text, subtext)
	return string.sub(text, -#subtext, -1) == subtext
end
local function allcases(s)
	return s:gsub("%a", function(c) 
		return "["..c:upper()..c:lower().."]"
	end)
end
local trimcache = {}
local whitespace = {[" "]=1, ["\n"]=1, ["\t"]=1, ["\r"]=1}
local function cheaptrim(str) --mw.text.trim is surprisingly expensive, so here's an alternative approach
	local quick = trimcache[str]
	if quick then
		return quick
	else
		-- local out = string.gsub(str, "^%s*(.-)%s*$", "%1")
		local lowEnd
		local strlen = #str
		for i = 1,strlen do
			if not whitespace[string.sub(str, i, i)] then
				lowEnd = i
				break
			end
		end
		if not lowEnd then
			trimcache[str] = ""
			return ""
		end
		for i = strlen,1,-1 do
			if not whitespace[string.sub(str, i, i)] then
				local out = string.sub(str, lowEnd, i)
				trimcache[str] = out
				return out
			end
		end
	end
end

--[=[ Implementation notes
---- NORMAL HTML TAGS ----
Tags are very strict on how they want to start, but loose on how they end.
The start must strictly follow <[tAgNaMe](%s|>) with no room for whitespace in
the tag's name, but may then flow as they want afterwards, making
<div\nclass\n=\n"\nerror\n"\n> valid

There's no sense of escaping < or >
E.g.
 <div class="error\>"> will end at \> despite it being inside a quote
 <div class="<span class="error">error</span>"> will not process the larger div

If a tag has no end, it will consume all text instead of not processing

---- NOPROCESSING TAGS (nowiki, pre, syntaxhighlight, source, etc.) ----
(In most comments, <source> will not be mentioned. This is because it is the
deprecated version of <syntaxhighlight>)

No-Processing tags have some interesting differences to the above rules.
For example, their syntax is a lot stricter. While an opening tag appears to
follow the same set of rules, A closing tag can't have any sort of extra
formatting period. While </div a/a> is valid, </nowiki a/a> isn't - only
newlines and spaces/tabs are allowed in closing tags.
Note that, even though <pre> tags cause a visual change when the ending tag has
extra formatting, it won't cause the no-processing effects. For some reason, the
format must be strict for that to apply.

Both the content inside the tag pair and the content inside each side of the
pair is not processed. E.g. <nowiki |}}>|}}</nowiki> would have both of the |}}
escaped in practice.

When something in the code is referenced to as a "Nowiki Tag", it means a tag
which causes wiki text to not be processed, which includes <nowiki>, <pre>,
and <syntaxhighlight>

Since we only care about these tags, we can ignore the idea of an intercepting
tag preventing processing, and just go straight for the first ending we can find
If there is no ending to find, the tag will NOT consume the rest of the text in
terms of processing behaviour (though <pre> will appear to have an effect).
Even if there is no end of the tag, the content inside the opening half will
still be unprocessed, meaning {{X20|<nowiki }}>}} wouldn't end at the first }}
despite there being no ending to the tag.

Note that there are some tags, like <math>, which also function like <nowiki>
which are included in this aswell. Some other tags, like <ref>, have far too
unpredictable behaviour to be handled currently (they'd have to be split and
processed as something seperate - its complicated, but maybe not impossible.)
I suspect that every tag listed in [[Special:Version]] may behave somewhat like
this, but that's far too many cases worth checking for rarely used tags that may
not even have a good reason to contain {{ or }} anyways, so we leave them alone.

---- HTML COMMENTS AND INCLUDEONLY ----
HTML Comments are about as basic as it could get for this
Start at <!--, end at -->, no extra conditions. Simple enough
If a comment has no end, it will eat all text instead of not being processed

includeonly tags function mostly like a regular nowiki tag, with the exception
that the tag will actually consume all future text if not given an ending as
opposed to simply giving up and not changing anything. Due to complications and
the fact that this is far less likely to be present on a page, aswell as being
something that may not want to be escaped, includeonly tags are ignored during
our processing
--]=]
local validtags = {nowiki=1, pre=1, syntaxhighlight=1, source=1, math=1}
--This function expects the string to start with the tag
local function TestForNowikiTag(text, scanPosition)
	local tagName = (string.match(text, "^<([^\n />]+)", scanPosition) or ""):lower()
	if not validtags[tagName] then
		return nil
	end
	local nextOpener = string.find(text, "<", scanPosition+1) or -1
	local nextCloser = string.find(text, ">", scanPosition+1) or -1
	if nextCloser > -1 and (nextOpener == -1 or nextCloser < nextOpener) then
		local startingTag = string.sub(text, scanPosition, nextCloser)
		--We have our starting tag (E.g. '<pre style="color:red">')
		--Now find our ending...
		if endswith(startingTag, "/>") then --self-closing tag (we are our own ending)
			return {
				Tag = tagName,
				Start = startingTag,
				Content = "", End = "",
				Length = #startingTag
			}

		else
			local endingTagStart, endingTagEnd = string.find(text, "</"..allcases(tagName).."[ \t\n]*>", scanPosition)
			if endingTagStart then --Regular tag formation
				local endingTag = string.sub(text, endingTagStart, endingTagEnd)
				local tagContent = string.sub(text, nextCloser+1, endingTagStart-1)
				return {
					Tag = tagName,
					Start = startingTag,
					Content = tagContent,
					End = endingTag,
					Length = #startingTag + #tagContent + #endingTag
				}

			else --Content inside still needs escaping (also linter error!)
				return {
					Tag = tagName,
					Start = startingTag,
					Content = "", End = "",
					Length = #startingTag
				}
			end
		end
	end
	return nil
end
local function TestForComment(text, scanPosition) --Like TestForNowikiTag but for <!-- -->
	if string.match(text, "^<!%-%-", scanPosition) then
		local commentEnd = string.find(text, "-->", scanPosition+4, true)
		if commentEnd then
			return {
				Start = "<!--", End = "-->",
				Content = string.sub(text, scanPosition+4, commentEnd-1),
				Length = commentEnd-scanPosition+3
			}
		else --Consumes all text if not given an ending
			return {
				Start = "<!--", End = "",
				Content = string.sub(text, scanPosition+4),
				Length = #text-scanPosition+1
			}
		end
	end
	return nil
end

--[[ Implementation notes
The goal of this function is to escape all text that wouldn't be parsed if it
was preprocessed (see above implementation notes).

Using keepComments will keep all HTML comments instead of removing them. They
will still be escaped regardless to avoid processing errors
--]]
local function PrepareText(text, keepComments)
	local newtext = {}
	local scanPosition = 1
	while true do
		local NextCheck = string.find(text, "<[NnSsPpMm!]", scanPosition) --Advance to the next potential tag we care about
		if not NextCheck then --Done
			newtext[#newtext+1] =  string.sub(text,scanPosition)
			break
		end
		newtext[#newtext+1] = string.sub(text,scanPosition,NextCheck-1)
		scanPosition = NextCheck
		local Comment = TestForComment(text, scanPosition)
		if Comment then
			if keepComments then
				newtext[#newtext+1] = Comment.Start .. mw.text.nowiki(Comment.Content) .. Comment.End
			end
			scanPosition = scanPosition + Comment.Length
		else
			local Tag = TestForNowikiTag(text, scanPosition)
			if Tag then
				local newTagStart = "<" .. mw.text.nowiki(string.sub(Tag.Start,2,-2)) .. ">"
				local newTagEnd = 
					Tag.End == "" and "" or --Respect no tag ending
					"</" .. mw.text.nowiki(string.sub(Tag.End,3,-2)) .. ">"
				local newContent = mw.text.nowiki(Tag.Content)
				newtext[#newtext+1] = newTagStart .. newContent .. newTagEnd
				scanPosition = scanPosition + Tag.Length
			else --Nothing special, move on...
				newtext[#newtext+1] = string.sub(text, scanPosition, scanPosition)
				scanPosition = scanPosition + 1
			end
		end
	end
	return table.concat(newtext, "")
end

--[=[ Implementation notes
This function is an alternative to Transcluder's getParameters which considers
the potential for a singular { or } or other odd syntax that %b doesn't like to
be in a parameter's value.

When handling the difference between {{ and {{{, mediawiki will attempt to match
as many sequences of {{{ as possible before matching a {{
E.g.
 {{{{A}}}} -> { {{{A}}} }
 {{{{{{{{Text|A}}}}}}}} -> {{ {{{ {{{Text|A}}} }}} }}
If there aren't enough triple braces on both sides, the parser will compromise
for a template interpretation.
E.g.
 {{{{A}} }} -> {{ {{ A }} }}

While there are technically concerns about things such as wikilinks breaking
template processing (E.g. {{[[}}]]}} doesn't stop at the first }}), it shouldn't
be our job to process inputs perfectly when the input has garbage ({ / } isn't
legal in titles anyways, so if something's unmatched in a wikilink, it's
guaranteed GIGO)

Setting dontEscape will prevent running the input text through EET. Avoid
setting this to true if you don't have to set it.

Returned values:
A table of all templates. Template data goes as follows:
 Text: The raw text of the template
 Name: The name of the template
 Args: A list of arguments
 Children: A list of immediate template children
--]=]
--Helper functions
local function boundlen(pair)
	return pair.End-pair.Start+1
end

--Main function
local function ParseTemplates(InputText, dontEscape)
	--Setup
	if not dontEscape then
		InputText = PrepareText(InputText)
	end
	local function finalise(text)
		if not dontEscape then
			return mw.text.decode(text)
		else
			return text
		end
	end
	local function CreateContainerObj(Container)
		Container.Text = {}
		Container.Args = {}
		Container.ArgOrder = {}
		Container.Children = {}
		-- Container.Name = nil
		-- Container.Value = nil
		-- Container.Key = nil
		Container.BeyondStart = false
		Container.LastIndex = 1
		Container.finalise = finalise
		function Container:HandleArgInput(character, internalcall)
			if not internalcall then
				self.Text[#self.Text+1] = character
			end
			if character == "=" then
				if self.Key then
					self.Value[#self.Value+1] = character
				else
					self.Key = cheaptrim(self.Value and table.concat(self.Value, "") or "")
					self.Value = {}
				end
			else --"|" or "}"
				if not self.Name then
					self.Name = cheaptrim(self.Value and table.concat(self.Value, "") or "")
					self.Value = nil
				else
					self.Value = self.finalise(self.Value and table.concat(self.Value, "") or "")
					if self.Key then
						self.Key = self.finalise(self.Key)
						self.Args[self.Key] = cheaptrim(self.Value)
						self.ArgOrder[#self.ArgOrder+1] = self.Key
					else
						local Key = tostring(self.LastIndex)
						self.Args[Key] = self.Value
						self.ArgOrder[#self.ArgOrder+1] = Key
						self.LastIndex = self.LastIndex + 1
					end
					self.Key = nil
					self.Value = nil
				end
			end
		end
		function Container:AppendText(text, ftext)
			self.Text[#self.Text+1] = (ftext or text)
			if not self.Value then
				self.Value = {}
			end
			self.BeyondStart = self.BeyondStart or (#table.concat(self.Text, "") > 2)
			if self.BeyondStart then
				self.Value[#self.Value+1] = text
			end
		end
		function Container:Clean(IsTemplate)
			self.Text = table.concat(self.Text, "")
			if self.Value and IsTemplate then
				self.Value = {string.sub(table.concat(self.Value, ""), 1, -3)} --Trim ending }}
				self:HandleArgInput("|", true) --Simulate ending
			end
			self.Value = nil
			self.Key = nil
			self.BeyondStart = nil
			self.LastIndex = nil
			self.finalise = nil
			self.HandleArgInput = nil
			self.AppendText = nil
			self.Clean = nil
		end
		return Container
	end
	
	--Step 1: Find and escape the content of all wikilinks on the page, which are stronger than templates (see implementation notes)
	local scannerPosition = 1
	local wikilinks = {}
	local openWikilinks = {}
	while true do
		local Position, _, Character = string.find(InputText, "([%[%]])%1", scannerPosition)
		if not Position then --Done
			break
		end

		scannerPosition = Position+2 --+2 to pass the [[ / ]]
		if Character == "[" then --Add a [[ to the pending wikilink queue
			openWikilinks[#openWikilinks+1] = Position
		else --Pair up the ]] to any available [[
			if #openWikilinks >= 1 then
				local start = table.remove(openWikilinks) --Pop the latest [[
				wikilinks[start] = {Start=start, End=Position+1, Type="Wikilink"} --Note the pair
			end
		end
	end
	
	--Step 2: Find the bounds of every valid template and variable ({{ and {{{)
	local scannerPosition = 1
	local templates = {}
	local variables = {}
	local openBrackets = {}
	while true do
		local Start, _, Character = string.find(InputText, "([{}])%1", scannerPosition)
		if not Start then --Done (both 9e9)
			break
		end
		local _, End = string.find(InputText, "^"..Character.."+", Start)

		scannerPosition = Start --Get to the {{ / }} set
		if Character == "{" then --Add the {{+ set to the queue
			openBrackets[#openBrackets+1] = {Start=Start, End=End}

		else --Pair up the }} to any available {{, accounting for {{{ / }}}
			local BracketCount = End-Start+1
			while BracketCount >= 2 and #openBrackets >= 1 do
				local OpenSet = table.remove(openBrackets)
				if boundlen(OpenSet) >= 3 and BracketCount >= 3 then --We have a {{{variable}}} (both sides have 3 spare)
					variables[OpenSet.End-2] = {Start=OpenSet.End-2, End=scannerPosition+2, Type="Variable"} --Done like this to ensure chronological order
					BracketCount = BracketCount - 3
					OpenSet.End = OpenSet.End - 3
					scannerPosition = scannerPosition + 3

				else --We have a {{template}} (both sides have 2 spare, but at least one side doesn't have 3 spare)
					templates[OpenSet.End-1] = {Start=OpenSet.End-1, End=scannerPosition+1, Type="Template"} --Done like this to ensure chronological order
					BracketCount = BracketCount - 2
					OpenSet.End = OpenSet.End - 2
					scannerPosition = scannerPosition + 2
				end

				if boundlen(OpenSet) >= 2 then --Still has enough data left, leave it in
					openBrackets[#openBrackets+1] = OpenSet
				end
			end
		end
		scannerPosition = End --Now move past the bracket set
	end
	
	--Step 3: Re-trace every object using their known bounds, collecting our parameters with (slight) ease
	local scannerPosition = 1
	local activeObjects = {}
	local finalObjects = {}
	while true do
		local LatestObject = activeObjects[#activeObjects] --Commonly needed object
		local NNC, _, Character --NNC = NextNotableCharacter
		if LatestObject then
			NNC, _, Character = string.find(InputText, "([{}%[%]|=])", scannerPosition)
		else
			NNC, _, Character = string.find(InputText, "([{}])", scannerPosition) --We are only after templates right now
		end
		if not NNC then
			break
		end
		if NNC > scannerPosition and LatestObject then
			local scannedContent = string.sub(InputText, scannerPosition, NNC-1)
			LatestObject:AppendText(scannedContent, finalise(scannedContent))
		end

		scannerPosition = NNC+1
		if Character == "{" or Character == "[" then
			local Container = templates[NNC] or variables[NNC] or wikilinks[NNC]
			if Container then
				CreateContainerObj(Container)
				if Container.Type == "Template" then
					Container:AppendText("{{")
					scannerPosition = NNC+2
				elseif Container.Type == "Variable" then
					Container:AppendText("{{{")
					scannerPosition = NNC+3
				else --Wikilink
					Container:AppendText("[[")
					scannerPosition = NNC+2
				end
				if LatestObject and Container.Type == "Template" then --Only templates count as children
					LatestObject.Children[#LatestObject.Children+1] = Container
				end
				activeObjects[#activeObjects+1] = Container
			elseif LatestObject then
				LatestObject:AppendText(Character)
			end

		elseif Character == "}" or Character == "]" then
			if LatestObject then
				LatestObject:AppendText(Character)
				if LatestObject.End == NNC then
					if LatestObject.Type == "Template" then
						LatestObject:Clean(true)
						finalObjects[#finalObjects+1] = LatestObject
					else
						LatestObject:Clean(false)
					end
					activeObjects[#activeObjects] = nil
					local NewLatest = activeObjects[#activeObjects]
					if NewLatest then
						NewLatest:AppendText(LatestObject.Text) --Append to new latest
					end
				end
			end

		else --| or =
			if LatestObject then
				LatestObject:HandleArgInput(Character)
			end
		end
	end
	
	--Step 4: Fix the order
	local FixedOrder = {}
	local SortableReference = {}
	for _,Object in next,finalObjects do
		SortableReference[#SortableReference+1] = Object.Start
	end
	table.sort(SortableReference)
	for i = 1,#SortableReference do
		local start = SortableReference[i]
		for n,Object in next,finalObjects do
			if Object.Start == start then
				finalObjects[n] = nil
				Object.Start = nil --Final cleanup
				Object.End = nil
				Object.Type = nil
				FixedOrder[#FixedOrder+1] = Object
				break
			end
		end
	end
	
	--Finished, return
	return FixedOrder
end

local p = {}
--Main entry points
p.PrepareText = PrepareText
p.ParseTemplates = ParseTemplates
--Extra entry points, not really required
p.TestForNowikiTag = TestForNowikiTag
p.TestForComment = TestForComment

return p

--[==[ console tests

local s = [=[Hey!{{Text|<nowiki | ||>
Hey! }}
A</nowiki>|<!--AAAAA|AAA-->Should see|Shouldn't see}}]=]
local out = p.PrepareText(s)
mw.logObject(out)

local s = [=[B<!--
Hey!
-->A]=]
local out = p.TestForComment(s, 2)
mw.logObject(out); mw.log(string.sub(s, 2, out.Length))

local a = p.ParseTemplates([=[
{{User:Aidan9382/templates/dummy
|A|B|C {{{A|B}}} { } } {
|<nowiki>D</nowiki>
|<pre>E
|F</pre>
|G|=|a=|A  =  [[{{PAGENAME}}|A=B]]{{Text|1==<nowiki>}}</nowiki>}}|A B=Success}}
]=])
mw.logObject(a)

]==]
