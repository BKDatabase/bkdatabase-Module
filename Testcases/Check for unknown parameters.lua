-- Unit tests for [[Module:Check for unknown parameters]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_01_1_check()
	self:preprocess_equals_sandbox_many('{{Module:Check for unknown parameters/testcases/template call', '', {
		{"arg1=arg1| arg2=arg2 | name=name | height=height | weight=weight | website=website", "Unknown name,Unknown height,Unknown website,Unknown weight,"},
	    }, {nowiki=1})
end

return p
