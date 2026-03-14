local getArgs = require('Module:Arguments/sandbox').getArgs
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

--------------------------------------------------------------------------
-- Default values
--------------------------------------------------------------------------

local d = {} 
d.frameTitle = 'Frame title'
d.parentTitle = 'Parent title'

-- Precedence-testing values
d.firstFrameArg = 'first frame argument'
d.firstParentArg = 'first parent argument'
d.secondParentArg = 'second parent argument'
d.uniqueFrameArg = 'unique frame argument'
d.uniqueFrameArgKey = 'uniqueFrameArgKey'
d.uniqueParentArg = 'unique parent argument'
d.uniqueParentArgKey = 'uniqueParentArgKey'

-- Trimming and whitespace values.
-- Whitespace gets trimmed from named parameters, so keys for these need
-- to be numbers to make this a proper test.
d.blankArg = ''
d.blankArgKey = 100 
d.spacesArg = '\n   '
d.spacesArgKey = 101
d.untrimmedArg = '\n   foo bar   '
d.untrimmedArgKey = 102
d.trimmedArg = 'foo bar'
d.valueFuncValue = 'valueFuncValue'
d.defaultValueFunc = function() return d.valueFuncValue end
d.translate = {
	foo = 'F00',
	bar = '8@r',
	baz = '8@z',
	qux = 'qUx'
}

--------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------

function suite.getFrames(frameTitle, frameArgs, parentTitle, parentArgs)
	frameTitle = frameTitle or d.frameTitle
	frameArgs = frameArgs or {
		d.firstFrameArg,
		[d.uniqueFrameArgKey] = d.uniqueFrameArg,
		[d.blankArgKey] = d.blankArg,
		[d.spacesArgKey] = d.spacesArg,
		[d.untrimmedArgKey] = d.untrimmedArg
	}
	parentTitle = parentTitle or d.parentTitle
	parentArgs = parentArgs or {
		d.firstParentArg,
		d.secondParentArg,
		[d.uniqueParentArgKey] = d.uniqueParentArg
	}
	local currentFrame = mw.getCurrentFrame()
	local parent = currentFrame:newChild{title = parentTitle, args = parentArgs}
	local frame = parent:newChild{title = frameTitle, args = frameArgs}
	return frame, parent
end

function suite.getDefaultArgs(options, frameTitle, frameArgs, parentTitle, parentArgs)
	local frame, parent = suite.getFrames(frameTitle, frameArgs, parentTitle, parentArgs)
	local args = getArgs(frame, options)
	return args
end

function suite:assertError(func, ...)
	-- Asserts that executing the function func results in an error.
	-- Parameters after func are func's arguments.
	local success, msg = pcall(func, ...)
	self:assertFalse(success)
end

function suite:assertNumberOfIterations(expected, iterator, t)
	local noIterations = 0
	for k, v in iterator(t) do
		noIterations = noIterations + 1
	end
	self:assertEquals(expected, noIterations)
end

--------------------------------------------------------------------------
-- Test precedence
--------------------------------------------------------------------------

function suite:assertDefaultPrecedence(args)
	self:assertEquals(d.firstFrameArg, args[1])
	self:assertEquals(d.secondParentArg, args[2])
	self:assertEquals(d.uniqueFrameArg, args[d.uniqueFrameArgKey])
	self:assertEquals(d.uniqueParentArg, args[d.uniqueParentArgKey])
end

function suite:testDefaultPrecedence()
	self:assertDefaultPrecedence(suite.getDefaultArgs())
end

function suite:testDefaultPrecedenceThroughWrapper()
	self:assertDefaultPrecedence(suite.getDefaultArgs{wrappers = {d.parentTitle}, parentOnly = false})
end

function suite:testDefaultPrecedenceThroughNonWrapper()
	self:assertDefaultPrecedence(suite.getDefaultArgs({wrappers = d.parentTitle, frameOnly = false}, nil, nil, 'Not the parent title'))
end

