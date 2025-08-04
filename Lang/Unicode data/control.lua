-- [[:wikimediacommons:Data:Unicode/data/category/ranges.tab]]
-- [[:wikimediacommons:Data:Unicode/data/category/singles.tab]]

local function get_result()
	local categories = {
		["Cc"] = "control",
		["Cf"] = "format",
		["Cs"] = "surrogate",
		["Co"] = "private-use",
		["Cn"] = "unassigned",
		["Zs"] = "space-separator",
		["Zl"] = "line-separator",
		["Zp"] = "paragraph-separator"
	}
	
	local result={}
	local write_index
	local category
	local first_char
	
	-- singles
	result.singles={}
	local data=mw.ext.data.get("Unicode/data/category/singles.tab")
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2]  then
			first_char=string.sub(cols[2], 1, 1)
			if first_char == "C" or first_char == "Z" then
				category=categories[cols[2]]
				if category then
					result.singles[tonumber(cols[1], 16)]=category
				end
			end
		end
	end
	
	-- ranges
	data=mw.ext.data.get("Unicode/data/category/ranges.tab")
	write_index=1
	result.ranges={}
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] and cols[3] then
			first_char=string.sub(cols[3], 1, 1)
			if first_char == "C" or first_char == "Z" then
				category=categories[cols[3]]
				if category then
					result.ranges[write_index]={tonumber(cols[1], 16), tonumber(cols[2], 16), category}
					write_index=write_index+1
				end
			end
		end
	end
	result.ranges.length = #result.ranges
	
	return result
end

return get_result()
