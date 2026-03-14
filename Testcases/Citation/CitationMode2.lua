-- Unit tests for [[Module:{{ROOTPAGENAME}}]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_CS1config_used()
	self:preprocess_equals('{{#invoke:Citation mode | main | cs2}}', '')
	self:preprocess_equals('{{#invoke:Citation mode/sandbox | main | cs2}}', '')
end

return p
