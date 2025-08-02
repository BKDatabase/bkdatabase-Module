local lang_obj = mw.language.getContentLanguage();
local this_wiki_lang_tag = lang_obj.code;										-- get this wiki's language tag


--[[--------------------------< L A N G _ N A M E _ T A B L E >------------------------------------------------

primary table of tables that decode:
	lang -> language tags and names
	script -> ISO 15924 script tags
	region -> ISO 3166 region tags
	variant -> iana registered variant tags
	suppressed -> map of scripts tags and their associated language tags
	
all of these data come from separate modules that are derived from the IANA language-subtag-registry file

key_to_lower() avoids the metatable trap and sets all keys in the subtables to lowercase. Many language codes
have multiple associated names; Module:lang is only concerned with the first name so key_to_lower() only fetches
the first name.

]]

local function key_to_lower (module, src_type)
	local out = {};
	local source_t = (('var_sup' == src_type) and require (module)) or mw.loadData (module);		-- fetch data from this module; require() avoids metatable trap for variant data

	if 'var_sup' == src_type then
		for k, v in pairs (source_t) do
			out[k:lower()] = v;													-- for variant and suppressed everything is needed
		end

	elseif 'lang' == src_type and source_t.active then							-- for ~/iana_languages (active)
		for k, v in pairs (source_t.active) do
			out[k:lower()] = v[1];												-- ignore multiple names; take first name only
		end

	elseif 'lang_dep' == src_type and source_t.deprecated then					-- for ~/iana_languages (deprecated)
		for k, v in pairs (source_t.deprecated) do
			out[k:lower()] = v[1];												-- ignore multiple names; take first name only
		end

	else																		-- here for all other sources
		for k, v in pairs (source_t) do
			out[k:lower()] = v[1];												-- ignore multiple names; take first name only
		end
	end
	return out;
end

local lang_name_table_t = {
	lang = key_to_lower ('Module:Lang/data/iana languages', 'lang'),
	lang_dep = key_to_lower ('Module:Lang/data/iana languages', 'lang_dep'),
	script = key_to_lower ('Module:Lang/data/iana scripts'),					-- script keys are capitalized; set to lower
	region = key_to_lower ('Module:Lang/data/iana regions'),					-- region keys are uppercase; set to lower
	variant = key_to_lower ('Module:Lang/data/iana variants', 'var_sup'),
	suppressed = key_to_lower ('Module:Lang/data/iana suppressed scripts', 'var_sup'),	-- script keys are capitalized; set to lower
	}


--[[--------------------------< I 1 8 N   M E D I A W I K I   O V E R R I D E >--------------------------------

For internationalization; not used at en.wiki

The language names taken from the IANA language-subtag-registry file are given in English. That may not be ideal.
Translating ~8,000 language names is also not ideal.  MediaWiki maintains (much) shorter lists of language names
in most languages for which there is a Wikipedia edition.  When desired, Module:Lang can use the MediaWiki 
language list for the local language.

Caveat lector: the list of MediaWiki language names for your language may not be complete or may not exist at all.
When incomplete, MediaWiki's list will 'fall back' to another language (typically English).  When that happens
add an appropriate entry to the override table below.

Caveat lector: the list of MediaWiki language names for your language may not be correct.  At en.wiki, the
MediaWiki language names do not agree with the IANA language names for these ISO 639-1 tags.  Often it is simply
spelling differences:
	bh: IANA: Bihari languages MW: Bhojpuri – the ISO 639-3 tag for Bhojpuri is bho
	bn: IANA: Bengali MW: Bangla – Bengali is the exonym, Bangla is the endonym
	dv: IANA: Dhivehi MW: Divehi
	el: IANA: Modern Greek MW: Greek
	ht: IANA: Haitian MW: Haitian Creole
	ky: IANA: Kirghiz MW: Kyrgyz
	li: IANA: Limburgan MW: Limburgish
	or: IANA: Oriya MW: Odia
	os: IANA: Ossetian MW: Ossetic
	"pa: IANA: Panjabi MW: Punjabi
	"ps: IANA: Pushto MW: Pashto
	"to: IANA: Tonga MW: Tongan
	"ug: IANA: Uighur MW: Uyghur
use the override table to override language names that are incorrect for your project

To see the list of names that MediaWiki has for your language, enter this in the Debug colsole:
	=mw.dumpObject (mw.language.fetchLanguageNames ('<tag>', 'all'))
(replacing <tag> with the language tag for your language)

Use of the MediaWiki language names lists is enabled when media_wiki_override_enable is set to boolean true.
	
]]

