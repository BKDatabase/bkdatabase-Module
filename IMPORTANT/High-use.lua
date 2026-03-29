local p = {}

-- _fetch looks at the "demo" argument.
local _fetch = require('Mô đun:Transclusion_count').fetch
local yesno = require('Mô đun:Yesno')

function p.num(frame, count)
	if count == nil then
		if yesno(frame.args['fetch']) == false then
			if (frame.args[1] or '') ~= '' then count = tonumber(frame.args[1]) end
		else
			count = _fetch(frame)
		end
	end
	
	-- Build output string
	local return_value = ""
	if count == nil then
		if frame.args[1] == "risk" then
			return_value = "một số lượng lớn"
		else
			return_value = "rất nhiều"
		end
	else
		-- Use 2 significant figures for smaller numbers and 3 for larger ones
		local sigfig = 2
		if count >= 100000 then
			sigfig = 3
		end
		
		-- Prepare to round to appropriate number of sigfigs
		local f = math.floor(math.log10(count)) - sigfig + 1
		
		-- Round and insert "approximately" or "+" when appropriate
		if (frame.args[2] == "yes") or (mw.ustring.sub(frame.args[1],-1) == "+") then
			-- Round down
			return_value = string.format("%s+", mw.getContentLanguage():formatNum(math.floor( (count / 10^(f)) ) * (10^(f))) )
		else
			-- Round to nearest
			return_value = string.format("khoảng&#x20;%s", mw.getContentLanguage():formatNum(math.floor( (count / 10^(f)) + 0.5) * (10^(f))) )
		end

		-- Insert percentage of pages if that is likely to be >= 1% and when |no-percent= not set to yes
		if count and count > 250000 and not yesno (frame:getParent().args['no-percent']) then
			local percent = math.floor( ( (count/frame:callParserFunction('NUMBEROFPAGES', 'R') ) * 100) + 0.5)
			if percent >= 1 then
				return_value = string.format("%s&#x20;trang, chiếm ≈&nbsp;%s%% tổng số", return_value, percent)
			end
		end	
	end
	
	return return_value
end

-- Actions if there is a large (greater than or equal to 100,000) transclusion count
function p.risk(frame)
	local return_value = ""
	if frame.args[1] == "risk" then
		return_value = "risk"
	else
		local count = _fetch(frame)
		if count and count >= 100000 then return_value = "risk" end
	end
	return return_value
end

