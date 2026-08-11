local p = {}

p.parse = function()
	local text = mw.title.new('MediaWiki:Gadgets-definition'):getContent()
	local lines = mw.text.split(text, '\n', false)
	
	local repo = {}
	for _, line in ipairs(lines) do
		if line:sub(1, 1) == '*' then
			local name, options, pages = p.parse_line(line)
			if name and #pages ~= 0 then
				repo[name] = { options = options, pages = pages }
			end
		end
	end
	return repo
end

p.parse_line = function(def) 
	local pattern = "^%*%s*(.+)%s*(%b[])%s*(.-)$"
	local name, opts, pageList = string.match(def, pattern)
	
	if name then
		name = mw.text.trim(name)
	end

	-- Process options string into a Lua table
    local options = {}	
	if opts then
	    -- Extracting the options without square brackets and trimming spaces
	    opts = opts:sub(2, -2):gsub("%s+", "")
	    
	    for pair in opts:gmatch("%s*([^|]+)%s*|?") do
		    local key, value = pair:match("%s*([^=]+)%s*=%s*([^=|]+)%s*")
		    if key and value then
		        options[key:match("%s*(.-)%s*$")] = value:match("^%s*(.-)%s*$")
		    else
		        key = pair:match("%s*(.-)%s*$")
		        options[key] = true
		    end
		end
	end

	-- Process page list into an array
	local pages = {}
	if pageList then
	    for page in pageList:gmatch("[^|]+") do
	        table.insert(pages, mw.text.trim(page))
	    end
    end
    return name, options, pages
end

p.get_type = function(def) 
	if def.options.type == 'general' or def.options.type == 'styles' then
		return def.options.type
	end
	if def.options.dependencies ~= nil then
		return 'general'
	end
	for _, page in ipairs(def.pages) do
		if not string.match(page, '%.css$') then
			return 'general'
		end
	end
	return 'styles'
end

p.get_usage = function(name)
	name = name:gsub("_", " ")

	local success, tabData = pcall(mw.ext.data.get, 'GadgetUsage.tab')
	if not success or not tabData or not tabData.data then
		return -1
	end

	for _, row in ipairs(tabData.data) do
		if row[1] == name then
			return tonumber(row[2]) or -1
		end
	end

	return -1
end

return p