-- Unit tests for [[Module:Anchor]]. Click talk page to run tests.

local anchor = require('Module:Anchor') -- the module to be tested
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

function suite:testmain()
	self:assertResultEquals('<span class="anchor" id="foo"></span>', '{{#invoke:Anchor|main|foo}}')
	self:assertResultEquals('<span class="anchor" id="foo"></span><span class="anchor" id="bar"></span>', '{{#invoke:Anchor|main|foo|bar}}')
	self:assertResultEquals('<span class="anchor" id="foo"></span>', '{{#invoke:Anchor|main|3=foo}}')
	self:assertResultEquals('<span class="anchor" id="foo"></span>', '{{#invoke:Anchor|main|  foo  }}')
	self:assertResultEquals('<span class="anchor" id="foo"></span>', '{{#invoke:Anchor|main|25=foo}}')
end

function suite:test_main()
	self:assertResultEquals('<span class="anchor" id="foo"></span>', anchor._main('foo'))
	self:assertResultEquals('<span class="anchor" id="foo"></span><span class="anchor" id="bar"></span>', anchor._main('foo', 'bar'))
end

function suite:testAgainstTemplate()
	self:assertSameResult('{{anchor|foo}}', '{{#invoke:Anchor|main|foo}}')
	self:assertSameResult('{{anchor|foo|bar}}', '{{#invoke:Anchor|main|foo|bar}}')
	self:assertSameResult('{{anchor|3=foo}}', '{{#invoke:Anchor|main|3=foo}}')
end

return suite