local media_wiki_override_enable = false;										-- set to true to override IANA names with MediaWiki names; always false at en.wiki
																				-- caveat lector: the list of MediaWiki language names for your language may not be complete or may not exist at all
	if true == media_wiki_override_enable then
		local mw_languages_by_tag_t = mw.language.fetchLanguageNames (this_wiki_lang_tag, 'all');	-- get a table of language tag/name pairs known to MediaWiki
		for tag, name in pairs (mw_languages_by_tag_t) do						-- loop through each tag/name pair in the MediaWiki list
			if lang_name_table_t.lang[tag] then									-- if the tag is in the main list
				lang_name_table_t.lang[tag] = name;								-- overwrite exisiting name with the name from MediaWiki
			end
		end
	end


--[[--------------------------< O V E R R I D E >--------------------------------------------------------------

Language codes and names in this table override the BCP47 names in lang_name_table.

indexes in this table shall always be lower case

]]

local override = {
------------------------------< I S O _ 6 3 9 - 1 >------------------------------------------------------------

	["ab"] = "Abkhaz",                                                          -- to match en.wiki article name
	["ca-valencia"] = "Valencia",
	["cu"] = "Slav Giáo hội",													-- 2nd IANA name;
	["de-at"] = "Đức Áo",														-- these code-region and code-variant to match en.wiki article names
	["de-ch"] = "Đức chuẩn Thụy Sĩ",
	["en-au"] = "Anh Úc",
	["en-ca"] = "Anh Canada",
	["en-emodeng"] = "Anh cận đại",
	["en-gb"] = "Anh Anh",
	["en-ie"] = "Anh Ireland",
	["en-in"] = "Anh Ấn Độ",
	["en-nz"] = "Anh New Zealand",
	["en-us"] = "Anh Mỹ",
	["en-za"] = "Anh Nam Phi",
	["fr-ca"] = "Pháp Québec",
	["fr-gallo"] = "Gallo",
	["fy"] = "Tây Frisia",														-- IANA name is Western Frisian
	["mo"] = "Moldova",															-- Moldavian (deprecated code); to match en.wiki article title
	["nl-be"] = "phương ngữ Vlaanderen",										-- match MediaWiki
	["oc-gascon"] = "Gascon",
	["oc-provenc"] = "Provençal",
	["ps"] = "Pashtun",															-- IANA name is Pushto
	["pt-br"] = "Bồ Đào Nha Brasil",											-- match MediaWiki
	["ro-md"] = "Moldova",														-- 'not deprecated' form
	["ro-cyrl-md"] = "Moldova",													-- 'not deprecated' form
	["tw-asante"] = "Asante Twi",

-- these ISO 639-1 language-name overrides imported from Module:Language/data/wp_languages (since deleted)
--<begin do-not-edit except to comment out>--
		["av"] = "Avar",														-- Avaric
		["bo"] = "Tạng tiêu chuẩn",												-- Tibetan
		["el"] = "Hy Lạp",														-- Modern Greek
--		["en-SA"] = "Anh Nam Phi",												-- English; no; SA is not South Africa it Saudi Arabia; ZA is South Africa
		["ff"] = "Fula",														-- Fulah
		["ht"] = "Haitian Creole",												-- Haitian
		["hz"] = "Otjiherero",													-- Herero
		["ii"] = "Yi",															-- Sichuan Yi
		["ki"] = "Gikuyu",														-- Kikuyu
		["kl"] = "Greenland",													-- Kalaallisut
		["ky"] = "Kyrgyz",														-- Kirghiz
		["lg"] = "Luganda",														-- Ganda
		["li"] = "Limburg",														-- Limburgan
		["mi"] = "Māori",														-- Maori
		["na"] = "Nauruan",														-- Nauru
		["nb"] = "Bokmål",														-- Norwegian Bokmål
		["nd"] = "Bắc Ndebele",													-- North Ndebele
		["nn"] = "Nynorsk",														-- Norwegian Nynorsk
		["nr"] = "Nam Ndebele",													-- South Ndebele
		["ny"] = "Chichewa",													-- Nyanja
		["oj"] = "Ojibwe",														-- Ojibwa
		["or"] = "Odia",														-- Oriya
		["pa"] = "Punjabi",														-- Panjabi
		["rn"] = "Kirundi",														-- Rundi
		["sl"] = "Slovene",														-- Slovenian
		["ss"] = "Swazi",														-- Swati
		["st"] = "Sotho",														-- Southern Sotho
		["to"] = "Tongan",														-- Tonga
--<end do-not-edit except to comment out>--


------------------------------< I S O _ 6 3 9 - 2,   - 3,   - 5 >----------------------------------------------

	["alv"] = "nhóm ngôn ngữ Đại Tây Dương-Congo",								-- to match en.wiki article title (endash)
	["arc"] = "Aram Đế quốc (700-300 TCN)",										-- Official Aramaic (700-300 BCE), Imperial Aramaic (700-300 BCE); to match en.wiki article title uses ISO639-2 'preferred' name
	["art"] = "được xây dựng",													-- to match en.wiki article; lowercase for category name
	["ast-es"] = "León",														-- ast in IANA is Asturian; Leonese is a dialect
	["bea"] = "Dane-zaa",														-- Beaver; to match en.wiki article title
	["bha"] = "Bhariati",														-- Bharia; to match en.wiki article title
	["bha"] = "Bhariati",														-- Bharia; to match en.wiki article title
	["bhd"] = "Bhadarwahi",														-- Bhadrawahi; to match en.wiki article title
	["bla"] = "Blackfoot",														-- Siksika; to match en.wiki article title
	["blc"] = "Nuxalk",															-- Bella Coola; to match en.wiki article title
	["bua"] = "Buryat",															-- Buriat; this is a macro language; these four use wp preferred transliteration;
	["bxm"] = "Buryat Mông Cổ",													-- Mongolia Buriat; these three all redirect to Buryat
	["bxr"] = "Buryat Nga",														-- Russia Buriat;
	["bxu"] = "Buryat Trung Quốc",												-- China Buriat;
	["byr"] = "Yipma",															-- Baruya, Yipma
	["clm"] = "Klallam",														-- Clallam; to match en.wiki article title
	["egy"] = "Ai Cập cổ đại",													-- Egyptian (Ancient); distinguish from contemporary arz: Egyptian Arabic 
	["ems"] = "Alutiiq",														-- Pacific Gulf Yupik; to match en.wiki article title
	["esx"] = "ngữ hệ Eskimo-Aleut",											-- to match en.wiki article title (endash)
	["frr"] = "Bắc Frisia",														-- Northern Frisian
	["frs"] = "Hạ Sachsen Đông Frisia",											-- Eastern Frisian
	["gsw-fr"] = "Alsace",														-- match MediaWiki
	["haa"] = "Hän",															-- Han; to match en.wiki article title
	["hei"] = "Heiltsuk–Oowekyala",												-- Heiltsuk; to match en.wiki article title
	["hmx"] = "ngữ hệ Hmông-Miền",												-- to match en.wiki article title (endash)
	["ilo"] = "Ilocano",														-- Iloko; to match en.wiki article title
	["jam"] = "Patwa Jamaica",													-- Jamaican Creole English
	["lij-mc"] = "Munegascu",													-- Ligurian as spoken in Monaco; this one for proper tool tip; also in <article_name> table
	["luo"] = "Dholuo",															-- IANA (primary) /ISO 639-3: Luo (Kenya and Tanzania); IANA (secondary): Dholuo
	["mhr"] = "Mari Thảo điền",													-- Eastern Mari
	["mid"] = "Mandaean hiện đại",												-- Mandaic
	['mis'] = "chưa mã hoá",													-- Uncoded languages; capitalization; special scope, not collective scope;
	["mkh"] = "ngữ hệ Môn-Khmer",												-- to match en.wiki article title (endash)
	["mla"] = "Tamambo",														-- Malo
	['mte'] = "Mono-Alu",														-- Mono (Solomon Islands)
	['mul'] = "đa ngôn ngữ",													-- Multiple languages; capitalization; special scope, not collective scope;
	["nan-tw"] = "Phúc Kiến Đài Loan",											-- make room for IANA / 639-3 nan Min Nan Chinese; match en.wiki article title
	["new"] = "Newar",															-- Newari, Nepal Bhasa; to match en,wiki article title
	["ngf"] = "ngữ hệ Liên New Guinea",											-- to match en.wiki article title (endash)
	["nic"] = "ngữ hệ Niger-Congo",												-- Niger-Kordofanian languages; to match en,wiki article title
	["nrf"] = "Norman",															-- not quite a collective - IANA name: Jèrriais + Guernésiais; categorizes to Norman-language text
	["nrf-gg"] = "Guernésiais",													-- match MediaWiki
	["nrf-je"] = "Jèrriais",													-- match MediaWiki
	["nzi"] = "Nzema",															-- Nzima; to match en.wiki article title
	["oma"] = "Omaha–Ponca",													-- to match en.wiki article title (endash)
	["orv"] = "Slav Đông cổ",													-- Old Russian
	["pfl"] = "Đức Pfalz",														-- Pfaelzisch; to match en.wiki article
	["pie"] = "Piro Pueblo",													-- Piro; to match en.wiki article
	["pms"] = "Piemonte",														-- Piemontese; to match en.wiki article title
	["pnb"] = "Punjabi (phương Tây)",											-- Western Panjabi; dab added to override import from ~/wp languages and distinguish pnb from pa in reverse look up tag_from_name()
	['qwm'] = "Cuman",															-- Kuman (Russia); to match en.wiki article name
	["rop"] = "Kriol Úc",														-- Kriol; en.wiki article is a dab; point to correct en.wiki article
	["sco-ulster"] = "Ulster Scots",
	["sdo"] = "Bukar–Sadong",													-- Bukar-Sadung Bidayuh; to match en.wiki article title
	["smp"] = "Hebrew Samari",													-- to match en.wiki article title
	["stq"] = "Frisia Saterland",												-- IANA name is Saterfriesisch
	["und"] = "không rõ",														-- capitalization to match existing category
	["wrg"] = "Warrongo",														-- Warungu
	["xal-ru"] = "Kalmyk",														-- to match en.wiki article title
	["xgf"] = "Tongva",															-- ISO 639-3 is Gabrielino-Fernandeño
	["yuf"] = "Havasupai–Hualapai",												-- Havasupai-Walapai-Yavapai; to match en.wiki article title
	["zkt"] = "Khitan",															-- Kitan; to match en.wiki article title
	["zxx"] = "không có nội dung ngôn ngữ",									-- capitalization

-- these ISO 639-2, -3 language-name overrides imported from Module:Language/data/wp_languages (since deleted)
--<begin do-not-edit except to comment out>--
		["ace"] = "Aceh",														-- Achinese
		["aec"] = "Ả Rập Sa'idi",												-- Saidi Arabic
		["akl"] = "Aklan",														-- Aklanon
		["alt"] = "Altay",														-- Southern Altai
		["apm"] = "Mescalero-Chiricahua",										-- Mescalero-Chiricahua Apache
		["bal"] = "Balochi",													-- Baluchi
--		["bcl"] = "Trung Bicolano",												-- Central Bikol
		["bin"] = "Edo",														-- Bini
		["bpy"] = "Manipur Bishnupriya",										-- Bishnupriya
		["chg"] = "Chagatay",													-- Chagatai
		["ckb"] = "Kurd Soran",													-- Central Kurdish
		["cnu"] = "Shenwa",														-- Chenoua
		["coc"] = "Cocopah",													-- Cocopa
		["diq"] = "Zazaki",														-- Dimli
		["fit"] = "Meänkieli",													-- Tornedalen Finnish
		["fkv"] = "Kven",														-- Kven Finnish
		["frk"] = "Frăng cổ",													-- Frankish
		["gez"] = "Ge'ez",														-- Geez
		["gju"] = "Gujari",														-- Gujari
		["gsw"] = "Đức Alemanni",												-- Swiss German
		["gul"] = "Gullah",														-- Sea Island Creole English
		["hak"] = "Hakka",														-- Hakka Chinese
		["hbo"] = "Hebrew Kinh Thánh",											-- Ancient Hebrew
		["hnd"] = "Hindko",														-- Southern Hindko
--		["ikt"] = "Inuvialuk",													-- Inuinnaqtun
		["kaa"] = "Karakalpak",													-- Kara-Kalpak
		["khb"] = "Tai Lü",														-- Lü
		["kmr"] = "Kurd Kurmanji",												-- Northern Kurdish
		["kpo"] = "Kposo",														-- Ikposo
		["krj"] = "Kinaray-a",													-- Kinaray-A
--		["ktz"] = "Juǀ'hoan",													-- Juǀʼhoan
		["lez"] = "Lezgi",														-- Lezghian
		["liv"] = "Livonia",													-- Liv
		["lng"] = "Lombard",													-- Langobardic
		["mia"] = "Miami-Illinois",												-- Miami
		["miq"] = "Miskito",													-- Mískito
		["mix"] = "Mixtec",														-- Mixtepec Mixtec
		["mni"] = "Meitei",														-- Manipuri
		["mrj"] = "Đồi Mari",													-- Western Mari
		["mww"] = "Hmông Trắng",												-- Hmong Daw
		["nds-nl"] = "Hạ Saxon Hà Lan",											-- Low German
--		["new"] = "Nepal Bhasa",												-- Newari
		["nso"] = "Bắc Sotho",													-- Pedi
--		["nwc"] = "Nepal Bhasa cổ điển",										-- Classical Newari, Classical Nepal Bhasa, Old Newari
		["ood"] = "O'odham",													-- Tohono O'odham
		["otk"] = "Turk cổ",													-- Old Turkish
		["pal"] = "Ba Tư trung đại",												-- Pahlavi
		["pam"] = "Kapampangan",												-- Pampanga
		["phr"] = "Potwari",													-- Pahari-Potwari
		["pka"] = "Jain Prakrit",												-- Ardhamāgadhī Prākrit
--		["pnb"] = "Punjabi",													-- Western Panjabi
		["psu"] = "Shauraseni",													-- Sauraseni Prākrit
		["rap"] = "Rapa Nui",													-- Rapanui
		["rar"] = "Māori quần đảo Cook",										-- Rarotongan
		["rmu"] = "Scandoromani",												-- Tavringer Romani
		["rom"] = "Digan",														-- Romany
		["rup"] = "Aromani",													-- Macedo-Romanian
		["ryu"] = "Okinaw",														-- Central Okinawan
		["sdc"] = "Sassar",														-- Sassarese Sardinian
		["sdn"] = "Gallur",														-- Gallurese Sardinian
		["shp"] = "Shipibo",													-- Shipibo-Conibo
		["src"] = "Logudor",													-- Logudorese Sardinian
		["sro"] = "Campidan",													-- Campidanese Sardinian
		["tkl"] = "Tokelau",													-- Tokelau
		["tvl"] = "Tuvalu",														-- Tuvalu
		["tyv"] = "Tuva",														-- Tuvinian
		["vls"] = "Tây Vlaanderen",												-- Vlaams
		["wep"] = "Westphali",													-- Westphalien
		["xal"] = "Oirat",														-- Kalmyk
		["xcl"] = "Armenian cổ",												-- Classical Armenian
		["yua"] = "Maya Yucatán",												-- Yucateco
--<end do-not-edit except to comment out>--


------------------------------< P R I V A T E _ U S E _ T A G S >----------------------------------------------

	["akk-x-latbabyl"] = "Akkad Babylon muộn",
	["akk-x-midassyr"] = "Akkad Assyria trung đại",
	["akk-x-midbabyl"] = "Akkad Babylon trung đại",
	["akk-x-neoassyr"] = "Tân Akkad Assyria",
	["akk-x-neobabyl"] = "Tân Akkad Babylon",
	["akk-x-old"] = "Akkad cổ",
	["akk-x-oldassyr"] = "Akkad Assyria cổ",
	["akk-x-oldbabyl"] = "Akkad Babylon cổ",
	["alg-x-proto"] = "Algonquian nguyên thủy",									-- alg in IANA is Algonquian languages
	["ca-x-old"] = "Catalunya cổ",
	["cel-x-combrit"] = "Britton phổ thông",									-- cel in IANA is Celtic languages
	["cel-x-proto"] = "Celt nguyên thủy",
	["egy-x-demotic"] = "Ai Cập thông dụng",
	["egy-x-late"] = "Ai Cập muộn",
	["egy-x-middle"] = "Ai Cập trung đại",
	["egy-x-old"] = "Ai Cập cổ",
	["gem-x-proto"] = "German nguyên thủy",										-- gem in IANA is Germanic languages
	["gmw-x-ecg"] = "Đông Trung Đức",
	["grc-x-aeolic"] = "Hy Lạp Aeolic",											-- these grc-x-... codes are preferred alternates to the non-standard catchall code grc-gre
	["grc-x-arcadcyp"] = "Hy Lạp Arcadocypriot",
	["grc-x-attic"] = "Hy Lạp Attic",
	["grc-x-biblical"] = "Hy Lạp Koine",
	["grc-x-byzant"] = "Hy Lạp Byzantine",
	["grc-x-classic"] = "Hy Lạp cổ điển",
	["grc-x-doric"] = "Hy Lạp Doric",
	["grc-x-hellen"] = "Hellenistic Greek",
	["grc-x-ionic"] = "Hy Lạp Ionic",
	["grc-x-koine"] = "Hy Lạp Koine",
	["grc-x-medieval"] = "Hy Lạp trung đại",
	["grc-x-patris"] = "Patristic Greek",
	["grk-x-proto"] = "Hy Lạp nguyên thủy",										-- grk in IANA is Greek languages
	["iir-x-proto"] = "Ấn-Iran nguyên thủy",									-- iir in IANA is Indo-Iranian Languages
	["inc-x-mitanni"] = "Mitanni-Arya",											-- inc in IANA is Indic languages
	["inc-x-proto"] = "Ấn-Arya nguyên thủy",
	["ine-x-anatolia"] = "ngữ tộc Tiểu Á",
	["ine-x-proto"] = "Ấn-Âu nguyên thủy",
	["ira-x-proto"] = "Iran nguyên thủy",										-- ira in IANA is Iranian languages
	["itc-x-proto"] = "Ý nguyên thủy",											-- itc in IANA is Italic languages
	["ksh-x-colog"] = "Cologne",												-- en.wiki article is Colognian; ksh (Kölsch) redirects there
	["la-x-medieval"] = "Latinh trung đại",
	["la-x-new"] = "Tân Latinh",
	["lmo-x-berg"] = "Bergamàsch",												-- lmo in IANA is Lombard; Bergamasque is a dialect
	["lmo-x-cremish"] = "Cremàsch",												-- lmo in IANA is Lombard; Cremish is a dialect
	["lmo-x-milanese"] = "Milanes",												-- lmo in IANA is Lombard; Milanese is a dialect
	["mis-x-ripuar"] = "Ripuari",												-- replaces improper use of ksh in wp_languages
	["prg-x-old"] = "Phổ cổ",
	["sem-x-ammonite"] = "Ammonite",
	["sem-x-aramaic"] = "Aramaic",
	["sem-x-canaan"] = "nhóm ngôn ngữ Canaan",
	["sem-x-dumaitic"] = "Dumaitic",
	["sem-x-egurage"] = "Gurage Đông",
	["sem-x-hatran"] = "Aramaic Hatran",
	["sem-x-oldsoara"] = "Nam Ả Rập cổ",
	["sem-x-palmyren"] = "Aramaic Palmyrene",
	["sem-x-proto"] = "Semit nguyên thủy",
	["sem-x-taymanit"] = "Taymanitic",
	["sla-x-proto"] = "Slav nguyên thủy",										-- sla in IANA is Slavic languages
	["yuf-x-hav"] = "Havasupai",												-- IANA name for these three is Havasupai-Walapai-Yavapai
	["yuf-x-wal"] = "Walapai",
	["yuf-x-yav"] = "Yavapai",
	["xsc-x-pontic"] = "Scythia Pontic",										-- xsc in IANA is Scythian
	["xsc-x-saka"] = "Saka",
	["xsc-x-sarmat"] = "Sarmatia",
	}


