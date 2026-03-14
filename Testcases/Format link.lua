-- Unit tests for [[Module:Format link]]
local mFormatLink = require('Module:Format link/sandbox')
local scribuntoUnit = require('Module:ScribuntoUnit')
local suite = scribuntoUnit:new()

--------------------------------------------------------------------------------
-- Testing helper functions
--------------------------------------------------------------------------------

function suite:assertParentFrameCallEquals(expected, func, args)
	args = args or {}
	local current = mw.getCurrentFrame()
	local parent = current:newChild{title = 'Parent', args = args}
	local child = parent:newChild{title = 'Child'}
	self:assertEquals(expected, func(child))
end


-------------------------------------------------------------------------------
-- formatLink tests
-------------------------------------------------------------------------------

function suite:testFormatLink()
	self:assertEquals('[[:Foo]]', mFormatLink._formatLink{link = 'Foo'})
end

function suite:testFormatLinkColonHandling()
	self:assertEquals(
		'[[:Category:Foo]]',
		mFormatLink._formatLink{link = ':Category:Foo'}
	)
end

function suite:testFormatLinkSectionLinking()
	self:assertEquals(
		'[[:Foo#Bar|Foo §&nbsp;Bar]]',
		mFormatLink._formatLink{link = 'Foo#Bar'}
	)
end

function suite:testFormatLinkPipeHandling()
	self:assertEquals(
		'[[:Foo|Bar]]',
		mFormatLink._formatLink{link = 'Foo|Bar'}
	)
end

function suite:testFormatLinkDisplay()
	self:assertEquals(
		'[[:Foo|Bar]]',
		mFormatLink._formatLink{link = 'Foo', display = 'Bar'}
	)
end

function suite:testFormatLinkDisplayOverwritesManualPiping()
	self:assertEquals(
		'[[:Foo|Baz]]',
		mFormatLink._formatLink{link = 'Foo|Bar', display = 'Baz'}
	)
end

function suite:testFormatLinkPageItalicization()
	self:assertEquals(
		"[[:Foo|<i>Foo</i>]]",
		mFormatLink._formatLink{link = 'Foo', italicizePage = true}
	)
end

function suite:testFormatLinkPageItalicizationWithSection()
	self:assertEquals(
		"[[:Foo#Bar|<i>Foo</i> §&nbsp;Bar]]",
		mFormatLink._formatLink{link = 'Foo#Bar', italicizePage = true}
	)
end

function suite:testFormatLinkSectionItalicization()
	self:assertEquals(
		"[[:Foo#Bar|Foo §&nbsp;<i>Bar</i>]]",
		mFormatLink._formatLink{link = 'Foo#Bar', italicizeSection = true}
	)
end

function suite:testFormatLinkPageItalicizationIsOverwrittenByDisplay()
	self:assertEquals(
		"[[:Foo#Bar|Baz]]",
		mFormatLink._formatLink{
			link = 'Foo#Bar',
			display = 'Baz',
			italicizePage = true,
		}
	)
end

function suite:testFormatLinkSectionItalicizationIsOverwrittenByDisplay()
	self:assertEquals(
		"[[:Foo#Bar|Baz]]",
		mFormatLink._formatLink{
			link = 'Foo#Bar',
			display = 'Baz',
			italicizeSection = true,
		}
	)
end

function suite:testFormatLinkItalicizationIsOverwrittenByManualPiping()
	self:assertEquals(
		"[[:Foo#Bar|Baz]]",
		mFormatLink._formatLink{
			link = 'Foo#Bar|Baz',
			italicizePage = true,
			italicizeSection = true,
		}
	)
end

function suite:testFormatLinkWithSectionOnlyLink()
	self:assertEquals(
		"[[:#Section|§&nbsp;Section]]",
		mFormatLink._formatLink{
			link = '#Section',
		}
	)
end

function suite:testFormatLinkWithSectionOnlyLinkAndItalicizedSection()
	self:assertEquals(
		"[[:#Section|§&nbsp;<i>Section</i>]]",
		mFormatLink._formatLink{
			link = '#Section',
			italicizeSection = true,
		}
	)
end

function suite:testFormatLinkWithSectionOnlyLinkAndItalicizedPage()
	self:assertEquals(
		"[[:#Section|§&nbsp;Section]]",
		mFormatLink._formatLink{
			link = '#Section',
			italicizePage=true,
		}
	)
end

function suite:testFormatLinkEntryPoint()
	self:assertParentFrameCallEquals('[[:Foo]]', mFormatLink.formatLink, {'Foo'})
	self:assertParentFrameCallEquals(
		'[[:Foo|Bar]]',
		mFormatLink.formatLink, {'Foo', 'Bar'}
	)
	self:assertParentFrameCallEquals(
		"[[:Foo#Bar|<i>Foo</i> §&nbsp;<i>Bar</i>]]",
		mFormatLink.formatLink,
		{'Foo#Bar', italicizepage="yes", italicizesection="yes"}
	)
	self:assertParentFrameCallEquals(
		"[[:Foo#Bar|Foo §&nbsp;Bar]]",
		mFormatLink.formatLink,
		{'Foo#Bar', italicizepage="no", italicizesection="no"}
	)
end

function suite:testFormatLinkNonexistentPageCategorization()
	self:assertEquals(
		'[[:Nonexistent page]][[Category:Test]]',
		mFormatLink._formatLink{
			link = 'Nonexistent page', --*should* be nonexistent; is salted
			categorizeMissing = 'Test'
		}
	)
end

function suite:testFormatLinkTarget()
	self:assertEquals(
		'[[:Baz|Foo §&nbsp;Bar]]',
		mFormatLink._formatLink{
			link = "Foo#Bar",
			target = 'Baz'
		}
	)
end

function suite:testFormatLinkTargetPiping()
	self:assertEquals(
		'[[:Baz|Boop]]',
		mFormatLink._formatLink{
			link = "Foo#Bar|Boop",
			target = 'Baz'
		}
	)
end

-------------------------------------------------------------------------------
-- formatPages tests
-------------------------------------------------------------------------------

function suite:testFormatPages()
	self:assertDeepEquals(
		{'[[:Foo]]', '[[:Bar]]'},
		mFormatLink.formatPages({}, {'Foo', 'Bar'})
	)
end

return suite
