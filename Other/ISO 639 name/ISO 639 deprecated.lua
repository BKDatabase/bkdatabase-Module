--[[--------------------------< D E P R E C A T E D _ 1 >------------------------------------------------------

ISO 639-1 code / name pairs taken from https://www.loc.gov/standards/iso639-2/php/code_changes.php

]]

local deprecated_1 = {															-- ISO 639-1 codes
	["in"] = {"Indonesian"},
	["iw"] = {"Hebrew"},
	["ji"] = {"Yiddish"},
	["jw"] = {"Javanese"},
	["mo"] = {"Moldavian", "Moldovan"},
	["sh"] = {"Serbo-Croatian"},												-- deprecated by ISO; retained in IANA
	}	


--[[--------------------------< D E P R E C A T E D _ 2 >------------------------------------------------------

ISO 639-2 code / name pairs taken from https://www.loc.gov/standards/iso639-2/php/code_changes.php

]]

local deprecated_2 = {															-- ISO 639-2 codes
	["mol"] = {"Moldavian", "Moldovan"},										-- ISO 639-3 overwrites this to {"Moldavian"}
	}


--[[--------------------------< D E P R E C A T E D _ 2 B >----------------------------------------------------

ISO 639-2B code / name pairs taken from https://www.loc.gov/standards/iso639-2/php/code_changes.php

]]

local deprecated_2B = {															-- ISO 639-2B codes
	["jaw"] = {"Javanese"},
	["scc"] = {"Serbian"},
	["scr"] = {"Croatian"},
	}


--[[--------------------------< D E P R E C A T E D _ 3 >------------------------------------------------------

ISO 639-3 code / name pairs taken from iso-639-3_Retirements_YYYYMMDD.tab file in Complete Code Tables Set UTF-8
version zip file available at https://iso639-3.sil.org/code_tables/download_tables

function deprecated_3_make() to avoid the metatable trap

]]

local function deprecated_3_make ()
	local dep3 = mw.loadData ('Module:ISO 639 name/ISO 639-3 (dep)');			-- separate source table for deprecated ISO 639-3 codes
	local t = {};
	for k, v in pairs (dep3) do													-- add deprecated ISO 639-3 codes/language names
		t[k] = {v[1]};
	end
	dep3={};
	return t;
end

local deprecated_3 = deprecated_3_make();											-- create deprecated codes/language names table


--[[--------------------------< D E P R E C A T E D _ 5 >------------------------------------------------------

ISO 639-3 code taken from https://www.loc.gov/standards/iso639-5/changes.php; names not listed

]]

local deprecated_5 = {
	["car"] = {"Galibi Carib"},													-- name is assumed from -2, -3 (both active); source  omits name
	}


--[[--------------------------< E X P O R T E D   T A B L E S >------------------------------------------------
]]

return
	{
	deprecated_1 = deprecated_1,
	deprecated_2 = deprecated_2,
	deprecated_2B = deprecated_2B,
	deprecated_3 = deprecated_3,
	deprecated_5 = deprecated_5,
	}