function suite:assertParentFirst(args)
	self:assertEquals(d.firstParentArg, args[1])
	self:assertEquals(d.secondParentArg, args[2])
	self:assertEquals(d.uniqueFrameArg, args[d.uniqueFrameArgKey])
	self:assertEquals(d.uniqueParentArg, args[d.uniqueParentArgKey])
end

function suite:testParentFirst()
	self:assertParentFirst(suite.getDefaultArgs{parentFirst = true})
end

function suite:testParentFirstThroughWrapper()
	self:assertParentFirst(suite.getDefaultArgs{wrappers = {d.parentTitle}, parentOnly = false, parentFirst = true})
end

function suite:testParentFirstThroughNonWrapper()
	self:assertParentFirst(suite.getDefaultArgs({wrappers = d.parentTitle, frameOnly = false, parentFirst = true}, nil, nil, 'Not the parent title'))
end

function suite:assertParentOnly(args)
	self:assertEquals(d.firstParentArg, args[1])
	self:assertEquals(d.secondParentArg, args[2])
	self:assertEquals(nil, args[d.uniqueFrameArgKey])
	self:assertEquals(d.uniqueParentArg, args[d.uniqueParentArgKey])
end

function suite:testParentOnly()
	self:assertParentOnly(suite.getDefaultArgs{parentOnly = true})
end

function suite:testParentOnlyThroughWrapper()
	self:assertParentOnly(suite.getDefaultArgs{wrappers = {d.parentTitle}})
end

function suite:testParentOnlyThroughSandboxWrapper()
	self:assertParentOnly(suite.getDefaultArgs({wrappers = d.parentTitle}, nil, nil, d.parentTitle .. '/sandbox'))
end

function suite:assertFrameOnly(args)
	self:assertEquals(d.firstFrameArg, args[1])
	self:assertEquals(nil, args[2])
	self:assertEquals(d.uniqueFrameArg, args[d.uniqueFrameArgKey])
	self:assertEquals(nil, args[d.uniqueParentArgKey])
end

function suite:testFrameOnly()
	self:assertFrameOnly(suite.getDefaultArgs{frameOnly = true})
end

function suite:testFrameOnlyThroughNonWrapper()
	self:assertFrameOnly(suite.getDefaultArgs({wrappers = d.parentTitle}, nil, nil, 'Not the parent title'))
end

function suite:testDefaultPrecedenceWithWhitespace()
	local frame, parent = suite.getFrames(
		d.frameTitle,
		{'  '},
		d.parentTitle,
		{d.firstParentArg}
	)
	local args = getArgs(frame)
	self:assertEquals(d.firstParentArg, args[1])
end

--------------------------------------------------------------------------
-- Test trimming and blank removal
--------------------------------------------------------------------------

function suite:testDefaultTrimmingAndBlankRemoval()
	local args = suite.getDefaultArgs()
	self:assertEquals(nil, args[d.blankArgKey])
	self:assertEquals(nil, args[d.spacesArgKey])
	self:assertEquals(d.trimmedArg, args[d.untrimmedArgKey])
end

function suite:testRemoveBlanksButNoTrimming()
	local args = suite.getDefaultArgs{trim = false}
	self:assertEquals(nil, args[d.blankArgKey])
	self:assertEquals(nil, args[d.spacesArgKey])
	self:assertEquals(d.untrimmedArg, args[d.untrimmedArgKey])
end

function suite:testTrimButNoBlankRemoval()
	local args = suite.getDefaultArgs{removeBlanks = false}
	self:assertEquals(d.blankArg, args[d.blankArgKey])
	self:assertEquals('', args[d.spacesArgKey])
	self:assertEquals(d.trimmedArg, args[d.untrimmedArgKey])
end

function suite:testNoTrimOrBlankRemoval()
	local args = suite.getDefaultArgs{trim = false, removeBlanks = false}
	self:assertEquals(d.blankArg, args[d.blankArgKey])
	self:assertEquals(d.spacesArg, args[d.spacesArgKey])
	self:assertEquals(d.untrimmedArg, args[d.untrimmedArgKey])
end

