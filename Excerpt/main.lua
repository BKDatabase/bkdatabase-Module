-- Module:Excerpt implements the Excerpt template
-- Documentation and master version: https://en.wikipedia.org/wiki/Module:Excerpt
-- Authors: User:Sophivorus, User:Certes, User:Aidan9382 & others
-- License: CC-BY-SA-3.0

local parser = require( 'Module:WikitextParser' )
local yesno = require( 'Module:Yesno' )

local ok, config = pcall( require, 'Module:Excerpt/config' )
if not ok then config = {} end

local Excerpt = {}

-- Main entry point for templates
function Excerpt.main( frame )

	-- Make sure the requested page exists and get the wikitext
	local page = Excerpt.getArg( 1 )
	if not page or page == '{{{1}}}' then return Excerpt.getError( 'no-page' ) end
	local title = mw.title.new( page )
	if not title then return Excerpt.getError( 'invalid-title', page ) end
	local fragment = title.fragment -- save for later
	if title.isRedirect then
		title = title.redirectTarget
		if fragment == "" then
			fragment = title.fragment -- page merge potential	
		end
	end
	if not title.exists then return Excerpt.getError( 'page-not-found', page ) end
	page = title.prefixedText
	local wikitext = title:getContent()

	-- Get the template params and process them
	local params = {
		hat = yesno( Excerpt.getArg( 'hat', true ) ),
		this = Excerpt.getArg( 'this' ),
		only = Excerpt.getArg( 'only' ),
		files = Excerpt.getArg( 'files', Excerpt.getArg( 'file' ) ),
		lists = Excerpt.getArg( 'lists', Excerpt.getArg( 'list' ) ),
		tables = Excerpt.getArg( 'tables', Excerpt.getArg( 'table' ) ),
		templates = Excerpt.getArg( 'templates', Excerpt.getArg( 'template' ) ),
		paragraphs = Excerpt.getArg( 'paragraphs', Excerpt.getArg( 'paragraph' ) ),
		references = yesno( Excerpt.getArg( 'references', true ) ),
		subsections = yesno( Excerpt.getArg( 'subsections', false ) ),
		links = yesno( Excerpt.getArg( 'links', true ) ),
		bold = yesno( Excerpt.getArg( 'bold', false ) ),
		briefDates = yesno( Excerpt.getArg( 'briefdates', false ) ),
		inline = yesno( Excerpt.getArg( 'inline' ) ),
		quote = yesno( Excerpt.getArg( 'quote' ) ),
		more = yesno( Excerpt.getArg( 'more' ) ),
		class = Excerpt.getArg( 'class' ),
		track = yesno( Excerpt.getArg( 'track', true ) ),
		displayTitle = Excerpt.getArg( 'displaytitle', page ),
	}

	-- Make sure the requested section exists and get the excerpt
	local excerpt
	local section = Excerpt.getArg( 2, fragment )
	section = mw.text.trim( section )
	if section == '' then section = nil end
	if section then
		excerpt = parser.getSectionTag( wikitext, section )
		if not excerpt then
			if params.subsections then
				excerpt = parser.getSection( wikitext, section )
			else
				local sections = parser.getSections( wikitext )
				excerpt = sections[ section ]
			end
		end
		if not excerpt then return Excerpt.getError( 'section-not-found', section ) end
		if excerpt == '' then return Excerpt.getError( 'section-empty', section ) end
	else
		excerpt = parser.getLead( wikitext )
		if excerpt == '' then return Excerpt.getError( 'lead-empty' ) end
	end

	-- Remove noinclude bits
	excerpt = excerpt:gsub( '<[Nn][Oo][Ii][Nn][Cc][Ll][Uu][Dd][Ee]>.-</[Nn][Oo][Ii][Nn][Cc][Ll][Uu][Dd][Ee]>', '' )

	-- Filter various elements from the excerpt
	excerpt = Excerpt.filterFiles( excerpt, params.files )
	excerpt = Excerpt.filterLists( excerpt, params.lists )
	excerpt = Excerpt.filterTables( excerpt, params.tables )
	excerpt = Excerpt.filterParagraphs( excerpt, params.paragraphs )

	-- If no file is found, try to get one from the infobox
	if ( params.only == 'file' or params.only == 'files' or not params.only and ( not params.files or params.files ~= '0' ) ) -- caller asked for files
		and not section -- and we're in the lead section
		and config.captions -- and we have the config option required to try finding files in infoboxes
		and #parser.getFiles( excerpt ) == 0 -- and there're no files in the excerpt
	then
		excerpt = Excerpt.addInfoboxFile( excerpt )
	end

	-- Filter the templates by appending the templates blacklist to the templates filter
	if config.blacklist then
		local blacklist = table.concat( config.blacklist, ',' )
		if params.templates then
			if string.sub( params.templates, 1, 1 ) == '-' then
				params.templates = params.templates .. ',' .. blacklist
			end
		else
			params.templates = '-' .. blacklist
		end
	end
	excerpt = Excerpt.filterTemplates( excerpt, params.templates )

	-- Leave only the requested elements
	if params.only == 'file' or params.only == 'files' then
		local files = parser.getFiles( excerpt )
		excerpt = params.only == 'file' and files[1] or table.concat( files, '\n\n' )
	end
	if params.only == 'list' or params.only == 'lists' then
		local lists = parser.getLists( excerpt )
		excerpt = params.only == 'list' and lists[1] or table.concat( lists, '\n\n' )
	end
	if params.only == 'table' or params.only == 'tables' then
		local tables = parser.getTables( excerpt )
		excerpt = params.only == 'table' and tables[1] or table.concat( tables, '\n\n' )
	end
	if params.only == 'paragraph' or params.only == 'paragraphs' then
		local paragraphs = parser.getParagraphs( excerpt )
		excerpt = params.only == 'paragraph' and paragraphs[1] or table.concat( paragraphs, '\n\n' )
	end
	if params.only == 'template' or params.only == 'templates' then
		local templates = parser.getTemplates( excerpt )
		excerpt = params.only == 'template' and templates[1] or table.concat( templates, '\n\n' )
	end

	-- @todo Make more robust and move downwards
	if params.briefDates then
		excerpt = Excerpt.fixDates( excerpt )
	end

	-- Remove unwanted elements
	excerpt = Excerpt.removeComments( excerpt )
	excerpt = Excerpt.removeSelfLinks( excerpt )
	excerpt = Excerpt.removeNonFreeFiles( excerpt )
	excerpt = Excerpt.removeBehaviorSwitches( excerpt )

	-- Fix or remove the references
	if params.references then
		excerpt = Excerpt.fixReferences( excerpt, page, wikitext )
	else
		excerpt = Excerpt.removeReferences( excerpt )
	end

	-- Remove wikilinks
	if not params.links then
		excerpt = Excerpt.removeLinks( excerpt )
	end

	-- Link the bold text near the start of most leads and then remove it
	if not section then
		excerpt = Excerpt.linkBold( excerpt, page )
	end
	if not params.bold then
		excerpt = Excerpt.removeBold( excerpt )
	end

	-- Remove extra line breaks but leave one before and after so the parser interprets lists, tables, etc. correctly
	excerpt = excerpt:gsub( '\n\n\n+', '\n\n' )
	excerpt = mw.text.trim( excerpt )
	excerpt = '\n' .. excerpt .. '\n'

	-- Remove nested categories
	excerpt = frame:preprocess( excerpt )
	excerpt = Excerpt.removeCategories( excerpt )

	-- Add tracking categories
	if params.track and config.categories then
		excerpt = Excerpt.addTrackingCategories( excerpt )
	end

	-- Build the final output
	if params.inline then
		return mw.text.trim( excerpt )
	end

	local tag = params.quote and 'blockquote' or 'div'
	local block = mw.html.create( tag ):addClass( 'excerpt-block' ):addClass( params.class )

	if config.styles then
		local styles = frame:extensionTag( 'templatestyles', '', { src = config.styles } )
		block:node( styles )
	end

	if params.hat then
		local hat = Excerpt.getHat( page, section, params )
		block:node( hat )
	end

	excerpt = mw.html.create( 'div' ):addClass( 'excerpt' ):wikitext( excerpt )
	block:node( excerpt )

	if params.more then
		local more = Excerpt.getReadMore( page, section )
		block:node( more )
	end

	return block
