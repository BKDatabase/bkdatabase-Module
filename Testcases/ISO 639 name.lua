--[=[
Unit tests for [[Module:ISO 639 name]] error messages. This is not intended to test every possible thing that
can make an error message; rather, it is to test the creation and rendering of the messages themselves.

Click talk page to run tests.

]=]

local p = require('Module:UnitTests')

--[[--------------------------< I S O _ 6 3 9 >----------------------------------------------------------------
]]

function p:test_iso_639()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|iso_639|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639|cat=no|', '}}',
		{
			{''},																-- no code param
			{'xx'},																-- not a 639-1 code
			{'nv'},																-- 639-1 code
			{'cic'},															-- 639-2 code
			{'ice'},															-- 639-2B code
			{'nav'},															-- 639-3 code
			{'apa'},															-- 639-5 code

			{'|'},																-- no code param, no 639-part param
			{'xx|1'},															-- not a 639-1 code
			{'nv|1'},															-- 639-1 code
			{'nav|2'},															-- 639-2 code
			{'ice|2B'},															-- 639-2B code
			{'cic|3'},															-- 639-3 code
			{'apa|5'},															-- 639-5 code

			{'apa|6'},															-- invalid 639-part

			{'el'},																-- 639-1 code in override table
			{'ang'},															-- 639-2 code in override table
			{'gre'},															-- 639-2B code in override table
			{'egy'},															-- 639-3 code in override table
--			{''},																-- 639-5 code at this writing override table is empty

			{'iw'},																-- 639-1 code in deprecated table
			{'mol'},															-- 639-2 code in deprecated table
			{'jaw'},															-- 639-2B code in deprecated table
			{'cqu'},															-- 639-3 code in deprecated table
			{'car'},															-- 639-5 code in deprecated table (also in -2 and -3)

--language names --
			{'Navajo'},															-- 639-1 name
			{'Navajo'},															-- 639-2 name
			{'Navaho'},															-- 639-3 name
			{'Apache languages'},												-- 639-5 name

			{'Navajo|1'},														-- 639-1 name
			{'Navajo|2'},														-- 639-2 name
			{'Icelandic|2B'},													-- 639-2B name
			{'Navaho|3'},														-- 639-3 name
			{'Apache languages|5'},												-- 639-5 name

--			{''},																-- name in deprecated 1; deprecated codes in 1 have same-name as other codes in 1
--			{''},																-- name in deprecated 2; deprecated codes in 2 have same-name as other codes in 2
			{'Javanese|2B'},													-- name in deprecated 2B
			{'Chilean Quechua|3'},												-- name in deprecated 3
			{'Galibi Carib|5'},													-- name in deprecated 5

			{'Navajo|5'},														-- name not in 639-5
			{'Apache languages|3'},												-- name not in 639-3
			{'Chickasaw|2B'},													-- name not in 639-2B
			{'Chickasaw|2'},													-- name not in 639-2
			{'Apache languages|1'},												-- name not in 639-1
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< N A M E _ F R O M _ C O D E >--------------------------------------

cannot specify part

]]

function p:test_name_from_code()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|name_from_code|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_to_name|cat=no|', '}}',
		{
			{''},																-- no language param
			{'xx'},																-- not a 639-1 code
			{'xxx'},															-- not a 639-2, 3, 5 code
			{'nv'},																-- 639-1 code
			{'nav'},															-- 639-2 code
			{'nav'},															-- 639-3 code
			{'apa'},															-- 639-5 code

			{'el'},																-- 639-1 code in override table
			{'ang'},															-- 639-2 code in override table
			{'tib'},															-- 639-2B code in override table
			{'egy'},															-- 639-3 code in override table
--			{''},																-- 639-5 code at this writing override table is empty

			{'iw'},																-- 639-1 code in deprecated table
			{'mol'},															-- 639-2 code in deprecated table
			{'jaw'},															-- 639-2B code in deprecated table
			{'cqu'},															-- 639-3 code in deprecated table
			{'car'},															-- 639-5 code in deprecated table (also in -2 and -3)

-- link & label
			{'nv|link=yes'},													-- links to 639-1 name
			{'nav|link=yes|label=Navaho'},										-- links to 639-2 name with alt spelling label
			{'ice|link=yes|label=Frozen North'},								-- links to 639-2B name with alt spelling label
			{'nav|label=Navaho'},												-- does not link; |label= is ignored
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< N A M E _ F R O M _ C O D E _ 1 >----------------------------------
]]

function p:test_name_from_code_1()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|name_from_code_1|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_1_to_name|cat=no|', '}}',
		{
			{''},																-- no language param
			{'xx'},																-- not a 639-1 code
			{'xx|hide-err=yes'},												-- not a 639-1 code
			{'nv-Latn'},														-- ietf tag
			{'nv'},																-- 639-1 code
			{'nav'},															-- 639-2 code
			{'el'},																-- override 639-1 code
			{'iw'},																-- 639-1 code in deprecated table

			{'nv|link=yes'},													-- linked
			{'nv|link=yes|label=Navaho'},										-- linked with alt label
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< N A M E _ F R O M _ C O D E _ 2 >----------------------------------
]]

function p:test_name_from_code_2()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|name_from_code_2|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_2_to_name|cat=no|', '}}',
		{
			{''},																-- no language param
			{'xxx'},															-- not a 639-2 code
			{'xxx|hide-err=yes'},												-- not a 639-2 code
			{'nav-Latn'},														-- ietf tag
			{'nv'},																-- 639-1 code
			{'nav'},															-- 639-2 code
			{'ice'},															-- 639-2B code
			{'mga'},															-- override 639-2 code
			{'mol'},															-- 639-2 code in deprecated table

			{'nav|link=yes'},													-- linked
			{'nav|link=yes|label=Navaho'},										-- linked with alt label
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< N A M E _ F R O M _ C O D E _ 2 B >--------------------------------
]]

