require('strict')
local p = {}

function p.main(frame)
	local parent = frame:getParent()
	if parent and parent:getTitle():gsub('/sandbox$', '') == 'Template:Call wikitext' then
		-- Treat the "Template:Call wikitext" frame as the current frame
		frame = parent
	end

	local code = frame.args['sourceCode'] or error("sourceCode arg not provided")

	if frame.args['unstripSourceCode'] == nil or require('Module:Yesno')(frame.args['unstripSourceCode']) then
		code = mw.text.unstripNoWiki(code) -- Undo nowiki sanitization
		code = code:gsub("&lt;", "<"):gsub("&gt;", ">") -- Unsanitize < and >
	end

	-- Remove sourceCode and unstripSourceCode from the arguments
	local newArgs = {}
	for k, v in pairs(frame.args) do
		if k ~= 'sourceCode' and k ~= 'unstripSourceCode' then
			newArgs[k] = v
		end
	end

	-- Create a new frame without "sourceCode" and "unstripSourceCode"
	local newFrame = frame:newChild{
		title = "Called wikitext",
		args = newArgs
	}

    return newFrame:preprocess(code)
end

return p
