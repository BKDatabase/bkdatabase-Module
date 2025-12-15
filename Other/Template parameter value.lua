local p = {}
local PrepareText = require("Module:Wikitext Parsing").PrepareText

local function getTitle(title)
	local success, titleObj = pcall(mw.title.new, title)
	if success then return titleObj
	else return nil end
end

-- Finds all templates in the given string, including nested templates
-- Templates are returned in position order, e.g. "<a<b>>" returns {"<a<b>>", "<b>"}
local function matchAllTemplates(str)
	local matchLayers = {{}}
	local unfinished = {}
	local position = 1
	local lastClosedLayer = 1
	while true do
		local nextOpen = string.find(str, "{{", position, true)
		local nextClose = string.find(str, "}}", position, true)

		if nextOpen and (not nextClose or nextOpen < nextClose) then
			unfinished[#unfinished+1] = nextOpen
			if not matchLayers[#unfinished] then
				matchLayers[#unfinished] = {}
			end
			position = nextOpen + 2

		elseif nextClose then
			local lenLayers = #unfinished
			if lenLayers > 0 then
				local matches = matchLayers[lenLayers]
				matches[#matches+1] = string.sub(str, unfinished[lenLayers], nextClose + 1)
				unfinished[lenLayers] = nil
				-- Ensure templates are ordered by their starting position, not their ending position
				if lenLayers < lastClosedLayer then
					local children = matchLayers[lenLayers+1]
					for i = 1, #children do
						matches[#matches+1] = children[i]
						children[i] = nil
					end
				end
				lastClosedLayer = lenLayers
			end
			position = nextClose + 2

		else
			break
		end
	end

	-- Check for any uncaught matches caused by bad input strings
	for i = #matchLayers, 2, -1 do
		local cur, parent = matchLayers[i], matchLayers[i-1]
		for i = 1, #cur do
			parent[#parent+1] = cur[i]
		end
	end
	return matchLayers[1]
end

--Forked version of getParameters from [[Module:Transcluder]] with extra features removed
local function escapeString(str)
	return string.gsub(str, '[%^%$%(%)%.%[%]%*%+%-%?%%]', '%%%0')
end
local function getParameters(template)
	local parameters, parameterOrder = {}, {}
	local params = string.match(template, '{{[^|}]-|(.*)}}')
	if params then
		local count = 0
		-- Temporarily replace pipes in subtemplates and wikilinks to avoid chaos
		for subtemplate in string.gmatch(params, '{%b{}}') do
			params = string.gsub(params, escapeString(subtemplate), string.gsub(subtemplate, ".", {["%"]="%%", ["|"]="@@:@@", ["="]="@@_@@"}) )
		end
		for wikilink in string.gmatch(params, '%[%b[]%]') do
			params = string.gsub(params, escapeString(wikilink), string.gsub(wikilink, ".", {["%"]="%%", ["|"]="@@:@@", ["="]="@@_@@"}) )
		end
		for parameter in mw.text.gsplit(params, '|') do
			local parts = mw.text.split(parameter, '=')
			local key = mw.text.trim(parts[1])
			local value
			if #parts == 1 then
				value = key
				count = count + 1
				key = tostring(count)
			else
				value = mw.text.trim(table.concat(parts, '=', 2))
			end
			value = string.gsub(string.gsub(value, '@@:@@', '|'), '@@_@@', '=')
			key = string.gsub(string.gsub(key, '@@:@@', '|'), '@@_@@', '=')
			table.insert(parameterOrder, key)
			parameters[key] = value
		end
	end
	return parameters, parameterOrder
end

-- Returns a table containing parameters and a table with the order in which each of their values were found.
-- Since this considers all subtemplates, a single parameter is expected to have multiple values.
-- E.g. {{ABC|X={{DEF|X=Value|Y=Other value}}{{ABC|X=Yes}}|Y=P}}
-- Would return {X={"{{DEF|X=Value|Y=Other value}}", "Value", "Yes"}, Y={"Other value", "P"}}
local function getAllParameters(template, ignore_blank, only_subtemplates)
	local parameterTree = setmetatable({}, {
		__index = function(self,key)
			rawset(self,key,{})
			return rawget(self,key)
		end
	})
	local params, paramOrder = getParameters(template)
	for _,key in ipairs(paramOrder) do
		local value = params[key]
		if not ignore_blank or value ~= "" then
			if not only_subtemplates then
				table.insert(parameterTree[key], value) --Insert the initial value into the tree
			end
			for subtemplate in string.gmatch(value, "{%b{}}") do --And now check for subvalues
				local subparams = getAllParameters(subtemplate, ignore_blank)
				for subkey,subset in next,subparams do
					for _,subvalue in ipairs(subset) do
						table.insert(parameterTree[subkey], subvalue) --And add any we find to our tree
					end
				end
			end
		end
	end
	return parameterTree
end

--Module entry point. Returns a success boolean and either the target template or why it failed
function p.getTemplate(page, templates, options)
	if not templates then --Required parameters
		return false, "Missing required parameter 'templates'"
	end
	options = options or {}
	
	local template_index = tonumber(options.template_index) or 1
	local treat_as_regex = options.treat_as_regex or false
	if type(templates) == "string" then
		-- TODO: Find a good way to allow specifying multiple templates via template invocation
		-- (Modules can just provide a table so no concerns there)
		-- Comma splitting is a bad idea (lots of templates have a comma in their name)
		templates = {templates}
	end
	
	local title = getTitle(page)
	if title == nil then
		return false, "Requested title doesn't exist"
	end
	local content = PrepareText(title:getContent() or "")
	
	local sanitisedTemplates = {}
	for i,template in pairs(templates) do
		if not treat_as_regex then
			template = escapeString(template)
		end
		local firstLetter = string.sub(template, 1, 1)
		local firstUpper, firstLower = firstLetter:upper(), firstLetter:lower()
		if firstUpper ~= firstLower then
			template = "[" .. firstUpper .. firstLower .. "]" .. string.sub(template, 2)
		end
		sanitisedTemplates[i] = template
	end
	
	local foundTemplates = 0
	local foundTemplate
	for _,template in next,matchAllTemplates(content) do
		for _,wantedTemplate in pairs(sanitisedTemplates) do
			if string.match(template, "^{{%s*"..wantedTemplate.."%s*[|}]") then
				foundTemplate = template
				foundTemplates = foundTemplates + 1
				if foundTemplates == template_index then --Found our wanted template
					return true, foundTemplate
				end
			end
		end
	end
	if foundTemplates > 0 and template_index == -1 then
		return true, foundTemplate
	end
	return false, "No valid template found"
end

--Module entry point. Returns a success boolean and either the target parameter's value or why it failed
function p.getParameter(page, templates, parameter, options)
	if not (templates and parameter) then --Required parameters
		return false, "Missing required parameters 'templates' and 'parameter'"
	end
	parameter = tostring(parameter) --Force consistency
	options = options or {}
	
	local success, text = p.getTemplate(page, templates, options)
	if not success then
		return success, text
	else
		local parameter_index = tonumber(options.parameter_index) or 1
		local ignore_subtemplates = options.ignore_subtemplates or false
		local only_subtemplates = options.only_subtemplates or false
		local ignore_blank = options.ignore_blank or false

		local value
		if ignore_subtemplates then
			value = getParameters(text)[parameter] or ""
		else
			local params = getAllParameters(text, ignore_blank, only_subtemplates)
			value = params[parameter][parameter_index] or ""
		end

		value = string.gsub(value, "</?%a*include%a*>", "")
		value = mw.text.trim(value) --technically wrong in some cases but not a big issue
		return true, mw.text.decode(value) --decode due to PrepareText
	end
end

--Template entry point. Returns either "yes" or nothing depending on if the wanted template is found
--Will return error text if no template is provided
function p.hasTemplate(frame)
	local args = require('Module:Arguments').getArgs(frame)
	local yesno = require("Module:Yesno")
	local page = args[1] or args.page
	local template = args[2] or args.template
	local template_index = tonumber(args[3] or args.N) or 1
	if not template or template == "" then
		return '<span class="error">No template provided for hasTemplate</span>'
	end
	local follow = yesno(args.follow) or false
	if follow then
		page = require("Module:Redirect").luaMain(page)
	end
	local options = {
		template_index = template_index,
		treat_as_regex = yesno(args.treat_as_regex) or false,
	}

	local success, _ = p.getTemplate(page, template, options)
	return success and "yes" or ""
end

--Template entry point for getParameter. Returns an empty string upon failure
function p.main(frame)
	local args = require('Module:Arguments').getArgs(frame, {
		wrappers = 'Template:Template parameter value'
	})
	local yesno = require("Module:Yesno")
	local options = {
		template_index = args[3] or args.template_index,
		parameter_index = args[5] or args.parameter_index,
		ignore_subtemplates = yesno(args.ignore_subtemplates or args.ist) or false,
		only_subtemplates = yesno(args.only_subtemplates) or false,
		ignore_blank = yesno(args.ignore_blank) or false,
		treat_as_regex = yesno(args.treat_as_regex) or false,
	}
	local page = args[1] or args.page
	local template = args[2] or args.template
	local parameter = args[4] or args.parameter
	local success, result = p.getParameter(page, template, parameter, options)
	if not success then
		return ""
	else
		if args.dontprocess then
			return result
		else
			return frame:preprocess(result)
		end
	end
end

--Backwards compatability
p.getValue = p.getParameter
--Potentially useful module entry points
p.matchAllTemplates = matchAllTemplates
p.getParameters = getParameters
p.getAllParameters = getAllParameters

return p
