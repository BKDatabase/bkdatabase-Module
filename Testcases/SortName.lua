local p = require('Module:UnitTests')

function p:test_sortname()
    self:preprocess_equals_many('{{#invoke:SortName|sortname|', '}}', {
        { 'Jim Excelsior Tyler', 'Tyler, Jim Excelsior' },
        { 'Jim', 'Jim' },
        { 'List of people named Jim', 'People named Jim' },
        { 'List of jims', 'Jims' },
        { 'Jim Tyler (musician)', 'Tyler, Jim' },
        { 'Jim Tyler, man and myth', 'Tyler, Jim' },
        { 'Jim Tyler of Clan Tyler', 'Tyler, Jim' },
        { 'Jim von Tyler', 'von Tyler, Jim' },
        { 'Jim Von Tyler', 'Von Tyler, Jim' },
        { 'Jim Tyler III', 'Tyler 3, Jim' },
        { 'Jim III', 'Jim 3' },
        { 'Jim Tyler III, Emperor of New Brunswick', 'Tyler 3, Jim' }
    })
end

return p