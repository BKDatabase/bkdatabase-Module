--[[--------------------------< T E M P L A T E S _ T >--------------------------------------------------------
]]

local templates_t = {
	lang = 'Lang',
	langx = 'Langx',
	langxx = 'Lang-xx',
	transliteration = 'Transliteration',
	}


--[[--------------------------< K N O W N _ P A R A M S >------------------------------------------------------

lists of all parameters known to {{lang}}, {{langx}}, {{lang-xx}} templates.

Exception: |fn= is known to {{lang}} but is not a 'lang' template;  that parameter causes the module to call the
specified lang(), lang_xx_inherit(), or lang_xx_italic() function.  These separate functions set |fn= to nill
and then do the known-param checking on the other template parameters

]]

local known_params_t = {
	['common_params_all_t'] = {													-- these parameters common to {{lang}}, {{langx}}, and {{lang-xx}}
		['code'] = true,
		['text'] = true,
		['rtl'] = true,
		['italic'] = true,
		['italics'] = true,
		['i'] = true,
		['size'] = true,
		['proto'] = true,
		['nocat'] = true,
		['cat'] = true,

		['template'] = true,													-- supplied by external templates to provide template name for error messaging ({{nihongo}}, etc)
		},
	
	['params_lang_t'] = {														-- unique to {{lang}}
		[1] = true,																-- alias of |code=
		[2] = true,																-- alias of |text=
		},

	['params_x_t'] = {															-- common to {{langx}} and {{lang-xx}}
		['translit'] = true,
		['translit-std'] = true,
		['translit-script'] = true,
		['translation'] = true,
		['lit='] = true,
		['label'] = true,
		['link'] = true,
		['links'] = true,
		['lit'] = true,
		['engvar'] = true,
		},

	['params_langx_t'] = {														-- unique to {{langx}}
		[1] = true,																-- alias of |code=
		[2] = true,																-- alias of |text=
		[3] = true,																-- alias of |translit=
		[4] = true,																-- alias of |translation=
		},

	['params_lang_xx_t'] = {													-- unique to {{lang-xx}}
		[1] = true,																-- alias of |text=
		[2] = true,																-- alias of |translit=
		[3] = true,																-- alias of |translation=
		['script'] = true,														-- these needed to override default params in {{lang-??}} templates
		['region'] = true,
		['variant'] = true,
		},
	}


--[[--------------------------< E N G _ V A R >----------------------------------------------------------------

Used at en.wiki so that spelling of 'romanized' (US, default) can be changed to 'romanised' to match the envar
specified by a {{Use xxx English}}.  Not likely useful outside of en.wiki

This is accomplished by setting |engvar=gb; can, should be omitted in articles that use American English; no
need for the clutter.

]]

local engvar_sel_t = {															-- select either UK English or US English
	['au'] = 'gb_t',															-- these match IANA region codes (except in lower case)
	['ca'] = 'us_t',
	['gb'] = 'gb_t',
	['ie'] = 'gb_t',
	['in'] = 'gb_t',
	['nz'] = 'gb_t',
	['us'] = 'us_t',															-- default engvar
	['za'] = 'gb_t'
	};

local engvar_t = {
	['gb_t'] = {
		['romanisz_lc'] = 'Latinh hoá',											-- lower case
		['romanisz_uc'] = 'Latinh hoá',											-- upper case; unused can be deleted
		['romanisz_pt'] = 'đã Latinh hoá',										-- past tense
		},
	['us_t'] = {																-- default engvar
		['romanisz_lc'] = 'Latinh hoá',											-- lower case
		['romanisz_uc'] = 'Latinh hoá',											-- upper case; unused can be deleted
		['romanisz_pt'] = 'đã Latinh hoá',										-- past tense
		}
	}

local default_engvar = 'us_t';


--[[
=============================<< M E S S A G I N G   T A B L E S >>=============================================

these tables are for internationalization.  Messages or fragments thereof are mostly grouped by function name.
Some messages are shared by functions other than the function table that lists the message or fragment.

]]


--[[--------------------------< K E Y W O R D S _ T >----------------------------------------------------------
]]

local keywords_t = {
	['affirmative'] = 'yes',
	['negative'] = 'no',
	['unset'] = 'unset',
	['invert'] = 'invert',
	['default'] = 'default',
	}


--[[--------------------------< M I S C _ T E X T _ T >--------------------------------------------------------



]]

local misc_text_t = {
	['error'] = 'Lỗi',														-- make_error_msg(), tag_from_name()
	['language'] = 'tiếng',													-- make_translit(), lang_xx(), name_from_tag()
	['help'] = 'trợ giúp',
	}


