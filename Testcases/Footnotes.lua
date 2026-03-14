-- Unit tests for [[Module:Footnotes]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_harvnb()
    self:preprocess_equals_preprocess_many('{{harvard citation no brackets/sandbox|', '}}', '{{harvnb|', '}}', {
        {""},
        { "Smith | 2004" },
        { "Smith | Jones | 2004" },
        { "Smith | Jones | Brown | 2004" },
        { "Smith | Jones | Brown | Taylor | 2004" },
        { "Smith | Jones | Brown | Taylor | King | 2004" },
        { "Smith | Jones | 2004 | p=45" },
        { "Smith | Jones | 2004 | page=45" },
        { "Smith | Jones | 2004 | p=45 | page =46" },
        { "Smith | Jones | 2004 | pp=23-57" },
        { "Smith | Jones | 2004 | pages=45-78" },
        { "Smith | Jones | 2004 | pp=23-57 | pages=45-78" },
        { "Smith | Jones | 2004 | pp=23-57 | loc=45-78" },
        { "Smith | Jones | 2004 | p=23 | loc=45-78" },
        { "Smith | Jones | 2004 | p=23 | page=45 | pp=23-57 | pages=45-78| location=145-178" },
        { "Smith | Jones | 2004 | loc=Chapter 2" },
        { "Smith | Jones | Brown | 2004 | ref = none" },
        { "Smith | Jones | Brown | 2004 | ref = Cream cheese" },
        { " Smith|2011|loc=[http://en.wikipedia.org chpt 3]" },        
        { " 中国 | चीन | 2004" },
        { " aiguë  | Dütschlünd | 2004" },
    } )
end

function p:test_sfn()
    self:preprocess_equals_preprocess_many('{{sfn/sandbox|', '}}', '{{sfn|', '}}', {
        {""},
        { "Smith | 2004" },
        { "Smith | Jones | 2004" },
        { "Smith | Jones | Brown | 2004" },
        { "Smith | Jones | Brown | Taylor | 2004" },
        { "Smith | Jones | Brown | Taylor | King | 2004" },
        { "Smith | Jones | 2004 | p=45" },
        { "Smith | Jones | 2004 | page=45" },
        { "Smith | Jones | 2004 | p=45 | page =46" },
        { "Smith | Jones | 2004 | pp=23-57" },
        { "Smith | Jones | 2004 | pages=45-78" },
        { "Smith | Jones | 2004 | pp=23-57 | pages=45-78" },
        { "Smith | Jones | 2004 | pp=23-57 | loc=45-78" },
        { "Smith | Jones | 2004 | p=23 | loc=45-78" },
        { "Smith | Jones | 2004 | p=23 | page=45 | pp=23-57 | pages=45-78| location=145-178" },
        { "Smith | Jones | 2004 | loc=Chapter 2" },
        { "Smith | Jones | Brown | 2004 | ref = none" },
        { "Smith | Jones | Brown | 2004 | ref = Cream cheese" },
        { " Smith|2011|loc=[http://en.wikipedia.org chpt 3]" },        
        { " 中国 | चीन | 2004" },
        { " aiguë  | Dütschlünd | 2004" },
    })
end


function p:test_harv()
    self:preprocess_equals_preprocess_many('{{harvard citation/sandbox|', '}}', '{{harv|', '}}', {
        {""},
        { "Smith | 2004" },
        { "Smith | Jones | 2004" },
        { "Smith | Jones | Brown | 2004" },
        { "Smith | Jones | Brown | Taylor | 2004" },
        { "Smith | Jones | Brown | Taylor | King | 2004" },
        { "Smith | Jones | 2004 | p=45" },
        { "Smith | Jones | 2004 | page=45" },
        { "Smith | Jones | 2004 | p=45 | page =46" },
        { "Smith | Jones | 2004 | pp=23-57" },
        { "Smith|2006| pp=25–26 | Ref=none" },
        { "Smith | Jones | 2004 | pages=45-78" },
        { "Smith | Jones | 2004 | pp=23-57 | pages=45-78" },
        { "Smith | Jones | 2004 | pp=23-57 | loc=45-78" },
        { "Smith | Jones | 2004 | p=23 | loc=45-78" },
        { "Smith | Jones | 2004 | p=23 | page=45 | pp=23-57 | pages=45-78| location=145-178" },
        { "Smith | Jones | 2004 | loc=Chapter 2" },
        { "Smith | Jones | Brown | 2004 | ref = none" },
        { "Smith | Jones | Brown | 2004 | ref = Cream cheese" },
        { " Smith|2011|loc=[http://en.wikipedia.org chpt 3]" },        
        { " 中国 | चीन | 2004" },
        { " aiguë  | Dütschlünd | 2004" },
    } )
end

function p:test_harvard_core()
	if nil then
    self:preprocess_equals_preprocess_many('{{harvard citation/core/sandbox|', '}}', '{{harvard citation/core|', '}}', {
        { "" },
        { "P1 = Smith | P2 = 2004 | REF = ABC" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | REF = ABC" },
        { "P1 = Smith | P2 = Jones | P3 = Brown | P4 = 2004 | REF = ABC" },
        { "P1 = Smith | P2 = Jones | P3 = Brown | P4 = Taylor | P5 = 2004 | REF=ABC" },
        { "P1 = Smith | P2 = Jones | P3 = Brown | P4 = Taylor | P5 = King | P6 = 2004 | REF=ABC" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | Page=45 | REF=ABC | PageSep=, p.&nbsp;" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | Pages=23-57| REF = ABC | PagesSep=, pp.&nbsp;" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | Location=45-78 | REF = ABC" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | Page=23 | Location=45-78 | REF= ABC | PageSep=, p.&nbsp;" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | Page=45 | Pages=45-78| Location=145-178 | REF = ABC| PageSep=, p.&nbsp;| PagesSep=, pp.&nbsp;" },
        { "P1 = Smith | P2 = Jones | P3 = 2004 | Location=Chapter 2 | REF = ABC" },
        { "P1 = Smith | P2 = Jones | P3 = Brown | P4 = 2004 | REF = none" },
        { "P1 = Smith | P2 = Jones | P3 = Brown | P4 = 2004 | REF = Cream cheese" },
        { "P1=Smith| P2 = 2011 | Location=[http://en.wikipedia.org chpt 3] | REF=ABC" },        
        { "P1 = Smith | P2 = Jones | P3 = 2004 | REF = ABC | BracketRight=% | BracketLeft=_ | BracketYearRight=@ | BracketYearLeft=^ | Postscript = ..." },
    } )
    end
end

return p;
