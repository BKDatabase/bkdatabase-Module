local mCatMain = require('Module:Cat main/sandbox') -- the module to be tested
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------

local function patchCurrentTitle(newTitle, func)
	local oldGetCurrentTitle = mw.title.getCurrentTitle
	mw.title.getCurrentTitle = function ()
		return mw.title.new("Category:Example")
	end
	func()
	mw.title.getCurrentTitle = oldGetCurrentTitle
end

--------------------------------------------------------------------------------
-- Custom assert methods
--------------------------------------------------------------------------------

function suite:assertHasClass(expectedClass, result)
	result = mw.text.killMarkers(result) -- remove TemplateStyles marker
	local classes = result:match('^<div[^>]*class="([^"]*)"')
	classes = mw.text.split(classes, ' ')
	local hasClass = false
	for _, actualClass in ipairs(classes) do
		if actualClass == expectedClass then
			hasClass = true
			break
		end
	end
	self:assertTrue(
		hasClass,
		string.format(
			'Class "%s" %s in result "%s"',
			expectedClass,
			hasClass and "found" or "not found",
			result
		)
	)
end

--------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------

function suite:testWholeOutput()
	self:assertEquals(
		[=[<div role="note" class="hatnote navigation-not-searchable">bài viết chính của [[Help:Thể loại|thể loại]] này là '''[[:Foo]]'''.</div>]=],
		mw.text.killMarkers(mCatMain._catMain(nil, 'Foo'))
	)
end

function suite:testOneArticle()
	self:assertStringContains(
		"bài viết chính của [[Help:Thể loại|thể loại]] này là '''[[:Foo]]'''.",
		mCatMain._catMain(nil, 'Foo'),
		true
	)
end

function suite:testTwoArticles()
	self:assertStringContains(
		"bài viết chính của [[Help:Thể loại|thể loại]] này là '''[[:Foo]]''' '''[[:Foo]]''' and '''[[:Bar]]'''.",
		mCatMain._catMain(nil, 'Foo', 'Bar'),
		true
	)
end

function suite:testThreeArticles()
	self:assertStringContains(
		"bài viết chính của [[Help:Thể loại|thể loại]] này là '''[[:Foo]]''' '''[[:Foo]]''', '''[[:Bar]]''' and '''[[:Baz]]'''.",
		mCatMain._catMain(nil, 'Foo', 'Bar', 'Baz'),
		true
	)
end

function suite:testNonArticle()
	self:assertStringContains(
		"bài viết chính của [[Help:Thể loại|thể loại]] này là '''[[:Foo]]'''",
		mCatMain._catMain({article = false}, 'Foo'),
		true
	)
end

function suite:testSelfReference()
	self:assertHasClass("selfref", mCatMain._catMain({selfref = true}, 'Foo'))
end

function suite:testNoArticles()
	patchCurrentTitle(
		"Category:Example",
		function ()
			self:assertStringContains(
				"bài viết chính của [[Help:Thể loại|thể loại]] này là '''[[Example]]'''",
				mCatMain._catMain(),
				true
			)
		end
	)
end

return suite
