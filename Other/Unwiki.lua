local module = {}

local getArgs = require('Module:Arguments').getArgs

function _main(args)
	return mw.text.decode(mw.text.unstripNoWiki(args[1]))
end

function module.main(frame)
	local args = getArgs(frame)
	return _main(args)
end

return module