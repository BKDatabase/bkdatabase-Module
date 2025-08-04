-- [[:wikimediacommons:Data:Unicode/data/combining/singles.tab]]
-- [[:wikimediacommons:Data:Unicode/data/combining/ranges.tab]]

local function get_result()
	local write_index
	local result={}
	
	-- singles
	result.singles={}
	local data=mw.ext.data.get("Unicode/data/combining/singles.tab")
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2]  then
				result.singles[tonumber(cols[1], 16)]=cols[2]
		end
	end
	
	-- ranges
	data=mw.ext.data.get("Unicode/data/combining/ranges.tab")
	write_index=1
	result.ranges={}
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] and cols[3] then
				result.ranges[write_index]={tonumber(cols[1], 16), tonumber(cols[2], 16), cols[3]}
				write_index=write_index+1
		end
	end
	result.ranges.length = #result.ranges
	
	return result
end

return get_result()
