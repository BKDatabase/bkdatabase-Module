-- [[:wikimediacommons:Data:Unicode/data/blocks.tab]]

local function get_result()
	local data=mw.ext.data.get("Unicode/data/blocks.tab")
	local result={}
	local write_index=1

	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] and cols[3] then
			result[write_index]={tonumber(cols[1], 16), tonumber(cols[2], 16), cols[3]}
			write_index=write_index+1
		end
	end
	result.length = #result

	return result
end

return get_result()
