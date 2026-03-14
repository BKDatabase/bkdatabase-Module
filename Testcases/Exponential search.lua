require[[strict]]
local search = require('Module:Exponential search')
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

local function makeTest(n)
	return function (i)
		return i <= n
	end
end

function suite:assertError(func, ...)
	local success, ret = pcall(func, ...)
	self:assertFalse(success)
	return ret
end

function suite:assertErrorMsg(msg, func, ...)
	local ret = self:assertError(func, ...)
	self:assertStringContains(msg, ret, true)
end

function suite:testFuncType()
	self:assertError(search, 5)
	self:assertError(search, 'foo')
	self:assertError(search, true)
	self:assertError(search, {})
	self:assertError(search, nil)
end

function suite:testInitType()
	self:assertError(search, makeTest(0), 'foo')
	self:assertError(search, makeTest(0), makeTest(0))
	self:assertError(search, makeTest(0), true)
	self:assertError(search, makeTest(0), {})
	self:assertError(search, makeTest(1), 'foo')
end
 
function suite:testInitIntegerCheck()
	self:assertErrorMsg(
		"invalid init value '0' detected in argument #2 to 'Exponential search' (init value must be a positive integer)",
		search, makeTest(0), 0
	)
	self:assertErrorMsg(
		"invalid init value '1.5' detected in argument #2 to 'Exponential search' (init value must be a positive integer)",
		search, makeTest(0), 1.5
	)
	self:assertErrorMsg(
		"invalid init value '-3' detected in argument #2 to 'Exponential search' (init value must be a positive integer)",
		search, makeTest(0), -3
	)
	self:assertErrorMsg(
		"invalid init value 'inf' detected in argument #2 to 'Exponential search' (init value must be a positive integer)",
		search, makeTest(0), math.huge
	)
	self:assertErrorMsg(
		"invalid init value '-nan' detected in argument #2 to 'Exponential search' (init value must be a positive integer)",
		search, makeTest(0), 0/0
	)
end

function suite:testKeyNotFound()
	self:assertEquals(nil, search(makeTest(0)))
end

function suite:testKeyNotFoundInit()
	self:assertEquals(nil, search(makeTest(0), 5))
end

function suite:test1()
	self:assertEquals(1, search(makeTest(1)))
end

function suite:test1Init1()
	self:assertEquals(1, search(makeTest(1), 1))
end

function suite:test1Init2()
	self:assertEquals(1, search(makeTest(1), 2))
end

function suite:test1Init3()
	self:assertEquals(1, search(makeTest(1), 3))
end

function suite:test2()
	self:assertEquals(2, search(makeTest(2)))
end

function suite:test2Init1()
	self:assertEquals(2, search(makeTest(2), 1))
end

function suite:test2Init2()
	self:assertEquals(2, search(makeTest(2), 2))
end

function suite:test2Init3()
	self:assertEquals(2, search(makeTest(2), 3))
end

function suite:test3()
	self:assertEquals(3, search(makeTest(3)))
end

function suite:test3Init1()
	self:assertEquals(3, search(makeTest(3), 1))
end

function suite:test3Init2()
	self:assertEquals(3, search(makeTest(3), 2))
end

function suite:test3Init3()
	self:assertEquals(3, search(makeTest(3), 3))
end

function suite:testLargeArray()
	self:assertEquals(1234567890, search(makeTest(1234567890)))
end

function suite:testLargeInit()
	self:assertEquals(3, search(makeTest(3), 1234567890))
end

return suite
