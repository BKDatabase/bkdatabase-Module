-- [[:wikimediacommons:Data:Unicode/data/category/singles.tab]]
-- [[:wikimediacommons:Data:Unicode/data/category/ranges.tab]]
-- [[:wikimediacommons:Data:Unicode/data/category/names.tab]]

local function get_result()
	local write_index
	local result={}
	
	-- singles
	result.singles={}
	local data=mw.ext.data.get("Unicode/data/category/singles.tab")
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2]  then
			if cols[2] ~= "Cn" then
				result.singles[tonumber(cols[1], 16)]=cols[2]
			end
		end
	end
	
	-- ranges
	data=mw.ext.data.get("Unicode/data/category/ranges.tab")
	write_index=1
	result.ranges={}
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] and cols[3] then
			if cols[3] ~= "Cn" then
				result.ranges[write_index]={tonumber(cols[1], 16), tonumber(cols[2], 16), cols[3]}
				write_index=write_index+1
			end
		end
	end

	-- long_names
	data=mw.ext.data.get("Unicode/data/category/names.tab")
	result.long_names={}
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] then
			result.long_names[cols[1]]=cols[2]
		end
	end
	
	return result
end

return get_result()