end

-- Filter the files in the given wikitext against the given filter
function Excerpt.filterFiles( wikitext, filter )
	if not filter then return wikitext end
	local filters, isBlacklist = Excerpt.parseFilter( filter )
	local files = parser.getFiles( wikitext )
	for index, file in pairs( files ) do
		local name = parser.getFileName( file )
		if isBlacklist and ( Excerpt.matchFilter( index, filters ) or Excerpt.matchFilter( name, filters ) )
		or not isBlacklist and ( not Excerpt.matchFilter( index, filters ) and not Excerpt.matchFilter( name, filters ) ) then 
			wikitext = Excerpt.removeString( wikitext, file )
		end
	end
	return wikitext
end

-- Filter the lists in the given wikitext against the given filter
function Excerpt.filterLists( wikitext, filter )
	if not filter then return wikitext end
	local filters, isBlacklist = Excerpt.parseFilter( filter )
	local lists = parser.getLists( wikitext )
	for index, list in pairs( lists ) do
		if isBlacklist and Excerpt.matchFilter( index, filters )
		or not isBlacklist and not Excerpt.matchFilter( index, filters ) then 
			wikitext = Excerpt.removeString( wikitext, list )
		end
	end
	return wikitext
end

-- Filter the tables in the given wikitext against the given filter
function Excerpt.filterTables( wikitext, filter )
	if not filter then return wikitext end
	local filters, isBlacklist = Excerpt.parseFilter( filter )
	local tables = parser.getTables( wikitext )
	for index, tableWikitext in pairs( tables ) do
		local id = parser.getTableAttribute( tableWikitext, 'id' )
		if isBlacklist and ( Excerpt.matchFilter( index, filters ) or Excerpt.matchFilter( id, filters ) )
		or not isBlacklist and ( not Excerpt.matchFilter( index, filters ) and not Excerpt.matchFilter( id, filters ) ) then 
			wikitext = Excerpt.removeString( wikitext, tableWikitext )
		end
	end
	return wikitext
