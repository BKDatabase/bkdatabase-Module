-- Unit tests for [[Module:File link]]. Click on the talk page to run the tests.

local mFileLink = require('Module:File link/sandbox')
local main = mFileLink.main
local _main = mFileLink._main
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------

function suite:assertError(func, ...)
	local success, result = pcall(func, ...)
	self:assertFalse(success)
end

function suite:assertNotError(func, ...)
	local success, result = pcall(func, ...)
	self:assertTrue(success)
end

function suite:assertPositionalParamExists(key)
	self:assertEquals(
		_main{file = 'Example.png', [key] = 'some value'},
		'[[File:Example.png|some value]]'
	)
end

function suite:assertNamedParamExists(key)
	self:assertEquals(
		_main{file = 'Example.png', [key] = 'some value'},
		'[[File:Example.png|' .. key .. '=some value]]'
	)
end

--------------------------------------------------------------------------------
-- Basic tests
--------------------------------------------------------------------------------

function suite:testBadInput()
	self:assertError(_main)
	self:assertError(_main, 'foo')
	self:assertError(_main, false)
end

function suite:testBadFile()
	self:assertError(_main, {})
	self:assertError(_main, {file = true})
	self:assertError(_main, {file = 123})
end

function suite:testFile()
	self:assertEquals(_main{file = 'Example.png'}, '[[File:Example.png]]')
end

--------------------------------------------------------------------------------
-- Positional parameters
--------------------------------------------------------------------------------

function suite:testFormat()
	self:assertPositionalParamExists('format')
end

function suite:testLocation()
	self:assertPositionalParamExists('location')
end

function suite:testAlignment()
	self:assertPositionalParamExists('alignment')
end

function suite:testSize()
	self:assertPositionalParamExists('size')
end

function suite:testCaption()
	self:assertPositionalParamExists('caption')
end

--------------------------------------------------------------------------------
-- Named parameters
--------------------------------------------------------------------------------

function suite:testUpright()
	self:assertNamedParamExists('upright')
end

function suite:testLink()
	self:assertNamedParamExists('link')
end

function suite:testAlt()
	self:assertNamedParamExists('alt')
end

function suite:testPage()
	self:assertNamedParamExists('page')
end

function suite:testClass()
	self:assertNamedParamExists('class')
end

function suite:testLang()
	self:assertNamedParamExists('lang')
end

function suite:testStart()
	self:assertNamedParamExists('start')
end

function suite:testEnd()
	self:assertNamedParamExists('end')
end

function suite:testThumbtime()
	self:assertNamedParamExists('thumbtime')
end

--------------------------------------------------------------------------------
-- Special parameters
--------------------------------------------------------------------------------

function suite:testBorder()
	self:assertEquals(
		_main{file = 'Example.png', border = true},
		'[[File:Example.png|border]]'
	)
	self:assertEquals(
		_main{file = 'Example.png', border = 'yes'},
		'[[File:Example.png|border]]'
	)
	self:assertEquals(
		_main{file = 'Example.png', border = 'y'},
		'[[File:Example.png|border]]'
	)
	self:assertEquals(
		_main{file = 'Example.png', border = 'YES'},
		'[[File:Example.png|border]]'
	)
end

function suite:testFormatfileWithFormat()
	self:assertEquals(
		_main{file = 'Example.png', format = 'a format', formatfile = 'foo'},
		'[[File:Example.png|a format=foo]]'
	)
end

function suite:testFormatfileWithoutFormat()
	self:assertEquals(
		_main{file = 'Example.png', formatfile = 'foo'},
		'[[File:Example.png]]'
	)
end

--------------------------------------------------------------------------------
-- Order
--------------------------------------------------------------------------------

function suite:testOrder()
	local params = {
		'file',
		'format',
		'formatfile',
		'border',
		'location',
		'alignment',
		'size',
		'upright',
		'link',
		'alt',
		'page',
		'class',
		'lang',
		'start',
		'end',
		'thumbtime',
		'caption'
	}
	local args = {}
	for i, param in ipairs(params) do
		args[param] = 'param ' .. i
	end
	args.border = true -- border is a special case
	local result = _main(args)

	-- Ugly hack to make border work whatever position it's in.
	local borderNum
	for i, v in ipairs(params) do
		if v == 'border' then
			borderNum = i
		end
	end
	result = result:gsub('border', 'param ' .. borderNum, 1)

	local i = 0
	for s in string.gmatch(result, 'param %d+') do
		i = i + 1
		suite:assertEquals(s, 'param ' .. i)
	end
end

return suite
