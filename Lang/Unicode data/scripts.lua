-- [[:wikimediacommons:Data:Unicode/data/scripts/singles.tab]]
-- [[:wikimediacommons:Data:Unicode/data/scripts/ranges.tab]]
-- [[:wikimediacommons:Data:Unicode/data/scripts/aliases.tab]]

local function get_result()
	local write_index
	local result={}
	
	-- singles
	result.singles={}
	local data=mw.ext.data.get("Unicode/data/scripts/singles.tab")
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2]  then
				result.singles[tonumber(cols[1], 16)]=cols[2]
		end
	end
	
	-- ranges
	data=mw.ext.data.get("Unicode/data/scripts/ranges.tab")
	write_index=1
	result.ranges={}
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] and cols[3] then
				result.ranges[write_index]={tonumber(cols[1], 16), tonumber(cols[2], 16), cols[3]}
				write_index=write_index+1
		end
	end
	result.ranges.length = #result.ranges

	-- aliases
	data=mw.ext.data.get("Unicode/data/scripts/aliases.tab")
	result.aliases={}
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] then
			result.aliases[cols[1]]=string.gsub(cols[2], "_", " ")
		end
	end
	
	result.rtl = {}
	for _, script in ipairs(mw.loadData "Module:Lang/data".rtl_scripts) do
		-- [[Module:Lang/data]] has script codes in lowercase;
		-- this module has script codes with the first letter capitalized.
		result.rtl[script:gsub("^%a", string.upper)] = true
	end
	return result

end

return get_result()