function p.text(frame, count)
	-- Only show the information about how this template gets updated if someone
	-- is actually editing the page and maybe trying to update the count.
	local bot_text = (frame:preprocess("{{REVISIONID}}") == "") and "\n\n----\n'''Thông báo xem trước''': Số lượt nhúng được cập nhật định kì ([[Bản mẫu:High-risk/doc#Chi tiết kĩ thuật|xem tài liệu]])." or ''
	
	if count == nil then
		if yesno(frame.args['fetch']) == false then
			if (frame.args[1] or '') ~= '' then count = tonumber(frame.args[1]) end
		else
			count = _fetch(frame)
		end
	end
	local title = mw.title.getCurrentTitle()
	if title.subpageText == "doc" or title.subpageText == "sandbox" then
		title = title.basePageTitle
	end
	
	local systemMessages = frame.args['system']
	if frame.args['system'] == '' then
		systemMessages = nil
	end
	
	-- This retrieves the project URL automatically to simplify localiation.
	local templateCount = ('ở rất nhiều trang'):format(
		mw.title.getCurrentTitle():fullUrl():gsub('//(.-)/.*', '%1'),
		mw.uri.encode(title.fullText), p.num(frame, count))
	local used_on_text = "'''" .. (mw.title.getCurrentTitle().namespace == 828 and 'Mô đun Lua' or 'Bản mẫu') .. ' này được sử dụng ';
	if systemMessages then
		used_on_text = used_on_text .. systemMessages ..
			((count and count > 2000) and ("''', và " .. templateCount) or "'''")
	else
		used_on_text = used_on_text .. templateCount .. "'''"
	end
	
	
	local sandbox_text = ("trang con [[%s/sandbox|/sandbox]], [[%s/testcases|/testcases]] của %s, hoặc ở %s. "):format(
		title.fullText, title.fullText,
		(mw.title.getCurrentTitle().namespace == 828 and "mô đun" or "bản mẫu"),
		mw.title.getCurrentTitle().namespace == 828 and "[[Mô đun:Sandbox|chỗ thử mô đun]]" or "không gian người dùng của bạn"
	)
	
	local infoArg = frame.args["info"] ~= "" and frame.args["info"]
	if (systemMessages or frame.args[1] == "risk" or (count and count >= 100000) ) then
		local info = systemMessages and '.<br />Thay đổi đến nó có thể dẫn đến thay đổi ngay lập tức giao diện người dùng BKDatabase.' or '.'
		if infoArg then
			info = info .. '<br />' .. infoArg
		end
		sandbox_text = info .. '<br />Để tránh gây lỗi trên quy mô lớn' ..
			(count and count >= 100000 and ' và [[:mw:Manual:Job queue|tải máy chủ]] không cần thiết' or '') ..
			', tất cả thay đổi cần được thử nghiệm ở ' .. sandbox_text ..
			'Các thay đổi đã được thử nghiệm có thể thêm vào ' .. (mw.title.getCurrentTitle().namespace == 828 and "mô đun" or "bản mẫu") ..  
			' bằng một sửa đổi duy nhất. '
	else
		sandbox_text = (infoArg and ('.<br />' .. infoArg .. ' N') or ', vì thế n') ..
			'hững thay đổi đến nó sẽ hiện ra rõ ràng. Vui lòng thử nghiệm các thay đổi ở ' .. sandbox_text
	end


	local discussion_text = (systemMessages or frame.args[1] == "risk" or (count and count >= 100000)) and 'Xin hãy thảo luận các thay đổi ' or 'Cân nhắc thảo luận các thay đổi '
	if frame.args["2"] and frame.args["2"] ~= "" and frame.args["2"] ~= "yes" then
		discussion_text = string.format("%stại [[%s]]", discussion_text, frame.args["2"])
	else
		discussion_text = string.format("%stại [[%s|trang thảo luận]]", discussion_text, title.talkPageTitle.fullText )
	end
	
	return used_on_text .. sandbox_text .. discussion_text .. ' trước khi áp dụng sửa đổi.' .. bot_text
end

function p.main(frame)
	local count = nil
	if yesno(frame.args['fetch']) == false then
		if (frame.args[1] or '') ~= '' then count = tonumber(frame.args[1]) end
	else
		count = _fetch(frame)
	end
	local image = "[[Tập_tin:BrainrotBiohazard.png|40px|alt=Chú ý|link=]]"
	local type_param = "style"
	local epilogue = ''
	if frame.args['system'] and frame.args['system'] ~= '' then
		image = "[[Tập_tin:BrainrotBiohazard.png|40px|alt=Chú ý|link=]]"
		type_param = "content"
		local nocat = frame:getParent().args['nocat'] or frame.args['nocat']
		local categorise = (nocat == '' or not yesno(nocat))
		if categorise then
			epilogue = frame:preprocess('{{Sandbox other||{{#switch:{{#gọi:Effective protection level|{{#switch:{{NAMESPACE}}|{{ns:6}}=upload|#default=edit}}|{{FULLPAGENAME}}}}|sysop|interfaceadmin=|#default=}}}}')
		end
	elseif (frame.args[1] == "risk" or (count and count >= 100000)) then
		image = "[[Tập_tin:BrainrotBiohazard.png|40px|alt=Chú ý|link=]]"
		type_param = "content"
	end
	
	if frame.args["form"] == "editnotice" then
		return frame:expandTemplate{
				title = 'editnotice',
				args = {
						["image"] = image,
						["text"] = p.text(frame, count),
						["expiry"] = (frame.args["expiry"] or "")
				}
		} .. epilogue
	else
		return require('Mô đun:Message box').main('ombox', {
			type = type_param,
			image = image,
			text = p.text(frame, count),
			expiry = (frame.args["expiry"] or "")
		}) .. epilogue
	end
end

return p
