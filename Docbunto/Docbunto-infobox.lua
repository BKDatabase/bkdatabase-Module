--- Infobox for Lua modules.
--  @script			 infobox
--  @param			 {table} data Taglet documentation data.
--  @param			 {string} codepage Code page name.
--  @param			 {table} frame Template invocation frame.
--  @param			 {table} options Docbunto configuration options.
--  @return			 {string} Infobox wikitext.
return function(data, codepage, frame, options, title, maybe_md)
	local module_rating_box = {}
	if data.info['release'] then
		module_rating_box.title = 'Module rating'
		module_rating_box.args = {}
		module_rating_box.args[1] = data.info['release']
	end
	local statusHeader = ''
	if module_rating_box.title then
		statusHeader = data.info['release']
			and frame:expandTemplate{
				title = module_rating_box.title,
				args = module_rating_box.args
			} or ''
	end
	
	local modules = data.info['require'] and mw.text.split(data.info['require'], '\n') or {}
	for k,v in ipairs(modules) do
		modules[k] = mw.ustring.sub(v, 3) 
	end
	
	local dependencies = ''
	if #modules ~= 0 then
		dependencies = require("Module:Lua banner").renderBox(modules)
	end
	if not options.autodoc then
		dependencies = ''
		statusHeader = ''
	end
	
	local infobox = {}
	infobox.title = 'Infobox Lua'
	infobox.args = {}
	if codepage ~= mw.text.split(title.text, '/')[2] then
		infobox.args['title'] = codepage
		infobox.args['code'] = codepage
	end

	if options.image or data.info['image'] then
		infobox.args['image file'] = data.info['image']
	end

	if options.caption or data.info['caption'] then
		infobox.args['image caption'] = frame:preprocess(maybe_md(
			options.caption or data.info['caption']
		))
	end

	infobox.args['type'] = data.type == 'module' and 'invocable' or 'meta'

	if data.info['release'] then
		infobox.args['status'] = data.info['release']
	end

	if data.summary then
		local description = data.summary
		if description:find('^(' .. codepage .. ')') then
			description = description:gsub('^' .. codepage .. '%s(%w)', mw.ustring.upper)
		end
		infobox.args['description'] = frame:preprocess(maybe_md(description))
	end

	if data.info['author'] then
		infobox.args['author'] = frame:preprocess(maybe_md(data.info['author']))
	end

	if data.info['attribution'] then
		infobox.args['using code by'] = frame:preprocess(maybe_md(data.info['attribution']))
	end

	if data.info['credit'] then
		infobox.args['other attribution'] = frame:preprocess(maybe_md(data.info['credit']))
	end
	
	if data.info['license'] then
		infobox.args['license'] = frame:preprocess(maybe_md(data.info['license']))
	end

	if data.info['require'] then
		local req = data.info['require']
			:gsub('^[^[%s]+$', '[[%1]]')
			:gsub('%* ([^[%s]+)', '* [[%1]]')
		infobox.args['dependencies'] = frame:preprocess(maybe_md(req))
	end

	if codepage ~= 'I18n' and data.code:find('[\'"]Module:I18n[\'"]') then
		infobox.args['languages'] = 'auto'
	elseif data.code:find('mw%.message%.new') then
		infobox.args['languages'] = 'mw'
	end

	if data.info['demo'] then
		infobox.args['examples'] = frame:preprocess(maybe_md(data.info['demo']))
	end
	return statusHeader .. dependencies .. frame:expandTemplate(infobox)
end
