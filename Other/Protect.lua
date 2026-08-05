local function processResult(options, success, ...)
	if not success then
		local message = tostring(... or '(không có tin nhắn)')
		if options.removeLocation then
			message = string.gsub(message, '^Mô đun:[^:]+:%d+: ', '', 1)
		end
		return string.format(options.errFormat, message)
	end
	return ...
end

local function protect(func, errFormat, options)
	if type(errFormat) == 'table' then
		options = options or errFormat
		errFormat = nil
	end
	options = mw.clone(options) or {}
	options.errFormat = errFormat or options.errFormat or 'Lỗi: %s'
	if not options.raw then
		options.errFormat = '<strong class="error">' .. options.errFormat .. '</strong>'
	end
	options.removeLocation = options.removeLocation == nil or options.removeLocation
	
	return function (...)
		return processResult(options, pcall(func, ...))
	end
end

return protect