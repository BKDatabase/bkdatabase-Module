local main = require('Module:Category pair') -- the module to be tested
local sandbox = require('Module:Category pair/sandbox')
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

local function makeCat(s)
	return mw.title.new(s,"Category")
end

function suite:inner(catPair)
	self:assertStringContains(
		"Xem thêm thể loại trước [[:Thể loại:X1]] và thể loại sau [[:Thể loại:X2]]",
		catPair._pair(makeCat("X1"),makeCat("X2")),
		true,"Pair exists failure")
	self:assertStringContains(
		"seealso",
		catPair._pair(makeCat("X1"),makeCat("X2")),
		true,"Missing seealso class")
	self:assertStringContains(
		"Xem thêm thể loại trước [[:Thể loại:X1]]",
		catPair._pair(makeCat("X1"),nil),
		true,"Preceding exists failure")
	self:assertStringContains(
		"Xem thêm thể loại sau [[:Thể loại:X3]]",
		catPair._pair(nil,makeCat("X3")),
		true,"Succeeding exists failure")
	self:assertStringContains(
		"Xem thêm thể loại trước [[:Thể loại:X1]] và thể loại sau [[:Thể loại:X2]]",
		catPair._pair(makeCat("X1"),makeCat("X2")),
		true,"Only preceding exists failure")
	self:assertStringContains(
		"Xem thêm thể loại trước [[:Thể loại:X1]] và thể loại sau [[:Thể loại:X2]]",
		catPair._pair(makeCat("X1"),makeCat("X2")),
		true,"Succeeding exists failure")
	self:assertEquals(catPair._pair(makeCat("X7"),makeCat("X8")),"",
		"Both missing failure")
end

function suite:testMain()
	self:inner(main)
end

function suite:testSandbox()
	self:inner(sandbox)
end

return suite
