require('strict');

local getArgs = require ('Module:Arguments').getArgs;
local unicode = require ("Module:Unicode data");								-- for is_latin()
local lang = require ('Module:Lang');

local namespace = mw.title.getCurrentTitle().namespace;							-- used for categorization

local err_texts = {																-- because wrapper templates have Latn/non-Latn text ordered according to the wrapper template's name
	['lang-sh-cyrl-latn'] = true,												-- this template has |1=cyrl script |2=latn script
	}


--[[--------------------------< E R R O R _ M S G _ M A K E >--------------------------------------------------

assembles an error message from template name, message text, help link, and error category.
<span style="font-family: monospace, monospace;">{{', template, '}}</span>
]]

local function error_msg_make (msg, template, nocat)
	local out = {};
	local category = 'Lang và lang-xx';

	table.insert (out, table.concat ({'<span style=\"color:#d33\">Lỗi: <span style="font-family: monospace, monospace;">{{', template, '}}</span>: '}));
	table.insert (out, msg);
	table.insert (out, table.concat ({' ([[Bản mẫu:', template, '#Error messages|trợ giúp]])'}));
	table.insert (out, '</span>');
	
	if (0 == namespace or 10 == namespace) and not nocat then					-- categorize in article space (and template space to take care of broken usages)
		table.insert (out, table.concat ({'[[Thể loại:Lỗi bản mẫu lang và lang-xx]]'}));
	end

	return table.concat (out);
end
	

--[[--------------------------< S E P A R A T O R _ G E T >----------------------------------------------------

allowed separators are comma, semicolon, virgule, or a quoted string of text

]]

local function separator_get (sep_param_val)
	if not sep_param_val then return ', ' end;									-- not specified, use default
	if ',' == sep_param_val then return ', ' end;
	if ';' == sep_param_val then return '; ' end;
	if '/' == sep_param_val then return '/' end;
	local str;
	if sep_param_val:match ('^%b\"\"$') then									-- if quoted string and uses double quotes
		str = sep_param_val:match ('%b\"\"'):gsub ('^"', ''):gsub ('"$', '');
		return str;																-- return the contents of the quote
	elseif sep_param_val:match ('^%b\'\'$') then								-- if quoted string and uses single quotes
		str = sep_param_val:match ('%b\'\''):gsub ('^\'', ''):gsub ('\'$', '');
		return str;																-- return the contents of the quote
	end
	return ', ';																-- default in case can't extract quoted string
end


--[[--------------------------< P A R A M _ S E L E C T >------------------------------------------------------

Selects the appropriate enumerated parameters for <text1> or <text2> according to <swap>

<args_t> - arguments table from frame
<lang_args_t> - arguments table to be supplied to _lang() (whichever text renders second)
<lang_xx_args_t> - arguments table to be supplied to _lang_xx_inherit() or _lang_xx_italic() (whichever text renders first)

]]

local function param_select (args_t, lang_args_t, lang_xx_args_t, swap)
	local enum_xx = swap and '2' or '1';
	local enum = swap and '1' or '2';
	
	lang_xx_args_t.script = args_t['script' .. enum_xx];						-- these for <textn> that renders first (uses {{lang-xx}})
	lang_xx_args_t.region = args_t['region' .. enum_xx];
	lang_xx_args_t.variant = args_t['variant' .. enum_xx];
	lang_xx_args_t.italic = args_t['italic' .. enum_xx];
	lang_xx_args_t.size = args_t['size' .. enum_xx];
	
	lang_args_t.italic = args_t['italic' .. enum];								-- these for <textn> that renders second (uses {{lang}})
	lang_args_t.size = args_t['size' .. enum];
end


--[[--------------------------< I E T F _ T A G _ M A K E >----------------------------------------------------

make ietf tag for _lang() (second rendered <textn>)

]]

local function ietf_tag_make (args_t, tag, swap)
	local ietf_tag_t = {tag};													-- initialize with <tag>
	local enum = swap and '1' or '2';											-- when <swap> is true latin <text1> is rendered second by _lang()
	
	for _, param in ipairs ({'script'..enum, 'region'..enum, 'variant'..enum}) do
		if args_t[param] then table.insert (ietf_tag_t, args_t[param]) end		-- build <ietf_tag> from <enum>erated subtags
	end

	return table.concat (ietf_tag_t, '-');										-- concatenate subtags with hyphen separator and done
end


