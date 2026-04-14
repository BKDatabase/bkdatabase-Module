local p = {}

function p.main(frame)
	local result = ""
	local title =  mw.title.new(mw.text.trim(frame.args[1]), 6)
	
	if (title ~= nil and title.fileExists) then
		local image = title.file
		local w = image.width
		local h = image.height
		local ratio = w/h
	
		-- Nếu tỷ lệ w/h > 2.5 hoặc < 0.5 thì báo lỗi
		if (ratio < 0.5 or ratio > 2.5) then
			local span = mw.html.create("span"):attr("class", "error"):wikitext("Hình ảnh chọn lọc phải có tỷ lệ chiều rộng/chiều cao từ 0.5 đến 2.5. Hình này đang có tỷ lệ là " .. math.floor(ratio * 100) / 100 .. " [= " .. w .. "/" .. h .. "].")
			result = tostring(span)
		end
	end
	
	return result
end

return p
