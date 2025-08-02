--[=[

Lua support for the {{lang}}, {{langx}}, {{lang-??}}, and {{transliteration}} templates and replacement of various supporting templates. 

]=]

require('strict');

local getArgs = require ('Module:Arguments').getArgs;
local unicode = require ("Module:Unicode data");								-- for is_Latin() and is_rtl()
local yesno = require ('Module:Yesno');

local lang_data =  mw.loadData ('Module:Lang/data');							-- language name override and transliteration tool-tip tables
local lang_name_table = lang_data.lang_name_table;								-- language codes, names, regions, scripts, suppressed scripts
local lang_table = lang_data.lang_name_table.lang;
local lang_dep_table = lang_data.lang_name_table.lang_dep;
local script_table = lang_data.lang_name_table.script;
local region_table = lang_data.lang_name_table.region;
local variant_table = lang_data.lang_name_table.variant;
local suppressed_table = lang_data.lang_name_table.suppressed;
local override_table = lang_data.override;

local synonym_table = mw.loadData ('Module:Lang/ISO 639 synonyms');				-- ISO 639-2/639-2T code translation to 639-1 code

local cfg = mw.loadData ('Module:Lang/configuration' .. (mw.getCurrentFrame():getTitle():match ('/sandbox') or ''));	-- for internationalization

local is_latn_data = mw.loadData ('Module:Lang/data/is latn data');
local sizeof_ranges_t = is_latn_data.sizeof_ranges_t;

local namespace = mw.title.getCurrentTitle().namespace;							-- used for categorization

local content_lang = mw.language.getContentLanguage();
local this_wiki_lang_tag = content_lang.code;									-- get this wiki's language tag
local this_wiki_lang_dir = content_lang:getDir();								-- get this wiki's language direction

local initial_style_state;														-- set by lang_xx_normal() and lang_xx_italic()

local maint_cats = {};															-- maintenance categories go here
local maint_msgs = {};															-- and their messages go here


--[[--------------------------< M A K E _ E R R O R _ S P A N >--------------------------------------------------

]]

local function make_error_span (template, msg)
	return table.concat ({'<span style="color:#d33">', cfg.misc_text_t.error, ': ', template, msg, '</span>'})
end


--[[--------------------------< S U B S T I T U T E >----------------------------------------------------------

Substitutes $1, $2, etc in <message> with data from <data_t>. Returns plain-text substituted string when
<data_t> not nil; returns <message> else.

]]

local function substitute (message, data_t)
	return data_t and mw.message.newRawMessage (message, data_t):plain() or message;
end


--[[--------------------------< M A K E _ E R R O R _ M S G >--------------------------------------------------

Assembles an error message from template name, message text, help link, and error category.

]]

local function make_error_msg (msg, args_t, template)
	local category;
	local text;																	-- handle the oddity that is {{langx}}
	if cfg.templates_t.langxx == template then
		text = args_t.text or args_t[1];										-- for {{lang-xx}}
	else
		text = args_t.text or args_t[2];										-- for {{lang}}, {{langx}}, and {{transliteration}}
	end

	if cfg.templates_t.transliteration == template then
		category = cfg.make_error_msg_t.xlit_err_cat;
	else
		category = cfg.make_error_msg_t.lang_err_cat;
	end
	
	local category_link = ((0 == namespace or 10 == namespace) and not args_t.nocat) and substitute ('[[Thể loại:$1]]', {category}) or '';
	return substitute ('[$1] <span style="color:#d33">$2: {{$3}}: $4 ([[:Thể loại:$5|$6]])</span>$7',
		{
		text or cfg.make_error_msg_t.undefined,
		cfg.misc_text_t.error,
		template,
		msg,
		category,
		cfg.misc_text_t.help,
		category_link
		})
end
	

--[[--------------------------< P A R A M E T E R _ V A L I D A T E >------------------------------------------

]]

local function parameter_validate (args_t, template)
	local err_msg = cfg.parameter_validate_t.invalid_param;

	if cfg.templates_t.lang == template then									-- for {{lang}}
		for param, _ in pairs (args_t) do
			if not cfg.known_params_t.params_lang_t[param] and					-- unique {{lang}} parameters
				 not cfg.known_params_t.common_params_all_t[param] then			-- common to all
					return substitute (err_msg, {param});						-- <param> not found so abandon
			end
		end
	elseif cfg.templates_t.langx == template then								-- for {{langx}}
		for param, _ in pairs (args_t) do
			if not cfg.known_params_t.params_langx_t[param] and					-- unique {{langx}} parameters
				not cfg.known_params_t.params_x_t[param] and					-- common to {{langx}} and {{lang-xx}}
				not cfg.known_params_t.common_params_all_t[param] then			-- common to all
					return substitute (err_msg, {param});						-- <param> not found so abandon
			end
		end
	elseif cfg.templates_t.langxx == template then								-- for {{lang-xx}}
		for param, _ in pairs (args_t) do
			if not cfg.known_params_t.params_lang_xx_t[param] and				-- unique {{lang-xx}} parameters
				not cfg.known_params_t.params_x_t[param] and					-- common to {{langx}} and {{lang-xx}}
				not cfg.known_params_t.common_params_all_t[param] then			-- common to all
					return substitute (err_msg, {param});						-- <param> not found so abandon
			end
		end
	end		
end


--[[--------------------------< I S _ S E T >------------------------------------------------------------------

Returns true if argument is set; false otherwise. Argument is 'set' when it exists (not nil) or when it is not
an empty string.

]]

local function is_set (var)
	return not (var == nil or var == '');
end


--[[--------------------------< I N V E R T  _ I T A L I C S >-------------------------------------------------

This function attempts to invert the italic markup a args.text by adding/removing leading/trailing italic markup
in args.text.  Like |italic=unset, |italic=invert disables automatic italic markup.  Individual leading/trailing
apostrophes are converted to their html numeric entity equivalent so that the new italic markup doesn't become
bold markup inadvertently.

Leading and trailing wiki markup is extracted from args.text into separate table elements.  Addition, removal,
replacement of wiki markup is handled by a string.gsub() replacement table operating only on these separate elements.
In the string.gsub() matching pattern, '.*' matches empty string as well as the three expected wiki markup patterns.

This function expects that markup in args.text is complete and correct; if it is not, oddness may result.

]]

local function invert_italics (source)
	local invert_pattern_table = {												-- leading/trailing markup add/remove/replace patterns
		[""]="\'\'",															-- empty string becomes italic markup
		["\'\'"]="",															-- italic markup becomes empty string
		["\'\'\'"]="\'\'\'\'\'",												-- bold becomes bold italic
		["\'\'\'\'\'"]="\'\'\'",												-- bold italic become bold
		};
	local seg = {};

	source = source:gsub ("%f[\']\'%f[^\']", '&#39;');							-- protect single quote marks from being interpreted as bold markup

	seg[1] = source:match ('^(\'\'+%f[^\']).+') or '';							-- get leading markup, if any; ignore single quote
	seg[3] = source:match ('.+(%f[\']\'\'+)$') or '';							-- get trailing markup, if any; ignore single quote

	if '' ~= seg[1] and '' ~= seg[3] then										-- extract the 'text' 
		seg[2] = source:match ('^\'\'+%f[^\'](.+)%f[\']\'\'+$')					-- from between leading and trailing markup
	elseif '' ~= seg[1] then
		seg[2] = source:match ('^\'\'+%f[^\'](.+)')								-- following leading markup
	elseif '' ~= seg[3] then
		seg[2] = source:match ('(.+)%f[\']\'\'+$')								-- preceding trailing markup
	else
		seg[2] = source															-- when there is no markup
	end

	seg[1] = invert_pattern_table[seg[1]] or seg[1];							-- replace leading markup according to pattern table
	seg[3] = invert_pattern_table[seg[3]] or seg[3];							-- replace leading markup according to pattern table

	return table.concat (seg);													-- put it all back together and done
end


--[[--------------------------< V A L I D A T E _ I T A L I C >------------------------------------------------

Validates |italic= or |italics= assigned values.

When |italic= is set and has an acceptible assigned value, return the matching css font-style property value or,
for the special case 'default', return nil.

When |italic= is not set, or has an unacceptible assigned value, return nil and a nil error message.

When both |italic= and |italics= are set, returns nil and a 'conflicting' error message.

The return value nil causes the calling lang, lang_xx, or transl function to set args.italic according to the template's
defined default ('inherit' for {{lang}}, 'inherit' or 'italic' for {{lang-??}} depending on
the individual template's requirements, 'italic' for {{transliteration}}) or to the value appropriate to |script=, if set ({{lang}}
and {{lang-??}} only).

Accepted values and the values that this function returns are are:
	nil		-	when |italic= absent or not set; returns nil
	default	-	for completeness, should rarely if ever be used; returns nil
	yes		-	force args.text to be rendered in italic font; returns 'italic'
	no		-	force args.text to be rendered in normal font; returns 'normal'
	unset	-	disables font control so that font-style applied to text is dictated by markup inside or outside the template; returns 'inherit'
	invert	-	disables font control so that font-style applied to text is dictated by markup outside or inverted inside the template; returns 'invert'

]]

local function validate_italic (args)
	local properties = {[cfg.keywords_t.affirmative] = 'italic', [cfg.keywords_t.negative] = 'normal', [cfg.keywords_t.unset] = 'inherit', [cfg.keywords_t.invert] = 'invert', [cfg.keywords_t.default] = nil};
	
	local count = 0
	for _, arg in pairs {'italic', 'italics', 'i'} do
		if args[arg] then
			count = count + 1
		end
	end

	if count > 1 then															-- return nil and an error message if more than one is set 
		return nil, cfg.validate_italic_t.multi_italic;
	end
	
	return properties[args.italic or args.italics or args.i], nil;				-- return an appropriate value and a nil error message
end


--[=[--------------------------< V A L I D A T E _ C A T _ A R G S >----------------------------------------------------------

Default behavior of the {{lang}} and {{lang-??}} templates is to add categorization when the templates are used in mainspace.
This default functionality may be suppressed by setting |nocat=yes or |cat=no.  This function selects one of these two parameters
to control categorization.

Because having two parameters with 'opposite' names and 'opposite' values is confusing, this function accepts only affirmative
values for |nocat= and only negative values for |cat=; in both cases the 'other' sense (and non-sense) is not accepted and the
parameter is treated as if it were not set in the template.

Sets args.nocat to true if categorization is to be turned off; to nil if the default behavior should apply.

Accepted values for |nocat= are the text strings:
	'yes', 'y', 'true', 't', on, '1'		-- [[Module:Yesno]] returns logical true for all of these; false or nil else
for |cat=
	'no', 'n', 'false', 'f', 'off', '0'		-- [[Module:Yesno]] returns logical false for all of these; true or nil else

]=]