--[[--------------------------< _ L A N G _ X 2 >--------------------------------------------------------------

mimics {{lang|<tag>|<text1>|<text2>}} except that <text2> is not a romanization of <text1> (which is always the
Latin-script form).  Intended for languages where two scripts are 'official' or 'native and equal in status' (sh
is and sr may be a candidate for this; are there others?)

{{lang_x2|<tag>|<text1>|<text2>|swap=yes|script2=<script>|separator=[,|;|/|<quoted string>]}}

	<tag> - (required) language tag for both of <text1> and <text2>
	<text1> - (required) Latin-script text (always)
	<text2> - (required) non-Latin-script text (always)
	|swap= - when set to 'yes', swaps the rendered order so that <text2> renders first followed by <text1>; default is Latin-script <text1> first 
	|separator = when single character ,;/ uses ', ' (default), '; ', '/'; when quoted string (first and last characters must be matching single or double quotes) uses that string

parameters supported by both of {{lang}} and {{lang-??}} templates are passed along:
	|cat=
	|nocat=
	
parameters supported only by {{lang-??}} that are not enumerated:
	|label=
	|link=
	
enumerated parameters:
	|script1= - ISO 15924 script tag for <text1>								-- when <text1> renders first, these are passed to _lang_xx_...() individually
	|region1= - ISO 3166 region tag for <text1>									-- when <text1> renders second, these are combined with <tag> to make an IETF tag for _lang()
	|variant1= - IETF tag for <text1>

	|script2= - ISO 15924 script tag for <text2>								-- when <text2> renders first, these are passed to _lang_xx_...() individually
	|region2= - ISO 3166 region tag for <text2>									-- when <text2> renders second, these are combined with <tag> to make an IETF tag for _lang()
	|variant2= - IETF tag for <text2>

	|italic1=
	|size1=

	|italic2=
	|size2=

this function calls:
	Module:Lang functions
		_lang_xx_inherit - when non-Latin <text2> renders first
		_lang_xx_italic - when Latin <text1> renders first
		_lang - to render <text2>
	Module:Unicode data function:
		is_Latin - error checking to make sure that <text1> is Latin-script text

]]

local function _lang_x2 (args_t)
	local tag = args_t.tag or args_t[1];
	local text1 = args_t.text1 or args_t[2];
	local text2 = args_t.text2 or args_t[3];
	local translation = args_t.translation or args_t[4];
	local template_name = args_t.template_name or 'lang-x2';
	local nocat = ('yes' == args_t.nocat) or ('no' == args_t.cat);				-- boolean

	if not (tag and text1 and text2) then
		return error_msg_make ('thiếu đối số bắt buộc', template_name, nocat);
	end
	if tag:find ('-', 1, true) then
		return error_msg_make ('thẻ ngôn ngữ không hợp lệ: <span style="font-family: monospace, monospace;">' .. tag .. '</span>; định dạng IETF không được hỗ trợ', template_name, nocat);
	end
	local is_latn, pos = unicode.is_Latin (text1);
	if not is_latn then
		return error_msg_make ('<span style="font-family: monospace, monospace;">&lt;' .. ((err_texts[template_name:lower()] and 'text2') or 'text1') .. '></span> không phải chữ Latinh (vị trí ' .. pos .. ')', template_name, nocat);
	end
	is_latn, pos = unicode.is_Latin (text2);
	if is_latn then
		return error_msg_make ('<span style="font-family: monospace, monospace;">&lt;' .. ((err_texts[template_name:lower()] and 'text1') or 'text2') .. '></span> là chữ Latinh (vị trí ' .. pos .. ')', template_name, nocat);
	end
	
	local swap = 'yes' == args_t.swap;											-- boolean
	local out = {};

	local ietf_tags = ietf_tag_make (args_t, tag, swap);						-- for calls to {{lang}}
																				-- create base-form arguments tables	
	local lang_xx_args_t = {['code']=tag, ['label']=args_t.label, ['link']=args_t.link, ['cat']=args_t.cat, ['nocat']=args_t.nocat, ['cat']=args_t.cat};	-- for whichever <textn> renders first
	local lang_args_t = {['code']=ietf_tags, ['cat']=args_t.cat, ['nocat']=args_t.nocat, ['cat']=args_t.cat};		-- for whichever <textn> renders second
	
	param_select (args_t, lang_args_t, lang_xx_args_t, swap);					-- load <lang_args_t>, <lang_xx_args_t> tables with appropriate enumerated parameters from <args_t> table according to <swap>

	if swap then																-- non-Latin script <text2> renders first
		lang_xx_args_t.text = text2;
		lang_args_t.text = text1;
		table.insert (out, lang._lang_xx_inherit (lang_xx_args_t));				-- render non-Latin script <text2> upright
	else																		-- Latin script <text1> renders first
		lang_xx_args_t.text = text1;
		lang_args_t.text = text2;
		table.insert (out, lang._lang_xx_italic (lang_xx_args_t));				-- render Latin script <text1> in italics
	end

	table.insert (out, separator_get (args_t.separator));						-- insert the separator
	table.insert (out, lang._lang (lang_args_t));								-- and render the other of <text1> or <text2>
	
	if translation then															-- if positional parameter 4 (translation of <text1> and <text2>)
		table.insert (out, lang._translation_make ({['translation'] = translation, ['label']=args_t.label, ['link']=args_t.link}));	-- add translation to rendering
	end

	return table.concat (out)
end


--[[--------------------------< L A N G _ X 2 >----------------------------------------------------------------

implements {{lang-x2}}; template entry point

]]

local function lang_x2 (frame)
	local args_t = getArgs (frame);
	return _lang_x2 (args_t);
end


--[[--------------------------< E X P O R T E D   F U N C T I O N S >------------------------------------------
]]

return {
	lang_x2 = lang_x2,
	}
