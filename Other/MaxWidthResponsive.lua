local p = {}

function p.main(frame)
	local result = ""
	local title =  mw.title.new(mw.text.trim(frame.args[1]), 6)
	
	if (title ~= nil and title.fileExists) then
		local image = title.file
		local w = image.width
		local h = image.height
		local maxWidth = 430 * (w / h)
	
		-- Nếu chiều cao > chiều rộng (w/h < 1) thì cung cấp max-width
		-- để max-height luôn đạt 430px
		if (w/h < 1) then
			result = "max-width: " .. maxWidth .. "px;"
		else
			result = "max-width: 430px;"
		end
	end
	
	return result
end

return p
