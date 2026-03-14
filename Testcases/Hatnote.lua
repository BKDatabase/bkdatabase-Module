local mHatnote = require('Module:Hatnote/sandbox') -- the module to be tested
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

function suite:assertError(func, ...)
	local success, result = pcall(func, ...)
	self:assertFalse(success)
end

function suite:assertNotEquals(expected, actual)
	self:assertTrue(expected ~= actual)
end

function suite:assertParentFrameCallEquals(expected, func, args)
	args = args or {}
	local current = mw.getCurrentFrame()
	local parent = current:newChild{title = 'Parent', args = args}
	local child = parent:newChild{title = 'Child'}
	self:assertEquals(expected, func(child))
end

function suite:assertParentFrameCallContains(expected, func, args)
	args = args or {}
	local current = mw.getCurrentFrame()
	local parent = current:newChild{title = 'Parent', args = args}
	local child = parent:newChild{title = 'Child'}
	self:assertStringContains(expected, func(child))
end

-------------------------------------------------------------------------------
-- findNamespaceId tests
-------------------------------------------------------------------------------

function suite:testFindNamespaceIdInputErrors()
    self:assertError(mHatnote.findNamespaceId, 9)
    self:assertError(mHatnote.findNamespaceId)
    self:assertError(mHatnote.findNamespaceId, 'A page', 9)
end

function suite:testFindNamespaceIdNamespaces()
	self:assertEquals(0, mHatnote.findNamespaceId('Foo'))
	self:assertEquals(2, mHatnote.findNamespaceId('User:Example'))
	self:assertEquals(14, mHatnote.findNamespaceId('Category:Example'))
end

function suite:testFindNamespaceIdColonRemoval()
	self:assertEquals(14, mHatnote.findNamespaceId(':Category:Example'))
end

function suite:testFindNamespaceIdSkipColonRemoval()
	self:assertNotEquals(14, mHatnote.findNamespaceId(':Category:Example', false))
end

-------------------------------------------------------------------------------
-- makeWikitextError tests
-------------------------------------------------------------------------------

function suite:testMakeWikitextError()
	self:assertEquals(
		'<strong class="error">Error: Foo.</strong>[[Category:Hatnote templates with errors]]',
		mHatnote.makeWikitextError('Foo', nil, nil, mw.title.new('Example'))
	)
end

function suite:testMakeWikitextErrorHelpLink()
	self:assertEquals(
		'<strong class="error">Error: Foo ([[Bar|help]]).</strong>[[Category:Hatnote templates with errors]]',
		mHatnote.makeWikitextError('Foo', 'Bar', nil, mw.title.new('Example'))
	)
end

function suite:testMakeWikitextErrorManualCategorySuppression()
	self:assertEquals(
		'<strong class="error">Error: Foo.</strong>',
		mHatnote.makeWikitextError('Foo', nil, false, mw.title.new('Example'))
	)
end

function suite:testMakeWikitextErrorTalkPageCategorySuppression()
	self:assertEquals(
		'<strong class="error">Error: Foo.</strong>',
		mHatnote.makeWikitextError('Foo', nil, nil, mw.title.new('Talk:Example'))
	)
end

-------------------------------------------------------------------------------
-- hatnote tests
-------------------------------------------------------------------------------

function suite:testHatnoteInputErrors()
    self:assertError(mHatnote._hatnote, 9)
    self:assertError(mHatnote._hatnote)
    self:assertError(mHatnote._hatnote, 'A page', 9)
end

function suite:testHatnote()
	self:assertStringContains(
		'<div role="note" class="hatnote navigation%-not%-searchable">Foo</div>',
		mHatnote._hatnote('Foo')
	)
end

function suite:testHatnoteSelfref()
	self:assertStringContains(
		'<div role="note" class="hatnote navigation%-not%-searchable selfref">Foo</div>',
		mHatnote._hatnote('Foo', {selfref = true})
	)
end

function suite:testHatnoteExtraClasses()
	self:assertStringContains(
		'<div role="note" class="hatnote navigation%-not%-searchable extraclass">Foo</div>',
		mHatnote._hatnote('Foo', {extraclasses = 'extraclass'})
	)
end

function suite:testHatnoteEntryPoint()
	self:assertParentFrameCallContains(
		'<div role="note" class="hatnote navigation%-not%-searchable">Foo</div>',
		mHatnote.hatnote,
		{'Foo'}
	)
end

function suite:testHatnoteEntryPointSelfref()
	self:assertParentFrameCallContains(
		'<div role="note" class="hatnote navigation%-not%-searchable selfref">Foo</div>',
		mHatnote.hatnote,
		{'Foo', selfref = 'yes'}
	)
end

function suite:testHatnoteEntryPointExtraClasses()
	self:assertParentFrameCallContains(
		'<div role="note" class="hatnote navigation%-not%-searchable extraclass">Foo</div>',
		mHatnote.hatnote,
		{'Foo', extraclasses = 'extraclass'}
	)
end

return suite
