local p = {}
local getArgs = require('Module:Arguments').getArgs
local yesNo = require('Module:Yesno')

-- function to determine whether "sub" occurs in "s"
local function plainFind(s, sub)
	return mw.ustring.find(s, sub, 1, true)
end

-- function to count the number of times "pattern" (a regex) occurs in "s"
local function countMatches(s, pattern)
	local _, count = mw.ustring.gsub(s, pattern, '')
	return count
end

local singular = 1
local likelyPlural = 2
local plural = 3

-- Determine whether a string is singular or plural (i.e., it represents one
-- item or many)
-- Arguments:
--   origArgs[1]: string to process
--   origArgs.no_comma:  if false, use commas to detect plural (default false)
--   origArgs.parse_links: if false, treat wikilinks as opaque singular objects (default false)
--   origArgs.any_comma: if true, allow any comma to cause likely plural, including ones between digits (default false)
--   origArgs.no_and: if false, use existence of "and" to detect plural (default false)
--   origArgs.parse_number: if true, parse number in argument: if 1, singular; if >1, plural (default false)
-- Returns:
--   singular, likelyPlural, or plural (see constants above), or nil for completely unknown
function p._main(origArgs)
	origArgs = type(origArgs) == 'table' and origArgs or {}
	local args = {}
	-- canonicalize boolean arguments
	for key, default in pairs({no_comma=false,parse_links=false,any_comma=false,
                               no_and=false,parse_number=false}) do
		if origArgs[key] == nil then
			args[key] = default
		else
			args[key] = yesNo(origArgs[key],default)
		end
	end
	local checkComma = not args.no_comma
	local checkAnd = not args.no_and
	local rewriteLinks = not args.parse_links
	local anyComma = args.any_comma
    local parseNumber = args.parse_number
	local s = origArgs[1]  -- the input string
	if not s then
		return nil -- empty input returns nil
	end
	s = tostring(s)
	s = mw.text.decode(s,true)  --- replace HTML entities (to avoid spurious semicolons)
	if plainFind(s,'data-plural="0"') then -- magic data string to return true
		return singular
	end
	if plainFind(s,'data-plural="1"') then -- magic data string to return false
		return plural
	end
	-- count number of list items
	local numListItems = countMatches(s,'<%s*li')
	-- if exactly one, then singular, if more than one, then plural
	if numListItems == 1 then
		return singular
	end
	if numListItems > 1 then
		return plural
	end
	-- if "list of" occurs inside of wlink, then it's plural
	if mw.ustring.find(s:lower(), '%[%[[^%]]*list of[^%]]+%]%]') then
		return plural
	end
    if parseNumber then
        local m = tonumber(mw.ustring.match(s,"^%s*(%d+)"))
        if m then
            return m > 1 and plural or singular
        end
    end
	-- fix for trailing br tags passed through [[template:marriage]]
	s = mw.ustring.gsub(s, '<%s*br[^>]*>%s*(</div>)', '%1')
	-- replace all wikilinks with fixed string
	if rewriteLinks then
		s = mw.ustring.gsub(s,'%b[]','WIKILINK') 
	end
	-- Five conditions: any one of them can make the string a likely plural or plural
	local hasBreak = mw.ustring.find(s,'<%s*br')
	-- For the last 4, evaluate on string stripped of wikimarkup
    local getPlain = require('Module:Text').Text().getPlain
	s = getPlain(s)
	local hasBullets = countMatches(s,'%*+') > 1
	local multipleQids = mw.ustring.find(s,'Q%d+[%p%s]+Q%d+') -- has multiple QIDs in a row
	if hasBullets or multipleQids then
		return plural
	end
	local commaPattern = anyComma and '[,;]' or '%D[,;]%D'  -- semi-colon similar to comma
	local hasComma = checkComma and mw.ustring.find(s, commaPattern)
	local hasAnd = checkAnd and (mw.ustring.find(s,'[,%s]and%s') or mw.ustring.find(s,'&',1,true))
	if hasBreak or hasComma or hasAnd then
		return likelyPlural
	end
	return singular
end

function p._pluralize(args)
	args = type(args) == 'table' and args or {}
	local singularForm = args[3] or args.singular or ""
	local pluralForm = args[4] or args.plural or ""
	local likelyForm = args.likely or pluralForm
	local link = args[5] or args.link
	if link then
		link = tostring(link)
		singularForm = '[['..link..'|'..singularForm..']]'
		pluralForm = '[['..link..'|'..pluralForm..']]'
		likelyForm = '[['..link..'|'..likelyForm..']]'
	end
	if args[2] then
		return pluralForm
	end
	local detect = p._main(args)
	if detect == nil then
		return ""   -- return blank on complete failure
	end
	if detect == singular then
		return singularForm
	elseif detect == likelyPlural then
		return likelyForm
	else
		return pluralForm
	end
end

function p.main(frame)
	local args = getArgs(frame)
	-- For template, return 1 if singular, blank if plural or empty
	local result = p._main(args)
	if result == nil then
		return 1
	end
	return result == singular and 1 or ""
end

function p.pluralize(frame)
	local args = getArgs(frame)
	return p._pluralize(args)
end

return p