--[[--------------------------< A R T I C L E _ L I N K >------------------------------------------------------

for those rare occasions when article titles don't fit with the normal '<language name> language', this table
maps language code to article title. Use of this table should be avoided and the use of redirects preferred as
that is the long-standing method of handling article names that don't fit with the normal pattern

]]

local article_name = {
	['kue'] = "Tiếng Kuman (New Guinea)",										-- Kuman (Papua New Guinea); to avoid Kuman dab page
	["lij-mc"] = "Phương ngữ Monégasque",										-- Ligurian as spoken in Monaco
	['mbo'] = "Tiếng Mbo (Cameroon)",											-- Mbo (Cameroon)
	['mnh'] = "Tiếng Mono (Congo)",												-- Mono (Democratic Republic of Congo); see Template_talk:Lang#Mono_languages
	['mnr'] = "Tiếng Mono (California)",										-- Mono (USA)
	['mru'] = "Tiếng Mono (Cameroon)",											-- Mono (Cameroon)
	["snq"] = "Tiếng Sangu (Gabon)",											-- Sangu (Gabon)
	["toi"] = "Tiếng Tonga (Zambia và Zimbabwe)",								-- Tonga (Zambia and Zimbabwe); to avoid Tonga language dab page
	["vwa"] = "Tiếng Awa (Trung Quốc)",											-- Awa (China); to avoid Awa dab page
	["xlg"] = "Tiếng Liguria (cổ đại)",											-- see Template_talk:Lang#Ligurian_dab
	["zmw"] = "Tiếng Mbo (Congo)",												-- Mbo (Democratic Republic of Congo)
	}