end

-- Filter the paragraphs in the given wikitext against the given filter
function Excerpt.filterParagraphs( wikitext, filter )
	if not filter then return wikitext end
	local filters, isBlacklist = Excerpt.parseFilter( filter )
	local paragraphs = parser.getParagraphs( wikitext )
	for index, paragraph in pairs( paragraphs ) do
		if isBlacklist and Excerpt.matchFilter( index, filters )
		or not isBlacklist and not Excerpt.matchFilter( index, filters ) then 
			wikitext = Excerpt.removeString( wikitext, paragraph )
		end
	end
	return wikitext
end

-- Filter the templates in the given wikitext against the given filter
function Excerpt.filterTemplates( wikitext, filter )
	if not filter then return wikitext end
	local filters, isBlacklist = Excerpt.parseFilter( filter )
	local templates = parser.getTemplates( wikitext )
	for index, template in pairs( templates ) do
		local name = parser.getTemplateName( template )
		if isBlacklist and ( Excerpt.matchFilter( index, filters ) or Excerpt.matchFilter( name, filters ) )
		or not isBlacklist and ( not Excerpt.matchFilter( index, filters ) and not Excerpt.matchFilter( name, filters ) ) then 
			wikitext = Excerpt.removeString( wikitext, template )
		end
	end
	return wikitext
end

