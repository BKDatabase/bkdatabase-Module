local mHatnote = require('Module:Hatnote')
local mHatlist = require('Module:Hatnote list')
local mArguments --initialize lazily
local mTableTools --initialize lazily
local libraryUtil = require('libraryUtil')
local checkType = libraryUtil.checkType
local p = {}

-- Produces standard {{other uses}} implementation
function p.otheruses(frame)
	mArguments = require('Module:Arguments')
	mTableTools = require('Module:TableTools')
	local args = mTableTools.compressSparseArray(mArguments.getArgs(frame))
	local title = mw.title.getCurrentTitle().prefixedText
	return p._otheruses(args, {title=title})
end

-- Produces standard {{other uses2}} implementation
function p.otheruses2(frame)
	return p._otheruses({}, {title = (frame:getParent().args[1] or mw.title.getCurrentTitle().prefixedText)})
end

--Implements "other [x]" templates with otherText supplied at invocation
function p.otherX(frame)
	mArguments = require('Module:Arguments')
	mTableTools = require('Module:TableTools')
	local x = frame.args[1]
	local args = mTableTools.compressSparseArray(
		mArguments.getArgs(frame, {parentOnly = true})
	)
	local options = {
		title = mw.title.getCurrentTitle().prefixedText,
		otherText = x
	}
	return p._otheruses(args, options)
end

-- Main generator
function p._otheruses(args, options)
	--Type-checks and defaults
	checkType('_otheruses', 1, args, 'table', true)
	args = args or {}
	checkType('_otheruses', 2, options, 'table')
	if not (options.defaultPage or options.title) then
		error('Không có dữ liệu tiêu đề mặc định được cung cấp trong bảng tùy chọn "_otheruses"', 2)
	end
	local emptyArgs = true
	for k, v in pairs(args) do
		if type(k) == 'number' then emptyArgs = false break end
	end
	if emptyArgs then
		args = {
			options.defaultPage or
			mHatnote.disambiguate(options.title, options.disambiguator)
		}
	end
	--Generate and return hatnote
	local text = mHatlist.forSeeTableToString({{
		use = options.otherText and "other " .. options.otherText or nil,
		pages = args
	}})
	return mHatnote._hatnote(text)
end

return p
