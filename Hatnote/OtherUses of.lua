local mArguments --initialize lazily
local mHatList = require('Module:Hatnote list')
local mHatnote = require('Module:Hatnote')
local mOtheruses = require('Module:Other uses')
local yesNo = require('Module:Yesno')
local p = {}

function p.otherusesof (frame)
	mArguments = require('Module:Arguments')
	return p._otherusesof(mArguments.getArgs(frame))
end

function p._otherusesof (args)
	local currentTitle = mw.title.getCurrentTitle()
	local prefixedText = currentTitle.prefixedText
	local maxArg = 0
	for k, v in pairs(args) do
		if type(k) == 'number' and k > maxArg then maxArg = k end
	end
	local page = args[maxArg]
	if maxArg == 1 then page = mHatnote.disambiguate(page) end
	local ofWhat = nil
	if maxArg > 2 then
		local pages = {}
		local midPages = {}
		for k, v in pairs(args) do
			if type(k) == 'number' and k < maxArg then
				midPages[k] = mHatnote.quote(v)
			end
		end
		for i = 1, maxArg do
			if midPages[i] then pages[#pages + 1] = midPages[i] end
		end
		ofWhat = mHatList.orList(pages)
	end
	if not ofWhat then
		ofWhat = mHatnote.quote(args[1] or prefixedText)
	end
	local options = {
		title = ofWhat,
		otherText =
			args.topic and
			string.format('uses of %s in %s', ofWhat, args.topic) or
			string.format('uses of %s', ofWhat)
	}
	local skipCat =
		(currentTitle.isTalkPage or (currentTitle.namespace == 2)) or
		(yesNo(args.category) == false)
	local oddCat =
		skipCat and '' or
		"[[Category:Hatnote templates using unusual parameters]]"
	if (mw.ustring.lower(args[1] or "") == mw.ustring.lower(prefixedText)) and
		maxArg <= 2 or
		((not args[1]) and (not args[2]))
	then
		options.otherText = options.otherText .. oddCat
	end
	arg = page and {page} or {}
	return mOtheruses._otheruses(arg, options)
end

return p
