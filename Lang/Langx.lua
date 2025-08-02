--[[--------------------------< R T L _ T >--------------------------------------------------------------------

table of language tags that render text right-to-left

Data in this table scraped from {{lang-xx}} templates that set |rtl=yes

keys (tags) in this table must be lowercase.

TODO: in the long run, do we need this table?  Can't {{langx}} apply dir="rtl" attribute automatically?

]]

local rtl_t = {
----------< I S O 6 3 9 - 1 >----------
	['ae'] = true,
	['ar'] = true,
	['fa'] = true,
	['he'] = true,
	['ku'] = true,
	['ps'] = true,
	['sd'] = true,
	['ur'] = true,
	['yi'] = true,

----------< I S O 6 3 9 - 2 , - 3 >----------
	['acm'] = true,
	['aeb'] = true,
	['aec'] = true,
	['afb'] = true,
	['aii'] = true,
	['aij'] = true,
	['aiq'] = true,
	['ajp'] = true,
	['amw'] = true,
	['apc'] = true,
	['arb'] = true,
	['arc'] = true,
	['arq'] = true,
	['ary'] = true,
	['arz'] = true,
	['ayn'] = true,
	['bal'] = true,
	['bdz'] = true,
	['bej'] = true,
	['bgn'] = true,
	['bqi'] = true,
	['brh'] = true,
	['bsk'] = true,
	['ckb'] = true,
	['cld'] = true,
	['deh'] = true,
	['gay'] = true,
	['gbz'] = true,
	['glk'] = true,
	['hac'] = true,
	['haz'] = true,
	['hbo'] = true,
	['hnd'] = true,
	['hno'] = true,
	['jog'] = true,
	['jrb'] = true,
	['jye'] = true,
	['khw'] = true,
	['kls'] = true,
	['kvx'] = true,
	['lrc'] = true,
	['lss'] = true,
	['luz'] = true,
	['mey'] = true,
	['mid'] = true,
	['mki'] = true,
	['mnj'] = true,
	['mwr'] = true,
	['myz'] = true,
	['mzb'] = true,
	['mzn'] = true,
	['nlm'] = true,
	['nqo'] = true,
	['oru'] = true,
	['ota'] = true,
	['otk'] = true,
	['pal'] = true,
	['pes'] = true,
	['prs'] = true,
	['prx'] = true,
	['rif'] = true,
	['rys'] = true,
	['sbn'] = true,
	['scl'] = true,
	['sgh'] = true,
	['siz'] = true,
	['skr'] = true,
	['sqo'] = true,
	['sqr'] = true,
	['srh'] = true,
	['syc'] = true,
	['syr'] = true,
	['tru'] = true,
	['ttt'] = true,
	['wbl'] = true,
	['wne'] = true,
	['xaa'] = true,
	['xdm'] = true,
	['xhe'] = true,
	['xqa'] = true,
	['ydg'] = true,
	}


--[[--------------------------< S C R I P T _ T >--------------------------------------------------------------

table of language tags that use script subtags

Data in this table scraped from {{lang-xx}} templates that set |script=<script tag>

keys (tags) in this table must be lowercase.

]]

local script_t = {
----------< I S O 6 3 9 - 1 >----------
	['ce'] = 'Cyrl',
	['ff'] = 'Latn',
	['sh'] = 'Latn',

----------< I S O 6 3 9 - 2 , - 3 >----------
	['bft'] = 'Aran',
	['brx'] = 'Deva',
	['bsk'] = 'Aran',
	['chr'] = 'Cher',
	['dgo'] = 'Deva',
	['dng'] = 'Cyrl',
	['dyu'] = 'Latn',
	['ess'] = 'Latn',
	['evn'] = 'Cyrl',
	['sat'] = 'Olck',
	['shn'] = 'Mymr',
	}


--[[--------------------------< S I Z E _ T >------------------------------------------------------------------

table of language tags that use |size=

Data in this table scraped from {{lang-xx}} templates that set |size=<size>

keys (tags) in this table must be lowercase.

]]

local size_t = {
	['bft'] = '125%',
	}


