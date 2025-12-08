--- This module attempts to suppress the display of any error
-- @module pcall
-- @alias p
-- @release alpha

local p = {}

--- Does the call.
function doCall(modToCall, frame, template, pckg, fail, includeError)
	if template then
		local templateTitle = mw.title.new(modToCall, 10)

		local success, result = pcall(function() 
			return frame:expandTemplate(templateTitle.fullText, frame.args)
		end)
		if success then
			return result
		else
			if includeError then
				return result
			else
				return fail
			end
		end
	else
		if pckg == nil then error(mw.message.new("scribunto-common-nofunction"):plain()) end
		local callMod = require("Module:" .. modToCall) or error(mw.message.new("scribunto-common-nosuchmodule", 0, modToCall):plain())
		local toCall = callMod[pckg] or error(mw.message.new("scribunto-common-nosuchfunction", 0, pckg):plain())
		if type(toCall) ~= type(function() end) then error(mw.message.new("scribunto-common-notafunction", nil, pckg):plain()) end
		local success, result = pcall(toCall, frame)
		if success then
			return result
		else
			if includeError then
				return result
			else
				return fail
			end
		end
	end
end


--- Main function.
-- @param {table} frame Calling frame.
-- @return Wikitext output.
function main(modToCall, frame, template)
	local pckg = frame.args[1]
	local fail = frame.args["_fail"] or ''
	local includeError = frame.args["_error"]
	local newFrame = {}
	for k,v in pairs(frame) do
		newFrame[k] = newFrame[k] or {}
		if type(v) == 'table' then
			for l,w in pairs(v) do
				newFrame[k][l] = w
			end
		end
	end
	local topArg = 2
	for k,v in ipairs(newFrame.args) do
		if k - 1 >= 1 then
			newFrame.args[k - 1] = v
		end
		if k > topArg then
			topArg = k
		end
	end
	newFrame.args[topArg] = nil
	
	-- get rid of first underscore for arguments "__fail" and "__includeerror"
	for k,v in pairs(newFrame.args) do
		if type(k) ~= type(1) then
			if k:find("__fail") or k:find("__error") then
				newFrame.args[k:sub(-k:len() + 1)] = v
				newFrame.args[k] = nil
			end
		end
	end
	
	return doCall(modToCall, newFrame, template, pckg, fail, includeError)
end

setmetatable(p, {
	__index = function(t, index)
		local title = mw.title.new(index, 828)
		if title.namespace ~= 828 then
			return function(frame)
				return main(index, frame, true)
			end
		end
		return function(frame)
			return main(index, frame, false)
		end
	end
})

return p
