-- ATTENTION !
-- This version of Excerpt is designed specifically for the portal namespace and its associated templates
-- Prefer Module:Excerpt whenever possible

-- Name of the category to track content pages with errors
local errorCategory = "Bài viết có đoạn trích bị hỏng"

-- Error messages
local errorMessages = {
	prefix = "Lỗi trích xuất: ",
	noPage = "Không có trang nào được đưa ra",
	pageNotFound = "Không tìm thấy trang '%s'",
	leadEmpty = " dẫn trống",
	sectionEmpty = "Mục '%s' trống",
	sectionNotFound = " tìm thấy mục '%s'",
	fragmentEmpty = "Đoạn '%s' trống",
	fragmentNotFound = "Không tìm thấy đoạn '%s'"
}

-- Regular expressions to match all aliases of the file namespace
local fileNamespaces = {
	"[Ff]ile",
	"[Ii]mage"
}

-- Regular expressions to match all image parameters
local imageParams = {
	{"thumb", "thumbnail", "frame", "framed", "frameless"},
	{"right", "left", "center", "none"},
	{"baseline", "middle", "sub", "super", "text-top", "text-bottom", "top", "bottom"}
}

-- Regular expressions to match all infobox parameters for image captions
local captionParams = {
	"[^=|]*[Cc]aption[^=|]*",
	"[^=|]*[Ll]egend[^=|]*"
}

-- List of file types that are allowed to be transcluded
local fileTypes = {"[Gg][Ii][Ff]", "[Jj][Pp][Ee]?[Gg]", "[Pp][Nn][Gg]", "[Ss][Vv][Gg]", "[Tt][Ii][Ff][Ff]", "[Xx][Cc][Ff]"}

