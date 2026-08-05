require('strict')
local p = {}

function p._main(frame)
	local root = mw.html.create()
	local pad = '<span style="padding-left:0.5ic;">&nbsp;</span>'
	local result = '<span lang="zh-Bopo">'
	for k,v in pairs(frame) do
		if k > 1 then
			result = result .. pad
		end
		result = result .. v
	end
	result = result .. '</span>'
	return result
end

function p.main(frame)
	local getArgs = require('Module:Arguments').getArgs
	return p._main(getArgs(frame))
end

return p