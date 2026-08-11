local MessageBox = require('Module:Message box')
local Gadgets = require('Module:Gadgets')
local Arguments = require('Module:Arguments')
local TableTools = require('Module:TableTools')

local p = {}

p.main = function(frame)
	local args = Arguments.getArgs(frame)
	return p.core(args.page or mw.title.getCurrentTitle().fullText)
end

p.core = function(page)
	local text = ''

	local content = mw.title.new(page).content
	if content then
		local result = content:match("/%* ({{mfd.-}})")
		if result then
			text = text .. mw.getCurrentFrame():preprocess(result)
		end
	end

	local len = page:len()
	if len < 4 then
		-- Too short page name, do nothing more
		return text
	end
	
	return p.makeMessage(page)
end

local skins = TableTools.listToSet({ 
	'common', 'vector-2022', 'vector', 'timeless', 'minerva', 'monobook', 'modern', 'cologneblue', 'citizen'
})

p.gadget_text = function(name, repo)
	local lang = mw.getContentLanguage()
	local options = repo[name].options
	local dependents = {}
	if options.hidden ~= nil then
		-- Find dependents
		for n, c in pairs(repo) do
			local deps = c.options.dependencies and 
				TableTools.listToSet(mw.text.split(c.options.dependencies, ',', false)) or {}
			local peers = c.options.peers and 
				TableTools.listToSet(mw.text.split(c.options.peers, ',', false)) or {}
			if deps['ext.gadget.'..name] ~= nil or peers[name] ~= nil then 
				table.insert(dependents, '[[Special:Gadgets#gadget-'..n..'|'..n..']]')
			end
		end
	end
	local usage = Gadgets.get_usage(name)
	if usage == -1 then
		usage = "an unknown number of"
	else
		usage = lang:formatNum(usage)
	end
	return 'This page is loaded as a part of the ' ..
		'[[Special:Gadgets#gadget-'..name..'|'..name..']] gadget' ..
		(options.hidden ~= nil and ', a hidden gadget'..
			(#dependents > 0 and ' used by '..mw.text.listToText(dependents)..'.' or '.') or 
		(options.default ~= nil and ', <b>which is enabled by default</b>.' or 
		(', used by '..usage..' users. ')))
end

p.makeMessage = function(page)
	local pageparts = mw.text.split(page, '.', true)
	local pagetype = '.' .. pageparts[#pageparts]
	
	local pagetypes = TableTools.listToSet({ 
		'.js', '.css', '.json', '.vue'
	})
	
	if #pageparts<2 or pagetypes[pagetype] == nil then
		return ''
	end

	local function listSisters(title, intro)
		local output = {intro}
		for sistertype in pairs(pagetypes) do
			if sistertype ~= pagetype then
				local sisterpage = mw.title.new(title .. sistertype)
				if sisterpage.exists then
					table.insert(output, 
						'an accompanying '..sistertype..' page at [['..sisterpage.fullText..']]'
					)
				end
			end
		end
		--listToText with Oxford commas
		return mw.text.listToText(output, ', ', (#output > 2) and ', and ' or ' and ') .. '.'
	end

	local text = ''
	local basepage = mw.title.new(page:sub(0, -1 * (#pagetype + 1)))
	
	if basepage.namespace == 2 then
		if skins[basepage.subpageText] ~= nil and (pagetype == '.js' or pagetype == '.css') then
			-- We are on a user skin file
			local sistertype = (pagetype == '.js') and '.css' or '.js'
			local sisterpage = mw.title.new(basepage.fullText .. sistertype)
			text = 'The accompanying '..sistertype..' page for this skin '..
				(sisterpage.exists and 'is' or 'can be added')..' at [['..sisterpage.fullText..']].'
		else
			-- We are on some script page, not a user skin file
			if basepage.exists then
				text = listSisters(basepage.fullText, 'This user script seems to have a documentation page at [['..basepage.fullText..']]')
			else
				text = listSisters(basepage.fullText)
				text = 'Documentation for this user script can be added at [['..basepage.fullText..']]' .. 
					((#text > 1) and '. This user script seems to have ' or '') ..
					text
			end	
		end
	elseif basepage.namespace == 8 then
		if basepage.text:find('^Gadget-') ~= nil then
			local gadgetRepo = Gadgets.parse()
			local shortName = basepage.text:gsub('^Gadget%-', '') .. pagetype
			for name, config in pairs(gadgetRepo) do
				if TableTools.inArray(config.pages, shortName) then
					text = text .. p.gadget_text(name, gadgetRepo)
				end
			end
			if text ~= '' then
				local sisterText = listSisters(basepage.fullText)
				text = text .. 
					((#sisterText > 1) and (' There seems to be ' .. sisterText) or '') ..
					'<br>'
			end
		end
	end
	
	if text ~= '' then
		return mw.getCurrentFrame():extensionTag{
			name = 'templatestyles', args = { src = 'Module:Script doc auto/styles.css' }
		} .. MessageBox.main('fmbox', {
			class = 'script-doc-auto-box',
			id = 'mw-script-doc',
			type = 'system',
			image = '[[File:Ledger_open_button.webp|43x40px|link=]]',
			text = text
		})
	end
	return ''
end

return p