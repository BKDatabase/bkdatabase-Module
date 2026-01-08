require ('strict');

local get_args = require ('Module:Arguments').getArgs;
local identifiers = require ('Module:Citation/CS1/Identifiers');
local utilities = require ('Module:Citation/CS1/Utilities');
	local has_accept_as_written = utilities.has_accept_as_written;				-- import functions from Module:Citation/CS1/Utilities
	local is_set = utilities.is_set;
	local make_wikilink = utilities.make_wikilink;
	local set_message = utilities.set_message;
	local substitute = utilities.substitute;

local cfg = mw.loadData ('Module:Citation/CS1/Configuration');

utilities.set_selected_modules (cfg);											-- so that functions in Utilities can see the selected cfg tables
identifiers.set_selected_modules (cfg, utilities);								-- so that functions in Identifiers can see the selected cfg tables and selected Utilities module

local Frame;																	-- local copy of <frame> from main(); nil else
local this_page = mw.title.getCurrentTitle();									-- used to limit categorization to certain namepsaces

local no_cat;																	-- used to limit categorization to certain namespaces
if cfg.uncategorized_namespaces[this_page.namespace] then						-- is this page's namespace id one of the uncategorized namespace ids?
	no_cat = true;																-- set no_cat; this page will not be categorized
end
for _, v in ipairs (cfg.uncategorized_subpages) do								-- cycle through page name patterns
	if this_page.text:match (v) then											-- test page name against each pattern
		no_cat = true;															-- set no_cat; this page will not be categorized
		break;																	-- bail out if one is found
	end
end


--[[--------------------------< E R R _ M E S S A G E _ C O N V E R T >----------------------------------------

converts cs1|2 error message to a message suitable for this module.

converted error messages do not name a parameter as is done in cs1|2.  The help link links to the template page
not to a help-namespace page.  The prefix is rewritten to name the offending template; not a cs1|2 template.

adds template specific category.

done this way because the identifier functions in Module:Citation/CS1/Identifiers create properly formatted
messages with correct html for styling.

]]

local function err_message_convert (message_prefix, message, _template, no_cat)
	message = message:gsub ('&#124;([^=]+)=', '%1');							-- remove parameter pipe and assignment operator
	message = message:gsub ('Help:CS1 errors#[^%]]+', substitute ('Template:$1|help', _template));	-- rewrite help text
	message = message:gsub ('(%b<>)', substitute ('$1$2: ', {'%1', message_prefix}), 1);	-- %1 is the opening span tag; insert <message_prefix>
	local category = no_cat and '' or substitute ('[[Category:Pages with $1 errors]]', _template:upper());	-- limited to certain namespaces 
	return substitute ('$1$2', {message, category});							-- make a big string and done
end


--[[--------------------------< M A I N T _ M E S S A G E _ C O N V E R T >------------------------------------

converts cs1|2 maintenance message to a message suitable for this module.

converted maintenance messages have a prefix suitable for the rendered template.  The 'link' text links to the
an appropriate maintenance category

]]

local function maint_message_convert (message_prefix, message_raw, _template, no_cat)
	message_raw = message_raw:gsub ('CS1 maint: ', '');							-- strip cs1-specific prefix from cat name
	local message = substitute ('$1: $2', {message_prefix, message_raw});		-- add the template prefix
	message = substitute ('$1$2 ($3)', {
		message,
		no_cat and '' or substitute (cfg.messages['cat wikilink'], message_raw),-- the category link; limited to certain namespaces
		substitute (cfg.messages[':cat wikilink'], message_raw)}				-- links to the maint cat, just as cs1|2 links to its maint cats
		);
	return substitute (cfg.presentation['hidden-maint'], message);				-- the maint message text
end


--[[--------------------------< P A R A M S _ G E T >----------------------------------------------------------

extract enumerated parameters from <args_t> where the enumerator is <i>.  enumerator is always the last character
of the parameter name (doi-broken-date1 not doi1-broken-date)

special case the enumerator is 1: prefer non-enumerated parameters

returns a table of same-enumerator parameters (without enumerator) 

note: <i> is a number

]]