local function validate_cat_args (args)
	if not (args.nocat or args.cat) then										-- both are nil, so categorize
		return;
	end
	
	if false == yesno (args.cat) or true == yesno (args.nocat) then
		args.nocat = true;														-- set to true when args.nocat is affirmative; nil else (as if the parameter were not set in the template)
	else																		-- args.nocat is the parameter actually used.
		args.nocat = nil;
	end
end


--[[--------------------------< I N _ A R R A Y >--------------------------------------------------------------

Whether needle is in haystack.

]]

local function in_array (needle, haystack)
	if needle == nil then
		return false;
	end
	for n,v in ipairs (haystack) do
		if v == needle then
			return n;
		end
	end
	return false;
end


--[[--------------------------< F O R M A T _ I E T F _ T A G >------------------------------------------------

Prettify ietf tags to use recommended subtag formats:
	code: lower case
	script: sentence case
	region: upper case
	variant: lower case
	private: lower case prefixed with -x-
	
]]

local function format_ietf_tag (code, script, region, variant, private)
	local out = {};

	if is_set (private) then
		return table.concat ({code:lower(), 'x', private:lower()}, '-');		-- if private, all other tags ignored
	end
	
	table.insert (out, code:lower());
	if is_set (script) then
		script = script:lower():gsub ('^%a', string.upper);
		table.insert (out, script);
	end

	if is_set (region) then
		table.insert (out, region:upper());
	end
	
	if is_set (variant) then
		table.insert (out, variant:lower());
	end
	
	return table.concat (out, '-');
end


--[[--------------------------< G E T _ I E T F _ P A R T S >--------------------------------------------------

Extracts and returns IETF language tag parts:
	primary language subtag (required) - 2 or 3 character IANA language code
	script subtag - four character IANA script code
	region subtag - two-letter or three digit IANA region code
	variant subtag - four digit or 5-8 alnum variant code; only one variant subtag supported
	private subtag - x- followed by 1-8 alnum private code; only supported with the primary language tag

in any one of these forms
	lang					lang-variant
	lang-script				lang-script-variant
	lang-region				lang-region-variant
	lang-script-region		lang-script-region-variant
	lang-x-private	
	
each of lang, script, region, variant, and private, when used, must be valid.

Languages with both two- and three-character code synonyms are promoted to the two-character synonym because
the IANA registry file omits the synonymous three-character code; we cannot depend on browsers understanding
the synonymous three-character codes in the lang= attribute.

For {{lang-??}} templates, the parameters |script=, |region=, and |variant= are supported (not supported in {{lang}}
because those parameters are superfluous to the IETF subtags in |code=).

Returns six  values; all lower case.  Valid parts are returned as themselves; omitted parts are returned as empty strings, invalid
parts are returned as nil; the sixth returned item is an error message (if an error detected) or nil.

See http://www.rfc-editor.org/rfc/bcp/bcp47.txt section 2.1.
	
]]

local function get_ietf_parts (source, args_script, args_region, args_variant)
	local code, script, region, variant, private;								-- ietf tag parts

	if not is_set (source) then
		return nil, nil, nil, nil, nil, cfg.get_ietf_parts_t.missing_lang_tag;
	end

	local pattern = {															-- table of tables holding acceptibe ietf tag patterns and short names of the ietf part captured by the pattern
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%a%a)%-(%d%d%d%d)$', 's', 'r', 'v'}, 				-- 1 -  ll-Ssss-RR-variant (where variant is 4 digits)
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%d%d%d)%-(%d%d%d%d)$', 's', 'r', 'v'},				-- 2 -  ll-Ssss-DDD-variant (where region is 3 digits; variant is 4 digits)
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%a%a)%-(%w%w%w%w%w%w?%w?%w?)$', 's', 'r', 'v'},		-- 3 -  ll-Ssss-RR-variant (where variant is 5-8 alnum characters)
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%d%d%d)%-(%w%w%w%w%w%w?%w?%w?)$', 's', 'r', 'v'},	-- 4 -  ll-Ssss-DDD-variant (where region is 3 digits; variant is 5-8 alnum characters)
		
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%d%d%d%d)$', 's', 'v'},						-- 5 -  ll-Ssss-variant (where variant is 4 digits)
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%w%w%w%w%w%w?%w?%w?)$', 's', 'v'},			-- 6 -  ll-Ssss-variant (where variant is 5-8 alnum characters)
		
		{'^(%a%a%a?)%-(%a%a)%-(%d%d%d%d)$', 'r', 'v'},							-- 7 -  ll-RR-variant (where variant is 4 digits)
		{'^(%a%a%a?)%-(%d%d%d)%-(%d%d%d%d)$', 'r', 'v'},						-- 8 -  ll-DDD-variant (where region is 3 digits; variant is 4 digits)
		{'^(%a%a%a?)%-(%a%a)%-(%w%w%w%w%w%w?%w?%w?)$', 'r', 'v'},				-- 9 -  ll-RR-variant (where variant is 5-8 alnum characters)
		{'^(%a%a%a?)%-(%d%d%d)%-(%w%w%w%w%w%w?%w?%w?)$', 'r', 'v'},				-- 10 - ll-DDD-variant (where region is 3 digits; variant is 5-8 alnum characters)
		
		{'^(%a%a%a?)%-(%d%d%d%d)$', 'v'},										-- 11 - ll-variant (where variant is 4 digits)
		{'^(%a%a%a?)%-(%w%w%w%w%w%w?%w?%w?)$', 'v'},							-- 12 - ll-variant (where variant is 5-8 alnum characters)
		
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%a%a)$', 's', 'r'},							-- 13 - ll-Ssss-RR
		{'^(%a%a%a?)%-(%a%a%a%a)%-(%d%d%d)$', 's', 'r'},						-- 14 - ll-Ssss-DDD (region is 3 digits)
		
		{'^(%a%a%a?)%-(%a%a%a%a)$', 's'},										-- 15 - ll-Ssss
		
		{'^(%a%a%a?)%-(%a%a)$', 'r'},											-- 16 - ll-RR
		{'^(%a%a%a?)%-(%d%d%d)$', 'r'},											-- 17 - ll-DDD (region is 3 digits)
		
		{'^(%a%a%a?)$'},														-- 18 - ll
		
		{'^(%a%a%a?)%-x%-(%w%w?%w?%w?%w?%w?%w?%w?)$', 'p'},						-- 19 - ll-x-pppppppp (private is 1-8 alnum characters)
		}

	local t = {};																-- table of captures; serves as a translator between captured ietf tag parts and named variables

	for i, v in ipairs (pattern) do												-- spin through the pattern table looking for a match
		local c1, c2, c3, c4;													-- captures in the 'pattern' from the pattern table go here
	
		c1, c2, c3, c4 = source:match (pattern[i][1]);							-- one or more captures set if source matches pattern[i])
			if c1 then															-- c1 always set on match
				code = c1;														-- first capture is always code
				t = {
					[pattern[i][2] or 'x'] = c2,								-- fill the table of captures with the rest of the captures
					[pattern[i][3] or 'x'] = c3,								-- take index names from pattern table and assign sequential captures
					[pattern[i][4] or 'x'] = c4,								-- index name may be nil in pattern[i] table so "or 'x'" spoofs a name for this index in this table
					};
				script = t.s or '';												-- translate table contents to named variables;
				region = t.r or '';												-- absent table entries are nil so set named ietf parts to empty string for concatenation
				variant= t.v or '';
				private = t.p or '';
				break;															-- and done
			end
	end

	if not code then
		return nil, nil, nil, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_tag, {source});	-- don't know what we got but it is malformed
	end

	code = code:lower();														-- ensure that we use and return lower case version of this
	
	if not (override_table[code] or lang_table[code] or synonym_table[code] or lang_dep_table[code]) then
		return nil, nil, nil, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_code, {code});		-- invalid language code, don't know about the others (don't care?)
	end

	if synonym_table[code] then													-- if 639-2/639-2T code has a 639-1 synonym
		table.insert (maint_cats, substitute (cfg.get_ietf_parts_t.maint_promo_cat, {code}));
		table.insert (maint_msgs, substitute (cfg.get_ietf_parts_t.maint_promo_msg, {code, synonym_table[code]}));
		code = synonym_table[code];												-- use the synonym
	end

	if is_set (script) then
		if is_set (args_script) then
			return code, nil, nil, nil, nil, cfg.get_ietf_parts_t.redundant_scr;	-- both code with script and |script= not allowed
		end
	else
		script = args_script or '';												-- use args.script if provided
	end 

	if is_set (script) then
		script = script:lower();												-- ensure that we use and return lower case version of this
		if not script_table[script] then
			return code, nil, nil, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_scr_code, {script, code});	-- language code ok, invalid script, don't know about the others (don't care?)
		end
	end
	if suppressed_table[script] then											-- ensure that code-script does not use a suppressed script
		if in_array (code, suppressed_table[script]) then
			return code, nil, nil, nil, nil, substitute (cfg.get_ietf_parts_t.script_code, {script, code});	-- language code ok, script is suppressed for this code
		end
	end

	if is_set (region) then
		if is_set (args_region) then
			return code, nil, nil, nil, nil, cfg.get_ietf_parts_t.redundant_reg;	-- both code with region and |region= not allowed
		end
	else
		region = args_region or '';												-- use args.region if provided
	end 

	if is_set (region) then
		region = region:lower();												-- ensure that we use and return lower case version of this
		if not region_table[region] then
			return code, script, nil, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_reg_code, {region, code});
		end
	end
	
	if is_set (variant) then
		if is_set (args_variant) then
			return code, nil, nil, nil, nil, cfg.get_ietf_parts_t.redundant_var;	-- both code with variant and |variant= not allowed
		end
	else
		variant = args_variant or '';											-- use args.variant if provided
	end 

	if is_set (variant) then
		variant = variant:lower();												-- ensure that we use and return lower case version of this
		if not variant_table[variant] then										-- make sure variant is valid
			return code, script, region, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_var, {variant});
		end																		-- does this duplicate/replace tests in lang() and lang_xx()?
		if is_set (script) then													-- if script set it must be part of the 'prefix'
			if not in_array (table.concat ({code, '-', script}), variant_table[variant]['prefixes']) then
				return code, script, region, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_var_code_scr, {variant, code, script});
			end
		elseif is_set (region) then												-- if region set, there are some prefixes that require lang code and region (en-CA-newfound)
			if not in_array (code, variant_table[variant]['prefixes']) then		-- first see if lang code is all that's required (en-oxendict though en-GB-oxendict is preferred)
				if not in_array (table.concat ({code, '-', region}), variant_table[variant]['prefixes']) then		-- now try for lang code and region (en-CA-newfound)
					return code, script, region, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_var_code_reg, {variant, code, region});
				end
			end
		else																	-- cheap way to determine if there are prefixes; fonipa and others don't have prefixes; # operator always returns 0
			if variant_table[variant]['prefixes'][1] and not in_array (code, variant_table[variant]['prefixes']) then
				return code, script, region, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_var_code, {variant, code});
			end
		end
	end

	if is_set (private) then
		private = private:lower();												-- ensure that we use and return lower case version of this
		if not override_table[table.concat ({code, '-x-', private})] then		-- make sure private tag is valid; note that index 
			return code, script, region, nil, nil, substitute (cfg.get_ietf_parts_t.unrecog_pri, {private});
		end
	end
	return code, script, region, variant, private, nil;							-- return the good bits; make sure that msg is nil
