-- This module converts a number into its written English form.
-- For example, "2" becomes "two", and "79" becomes "seventy-nine".

local getArgs = require('Mô đun:Arguments').getArgs

local p = {}

local max = 100 -- The maximum number that can be parsed.

local ones = {
	[0] = 'không',
	[1] = 'một',
	[2] = 'hai',
	[3] = 'ba',
	[4] = 'bốn',
	[5] = 'năm',
	[6] = 'sáu',
	[7] = 'bảy',
	[8] = 'tám',
	[9] = 'chín'
}

local specials = {
	[10] = 'mười',
	[11] = 'mười một',
	[12] = 'mười hai',
	[13] = 'mười ba',
	[15] = 'mười lăm',
	[18] = 'mười tám',
	[20] = 'hai mươi',
	[30] = 'ba mươi',
	[40] = 'bốn mươi',
	[50] = 'năm mươi',
	[60] = 'sáu mươi',
	[70] = 'bảy mươi',
	[80] = 'tám mươi',
	[90] = 'chín mươi',
	[100] = 'một trăm'
}

local formatRules = {
	{num = 90, rule = 'chín mươi %s'},
	{num = 80, rule = 'tám mươi %s'},
	{num = 70, rule = 'bảy mươi %s'},
	{num = 60, rule = 'sáu mươi %s'},
	{num = 50, rule = 'năm mươi %s'},
	{num = 40, rule = 'bốn mươi %s'},
	{num = 30, rule = 'ba mươi %s'},
	{num = 20, rule = 'hai mươi %s'},
	{num = 10, rule = 'mười %s'}
}

function p.main(frame)
	local args = getArgs(frame)
	local num = tonumber(args[1])
	local success, result = pcall(p._main, num)
	if success then
		return result
	else
		return string.format('<strong class="error">Lỗi: %s</strong>', result) -- "result" is the error message.
	end
	return p._main(num)
end

function p._main(num)
	if type(num) ~= 'number' or math.floor(num) ~= num or num < 0 or num > max then
		error('nhập vào phải là một số nguyên giữa 0 và ' .. tostring(max), 2)
	end
	-- Check for numbers from 0 to 9.
	local onesVal = ones[num]
	if onesVal then
		return onesVal
	end
	-- Check for special numbers.
	local specialVal = specials[num]
	if specialVal then
		return specialVal
	end
	-- Construct the number from its format rule.
	onesVal = ones[num % 10]
	if not onesVal then
		error('Lỗi được không muốn đang phân tích nhập vào ' .. tostring(num))
	end
	for i, t in ipairs(formatRules) do
		if num >= t.num then
			return string.format(t.rule, onesVal)
		end
	end
	error('Không có quy tắc định dạng được tìm thấy nhập vào ' .. tostring(num))
end

return p
