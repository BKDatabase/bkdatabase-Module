--------------------------------------------------------------------------------
--                               Labelled list                                --
--                                                                            --
-- This module does the core work of creating a hatnote composed of a list    --
-- prefixed by a colon-terminated label, i.e. "LABEL: [andList of pages]",    --
-- for {{see also}} and similar templates.                                    --
--------------------------------------------------------------------------------

local mHatnote = require('Module:Hatnote')
local mHatlist = require('Module:Hatnote list')
local mArguments --initialize lazily
local yesno --initialize lazily
local p = {}

-- Defaults global to this module
local defaults = {
	label = 'See also', --Final fallback for label argument
	labelForm = '%s: %s',
	prefixes = {'label', 'label ', 'l'},
	template = 'Module:Labelled list hatnote'
}

-- Localizable message strings
local msg = {
	errorSuffix = '#Errors',
	noInputWarning = 'no page names specified',
	noOutputWarning =
		"'''[[%s]] — no output: none of the target pages exist.'''"
}

-- Helper function that pre-combines display parameters into page arguments.
-- Also compresses sparse arrays, as a desirable side-effect.
function p.preprocessDisplays (args, prefixes)
	-- Prefixes specify which parameters, in order, to check for display options
	-- They each have numbers auto-appended, e.g. 'label1', 'label 1', & 'l1'
	prefixes = prefixes or defaults.prefixes
	local indices = {}
	local sparsePages = {}
	for k, v in pairs(args) do
		if type(k) == 'number' then
			indices[#indices + 1] = k
			local display
			for i = 1, #prefixes do
				display = args[prefixes[i] .. k]
				if display then break end
			end
			sparsePages[k] = display and
				string.format('%s|%s', string.gsub(v, '|.*$', ''), display) or v
		end
	end
	table.sort(indices)
	local pages = {}
	for k, v in ipairs(indices) do pages[#pages + 1] = sparsePages[v] end
	return pages
end

--Helper function to get a page target from a processed page string
--e.g. "Page|Label" → "Page" or "Target" → "Target"
local function getTarget(pagename)
 	local pipe = string.find(pagename, '|')
	return string.sub(pagename, 0, pipe and pipe - 1 or nil)
end

-- Produces a labelled pages-list hatnote.
-- The main frame (template definition) takes 1 or 2 arguments, for a singular
-- and (optionally) plural label respectively:
-- * {{#invoke:Labelled list hatnote|labelledList|Singular label|Plural label}}
-- The resulting template takes pagename & label parameters normally.
function p.labelledList (frame)
	mArguments = require('Module:Arguments')
	yesno = require('Module:Yesno')
	local labels = {frame.args[1] or defaults.label}
	labels[2] = frame.args[2] or labels[1]
	labels[3] = frame.args[3] --no defaulting
	labels[4] = frame.args[4] --no defaulting
	local template = frame:getParent():getTitle()
	local args = mArguments.getArgs(frame, {parentOnly = true})
	local pages = p.preprocessDisplays(args)
	local options = {
		category = yesno(args.category),
		extraclasses = frame.args.extraclasses,
		ifexists = yesno(frame.args.ifexists),
		namespace = frame.args.namespace or args.namespace,
		selfref = yesno(frame.args.selfref or args.selfref),
		template = template
	}
	return p._labelledList(pages, labels, options)
end

function p._labelledList (pages, labels, options)
	if options.ifexists then
		for k = #pages, 1, -1 do --iterate backwards to allow smooth removals
			local v = pages[k]
			local title = mw.title.new(getTarget(v), namespace)
			if (v == '') or title == nil or not title.exists then
				table.remove(pages, k)
			end
		end
	end
	labels = labels or {}
	label = (#pages == 1 and labels[1] or labels[2]) or defaults.label
	for k, v in pairs(pages) do 
		if mHatnote.findNamespaceId(v) ~= 0 then
			label =
				(
					#pages == 1 and
					(labels[3] or labels[1] or defaults.label) or
					(labels[4] or labels[2] or defaults.label)
				) or defaults.label
		end
	end
	if #pages == 0 then
		if options.ifexists then
			mw.addWarning(
				string.format(
					msg.noOutputWarning, options.template or defaults.template
				)
			)
			return ''
		else
			return mHatnote.makeWikitextError(
				msg.noInputWarning,
				(options.template or defaults.template) .. msg.errorSuffix,
				options.category
			)
		end
	end
	local text = string.format(
		options.labelForm or defaults.labelForm,
		label,
		mHatlist.andList(pages, true)
	)
	local hnOptions = {
		extraclasses = options.extraclasses,
		selfref = options.selfref
	}
	return mHatnote._hatnote(text, hnOptions)
end

return p