end


--[=[-------------------------< M A K E _ W I K I L I N K >----------------------------------------------------

Makes a wikilink; when both link and display text is provided, returns a wikilink in the form [[L|D]]; if only
link is provided, returns a wikilink in the form [[L]]; if neither are provided or link is omitted, returns an
empty string.

]=]

local function make_wikilink (link, display)
	if is_set (link) then
		if is_set (display) then
			return table.concat ({'[[', link, '|', display, ']]'});
		else
			return table.concat ({'[[', link, ']]'});
		end
	else
		return '';
	end
end


--[[--------------------------< D I V _ M A R K U P _ A D D >--------------------------------------------------

Adds <i> and </i> tags to list-item text or to implied <p>..</p> text. Mixed not supported.

]]

local function div_markup_add (text, style)
	if text:find ('^\n[%*:;#]') then											-- look for list markup; list markup must begin at start of text
		if 'italic' == style then
			return text:gsub ('(\n[%*:;#]+)([^\n]+)', '%1<i>%2</i>');			-- insert italic markup at each list item
		else
			return text;
		end
	end

	if text:find ('\n+') then													-- look for any number of \n characters in text
		text = text:gsub ('([^\n])\n([^\n])', '%1 %2');							-- replace single newline characters with a space character which mimics mediawiki

		if 'italic' == style then
			text = text:gsub('[^\n]+', '<p><i>%1</i></p>');						-- insert p and italic markup tags at each impled p (two or more consecutive '\n\n' sequences)
		else
			text = text:gsub ('[^\n]+', '<p>%1</p>');							-- insert p markup at each impled p
			text = text:gsub ('\n', '');										-- strip newline characters
		end
	end

	return text;
end


--[[--------------------------< T I T L E _ W R A P P E R _ M A K E >------------------------------------------

Makes a <span title="<title text>"><content_text></span> or <div title="<title text>"><content_text></div> where
<title text> is in the tool-tip in the wiki's local language and <content_text> is non-local-language text in
html markup.  This because the lang= attibute applies to the content of its enclosing tag.

<tag> holds a string 'div' or 'span' used to choose the correct wrapping tag.

]]

local function title_wrapper_make (title_text, content_text, tag)
	local wrapper_t = {};
	
	table.insert (wrapper_t, table.concat ({'<', tag}));						-- open opening wrapper tag
	table.insert (wrapper_t, ' title=\"');										-- begin title attribute
	table.insert (wrapper_t, title_text);										-- add <title_text>
	table.insert (wrapper_t, '\">');											-- end title attribute and close opening wrapper tag
	table.insert (wrapper_t, content_text);										-- add <content_text>
	table.insert (wrapper_t, table.concat ({'</', tag, '>'}));					-- add closing wrapper tag

	return table.concat (wrapper_t);											-- make a big string and done
end


--[[--------------------------< M A K E _ T E X T _ H T M L >--------------------------------------------------

Add the html markup to text according to the type of content that it is: <span> or <i> tags for inline content or
<div> tags for block content

The lang= attribute also applies to the content of the tag where it is placed so this is wrong because 'Spanish
language text' is English:
	<i lang="es" title="Spanish language text">casa</i>
should be:
	<span title="Spanish language text"><i lang="es">casa</i></span>
or for <div>...</div>:
	<div title="Spanish language text"><div lang="es"><spanish-language-text></div></div>

]]

