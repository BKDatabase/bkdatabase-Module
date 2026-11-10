require('strict')
local getArgs = require('Module:Arguments').getArgs
local hatnote = require('Module:Hatnote')._hatnote
local formatLink = require('Module:Format link')._formatLink

local p = {}

local catNS = mw.site.namespaces.Category.id -- category namespace number

-- Lua implementation of [[Bản mẫu:Cặp thể loại]]
-- Arguments:
--   prevTitle -- mw.title.Title object for preceding category
--   nextTitle -- mw.title.Title object for succeeding category
-- Returns:
--   hatnote that says "see also" for one or both of prev/next (depending on whether they exist)
function p._pair(prevTitle, nextTitle)
	prevTitle = prevTitle and prevTitle.exists and formatLink{link = prevTitle.fullText}
	nextTitle = nextTitle and nextTitle.exists and formatLink{link = nextTitle.fullText}
	local note = ''
	if prevTitle and nextTitle then -- if both
		note = mw.ustring.format('Xem thêm thể loại trước %s và thể loại sau %s',prevTitle, nextTitle)
	elseif prevTitle then -- if only prevTitle
		note = mw.ustring.format('Xem thêm thể loại trước %s', prevTitle)
	elseif nextTitle then -- if only nextTitle
		note = mw.ustring.format('Xem thêm thể loại sau %s', nextTitle)
	else                  -- otherwise neither
		return mw.title.getCurrentTitle().namespace == catNS and '[[Thể loại:Trang sử dụng cặp thể loại không có đầu ra]]' or ''
	end
	return hatnote(note, {extraclasses = 'seealso'})
end

function p.catPair(frame)
	local args = getArgs(frame, {wrappers={'Bản mẫu:Category pair'}})
	local prevTitle = args[1] and mw.title.new(args[1],catNS)
	local nextTitle = args[2] and mw.title.new(args[2],catNS)
	return p._pair(prevTitle, nextTitle)
end

function p.prevCat(frame)
	local args = getArgs(frame, {wrappers={'Bản mẫu:Preceding category'}})
	local prevTitle = args[1] and mw.title.new(args[1], catNS)
	return p._pair(prevTitle, nil)
end

function p.nextCat(frame)
	local args = getArgs(frame, {wrappers={'Bản mẫu:Succeeding category'}})
	local nextTitle = args[1] and mw.title.new(args[1], catNS)
	return p._pair(nil, nextTitle)
end

return p
