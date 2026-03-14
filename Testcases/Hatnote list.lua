local mHatnoteList = require('Module:Hatnote list/sandbox') -- the module to be tested
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

function suite:testAndList()
	self:assertEquals(
		"Foo, Bar, and Baz",
		mHatnoteList.andList({"Foo", "Bar", "Baz"})
	)
end

function suite:testOrList()
	self:assertEquals(
		"Foo, Bar, or Baz",
		mHatnoteList.orList({"Foo", "Bar", "Baz"})
	)
end

function suite:testForSee()
	self:assertEquals(
		"For Foo, see [[:Bar]]. For Baz, see [[:Qux]].",
		mHatnoteList._forSee({"Foo", "Bar", "Baz", "Qux"})
	)
end

function suite:testPunctuationCollapse()
	self:assertEquals(
		"For periods, see [[:Foo.]] and [[:Bar.]] " ..
			"For question marks, see [[:Baz?]] and [[:Qux?]] " ..
			"For exclamation marks, see [[:Oof!]] and [[:Rab!]]",
		mHatnoteList._forSee({
			"periods", "Foo.", "and", "Bar.",
			"question marks", "Baz?", "and", "Qux?",
			"exclamation marks", "Oof!", "and", "Rab!"
		})
	)	
end

function suite:testPunctuationCollapseWithItalics()
	self:assertEquals(
		"For periods, see [[:Foo.|''Foo.'']] " ..
			"For question marks, see [[:Bar?|''Bar?'']] " ..
			"For exclamation marks, see [[:Baz!|''Baz!'']]",
		mHatnoteList._forSee({
			"periods", "Foo.|''Foo.''",
			"question marks", "Bar?|''Bar?''",
			"exclamation marks", "Baz!|''Baz!''"
		})
	)	
end

return suite
