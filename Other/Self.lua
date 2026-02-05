-- .___  ___.   ______    _______   __    __   __       _______        _______. _______  __       _______ 
-- |   \/   |  /  __  \  |       \ |  |  |  | |  |     |   ____| _    /       ||   ____||  |     |   ____|
-- |  \  /  | |  |  |  | |  .--.  ||  |  |  | |  |     |  |__   (_)  |   (----`|  |__   |  |     |  |__   
-- |  |\/|  | |  |  |  | |  |  |  ||  |  |  | |  |     |   __|        \   \    |   __|  |  |     |   __|  
-- |  |  |  | |  `--'  | |  '--'  ||  `--'  | |  `----.|  |____  _.----)   |   |  |____ |  `----.|  |     
-- |__|  |__|  \______/  |_______/  \______/  |_______||_______|(_)_______/    |_______||_______||__|     
                                                                                                       
-- Written by [[c:user:jarekt]]
 
-- Original Template:Self used the following templates and modules:
-- * Template:Dir
-- * Template:Lang
-- * Template:License migration is redundant
-- * Template:License migration is redundant multiple
-- * Template:Self/is-pd-expired
-- * Template:SDC statement exist
-- * Module:SDC tracking

require('strict') -- used for debugging purposes as it detects cases of unintended global variables
local p = {}

-------------------------------------------------------------------------------
local function normalize_input_args(input_args, output_args)
	for name, value in pairs( input_args ) do 
		value = mw.text.trim(value) -- trim whitespaces from the beggining and the end of the string
		if value ~= '' then -- nuke empty strings
			if type(name)=='string' then 
				name =  string.lower(name)
			end
			output_args[name] = value
		end
	end
	return output_args
end

-------------------------------------------------------------------------------
local function startswith(name, str) 
	-- test if strings starts with "str"
	 return (string.sub(name,1,string.len(str))==str)
end

-------------------------------------------------------------------------------
local function license_migration_is_redundant(name)
	-- Lua version of Template:License migration is redundant
	name = string.lower(name)
	return (startswith(name, 'cc-by-3.0' ) 
		 or startswith(name, 'cc-by-sa-3.0') 
		 or name=='cc-by-4.0' 		 or name=='cc-by-all'
		 or name=='cc-by-sa-4.0'	 or name=='cc-by-sa-all'
		 or name=='cc-by-sa-any'	 or name=='cc-by-sa-1.0+'
		 or name=='cc-by-sa-2.0+'	 or name=='cc-by-sa-4.0,3.0,2.5,2.0,1.0')
end

-------------------------------------------------------------------------------
local function pd_is_expired(name)
	-- Lua version of [[Template:Self/is-pd-expired]]
	name = string.lower(name)
	return (startswith(name, 'pd-us-') or startswith(name, 'pd-old') or startswith(name, 'pd-anon') 
		or name=='pd-us' or name=='pd-1923' or name=='pd-canada-anon' or name=='anonymous-eu')
end

-------------------------------------------------------------------------------
function p.main(frame)    
	-- parse inputs
	local args, sargs = {}, {}
	args = normalize_input_args(frame:getParent().args, args)
	args = normalize_input_args(frame.args, args)
	local lang = args.lang or frame:callParserFunction("int","lang")  -- get user's chosen language
	local dir  = mw.language.new( lang ):getDir()                     -- get text direction
	local page = mw.title.getCurrentTitle()
	local namespace = page.namespace                                  -- get page namespace
	local author = args.author
	
	-- evaluate numbered inputs
	local tag = {}
	local ntag = 0 -- will count numbered inputs
	local pd_expired = false -- Do we have any public domain tags due to expiration 
	local redundant  = false
	for label, value in pairs( args ) do -- loop through numbered variables
		if (type(label)=='number' and value~='Self') then 
			ntag = ntag+1
			tag[ntag]  = value
			pd_expired = pd_expired or pd_is_expired(tag[ntag])
			redundant  = redundant  or license_migration_is_redundant(tag[ntag])
		elseif (type(label)=='string') then 
			sargs[label] = args[label]
		end
	end
	
	-- One of the tags indicate public domain work not released by the author
	local output, cats = {}, {}
	local msg
	if pd_expired then
		msg = mw.message.new( 'wm-license-self-invalid-parameter'):inLanguage(lang):plain()
		msg = mw.ustring.format('<div class="error" style="text-align:center; font-weight:bold;">%s</div>', msg)
		table.insert(output, msg)
		table.insert(cats, '[[Category:Files with invalid parameter in Self template]]')
	end

	-- get proper header, like ("I, the copyright holder of this work, hereby publish it under the following license:")
	if (ntag>1 and author) then
		msg = mw.message.new( 'wm-license-self-multiple-licenses-with-author', author)
	elseif (ntag==1 and author) then
		msg = mw.message.new( 'wm-license-self-one-license-with-author', author)
	elseif (ntag>1) then -- no author
		msg = mw.message.new( 'wm-license-self-multiple-licenses')
	else -- ntag==1 and no author
		msg = mw.message.new( 'wm-license-self-one-license')
	end
	msg = msg:inLanguage(lang):plain()
	local lang_fmt = '<div lang="%s" dir="%s" class="description %s" style="display:inline;">%s</div>'
	msg = mw.ustring.format(lang_fmt, lang, dir, lang, msg)
	msg = mw.ustring.format('<div class="center" style="font-weight:bold;">%s</div>', msg)
	table.insert(output, msg)
	
	-- render license templates
	sargs.attribution = args.attribution or author
	if not args.migration and redundant then
		sargs.migration='redundant'
	end
	for i=1,ntag do 
		table.insert(output, frame:expandTemplate{ title = tag[i], args=sargs } )
	end
	
	-- extra message if multiple templates present ("You may select the license of your choice.")
	if (ntag>1) then
		msg = mw.message.new( 'wm-license-self-multiple-licenses-select'):inLanguage(lang):plain()
		msg = mw.ustring.format(lang_fmt, lang, dir, lang, msg)
		msg = mw.ustring.format('<div class="center">%s</div>', msg)
		table.insert(output, msg)
	end
	
	-- assemble the final template and save as string
	local results = table.concat(output,'\n')
	msg = '<div style="clear:both; margin:0.5em auto; background-color:#061016; color:inherit; border:2px solid #4DB6B0; padding:8px; direction:%s; " class="licensetpl_wrapper">%s</div>'
	results = mw.ustring.format(msg, dir, results)
	
	-- If used in files then add some categories if needed
	if namespace==6 then
		table.insert(cats, '[[Category:Self-published work]]')
		local entity = mw.wikibase.getEntity()
	end
	return results
end

return p