local function params_get (args_t, i)
--mw.logObject (args_t, 'args_t')
	local params_t = {};														-- selected parameters go in this table
	if 1 == i then																-- special case when enumerator (<i>) is 1
		for k, v in pairs (args_t) do											-- for each parameter
			if 'number' == type (k) then										-- if this is a positional parameter
				if 1 == k then													-- and its the first positional parameter
					params_t[1] = v;											-- save it
				end
			else																-- here for named parameters
				local enum = k:match ('%d+$');									-- extract the enumerator from the parameter's name; nil else
				if (not enum) or (1 == tonumber (enum)) then					-- when not enumerated or when enumerator is 1
					k = k:gsub ('%d+$', '');									-- remove the enumerator from parameter name
					params_t[k] = v;											-- and save this parameter
				end
			end
		end
	else
		for k, v in pairs (args_t) do											-- for each parameter
			if 'number' == type (k) then										-- if this is a positional parameter
				if i == k then													-- and is the desired positional parameter
					params_t[1] = v;											-- save it (as index number 1; not as index <i>)
				end
			else																-- here for named parameters
				local enum = k:match ('%d+$');									-- extract the parameter's enumerator; nil else
				if enum and (i == tonumber (enum)) then							-- when enumerated and the enumerator is same as requested
					k = k:gsub ('%d+$', '');									-- remove the enumerator from parameter name
					params_t[k] = v;											-- and save this parameter
				end
			end
		end
	end
--mw.logObject (params_t, 'params_t')
	return params_t;															-- and done
end


--[[--------------------------< R E N D E R _ F I N A L >------------------------------------------------------

this function applies cs1|2 template style sheet to a rendered identifier or error message

]]

local function render_final (output)
	if not Frame then															-- not set when this module called from another module
		Frame = mw.getCurrentFrame();											-- get the calling module's frame so that we can call extensionTag()
	end

	return substitute ('$1$2', {
		Frame:extensionTag ('templatestyles', '', {src='Module:Citation/CS1/styles.css'}),	-- apply templatestyles
		output																	-- to the rendered identifier or error message
		});

end


--[[--------------------------< _ M A I N >--------------------------------------------------------------------

entry point when called from another module; example:
	local rendered_identifier = require ('Module:CS1 identifiers')._main ({'10.4231/sommat', _template = 'doi', ['doi-access'] = 'free', ['doi-broken-date'] = 'June 2025'});

supported identifier templates are:
	{{arxiv}}	{{asin}}	{{bibcode}}	{{biorxiv}}		{{citeseerx}}	{{doi}}
	{{hdl}}		{{isbn}}	{{ismn}}	{{issn}}		{{jfm}}			{{jstor}}
	{{medrxiv}}	{{mr}}		{{oclc}}	{{ol}}			{{osti}}		{{pmc}}
	{{pmid}}	{{sbn}}		{{ssrn}}	{{s2cid}}		{{zbl}}

<args_t> is a table of all parameters needed to properly render the identifier

]]