-- Regular expressions to match all inline templates that are undesirable in excerpts
local unwantedInlineTemplates = {
	"[Ee]fn", "[Ee]fn%-[lu][arg]", "[Ee]fn [%a ]-", "[Ee]l[mn]", "[Rr]p?", "[Ss]fn[bmp]", "[Ss]f[bn]", "[Nn]ote[Tt]ag", "#[Tt]ag:%s*[Rr]ef", "[Rr]efn?",
	"[CcDd]n", "[Cc]itation[%- _]needed", "[Dd]isambiguation needed", "[Ff]eatured article", "[Gg]ood article",
	"[Dd]ISPLAYTITLE", "[Ss]hort[ _]+description", "[Cc]itation", "[Cc]ite[%- _]+[%w_%s]-", "[Cc]oor[%w_%s]-",
	"[Uu]?n?[Rr]eliable source[%?%w_%s]-", "[Rr]s%??", "[Vv]c", "[Vv]erify credibility", "[Bb]y[ _]*[Ww]ho[m]*%??", "[Ww]ikisource[ -_]*multi", "[Ii]nflation[ _/-]*[Ff]n",
	"[Bb]iblesource",
	-- aliases for Clarification needed
	"[Cc]f[ny]", "[Cc]larification[ _]+inline", "[Cc]larification[%- _]*needed", "[Cc]larification", "[Cc]larify%-inline", "[Cc]larify%-?me",
	"[Cc]larify[ _]+inline", "[Cc]larify", "[Cc]LARIFY", "[Cc]onfusing%-inline", "[Cc]onfusing%-short", "[Ee]xplainme", "[Hh]uh[ _]*%??", "[Ww]hat%?",
	"[Ii]nline[ _]+[Uu]nclear", "[Ii]n[ _]+what[ _]+sense", "[Oo]bscure", "[Pp]lease[ _]+clarify", "[Uu]nclear[ _]+inline", "[Ww]hat's[ _]+this%?",
	"[Gg]eoQuelle", "[Nn]eed[s]+[%- _]+[Ii][Pp][Aa]", "[Ii]PA needed",
	-- aliases for Clarification needed lead
	"[Cc]itation needed %(?lea?de?%)?", "[Cc]nl", "[Ff]act %(?lea?de?%)?", "[Ll]ead citation needed", "[Nn]ot in body", "[Nn]ot verified in body",
	-- Primary source etc.
	"[Pp]s[ci]", "[Nn]psn", "[Nn]on%-primary[ _]+source[ _]+needed", "[Ss]elf%-published[%w_%s]-", "[Uu]ser%-generated[%w_%s]-",
	"[Pp]rimary source[%w_%s]-", "[Ss]econdary source[%w_%s]-", "[Tt]ertiary source[%w_%s]-", "[Tt]hird%-party[%w_%s]-",
	-- aliases for Disambiguation (page) and similar
	"[Bb]egriffsklärung", "[Dd][Aa][Bb]", "[Dd]big", "[%w_%s]-%f[%w][Dd]isam[%w_%s]-", "[Hh][Nn][Dd][Ii][Ss]",
	-- aliases for Failed verification
	"[Bb]adref", "[Ff]aile?[ds] ?[rv][%w_%s]-", "[Ff][Vv]", "[Nn][Ii]?[Cc][Gg]", "[Nn]ot ?in ?[crs][%w_%s]-", "[Nn]ot specifically in source",
	"[Vv]erification[%- _]failed",
	-- aliases for When
	"[Aa]s[ _]+of[ _]+when%??", "[Aa]s[ _%-]+of%??", "[Cc]larify date", "[Dd]ate[ _]*needed", "[Nn]eeds?[ _]+date", "[Rr]ecently", "[Ss]ince[ _]+when%??",
	"[Ww]HEN", "[Ww]hen%??",
	-- aliases for Update
	"[Nn]ot[ _]*up[ _]*to[ _]*date","[Oo]u?[Tt][Dd]","[Oo]ut[%- _]*o?f?[%- _]*dated?", "[Uu]pdate",  "[Uu]pdate[ _]+sect", "[Uu]pdate[ _]+Watch",
	-- aliases for Pronunciation needed
	"[Pp]ronunciation%??[%- _]*n?e?e?d?e?d?", "[Pp]ronounce", "[Rr]equested[%- _]*pronunciation", "[Rr]e?q?pron", "[Nn]eeds[%- _]*pronunciation",
	-- Chart, including Chart/start etc.
	"[Cc]hart", "[Cc]hart/[%w_%s]-",
	-- Cref and others
	"[Cc]ref2?", "[Cc]note",
	-- Explain and others
	"[Ee]xplain", "[Ff]urther[ ]*explanation[ ]*needed", "[Ee]laboration[ ]*needed", "[Ee]xplanation[ ]*needed",
	-- TOC templates
	"[Cc][Oo][Mm][Pp][Aa][Cc][Tt][ _]*[Tt][Oo][Cc][8]*[5]*", "[Tt][Oo][Cc]", "09[Aa][Zz]", "[Tt][Oo][Cc][ ]*[Cc][Oo][Mm][Pp][Aa][Cc][Tt]", "[Tt][Oo][Cc][ ]*[Ss][Mm][Aa][Ll][Ll]", "[Cc][Oo][Mm][Pp][Aa][Cc][Tt][ _]*[Aa][Ll][Pp][Hh][Aa][Bb][Ee][Tt][Ii][Cc][ _]*[Tt][Oo][Cc]",
	"DEFAULTSORT:.-",
	"[Oo]ne[ _]+source",
	"[Cc]ontains[ _]+special[ _]+characters",
	"[Ii]nfobox[ _]+[Cc]hinese"
}

-- Regular expressions to match all block templates that are desirable in excerpts
local wantedBlockTemplates = {
	"[Bb]asketball[ _]roster[ _]header",
	"[Cc]abinet[ _]table[^|}]*",
	"[Cc]hart[^|}]*",
	"[Cc]lear",
	"[Cc]ol[^|}]*", -- all column templates
	"COVID-19[ _]pandemic[ _]data[^|}]*",
	"[Cc]ycling[ _]squad[^|}]*",
	"[Dd]ynamic[ _]list",
	"[Ee]lection[ _]box[^|}]*",
	"[Gg]allery",
	"[Gg]raph[^|}]*",
	"[Hh]idden",
	"[Hh]istorical[ _]populations",
	"[Ll]egend[ _]inline",
	"[Pp]lainlist",
	"[Pp]layer[^|}]*",
	"[Ss]eries[ _]overview",
	"[Ss]ide[ _]box",
	"[Ss]witcher",
	"[Tt]ree[ _]chart[^|}]*",
	"[Tt]elevision[ _]ratings[ _]graph"
}