--[[--------------------------< M A K E _ E R R O R _ M S G _ T >----------------------------------------------
]]

local make_error_msg_t = {
	['xlit_err_cat'] = 'Lỗi bản mẫu transliteration',
	['lang_err_cat'] = 'Lỗi bản mẫu lang và lang-xx',
	['undefined'] = 'không xác định',
	}
	

--[[--------------------------< V A L I D A T E _ I T A L I C _ T >--------------------------------------------
]]

local parameter_validate_t = {
	['invalid_param'] = 'Tham số không hợp lệ: &#124;$1=',							-- $1 is parameter name
	}


--[[--------------------------< V A L I D A T E _ I T A L I C _ T >--------------------------------------------
]]

local validate_italic_t = {
	['multi_italic'] = 'chỉ có thể định rõ một trong số &#124;italic=, &#124;italics=, hoặc &#124;i=',
	}
	

--[[--------------------------< V A L I D A T E _ T E X T _ T >------------------------------------------------
]]

local validate_text_t = {
	['no_text'] = 'không có văn bản',
	['malformed_markup'] = 'văn bản có thẻ đánh dấu hỏng',
	['italic_markup'] = 'văn bản có thẻ đánh dấu in nghiêng',
	}


--[[--------------------------< T E X T _ S C R I P T _ M A T C H _ T E S T _ T >------------------------------
]]

local text_script_match_test_t = {
	['latn_txt_mismatch'] = 'Văn bản latn/thẻ hệ chữ viết phi latn không khớp',
	['latn_scr_mismatch'] = 'Văn bản phi latn (vị trí $1: $2)/thẻ hệ chữ viết latn không khớp',	-- $1 identifies offending character's position; $2 is the character
	}


--[[--------------------------< L A N G _ T >------------------------------------------------------------------
]]

local lang_t = {
	['conflict_n_param'] = 'xung đột: {{{$1}}} và &#124;$2=',							-- $1 is positional param number, $2 is named param; shared with _lang_xx()
	['conflict_n_param_types'] = {
		['code'] = 'code',
		['text'] = 'text',
		['translit'] = 'translit',
		},
	['invalid_proto'] = '&#124;proto=: $1 không hợp lệ',								-- _lang_xx also emits this message
	}
	
	
--[[--------------------------< L A N G _ X X _ T >------------------------------------------------------------
]]

local lang_xx_t	= {
	['conflict_n_lit'] = 'xung đột: {{{$1}}} và &#124;lit= hoặc &#124;translation=',	-- $1 is positional parameter; can be either 3 ({{lang-??}}) or 4 ({{langx}})
	['conflict_lit'] = 'xung đột: &#124;lit= và &#124;translation=',
	['conflict_link'] = 'xung đột: &#124;links= và &#124;link=',
	['invalid_xlit_std'] = 'translit-std không hợp lệ',
	['romanization'] = 'Latinh hoá tiếng',
	['translit_nonlatn'] = 'văn bản chuyển tự không phải chữ Latinh (vị trí $1: $2)',			-- _transl() also emits this message; $1 identifies offending character's position; $2 is the character
	['xlit_of_latn'] = 'chuyển tự chữ latn',
	}


--[[--------------------------< T A G _ F R O M _ N A M E _ T >------------------------------------------------
]]

local tag_from_name_t = {
	['lang_not_found'] = 'ngôn ngữ: không tìm thấy $1',								-- $1 is language name parameter value
	['missing_lang_name'] = 'thiếu tên ngôn ngữ',
	}


--[[--------------------------< T R A N S L _ T >--------------------------------------------------------------
]]

local transl_t = {
	['unrecog_xlit_std'] = 'tiêu chuẩn chuyển tự không rõ: $1',					-- $1 is |translit_std- parameter value
	['no_text'] = 'không có văn bản',
	['missing_lang_scr'] = 'thiếu mã ngôn ngữ / hệ chữ viết',
	['unrecog_lang_scr'] = 'mã ngôn ngữ / hệ chữ viết không rõ: $1',			-- $1 is the language/script code
	}


--[[--------------------------< G E T _ I E T F _ P A R T S _ T >----------------------------------------------
]]