--[=[-------------------------< R T L _ S C R I P T S >--------------------------------------------------------

ISO 15924 scripts that are written right-to-left. Data in this table taken from [[ISO 15924#List of codes]]

last update to this list: 2017-12-24

]=]

local rtl_scripts = {
	'adlm', 'arab', 'aran', 'armi', 'avst', 'cprt', 'egyd', 'egyh', 'hatr', 'hebr',
	'hung', 'inds', 'khar', 'lydi', 'mand', 'mani', 'mend', 'merc', 'mero', 'narb',
	'nbat', 'nkoo', 'orkh', 'palm', 'phli', 'phlp', 'phlv', 'phnx', 'prti', 'rohg',
	'samr', 'sarb', 'sogd', 'sogo', 'syrc', 'syre', 'syrj', 'syrn', 'thaa', 'wole',
	};


--[[--------------------------< T R A N S L I T _ T I T L E S >------------------------------------------------

This is a table of tables of transliteration standards and the language codes or language scripts that apply to
those standards. This table is used to create the tool-tip text associated with the transliterated text displayed
by some of the {{lang-??}} templates.

These tables are more-or-less copied directly from {{transl}}. The standard 'NO_STD' is a construct to allow for
the cases when no |std= parameter value is provided.

]]

local translit_title_table = {
	['ahl'] = {
		['default'] = 'Chuyển tự bởi Viện hàn lâm Ngôn ngữ Hebrew',
		},

	['ala'] = {
		['default'] = 'Chuyển tự bởi Hiệp hội Thư viện Hoa Kỳ – Thư viện Quốc hội',
		},

	['ala-lc'] = {
		['default'] = 'Chuyển tự bởi Hiệp hội Thư viện Hoa Kỳ – Thư viện Quốc hội',
		},

	['batr'] = {
		['default'] = 'Quy tắc chuyển tự tiếng Ả Rập Bikdash',
		},

	['bgn/pcgn'] = {
		['default'] = 'Board on Geographic Names / Permanent Committee on Geographical Names transliteration',
		},

	['din'] = {
		['ar'] = 'DIN 31635 Ả Rập',
		['fa'] = 'DIN 31635 Ả Rập',
		['ku'] = 'DIN 31635 Ả Rập',
		['ps'] = 'DIN 31635 Ả Rập',
		['tg'] = 'DIN 31635 Ả Rập',
		['ug'] = 'DIN 31635 Ả Rập',
		['ur'] = 'DIN 31635 Ả Rập',
		['arab'] = 'DIN 31635 Ả Rập',

		['default'] = 'Chuyển tự theo tiêu chuẩn DIN',
		},

	['eae'] = {
		['default'] = 'Chuyển tự Encyclopaedia Aethiopica',
		},

	['hepburn'] = {
		['default'] = 'Chuyển tự Hepburn',
		},

	['hunterian'] = {
		['default'] = 'Chuyển tự Hunteria',
		},

	['iast'] = {
		['default'] = 'Chuyển tự IAST',
		},

	['iso'] = {																	-- when a transliteration standard is supplied
		['ab'] = 'ISO 9 Kirin',
		['ba'] = 'ISO 9 Kirin',
		['be'] = 'ISO 9 Kirin',
		['bg'] = 'ISO 9 Kirin',
		['kk'] = 'ISO 9 Kirin',
		['ky'] = 'ISO 9 Kirin',
		['mn'] = 'ISO 9 Kirin',
		['ru'] = 'ISO 9 Kirin',
		['tg'] = 'ISO 9 Kirin',
		['uk'] = 'ISO 9 Kirin',
		['bua'] = 'ISO 9 Kirin',
		['sah'] = 'ISO 9 Kirin',
		['tut'] = 'ISO 9 Kirin',
		['xal'] = 'ISO 9 Kirin',
		['cyrl'] = 'ISO 9 Kirin',
		['cyrs'] = 'ISO 9 Kirin',

		['ar'] = 'ISO 233 Ả Rập',
		['ku'] = 'ISO 233 Ả Rập',
		['ps'] = 'ISO 233 Ả Rập',
		['ug'] = 'ISO 233 Ả Rập',
		['ur'] = 'ISO 233 Ả Rập',
		['arab'] = 'ISO 233 Ả Rập',

		['he'] = 'ISO 259 Hebrew',
		['yi'] = 'ISO 259 Hebrew',
		['hebr'] = 'ISO 259 Hebrew',

		['el'] = 'ISO 843 Hy Lạp',
		['grc'] = 'ISO 843 Hy Lạp',

		['ja'] = 'ISO 3602 Nhật',
		['hira'] = 'ISO 3602 Nhật',
		['hrkt'] = 'ISO 3602 Nhật',
		['jpan'] = 'ISO 3602 Nhật',
		['kana'] = 'ISO 3602 Nhật',

		['zh'] = 'ISO 7098 Trung Quốc',
		['chi'] = 'ISO 7098 Trung Quốc',
		['cmn'] = 'ISO 7098 Trung Quốc',
		['zho'] = 'ISO 7098 Trung Quốc',
--		['han'] = 'ISO 7098 Trung Quốc',										-- unicode alias of Hani? doesn't belong here? should be Hani?
		['hans'] = 'ISO 7098 Trung Quốc',
		['hant'] = 'ISO 7098 Trung Quốc',

		['ka'] = 'ISO 9984 Gruzia',
		['kat'] = 'ISO 9984 Gruzia',

		['arm'] = 'ISO 9985 Armenia',
		['hy'] = 'ISO 9985 Armenia',

		['th'] = 'ISO 11940 Thái',
		['tha'] = 'ISO 11940 Thái',

		['ko'] = 'ISO 11941 Hàn Quốc',
		['kor'] = 'ISO 11941 Hàn Quốc',

		['awa'] = 'ISO 15919 Ấn-Arya',
		['bho'] = 'ISO 15919 Ấn-Arya',
		['bn'] = 'ISO 15919 Ấn-Arya',
		['bra'] = 'ISO 15919 Ấn-Arya',
		['doi'] = 'ISO 15919 Ấn-Arya',
		['dra'] = 'ISO 15919 Ấn-Arya',
		['gon'] = 'ISO 15919 Ấn-Arya',
		['gu'] = 'ISO 15919 Ấn-Arya',
		['hi'] = 'ISO 15919 Ấn-Arya',
		['hno'] = 'ISO 15919 Ấn-Arya',
		['inc'] = 'ISO 15919 Ấn-Arya',
		['kn'] = 'ISO 15919 Ấn-Arya',
		['kok'] = 'ISO 15919 Ấn-Arya',
		['ks'] = 'ISO 15919 Ấn-Arya',
		['mag'] = 'ISO 15919 Ấn-Arya',
		['mai'] = 'ISO 15919 Ấn-Arya',
		['ml'] = 'ISO 15919 Ấn-Arya',
		['mr'] = 'ISO 15919 Ấn-Arya',
		['ne'] = 'ISO 15919 Ấn-Arya',
		['new'] = 'ISO 15919 Ấn-Arya',
		['or'] = 'ISO 15919 Ấn-Arya',
		['pa'] = 'ISO 15919 Ấn-Arya',
		['pnb'] = 'ISO 15919 Ấn-Arya',
		['raj'] = 'ISO 15919 Ấn-Arya',
		['sa'] = 'ISO 15919 Ấn-Arya',
		['sat'] = 'ISO 15919 Ấn-Arya',
		['sd'] = 'ISO 15919 Ấn-Arya',
		['si'] = 'ISO 15919 Ấn-Arya',
		['skr'] = 'ISO 15919 Ấn-Arya',
		['ta'] = 'ISO 15919 Ấn-Arya',
		['tcy'] = 'ISO 15919 Ấn-Arya',
		['te'] = 'ISO 15919 Ấn-Arya',
		['beng'] = 'ISO 15919 Ấn-Arya',
		['brah'] = 'ISO 15919 Ấn-Arya',
		['deva'] = 'ISO 15919 Ấn-Arya',
		['gujr'] = 'ISO 15919 Ấn-Arya',
		['guru'] = 'ISO 15919 Ấn-Arya',
		['knda'] = 'ISO 15919 Ấn-Arya',
		['mlym'] = 'ISO 15919 Ấn-Arya',
		['orya'] = 'ISO 15919 Ấn-Arya',
		['sinh'] = 'ISO 15919 Ấn-Arya',
		['taml'] = 'ISO 15919 Ấn-Arya',
		['telu'] = 'ISO 15919 Ấn-Arya',

		['default'] = 'Chuyển tự theo tiêu chuẩn ISO',
		},

	['jyutping'] = {
		['default'] = 'Bính âm Việt ngữ',
		},

	['mlcts'] = {
		['default'] = 'Hệ thống phiên âm của Ủy ban Ngôn ngữ Myanmar',
		},

	['mr'] = {
		['default'] = 'Chuyển tự McCune–Reischauer',
		},

	['nihon-shiki'] = {
		['default'] = 'Chuyển tự Nihon-shiki',
		},

	['no_std'] = {																-- when no transliteration standard is supplied
		['akk'] = 'Chuyển tự Semit',
		['sem'] = 'Chuyển tự Semit',
		['phnx'] = 'Chuyển tự Semit',
		['xsux'] = 'Chuyển tự chữ hình nêm',
		},

	['pinyin'] = {
		['default'] = 'Bính âm Hán ngữ',
		},

	['rr'] = {
		['default'] = 'Revised Romanization of Korean transliteration',
		},

	['rtgs'] = {
		['default'] = 'Hệ thống Chuyển tự Tiếng Thái Hoàng gia',
		},
	
	['satts'] = {
		['default'] = 'Standard Arabic Technical Transliteration System transliteration',
		},

	['scientific'] = {
		['default'] = 'Chuyển tự khoa học',
		},

	['ukrainian'] = {
		['default'] = 'Hệ phiên âm Latinh quốc gia cho tiếng Ukraina',
		},

	['ungegn'] = {
		['default'] = 'United Nations Group of Experts on Geographical Names transliteration',
		},

	['wadegile'] = {
		['default'] = 'Chuyển tự Wade–Giles',
		},

	['wehr'] = {
		['default'] = 'Chuyển tự Hans Wehr',
		},
	['yaleko'] = {
		['default'] = 'Hệ phiên âm Latinh Yale cho tiếng Hàn Quốc',
	}
};


--[[--------------------------< E N G _ V A R >----------------------------------------------------------------

Used at en.wiki so that spelling of 'romanized' (US, default) can be changed to 'romanised' to match the envar
specified by a {{Use xxx English}}.

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
		['romanisz_lc'] = 'latinh hoá',											-- lower case
		['romanisz_uc'] = 'Latinh hoá',											-- upper case
		['romanisz_pt'] = 'đâ Latinh hoá',										-- past tense
		},
	['us_t'] = {																-- default engvar
		['romanisz_lc'] = 'latinh hoá',											-- lower case
		['romanisz_uc'] = 'Latinh hoá',											-- upper case
		['romanisz_pt'] = 'đã Latinh hoá',										-- past tense
		}
	}


--[[--------------------------< E X P O R T S >----------------------------------------------------------------
]]

return
	{
	this_wiki_lang_tag = this_wiki_lang_tag,
	this_wiki_lang_dir = lang_obj:getDir(),										-- wiki's language direction
	
	article_name = article_name,
	engvar_t = engvar_t,
	engvar_sel_t = engvar_sel_t,
	lang_name_table = lang_name_table_t,
	override = override,
	rtl_scripts = rtl_scripts,
	special_tags_table = special_tags_table,
	translit_title_table = translit_title_table,
	};
