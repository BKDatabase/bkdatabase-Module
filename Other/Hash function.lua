require("strict")

local p = {}

function p.main(frame)
	local algo = frame.args['algo'] or frame.args[1]
	local value = frame.args['value'] or frame.args[2]
	return mw.hash.hashValue( algo, value )
end

function p.list()
	local list = {}
	for i, v in ipairs(mw.hash.listAlgorithms()) do
		list[i] = "<code>" .. v .. "</code>"
	end
	
	return table.concat(list, ",\n")
end

return p