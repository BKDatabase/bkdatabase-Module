--[[--------------------------< O V E R R I D E _ 1 >----------------------------------------------------------

Language codes and names in this table override the ISO 639 names in: Module:Lang/data/iana languages

]]

local override_1 = {
	["bo"] = {"Standard Tibetan"},												-- en.wiki preferred; Tibetan
	["el"] = {"Greek"},															-- Modern Greek (1453-)
	["ht"] = {"Haitian Creole"},												-- en.wiki preferred; Haitian
--	["mo"] = {"Moldovan"},														-- deprecated in ISO 639, still in use at en.wiki
	["st"] = {"Sotho"},															-- Southern Sotho; match ISO 639-2; en.wiki preferred
	["to"] = {"Tongan"},														-- en.wiki preferred; Tonga (Tonga Islands)
	}


--[[--------------------------< O V E R R I D E _ 2 >----------------------------------------------------------

Language codes and names in this table override the ISO 639 names in: Module:ISO 639 name/ISO 639-2

]]

local override_2 = {
--	["ang"] = {"Old English"},													-- English, Old (ca.450-1100)
	["bod"] = {"Standard Tibetan"},												-- en.wiki preferred; Tibetan
--	["dum"] = {"Middle Dutch"},													-- Dutch, Middle (ca.1050-1350)
	["egy"] = {"Ancient Egyptian"},												-- Egyptian (Ancient)
	["ell"] = {"Greek"},														-- Greek, Modern (1453-)
--	["enm"] = {"Middle English"},												-- English, Middle (1100-1500)
--	["frm"] = {"Middle French"},												-- French, Middle (ca.1400-1600)	
--	["fro"] = {"Old French"},													-- French, Old (842-ca.1400)
--	["gmh"] = {"Middle High German"},											-- German, Middle High (ca.1050-1500)
--	["goh"] = {"Old High German"},												-- German, Old High (ca.750-1050)
--	["grc"] = {"Ancient Greek"},												-- Greek, Ancient (to 1453)
	["hat"] = {"Haitian Creole"},												-- en.wiki preferred; Haitian
--	["mga"] = {"Middle Irish"},													-- Irish, Middle (900-1200)
--	["mol"] = {"Moldovan"},														-- deprecated in ISO 639, still in use at en.wiki
	["nbl"] = {"Southern Ndebele"},												-- Ndebele, South or South Ndebele
	["nde"] = {"Northern Ndebele"},												-- Ndebele, North or North Ndebele
	["nob"] = {"Norwegian Bokmål"},												-- Bokmål, Norwegian or Norwegian Bokmål
--	["non"] = {"Old Norse"},													-- Norse, Old
--	["ota"] = {"Ottoman Turkish"},												-- Turkish, Ottoman (1500-1928)
--	["peo"] = {"Old Persian"},													-- Persian, Old (ca.600-400 B.C.)
	["pro"] = {"Old Occitan"},													-- Provençal, Old (to 1500) or Occitan, Old (to 1500)
--	["sga"] = {"Old Irish"},													-- Irish, Old (to 900)
	["sot"] = {"Sotho"},														-- Sotho, Southern; en.wiki preferred
	["ton"] = {"Tongan"},														-- en.wiki preferred; Tonga (Tonga Islands)
	}


--[[--------------------------< O V E R R I D E _ 2 B >--------------------------------------------------------

Language codes and names in this table override the ISO 639 names in: Module:ISO 639 name/ISO 639-2B

]]

local override_2B = {
	["gre"] = {"Greek"},														-- Greek, Modern (1453-)
	["tib"] = {"Standard Tibetan"},												-- en.wiki preferred; Tibetan
	}


--[[--------------------------< O V E R R I D E _ 3 >----------------------------------------------------------

Language codes and names in this table override the ISO 639 names in: Module:ISO 639 name/ISO 639-3

]]

local override_3 = {
	["bod"] = {"Standard Tibetan"},												-- en.wiki preferred; Tibetan
	["egy"] = {"Ancient Egyptian"},												-- Egyptian (Ancient)
	["ell"] = {"Greek"},														-- Modern Greek (1453-)
	["haa"] = {"Hän"},															-- to avoid redirect; Han
	["hat"] = {"Haitian Creole"},												-- en.wiki preferred; Haitian
--	["mol"] = {"Moldovan"},														-- deprecated in ISO 639, still in use at en.wiki as ISO 639-1 mo
	['mte'] = {"Mono-Alu"},														-- en.wiki preferred; Mono (Solomon Islands)
	["nbl"] = {"Southern Ndebele"},												-- South Ndebele
	["nde"] = {"Northern Ndebele"},												-- North Ndebele
	["pms"] = {"Piedmontese"},													-- ISO 639-3 name is Piemontese; to match en.wiki article title
	["pnb"] = {"Punjabi"},														-- Western Panjabi, a dab; en.wiki preferred
	["sot"] = {"Sotho"},														-- Southern Sotho; match ISO 639-2; en.wiki preferred
	["ton"] = {"Tongan"},														-- en.wiki preferred; Tonga (Tonga Islands)
	}


--[[--------------------------< O V E R R I D E _ 5 >----------------------------------------------------------

Language codes and names in this table override the ISO 639 names in: Module:ISO 639 name/ISO 639-5

]]

local override_5 = {
	}


--[[--------------------------< O V E R R I D E _ D E P >------------------------------------------------------

Language codes and names in this table override the ISO 639 names in: Module:ISO 639 name/ISO 639 deprecated

]]

local override_dep = {
	}


--[[--------------------------< A R T I C L E _ L I N K >------------------------------------------------------

for those rare occasions when article titles don't fit with the normal '<language name> language', this table
maps language code to article title.  Use of this table should be avoided and the use of redirects preferred as
that is the long-standing method of handling article names that don't fit with the normal pattern

]]

local article_name = {
	["lij"] = {"Ligurian (Romance language)"},									-- Ligurian; see Template_talk:Lang#Ligurian_dab
	['mbo'] = {"Mbo language (Cameroon)"},										-- Mbo (Cameroon)
	['mnh'] = {"Mono language (Congo)"},										-- Mono (Democratic Republic of Congo); see Template_talk:Lang#Mono_languages
	['mnr'] = {"Mono language (California)"},									-- Mono (USA)
	['mru'] = {"Mono language (Cameroon)"},										-- Mono (Cameroon)
	["xlg"] = {"Ligurian (ancient language)"},									-- see Template_talk:Lang#Ligurian_dab
	["zmw"] = {"Mbo language (Congo)"},											-- Mbo (Democratic Republic of Congo)
	}


--[[--------------------------< E X P O R T E D   T A B L E S >------------------------------------------------
]]

return
	{
	override_1 = override_1,
	override_2 = override_2,
	override_2B = override_2B,
	override_3 = override_3,
	override_5 = override_5,
	override_dep = override_dep,
	
	article_name = article_name,
	}