local function _main (args_t)
	local ID_list_t = {};														-- sequence table of rendered identifiers
	local ID_list_coins_t = {};													-- table of identifiers and their values from args; key is same as cfg.id_handlers's key; COinS not supported in this module
	local template_name = args_t._template;
	local message_prefix;

	if not (template_name and cfg.id_handlers[template_name:upper()]) then
		error ('|_template= requires valid value');								-- a message for template writers; not seen by users
	end

	template_name = template_name:lower();										-- force lower case
	message_prefix = substitute ('<code class="cs1-code">&#x7B;{[[Template:$1|$1]]}}</code>', template_name);

	local rendered_id;															-- a single rendered id worked on here
	local rendered_ids_t = {};													-- individual rendered ids go here
	
	local i = 1;																-- initialize the indexer for the repeat loop
	repeat																		-- loop until no 
		local params_t = params_get (args_t, i);								-- get the parameters associated with enumerator <i>
		params_t[template_name] = params_t[1] or params_t['id'];				-- assign value from {{{1}}} or |id= to |<identifier>=
		params_t._template = nil;												-- unset as no longer needed
		if not params_t[template_name] then										-- in case params_t[1] and params_t.id are nil
			params_t[template_name] = '';										-- set <id> to empty string
			return render_final (												-- make an error message and done
				substitute ('<span class="cs1-visible-error citation-comment">$1: required identifier missing ($2)</span>$3', {
					message_prefix,
					substitute ('[[Template:$1|help]]', template_name),
					no_cat and '' or substitute ('[[Category:Pages with $1 errors]]', template_name:upper())
					}));
		end
		params_t[i] = nil;														-- unset these as no longer needed
		params_t.id = nil;

		local DoiBroken = params_t['doi-broken-date'];							-- {{doi}} only
		local Embargo = params_t['pmc-embargo-date'];							-- {{pmc}} only
		local Class = params_t['class'];										-- {{arxiv}} only
		local AsinTLD = params_t['asin-tld'];									-- {{asin}} only

		ID_list_t, ID_list_coins_t = identifiers.identifier_lists_get (params_t, {DoiBroken = DoiBroken, Embargo = Embargo, Class = Class, ASINTLD = AsinTLD}, {});	-- {} is a placeholder for unused ID_support{}
		rendered_id = ID_list_t[1];

		if utilities.z.error_msgs_t[1] then										-- only one error message considered
			rendered_id = substitute ('$1 $2', {
				rendered_id,
				err_message_convert (message_prefix, utilities.z.error_msgs_t[1], template_name, no_cat),
				});
			
		elseif utilities.z.maint_cats_t[1] then									-- only one maint message considered per rendering
			rendered_id = substitute ('$1 $2', {
				rendered_id,
				maint_message_convert (message_prefix, utilities.z.maint_cats_t[1], template_name, no_cat),
				});
		end

		utilities.z.error_msgs_t = {};											-- reset these
		utilities.z.maint_cats_t = {};
		
		if (1 ~= i) or ((1 == i) and ('yes' == args_t.plainlink)) then			-- no label for 2nd... identifiers; when |plainlink=yes then no label for first identifier; 
			local separator = cfg.id_handlers[template_name:upper()].separator;	-- get the identifier label separator
			rendered_id = rendered_id:gsub ('^%[%[.-|.-%]%]', '');				-- strip cs1-supplied label
			rendered_id = rendered_id:gsub ('^' .. separator, '');				-- and strip the label separator
		elseif 1 == i then														-- here for first identifier; |plainlink= not set
			if 'no' == args_t.link then											-- |link=no then do not link identifier label
				rendered_id = rendered_id:gsub ('^%[%[.-|(.-)%]%]', '%1');		-- strip wikilink markup from cs1-supplied label
			end
		end
		table.insert (rendered_ids_t, rendered_id);								-- save the rendered identifier
		
		i = i + 1;																-- bump the indexer
		until not (args_t[i] or args_t['id' .. i]);								-- end of repeat loop

	local list_separator = ', ';												-- identifier separator for a list of identifiers
	local leadout = args_t.leadout and mw.ustring.gsub (args_t.leadout, '^(%a.*)', ' %1 ') or nil;	-- insert leading space if first character is a letter; add trailing space

	if leadout then																-- extra text goes between last two identifiers in the list
		return render_final (mw.text.listToText (rendered_ids_t, list_separator, leadout));	-- make a list, add templatestyles, and done
	end

	return render_final (table.concat (rendered_ids_t, list_separator));		-- make a list, add templatestyles, and done
end


--[[--------------------------< M A I N >----------------------------------------------------------------------

entry point from an invoke

	{{#invoke:CS1 identifiers|main|_template=<identifier name>}}
	
]]

local function main (frame)
	Frame = frame;																-- make a copy for rendering final output
	local args_t = get_args (frame);											-- extract the arguments

	return _main (args_t);														-- render the identifier and done
end


--[[--------------------------< E X P O R T S >----------------------------------------------------------------
]]

return {
	main = main,																-- entry point from an invoke (in a template usually)
	
	_main = _main																-- entry point when called from another module
	}