--------------------------------------------------------------------------
-- Test valueFunc
--------------------------------------------------------------------------

function suite:testValueFunc()
	local args = suite.getDefaultArgs{valueFunc = d.defaultValueFunc}
	self:assertEquals(d.valueFuncValue, args['some random key: sdfaliwyda'])
end

function suite:testValueFuncPrecedence()
	local args = suite.getDefaultArgs{
		trim = false,
		removeBlanks = false,
		valueFunc = d.defaultValueFunc
	}
	self:assertEquals(d.valueFuncValue, args[1])
	self:assertEquals(d.valueFuncValue, args['some random key: gekjabawyvy'])
end

function suite:testValueFuncKey()
	local args = suite.getDefaultArgs{valueFunc = function(key, value)
		return 'valueFunc key: '.. key
	end}
	self:assertEquals('valueFunc key: foo', args.foo)
end

function suite:testValueFuncValue()
	local args = suite.getDefaultArgs{valueFunc = function(key, value)
		return 'valueFunc value: '.. value
	end}
	self:assertEquals(
		'valueFunc value: ' .. d.uniqueFrameArg,
		args[d.uniqueFrameArgKey]
	)
end

--------------------------------------------------------------------------
-- Test adding new arguments
--------------------------------------------------------------------------

function suite:testAddingNewArgs()
	local args = suite.getDefaultArgs()
	self:assertEquals(nil, args.newKey)
	args.newKey = 'some new key'
	self:assertEquals('some new key', args.newKey)
end

function suite:testAddingNewBlankArgs()
	local args = suite.getDefaultArgs()
	self:assertEquals(nil, args.newKey)
	args.newKey = ''
	self:assertEquals('', args.newKey)
end

function suite:testAddingNewSpacesArgs()
	local args = suite.getDefaultArgs()
	self:assertEquals(nil, args.newKey)
	args.newKey = ' '
	self:assertEquals(' ', args.newKey)
end

function suite:testOverwriting()
	local args = suite.getDefaultArgs()
	self:assertEquals(d.firstFrameArg, args[1])
	args[1] = 'a new first frame argument'
	self:assertEquals('a new first frame argument', args[1])
end

function suite:testOverwritingWithNil()
	local args = suite.getDefaultArgs()
	self:assertEquals(d.firstFrameArg, args[1])
	args[1] = nil
	self:assertEquals(nil, args[1])
end

function suite:testOverwritingWithBlank()
	local args = suite.getDefaultArgs()
	self:assertEquals(d.firstFrameArg, args[1])
	args[1] = ''
	self:assertEquals('', args[1])
end

function suite:testOverwritingWithSpaces()
	local args = suite.getDefaultArgs()
	self:assertEquals(d.firstFrameArg, args[1])
	args[1] = ' '
	self:assertEquals(' ', args[1])
end

function suite:testReadOnly()
	local args = suite.getDefaultArgs{readOnly = true}
	local function testFunc()
		args.newKey = 'some new value'
	end
	self:assertError(testFunc)
end

function suite:testNoOverwriteExistingKey()
	local args = suite.getDefaultArgs{noOverwrite = true}
	self:assertEquals(d.firstFrameArg, args[1])
	local function testFunc()
		args[1] = 'a new first frame argument'
	end
	self:assertError(testFunc)
end

function suite:testNoOverwriteNewKey()
	local args = suite.getDefaultArgs{noOverwrite = true}
	self:assertEquals(nil, args.newKey)
	args.newKey = 'some new value'
	self:assertEquals('some new value', args.newKey)
end

--------------------------------------------------------------------------
-- Test bad input
--------------------------------------------------------------------------

function suite:testBadFrameInput()
	self:assertError(getArgs, 'foo')
	self:assertError(getArgs, 9)
	self:assertError(getArgs, true)
	self:assertError(getArgs, function() return true end)
end

function suite:testBadOptionsInput()
	self:assertError(getArgs, {}, 'foo')
	self:assertError(getArgs, {}, 9)
	self:assertError(getArgs, {}, true)
	self:assertError(getArgs, {}, function() return true end)
