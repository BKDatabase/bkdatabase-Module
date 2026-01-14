-- Mô đun này thực hiện [[Bản mẫu:Tfd links]]
local p = {}

local function urlencode(text)
	-- Return equivalent of {{urlencode:text}}.
	local function byte(char)
		return string.format('%%%02X', string.byte(char))
	end
	return text:gsub('[^ %w%-._]', byte):gsub(' ', '+')
end

local function fullurllink(t, a, s)
	return '[//vi.wikipedia.org/w/index.php?title=' .. urlencode(t) .. '&' .. a .. ' ' .. s .. ']'
end

function p.main(frame)
	local args = frame:getParent().args
	local ns = (args['catfd'] and args['catfd'] ~= '') 
		and 'Thể loại' or 'Bản mẫu'
	local tname = mw.getContentLanguage():ucfirst(args['1'] or 'Ví dụ')
	local fname = ns .. ':' .. tname
	local ymd = args['2'] or ''
	local fullpagename = (ymd ~= '')
		and	'WP:Bản mẫu cho thảo luận/Nhật trình/' .. ymd
		or frame:preprocess('{{FULLPAGENAME}}')
	local sep = '&nbsp;<b>·</b> '
	
	local res = '<span id="' .. ns .. ':' .. tname 
		.. '" class="plainlinks nourlexpansion 1x">'
		.. '[[:' .. ns .. ':' .. tname .. ']]&nbsp;('
	
	if ymd ~= '' then
		local dmy = frame:expandTemplate{ title='date', args={ymd, 'dmy'} } 
		res = res .. '[[' .. fullpagename .. '#' .. fname 
			.. '|' .. dmy .. ']]) ('
	end
	res = res .. fullurllink(fname, 'action=edit', 'sửa') .. sep
	res = res .. '[[Thảo luận ' .. ns .. ':' .. tname .. '|thảo luận]]' .. sep
	res = res .. fullurllink(fname, 'action=history', 'lịch sử') .. sep
	if ns ~= 'Thể loại' then
		res = res .. fullurllink('Đặc_biệt:Liên_kết_đến_đây/' 
			.. fname, 'limit=999', 'liên kết') .. sep
	end
	res = res .. fullurllink('Đặc_biệt:Nhật_trình', 'page=' 
		.. urlencode(fname), 'nhật trình') .. sep
	res = res .. '[[Đặc_biệt:Tiền_tố/' .. fname .. '/|trang con]]' .. sep
	res = res .. fullurllink(fname, 'action=delete&wpReason=' 
		.. urlencode('[[' .. fullpagename .. '#' .. fname .. ']]'), 'xóa')
	res = res .. ')</span>'
	
	return res
end

return p
