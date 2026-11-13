-- Unit tests for [[Module:{{ROOTPAGENAME}}]]. Click talk page to run tests.
local p = require('Module:UnitTests')

-- smoke test
function p:test_toHepburn_smoke()
	self:preprocess_equals_many('{{#invoke:Hepburner|toHepburn|','}}', 
	{
		{'ooki','ōki'},
		{'Oubou','Ōbō'},	
		{'saa','sā'},
		{'Aasaa','Āsā'},
		{'iin','iin'},
		{'Iina','Iina'},
		{'shuu','shū'},
		{'Uuna','Ūna'}
	})
end

-- smoke test (sandbox)
function p:test_toHepburn_smoke_sandbox()
	self:preprocess_equals_many('{{#invoke:Hepburner/sandbox|toHepburn|','}}', 
	{
		{'ooki','ōki'},
		{'Oubou','Ōbō'},	
		{'saa','sā'},
		{'Aasaa','Āsā'},
		{'iin','iin'},
		{'Iina','Iina'},
		{'shuu','shū'},
		{'Uuna','Ūna'}
	})
end

return p