function Excerpt.addInfoboxFile( excerpt )
	-- We cannot distinguish the infobox from the other templates, so we search them all
	local templates = parser.getTemplates( excerpt )
	for _, template in pairs( templates ) do
		local parameters = parser.getTemplateParameters( template )
		local file, captions, caption, cssClasses, cssClass
		for _, pair in pairs( config.captions ) do
			file = pair[1]
			file = parameters[file]
			if file and Excerpt.matchAny( file, '^.*%.', { '[Jj][Pp][Ee]?[Gg]', '[Pp][Nn][Gg]', '[Gg][Ii][Ff]', '[Ss][Vv][Gg]' }, '.*' ) then
				file = string.match( file, '%[?%[?.-:([^{|]+)%]?%]?' ) or file -- [[File:Example.jpg{{!}}upright=1.5]] to Example.jpg
				captions = pair[2]
				for _, p in pairs( captions ) do
					if parameters[ p ] then caption = parameters[ p ] break end
				end
				-- Check for CSS classes
				-- We opt to use skin-invert-image instead of skin-invert
				-- in all other cases, the CSS provided in the infobox is used
				if pair[3] then
					cssClasses = pair[3]
					for _, p in pairs( cssClasses ) do
						if parameters[ p ] then
							cssClass = ( parameters[ p ] == 'skin-invert' ) and 'skin-invert-image' or parameters[ p ]
							break
						end
					end
				end
				local class = cssClass and ( '|class=' .. cssClass ) or ''
				return '[[File:' .. file .. class .. '|thumb|' .. ( caption or '' ) .. ']]' .. excerpt
			end
		end
	end
	return excerpt
end

function Excerpt.removeNonFreeFiles( wikitext )
	local files = parser.getFiles( wikitext )
	for _, file in pairs( files ) do
		local fileName = 'File:' .. parser.getFileName( file )
		local fileTitle = mw.title.new( fileName )
		if fileTitle then
			local fileDescription = fileTitle:getContent()
			if not fileDescription or fileDescription == '' then
				local frame = mw.getCurrentFrame()
				fileDescription = frame:preprocess( '{{' .. fileName .. '}}' ) -- try Commons
			end
			if fileDescription and string.match( fileDescription, '[Nn]on%-free' ) then
				wikitext = Excerpt.removeString( wikitext, file )
			end
		end
	end
	return wikitext
end

function Excerpt.getHat( page, section, params )
	local hat

	-- Build the text
	if params.this then
		hat = params.this
	elseif params.quote then
		hat = Excerpt.getMessage( 'this' )
	elseif params.only then
		hat = Excerpt.getMessage( params.only )
	else
		hat = Excerpt.getMessage( 'section' )
	end
	hat = hat .. ' ' .. Excerpt.getMessage( 'excerpt' )

	-- Build the link
	if section then
		hat = hat .. ' [[:' .. page .. '#' .. mw.uri.anchorEncode( section ) .. '|' .. params.displayTitle
			.. ' § ' .. section:gsub( '%[%[([^]|]+)|?[^]]*%]%]', '%1' ) .. ']].' -- remove nested links
	else
		hat = hat .. ' [[:' .. page .. '|' .. params.displayTitle .. ']].'
	end

	-- Build the edit link
	local title = mw.title.new( page )
	local editUrl = title:fullUrl( 'action=edit' )
	hat = hat .. '<span class="mw-editsection-like plainlinks"><span class="mw-editsection-bracket">[</span>['
	hat = hat .. editUrl .. ' ' .. mw.message.new( 'editsection' ):plain()
	hat = hat .. ']<span class="mw-editsection-bracket">]</span></span>'

	if config.hat then
		local frame = mw.getCurrentFrame()
		hat = config.hat .. hat .. '}}'
		hat = frame:preprocess( hat )
	else
		hat = mw.html.create( 'div' ):addClass( 'dablink excerpt-hat' ):wikitext( hat )
	end

	return hat
end

function Excerpt.getReadMore( page, section )
	local link = "'''[[" .. page
	if section then
		link = link .. '#' .. section
	end
	local text = Excerpt.getMessage( 'more' )
	link = link .. '|' .. text .. "]]'''"
	link = mw.html.create( 'div' ):addClass( 'noprint excerpt-more' ):wikitext( link )
	return link
