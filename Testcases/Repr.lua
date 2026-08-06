-- Load necessary modules
local mRepr = require('Module:Repr')
local ScribuntoUnit = require('Module:ScribuntoUnit')

-- Initialise test suite
local suite = ScribuntoUnit:new()

--------------------------------------------------------------------------------
-- isLuaIdentifier tests
--------------------------------------------------------------------------------

local isLuaIdentifierTestData = {
	{
		testName = "testIsLuaIdentifier_containingLowerCaseCharacters_isTrue",
		value = "foo",
		expected = true,
	},
	{
		testName = "testIsLuaIdentifier_containingUpperCaseCharacters_isTrue",
		value = "FOO",
		expected = true,
	},
	{
		testName = "testIsLuaIdentifier_containingDigitsAfterFirstPosition_isTrue",
		value = "test1",
		expected = true,
	},
	{
		testName = "testIsLuaIdentifier_containingUnderscores_isTrue",
		value = "foo_bar",
		expected = true,
	},
	{
		testName = "testIsLuaIdentifier_nonString_isFalse",
		value = 6,
		expected = false,
	},
	{
		testName = "testIsLuaIdentifier_emptyString_isFalse",
		value = "",
		expected = false,
	},
	{
		testName = "testIsLuaIdentifier_startingWithNumber_isFalse",
		value = "1foo",
		expected = false,
	},
	{
		testName = "testIsLuaIdentifier_containingMultibyteCharacter_isFalse",
		value = "föo",
		expected = false,
	},
	{
		testName = "testIsLuaIdentifier_containingPeriod_isFalse",
		value = "a1.2",
		expected = false,
	},
	{
		testName = "testIsLuaIdentifier_containingHyphen_isFalse",
		value = "foo-bar",
		expected = false,
	},
}

for _, testData in ipairs(isLuaIdentifierTestData) do
	suite[testData.testName] = function(self)
		local result = mRepr._isLuaIdentifier(testData.value)
		self:assertEquals(testData.expected, result)
	end
end

local luaKeywords = {
	"and",
	"break",
	"do",
	"else",
	"elseif",
	"end",
	"false",
	"for",
	"function",
	"if",
	"in",
	"local",
	"nil",
	"not",
	"or",
	"repeat",
	"return",
	"then",
	"true",
	"until",
	"while",
}

for _, keyword in ipairs(luaKeywords) do
	suite["testIsLuaIdentifier_keyword_" .. keyword .. '_isFalse'] = function(self)
		self:assertFalse(mRepr._isLuaIdentifier(keyword))
	end
end

--------------------------------------------------------------------------------
-- repr tests
--------------------------------------------------------------------------------

local TABLE_WITH_IDENTIFIER_KEYS = {e = "eee", c = "ccc", a = "aaa", d = "ddd", b = "bbb"}
local TABLE_WITH_IDENTIFIER_KEYS_SORTED_REPR = '{a = "aaa", b = "bbb", c = "ccc", d = "ddd", e = "eee"}'

local CYCLIC_SEQUENCE = {1, 2, 3}
table.insert(CYCLIC_SEQUENCE, CYCLIC_SEQUENCE)
local CYCLIC_SEQUENCE_REPR = '{1, 2, 3, {CYCLIC}}'

local CYCLIC_TABLE = {a = "aaa"}
CYCLIC_TABLE.b= CYCLIC_TABLE
local CYCLIC_TABLE_REPR = '{a = "aaa", b = {CYCLIC}}'

local CYCLIC_TABLE_PAIR = {a = "aaa", b = {c = "ccc"}}
CYCLIC_TABLE_PAIR.b.d = CYCLIC_TABLE_PAIR
local CYCLIC_TABLE_PAIR_REPR = '{a = "aaa", b = {c = "ccc", d = {CYCLIC}}}'

local SUBTABLE = {foo = "bar"}
local TABLE_WITH_SHARED_SUBTABLES = {a = SUBTABLE, b = SUBTABLE}
local TABLE_WITH_SHARED_SUBTABLES_REPR = '{a = {foo = "bar"}, b = {foo = "bar"}}'

