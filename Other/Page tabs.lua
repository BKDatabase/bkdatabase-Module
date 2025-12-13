-- This module implements {{Page tabs}}.

local getArgs = require('Mô đun:Arguments').getArgs
local yesno = require('Mô đun:Yesno')

local p = {}

function p.main(frame)
	local args = getArgs(frame)
	return p._main(args)
end

function p._main(args)
	local makeTab = p.makeTab
	local root = mw.html.create()
	root:wikitext(yesno(args.NOTOC) and '__NOTOC__' or nil)
	local row = root:tag('div')
		:css('background', args.Background or '#f8fcff')
		:css('color', 'black')
		:cssText(args.style or nil)
		:addClass('template-page-tabs')
		:addClass(args.class or nil)
	if not args[1] then
		args[1] = '{{{1}}}'
	end
	for i, link in ipairs(args) do
		makeTab(row, link, args, i, args["class" .. i] or nil, args["style" .. i] or nil)
	end
		
	return tostring(root)
end

function p.makeTab(root, link, args, i, class, css)
	local thisPage = (args.This == 'auto' and link:find('[[' .. mw.title.getCurrentTitle().prefixedText .. '|', 1, true)) or tonumber(args.This) == i
	root:tag('span')
		:addClass(class)
		:css('background-color', thisPage and (args['tab-bg'] or 'white') or (args['tab1-bg'] or '#e0edf6'))
		:css('color', 'black')
		:cssText(thisPage and 'border-bottom:0;font-weight:bold' or 'font-size:95%')
		:cssText(css)
		:wikitext(link)
		:done()
		:wikitext('<span class="spacer ' .. (class or "") .. '">&#32;</span>')
end

return p