local yesno = require('Module:Yesno')
local p = {}

-- Helper function to test for truthy and falsy values
local function is(value)
	if not value or value == "" or value == "0" or value == "false" or value == "no" then
		return false
	end
	return true
end

-- Error handling function
-- Throws a Lua error or returns an empty string if error reporting is disabled
local errors = true -- show errors by default
local function luaError(message, value)
	if not is(errors) then return '' end -- error reporting is disabled
	message = errorMessages[message] or message or ''
	message = mw.ustring.format(message, value)
	error(message, 2)
end

-- Error handling function
-- Returns a wiki friendly error or an empty string if error reporting is disabled
local function wikiError(message, value)
	if not is(errors) then return '' end -- error reporting is disabled
	message = errorMessages[message] or message or ''
	message = mw.ustring.format(message, value)
	message = errorMessages.prefix .. message
	if mw.title.getCurrentTitle().isContentPage then
		local errorCategory = mw.title.new(errorCategory, 'Category')
		if errorCategory then message = message .. '[[' .. errorCategory.prefixedText .. ']]' end
	end
	message = mw.html.create('div'):addClass('error'):wikitext(message)
	return message
end

-- Helper function to match from a list regular expressions
-- Like so: match pre..list[1]..post or pre..list[2]..post or ...
local function matchAny(text, pre, list, post, init)
	local match = {}
	for i = 1, #list do
		match = { mw.ustring.match(text, pre .. list[i] .. post, init) }
		if match[1] then return unpack(match) end
	end
	return nil
end

-- Helper function to convert imagemaps into standard images
local function convertImageMap(imagemap)
	local image = matchAny(imagemap, "[>\n]%s*", fileNamespaces, "[^\n]*")
	if image then
		return "<!--imagemap-->[[" .. mw.ustring.gsub(image, "[>\n]%s*", "", 1) .. "]]"
	else
		return "" -- remove entire block if image can't be extracted
	end
end

-- Helper function to convert a comma-separated list of numbers or min-max ranges into a list of booleans
-- For example: "1,3-5" to {1=true,2=false,3=true,4=true,5=true}
local function numberFlags(str)
	if not str then return {} end
	local flags = {}
	local ranges = mw.text.split(str, ",") -- parse ranges: "1,3-5" to {"1","3-5"}
	for _, r in pairs(ranges) do
		local min, max = mw.ustring.match(r, "^%s*(%d+)%s*[-–—]%s*(%d+)%s*$") -- "3-5" to min=3 max=5
		if not max then	min, max = mw.ustring.match(r, "^%s*((%d+))%s*$") end -- "1" to min=1 max=1
		if max then
			for p = min, max do flags[p] = true end
		end
	end
	return flags
end

-- Helper function to convert template arguments into an array of arguments fit for get()
local function parseArgs(frame)
	local args = {}
	for key, value in pairs(frame:getParent().args) do args[key] = value end
	for key, value in pairs(frame.args) do args[key] = value end -- args from a Lua call have priority over parent args from template
	args.paraflags = numberFlags(args["paragraphs"] or "") -- parse paragraphs: "1,3-5" to {"1","3-5"}
	args.fileflags = numberFlags(args["files"] or "") -- parse file numbers
	return args
end

-- simulate {{Airreg}} without the footnote, given "N|485US|," or similar
local function airreg(p)
	local s = mw.text.split(p, "%s*|%s*")
	if s[1] ~= "N" and s[1] ~= "HL" and s[1] ~= "JA" then s[1]=s[1] .. "-" end
	return table.concat(s, "")
end