end

-- Fix birth and death dates, but only in the first paragraph
-- @todo Use parser.getParagraphs() to get the first paragraph
function Excerpt.fixDates( excerpt )
	local start = 1 -- skip initial templates
	local s
	local e = 0
	repeat
		start = e + 1
		s, e = mw.ustring.find( excerpt, '%s*%b{}%s*', start )
	until not s or s > start
	s, e = mw.ustring.find( excerpt, '%b()', start ) -- get (...), which may be (year–year)
	if s and s < start + 100 then -- look only near the start
		local excerptStart = mw.ustring.sub( excerpt, s, e )
		local year1, conjunction, year2 = string.match( excerptStart, '(%d%d%d+)(.-)(%d%d%d+)' )
		if year1 and year2 and ( string.match( conjunction, '[%-–—]' ) or string.match( conjunction, '{{%s*[sS]nd%s*}}' ) ) then
			local y1 = tonumber( year1 )
			local y2 = tonumber( year2 )
			if y2 > y1 and y2 < y1 + 125 and y1 <= tonumber( os.date( '%Y' ) ) then
				excerpt = mw.ustring.sub( excerpt, 1, s ) .. year1 .. '–' .. year2 .. mw.ustring.sub( excerpt, e )
			end
		end
	end
	return excerpt
end

-- Replace the first call to each reference defined outside of the excerpt for the full reference, to prevent undefined references
-- Then prefix the page title to the reference names to prevent conflicts
-- that is, replace <ref name="Foo"> for <ref name="Title of the article Foo">
-- and also <ref name="Foo" /> for <ref name="Title of the article Foo" />
-- also remove reference groups: <ref name="Foo" group="Bar"> for <ref name="Title of the article Foo">
-- and <ref group="Bar"> for <ref>
-- @todo The current regex may fail in cases with both kinds of quotes, like <ref name="Darwin's book">
function Excerpt.fixReferences( excerpt, page, wikitext )
	local references = parser.getReferences( excerpt )
	local fixed = {}
	for _, reference in pairs( references ) do
		local name = parser.getTagAttribute( reference, 'name' )
		if not fixed[ name ] then -- fix each reference only once
			local content = parser.getTagContent( reference )
			if not content then -- reference is self-closing
				local full = parser.getReference( excerpt, name )
				if not full then -- the reference is not defined in the excerpt
					full = parser.getReference( wikitext, name )
					if full then
						excerpt = excerpt:gsub( Excerpt.escapeString( reference ), Excerpt.escapeString( full ), 1 )
					end
					table.insert( fixed, name )
				end
			end
		end
	end
	-- Prepend the page title to the reference names to prevent conflicts with other references in the transcluding page
	excerpt = excerpt:gsub( '< *[Rr][Ee][Ff][^>]*name *= *["\']?([^"\'>/]+)["\']?[^>/]*(/?) *>', '<ref name="' .. page:gsub( '"', '' ) .. ' %1"%2>' )
	-- Remove reference groups because they don't apply to the transcluding page
	excerpt = excerpt:gsub( '< *[Rr][Ee][Ff] *group *= *["\']?[^"\'>/]+["\'] *>', '<ref>' )
	return excerpt
end

function Excerpt.removeReferences( excerpt )
	local references = parser.getReferences( excerpt )
	for _, reference in pairs( references ) do
		excerpt = Excerpt.removeString( excerpt, reference )
	end
	return excerpt
end

function Excerpt.removeCategories( excerpt )
	local categories = parser.getCategories( excerpt )
	for _, category in pairs( categories ) do
		excerpt = Excerpt.removeString( excerpt, category )
	end
	return excerpt
end

function Excerpt.removeBehaviorSwitches( excerpt )
	return excerpt:gsub( '__[A-Z]+__', '' )
end

function Excerpt.removeComments( excerpt )
	return excerpt:gsub( '<!%-%-.-%-%->', '' )