end

function suite:testBadValueFuncInput()
	self:assertError(getArgs, {}, {valueFunc = 'foo'})
	self:assertError(getArgs, {}, {valueFunc = 9})
	self:assertError(getArgs, {}, {valueFunc = true})
	self:assertError(getArgs, {}, {valueFunc = {}})
end

--------------------------------------------------------------------------
-- Test iterator metamethods
--------------------------------------------------------------------------

function suite:testPairs()
	local args = getArgs{'foo', 'bar', baz = 'qux'}
	self:assertNumberOfIterations(3, pairs, args)
end

function suite:testIpairs()
	local args = getArgs{'foo', 'bar', baz = 'qux'}
	self:assertNumberOfIterations(2, ipairs, args)
end

function suite:testNoNilsinPairs()
	-- Test that when we use pairs, we don't iterate over any nil values
	-- that have been memoized.
	local args = getArgs{''}
	local temp = args[1] -- Memoizes the nil
	self:assertNumberOfIterations(0, pairs, args)
end

function suite:testNoNilsinIpairs()
	-- Test that when we use ipairs, we don't iterate over any nil values
	-- that have been memoized.
	local args = getArgs{''}
	local temp = args[1] -- Memoizes the nil
	self:assertNumberOfIterations(0, ipairs, args)
end

function suite:testDeletedArgsInPairs()
	-- Test that when we use pairs, we don't iterate over any values that have
	-- been explicitly set to nil.
	local args = getArgs{'foo'}
	args[1] = nil
	self:assertNumberOfIterations(0, pairs, args)
end

function suite:testDeletedArgsInIpairs()
	-- Test that when we use ipairs, we don't iterate over any values that have
	-- been explicitly set to nil.
	local args = getArgs{'foo'}
	args[1] = nil
	self:assertNumberOfIterations(0, ipairs, args)
end

function suite:testNoNilsInPairsAfterIndex()
	-- Test that when we use pairs, we don't iterate over any nils that
	-- might have been memoized after a value that is not present in the
	-- original args table is indexed.
	local args = getArgs{}
	local temp = args.someRandomValue -- Memoizes the nil
	self:assertNumberOfIterations(0, pairs, args)
end

function suite:testNoNilsInPairsAfterNewindex()
	-- Test that when we use pairs, we don't iterate over any nils that
	-- might have been memoized after a value that is not present in the
	-- original args table is added to the args table.
	local args = getArgs{}
	args.newKey = nil -- The nil is memoized
	self:assertNumberOfIterations(0, pairs, args)
end