local get_ietf_parts_t = {
	['maint_promo_cat'] = 'Mã lang và lang-xx được nâng cấp thành ISO 639-1|$1',			-- $1 is ISO 639-2/3 subtag
	['maint_promo_msg'] = 'mã: $1 được nâng cấp thành mã: $2',								-- $1 is ISO 639-2/3 subtag, $2 is synonymous ISO 639-1 subtag

	['missing_lang_tag'] = 'thiếu thẻ ngôn ngữ',											-- also used in _langx()
	['redundant_scr'] = 'thẻ hệ chữ viết thừa',
	['redundant_reg'] = 'thẻ vùng thừa',
	['redundant_var'] = 'thẻ biến thể thừa',
	['unrecog_tag'] = 'thẻ ngôn ngữ không rõ: $1',											-- $1 is the whole language tag
	['unrecog_code'] = 'mã ngôn ngữ không rõ: $1',											-- $1 is code
	['unrecog_reg_code'] = 'vùng không rõ: $1 cho mã: $2',									-- $1 is region, $2 is code
	['unrecog_scr_code'] = 'hệ chữ viết không rõ: $1 cho mã: $2',							-- $1 is script, $2 is code
	['script_code'] = 'hệ chữ viết: $1 không được hỗ trợ cho mã: $2',						-- $1 is script, $2 is code
	['unrecog_var'] = 'biến thể không rõ: $1',												-- $1 is variant
	['unrecog_var_code'] = 'biến thể không rõ: $1 cho mã: $2',								-- $1 is variant, $2 is code
	['unrecog_var_code_scr'] = 'biến thể không rõ: $1 cho cặp mã-hệ chữ viết: $2-$3',		-- $1 is variant, $2 is code, $3 is script
	['unrecog_var_code_reg'] = 'biến thể không rõ: $1 cho cặp mã-vùng: $2-$3',				-- $1 is variant, $2 is code, $3 is region
	['unrecog_pri'] = 'thẻ riêng không rõ: $1',												-- $1 is private tag
	}


--[[--------------------------< L A N G U A G E _ N A M E _ G E T _ T >----------------------------------------
]]

local language_name_get_t = {
	['deprecated_cat'] = 'Lang và lang-xx sử dụng mã ISO 639 lỗi thời |$1',					-- $1 is deprecated ISO 639 subtag
	['deprecated_msg'] = 'mã: $1 đã lỗi thời',												-- $1 is deprecated ISO 639 subtag
	}


--[[--------------------------< H T M L _ T I T L E _ T E X T _ T >--------------------------------------------
]]

local make_text_html_t = {
	['zxx'] = 'Văn bản',												-- for zxx no linguistic content
	['collective'] = 'Văn bản ngôn ngữ',								-- for collective languages
	['individual'] = 'Văn bản tiếng',									-- for individual languages
	}


--[[--------------------------< T R A N S L A T I O N _ M A K E _ T >------------------------------------------
]]

local translation_make_t = {
	['lit_xlation'] = 'Dịch nghĩa đen',									-- article title fragment and html title attribute
	['lit_abbr'] = 'n.đ.',
	}


--[[--------------------------< M A K E _ C A T E G O R Y _ T >------------------------------------------------
]]

local make_category_t = {
	['collective_cat'] = 'Thể loại:Bài viết có văn bản',						-- for collective languages
	['cat_prefix'] = 'Thể loại:Bài viết có',									-- prefix for explicitly cited and individual languages
	['explicit_cat'] = 'nêu rõ',											-- for explicitly citing this wiki's language
	['cat_postfix'] = 'văn bản tiếng',											-- postfix for individual languages
	}
	

--[[--------------------------< M A K E _ T R A N S L I T _ T >------------------------------------------------
]]

local make_translit_t = {
	['script'] = 'chữ',
	['transliteration'] = 'Chuyển tự',
	}


--[[--------------------------< E X P O R T S >----------------------------------------------------------------
]]

return {
	known_params_t = known_params_t,
	templates_t = templates_t,

	default_engvar = default_engvar,											-- engvar support not likely useful outside of en.wiki
	engvar_t = engvar_t,
	engvar_sel_t = engvar_sel_t,

	get_ietf_parts_t = get_ietf_parts_t,										-- messaging tables
	keywords_t = keywords_t,
	lang_t = lang_t,
	lang_xx_t = lang_xx_t,
	language_name_get_t = language_name_get_t,
	make_category_t = make_category_t,
	make_error_msg_t = make_error_msg_t,
	make_text_html_t = make_text_html_t,
	make_translit_t = make_translit_t,
	misc_text_t = misc_text_t,
	parameter_validate_t = parameter_validate_t,
	tag_from_name_t = tag_from_name_t,
	text_script_match_test_t = text_script_match_test_t,
	transl_t = transl_t,
	translation_make_t = translation_make_t,
	validate_italic_t = validate_italic_t,
	validate_text_t = validate_text_t,
	}
