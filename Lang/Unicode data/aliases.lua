-- [[:wikimediacommons:Data:Unicode/data/aliases.tab]]

local function get_result()
	local data=mw.ext.data.get("Unicode/data/aliases.tab")
	local result = {}
	
	for index, cols in ipairs(data.data) do
		if cols[1] and cols[2] and cols[3] and cols[4] then
			code_point=tonumber("0x"..cols[1])
			
			if cols[2] == 1 then
				result[code_point]={}
			end
			result[code_point][cols[2]]={cols[4], cols[3]}
		end
	end
	
	return result
end

return get_result()
