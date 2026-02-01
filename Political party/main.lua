local p = {}

local default_color = '&#35;F8F9FA'

local categories = {
	party_not_in_list = '[[Category:Pages using Political party with unknown party]]',
	shortname_not_in_list = '[[Category:Pages using Political party with missing shortname]]',
	color_not_in_list = '[[Category:Pages using Political party with missing color]]',
}

local function create_error(error_message)
	return string.format('<strong class="error">%s</strong>', error_message)
end

local function getFirstLetter(party)
	local index = mw.ustring.sub(party, 1, 1)
	-- Set index for non-A-Z starts
	if string.match(index, '%A') then
		return '1'
	end
	return string.upper(index)
end

local function stripToNil(text)
	-- If text is a string, return its trimmed content, or nil if empty.
	-- Otherwise return text (which may, for example, be nil).
	if type(text) == 'string' then
		text = text:match('(%S.-)%s*$')
		local delink = require('Module:Delink')._delink
		text = delink({text, wikilinks = "target"})
	end
	return text
end

-- Example of having all the data - color and names - in one table. Requires one page to be edited instead of two when adding a new party.
function p._fetch(args)
	if not args[1] then
		return create_error("parameter 1 should be a party name.")
	end

	if not args[2] then
		return create_error("parameter 2 should be the output type.")
	end

 	local party = stripToNil(args[1])
	local out_type = stripToNil(args[2])
	if out_type == 'colour' then
		out_type = 'color'
	end
	local index = getFirstLetter(party)
	
	-- Load data from submodule
	local data = mw.loadData('Module:Political party/' .. index)
	local data_all = data.full

	local party_alt = data.alternate[party]
	local party_info
	if party_alt then
		if data_all[party_alt] then
			party_info = data_all[party_alt]
		else
			index = getFirstLetter(party_alt)
			data = mw.loadData('Module:Political party/' .. index)
			party_info = data.full[party_alt]
		end
	else
		party_info = data_all[party]
	end

	-- Check if database value exists
	-- * Not even in database - return given error or input
	-- * No color - return error
	-- * No shortname/abbrev - return first non-blank of abbrev->shortname->input
	if not party_info then
		if out_type == 'color' then
			return args.error or default_color
		else
			return args.error or party
		end
	end
	local return_value = party_info[out_type]
	if return_value == "" then
		if out_type == 'color' then
			return args.error or create_error("Value not in template. Please request that it be added.")
		elseif out_type == 'abbrev' then
			if party_info.shortname ~= "" then
				return party_info.shortname
			else
				return party
			end
		elseif out_type == 'shortname' then
			if party_info.abbrev ~= "" then
				return party_info.abbrev 
			else
				return party
			end
		else
			return party
		end
	end

	if out_type == 'color' and string.find(return_value, '#') then
		return_value = string.gsub(return_value, '#', '&#35;')
	end
	return return_value	
end

function p.fetch(frame)
	-- Initialise and populate variables
	local getArgs = require("Module:Arguments").getArgs
	local args = getArgs(frame)
	
	return p._fetch(args)
end

return p