end

function Excerpt.removeBold( excerpt )
	return excerpt:gsub( "'''", '' )
end

function Excerpt.removeLinks( excerpt )
	local links = parser.getLinks( excerpt )
	for _, link in pairs( links ) do
		excerpt = Excerpt.removeString( excerpt, link )
	end
	return excerpt
end

-- @todo Use parser.getLinks
function Excerpt.removeSelfLinks( excerpt )
	local lang = mw.language.getContentLanguage()
	local page = Excerpt.escapeString( mw.title.getCurrentTitle().prefixedText )
	local ucpage = lang:ucfirst( page )
	local lcpage = lang:lcfirst( page )
	excerpt = excerpt
		:gsub( '%[%[(' .. ucpage .. ')%]%]', '%1' )
		:gsub( '%[%[(' .. lcpage .. ')%]%]', '%1' )
		:gsub( '%[%[' .. ucpage .. '|([^]]+)%]%]', '%1' )
		:gsub( '%[%[' .. lcpage .. '|([^]]+)%]%]', '%1' )
	return excerpt
end

-- Replace the bold title or synonym near the start of the page by a link to the page
function Excerpt.linkBold( excerpt, page )
	local lang = mw.language.getContentLanguage()
	local position = mw.ustring.find( excerpt, "'''" .. lang:ucfirst( page ) .. "'''", 1, true ) -- look for "'''Foo''' is..." (uc) or "A '''foo''' is..." (lc)
		or mw.ustring.find( excerpt, "'''" .. lang:lcfirst( page ) .. "'''", 1, true ) -- plain search: special characters in page represent themselves
	if position then
		local length = mw.ustring.len( page )
		excerpt = mw.ustring.sub( excerpt, 1, position + 2 ) .. '[[' .. mw.ustring.sub( excerpt, position + 3, position + length + 2 ) .. ']]' .. mw.ustring.sub( excerpt, position + length + 3, -1 ) -- link it
	else -- look for anything unlinked in bold, assumed to be a synonym of the title (e.g. a person's birth name)
		excerpt = mw.ustring.gsub( excerpt, "'''(.-'*)'''", function ( text )
			if not string.find( text, '%[' ) and not string.find( text, '%{' ) then -- if not wikilinked or some weird template
				return "'''[[" .. page .. '|' .. text .. "]]'''" -- replace '''Foo''' by '''[[page|Foo]]'''
			else
				return nil -- instruct gsub to make no change
			end
		end, 1 ) -- terminates the anonymous replacement function passed to gsub
	end
	return excerpt
end

function Excerpt.addTrackingCategories( excerpt )
	local currentTitle = mw.title.getCurrentTitle()
	local addedCategories = false
	local contentCategory = config.categories.content
	if contentCategory and currentTitle.isContentPage then
		addedCategories = true
		excerpt = excerpt .. '[[Category:' .. contentCategory .. ']]'
	end
	local namespaceCategory = config.categories[ currentTitle.namespace ]
	if namespaceCategory then
		addedCategories = true
		excerpt = excerpt .. '[[Category:' .. namespaceCategory .. ']]'
	end
	if addedCategories then
		excerpt = excerpt .. '\n'
	end
	return excerpt
end

-- Helper method to match from a list of regular expressions
-- Like so: match pre..list[1]..post or pre..list[2]..post or ...
function Excerpt.matchAny( text, pre, list, post, init )
	local match = {}
	for i = 1, #list do
		match = { mw.ustring.match( text, pre .. list[ i ] .. post, init ) }
		if match[1] then return unpack( match ) end
	end
	return nil
end

-- Helper function to get arguments
-- args from Lua calls have priority over parent args from template
function Excerpt.getArg( key, default )
	local frame = mw.getCurrentFrame()
	for k, value in pairs( frame:getParent().args ) do
		if k == key and mw.text.trim( value ) ~= '' then
			return value
		end
	end
	for k, value in pairs( frame.args ) do
		if k == key and mw.text.trim( value ) ~= '' then
			return value
		end
	end
	return default
end

-- Helper method to get an error message
-- This method also categorizes the current page in one of the configured error categories
function Excerpt.getError( key, value )
	local message = Excerpt.getMessage( 'error-' .. key, value )
	local markup = mw.html.create( 'div' ):addClass( 'error' ):wikitext( message )
	if config.categories and config.categories.errors and mw.title.getCurrentTitle().isContentPage then
		markup:node( '[[Category:' .. config.categories.errors .. ']]' )
	end
	return markup
end

-- Helper method to get a localized message
-- This method uses Module:TNT to get localized messages from https://commons.wikimedia.org/wiki/Data:I18n/Module:Excerpt.tab
-- If Module:TNT is not available or the localized message does not exist, the key is returned instead
function Excerpt.getMessage( key, value )
	local ok, TNT = pcall( require, 'Module:TNT' )
	if not ok then return key end
	local ok2, message = pcall( TNT.format, 'I18n/Module:Excerpt.tab', key, value )
	if not ok2 then return key end
	return message
end

-- Helper method to escape a string for use in regexes
function Excerpt.escapeString( str )
	return str:gsub( '[%^%$%(%)%.%[%]%*%+%-%?%%]', '%%%0' )
end

-- Helper method to remove a string from a text
-- @param text Text from where to remove the string
-- @param str String to remove
-- @return The given text with the string removed
function Excerpt.removeString( text, str )
	local pattern = Excerpt.escapeString( str )
	if #pattern > 9999 then -- strings longer than 10000 bytes can't be put into regexes
		pattern = Excerpt.escapeString( mw.ustring.sub( str, 1, 999 ) ) .. '.-' .. Excerpt.escapeString( mw.ustring.sub( str, -999 ) )
	end
	return text:gsub( pattern, '' )
end

-- Helper method to convert a comma-separated list of numbers or min-max ranges into a list of booleans
-- @param filter Required. Comma-separated list of numbers or min-max ranges, for example '1,3-5'
-- @return Map from integers to booleans, for example {1=true,2=false,3=true,4=true,5=true}
-- @return Boolean indicating whether the filters should be treated as a blacklist or not
-- @note Merging this into matchFilter is possible, but way too inefficient
function Excerpt.parseFilter( filter )
	local filters = {}
	local isBlacklist = false
	if string.sub( filter, 1, 1 ) == '-' then
		isBlacklist = true
		filter = string.sub( filter, 2 )
	end
	local values = mw.text.split( filter, ',' ) -- split values: '1,3-5' to {'1','3-5'}
	for _, value in pairs( values ) do
		value = mw.text.trim( value )
		local min, max = mw.ustring.match( value, '^(%d+)%s*[-–—]%s*(%d+)$' ) -- '3-5' to min=3 max=5
		if not max then min, max = string.match( value, '^((%d+))$' ) end -- '1' to min=1 max=1
		if max then
			for i = min, max do filters[ i ] = true end
		else
			filters[ value ] = true -- if we reach this point, the string had the form 'a,b,c' rather than '1,2,3'
		end
	end
	local filter = {cache = {}, terms = filters}
	return filter, isBlacklist
end

-- Helper function to see if a value matches any of the given filters
function Excerpt.matchFilter( value, filter )
	if value == nil then
		return false
	elseif type(value) == "number" then
		return filter.terms[value]
	else
		local cached = filter.cache[value]
		if cached ~= nil then
			return cached
		end
		local lang = mw.language.getContentLanguage()
		local lcvalue = lang:lcfirst(value)
		local ucvalue = lang:ucfirst(value)
		for term in pairs( filter.terms ) do
			if value == tostring(term)
			or type(term) == "string" and (
				lcvalue == term
				or ucvalue == term
				or mw.ustring.match( value, term )
			) then
				filter.cache[value] = true
				return true
			end
		end
		filter.cache[value] = false
	end
end

return Excerpt
