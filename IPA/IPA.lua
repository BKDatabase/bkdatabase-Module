require('strict')
local p = {}

local function multiFind(s, patterns, init)
	local i, j = mw.ustring.find(s, patterns[1], init)
	for n = 2, #patterns do
		local i2, j2 = mw.ustring.find(s, patterns[n], init)
		if i2 and (not i or i2 < i) then
			i, j = i2, j2
		end
	end
	return i, j
end

local function wrapAtSpaces(s)
	return mw.ustring.gsub(s, '(%s+)', '<span class="wrap">%1</span>')
end

local function wrapAtSpacesSafely(s)
	local patterns = {
		'%[%[[^%]|]-%s[^%]|]-|', -- Piped links
		'</?[A-Za-z][^>]-%s[^>]->' -- HTML tags
	}
	s = mw.ustring.gsub(s, '%[%[([^%]|]-%s[^%]|]-)%]%]', '[[%1|%1]]') -- Pipe all links
	local t = {}
	local init
	while true do
		local i, j = multiFind(s, patterns, init)
		if not i then
			break
		end
		local pre = wrapAtSpaces(mw.ustring.sub(s, init, i - 1)) -- What precedes the match
		table.insert(t, pre)
		table.insert(t, mw.ustring.sub(s, i, j)) -- The match
		init = j + 1
	end
	local post = wrapAtSpaces(mw.ustring.sub(s, init)) -- What follows the last match
	table.insert(t, post)
	return table.concat(t)
end

local function checkNamespace(isDebug)
	return isDebug or require('Mô đun:Category handler').main({ true })
end

local function renderCats(cats, isDebug)
	if not cats[1] or not checkNamespace(isDebug) then
		return ''
	end
	local t = {}
	for _, v in ipairs(cats) do
		table.insert(t, string.format(
			'[[%sThể loại:%s]]',
			isDebug and ':' or '',
			v
		))
	end
	return table.concat(t)
end

local function resolveSynonym(s)
	return mw.loadData('Mô đun:Lang/ISO 639 synonyms')[s] or s
end

local function getLangName(code, link)
	return require('Mô đun:Lang')._name_from_tag({
		code,
		link = link,
		-- Without linking, "{{IPA}}" gets expanded in some contexts
		template = '[[Bản mẫu:IPA|IPA]]'
	})
end

local function linkLang(name, target, link)
	return link == 'yes' and string.format(
		'[[%s|%s]]',
		target or name .. ' language',
		name
	) or name
end

