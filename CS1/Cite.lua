require ('strict');

local cfg = mw.loadData ('Module:Cite/config');


--[[--------------------------< S U B S T I T U T E >----------------------------------------------------------

Substitutes $1, $2, etc in <message> with data from <data_t>. Returns plain-text substituted string when
<data_t> not nil; returns <message> else.

]]

local function substitute (message, data_t)
	return data_t and mw.message.newRawMessage (message, data_t):plain() or message;
end


--[[--------------------------< M A K E _ E R R O R _ M S G >--------------------------------------------------

Assembles an error message from module name, message text, help link, and error category.

]]

local function make_error_msg (frame, msg)
	local module_name = frame:getTitle();										-- get the module name for prefix and help-link label
	local namespace = mw.title.getCurrentTitle().namespace;						-- used for categorization

	local category_link = (0 == namespace) and substitute ('[[Category:$1]]', {cfg.settings_t.err_category}) or '';
	return substitute ('<span style="color:#d33">Error: &#x7B;{[[$1|#invoke:$2]]}}: $3 ([[:$4|$5]])</span>$6',
		{
		module_name,															-- the module name with namespace
		module_name:gsub ('Module:', ''),										-- the module name without namespace
		msg,																	-- the error message
		cfg.settings_t.help_text_link,											-- help wikilink to text at help page
		cfg.settings_t.help,													-- help wikilink display text
		category_link															-- link to error category (for main namespace errors only)
		})
end
	

--[[--------------------------< C I T E >---------------------------------------------------------------------

Function to call Module:Citation/CS1/sandbox with appropriate parameters.  For use when an article exceeds the
post-expand include size limit.

	{{#invoke:cite|book|title=Title}}

]]

local function cite (frame, template)
	local args_t = require ('Module:Arguments').getArgs (frame, {frameOnly=true});

	template = template:lower();												-- lowercase for table indexes
	
	if not cfg.known_templates_t[template] then									-- do we recognize this template name?
		return make_error_msg (frame, substitute (cfg.settings_t.unknown_name, {template}));	-- nope; abandon with error message
	end

	local config_t = {['CitationClass'] = cfg.citation_classes_t[template] or template};	-- set CitationClass value
	return require ('Module:Citation/CS1')._citation (nil, args_t, config_t);	-- go render the citation
end


--[[--------------------------< E X P O R T S >---------------------------------------------------------------
]]

return setmetatable({}, {__index =												-- returns an empty TABLE whose metatable has the __index set so that, for any given KEY, it returns
	function(_, template)														-- this anonymous function called as function(TABLE, KEY)
		return function (frame) return cite (frame, template) end;				-- which in turn returns a function that calls cite() with the KEY name
	end
})
