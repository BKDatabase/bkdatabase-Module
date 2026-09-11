-- Unit tests for [[Module:Separated entries]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_main()
    self:preprocess_equals_many('{{#invoke:Separated entries|main|', '}}', {
    	{'', ''},
        {'A', 'A'},
        {'A|B', 'AB'},
        {'A||B', 'AB'}, -- empty parameter
        {'A|B|C', 'ABC'},
        {'separator=,', ''},
        {'separator=,|A', 'A'},
        {'separator=,|A|B', 'A,B'},
        {'separator=,|A||B', 'A,B'}, -- empty parameter
        {'conjunction=;', ''},
        {'conjunction=;|A', 'A'},
        {'conjunction=;|A|B', 'A;B'},
        {'separator=,|conjunction=;', ''},
        {'separator=,|conjunction=;|A', 'A'},
        {'separator=,|conjunction=;|A|B', 'A;B'},
        {'separator=,|conjunction=;|A|B|C', 'A,B;C'},
        {'separator=,|conjunction=;|A|B|C|D', 'A,B,C;D'},
        {'start=2|separator=,|conjunction=;|A|B|C|D', 'B,C;D'},
        {'dataPlural=1', ''},
        {'dataPlural=1|A', 'A'},
        {'dataPlural=1|A|B', 'AB'},
        {'dataPlural=1|A||B', 'AB'}, -- empty parameter
        {'dataPlural=1|A|B|C', 'ABC'},
        {'dataPlural=1|separator=,', ''},
        {'dataPlural=1|separator=,|A', 'A'},
        {'dataPlural=1|separator=,|A|B', 'A,B'},
        {'dataPlural=1|separator=,|A||B', 'A,B'}, -- empty parameter
        {'dataPlural=1|conjunction=;', ''},
        {'dataPlural=1|conjunction=;|A', 'A'},
        {'dataPlural=1|conjunction=;|A|B', 'A;B'},
        {'dataPlural=1|separator=,|conjunction=;', ''},
        {'dataPlural=1|separator=,|conjunction=;|A', 'A'},
        {'dataPlural=1|separator=,|conjunction=;|A|B', 'A;B'},
        {'dataPlural=1|separator=,|conjunction=;|A|B|C', 'A,B;C'},
        {'dataPlural=1|separator=,|conjunction=;|A|B|C|D', 'A,B,C;D'},
        {'dataPlural=1|start=2|separator=,|conjunction=;|A|B|C|D', 'B,C;D'},
    },{nowiki=1})
end

function p:test_sandbox()
    self:preprocess_equals_many('{{#invoke:Separated entries/sandbox|main|', '}}', {
    	{'', ''},
        {'A', 'A'},
        {'A|B', 'AB'},
        {'A||B', 'AB'}, -- empty parameter
        {'A|B|C', 'ABC'},
        {'separator=,', ''},
        {'separator=,|A', 'A'},
        {'separator=,|A|B', 'A,B'},
        {'separator=,|A||B', 'A,B'}, -- empty parameter
        {'conjunction=;', ''},
        {'conjunction=;|A', 'A'},
        {'conjunction=;|A|B', 'A;B'},
        {'separator=,|conjunction=;', ''},
        {'separator=,|conjunction=;|A', 'A'},
        {'separator=,|conjunction=;|A|B', 'A;B'},
        {'separator=,|conjunction=;|A|B|C', 'A,B;C'},
        {'separator=,|conjunction=;|A|B|C|D', 'A,B,C;D'},
        {'start=2|separator=,|conjunction=;|A|B|C|D', 'B,C;D'},
        {'dataPlural=1', ''},
        {'dataPlural=1|A', 'A'},
        {'dataPlural=1|A|B', 'AB'},
        {'dataPlural=1|A||B', 'AB'}, -- empty parameter
        {'dataPlural=1|A|B|C', 'ABC'},
        {'dataPlural=1|separator=,', ''},
        {'dataPlural=1|separator=,|A', 'A<span style="display:none" data-plural="0"></span>'},
        {'dataPlural=1|separator=,|A|B', 'A,B<span style="display:none" data-plural="1"></span>'},
        {'dataPlural=1|separator=,|A||B', 'A,B<span style="display:none" data-plural="1"></span>'}, -- empty parameter
        {'dataPlural=1|conjunction=;', ''},
        {'dataPlural=1|conjunction=;|A', 'A<span style="display:none" data-plural="0"></span>'},
        {'dataPlural=1|conjunction=;|A|B', 'A;B<span style="display:none" data-plural="1"></span>'},
        {'dataPlural=1|separator=,|conjunction=;', ''},
        {'dataPlural=1|separator=,|conjunction=;|A', 'A<span style="display:none" data-plural="0"></span>'},
        {'dataPlural=1|separator=,|conjunction=;|A|B', 'A;B<span style="display:none" data-plural="1"></span>'},
        {'dataPlural=1|separator=,|conjunction=;|A|B|C', 'A,B;C<span style="display:none" data-plural="1"></span>'},
        {'dataPlural=1|separator=,|conjunction=;|A|B|C|D', 'A,B,C;D<span style="display:none" data-plural="1"></span>'},
        {'dataPlural=1|start=2|separator=,|conjunction=;|A|B|C|D', 'B,C;D<span style="display:none" data-plural="1"></span>'},
    },{nowiki=1})
end

return p
