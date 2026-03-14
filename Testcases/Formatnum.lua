-- Unit tests for [[Module:Formatnum]]. Click talk page to run tests.
local p = require('Module:UnitTests')

local function err(msg)
	-- Generates wikitext error messages.
	return mw.ustring.format('<strong class="error">Formatting error: %s</strong>', msg)
end

function p:test_1_English_basic()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|0|en}}', '0')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|-123|en}}', '-123')
end

function p:test_2_unnecessary_signs()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|-0|en}}', '0')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|+123|en}}', '123')
end

function p:test_3_non_numbers_preserved()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12:34:45|en}}', '12:34:45')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12 h 34|fr}}', '12 h 34')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12:34:45|th}}', '12:34:45')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12:34:45.00|en}}', '12:34:45.00')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12°34′45.00″|en}}', '12°34′45.00″')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|some words...|en}}', 'some words...')
end

function p:test_4_English_precision_rounding()
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100|en|prec=1}}', '100.0')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100.0|en|prec=1}}', '100.0')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100.01|en|prec=2}}', '100.01')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100.01|en|prec=3}}', '100.010')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100.010|en|prec=2}}', '100.01')
end

function p:test_5_English_bad_parameters()
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|.10,00|en}}', '.10,00')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|.10,00|en|sep=}}', '.10,00')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100,0.|en}}', '100,0.')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100,0.|en|sep=}}', '100,0.')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100.01|en|prec=-2}}', '100.01')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|200.1|en|prec=3.5}}', '200.100')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|200.1|en|prec=3,5}}', '200.1')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|200.1|en|prec=a}}', '200.1')
end

function p:test_6_decimal_separator()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|.12345|en}}', '0.12345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|.12345|fr}}', '0,12345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|123.45|en}}', '123.45')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|123.45|fr}}', '123,45')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|123.|en}}', '123')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|123.|fr}}', '123')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|123.00|en}}', '123')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|123.00|fr}}', '123')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1001|de}}', '1.001')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1001|pl}}', '1001')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1001|en}}', '1,001')
end

function p:test_7_no_grouping_separators()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|en|sep=1}}', '100000')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|fr|sep=1}}', '100000')
end

function p:test_8_HTML_entity_or_native_UTF8()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|en}}', '12,345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|fr}}', '12\194\160345') -- "\194\160" in Lua litterals is NBSP (U+00A0) encoded in UTF-8 (0xC2,0xA0)
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|en}}', '12,345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|fr}}', '12\194\160345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|br}}', '12\194\160345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|co}}', '12\194\160345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|oc}}', '12\194\160345')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|12345|ty}}', '12\194\160345')
end

function p:test_9_grouping_separators()
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|en}}', '1,234,567,890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|es}}', '1.234.567.890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|pt}}', '1.234.567.890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|ka}}', '1,234,567,890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|mn}}', '᠑,᠒᠓᠔,᠕᠖᠗,᠘᠙᠐')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|ar}}', '۱,۲۳۴,۵۶۷,۸۹۰')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|fa}}', '۱,۲۳۴,۵۶۷,۸۹۰')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|ks}}', '۱,۲۳۴,۵۶۷,۸۹۰')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|hi}}', '१,२३,४५,६७,८९०')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|bn}}', '১,২৩,৪৫,৬৭,৮৯০')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|ta}}', '1,23,45,67,890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|te}}', '౧,౨౩,౪౫,౬౭,౮౯౦')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|kn}}', '೧,೨೩,೪೫,೬೭,೮೯೦ ')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|or}}', '୧,୨୩,୪୫,୬୭,୮୯୦')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|gu}}', '1,23,45,67,890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|pa}}', '1,23,45,67,890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|bo}}',  '༡,༢༣༤,༥༦༧,༨༩༠')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|th}}', '๑,๒๓๔,๕๖๗,๘๙๐')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|km}}', '1,234,567,890')
	self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|1234567890|lo}}', '໑,໒໓໔,໕໖໗,໘໙໐ ')
end

function p:test_Error_more_than_20_languages()
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|ab|sep=1}}', '100000')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|ace|sep=1}}', '100000')
end

function p:test_Unsupported_languages_using_user_default_language_instead_may_fail()
    -- these may fail depending on supported language of the user if it uses non-ASCII digits
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000||sep=1}}', '100000') -- unspecified Wikimedia default
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|aa|sep=1}}', '100000') -- Afar
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|qq|sep=1}}', '100000') -- Private-use
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|qqa|sep=1}}', '100000') -- Private-use
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|mul|sep=1}}', '100000') -- Multilingual
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|und|sep=1}}', '100000') -- Undetermined
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|root|sep=1}}', '100000') -- CLDR default
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|user|sep=1}}', '100000')
    self:preprocess_equals('{{#invoke:Formatnum/sandbox|main|100000|invalid|sep=1}}', '100000')
end

return p