-- Helper function to remove unwanted templates and pseudo-templates such as #tag:ref and DEFAULTSORT
local function stripTemplate(t)
	-- If template is unwanted then return "" (gsub will replace by nothing), else return nil (gsub will keep existing string)
	if matchAny(t, "^{{%s*", unwantedInlineTemplates, "%s*%f[|}]") then return "" end

	-- If template is wanted but produces an unwanted reference then return the string with |Note=, |ref or |shortref removed
	local noRef = mw.ustring.gsub(t, "|%s*Note%s*=.-%f[|}]", "")
	noRef = mw.ustring.gsub(noRef, "|%s*ref%s*%f[|}]", "")
	noRef = mw.ustring.gsub(noRef, "|%s*shortref%s*%f[|}]", "")

	-- If a wanted template has unwanted nested templates, purge them too
	noRef = mw.ustring.sub(noRef, 1, 2) .. mw.ustring.gsub(mw.ustring.sub(noRef, 3), "%b{}", stripTemplate)

	-- Replace {{audio}} by its text parameter: {{Audio|Foo.ogg|Bar}} → Bar
	noRef = mw.ustring.gsub(noRef, "^{{%s*[Aa]udio.-|.-|(.-)%f[|}].*", "%1")

	-- Replace {{Nihongo foot}} by its text parameter: {{Nihongo foot|English|英語|eigo}} → English
	noRef = mw.ustring.gsub(noRef, "^{{%s*[Nn]ihongo[ _]+foot%s*|(.-)%f[|}].*", "%1")

	-- Replace {{Airreg}} by its text parameter: {{Airreg|N|485US|,}} → N485US,
	noRef = mw.ustring.gsub(noRef, "^{{%s*[Aa]irreg%s*|%s*(.-)}}", airreg)

	if noRef ~= t then return noRef end

	return nil -- not an unwanted template: keep
end

-- Get a page's content, following redirects
-- Also returns the page name, or the target page name if a redirect was followed, or false if no page found
-- For file pages, returns the content of the file description page
local function getContent(page)
	local title = mw.title.new(page)
	if not title then return false, false end

	local target = title.redirectTarget
	if target then title = target end

	return title:getContent(), title.prefixedText
end

-- Get the tables only
local function getTables(text, options)
	local tables = {}
	for candidate in mw.ustring.gmatch(text, "%b{}") do
		if mw.ustring.sub(candidate, 1, 2) == '{|' then
			table.insert(tables, candidate)
		end
	end
	return table.concat(tables, '\n')
end

-- Get the lists only
local function getLists(text, options)
	local lists = {}
	for list in mw.ustring.gmatch(text, "\n[*#][^\n]+") do
		table.insert(lists, list)
	end
	return table.concat(lists, '\n')
end

-- Check image for suitability
local function checkImage(image)
	if type(image) == "table" then
		--Infobox image. Pass in a quick string equivilant of the image, since we should still check it for things like non-free files
		return checkImage("[[File:"..image.file.."]]")
	end
	local page = matchAny(image, "", fileNamespaces, "%s*:[^|%]]*") -- match File:(name) or Image:(name)
	if not page then return false end

	-- Limit to image types: .gif, .jpg, .jpeg, .png, .svg, .tiff, .xcf (exclude .ogg, audio, etc.)
	if not matchAny(page, "%.", fileTypes, "%s*$") then return false end

	-- Check the local wiki
	local fileDescription, fileTitle = getContent(page) -- get file description and title after following any redirect
	if not fileTitle or fileTitle == "" then return false end -- the image doesn't exist

	-- Check Commons
	if not fileDescription or fileDescription == "" then
		local frame = mw.getCurrentFrame()
		fileDescription = frame:preprocess("{{" .. fileTitle .. "}}")
	end

	-- Filter non-free images
	if not fileDescription or fileDescription == "" or mw.ustring.match(fileDescription, "[Nn]on%-free") then return false end

	return true
end