function suite:testNoTableLengthChangeWhileIterating()
	-- Test that the number of arguments doesn't change if we index the
	-- args table while iterating.
	-- (Note that the equivalent test is not needed for new arg table
	-- indexes, as that would be a user error - doing so produces
	-- undetermined behaviour in Lua's next() function.)
	local args = getArgs{'foo', 'bar', baz = 'qux'}
	self:assertNumberOfIterations(3, pairs, args)
	for k, v in pairs(args) do
		local temp = args[k .. 'foo']
	end
	self:assertNumberOfIterations(3, pairs, args)
end

function suite:testPairsPrecedenceWithWhitespace()
	local frame, parent = suite.getFrames(
		d.frameTitle,
		{'  '},
		d.parentTitle,
		{d.firstParentArg}
	)
	local args = getArgs(frame)
	local actual
	for k, v in pairs(args) do
		actual = v
	end
	self:assertEquals(d.firstParentArg, actual)
	-- Check that we have actually iterated.
	self:assertNumberOfIterations(1, pairs, args)
end

function suite:testPairsPrecedenceWithNil()
	local frame, parent = suite.getFrames(
		d.frameTitle,
		{},
		d.parentTitle,
		{d.firstParentArg}
	)
	local args = getArgs(frame)
	local actual
	for k, v in pairs(args) do
		actual = v
	end
	self:assertEquals(d.firstParentArg, actual)
	-- Check that we have actually iterated.
	self:assertNumberOfIterations(1, pairs, args)
end

function suite:testIpairsEarlyExit()
	local mt = {}
	function mt.__index(t, k)
		if k == 1 then
			return 'foo'
		elseif k == 2 then
			return 'bar'
		elseif k == 3 then
			error('Expanded argument 3 unnecessarily')
		end
	end
	function mt.__pairs(t)
		error('Called pairs unnecessarily')
	end
	function mt.__ipairs(t)
		-- Works just like the default ipairs, except respecting __index
		return function(t, i)
			local v = t[i + 1]
			if v ~= nil then
				return i + 1, v
			end
		end, t, 0
	end
	local args = getArgs(setmetatable({}, mt))
	for k,v in ipairs(args) do
		if v == 'bar' then
			break
		end
	end
end

--------------------------------------------------------------------------
-- Test argument translation
--------------------------------------------------------------------------

function suite:testTranslationIndex()
	local args = getArgs({F00 = 'one', ['8@r'] = 'two', ['8@z'] = 'three', qUx = 'four', foo = 'nope', untranslated = 'yep'}, {translate = d.translate})
	self:assertEquals('one', args.foo)
	self:assertEquals('two', args.bar)
	self:assertEquals('three', args.baz)
	self:assertEquals('four', args.qux)
	self:assertEquals('yep', args.untranslated)
end

function suite:testTranslationPairsWithAutoBacktranslate()
	local args = getArgs({F00 = 'one', ['8@r'] = 'two', ['8@z'] = 'three', qUx = 'four', foo = 'nope', untranslated = 'yep'}, {translate = d.translate})
	local cleanArgs = {}
	for k,v in pairs(args) do
		cleanArgs[k] = v
	end
	self:assertDeepEquals(
		{
			foo = 'one',
			bar = 'two',
			baz = 'three',
			qux = 'four',
			untranslated = 'yep'
		},
		cleanArgs
	)
end

function suite:testTranslationPairsWithBacktranslate()
	local args = getArgs({F00 = 'one', ['8@r'] = 'two', ['8@z'] = 'three', qUx = 'four', foo = 'nope', untranslated = 'yep'}, {translate = d.translate, backtranslate = {F00 = 'foo'}})
	local cleanArgs = {}
	for k,v in pairs(args) do
		cleanArgs[k] = v
	end
	self:assertDeepEquals(
		{
			foo = 'one',
			['8@r'] = 'two',
			['8@z'] = 'three',
			qUx = 'four',
			untranslated = 'yep'
		},
		cleanArgs
	)
end

function suite:testTranslationPairsWithoutBacktranslate()
	local args = getArgs({F00 = 'one', ['8@r'] = 'two', ['8@z'] = 'three', qUx = 'four', foo = 'nope', untranslated = 'yep'}, {translate = d.translate, backtranslate = false})
	local cleanArgs = {}
	for k,v in pairs(args) do
		cleanArgs[k] = v
	end
	self:assertDeepEquals(
		{
			F00 = 'one',
			['8@r'] = 'two',
			['8@z'] = 'three',
			qUx = 'four',
			foo = 'nope',
			untranslated = 'yep'
		},
		cleanArgs
	)
end

function suite:testTranslationNewindex()
	local args = getArgs({F00 = 'one', ['8@r'] = 'two', ['8@z'] = 'three', qUx = 'four', foo = 'nope', untranslated = 'yep'}, {translate = d.translate, backtranslate = false})
	args.foo = 'changed1'
	args.untranslated = 'changed2'
	local cleanArgs = {}
	for k,v in pairs(args) do
		cleanArgs[k] = v
	end
	self:assertDeepEquals(
		{
			F00 = 'changed1',
			['8@r'] = 'two',
			['8@z'] = 'three',
			qUx = 'four',
			foo = 'nope',
			untranslated = 'changed2'
		},
		cleanArgs
	)
end

function suite:test_argument()
	local currentFrame = mw.getCurrentFrame()
	currentFrame.args[5] = 555;
	local args = getArgs(currentFrame)
	self:assertEquals('nil', type(args.foo))
end

return suite