function p:test_name_from_code_2B()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|name_from_code_2B|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_2B_to_name|cat=no|', '}}',
		{
			{''},																-- no language param
			{'xxx'},															-- not a 639-2 code
			{'xxx|hide-err=yes'},												-- not a 639-2 code
			{'nav-Latn'},														-- ietf tag
			{'nv'},																-- 639-1 code
			{'nav'},															-- 639-2T code
			{'ice'},															-- 639-2B code
			{'tib'},															-- 639-2B code in override table
			{'jaw'},															-- 639-2B code in deprecated table

			{'ice|link=yes'},													-- linked
			{'ice|link=yes|label=Frozen North'},								-- linked with alt label
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< N A M E _ F R O M _ C O D E _ 3 >----------------------------------
]]

function p:test_name_from_code_3()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|name_from_code_3|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_3_to_name|cat=no|', '}}',
		{
			{''},																-- no language param
			{'xxx'},															-- not a 639-3 code
			{'xxx|hide-err=yes'},												-- not a 639-3 code
			{'nav-Latn'},														-- ietf tag
			{'nv'},																-- 639-1 code
			{'nav'},															-- 639-3 code
			{'pms'},															-- override 639-3 code
			{'cqu'},															-- 639-3 code in deprecated table

			{'nav|link=yes'},													-- linked
			{'nav|link=yes|label=Navajo'},										-- linked with alt label
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< N A M E _ F R O M _ C O D E _ 5 >----------------------------------
]]

function p:test_name_from_code_5()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|name_from_code_5|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_5_to_name|cat=no|', '}}',
		{
			{''},																-- no language param
			{'xxx'},															-- not a 639-5 code
			{'xxx|hide-err=yes'},												-- not a 639-5 code
			{'nav-Latn'},														-- ietf tag
			{'nv'},																-- 639-1 code
			{'apa'},															-- 639-5 code
--			{''},																-- override 639-5 code; none at this writing
			{'car'},															-- 639-5 code in deprecated table (also in -2 and -3)

			{'apa|link=yes'},													-- linked
			{'apa|link=yes|label=Apache'},										-- linked with alt label
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< C O D E _ F R O M _ N A M E >--------------------------------------
]]

function p:test_code_from_name()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|code_from_name|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_name_to_code|cat=no|', '}}',
		{
			{''},																-- no name param
			{'nv'},																-- 639-1 code
--language names --
			{'Navajo'},															-- 639-1 name
			{'Navajo'},															-- 639-2 name
--			{''},																-- 639-2B names same as -1, -2T names so -1 name will be used for this test
			{'Navaho'},															-- 639-3 name
			{'Apache languages'},												-- 639-5 name

			{'Navajo|1'},														-- 639-1 name
			{'Icelandic|2'},													-- 639-2 name
			{'Icelandic|2B'},													-- 639-2B name
			{'Navaho|3'},														-- 639-3 name
			{'Apache languages|5'},												-- 639-5 name

			{'Navajo|5'},														-- 639-1 name not in 5
			{'Navajo|3'},														-- 639-2 name not in 3
			{'Navaho|2B'},														-- 639-3 name not in 2B
			{'Navaho|2'},														-- 639-3 name not in 2
			{'Apache languages|1'},												-- 639-5 name not in 1

			{'Apache languages|6'},												-- invalid 639-part

			{'Greek'},															-- only 639-1 code in override table
			{'Old English'},													-- 639-2 code in override table
			{'Standard Tibetan'},												-- 639-2B code in override table; same as -1 and -2 so -1 code is returned
			{'Ancient Egyptian'},												-- 639-3 code in override table
--			{''},																-- 639-5 code at this writing override table is empty

--			{''},																-- name in deprecated 1; deprecated codes in 1 have same-name as other codes in 1
--			{''},																-- name in deprecated 2; deprecated codes in 2 have same-name as other codes in 2
			{'Javanese|2B'},													-- name in deprecated 2B
			{'Chilean Quechua|3'},												-- name in deprecated 3
			{'Galibi Carib|5'},													-- name in deprecated 5

-- these should not link
			{'Navajo|link=yes'},												-- 639-1 name
			{'Navajo|link=yes|label=Navajo'},									-- 639-2 name
			{'Navaho|label=Navajo'},											-- 639-3 name
		},
		{nowiki=false, templatestyles=true}
	)
end


--[[--------------------------< I S _ C O D E >----------------------------------------
]]

function p:test_is_code()
    self:preprocess_equals_preprocess_many(
    	'{{#invoke:ISO 639 name/sandbox|is_code|cat=no|', '}}', '{{#invoke:ISO 639 name|iso_639_code_exists|cat=no|', '}}',
		{
			{''},																-- no code param
			{'xx'},																-- not a 639-1 code
			{'xxx'},															-- not a 639-2, 3, 5 code

			{'nv'},																-- 639-1 code
			{'apa'},															-- 639-2 code
			{'ice'},															-- 639-2B code
			{'nav'},															-- 639-2 code

			{'el'},																-- override 639-1 code
			{'mga'},															-- override 639-2 code
			{'pms'},															-- override 639-3 code

			{'iw'},																-- 639-1 code in deprecated table
			{'mol'},															-- 639-2 code in deprecated table
			{'jaw'},															-- 639-2B code in deprecated table
			{'cqu'},															-- 639-3 code in deprecated table
			{'car'},															-- 639-5 code in deprecated table (also in -2 and -3)
		},
		{nowiki=false, templatestyles=true}
	)
end


return p