function p._main(args)
	local ret, cats = {}, {}
	local isDebug = args.debug == 'yes'
	local s, langCode, isPrivate, fullLangCode
	
	-- Guide-linking mode
	if args[2] and args[2] ~= '' then
		local data = mw.loadData('Mô đun:IPA/data')
		local isGeneric = args.generic == 'yes'
		s = args[2]
		
		-- Split tag into language and region codes
		langCode = args[1]:gsub('%-.*', ''):lower()
		langCode = resolveSynonym(langCode)
		local regionCode = args[1]:match('%-(.+)')
		local langData = data.langs[langCode] or {}
		if regionCode then
			isPrivate = regionCode:sub(1, 2) == 'x-'
			if not isPrivate then
				regionCode = regionCode:upper()
			end
			if langData.dialects and langData.dialects[regionCode] then
				-- Overwrite language data with the dialect's
				local newLangData = {}
				for k, v in pairs(langData) do
					if k ~= 'dialects' then
						newLangData[k] = v
					end
				end
				local dialectData = langData.dialects[regionCode]
				if dialectData.aliasOf then
					-- Use the canonical region code
					regionCode = dialectData.aliasOf
					dialectData = langData.dialects[regionCode]
				end
				-- Lowercase IANA variant
				if dialectData.isVariant then
					regionCode = regionCode:lower()
				end
				for k, v in pairs(dialectData) do
					newLangData[k] = v
				end
				langData = newLangData
			else
				isGeneric = true
			end
			fullLangCode = langCode .. '-' .. regionCode
		else
			fullLangCode = langCode
		end
		
		local langName = langData.name
			and linkLang(langData.name, langData.link, args.link)
			or getLangName(fullLangCode, args.link)
		if langName:sub(1, 5) == '<span' then
			-- Module:Lang has returned an error
			return langName .. renderCats({ 'Lỗi bản mẫu IPA' }, isDebug)
		end
		if args.cat ~= 'no' then
			local catLangName = args.link == 'yes'
				and mw.ustring.match(langName, '([^%[|%]]+)%]%]$')
				or langName
			table.insert(cats, string.format('Trang có IPA %s', catLangName))
		end
		
		-- Label
		local label = args.label
		if not label then
			local labelCode = args[3] and args[3]:lower()
				or langData.defaultLabelCode
			if labelCode == '' then
				label = ''
			else
				local langText
				if langData.text then
					langText = linkLang(
						langData.text,
						mw.ustring.match(langName, '^%[%[([^|%]]+)'),
						args.link
					)
				else
					langText = mw.ustring.gsub(
						langName,
						'^%[%[(([^|]+) languages)%]%]$',
						'[[%1|%2]]'
					)
					langText = mw.ustring.gsub(
						langText,
						' languages(%]?%]?)$',
						'%1'
					)
				end
				if labelCode and data.labels[labelCode] then
					label = data.labels[labelCode]:format(langText)
				else
					label = data.defaultLabel:format(langText)
				end
			end
		end
		if label and label ~= '' then
			local span = mw.html.create('span')
				:addClass('IPA-label')
				:wikitext(label)
			if args.small ~= 'no' then
				span:addClass('IPA-label-small')
				table.insert(ret, mw.getCurrentFrame():extensionTag({
					name = 'templatestyles',
					args = { src = 'Mô đun:IPA/styles.css' }
				}))
			end
			table.insert(ret, tostring(span) .. ' ')
		end
		
		-- Brackets
		s = (not isGeneric and langData.format or '&#91;%s&#93;'):format(s)
		
		-- Link to key
		local key = not isGeneric and langData.key or data.defaultKey
		s = string.format('[[%s|%s]]', key, s)
	else
		-- Basic mode
		s = args[1]
		if args.cat ~= 'no' then
			table.insert(cats, 'Trang có IPA thường')
		end
	end
	
	-- Transcription
	do
		local lang = isPrivate and langCode or fullLangCode or
			args.lang ~= '' and args.lang or 'und'
		local span = mw.html.create('span')
			:addClass('IPA')
			:addClass(args.class)
			:attr('lang', lang .. '-Latn-fonipa')
		-- wrap=all: Do nothing
		-- wrap=none: Never break
		-- Otherwise: Break at spaces only
		if args.wrap ~= 'all' then
			span:addClass('nowrap')
			if args.wrap ~= 'none' then
				s = wrapAtSpacesSafely(s)
			end
		end
		if (not args[2] or args[2] == '') and args.tooltip ~= '' then
			local tooltip = args.tooltip or
				'Ký tự trong Bảng Phiên âm Quốc tế (IPA)'
			span:attr('title', tooltip)
		end
		s = tostring(span:wikitext(s))
		table.insert(ret, s)
	end
	
	-- Audio
	local audio = args.audio ~= '' and args.audio or args[4] ~= '' and args[4]
	if audio then
		local button = mw.getCurrentFrame():expandTemplate({
			title = 'Audio',
			args = { audio, '' }
		})
		table.insert(ret, ' ' .. button)
		table.insert(cats, 'Trang có phát âm được ghi âm')
	end
	
	-- Categories
	table.insert(ret, renderCats(cats, isDebug))
	
	return table.concat(ret)
end

function p.main(frame)
	local args = frame:getParent().args
	if not args[1] then
		return ''
	end
	for i, v in ipairs(args) do
		args[i] = mw.text.trim(v)
	end
	return p._main(args)
end

return p
