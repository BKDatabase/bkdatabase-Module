local lang_data =  mw.loadData ('Module:Lang/data');							-- language name override and transliteration tool-tip tables
local lang_name_table = lang_data.lang_name_table;								-- language codes, names, regions, scripts, suppressed scripts

local lang_table = lang_name_table.lang;										-- language codes, names
local lang_dep_table = lang_name_table.lang_dep;								-- deprecated language codes, names
local override_table = lang_data.override;

local rev_lang_table = {};														-- same as lang_table reversed so language name is key and language tag is value
local rev_lang_dep_table = {};													-- same as lang_dep_table reversed so language name is key and language tag is value
local rev_override_table = {};													-- same as override_table except reversed
local dedabbed_names_list = {};													-- holds a list of dedabbed name and tags


--[[--------------------------< R E V _ L I S T _ A D D >------------------------------------------------------

local function to add <name> (key) and <tag> (value) pair to <rev_list>

<name>/<tag> pairs where <tag> is ISO 639-1, overwrite all other <name>/<tag> pairs.  When creating overrides,
take care that the <name> is properly disambiguated to avoid improper masking

]]

local function rev_list_add (rev_list, name, tag)
	if rev_list[name] then														-- if already in <rev_list>
		if 2 == tag:len() then													-- is this is a 2-characater code?
			rev_list[name] = tag;												-- yes, overwrite 3-characater language <name> and <tag> pair in <rev_list>
		end
	else																		-- here when not yet in <rev_list>
		rev_list[name] = tag;													-- add language <name> and <tag> (value) pair to <rev_list>
	end
end


--[[--------------------------< D E D A B B E D _ N A M E S _ L I S T _ A D D >--------------------------------

adds <name>/<tag> pairs to the dedabbed_names_list when <name> not already present.  When <name> is present in
the list, unsets the listed <tag> to empty string; cannot have different <name>/<tag> pairs where the table
key (<name>) is shared with another <name>/<tag> pair.

]]

local function dedabbed_names_list_add (dab, name, tag)
	if 0 ~= dab then															-- if dab was removed
		if dedabbed_names_list[name] then										-- if this dedabbed name is in the table then there are more than one name with different dabs
			dedabbed_names_list[name] = '';										-- unset but not too unset
		else
			dedabbed_names_list[name] = tag;									-- add name / tag pair in case this the only dedabbed name
		end
	end
end


--[[--------------------------< D E D A B B E D _ T O _ R E V _ L I S T _ A D D >------------------------------

adds <name>/<tag> pairs to specified <rev_list> when <tag> is not empty string

]]

local function dedabbed_to_rev_list_add (rev_list, name, tag)
	for name, tag in pairs (dedabbed_names_list) do								-- add dedabbed <name>/<tag> pairs to the reversed table
		if '' ~= tag then														-- when <name>/<tag> has not been unset because of multiple dabs
			rev_list_add (rev_list, name, tag);									-- add
		end
	end
end


--[[--------------------------< T A G - F R O M - N A M E   D A T A >------------------------------------------

Creates tag-from-name tables from the data in Module:Lang/data so that templates can get language tags from the
same names as the {{lang}} templates get from those tags.  The conversion prefers ISO 639-1 codes.

Data in these tables are used by tag_from_name() in Module:Lang

When <name> is disambiguated, will create an additional <name> entry without the dab as long as that action won't
conflict with actual undabbed names in the source.

<name> without dab is always added to the list; this rule arises because of the three Marwari language code/name pairs:
	mwr: Marwari																-– not dabbed
these will not have dedabbed entries because of mwr
	rwr: Marwari (India)
	mve: Marwari (Pakistan)

These all share the same base name so there will not not be an dedabbed entry:
	["yaka"] = "axk",															-- this would be wrong for two of these languages
	["yaka (central african republic)"] = "axk",
	["yaka (congo)"] = "iyx",
	["yaka (democratic republic of congo)"] = "yaf",

Say that we find "axk".  It has a dab so we add the dabbed form to rev_lang_table{}.  Then we look in
dedabbed_names_list{} to see if ["yaka"] is already there.  It's not, so we add this:
	["yaka"] = "axk",
Later we find "yaf".  It has a dab so we add the dabbed form to rev_lang_table{}.  Then we look in
dedabbed_names_list{} to see if ["yaka"] is already there.  It is, so that means that more than one language
code could create an dedabbed language name key; there can be only one.  Because ["yaka"] is already in the
dedabbed_names_list{} table we unset the ["yaka"] entry to empty string:
	["yaka"] = '',
later we find "iyx" and add it to rev_lang_table{}.  We look in dedabbed_names_list{} and find ["yaka"] has been
unset to empty string so do nothing.

When done adding names/codes to rev_lang_table{}, spin through dedabbed_names_list{} and add all non-empty-string
name/code pairs to rev_lang_table{}.

This does not catch things like overrides ["pa"] = "Punjabi" and ["pnb"] = "Punjabi".  "pa" and "pnb" are not
synonyms but because the names are the same, will be treated like synonyms ("pnb" promotes to "pa"). To avoid
this, disambiguate the override: ["pnb"] = {"Punjabi"} -> ["pnb"] = {"Punjabi (Western)"}

]]

for tag, name_table in pairs (lang_table) do
	if not override_table[tag] then												-- only add names/tags from name_table when tag not present in override table
		local name_raw = name_table:lower();
		local name, dab = name_raw:gsub ('%s+%b()', '');						-- remove parenthetical disambiguators or qualifiers from names that have them; <dab> non-zero when disambiguation removed
	
		rev_list_add (rev_lang_table, name_raw, tag);							-- add no-dab-names and names-with-dab here
		dedabbed_names_list_add (dab, name, tag);								-- add to dedabbed_names_list if dabbed
	end
end

dedabbed_to_rev_list_add (rev_lang_table, name, tag);							-- add dedabbed name/tag pairs to the reversed table

dedabbed_names_list = {};														-- reset list of dedabbed names

for tag, name_table in pairs (lang_dep_table) do
	if not override_table[tag] then												-- only add names/tags from name_table when tag not present in override table
		local name_raw = name_table:lower();
		local name, dab = name_raw:gsub ('%s+%b()', '');						-- remove parenthetical disambiguators or qualifiers from names that have them; <dab> non-zero when disambiguation removed
	
		rev_list_add (rev_lang_dep_table, name_raw, tag);						-- add no-dab-names and names-with-dab here
		dedabbed_names_list_add (dab, name, tag);								-- add to dedabbed_names_list if dabbed
	end
end

dedabbed_to_rev_list_add (rev_lang_dep_table, name, tag);						-- add dedabbed name/tag pairs to the reversed table

dedabbed_names_list = {};														-- reset list of dedabbed names

for tag, name_table in pairs (override_table) do
	local name_raw = name_table:lower();
	local name, dab = name_raw:gsub ('%s+%b()', '');							-- remove parenthetical disambiguators or qualifiers from names that have them

	rev_list_add (rev_override_table, name_raw, tag);
	dedabbed_names_list_add (dab, name, tag);									-- add to dedabbed_names_list if dabbed
end

dedabbed_to_rev_list_add (rev_override_table, name, tag);						-- add dedabbed name/tag pairs to the reversed table

dedabbed_names_list = {};														-- reset list


--[[--------------------------< E X P O R T E D   T A B L E S >------------------------------------------------
]]

return {
	rev_lang_table = rev_lang_table,
	rev_lang_dep_table = rev_lang_dep_table,
	rev_override_table = rev_override_table,
	}