--[[--------------------------< L I N K _ T >------------------------------------------------------------------

table of language tags that use |link=

Data in this table scraped from {{lang-xx}} templates that set |link=

keys (tags) in this table must be lowercase.

]]

local link_t = {
	['vi'] = 'no',
	}


--[[--------------------------< U N S U P P O R T E D _ T >----------------------------------------------------

these are language tags from {{lang-??}} templates that should not be converted to {{langx}} during the transition
from {{lang-??}} to {{langx|??}}.

this table used to add a category when {{langx}} templates are encountered with these language tags.

initial contents of this table copied from Wikipedia:Templates_for_discussion/Log/2024_September_27/lang-%3F%3F_templates#excluded_templates

2024-11-15: now that the conversion of the {{lang-??}} templates is complete, and User:Monkbot/task 20 has
completed its work, and now that Module:Lang detects unsupported parameters, those valid IETF tags listed here
can be stricken so that valid use of those tags with {{langx|<tag>|...}} can be allowed.

]]

local unsupported_t = {
	['bcs'] = true,																-- bcs is IANA Kohumono language not Bosnian/Croatian/Serbian grouped under tag sh
	['crh3'] = true,															-- being deleted; convert to something like {{lang-sr-latn-cyrl}}?
	['est-sea'] = true,															-- {{Language with name}} wrapper; convert to private use tag: et-x-seto?
	['fra-frc'] = true,															-- {{Language with name}} wrapper; convert to private use tag: fr-x-frainc?
	['grc-gre'] = true,															-- currently (2024-11-15) being discussed for deletion
	['my-name-mlcts'] = true,													-- wrapper around {{lang-my-Mymr}} to render a {{lang-??}}-like result
	['sq-definite'] = true,														-- definiteness is a linguistic construct
	['su-fonts'] = true,														-- styling
	['uniturk'] = true,															-- a writing system
	['1ca'] = true,																-- uses {{lang}} and trk-Arab-TR; add that tag to ~/data for Old Anatolian Turkish?

--	['ast-leo'] = true,															-- deleted; use ast-es
--	['lmo-cr'] = true,															-- deleted; use lmo-x-cremish
--	['lmo-it'] = true,															-- deleted; use lmo-x-berg
--	['pun'] = true,																-- deleted; was a template dab
--	['sa2'] = true,																-- deleted; use {{lang}}

--	['bcs-latn-cyrl'] = true,													-- {{lang-x2}} template wrappers; these tags not valid
--	['cnr-cyrl-latn'] = true,
--	['cnr-latn-cyrl'] = true,
--	['sh-cyrl-latn'] = true,
--	['sh-latn-cyrl'] = true,
--	['sr-cyrl-latn'] = true,
--	['sr-latn-cyrl'] = true,
--	['uz-cyrl-latn'] = true,
--	['uz-latn-cyrl'] = true,

--	['cnr-cyrl'] = true,														-- valid IETF tags; no reason to prevent their use with {{langx}}
--	['cnr-latn'] = true,
--	['hmd'] = true,
--	['ka'] = true,
--	['ku-arab'] = true,
--	['mnc'] = true,
--	['my-mymr'] = true,
--	['rus'] = true,																-- sort of valid IETF tag; should be promoted to 'ru'
--	['sh-cyrl'] = true,
--	['sh-latn'] = true,
--	['sr'] = true,																-- per Template_talk:Lang#tracking_sr_usage_with_issues; discussion died nothing being done
--	['sr-cyrl'] = true,
--	['sr-latn'] = true,
--	['uz-latn'] = true,
--	['zh'] = true,

--	Moldovan Cyrillic															-- now a redirect to Lang-ro-Cyrl
--	['vi-chunom'] = true,														-- now a redirect to {{Chunom}}
--	['vi-hantu'] = true,														-- now a redirect to {{Chuhan}}
	}


--[[--------------------------< E X P O R T S >----------------------------------------------------------------
]]

return {
	link_t = link_t,
	rtl_t = rtl_t,
	script_t = script_t,
	size_t = size_t,
	unsupported_t = unsupported_t,
	}