local TOSTRING_METAMETHOD_TABLE_REPR = '<my table>'
local TOSTRING_METATABLE = 	{
	__tostring = function (t)
		return TOSTRING_METAMETHOD_TABLE_REPR
	end	
}
local TOSTRING_METAMETHOD_TABLE = setmetatable({}, TOSTRING_METATABLE)
local TOSTRING_METATABLE_REPR = '{__tostring = <function>}'

local NESTED_TABLE = {a = "aaa", b = {c = "ccc"}}

local reprTestData = {
	{
		testName = "testRepr_nil",
		args = {nil, {}},
		expected = 'nil',
	},
	{
		testName = "testRepr_true",
		args = {true, {}},
		expected = 'true',
	},
	{
		testName = "testRepr_false",
		args = {false, {}},
		expected = 'false',
	},
	{
		testName = "testRepr_integer",
		args = {7, {}},
		expected = '7',
	},
	{
		testName = "testRepr_float",
		args = {3.14159, {}},
		expected = '3.14159',
	},
	{
		testName = "testRepr_largeInt",
		args = {12345678901234567890, {}},
		expected = '1.2345678901235e+19',
	},
	{
		testName = "testRepr_positiveInfinity",
		args = {math.huge, {}},
		expected = 'math.huge',
	},
	{
		testName = "testRepr_negativeInfinity",
		args = {-math.huge, {}},
		expected = '-math.huge',
	},
	{
		testName = "testRepr_NaN",
		args = {0/0, {}},
		expected = '-nan',
	},
	{
		testName = "testRepr_emptyString",
		args = {"", {}},
		expected = '""',
	},
	{
		testName = "testRepr_normalString",
		args = {"foo", {}},
		expected = '"foo"',
	},
	{
		testName = "testRepr_stringWithQuotes",
		args = {'"foo"', {}},
		expected = '"\\"foo\\""',
	},
	{
		testName = "testRepr_stringWithNewline",
		args = {'foo\nbar', {}},
		expected = '"foo\\nbar"',
	},
	{
		testName = "testRepr_emptyTable",
		args = {{}, {}},
		expected = '{}',
	},
	{
		testName = "testRepr_sequenceWithSimpleValues",
		args = {{1, "foo", true}, {}},
		expected = '{1, "foo", true}',
	},
	{
		testName = "testRepr_sparseSequence",
		args = {{1, nil, 3, nil, 5}, {}},
		expected = '{1, [3] = 3, [5] = 5}',
	},
	{
		testName = "testRepr_mixedSequenceAndKeys",
		args = {{1, 2, 3, foo = "bar"}, {}},
		expected = '{1, 2, 3, foo = "bar"}',
	},
	{
		testName = "testRepr_tableWithZeroKey",
		args = {{[0] = 0}, {}},
		expected = '{[0] = 0}',
	},
	{
		testName = "testRepr_tableWithNegativeIntegerKey",
		args = {{[-1] = -1}, {}},
		expected = '{[-1] = -1}',
	},
	{
		testName = "testRepr_tableWithFloatKeys",
		args = {{[3.14159] = "pi"}, {}},
		expected = '{[3.14159] = "pi"}',
	},
	{
		testName = "testRepr_tableWithHugeKey",
		args = {{[math.huge] = "huge"}, {}},
		expected = '{[math.huge] = "huge"}',
	},
	{
		testName = "testRepr_tableWithEmptyStringKey",
		args = {{[""] = "empty"}, {}},
		expected = '{[""] = "empty"}',
	},
	{
		testName = "testRepr_tableWithIdentifierKeys",
		args = {{a = "b", c = "d"}, {}},
		expected = '{a = "b", c = "d"}',
	},
	{
		testName = "testRepr_tableWithStringKeysStartingWithNumbers",
		args = {{["1foo"] = "foo", ["2bar"] = "bar"}, {}},
		expected = '{["1foo"] = "foo", ["2bar"] = "bar"}',
	},
	{
		testName = "testRepr_tableWithStringKeysContainingMultibyteCharacters",
		args = {{["föo"] = "bâr"}, {}},
		expected = '{["föo"] = "bâr"}',
	},
	{
		testName = "testRepr_tableWithLuaKeywordKey",
		args = {{["break"] = "break"}, {}},
		expected = '{["break"] = "break"}',
	},
	{
		testName = "testRepr_tableWithBooleanKey",
		args = {{[true] = "the truth"}, {}},
		expected = '{[true] = "the truth"}',
	},
	{
		testName = "testRepr_tableWithEmptyTableKey",
		args = {{[{}] = "a table"}, {}},
		expected = '{[{}] = "a table"}',
	},
	{
		testName = "testRepr_nestedSequence",
		args = {{1, 2, {3, 4, {5}}}, {}},
		expected = '{1, 2, {3, 4, {5}}}',
	},
	{
		testName = "testRepr_nestedTableWithIdentifierKeys",
		args = {{a = {b = {c = "d"}}}, {}},
		expected = '{a = {b = {c = "d"}}}',
	},
	{
		testName = "testRepr_tableWithNestedTableKey",
		args = {{[{a = {b = "b"}}] = "value"}, {}},
		expected = '{[{a = {b = "b"}}] = "value"}',
	},
	{
		testName = "testRepr_sequenceKey",
		args = {{[{1, 2, 3}] = 6}, {}},
		expected = '{[{1, 2, 3}] = 6}',
	},
	{
		testName = "testRepr_cyclicSequence",
		args = {CYCLIC_SEQUENCE, {}},
		expected = CYCLIC_SEQUENCE_REPR,
	},
	{
		testName = "testRepr_cyclicTable",
		args = {CYCLIC_TABLE, {}},
		expected = CYCLIC_TABLE_REPR,
	},
	{
		testName = "testRepr_cyclicTablePair",
		args = {CYCLIC_TABLE_PAIR, {}},
		expected = CYCLIC_TABLE_PAIR_REPR,
	},
	{
		testName = "testRepr_tableWithSharedSubtables",
		args = {TABLE_WITH_SHARED_SUBTABLES, {}},
		expected = TABLE_WITH_SHARED_SUBTABLES_REPR,
	},
	{
		testName = "testRepr_tableWithToStringMethod",
		args = {TOSTRING_METATABLE, {}},
		expected = TOSTRING_METATABLE_REPR,
	},
	{
		testName = "testRepr_tableWithToStringMetamethod",
		args = {TOSTRING_METAMETHOD_TABLE, {}},
		expected = TOSTRING_METAMETHOD_TABLE_REPR,
	},
	{
		testName = "testRepr_function",
		args = {function () end, {}},
		expected = '<function>',
	},
	{
		testName = "testRepr_tableKeySorting_withExplicitSetting",
		args = {TABLE_WITH_IDENTIFIER_KEYS, {sortKeys=true}},
		expected = TABLE_WITH_IDENTIFIER_KEYS_SORTED_REPR,
	},
	{
		testName = "testRepr_tableKeySorting_withDefaultSetting",
		args = {TABLE_WITH_IDENTIFIER_KEYS},
		expected = TABLE_WITH_IDENTIFIER_KEYS_SORTED_REPR,
	},
	{
		testName = "testRepr_tableKeySorting_withInheritedSetting",
		args = {TABLE_WITH_IDENTIFIER_KEYS, {}},
		expected = TABLE_WITH_IDENTIFIER_KEYS_SORTED_REPR,
	},
	{
		testName = "testRepr_prettyPrint_withDefaultSettings",
		args = {NESTED_TABLE, {pretty = true}},
		expected = [[
{
	a = "aaa",
	b = {
		c = "ccc"
	}
}]],
	},
	{
		testName = "testRepr_prettyPrint_withDefaultSpaces",
		args = {NESTED_TABLE, {pretty = true, tabs = false}},
		expected = [[
{
    a = "aaa",
    b = {
        c = "ccc"
    }
}]],
	},
	{
		testName = "testRepr_prettyPrint_withTwoSpaces",
		args = {NESTED_TABLE, {pretty = true, spaces = 2, tabs = false}},
		expected = [[
{
  a = "aaa",
  b = {
    c = "ccc"
  }
}]],
	},
	{
		testName = "testRepr_prettyPrint_withSemicolons",
		args = {NESTED_TABLE, {pretty = true, semicolons = true}},
		expected = [[
{
	a = "aaa";
	b = {
		c = "ccc"
	}
}]],
	},
	{
		testName = "testRepr_prettyPrint_withDepthOf1",
		args = {NESTED_TABLE, {pretty = true, depth = 1}},
		expected = [[{
		a = "aaa",
		b = {
			c = "ccc"
		}
	}]],
	},
	{
		testName = "testRepr_prettyPrint_withNestedTableKey",
		args = {{[{a = "aaa", b = "bbb"}] = "ccc"}, {pretty = true}},
		expected = [[
{
	[{
		a = "aaa",
		b = "bbb"
	}] = "ccc"
}]],
	},
	{
		testName = "testRepr_nestedTable_withSemicolons",
		args = {NESTED_TABLE, {semicolons = true}},
		expected = '{a = "aaa"; b = {c = "ccc"}}',
	},
}