local function make_text_html (code, text, tag, rtl, style, size, language)
	local html_t = {};
	local style_added = '';
	local wrapper_tag = tag;													-- <tag> gets modified so save a copy for use when/if we create a wrapper span or div

	if text:match ('^%*') then
		table.insert (html_t, '&#42;');											-- move proto language text prefix outside of italic markup if any; use numeric entity because plain splat confuses MediaWiki
		text = text:gsub ('^%*', '');											-- remove the splat from the text
	end

	if 'span' == tag then														-- default html tag for inline content
		if 'italic' == style then												-- but if italic
			tag = 'i';															-- change to <i> tags
		end
	else																		-- must be div so go
		text = div_markup_add (text, style);									-- handle implied <p>, implied <p> with <i>, and list markup (*;:#) with <i>
	end

	table.insert (html_t, table.concat ({'<', tag}));							-- open the <i>, <span>, or <div> html tag
	code = code:gsub ('%-x%-.*', '');											-- strip private use subtag from code tag because meaningless outside of wikipedia
	table.insert (html_t, table.concat ({' lang="', code, '\"'}));				-- add language attribute

	if (rtl or unicode.is_rtl(text)) and ('ltr' == this_wiki_lang_dir) then		-- text is right-to-left on a left-to-right wiki
		table.insert (html_t, ' dir="rtl"');									-- add direction attribute for right-to-left languages
	elseif not (rtl or unicode.is_rtl(text)) and ('rtl' == this_wiki_lang_dir) then	-- text is left-to-right on a right-to-left wiki
		table.insert (html_t, ' dir="ltr"');									-- add direction attribute for left-to-right languages
	end

	if 'normal' == style then													-- when |italic=no
		table.insert (html_t, ' style=\"font-style: normal;');					-- override external markup, if any
		style_added = '\"';														-- remember that style attribute added and is not yet closed
	end

	if is_set (size) then														-- when |size=<something>
		if is_set (style_added) then
			table.insert (html_t, table.concat ({' font-size: ', size, ';'}));	-- add when style attribute already inserted
		else
			table.insert (html_t, table.concat ({' style=\"font-size: ', size, ';'}));	-- create style attribute
			style_added = '\"';													-- remember that style attribute added and is not yet closed
		end
	end

	table.insert (html_t, table.concat ({style_added, '>'}));					-- close the opening html tag
	table.insert (html_t, text);												-- insert the text

	table.insert (html_t, table.concat ({'</', tag, '>'}));						-- close the 'text' <i>, <span>, or <div> html tag

	if is_set (language) then													-- create a <title_text> string for the title= attribute in a wrapper span or div
		local title_text;
			if 'zxx' == code then												-- special case for this tag 'no linguistic content'
				title_text = substitute ('$1 $2', {cfg.make_text_html_t.zxx, language});	-- not a language so don't use 'language' in title text
			elseif mw.ustring.find (language, 'ngữ', 1, true) then
				title_text = substitute ('$1 $2', {cfg.make_text_html_t.collective, language});	-- for collective languages
			else
				title_text = substitute ('$1 $2', {cfg.make_text_html_t.individual, language});	-- for individual languages
			end

		return title_wrapper_make (title_text, table.concat (html_t), wrapper_tag);
	else
		return table.concat (html_t);
	end
end


--[=[-------------------------< M A K E _ C A T E G O R Y >----------------------------------------------------

For individual language, <language>, returns:
	[[Thể loại:Bài viết có văn bản <language>]]

For Vietnamese:
	[[Thể loại:Bài viết có văn bản tiếng Việt nêu rõ]]
	
For ISO 639-2 collective languages (and for 639-1 bh):
	[[Thể loại:Bài viết có văn bản <language>]]

]=]

local function make_category (code, language_name, nocat, name_get)
	if ((0 ~= namespace) or nocat) and not name_get then						-- only categorize in article space
		return '';																-- return empty string for concatenation
	end

	if mw.ustring.find (language_name, 'ngữ', 1, true) then
		return substitute ('[[$1 $2]]', {cfg.make_category_t.collective_cat, language_name});
	end
		
	if this_wiki_lang_tag == code then
		return substitute ('[[$1 $2 $3 $4]]', {									-- unique category name for the local language
			cfg.make_category_t.cat_prefix,
			cfg.make_category_t.cat_postfix,
			language_name,
			cfg.make_category_t.explicit_cat,
			});
	else
		return substitute ('[[$1 $2 $3]]', {									-- category for individual languages
			cfg.make_category_t.cat_prefix,
			cfg.make_category_t.cat_postfix,
			language_name,
			});
	end
end


--[[--------------------------< M A K E _ T R A N S L I T >----------------------------------------------------

Return translit <i lang=xx-Latn>...</i> where xx is the language code; else return empty string.

The value |script= is not used in {{transliteration}} for this purpose; instead it uses |code.  Because language scripts
are listed in the {{transliteration}} switches they are included in the data tables.  The script parameter is introduced
at {{Language with name and transliteration}}.  If |script= is set, this function uses it in preference to code.

To avoid confusion, in this module and the templates that use it, the transliteration script parameter is renamed
to be |translit-script= (in this function, tscript).

This function is used by both lang_xx() and transl()
	lang_xx() always provides code, language_name, and translit; may provide tscript; never provides style
	transl() always provides language_name, translit, and one of code or tscript, never both; always provides style

For {{transliteration}}, style only applies when a language code is provided.

]]

local function make_translit (code, language_name, translit, std, tscript, style, engvar)
	local title_t = lang_data.translit_title_table;								-- table of transliteration standards and the language codes and scripts that apply to those standards
	local title_text = '';														-- tool tip text for title= attribute
	
	std = std and std:lower();													-- lower case for table indexing
	
	if not is_set (std) and not is_set (tscript) then							-- when neither standard nor script specified
		title_text = language_name;												-- write a generic tool tip
		if not mw.ustring.find (language_name, 'ngữ', 1, true) then		-- collective language names (plural 'languages' is part of the name)
			title_text = substitute ('$1 $2', {cfg.misc_text_t.language, title_text});	-- skip this text (individual and macro languages only)
		end
		title_text = substitute ('$1 $2', {cfg.engvar_t[engvar]['romanisz_lc'], title_text});	-- finish the tool tip; use romanization when neither script nor standard supplied

	elseif is_set (std) and is_set (tscript) then								-- when both are specified
		if title_t[std] then													-- and if standard is legitimate
			if title_t[std][tscript] then										-- and if script for that standard is legitimate
				if script_table[tscript] then
					title_text = substitute ('$1$2 $3 ($4 $5)', {				-- add the appropriate text to the tool tip
						cfg.make_translit_t.transliteration,
						title_text,
						title_t[std][tscript:lower()],
						cfg.make_translit_t.script,
						script_table[tscript],
						});
				else
					title_text = title_text .. title_t[std]['default'];			-- use the default if script not in std table; TODO: maint cat? error message because script not found for this standard?
				end
			else
				title_text = title_text .. title_t[std]['default'];				-- use the default if script not in std table; TODO: maint cat? error message because script not found for this standard?
			end
		else
			return '';															-- invalid standard, setup for error message
		end

	elseif is_set (std) then													-- translit-script not set, use language code
		if not title_t[std] then return ''; end									-- invalid standard, setup for error message
		
		if title_t[std][code] then												-- if language code is in the table (transl may not provide a language code)
			title_text = substitute ('$1$2 $3 ($4 $5)', {						-- add the appropriate text to the tool tip
				cfg.make_translit_t.transliteration,
				title_text,
				title_t[std][code:lower()],
				cfg.misc_text_t.language,
				language_name,
				});
		else																	-- code doesn't match
			title_text = title_text .. title_t[std]['default'];					-- so use the standard's default
		end

	else																		-- here if translit-script set but translit-std not set
		if title_t['no_std'][tscript] then
			title_text = title_text .. title_t['no_std'][tscript];				-- use translit-script if set
		elseif title_t['no_std'][code] then
			title_text = title_text .. title_t['no_std'][code];					-- use language code
		else
			if is_set (tscript) then
				title_text = substitute ('$1 $2 $3 $4', {						-- write a script tool tip
					cfg.make_translit_t.transliteration,
					cfg.make_translit_t.script,
					title_text,
					language_name,
					});

			elseif is_set (code) then
				if not mw.ustring.find (language_name, 'ngữ', 1, true) then	-- collective language names (plural 'languages' is part of the name)
					title_text = substitute ('$1 $2', {							-- skip this text (individual and macro languages only)
						cfg.misc_text_t.language,
						title_text,
						});
				end
					title_text = substitute ('$1 $2', {							-- finish the tool tip
						cfg.make_translit_t.transliteration,
						title_text,
						});
			else
					title_text = substitute ('$1 $2', {							-- generic tool tip (can we ever get here?)
						cfg.make_translit_t.transliteration,
						title_text,
						});
			end
		end
	end

	local tag
	if is_set (code) then														-- when a language code is provided (always with {{lang-??}} templates, not always with {{transliteration}})
		code = code:match ('^(%a%a%a?)');										-- strip all subtags leaving only the language subtag
		if not style then														-- nil for the default italic style
			tag = '<i lang="%s-Latn">%s</i>'
		else
			tag = '<span style="font-style: %s" lang="%s-Latn">%s</span>'		-- non-standard style, construct a span tag for it
			tag = string.format(tag, style, "%s", "%s")
		end
		tag = string.format(tag, code, "%s")
	else
		tag = '<span>%s</span>'													-- when no language code: no lang= attribute, not italic ({{transliteration}} only)
	end
	
	tag = string.format(tag, translit)											-- add the translit text
	if '' == title_text then													-- when there is no need for a tool-tip
		return tag;																-- done
	else
		title_text = cfg.engvar_sel_t.gb == engvar and title_text:gsub ('([Rr]omani)z', '%1s') or title_text;	-- gb eng when engvar specifies gb eng; us eng else
		return title_wrapper_make (title_text, tag, 'span');					-- wrap with a tool-tip span and done
	end
end


--[[--------------------------< V A L I D A T E _ T E X T >----------------------------------------------------

This function checks the content of args.text and returns empty string if nothing is amiss else it returns an
error message. The tests are for empty or missing text and for improper or disallowed use of apostrophe markup.

Italic rendering is controlled by the |italic= template parameter so italic markup should never appear in args.text
either as ''itself'' or as '''''bold italic''''' unless |italic=unset or |italic=invert.

]]

local function validate_text (template, args)
	if not is_set (args.text) then
		return make_error_msg (cfg.validate_text_t.no_text, args, template);
	end

	if args.text:find ("%f[\']\'\'\'\'%f[^\']") or args.text:find ("\'\'\'\'\'[\']+") then	-- because we're looking, look for 4 appostrophes or 6+ appostrophes
		return make_error_msg (cfg.validate_text_t.malformed_markup, args, template);
	end

	local style = args.italic;

	if (cfg.keywords_t.unset ~= style) and (cfg.keywords_t.invert ~=style) then
		if args.text:find ("%f[\']\'\'%f[^\']") or args.text:find ("%f[\']\'\'\'\'\'%f[^\']") then	-- italic but not bold, or bold italic
			return make_error_msg (cfg.validate_text_t.italic_markup, args, template);
		end
	end
end


--[[--------------------------< R E N D E R _ M A I N T >------------------------------------------------------

Render mainenance messages and categories.

]]

local function render_maint (nocat)
	local maint = {};
	
	if 0 < #maint_msgs then														-- when there are maintenance messages
		table.insert (maint, table.concat ({'<span class="lang-comment" style="font-style: normal; display: none; color: #33aa33; margin-left: 0.3em;">'}));	-- opening <span> tag
		for _, msg in ipairs (maint_msgs) do
			table.insert (maint, table.concat ({msg, ' '}));					-- add message strings
		end
		table.insert (maint, '</span>');										-- close the span
	end
	
	if (0 < #maint_cats) and (0 == namespace) and not nocat then				-- when there are maintenance categories; article namespace only
		for _, cat in ipairs (maint_cats) do
			table.insert (maint, table.concat ({'[[Thể loại:', cat, ']]'}));	-- format and add the categories
		end
	end
	
	return table.concat (maint);
end


--[[--------------------------< P R O T O _ P R E F I X >------------------------------------------------------

For proto languages, text is prefixed with a splat. We do that here as a flag for make_text_html() so that a splat
will be rendered outside of italic markup (if used). If the first character in text here is already a splat, we
do nothing.

proto_param is boolean or nil; true adds splat prefix regardless of language name; false removes and inhibits
regardless of language name; nil does nothing; presumes that the value in text is correct but removes extra splac.

]]

local function proto_prefix (text, language_name, proto_param)
	if false == proto_param then												-- when forced by |proto=no
		return text:gsub ('^%**', '');											-- return text without splat prefix regardless of language name or existing splat prefix in text
	elseif (language_name:find ('^Proto%-') or language_name:find (' nguyên th[uủ][yỷ]$') or (true == proto_param)) then		-- language is a proto or forced by |proto=yes
		return text:gsub ('^%**', '*');											-- prefix proto-language text with a splat; also removes duplicate prefixing splats
	end
	
	return text:gsub ('^%*+', '*');												-- return text unmolested except multiple splats reduced to one splat
end


--[[--------------------------< H A S _ P O E M _ T A G >------------------------------------------------------

Looks for a poem strip marker in text; returns true when found; false else.

Auto-italic detection disabled when text has poem stripmarker because it is not possible for this code to know
the content that will replace the stripmarker.

]]

local function has_poem_tag (text)
	return text:find ('\127[^\127]*UNIQ%-%-poem%-[%a%d]+%-QINU[^\127]*\127') and true or false;
end


--[[--------------------------< H T M L _ T A G _ S E L E C T >------------------------------------------------

Inspects content of and selectively trims text.  Returns text and the name of an appropriate html tag for text.

If text contains:
	\n\n	text has implied <p>..</p> tags - trim leading and trailing whitespace and return 
If text begins with list markup:
	\n*		unordered
	\n;		definition
	\n:		definition
	\n#		ordered
trim all leading whitespace except  \n and trim all trailing whitespace

If text contains <poem>...</poem> stripmarker, return text unmodified and choose <div>..</div> tags because 
the stripmarker is replaced with text wrapped in <div>..</div> tags.

If the text contains any actual <div>...</div> tags, then it's again returned unmodified and <div>...</div>
tags are used to wrap it, to prevent div/span inversion.

]]

local function html_tag_select (text)
	local tag;
	
	if has_poem_tag (text) then													-- contains poem stripmarker (we can't know the content of that)
		tag = 'div';															-- poem replacement is in div tags so lang must use div tags
	elseif text:find ('<div') then												-- reductive; if the text contains a div tag, we must use div tags
		tag = 'div';
	elseif mw.text.trim (text):find ('\n\n+') then								-- contains implied p tags
		text = mw.text.trim (text);												-- trim leading and trailing whitespace characters
		tag = 'div';															-- must be div because span may not contain p tags (added later by MediaWiki); poem replacement is in div tags
	elseif text:find ('\n[%*:;%#]') then										-- if text has list markup
		text = text:gsub ('^[\t\r\f ]*', ''):gsub ('%s*$', '');					-- trim all whitespace except leading newline character '\n'
		tag = 'div';															-- must be div because span may not contain ul, dd, dl, ol tags (added later by MediaWiki)
	else
		text = mw.text.trim (text);												-- plain text
		tag = 'span';															-- so span is fine
	end
	
	return text, tag;
end


--[[--------------------------< V A L I D A T E _ P R O T O >--------------------------------------------------

Validates value assigned to |proto=; permitted values are yes and no; yes returns as true, no returns as false,
empty string (or parameter omitted) returns as nil; any other value returns nil with <proto_param> as second
return value for use in error message.

]]

local function validate_proto (proto_param)
	if cfg.keywords_t.affirmative == proto_param then
		return true;
	elseif cfg.keywords_t.negative == proto_param then
		return false;
	elseif is_set (proto_param) then
		return nil, proto_param;												-- |proto= something other than 'yes' or 'no'
	else
		return nil;																-- missing or empty
	end
end


--[[--------------------------< L A N G U A G E _ N A M E _ G E T >--------------------------------------------

Common function to return language name from the data set according to IETF tag.

Returns language name if found in data tables; nil else.

]]

local function language_name_get (ietf, code, cat)
	ietf = ietf:lower();														-- ietf:lower() because format_ietf_tag() returns mixed case
	
	local name;																	-- remains nil if not found
	
	if override_table[ietf] then												-- look for whole IETF tag in override table
		name = override_table[ietf];
	elseif override_table[code] then											-- not there so try basic language tag
		name = override_table[code];
	elseif lang_table[code] then												-- shift to iana active tag/name table
		name = lang_table[code];
	elseif lang_dep_table[code] then											-- try the iana deprecated tag/name table
		name = lang_dep_table[code];
	end

	if lang_dep_table[code] and cat then										-- because deprecated code may have been overridden to en.wiki preferred name
		table.insert (maint_cats, substitute (cfg.language_name_get_t.deprecated_cat, {code}));
		table.insert (maint_msgs, substitute (cfg.language_name_get_t.deprecated_msg, {code}));
	end

	return name;																-- name from data tables or nil
end


--[[--------------------------< T E X T _ S C R I P T _ M A T C H _ T E S T >----------------------------------

IETF script subtag should match the script of the <text>.  This module does not attempt to know all scripts and
what they look like.  It does know what Latn script looks like so when <text> is written using other than the Latn
script, the IETF script subtag, if present, should not be Latn.

Conversely, when <text> is written using the Latn script, the IETF script subtag, if present, should be Latn.

For the purposes of this test, Latf (Fraktur) and Latg (Gaelic) are considered to be equivalent to Latn because
unicode treats these two scripts as font-specific variants of Latn.

Returns an error message when mismatch detected; nil else.

]]

local function text_script_match_test (script, is_latn_text, pos, char)
	local scripts_t = {['latf'] = true, ['latg'] = true, ['latn'] = true};		-- unicode 'latn' scripts; 'latf' and 'latg' are font variants so there are no Fraktur or Gaelic codepoints
	if is_set (script) then														-- don't bother with the rest of this if <script> is nil or empty string
		script = script:lower();												-- lower case to index into <scripts_t>
		if is_latn_text then													-- when text is wholly Latn script
			if not scripts_t[script] then										-- but a non-Latn script is specified
				return cfg.text_script_match_test_t.latn_txt_mismatch;			-- emit an error message
			end
		else																	-- when text is not wholly Latn script
			if scripts_t[script] then											-- but a Latn script is specified
				return substitute (cfg.text_script_match_test_t.latn_scr_mismatch, {pos, char});	-- emit an error message with position of first offending character
			end
		end
	end
end


--[[--------------------------< B I N A R Y _ S E A R C H >---------------------------------------------------

conducts a binary search of <ranges_t> for a sub-range that holds <target>.

returns boolean true if a sub-range holding <target> is found; boolean false else.

]]

local function binary_search (target, ranges_t)
	local idx_bot = 1;															-- initialize to index of first key
	local idx_top = sizeof_ranges_t;											-- initialize to index of last key (number of keys)

	if (target < ranges_t[idx_bot][1]) or (target > ranges_t[idx_top][2]) then	-- invalid; target out of range
		return;																	-- abandon
	end

	local idx_mid;																-- calculated index of range midway between top index and bottom index
	local flag = false;															-- flag to tell us when we've evaluated last (highest) range in <ranges_t>

	while 1 do
		idx_mid = math.ceil ((idx_bot + idx_top) / 2);							-- get the mid-point in the <ranges_t> sequence
		if (target >= ranges_t[idx_mid][1]) and (target <= ranges_t[idx_mid][2]) then		-- indexed range low value <= target <= indexed range high value
			return true;														-- we found the range that holds the <target> character; return true
		
		elseif (target > ranges_t[idx_mid][2]) then								-- is <target> > indexed range high value?
			idx_bot = idx_mid;													-- adjust <idx_bot> up

		else																	-- here when <target> less than indexed range low value
			idx_top = idx_mid - 1;												-- adjust <idx_top> down
		end

		if flag then
			break;																-- here when we just evaluated the last range and <target> not found
		end
	
		if not flag and (idx_bot == idx_top) then								-- set true just before we evaluate the last (highest) range in <ranges_t>
			flag = true;
		end
	end
end


--[[--------------------------< I S _ L A T I N >--------------------------------------------------------------

compare <text> as codepoints to lists of known codepoints accepted as Latn script

returns boolean true and modified <text> when <text> is wrapped in accept-as-written markup

returns boolean true and <text> when codepoint is known

returns boolean false, <text>, non-Latn codepoint position in <text> (left to right), and the codepoint character
	when codepoint is not known

TODO: when text has accept-as-written markup, return a non-boolean value to indicate that <text> is not wholly
	latn script?  Use that return value to create non-Latn html lang= attribute because <text> isn't really
	latn so lang=und (undetermined)? or instead, omit the -Latn subtag? (without -latn need to force |italic=yes)

]]

local function is_latin (text, tag)
	local count;
	text, count = text:gsub ('^%(%((.+)%)%)$', '%1');							-- remove accept-as-written markup if present
	if 0 ~= count then
		return true, text;														-- markup present so assume that <text> is Latn-script
	end

	local pos = 0;																-- position counter for error messaging
	for codepoint in mw.ustring.gcodepoint (text) do							-- fetch each code point
		pos = pos + 1;															-- bump the position counter

		if not is_latn_data.singles_t[codepoint] and							-- codepoint not found in the singles list?
			not binary_search (codepoint, is_latn_data.ranges_t) and			-- codepoint not a member of a listed range?
			not (tag and is_latn_data.specials_t[codepoint] and is_latn_data.specials_t[codepoint][tag]) then	-- not a language-specific codepoint?
				return false, text, pos, mw.ustring.char (codepoint);			-- codepoint not known; return false with codepoint position and character representation
		end
	end
	return true, text;															-- is known; return <text>
end


--[[--------------------------< _ L A N G >--------------------------------------------------------------------

Entry point for {{lang}}.

There should be no reason to set parameters in the {{lang}} {{#invoke:}}
	<includeonly>{{#invoke:lang|lang}}</includeonly>

Parameters are received from the template's frame (parent frame).

]]

local function _lang (args)
	local out = {};
	local language_name;														-- used to make category names
	local category_name;														-- same as language_name except that it retains any parenthetical disambiguators (if any) from the data set
	local subtags = {};															-- IETF subtags script, region, variant, and private
	local code;																	-- the language code
	local msg;																	-- for error messages
	local tag = 'span';															-- initial value for make_text_html()
	local template = args.template or cfg.templates_t.lang;

	maint_cats = {};															-- initialize because when this module required into another module, these only declared once so only initialzed once
	maint_msgs = {};
	
	validate_cat_args (args);													-- determine if categorization should be suppressed

	if args[1] and args.code then
		return make_error_msg (substitute (cfg.lang_t.conflict_n_param, {'1', cfg.lang_t.conflict_n_param_types.code}), args, template);
	else
		args.code = args[1] or args.code;										-- prefer args.code
	end

	if args[2] and args.text then
		return make_error_msg (substitute (cfg.lang_t.conflict_n_param, {'2', cfg.lang_t.conflict_n_param_types.text}), args, template);
	else
		args.text = args[2] or args.text;										-- prefer args.text
	end

	msg = validate_text (template, args);										-- ensure that |text= is set
	if is_set (msg) then														-- msg is an already-formatted error message
		return msg;
	end
	
	args.text, tag = html_tag_select (args.text);								-- inspects text; returns appropriate html tag with text trimmed accordingly

	args.rtl = args.rtl == cfg.keywords_t.affirmative;							-- convert to boolean: 'yes' -> true, other values -> false

	args.proto, msg = validate_proto (args.proto);								-- return boolean, or nil, or nil and error message flag
	if msg then
		return make_error_msg (substitute (cfg.lang_t.invalid_proto, {msg}), args, template);
	end

	code, subtags.script, subtags.region, subtags.variant, subtags.private, msg = get_ietf_parts (args.code);	-- |script=, |region=, |variant= not supported because they should be part of args.code ({{{1}}} in {{lang}})

	if msg then
		return make_error_msg (msg, args, template);
	end

	local is_latn_text, pos, char;
	is_latn_text, args.text, pos, char= is_latin (args.text, code);		-- make a boolean

	msg = text_script_match_test (subtags.script, is_latn_text, pos, char)
	if msg then																	-- if an error detected then there is an error message
		return make_error_msg (msg, args, template);
	end

	args.italic, msg = validate_italic (args);
	if msg then
		return make_error_msg (msg, args, template);
	end

	if nil == args.italic then													-- nil when |italic= absent or not set or |italic=default; args.italic controls
		if ('latn' == subtags.script) or								 		-- script is latn
			(this_wiki_lang_tag ~= code and not is_set (subtags.script) and not has_poem_tag (args.text) and is_latn_text) then -- text not this wiki's language, no script specified and not in poem markup but is wholly latn script (auto-italics)
				args.italic = 'italic';											-- DEFAULT for {{lang}} templates is upright; but if latn script set for font-style:italic
		else
			args.italic = 'inherit';											-- italic not set; script not latn; inherit current style
		end
	end
	
	if is_set (subtags.script) then												-- if script set, override rtl setting
		if in_array (subtags.script, lang_data.rtl_scripts) then
			args.rtl = true;													-- script is an rtl script
		else
			args.rtl = false;													-- script is not an rtl script
		end
	end

	args.code = format_ietf_tag (code, subtags.script, subtags.region, subtags.variant, subtags.private);	-- format to recommended subtag styles
	language_name = language_name_get (args.code, code, true);					-- get language name; try ietf tag first, then code w/o variant then code w/ variant

	if cfg.keywords_t.invert == args.italic and 'span' == tag then				-- invert only supported for in-line content
		args.text = invert_italics (args.text)
	end

	args.text = proto_prefix (args.text, language_name, args.proto);			-- prefix proto-language text with a splat

	table.insert (out, make_text_html (args.code, args.text, tag, args.rtl, args.italic, args.size, language_name));
	table.insert (out, make_category (code, language_name, args.nocat));
	table.insert (out, render_maint (args.nocat));								-- maintenance messages and categories

	return table.concat (out);													-- put it all together and done
end


--[[--------------------------< L A N G >----------------------------------------------------------------------

Entry point for {{lang}}.

There should be no reason to set parameters in the {{lang}} {{#invoke:}}
	<includeonly>{{#invoke:lang|lang}}</includeonly>

Parameters are received from the template's frame (parent frame).

]]

local function lang (frame)
	local args_t = getArgs (frame, {											-- this code so that we can detect and handle wiki list markup in text
		valueFunc = function (key, value)
			if 2 == key or 'text' == key then									-- the 'text' parameter; do not trim wite space
				return value;													-- return untrimmed 'text'
			elseif value then													-- all other values: if the value is not nil
				value = mw.text.trim (value);									-- trim whitespace
				if '' ~= value then												-- empty string when value was only whitespace
					return value;
				end
			end
			return nil;															-- value was empty or contained only whitespace
		end																		-- end of valueFunc
		});

	args_t.fn = nil;															-- unset because not supported but this function might have been called by {{lang|fn=lang|...}}

	local msg = parameter_validate (args_t, cfg.templates_t.lang);				-- verify that all supplied parameters are supported by {{lang-??}}
	if msg then
		return make_error_msg (msg, args_t, cfg.templates_t.lang);				-- when template has unsupported params, abandon with error message
	end

	return _lang (args_t);
end


--[[--------------------------< T R A N S L A T I O N _ M A K E >----------------------------------------------

Stand-alone function to create literal translation of main text.

Also used by {{lang-x2}}.

]]

local function translation_make (args_t)
	local translation_t = {', '};												-- initialize output

	if 'none' ~= args_t.label then												-- if we want a label
		table.insert (translation_t, '<small>');								-- open the <small> html tag
		if cfg.keywords_t.negative == args_t.link then
			table.insert (translation_t, substitute ('<abbr title="$1">$2</abbr>', {cfg.translation_make_t.lit_xlation, cfg.translation_make_t.lit_abbr}));	-- unlinked form
		else
			table.insert (translation_t, make_wikilink (cfg.translation_make_t.lit_xlation, cfg.translation_make_t.lit_abbr));	-- linked form
		end
		table.insert (translation_t, "&thinsp;</small>");						-- close the <small> html tag
	end
	table.insert (translation_t, table.concat ({'&#39;', args_t.translation, '&#39;'}));	-- use html entities to avoid wiki markup confusion
	return table.concat (translation_t);										-- make a big string and done
end


--[[--------------------------< _ L A N G _ X X >--------------------------------------------------------------

For the {{lang-??}} templates, the only parameter required to be set in the template is the language code.  All
other parameters can, usually should, be written in the template call.  For {{lang-??}} templates for languages
that can have multiple writing systems, it may be appropriate to set |script= as well.

For each {{lang-??}} template choose the appropriate entry-point function so that this function knows the default
styling that should be applied to text.

For normal, upright style:
	<includeonly>{{#invoke:lang|lang_xx_inherit|code=xx}}</includeonly>
For italic style:
	<includeonly>{{#invoke:lang|lang_xx_italic|code=xx}}</includeonly>

All other parameters should be received from the template's frame (parent frame)

Supported parameters are:
	|code = (required) the IANA language code
	|script = IANA script code; especially for use with languages that use multiple writing systems
	|region = IANA region code
	|variant = IANA variant code
	|text = (required) the displayed text in language specified by code
	|link = boolean false ('no') does not link code-spcified language name to associated language article
	|rtl = boolean true ('yes') identifies the language specified by code as a right-to-left language
	|nocat = boolean true ('yes') inhibits normal categorization; error categories are not affected
	|cat = boolian false ('no') opposite form of |nocat=
	|italic = boolean true ('yes') renders displayed text in italic font; boolean false ('no') renders displayed text in normal font; not set renders according to initial_style_state
	|lit = text that is a literal translation of text
	|label = 'none' to suppress all labeling (language name, 'translit.', 'lit.')
				any other text replaces language-name label - automatic wikilinking disabled
	
	for those {{lang-??}} templates that support transliteration (those templates where |text= is not entirely latn script):
	|translit = text that is a transliteration of text
	|translit-std = the standard that applies to the transliteration
	|translit-script = ISO 15924 script name; falls back to code

For {{lang-??}}, the positional parameters are:
	{{{1}}}	text
	{{{2}}}	transliterated text
	{{{3}}}	literal translation text
no other positional parameters are allowed

]]

local function _lang_xx (args, base_template)									-- base_template will be either of 'Langx' or 'Lang-xx'
	local out = {};
	local language_name;														-- used to make display text, article links
	local category_name;														-- same as language_name except that it retains any parenthetical disambiguators (if any) from the data set
	local subtags = {};															-- IETF subtags script, region, and variant
	local code;																	-- the language code

	local translit_script_name;													-- name associated with IANA (ISO 15924) script code
	local translit;
	local msg;																	-- for error messages
	local tag = 'span';															-- initial value for make_text_html()
	local template = args.template or base_template;

	maint_cats = {};															-- initialize because when this module required into another module, these only declared once so only initialzed once
	maint_msgs = {};
	
	local text_idx = (cfg.templates_t.langx == base_template) and 2 or 1;		-- for {{langx}} 'text' positional parameter is '2'
	local translit_idx = (cfg.templates_t.langx == base_template) and 3 or 2;
	local xlate_idx = (cfg.templates_t.langx == base_template) and 4 or 3;

	if args[text_idx] and args.text then
		return make_error_msg (substitute (cfg.lang_t.conflict_n_param, {translit_idx, cfg.lang_t.conflict_n_param_types.text}), args, template);
	else
		args.text = args[text_idx] or args.text;								-- prefer positional 'text' parameter
	end

	msg = validate_text (template, args);										-- ensure that |text= is set, does not contain italic markup and is protected from improper bolding
	if is_set (msg) then
		return msg;
	end

	args.text, tag = html_tag_select (args.text);								-- inspects text; returns appropriate html tag with text trimmed accordingly

	if args[translit_idx] and args.translit then
		return make_error_msg (substitute (cfg.lang_t.conflict_n_param, {translit_idx, cfg.lang_t.conflict_n_param_types.translit}), args, template);

	else
		args.translit = args[translit_idx] or args.translit						-- prefer positional 'translit' parameter
	end

	args.engvar = cfg.engvar_sel_t[args.engvar] or cfg.default_engvar;			-- |engvar= when valid; cfg.default_engvar else

	if args[xlate_idx] and (args.translation or args.lit) then
		return make_error_msg (substitute (cfg.lang_xx_t.conflict_n_lit, {translit_idx}), args, template);
	elseif args.translation and args.lit then
		return make_error_msg (cfg.lang_xx_t.conflict_lit, args, template);
	else
		args.translation = args[xlate_idx] or args.translation or args.lit;		-- prefer positional 'translation' parameter
	end

	if args.links and args.link then
		return make_error_msg (cfg.lang_xx_t.conflict_link, args, template);
	else
		args.link = args.link or args.links;									-- prefer args.link
	end

	validate_cat_args (args);													-- determine if categorization should be suppressed

	args.rtl = args.rtl == cfg.keywords_t.affirmative;							-- convert to boolean: 'yes' -> true, other values -> false

	code, subtags.script, subtags.region, subtags.variant, subtags.private, msg = get_ietf_parts (args.code, args.script, args.region, args.variant);	-- private omitted because private

	if msg then																	-- if an error detected then there is an error message
		return make_error_msg (msg, args, template);
	end
	
	if args.translit then
		local latn, pos, char;
		latn, args.translit, pos, char = is_latin (args.translit, (('' ~= subtags.private) and (code .. '-x-' .. subtags.private)) or code);
		if not latn then
			return make_error_msg (substitute (cfg.lang_xx_t.translit_nonlatn, {pos, char}), args, template);
		end
	end

	local is_latn_text, text, pos, char = is_latin (args.text, code);			-- make a boolean
	args.text = text;															-- may have been modified (accept-as-written markup removed)

	msg = text_script_match_test (subtags.script, is_latn_text, pos, char)
	if msg then																	-- if an error detected then there is an error message
		return make_error_msg (msg, args, template);
	end

	args.italic, msg = validate_italic (args);
	if msg then
		return make_error_msg (msg, args, template);
	end
																				
	if cfg.templates_t.langx == base_template then								-- auto-italics  for {{langx}} templates; adapted from {{lang}} (no support for poem tag) 
		if nil == args.italic then												-- nil when |italic= absent or not set or |italic=default; args.italic controls
			if ('latn' == subtags.script) or								 	-- script is latn
				(this_wiki_lang_tag ~= code and not is_set (subtags.script) and is_latn_text) then -- text is not this wiki's language, no script specified and is wholly latn script (auto-italics)
					args.italic = 'italic';										-- set font-style:italic
			else
				args.italic = 'inherit';										-- italic not set; script not latn; inherit current style
			end
		end
	
	else																		-- {{lang-xx}} does not do auto italics; retained for those wikis that don't support {{langx}}
		if nil == args.italic then												-- args.italic controls
			if is_set (subtags.script) then
				if 'latn' == subtags.script then
					args.italic = 'italic';										-- |script=Latn; set for font-style:italic
				else
					args.italic = initial_style_state;							-- italic not set; script is not latn; set for font-style:<initial_style_state>
				end
			else
				args.italic = initial_style_state;								-- here when |italic= and |script= not set; set for font-style:<initial_style_state>
			end
		end
	end
	
	if is_set (subtags.script) then												-- if script set override rtl setting
		if in_array (subtags.script, lang_data.rtl_scripts) then
			args.rtl = true;													-- script is an rtl script
		else
			args.rtl = false;													-- script is not an rtl script
		end
	end

	args.proto, msg = validate_proto (args.proto);								-- return boolean, or nil, or nil and error message flag
	if msg then
		return make_error_msg (substitute (cfg.lang_t.invalid_proto, {args.proto}), args, template);
	end

	args.code = format_ietf_tag (code, subtags.script, subtags.region, subtags.variant, subtags.private);	-- format to recommended subtag styles
	language_name = language_name_get (args.code, code, true);					-- get language name; try ietf tag first, then code w/o variant then code w/ variant

	category_name = language_name;												-- category names retain IANA parenthetical diambiguators (if any)
	language_name = language_name:gsub ('%s+%b()', '');							-- remove IANA parenthetical disambiguators or qualifiers from names that have them

	if args.label then
		if 'none' ~= args.label then
			table.insert (out, table.concat ({args.label, ': '}));				-- custom label
		end
	else
		if cfg.keywords_t.negative == args.link then
			table.insert (out, substitute ('$1 $2', {cfg.misc_text_t.language, language_name}));									-- language name without wikilink
		else
			if mw.ustring.find (language_name, 'ngữ', 1, true) then
				table.insert (out, make_wikilink (language_name));				-- collective language name uses simple wikilink
			elseif lang_data.article_name[args.code:lower()] then				-- is ietf tag in article name over ride?
				table.insert (out, make_wikilink (lang_data.article_name[args.code:lower()], language_name));	-- language name with wikilink from override data
			elseif lang_data.article_name[code] then							-- is language tag in article override
				table.insert (out, make_wikilink (lang_data.article_name[code], language_name));	-- language name with wikilink from override data
			else
				table.insert (out, make_wikilink (substitute ('$1 $2', {cfg.misc_text_t.language, language_name})));	-- language name with wikilink
			end
		end
		table.insert (out, ': ');												-- separator
	end

	if cfg.keywords_t.invert == args.italic then
		args.text = invert_italics (args.text)
	end
	
	args.text = proto_prefix (args.text, language_name, args.proto);			-- prefix proto-language text with a splat

	table.insert (out, make_text_html (args.code, args.text, tag, args.rtl, args.italic, args.size, ('none' == args.label) and language_name or nil))

	if is_set (args.translit) and not is_latn_text then							-- transliteration; not supported when args.text is wholly latn text (this is an imperfect test)
		table.insert (out, ', ');												-- comma to separate text from translit
		if 'none' ~= args.label then
			table.insert (out, '<small>');
			if script_table[args['translit-script']] then						-- when |translit-script= is set, try to use the script's name
				translit_script_name = script_table[args['translit-script']];
			else
				translit_script_name = language_name;							-- fall back on language name
			end

			local translit_title_obj = mw.title.makeTitle (0, substitute ('$1 $2',{cfg.lang_xx_t.romanization, translit_script_name}));		-- make a title object; no engvar, article titles use US spelling
			if translit_title_obj.exists and (cfg.keywords_t.negative ~= args.link) then
				table.insert (out, make_wikilink (substitute ('$1 $2', {cfg.lang_xx_t.romanization, translit_script_name or language_name}),
					substitute ('$1', {cfg.engvar_t[args.engvar]['romanisz_pt']})) .. ':');	-- make a wikilink if there is an article to link to; engvar the display text

			else
				table.insert (out, substitute ('$1:', {cfg.engvar_t[args.engvar]['romanisz_pt']}));	-- else plain text per engvar

			end
			table.insert (out, '&nbsp;</small>');								-- close the small tag
		end
		
		translit = make_translit (args.code, language_name, args.translit, args['translit-std'], args['translit-script'], nil, args.engvar)
		if is_set (translit) then
			table.insert (out, translit);
		else
			return make_error_msg (substitute ('$1: $2', {cfg.lang_xx_t.invalid_xlit_std, args['translit-std'] or '[missing]'}), args, template);
		end
	
	elseif is_set (args.translit) and is_latn_text then							-- when creating a transliteration of Latn script <text>
		return make_error_msg (cfg.lang_xx_t.xlit_of_latn, args, template);		-- emit error message and abandon
	end

	if is_set (args.translation) then											-- translation (not supported in {{lang}})
		table.insert (out, translation_make (args));
	end
	
	table.insert (out, make_category (code, category_name, args.nocat));
	table.insert (out, render_maint(args.nocat));								-- maintenance messages and categories

	return table.concat (out);													-- put it all together and done
end


--[[--------------------------< L A N G _ X X _ A R G S _ G E T >----------------------------------------------

Common function to get args table from {{lang-??}} templates.

Returns table of args.

Text positional parameters are not trimmed here but are selectively trimmed at html_tag_select().

]]

local function lang_xx_args_get (frame, base_template)
	local args_t = getArgs(frame,
		{
		parentFirst= true,														-- parameters in the template override parameters set in the {{#invoke:}}
		valueFunc = function (key, value)
			if ((cfg.templates_t.langx == base_template) and 2 or 1) == key then	-- the 'text' positional parameter; 1 for {{lang-??}}, 2 for {{langx}}; do not trim wite space
				return value;													-- return untrimmed 'text' positional parameter
			elseif value then													-- all other values: if the value is not nil
				value = mw.text.trim (value);									-- trim whitespace
				if '' ~= value then												-- empty string when value was only whitespace
					return value;
				end
			end
			return nil;															-- value was empty or contained only whitespace
		end																		-- end of valueFunc
	});

	return args_t;
end


--[[--------------------------< L A N G _ X X _ I T A L I C >--------------------------------------------------

Entry point for those {{lang-??}} templates that call lang_xx_italic(). Sets the initial style state to italic.

]]

local function lang_xx_italic (frame)
	local args = lang_xx_args_get (frame, cfg.templates_t.langxx);
	args.fn = nil;																-- unset because not supported but this function might have been called by {{lang|fn=lang_xx_italic|...}}
	
	local msg = parameter_validate (args, cfg.templates_t.langxx);				-- verify that all supplied parameters are supported by {{lang-??}}
	if msg then
		return make_error_msg (msg, args, cfg.templates_t.langxx);				-- when template has unsupported params, abandon with error message
	end

	initial_style_state = 'italic';
	return _lang_xx (args, cfg.templates_t.langxx) .. '[[Thể loại:Trang sử dụng bản mẫu Lang-xx]]';	-- temporary category
end


--[[--------------------------< _ L A N G _ X X _ I T A L I C >------------------------------------------------

Entry point from another module. Sets the initial style state to italic.

]]

local function _lang_xx_italic (args)
	initial_style_state = 'italic';
	return _lang_xx (args, cfg.templates_t.langxx);
end


--[[--------------------------< L A N G _ X X _ I N H E R I T >------------------------------------------------

Entry point for those {{lang-??}} templates that call lang_xx_inherit(). Sets the initial style state to inherit.

]]

local function lang_xx_inherit (frame)
	local args = lang_xx_args_get (frame, cfg.templates_t.langxx);
	args.fn = nil;																-- unset because not supported but this function might have been called by {{lang|fn=lang_xx_inherit|...}}

	local msg = parameter_validate (args, cfg.templates_t.langxx);				-- verify that all supplied parameters are supported by {{lang-??}}
	if msg then
		return make_error_msg (msg, args, cfg.templates_t.langxx);				-- when template has unsupported params, abandon with error message
	end

	initial_style_state = 'inherit';
	return _lang_xx (args, cfg.templates_t.langxx) .. '[[Thể loại:Trang sử dụng bản mẫu Lang-xx]]';	-- temporary category
end


--[[--------------------------< _ L A N G _ X X _ I N H E R I T >----------------------------------------------

Entry point from another module. Sets the initial style state to inherit.

]]

local function _lang_xx_inherit (args)
	initial_style_state = 'inherit';
	return _lang_xx (args, cfg.templates_t.langxx);
end


--[[--------------------------< _ L A N G X >------------------------------------------------------------------

Entry point from another module.

]]

local function _langx (args_t)
	local langx_data = mw.loadData ('Module:Lang/langx');						-- get necessary data 
	local rtl_t = langx_data.rtl_t;												-- get list of language tags for languages that are rendered right-to-left
	local link_t = langx_data.link_t;											-- get list of language tags for {{lang-??}} templates that set |link=<something>
	local size_t = langx_data.size_t;											-- get list of language tags for {{lang-??}} templates that set |size=<something>

	local msg = parameter_validate (args_t, cfg.templates_t.langx);
	if msg then
		return make_error_msg (msg, args_t, cfg.templates_t.langx);
	end

	args_t.code = args_t[1] or args_t.code;										-- get the language tag; must be {{{1}}} or |code=
	if not args_t.code then
		return make_error_msg (cfg.get_ietf_parts_t.missing_lang_tag, args_t, cfg.templates_t.langx);
	end
	
	args_t.rtl = args_t.rtl or (rtl_t[args_t.code] and cfg.keywords_t.affirmative);	-- prefer |rtl= in template call, use rtl_t else
	args_t.link = args_t.link or link_t[args_t.code];							-- prefer |link= in template call, use link_t felse
	args_t.size = args_t.size or size_t[args_t.code];							-- prefer |size= in template call, use size_t else
	
	args_t[1] = nil;															-- unset to mimic {{lang-??}} templates which set |code=xx

	local lang_subtag = args_t.code;											-- use only the base language subtag for unsupported tag test; some args_t.code are modified by |script= etc
	return _lang_xx (args_t, cfg.templates_t.langx);
end


--[[--------------------------< L A N G X >--------------------------------------------------------------------

Entry point for {{langx}}.

this function calls _lang_xx() to render non-English text. The {{lang-??}} templates have three positional paramters
but {{langx}} has four:

				|  1	|  2		|  3		|  4	
	{{lang-xx	|<text>	|<transl>	|<xlate>			}}
	{{langx		|<tag>	|<text>		|<transl>	|<xlate>	}}

The calls to lang_xx_args_get() and _lang_xx() use 'Langx' as a flag for those functions to select the proper
positional parameters.

{{lang-??}} depends on the calling template to select 'inherit' or 'italic' to establish the default rendering.

{{langx}} can't do that.  The initial version of {{langx}} relied on a list of language tags (inherit_t in ~/langx)
scraped from those {{lang-??}} templates that call lang_xx_inherit() to render text in upright font. Langx now
uses auto-italics code adapted from {{lang}} (doesn't support poem tags).

]]

local function langx (frame)
	local args_t = lang_xx_args_get (frame, cfg.templates_t.langx);				-- get the arguments; 'Langx' is the <base_template> used to decide which positional param is 'text', 'translit', 'lit'
	
	return _langx (args_t);
end


--[[--------------------------< _ I S _ I E T F _ T A G >------------------------------------------------------

Returns true when a language name associated with IETF language tag exists; nil else.  IETF language tag must be valid.

All code combinations supported by {{lang}} and the {{lang-??}} templates are supported by this function.

Module entry point from another module.

]]

local function _is_ietf_tag (tag)												-- entry point when this module is require()d into another
	local c, s, r, v, p, err;													-- code, script, region, variant, private, error message
	c, s, r, v, p, err = get_ietf_parts (tag);									-- disassemble tag into constituent part and validate

	return ((c and not err) and true) or nil;									-- return true when code portion has a value without error message; nil else
end


--[[--------------------------< I S _ I E T F _ T A G >--------------------------------------------------------

Module entry point from an {{#invoke:}}.

]]

local function is_ietf_tag (frame)
	return _is_ietf_tag (getArgs (frame)[1]);									-- args[1] is the ietf language tag to be tested; also get parent frame
end


--[[--------------------------< I S _ I E T F _ T A G _ F R A M E >--------------------------------------------

Module entry point from an {{#invoke:}}; same as is_ietf_tag() except does not get parameters from the parent
(template) frame.  This function not useful when called by {{lang|fn=is_ietf_tag_frame|<tag>}} because <tag>
is in the parent frame.

]]

local function is_ietf_tag_frame (frame)
	return _is_ietf_tag (getArgs (frame, {frameOnly = true,})[1]);				-- args[1] is the ietf language tag to be tested; do not get parent frame
end


--[[--------------------------< _ N A M E _ F R O M _ T A G >--------------------------------------------------

Returns language name associated with IETF language tag if valid; error message else.

All code combinations supported by {{lang}} and the {{lang-??}} templates are supported by this function.

Set invoke's |link= parameter to yes to get wikilinked version of the language name.

Module entry point from another module.

]]

local function _name_from_tag (args)
	local subtags = {};															-- IETF subtags script, region, variant, and private
	local raw_code = args[1];													-- save a copy of the input IETF subtag
	local link = cfg.keywords_t.affirmative == args['link'];					-- make a boolean
	local label = args.label;
	local code;																	-- the language code
	local msg;																	-- gets an error message if IETF language tag is malformed or invalid
	local language_name = '';
	
	code, subtags.script, subtags.region, subtags.variant, subtags.private, msg = get_ietf_parts (raw_code);
	if msg then
		local template = (args['template'] and table.concat ({'{{', args['template'], '}}: '})) or '';	-- make template name (if provided by the template)
		return make_error_span (template, msg);
	end

	raw_code = format_ietf_tag (code, subtags.script, subtags.region, subtags.variant, subtags.private);	-- format to recommended subtag styles; private omitted because private
	language_name = language_name_get (raw_code, code);							-- get language name; try ietf tag first, then code w/o variant then code w/ variant

	if 'yes' ~= args.raw then
		language_name = language_name:gsub ('%s+%b()', '');						-- remove IANA parenthetical disambiguators or qualifiers from names that have them
	end

	if link then																-- when |link=yes, wikilink the language name
		if mw.ustring.find (language_name, 'ngữ', 1, true) then
			language_name = make_wikilink (language_name, label);				-- collective language name uses simple wikilink
		elseif lang_data.article_name[raw_code:lower()] then					-- is ietf tag in article name override?
			language_name = make_wikilink (lang_data.article_name[raw_code:lower()], label or language_name);	-- language name with wikilink from override data
		elseif lang_data.article_name[code] then								-- is language tag in article name override?
			language_name = make_wikilink (lang_data.article_name[code], label or language_name);	-- language name with wikilink from override data
		else
			language_name = make_wikilink (substitute ('$1 $2', {cfg.misc_text_t.language, language_name}));	-- language name with wikilink
		end
	end

	if link or mw.ustring.find (language_name, 'ngữ', 1, true) then
	    return language_name;
	end
	return substitute ('$1 $2', {cfg.misc_text_t.language, language_name});
end


--[[--------------------------< N A M E _ F R O M _ T A G >----------------------------------------------------

Module entry point from an {{#invoke:}}.

]]

local function name_from_tag (frame)											-- entry point from an {{#invoke:Lang|name_from_tag|<ietf tag>|link=<yes>|template=<template name>}}
	return _name_from_tag (getArgs(frame))										-- pass-on the args table, nothing else; getArgs() so we also get parent frame
end


--[[--------------------------< _ T A G _ F R O M _ N A M E >--------------------------------------------------

Returns the ietf language tag associated with the language name.  Spelling of language name must be correct
according to the spelling in the source tables.  When a standard language name has a parenthetical disambiguator,
that disambiguator must be omitted (they are not present in the data name-to-tag tables).

Module entry point from another module.

]]

local function _tag_from_name (args)											-- entry point from another module
	local msg;

	if args[1] and '' ~= args[1] then
		local data = mw.loadData ('Module:Lang/tag from name');					-- get the reversed data tables TODO: change when going live
		local lang = args[1]:lower();											-- allow any-case for the language name (speeling must till be correct)
		local tag = data.rev_override_table[lang] or data.rev_lang_table[lang] or data.rev_lang_dep_table[lang];	-- get the code; look first in the override then in the standard

		if tag then
			return tag, true;													-- language name found so return tag and done; second return used by is_lang_name()
		else
			msg = substitute (cfg.tag_from_name_t.lang_not_found, {args[1]});	-- language name not found, error message
		end
	else
		msg = cfg.tag_from_name_t.missing_lang_name;							-- language name not found, error message
	end

	local template = '';
	if args.template and '' ~= args.template then
		template = table.concat ({'{{', args['template'], '}}: '});				-- make template name (if provided by the template)
	end
	return make_error_span (template, msg);

end


--[[--------------------------< T A G _ F R O M _ N A M E >----------------------------------------------------

Module entry point from an {{#invoke:}}.

]]

local function tag_from_name (frame)											-- entry point from an {{#invoke:Lang|tag_from_name|<language name>|link=<yes>|template=<template name>}}
	local result, _ = _tag_from_name (getArgs(frame))							-- pass-on the args table, nothing else; getArgs() so we also get parent frame; supress second return used by is_lang_name()
	return result;		
end


--[[--------------------------< I S _ L A N G _ N A M E >------------------------------------------------------

Module entry point from an {{#invoke:}}.

]]

local function is_lang_name (frame)
	local _, result = _tag_from_name (getArgs(frame))							-- pass-on the args table, nothing else; getArgs() so we also get parent frame; supress second return used by tag_from_name()
	return result and true or nil;		
end


--[[--------------------------< _ T R A N S L >----------------------------------------------------------------

Module entry point from another module.

]]

local function _transl (args)
	local title_table = lang_data.translit_title_table;							-- table of transliteration standards and the language codes and scripts that apply to those standards
	local language_name;														-- language name that matches language code; used for tool tip
	local translit;																-- transliterated text to display
	local script;																-- IANA script
	local msg;																	-- for when called functions return an error message
	local template = args.template or cfg.templates_t.transliteration;

	maint_cats = {};															-- initialize because when this module required into another module, these only declared once so only initialzed once
	maint_msgs = {};
	
	if is_set (args[3]) then													-- [3] set when {{transliteration|code|standard|text}}
		args.text = args[3];													-- get the transliterated text
		args.translit_std = args[2] and args[2]:lower();						-- get the standard; lower case for table indexing

		if not title_table[args.translit_std] then
			return make_error_msg (substitute (cfg.transl_t.unrecog_xlit_std, {args.translit_std}), args, template);
		end
	else
		if is_set (args[2]) then												-- [2] set when {{transliteration|code|text}}
			args.text = args[2];												-- get the transliterated text
		else
			if args[1] and (args[1]:match ('^%a%a%a?%a?$') or					-- args[2] missing; is args[1] a language or script tag or is it the transliterated text?
				args[1]:match ('^%a%a%a?%-x%-')) then							-- or is args[1] a private-use tag
					return make_error_msg (cfg.transl_t.no_text, args, template);	-- args[1] is a code so we're missing text
			else
				args.text = args[1];											-- args[1] is not a code so we're missing that; assign args.text for error message
				return make_error_msg (cfg.transl_t.missing_lang_scr, args, template);
			end
		end
	end

	if is_set (args[1]) then													-- IANA language code used for html lang= attribute; or ISO 15924 script code
		if args[1]:match ('^%a%a%a?%a?$') or args[1]:match ('^%a%a%a?%-x%-') then	-- args[1] has correct form?
			args.code = args[1]:lower();										-- use the language/script code; only (2, 3, or 4 alpha characters) or private-use; lower case because table indexes are lower case
		else
			return make_error_msg (substitute (cfg.transl_t.unrecog_lang_scr, {args[1]}), args, template);	-- invalid language / script code
		end
	else
		return make_error_msg (cfg.transl_t.missing_lang_scr, args, template);	-- missing language / script code so quit
	end

	local is_latn_text, pos, char;
	is_latn_text, args.text, pos, char= is_latin (args.text, args.code);		-- is latn text? strip accept-as-written markup
	if not is_latn_text then													-- when text is not latn
		return make_error_msg (substitute (cfg.lang_xx_t.translit_nonlatn, {pos, char}), args, template);	-- abandon with error message
	end


	args.italic, msg = validate_italic (args);
	if msg then
		return make_error_msg (msg, args, template);
	end
	
	if 'italic' == args.italic then												-- 'italic' when |italic=yes; because that is same as absent or not set and |italic=default
		args.italic = nil;														-- set to nil; 
	end

	args.engvar = cfg.engvar_sel_t[args.engvar] or cfg.default_engvar;			-- |engvar= when valid; cfg.default_engvar else

	if override_table[args.code] then											-- is code a language code defined in the override table?
		language_name = override_table[args.code];
		args.code = args.code:match ('^%a%a%a?');								-- if private use, strip all but language subtag
	elseif lang_table[args.code] then											-- is code a language code defined in the standard language code tables?
		language_name = lang_table[args.code];
	elseif lang_dep_table[args.code] then										-- is code a language code defined in the deprecated language code tables?
		language_name = lang_dep_table[args.code];
	elseif script_table[args.code] then											-- if here, code is not a language code; is it a script code?
		language_name = script_table[args.code];
		script = args.code;														-- code was an ISO 15924 script so use that instead
		args.code = '';															-- unset because not a language code
	else
		return make_error_msg (substitute (cfg.transl_t.unrecog_lang_scr, {args.code}), args, template);	-- invalid language / script code
	end
																				-- here only when all parameters passed to make_translit() are valid
	return make_translit (args.code, language_name, args.text, args.translit_std, script, args.italic, args.engvar);
end


--[[--------------------------< T R A N S L >------------------------------------------------------------------

Module entry point from an {{#invoke:}}.

]]

local function transl (frame)
	return _transl (getArgs(frame));
end


--[[--------------------------< C A T E G O R Y _ F R O M _ T A G >--------------------------------------------

Returns category name associated with IETF language tag if valid; error message else.

All code combinations supported by {{lang}} and the {{lang-??}} templates are supported by this function.

Module entry point from another module.

]]

local function _category_from_tag (args_t)
	local subtags = {};															-- IETF subtags script, region, variant, and private
	local raw_code = args_t[1];													-- save a copy of the input IETF subtag
	local link = cfg.keywords_t.affirmative == args_t.link;						-- make a boolean
	local label = args_t.label;
	local code;																	-- the language code
	local msg;																	-- gets an error message if IETF language tag is malformed or invalid
	local category_name = '';
	
	code, subtags.script, subtags.region, subtags.variant, subtags.private, msg = get_ietf_parts (raw_code);
	if msg then
		local template = (args_t.template and table.concat ({'{{', args_t.template, '}}: '})) or '';	-- make template name (if provided by the template)
		return make_error_span (template, msg);
	end

	raw_code = format_ietf_tag (code, subtags.script, subtags.region, subtags.variant, subtags.private);	-- format to recommended subtag styles; private omitted because private
	category_name = language_name_get (raw_code, code);							-- get language name; try ietf tag first, then code w/o variant then code w/ variant
	category_name = make_category (code, category_name, nil, true):gsub ('[%[%]]', '');

	if link then
		return table.concat ({'[[:', category_name, ']]'});
	else
		return category_name;
	end
end


--[[--------------------------< C A T E G O R Y _ F R O M _ T A G >--------------------------------------------

Module entry point from an {{#invoke:}}.

]]

local function category_from_tag (frame)										-- entry point from an {{#invoke:Lang|category_from_tag|<ietf tag>|template=<template name>}}
	return _category_from_tag (getArgs (frame));								-- pass-on the args table, nothing else; getArgs() so we also get parent frame
end


--[[--------------------------< E X P O R T E D   F U N C T I O N S >------------------------------------------
]]

return {
	category_from_tag = category_from_tag,
	lang = lang,																-- entry point for {{lang}}
	langx = langx,																-- entry point for {{langx}}
	lang_xx_inherit = lang_xx_inherit,											-- entry points for {{lang-??}}
	lang_xx_italic = lang_xx_italic,
	is_ietf_tag = is_ietf_tag,
	is_ietf_tag_frame = is_ietf_tag_frame,
	is_lang_name = is_lang_name,
	tag_from_name = tag_from_name,												-- returns ietf tag associated with language name
	name_from_tag = name_from_tag,												-- used for template documentation; possible use in ISO 639 name from code templates
	transl = transl,															-- entry point for {{transliteration}}
	
	_category_from_tag = _category_from_tag,									-- entry points when this module is require()d into other modules
	_lang = _lang,
	_langx = _langx,
	_lang_xx_inherit = _lang_xx_inherit,
	_lang_xx_italic = _lang_xx_italic,
	_is_ietf_tag = _is_ietf_tag,
	get_ietf_parts = get_ietf_parts,
	_tag_from_name = _tag_from_name, 
	_name_from_tag = _name_from_tag,
	_transl = _transl,
	_translation_make = translation_make,
	};