-- Attempt to parse [[File:...]] or [[Image:...]], either anywhere (start=false) or at the start only (start=true)
local function parseImage(text, start)
	local startre = ""
	if start then startre = "^" end -- a true flag restricts search to start of string
	local image = matchAny(text, startre .. "%[%[%s*", fileNamespaces, "%s*:.*") -- [[File: or [[Image: ...
	if image then
		image = mw.ustring.match(image, "%b[]%s*") -- matching [[...]] to handle wikilinks nested in caption
	end
	return image
end

-- Returns the file name and the arg data of the file if it exists
local function extractFileData(str,notmultiline)
	local reg = "^%[?%[?%a-:([^{|]+)(.-)%]?%]?$"
	local name,args,_ = mw.ustring.match(str,reg)
	if name then
		return name,args
	else
		return str,"" --Default fallback
	end
end

-- Helper function to escape a string for use in regexes (from Module:Transcluder)
local function escapeString(str)
	return string.gsub(str, '[%^%$%(%)%.%[%]%*%+%-%?%%]', '%%%0')
end

-- Extracts the parameters from a template into a table
-- Modified version of Module:Transcluder's getParameters, designed to help respect the original order
local function getParameters(text, flags)
	local parameters = {}
	local paramOrder, paramCount = {}, 1
	local params, count, parts, key, value
	for template in string.gmatch(text, '{%b{}}') do
		params = string.match(template, '{{[^|}]-|(.+)}}')
		if params then
			count = 0
			-- Temporarily replace pipes in subtemplates, tables and links to avoid chaos
			for subtemplate in string.gmatch(params, '%b{}') do
				params = string.gsub(params, escapeString(subtemplate), string.gsub(string.gsub(subtemplate, '%%', '%%%%'), '|', '@@@') )
			end
			for link in string.gmatch(params, '%b[]') do
				params = string.gsub(params, escapeString( mw.ustring.gsub(link, '%%', '%%%%') ), string.gsub(link, '|', '@@@') )
			end
			for parameter in mw.text.gsplit(params, '|') do
				parts = mw.text.split(parameter, '=')
				key = mw.text.trim(parts[1])
				value = table.concat(parts, '=', 2)
				if value == '' then
					value = key
					count = count + 1
					key = count
				else
					value = mw.text.trim(value)
				end
				value = string.gsub(value, '@@@', '|')
				parameters[key] = value
				paramOrder[paramCount] = key
				paramCount = paramCount + 1
			end
		end
	end
	return parameters, paramOrder
end

-- Turns an infobox file table into a [[File:...]]
local function stringifytemplateImage(image,allowFancy)
	--Certain positional elements may need to apply to the containing infobox, and not the file itself, so we should check that here
	if is(image.caption) and allowFancy then --Will be displayed like an infobox
		--Do not allow positioning the internal image. Instead, apply any positions we care about to the container
		local args,replacecount = string.gsub(image.args,"|left","") --We care if its formatted to the left, so track this
		args = mw.ustring.gsub(args,"|right","")
		args = mw.ustring.gsub(args,"|center","")
		local isleft = (replacecount > 0 and "y") or ""
		
		return mw.getCurrentFrame():expandTemplate({
			title="Infobox file display",
			args={image.file..args,image.caption,left=isleft}
		}) .. "\n"
	else
		local captionText = (is(image.caption) and "|"..image.caption) or ""
		return "[[File:"..image.file..captionText..image.args.."|thumb]]\n"
	end
end
-- Attempt to construct a [[File:...]] block from {{infobox ... |image= ...}}
local function templateImages(text)
	local hasNamedArgs = mw.ustring.find(text, "|") and mw.ustring.find(text, "=")
	if not hasNamedArgs then return nil end -- filter out any template that obviously doesn't contain an image

	-- ensure image map is captured, while removing anything beyond it
	text = mw.ustring.gsub(text, '<!%-%-imagemap%-%->(%[%b[]%])[^|]+', '|imagemap=%1')

	-- filter through parameters for image related ones
	local images = {}
	local parameters, parameterOrder = getParameters(text)
	
	--Search all template parameters for file-like objects
	local positionalImages = {}
	local position = 1
	for _,key in ipairs(parameterOrder) do
		position = position + 1 --Cant rely on ipairs due to potentially weird manipulation later
		local value = parameters[key]
		if is(value) then --Ensure its not empty
			if string.sub(value,1,2) == "{{" and string.sub(value,-2,-1) == "}}" then --Template in a template
				--Extract files from the template and insert files if any appear
				local internalImages = templateImages(value) or {}
				local initialPosition = position
				for index,image in ipairs(internalImages) do
					positionalImages[initialPosition+index] = image --Still positional, technically
					position = position + 1 --Advance our own counter to avoid overlap
				end
			else
				if matchAny(key, "", captionParams, "%s*") then
					--Caption-like parameter name, try to associate it with an image
					local scanPosition = position
					while scanPosition > 0 do
						scanPosition = scanPosition - 1
						local image = positionalImages[scanPosition]
						if image and image.caption == "" then
							image.caption = mw.getCurrentFrame():preprocess(value) --Assign caption to most recently defined image
							break
						end
					end
				
				elseif matchAny(value, "%.", fileTypes, "%s*$") then
					--File-like value, assume its an image
					local filename,fileargs = extractFileData(value)
					positionalImages[position] = {file=filename,caption="",args=fileargs}
				
				elseif mw.ustring.match(key, "[Ii][Mm][Aa][Gg][Ee]") or mw.ustring.match(key, "[Pp][Hh][Oo][Tt][Oo]") or mw.ustring.match(key, "[Ss][Yy][Mm][Bb][Oo][Ll]") then
					--File-like parameter name, assume its an image after some scrutinization
					local keyLower = string.lower(key)
					if string.find(keyLower,"caption")
					 or string.find(keyLower,"size") or string.find(keyLower,"width")
					 or string.find(keyLower,"upright")
					 or string.find(keyLower,"alt") then --Argument is defining image settings, not an image
						--Do nothing for now
						--TODO: we really should extract some of this for later use
					else
						local filename,fileargs = extractFileData(value)
						positionalImages[position] = {file=filename,caption="",args=fileargs}
					end
				end
			end --End of "Is template in template" check
		end --End of "is(value)" check
	end
	
	--Append entries from positionalImages into the main images table
	for i = 1,position do
		local value = positionalImages[i]
		if value then
			table.insert(images,value)
		end
	end

	return images
end

local function modifyImage(image, fileArgs)
	if type(image) == "table" then
		--Pass in a dummy string version and use that to handle modification
		local newversion = modifyImage("[[File:"..image.file..string.gsub(image.args,"{{!}}","|").."]]",fileArgs)
		--Since we know the format is strictly controlled, we can do a lazy sub grab for the args
		image.args = string.sub(newversion,8+#image.file,-3)
		return image
	end
	if fileArgs then
		for _, filearg in pairs(mw.text.split(fileArgs, "|")) do -- handle fileArgs=left|border etc.
			local fa = mw.ustring.gsub(filearg, "=.*", "") -- "upright=0.75" → "upright"
			local group = {fa} -- group of "border" is ["border"]...
			for _, g in pairs(imageParams) do
				for _, a in pairs(g) do
					if fa == a then group = g end -- ...but group of "left" is ["right", "left", "center", "none"]
				end
			end
			for _, a in pairs(group) do
				image = mw.ustring.gsub(image, "|%s*" .. a .. "%f[%A]%s*=[^|%]]*", "") -- remove "|upright=0.75" etc.
				image = mw.ustring.gsub(image, "|%s*" .. a .. "%s*([|%]])", "%1") -- replace "|left|" by "|" etc.
			end
			image = mw.ustring.gsub(image, "([|%]])", "|" .. filearg .. "%1", 1) -- replace "|" by "|left|" etc.
		end
	end
	image = mw.ustring.gsub(image, "(|%s*%d*x?%d+%s*px%s*.-)|%s*%d*x?%d+%s*px%s*([|%]])", "%1%2") -- double px args
	return image
end

-- a basic parser to trim down extracted w