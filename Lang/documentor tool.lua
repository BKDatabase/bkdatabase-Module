require('strict')
local p = {}

--[[ -------------------------< P R I V A T E _ T A G S >------------------------------------------------------

{{#invoke:Lang/documentor tool|private_tags}}

Reads the override{} table in Module:Lang/data and renders a wiki table of private tags and their associated languages

]]

local function private_tags (frame)
	local override_t = mw.loadData ('Module:Lang/data').override				-- get the override table
	
	local private_t = {}

	for tag, lang in pairs (override_t) do
		if tag:find ('%-x%-') then
			table.insert (private_t, table.concat ({'\n|-\n|', lang, '||', tag}))
		end
	end
	table.sort (private_t)

	table.insert (private_t, 1, '{| class="wikitable sortable"')
	table.insert (private_t, 2, '\n|+ Supported private-use IETF language tags')
	table.insert (private_t, 3, '\n! Language !! Private-use tag')

	return table.concat (private_t) .. '\n|}'
--	return '<pre>' .. table.concat (private_t) .. '\n|}' .. '</pre>'
--error (mw.dumpObject (private_t))
end


--[[ -------------------------< L A N G - X X _ S E T T I N G S >----------------------------------------------

{{#invoke:Lang/documentor tool|lang_xx_settings|template={{ROOTPAGENAME}}}}

Reads the content of the template and extracts the parameters from {{#invoke:Lang|...}} for display on the template's
documentation page.

]]

local function lang_xx_settings(frame)
	local page = mw.title.makeTitle('Template', frame.args['template'] or frame.args[1])	-- get a page object for this page in 'Template:' namespace
	if not page then
		return ''																-- TODO: error message?
	end

	local content = page:getContent()											-- get unparsed content
	if not page then
		return ''																-- TODO: error message?
	end

	local out = {}

	local params
	local style

	if content:match('{{%s*#invoke:%s*[Ll]ang%s*|[^|]+|[^}]+}}') or content:match('{{%s*#invoke:%s*[Ll]ang/sandbox%s*|[^|]+|[^}]+}}') then			-- if this template uses [[Module:Lang]]
		params = content:match('{{%s*#invoke:%s*[Ll]ang%s*|[^|]+(|[^}]+)}}') or content:match('{{%s*#invoke:%s*[Ll]ang/sandbox%s*|[^|]+(|[^}]+)}}')	-- extract the #invoke:'s parameters
		if not params then 
			return ''															-- there should be at least one or the template/module won't work TODO: error message?
		end
		table.insert(out, '{| class="wikitable" style="text-align: right; float: right;"\n|+settings')	-- start a wikitable
		for k, v in params:gmatch('%s*|%s*([^%s=]+)%s*=%s*([^%s|]+)') do		-- get the parameter names (k) and values (v)
			if 'label' == k then												-- special case for labels because spaces and pipes
				v = params:match('label%s*=%s*(%[%[[^%]]+%]%])') or params:match('label%s*=%s*([^|\n]+)') or 'missing label'
			end
			table.insert(out, table.concat({k, '\n|', v}))						-- make rudimentary wikitable entries
		end

		style = content:match('lang_xx_([^|]+)')
		if not style or ('italic' ~= mw.text.trim (style) and 'inherit' ~= mw.text.trim (style)) then
			return '<span style="color:#d33">Error: template #invoke calls unknown function</span>'
		end
		return table.concat({table.concat(out,'\n|-\n! scope="row" | '), '\n|-\n|colspan="2"|style: ', style, '\n|-\n|}'})	-- add inter-row markup and close the wikitable and done
	else
		return ''																-- does not use [[Module:Lang]] so abandon quietly
	end
end


--[[ -------------------------- < U S E S _ M O D U L E > --------------------------

{{#invoke:Lang/documentor tool|uses_module|template={{ROOTPAGENAME}}}}

Reads the content of the template to determine if this {{lang-xx}} template uses Module:Lang.
Returns the index of the substring '{{#invoke|lang|' in the template page content if true; empty string if false.

Used in template documentation {{#if:}} parser functions.

]]

local function uses_module(frame)
	local page = mw.title.makeTitle('Template', frame.args['template'] or frame.args[1])	-- get a page object for this page in 'Template:' namespace
	if not page then
		return ''																-- TODO: error message?
	end

	local content = page:getContent()											-- get unparsed content
	if not page then
		return ''																-- TODO: error message?
	end

	return content:find('{{%s*#invoke:[Ll]ang%s*|') or ''						-- return index or empty string
end


--[[ -------------------------- < S H A R E D _ C O D E > --------------------------

- Tables:
-- language_categories
-- error_messages
-- strings

- Functions:
-- make_error(message, layout, parent_category, nocat)
-- get_language_link(language_name, language_code)
-- get_see_also_section(page_title, language_name, language_code)
-- get_hidden_category_template(frame)
-- get_top_section(frame)
-- get_bottom_section(frame, language_name, see_also_section, parent_category)

]]

local language_categories = {
	["LANGUAGES_SOURCES"] = "Articles with %s-language sources (%s)",
	["LANGUAGES_COLLECTIVE_SOURCES"] = "Articles with %s-collective sources (%s)",
	["CS1"] = "CS1 %s-language sources (%s)",
	["LANGUAGE_TEXT"] = "Articles containing %s-language text",
	-- old version ["LANGUAGES_COLLECTIVE_TEXT"] = "Articles with text from the %s collective",
	["LANGUAGES_COLLECTIVE_TEXT"] = "Articles with text in %s",
	["ENGLISH"] = "Articles containing explicitly cited %s-language text",
}

local error_assistance = " Please see [[Template talk:Lang]] for assistance."

local error_messages = {
	["ASSISTANCE"] = "Please see [[Template talk:Lang]] for assistance.",
	["INCORRECT_CATEGORY_TITLE"] = "[[:%s]] is not the category being populated by the {{tlx|%s}} template. The correct category is located at: [[:%s]].",
	["NO_CATEGORY_TITLE_FOUND"] = "No language category found for '''%s.'''" .. error_assistance,
	["NOT_VALID_CATEGORY_FORMAT"] = "'''%s''' is not a a valid category title." .. error_assistance,
	["NOT_VALID_LANGUAGE_CODE"] = "[[%s]] is not a valid ISO 639 or IETF language name." .. error_assistance,
}

local strings = {
	["ERROR_CATEGORY"] = "[[Category:Lang and lang-xx template errors]]",
	["ERROR_SPAN"] = '<span style="font-size: 100%%; font-style: normal;" class="error">Error: %s </span>',
	["PURGE_DIV"] = '<div style="font-size: x-small;">%s</div>',
	["SEE_ALSO"] = "\n==See also==",
	["SEE_ALSO_ITEM"] = "* [[:%s]]",
}


--[[ -------------------------- < M A K E _ E R R O R > --------------------------

Create an error message.
Does not place page in error category if args.nocat is used.
Does not categorize in parent cateogory if used in category namespace (usually for /testcases).

]]

local function make_error(message, layout, parent_category, nocat)
	table.insert(layout, string.format(strings["ERROR_SPAN"], message))

	if not nocat then
		table.insert(layout, strings["ERROR_CATEGORY"])
	end

	if mw.title.getCurrentTitle().nsText == "Category" then
		table.insert(layout, parent_category)
	end

	return table.concat(layout)
end


--[[ -------------------------- < G E T _ L A N G U A G E _ L I N K > --------------------------

Generates a language link for the correct style.

Collective languages use the name_from_tag value,
while other languages use a display name of "x-language".

]]

local function get_language_link(language_name, language_code)
	local lang_module = require('Module:Lang')
	-- Is a language collective?
	if language_name:find('languages') then
		return lang_module.name_from_tag({language_code, link = "yes"})
	else
		return lang_module.name_from_tag({language_code, link = "yes", label = lang_module.name_from_tag({language_code}) .. "-language"})
	end
end


--[[ -------------------------- < G E T _ P R I M A R Y _ L A N G U A G E _ C O D E > --------------------------

Returns the primary language for sub-langage variants.

]]

local function get_primary_language_code(language_code)
	-- If no hyphen exists, return nil (for cases like "el")
	if not language_code:find("-") then
		return nil
	end
	
	-- Match everything before the first hyphen, but only if a hyphen exists
	if language_code:match("^-") then
		return nil  -- If the code starts with a hyphen, return nil
	end

	-- Look for the first part before any hyphen
	local primary_code = language_code:match("^[^-]+")
	return primary_code
end


--[[ -------------------------- < G E T _ S E E _ A L S O _ S E C T I O N > --------------------------

Generates a consistent style See also section for
{{Category articles containing non-English-language text}} and {{Non-English-language source category}}.

If {{CS1 language sources}} is converted, it should also use it.

]]

local function get_see_also_section(page_title, language_name, language_code)
	local see_also_section = {}

	for _, category_name in pairs(language_categories) do
		local category = mw.title.new(string.format(category_name, language_name, language_code), 14)
 		if category and page_title ~= category.text and category.exists then
			table.insert(see_also_section, string.format(strings["SEE_ALSO_ITEM"], category.prefixedText))
		end
	end

	table.sort(see_also_section)
	table.insert(see_also_section, 1, strings["SEE_ALSO"])

	if table.getn(see_also_section) == 1 then
		return ""
	else
		return table.concat(see_also_section, "\n")
	end
end


--[[ -------------------------- < G E T _ H I D D E N _ C A T E G O R Y _ T E M P L A T E > --------------------------

Generates the Template:Hidden category template.

This function is separate from the get_top_section() function
as this should be used in both error categories and valid categories.

]]

local function get_hidden_category_template(frame)
	return frame:expandTemplate{title = 'Hidden category'}
end


--[[ -------------------------- < G E T _ T O P _ S E C T I O N > --------------------------

Generates a consistent top maintenance template section which consists of:
-- Template:Possibly empty category
-- Template:Purge

]]

local function get_top_section(frame)
	local top_section = {}
	if mw.site.stats.pagesInCategory(mw.title.getCurrentTitle().text, "all") == 0 then
		table.insert(top_section, frame:expandTemplate{title = 'Possibly empty category'})
	else
		table.insert(top_section, frame:expandTemplate{title = 'Possibly empty category', args = {hidden=true}})
	end

	local purge_module = require('Module:Purge')
	table.insert(top_section, string.format(strings["PURGE_DIV"], purge_module._main({"Purge page cache"})))

	return table.concat(top_section, "\n\n")
end


--[[ -------------------------- < G E T _ B O T T O M _ S E C T I O N > --------------------------

Generates a consistent non-text section which consists of:
-- Template:Automatic category TOC
-- A see also section
-- {{DEFAULTSORT}}
-- Categorization in parent category

]]

local function get_bottom_section(frame, language_name, see_also_section, parent_category, parent_language_category)
	local bottom_section = {}
	table.insert(bottom_section, frame:expandTemplate{title = 'Automatic category TOC'})
	table.insert(bottom_section, see_also_section)

	if mw.title.getCurrentTitle().nsText == "Category" then
		table.insert(bottom_section, frame:preprocess{text = "{{DEFAULTSORT:" .. language_name .. "}}"})
		if parent_language_category then
			table.insert(bottom_section, "[[" .. parent_language_category .. "]]")
		end
		table.insert(bottom_section, parent_category)
	end

	return table.concat(bottom_section, "\n\n\n")
end


--[[ -------------------------- < N O N _ E N G L I S H _ L A N G U A G E _ T E X T _ C A T E G O R Y > --------------------------

{{#invoke:Lang/documentor tool|non_english_language_text_category}}

This function implements {{Non-English-language text category}}.

]]

local non_english_language_text_strings = {
	["LINE1"] = "This category contains articles with %s%s text. The primary purpose of these categories is to facilitate manual or automated checking of text in other languages.",
	["LINE2"] = "This category should only be added with the %s family of templates, never explicitly.",
	["LINE3"] = 'For example %s, which wraps the text with %s. Also available is %s which displays as %s.',
	["LINE3_SYNTAXHIGHLIGHT"] = "<span lang=\"%s\">",
	["IN_SCRIPT"] = " (in %s)",
	["EXAMPLE_DEFAULT_TEXT"] = "text in %s language here",
	["PARENT_CATEGORY"] = "[[Category:Articles containing non-English-language text]]",
	["TEMPLATE"] = "Lang",
	["TEMPLATE2"] = "Langx",
}

local function non_english_language_text_category(frame)
	local page = mw.title.getCurrentTitle()
	local args = require('Module:Arguments').getArgs(frame)
	-- args.test is used for /testcases
	if args.test then
		page = mw.title.new(args.test)
	end

	-- Naming style: Articles with text from the Berber languages collective
	local page_title_modified = page.text
	local split_title = "([^,]+)%%s([^,]*)"
	local part1 = ""
	local part2 = ""

	if page_title_modified:find('Articles with text in') then
		-- Naming style: Category:Articles with text from Afro-Asiatic languages (as currently implemented in Module:lang)
		part1, part2 = language_categories["LANGUAGES_COLLECTIVE_TEXT"]:match(split_title)
	elseif page_title_modified:find('explicitly cited') then
		part1, part2 = language_categories["ENGLISH"]:match(split_title)
	else
		-- Naming style: Category:Articles containing French-language text
		part1, part2 = language_categories["LANGUAGE_TEXT"]:match(split_title)
	end

	page_title_modified = page_title_modified:gsub(part1, "")
	page_title_modified = page_title_modified:gsub(part2, "")
	local language_name = page_title_modified

	local layout = {}
	table.insert(layout, get_hidden_category_template(frame))
	local parent_category = non_english_language_text_strings["PARENT_CATEGORY"]

	if language_name == page.text then
		-- Error: Category title format not supported.
		return make_error(string.format(error_messages["NOT_VALID_CATEGORY_FORMAT"], page.text), layout, parent_category, args.nocat)
	end

	local lang_module = require('Module:Lang')
	local language_code = lang_module._tag_from_name({language_name})	

	if language_code:find('[Ee]rror') then
		-- Error: Language code not found in database.
		return make_error(string.format(error_messages["NOT_VALID_LANGUAGE_CODE"], language_name), layout, parent_category, args.nocat)
	end

	local correct_language_category_title = lang_module._category_from_tag({language_code})
	if correct_language_category_title:find('[Ee]rror') then
		-- Error: No category title found for language code.
		return make_error(string.format(error_messages["NO_CATEGORY_TITLE_FOUND"], language_code), layout, parent_category, args.nocat)
	end

	local current_category_title = page.prefixedText
	if current_category_title ~= correct_language_category_title then
		-- Error: The current title used is not in the supported format. TODO: can this still be reached?
		return make_error(
			string.format(error_messages["INCORRECT_CATEGORY_TITLE"], current_category_title, non_english_language_text_strings["TEMPLATE"], correct_language_category_title),
			layout, parent_category, args.nocat)
	end

	table.insert(layout, get_top_section(frame))

	local script_text = ""
	if args.script then
		script_text = string.format(non_english_language_text_strings["IN_SCRIPT"], args.script)
	end

	local language_link = get_language_link(language_name, language_code)
	table.insert(layout, string.format(non_english_language_text_strings["LINE1"], language_link, script_text))

	local lang_template = frame:expandTemplate{title = 'Tl', args = {non_english_language_text_strings["TEMPLATE"]}}
	table.insert(layout, string.format(non_english_language_text_strings["LINE2"], lang_template))

	local language_code_link = lang_module._name_from_tag({language_code, link="yes", label=language_code})
	local example_default_text = string.format(non_english_language_text_strings["EXAMPLE_DEFAULT_TEXT"], language_name)
	local example_text = args.example or example_default_text
	local lang_template_example = frame:expandTemplate{title = "Tlx", args = {non_english_language_text_strings["TEMPLATE"], language_code_link, example_text}}
	local langx_args = {non_english_language_text_strings["TEMPLATE2"], language_code_link, example_text}
	local langx_template_example = frame:expandTemplate{title = "Tlx", args = {non_english_language_text_strings["TEMPLATE2"], language_code, example_text}}
	local langx_template_code = frame:expandTemplate{title = non_english_language_text_strings["TEMPLATE2"], args = {language_code, example_text}}

	-- Strip private use subtag from code tag because this is what [[Module:Lang]] does.
	local language_code_without_private_use = language_code:gsub("%-x%-.*", "")

	-- Wrap in syntaxhighlight.
	local syntaxhighlight = frame:extensionTag(
			"syntaxhighlight",
			string.format(non_english_language_text_strings["LINE3_SYNTAXHIGHLIGHT"], language_code_without_private_use),
			{lang = "html", inline = true}
		)

	table.insert(layout, string.format(non_english_language_text_strings["LINE3"], lang_template_example, syntaxhighlight, langx_template_example, langx_template_code))
	local see_also_section = get_see_also_section(page.text, language_name, language_code)

	local parent_language_code = get_primary_language_code(language_code)
	local parent_language_category
	if parent_language_code then
		parent_language_category = lang_module._category_from_tag({parent_language_code})
	end

	local bottom = get_bottom_section(frame, language_name, see_also_section, non_english_language_text_strings["PARENT_CATEGORY"], parent_language_category)
	return table.concat(layout, "\n\n") .. bottom
end


--[[ -------------------------- < N O N _ E N G L I S H _ L A N G U A G E _ S O U R C E S _ C A T E G O R Y > --------------------------

{{#invoke:Lang/documentor tool|non_english_language_sources_category}}

This function implements {{Non-English-language sources category}}.

]]

local non_english_language_sources_strings = {
	["LINE1"] = "This is a tracking category for articles that use %s to identify %s sources.",
	["PARENT_CATEGORY"] = "[[Category:Articles with non-English-language sources]]",
	["TEMPLATE"] = "In lang",
}

local function non_english_language_sources_category(frame)
	local page = mw.title.getCurrentTitle()
	local args = require('Module:Arguments').getArgs(frame)
	-- args.test is used for /testcases
	if args.test then
		page = mw.title.new(args.test)
	end

	local page_title = page.text
	local language_code = page_title:match('%(([%a%-]+)%)')
	local language_name = require('Module:Lang')._name_from_tag({language_code})

	local layout = {}
	table.insert(layout, get_hidden_category_template(frame))
	local parent_category = non_english_language_sources_strings["PARENT_CATEGORY"]
	
	local in_lang_module = require('Module:In lang')
	local correct_language_category_title = in_lang_module._in_lang({language_code, ["list-cats"]="yes"})
	if correct_language_category_title == "" then
		-- Error: No category title found for language code.
		return make_error(string.format(error_messages["NO_CATEGORY_TITLE_FOUND"], language_code), layout, parent_category, args.nocat)
	end

	local current_category_title = page.prefixedText
	if correct_language_category_title ~= current_category_title then
		-- Error: The current title used is not in the supported format.
		return make_error(
			string.format(error_messages["INCORRECT_CATEGORY_TITLE"], current_category_title, non_english_language_sources_strings["TEMPLATE"], correct_language_category_title),
			layout, parent_category, args.nocat)
	end

	local language_link = get_language_link(language_name, language_code)
	local text = string.format(non_english_language_sources_strings["LINE1"], frame:expandTemplate{title = 'Tlx', args = {non_english_language_sources_strings["TEMPLATE"], language_code}}, language_link)

	table.insert(layout, get_top_section(frame))	
	table.insert(layout, text)
	local see_also_section = get_see_also_section(page_title, language_name, language_code)

	local parent_language_code = get_primary_language_code(language_code)
	local parent_language_category
	if parent_language_code then
		parent_language_category = in_lang_module._in_lang({parent_language_code, ["list-cats"]="yes"})
	end

	local bottom = get_bottom_section(frame, language_name, see_also_section, parent_category, parent_language_category)
	return table.concat(layout, "\n\n") .. bottom
end


--[[ -------------------------- < N O N _ E N G L I S H _ L A N G U A G E _ C S 1 _ S O U R C E S _ C A T E G O R Y > --------------------------

{{#invoke:Lang/documentor tool|non_english_language_cs1_sources_category}}

This function implements {{Non-English-language CS1 sources category}}.

]]

local non_english_language_cs1_text_strings = {
	["LINE1"] = "This is a tracking category for [[WP:CS1|CS1 citations]] that use the parameter %s to identify a source in [[%s language|%s]]. Pages in this category should only be added by CS1 templates and [[Module:Citation/CS1]].",
	["PARENT_CATEGORY"] = "[[Category:CS1 foreign language sources]]", -- #TODO change to "Articles with non-english CS1 language sources" or "CS1 non-English language sources"
}

	--"This is a tracking category for [[WP:CS1|CS1 citations]] that use the parameter %s to hold a citation title that uses %s characters and contains the language prefix <code>%s:</code>. Pages in this category should only be added by CS1 templates and [[Module:Citation/CS1]].",
	--"[[Category:CS1 uses foreign language script]]",

	-- "This is a tracking category for [[WP:CS1|CS1 citations]] that use the parameter %s. Pages in this category should only be added by CS1 templates and [[Module:Citation/CS1]].",
	-- "to identify a source in [[%s language|%s]].",
	-- "to hold a citation title that uses %s characters and contains the language prefix <code>%s:</code>.",

local function non_english_language_cs1_sources_category(frame)
	local page_title_object = mw.title.getCurrentTitle()
	local page_title = page_title_object.text
	local language_code = page_title:match('%(([%a%-]+)%)')
	local language_name = require('Module:Lang')._name_from_tag({language_code})
	local layout = {}
	table.insert(layout, get_hidden_category_template(frame))
	local see_also_section = ""
	local parameter_doc = frame:expandTemplate{title = 'para', args = {"language", language_code}}
	table.insert(layout, get_top_section(frame))
	table.insert(layout, string.format(non_english_language_cs1_text_strings["LINE1"], parameter_doc, language_name, language_name))
	local see_also_section = get_see_also_section(page_title, language_name, language_code)
	local bottom = get_bottom_section(frame, language_name, see_also_section, non_english_language_cs1_text_strings["PARENT_CATEGORY"])
	return table.concat(layout, "\n\n") .. bottom
end


--[[ -------------------------- < T E S T _ C A S E S _ S H A R E D _ C O D E > -------------------------- 

]]

local function compare_by_keys2(a, b)											-- local function used by table.sort()
	return a[2] < b[2]															-- ascending sort by code
end


local function compare_by_keys(a, b)											-- local function used by table.sort()
	return a[1] < b[1]															-- ascending sort by code
end


-- Used by testcases_iso_code_to_name()
local function get_language_code_table_from_code(args)
	local entry = {}
	--if args.override_table[args.language_code] then
	--	table.insert(entry, args.override_table[args.language_code][1]) -- :gsub(' %b()$', '') fails here
	--else
		table.insert(entry, args.language_code)
--	end
	return entry
end


-- Used by testcases_name_from_tag()
local function get_language_code_and_name_table_from_code(args)
	local entry = {}
	if args.override_table and args.override_table[args.language_code] then
		table.insert(entry, args.language_code)
		local language_code, _ = args.override_table[args.language_code][1]:gsub(' %b()$', '')
		table.insert(entry, language_code)
	else
		table.insert(entry, args.language_code)
		table.insert(entry, args.language_table[args.language_code])
	end
	return entry
end


-- Used by testcases_category_from_tag()
local function get_language_code_and_category_table_from_code(args)
	local entry = {}
	table.insert(entry, args.language_code)
	table.insert(entry, args.test_function({args.language_code}))
	return entry
end


-- Used by testcases_iso_name_to_code() and testcases_tag_from_name()
local function get_language_name_and_code_table_from_code(args)
	local entry = {}
	if args.override_table[args.language_code] then
		table.insert(entry, args.override_table[args.language_code][1])			-- only the first name when there are multiples
		table.insert(entry, args.language_code)
	else
		table.insert(entry, args.language_names[1])								-- only the first name when there are multiples
		table.insert(entry, args.language_code)
	end
	return entry
end


local function get_table(table_function, language_table, length, range, iso_number, test_function)
	local table_of_language_name_and_code_tables = {}

	local override_table_name = "override"
	if iso_number then
		override_table_name = "override_" .. iso_number
	end
	local override_table = require("Module:ISO 639 name/ISO_639_override/sandbox")[override_table_name]

	-- For most ISO 639s.
	if range then
		for language_code, language_names in pairs(language_table) do
			if language_code:find(range) then
				table.insert(table_of_language_name_and_code_tables, table_function({
					override_table = override_table,
					language_code = language_code,
					language_names = language_names,
					test_function = test_function,
					language_table = language_table
				}))
			end
		end
	-- For ISO 639-1.
	elseif length then
		for language_code, language_names in pairs(language_table) do
			if language_code:len() == 2 then
				table.insert(table_of_language_name_and_code_tables, table_function({
					override_table = override_table,
					language_code = language_code,
					language_names = language_names,
					test_function = test_function,
					language_table = language_table
				}))
			end
		end
	-- For general /testcases.
	else
		for language_code, language_names in pairs(language_table) do
				table.insert(table_of_language_name_and_code_tables, table_function({
					override_table = override_table,
					language_code = language_code,
					language_names = language_names,
					test_function = test_function,
					language_table = language_table
				}))
		end
	end
	return table_of_language_name_and_code_tables
end


local function get_undabbed_table(language_list, length, range)
	local undabbed_language_table = {}											-- for this test, ISO 639-3 language name disambiguators must be removed; un-dabbed names go here
	for language_code, language_names in pairs(language_list) do
		-- For most ISO 639s.
		if range then
			if language_code:find(range) then
				undabbed_language_table[language_code] = language_names[1]:gsub(' %b()$', '')	-- undab and save only the first name; ignore all other names assigned to a code
			end
		-- For ISO 639-1.
		elseif length then
			if language_code:len() == 2 then
				undabbed_language_table[language_code] = language_names[1]:gsub(' %b()$', '')	-- undab and save only the first name; ignore all other names assigned to a code
			end
		-- For general /testcases.
		else
			undabbed_language_table[language_code] = language_names[1]:gsub(' %b()$', '')
		end
	end
	return undabbed_language_table
end


--[[ -------------------------- < T E S T C A S E S _ C A T E G O R Y _ F R O M _ T A G > --------------------------

Entry point for the various category_from_tag testcases.

Build a table of test patterns where each entry in the table is a table with two members:
	{"<language_code>", "<category name according to Module:Lang>"}

- "Expected" column value is the category name according to Module:Lang.
- "Actual" column value is the result of {{#invoke:Lang/sandbox|category_from_tag|<language_code>}}.

TODO: Currently not working.

]]

local function testcases_category_from_tag(self, args)
	local cat_from_tag_function = require('Module:Lang')._category_from_tag	
	local language_tables = get_table(get_language_code_and_category_table_from_code, args.language_list, args.length, args.range, args.iso_number, cat_from_tag_function)
	table.sort(language_tables, compare_by_keys)

	self:preprocess_equals_preprocess_many(
		'{{#invoke:Lang/sandbox|category_from_tag|', '}}', '', '',
		language_tables, 
		{nowiki=false}
	)
end


--[[ -------------------------- < T E S T C A S E S _ N A M E _ F R O M _ T A G > --------------------------

Entry point for the various name_from_tag testcases.

Build a table of test patterns where each entry in the table is a table with two members:
	{"<language_code>", "<language_name>"}

- "Expected" column value is the <language_name>.
- "Actual" column value is the result of sandbox version {{#invoke:Lang/sandbox|name_from_tag|<language_code>}}.

]]

local function testcases_name_from_tag(self, args)
	local undabbed_language_table = get_undabbed_table(args.language_list, args.length, args.range, nil)
	local language_tables = get_table(get_language_code_and_name_table_from_code, undabbed_language_table, args.length, args.range)
	table.sort(language_tables, compare_by_keys)

	self:preprocess_equals_preprocess_many(
		'{{#invoke:Lang/sandbox|name_from_tag|', '}}', '', '',
		language_tables, 
		{nowiki=false}
	)
end


--[[ -------------------------- < T E S T C A S E S _ T A G _ F R O M _ N A M E > --------------------------

Entry point for the various tag_from_name testcases.

Build a table of test patterns where each entry in the table is a table with two members:
	{"<language_name>", "<language_code>"}

- "Expected" column value is the <language_code>.
- "Actual" column value is the result of sandbox version {{#invoke:Lang/sandbox|tag_from_name|<language_name>}}.

TODO: Currently not working.

]]

local function testcases_tag_from_name(self, args)
	local language_tables = get_table(get_language_name_and_code_table_from_code, args.language_list, args.length, args.range, args.iso_number, nil)
	table.sort(language_tables, compare_by_keys2)

	local ordered_table = {}
	table.sort(unordered_table)
	for _, key in ipairs(unordered_table) do
		table.insert(ordered_table, {key, reverse_table[key]})
	end

	self:preprocess_equals_preprocess_many(
		'{{#invoke:Lang/sandbox|tag_from_name|', '}}', '', '',
		language_tables, 
		{nowiki=false}
	)
end


--[[ -------------------------- < T E S T C A S E S _ I S O _ C O D E _ T O _ N A M E > --------------------------

Entry point for the various iso_code_to_name testcases.

Build a table of test patterns where each entry in the table is a table with one member:
	{"<language_code>"}

- "Expected" column value is the result of the live version of {{#invoke:ISO 639 name|iso_639_name_to_code|<language_code>}}.
- "Actual" column value is the result of sandbox version {{#invoke:ISO 639 name/sandbox|iso_639_name_to_code|<language_code>}}.

]]

local function testcases_iso_code_to_name(self, args)
	local language_tables = get_table(get_language_code_table_from_code, args.language_list, args.length, args.range, args.iso_number, nil)
	table.sort(language_tables, compare_by_keys)

	self:preprocess_equals_preprocess_many(
		'{{#invoke:ISO 639 name/sandbox|iso_639_code_to_name|link=yes|', '}}', '{{#invoke:ISO 639 name|iso_639_code_to_name|link=yes|', '}}',
		language_tables, 
		{nowiki=false}
	)
end


--[[ -------------------------- < T E S T C A S E S _ I S O _ N A M E _ T O _ C O D E > --------------------------

Entry point for the various iso_name_to_code testcases.

Build a table of test patterns where each entry in the table is a table with two members:
	{"<language_name>", "<language_code>"}

- "Expected" column value is the <language_code>.
- "Actual" column is value the result of {{#invoke:ISO 639 name/sandbox|iso_639_name_to_code|<language_name>}}.

]]

local function testcases_iso_name_to_code(self, args)
	local language_tables = get_table(get_language_name_and_code_table_from_code, args.language_list, args.length, args.range, args.iso_number, nil)
	table.sort(language_tables, compare_by_keys2)
	self:preprocess_equals_preprocess_many(
		'{{#invoke:ISO 639 name/sandbox|iso_639_name_to_code|2=' .. args.iso_number .. "|", '}}', '', '',
		language_tables, 
		{nowiki=false}
	)
end


--[[--------------------------< S E E _ A L S O >--------------------------------------------------------------

adds items to the list of items in §See also section of Template:Lang-x/doc;  Evaluates single positional parameter
which is a comma-separated list of items including list markup.

	{{#invoke:Lang/documentor tool|see_also|*{{tl|Lang-tt-Cyrl}}, *{{tl|Lang-tt-Latn}}, *{{tl|Lang-tt-Arab}}}}

]]

local function see_also (frame)
	if nil == frame.args[1] or '' == frame.args[1] then							-- if empty, ...
		return																	-- ... return nothing
	end

	return frame:preprocess (frame.args[1]:gsub ('%s*,%s', '\n'))				-- preprocess so any templates are rendered before saving and done
end


--[[ -------------------------< E X P O R T E D _ F U N C T I O N S > -----------------------------------------

]]

return {
	lang_xx_settings = lang_xx_settings,
	uses_module = uses_module,
	see_also = see_also,
	non_english_language_text_category = non_english_language_text_category,
	non_english_language_sources_category = non_english_language_sources_category,
	non_english_language_cs1_sources_category = non_english_language_cs1_sources_category,
	private_tags = private_tags,

	-- Module:Lang testcases
	testcases_category_from_tag = testcases_category_from_tag,
	testcases_name_from_tag = testcases_name_from_tag,
	testcases_tag_from_name = testcases_tag_from_name,

	-- Module:ISO 639 name testcases
	testcases_iso_code_to_name = testcases_iso_code_to_name,
	testcases_iso_name_to_code = testcases_iso_name_to_code,
}
