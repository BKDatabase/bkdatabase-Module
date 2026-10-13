local p = {}

function p.main(frame)
	-- Undo sanitization:
	local code = frame.args[1] or ''
	if code:match'nowiki' then
		code = mw.text.unstripNoWiki(code)
	else error("<nowiki> missing from first parameter") end
	
	-- Angle brackets still remain santiized; unsanitize them
	local wikitext = code:gsub('&lt;', '<'):gsub('&gt;', '>')
	
	local secondParam = frame.args[2]
    local start = tonumber(secondParam:match('%d+')) -- Extract the first number from the second parameter
    local result = ''
    
    assert(secondParam, "second parameter missing")
    
    local function replaceTripleBraces(parameter, _, default, i) -- extract corresponding arguments from the parent function. the _ is necessary because the pipe still gets caught in the second capture group
    	if _ == "" then default = nil end -- mildly ugly hack for checking for {{{parameter|}}}
		return frame:getParent().args[parameter:gsub("%d+", tostring(i))] or default or "{{{" .. parameter .. "}}}"
    end 
    
    for i = start, math.huge do
        -- Check if the parameter is defined
        if not frame:getParent().args[secondParam:gsub('%d+', tostring(i))] then 
        	break
        end

        local processed = wikitext:gsub("{{{([^{}<>|]+)(|?)([^{}|]*)}}}", function(a, b, c) return replaceTripleBraces(a, b, c, i) end) -- Find stuff of the form {{{parameter}}} or {{{parameter|default}}} via pattern matching
        result = result .. processed
    end
    
    return frame:preprocess(result)
end

return p
