-- Unit tests for [[Module:{{ROOTPAGENAME}}]]. Click talk page to run tests.
local p = require('Module:UnitTests')

-- Example unit test.
function p:test_hello()
	local includes = require('Module:Includes')

	-- These will return true
	self:equals('includes({"a", "b", "c", "d"}, "b")', includes({"a", "b", "c", "d"}, "b"), true)
	self:equals('includes({"a", "b", "c", "d"}, "b", 0)', includes({"a", "b", "c", "d"}, "b", 0), true)
	self:equals('includes({"a", "b", "c", "d"}, "b", 1)', includes({"a", "b", "c", "d"}, "b", 1), true)
	self:equals('includes({"a", "b", "c", "d"}, "b", 2)', includes({"a", "b", "c", "d"}, "b", 2), true)
	self:equals('includes({"a", "b", "c", "d"}, "b", -3)', includes({"a", "b", "c", "d"}, "b", -3), true)
	self:equals('includes({"a", "b", "c", "d"}, "b", -5)', includes({"a", "b", "c", "d"}, "b", -5), true)
	self:equals('includes({[1] = "a",[100] = "b",[101] = "c"}, "b")', includes({[1] = "a",[100] = "b",[101] = "c"}, "b"), true)
	self:equals('includes({[1] = "a",[2] = "b",[3] = "c"}, "b", 0)', includes({[1] = "a",[2] = "b",[3] = "c"}, "b", 0), true)
	self:equals('includes({first = "a", second = "b", third = "c"}, "b")', includes({first = "a", second = "b", third = "c"}, "b"), true)
	
	--these will return false
	self:equals('includes("b","b")', includes("b","b"), false) -- array is not a table
	self:equals('includes({"a", "b", "c", "d"})', includes({"a", "b", "c", "d"}), false) -- value missing
	self:equals('includes({"a", "b", "c", "d"}, "e")', includes({"a", "b", "c", "d"}, "e"), false) -- "e" is not in array
	self:equals('includes({"a", "b", "c", "d"}, "b", 3)', includes({"a", "b", "c", "d"}, "b", 3), false) -- "b" is before position 3
	self:equals('includes({"a", "b", "c", "d"}, "b", 5)', includes({"a", "b", "c", "d"}, "b", 5), false) -- 5 is larger than #array
	self:equals('includes({"a", "b", "c", "d"}, "b", -2)', includes({"a", "b", "c", "d"}, "b", -2), false) -- "b" is not in the last two positions
	self:equals('includes({[1] = "a", [100] = "b", [101] = "c"}, "b", 0)', includes({[1] = "a", [100] = "b", [101] = "c"}, "b", 0), false) -- key 100 is non-consecutive
	self:equals('includes({first = "a", second = "b", third = "c"}, "b", 0)', includes({first = "a", second = "b", third = "c"}, "b", 0), false) -- key "second" is not an integer
end

return p
