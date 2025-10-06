local export = {}

local unpack = unpack or table.unpack -- Lua 5.2 compatibility

function export.dataset(dataset_name)
	local dataset = mw.ext.data.get(dataset_name)
	
	if not dataset then return nil end
	local data = dataset.data
	local result = {}
	
	for _, item in ipairs(data) do
		local charcode_hex, filename = unpack(item)
		result[tonumber(charcode_hex)] = filename
	end
	
	return result
end

return export