for _, testData in ipairs(reprTestData) do
	suite[testData.testName] = function(self)
		local result = mRepr.repr(unpack(testData.args))
		self:assertEquals(testData.expected, result)
	end
end

--------------------------------------------------------------------------------
-- invocationRepr tests
--------------------------------------------------------------------------------

local invocationReprTestData = {
	{
		testName = "testInvocationRepr_nameOnly",
		args = {
			funcName = "foo.bar",
			args = {},
			options = {},
		},
		expected = "foo.bar()",
	},
	{
		testName = "testInvocationRepr_nameOnly_withNilArgsAndOptions",
		args = {
			funcName = "foo.bar",
		},
		expected = "foo.bar()",
	},
	{
		testName = "testInvocationRepr_withSimpleArguments",
		args = {
			funcName = "myFunc",
			args = {1, "foo", true},
			options = {},
		},
		expected = 'myFunc(1, "foo", true)',
	},
	{
		testName = "testInvocationRepr_withTableArguments",
		args = {
			funcName = "myFunc",
			args = {{foo = "bar"}, {["123"] = "456"}},
			options = {},
		},
		expected = 'myFunc({foo = "bar"}, {["123"] = "456"})',
	},
	{
		testName = "testInvocationRepr_withNestedTableArgument",
		args = {
			funcName = "myFunc",
			args = {{a = {b = "bbb"}}},
			options = {},
		},
		expected = 'myFunc({a = {b = "bbb"}})',
	},
	{
		testName = "testInvocationRepr_withNestedTableArgument_prettyPrinted",
		args = {
			funcName = "myFunc",
			args = {{a = "aaa", b = {c = "ccc"}}},
			options = {pretty = true},
		},
		expected = [[
myFunc(
	{
		a = "aaa",
		b = {
			c = "ccc"
		}
	}
)]],
	},
	{
		testName = "testInvocationRepr_withNestedTableArgument_prettyPrintedWithDepthOf1",
		args = {
			funcName = "myFunc",
			args = {{a = "aaa", b = {c = "ccc"}}},
			options = {pretty = true, depth = 1},
		},
		expected = [[myFunc(
		{
			a = "aaa",
			b = {
				c = "ccc"
			}
		}
	)]],
	},
}

for _, testData in ipairs(invocationReprTestData) do
	suite[testData.testName] = function(self)
		local result = mRepr.invocationRepr(testData.args)
		self:assertEquals(testData.expected, result)
	end
end

return suite