-- Unit tests for [[Module:IP]]. Click talk page to run tests.

-- Unit test module setup
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

-- Target module setup
local IP = require('Module:IP')
local IPAddress = IP.IPAddress
local Subnet = IP.Subnet
local IPv4Collection = IP.IPv4Collection
local IPv6Collection = IP.IPv6Collection

-- Constants
local IP_ADDRESS_CLASS = 'IPAddress'
local IP_ADDRESS_OBJECT = 'ipAddress'
local SUBNET_CLASS = 'Subnet'
local SUBNET_OBJECT = 'subnet'
local IPV4COLLECTION_CLASS = 'IPv4Collection'
local IPV4COLLECTION_OBJECT = 'ipv4Collection'
local IPV6COLLECTION_CLASS = 'IPv6Collection'
local IPV6COLLECTION_OBJECT = 'ipv6Collection'

-------------------------------------------------------------------------------
-- Helper methods
-------------------------------------------------------------------------------

function suite:assertError(message, plain, ...)
	local success, ret = pcall(...)
	self:assertFalse(success)
	self:assertStringContains(message, ret, plain)
end

function suite:assertNotError(...)
	local success = pcall(...)
	self:assertTrue(success)
end

function suite:assertSelfParameterError(class, objName, method, ...)
	local message = string.format(
		'IP: invalid %s object. Did you call %s with a dot instead of a colon, i.e. %s.%s() instead of %s:%s()?',
		class, method, objName, method, objName, method
	)
	self:assertError(message, true, ...)
end

function suite:assertTypeError(argIdx, funcName, expected, received, ...)
	local message = string.format(
		"bad argument #%d to '%s' (%s expected, got %s)",
		argIdx, funcName, expected, received
	)
	self:assertError(message, true, ...)
end

function suite:assertObjectError(argIdx, funcName, className, ...)
	local message = string.format(
		"bad argument #%d to '%s' (not a valid %s object)",
		argIdx, funcName, className
	)
	self:assertError(message, true, ...)
end

function suite:assertIPStringError(ipStr, ...)
	local message = string.format("'%s' is an invalid IP address", ipStr)
	self:assertError(message, true, ...)
end

function suite:assertCIDRStringError(cidr, ...)
	local message = string.format("'%s' is an invalid CIDR string", cidr)
	self:assertError(message, true, ...)
end

function suite:assertMetatableProtected(obj)
	self:assertError('cannot change a protected metatable', true, function ()
		setmetatable(obj, {})
	end)
end

function suite:assertNotMetatable(val)
	self:assertFalse(type(val) == 'table' and type(val.__eq) == 'function')
end

function suite:assertObject(val, ...)
	self:assertTrue(type(val) == 'table')
	for i, method in ipairs{...} do
		self:assertTrue(type(val[method]) == 'function')
	end
end

function suite:assertIPAddressObject(val)
	suite:assertObject(val, 'getIP', 'isInSubnet')
end

function suite:assertSubnetObject(val)
	suite:assertObject(val, 'getCIDR', 'containsIP')
end

function suite:assertCollectionObject(val)
	suite:assertObject(val, 'addIP', 'addSubnet')
end

function suite:assertIPv4CollectionObject(val)
	self:assertCollectionObject(val)
	self:assertEquals('IPv4', val:getVersion())
end

function suite:assertIPv6CollectionObject(val)
	self:assertCollectionObject(val)
	self:assertEquals('IPv6', val:getVersion())
end

function suite:assertRangesEqual(expected, actual)
	self:assertTrue(#expected == #actual)
	for i = 1, #expected do
		local expectedRange = expected[i]
		local actualRange = actual[i]
		self:assertEquals(expectedRange[1], actualRange[1])
		self:assertEquals(expectedRange[2], actualRange[2])
	end
end

-------------------------------------------------------------------------------
-- IPAddress tests
-------------------------------------------------------------------------------

function suite:testIPConstructor()
	local function assertValidIP(ip)
		self:assertIPAddressObject(IPAddress.new(ip))
	end
	assertValidIP('1.2.3.4')
	assertValidIP('0.0.0.0')
	assertValidIP('255.255.255.255')
	assertValidIP('::')
	assertValidIP('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff')
	assertValidIP('2001::f:1234')
end

function suite:testInvalidIPs()
	local function assertInvalidIP(ip)
		self:assertError(
			string.format("'%s' is an invalid IP address", ip),
			true,
			function ()
				IPAddress.new(ip)
			end
		)
	end
	assertInvalidIP('')
	assertInvalidIP('foo')
	assertInvalidIP('01.02.03.04')
	assertInvalidIP('256.256.256.256')
	assertInvalidIP('1.2.3')
	assertInvalidIP('1.2.3.4.5')
	assertInvalidIP('-1.2.3.4')
	assertInvalidIP(':')
	-- TODO: work out what to do about the following test
	-- assertInvalidIP(':::')
	assertInvalidIP('2001::f::1234')
	assertInvalidIP('2001:g::')
end

function suite:testIPConstructorErrors()
	self:assertTypeError(
		1, 'IPAddress.new', 'string', 'boolean',
		function ()
			IPAddress.new(true)
		end
	)
	self:assertTypeError(
		1, 'IPAddress.new', 'string', 'number',
		function ()
			IPAddress.new(7)
		end
	)
	self:assertTypeError(
		1, 'IPAddress.new', 'string', 'nil',
		function ()
			IPAddress.new()
		end
	)
	self:assertError(
		"'foo' is an invalid IP address",
		true,
		function ()
			IPAddress.new('foo')
		end
	)
end

function suite:testIPEquals()
	self:assertTrue(IPAddress.new('1.2.3.4') == IPAddress.new('1.2.3.4'))
	self:assertFalse(IPAddress.new('1.2.3.5') == IPAddress.new('1.2.3.4'))
	self:assertTrue(IPAddress.new('2001:a1:b2::') == IPAddress.new('2001:a1:b2::'))
	self:assertTrue(IPAddress.new('::') == IPAddress.new('0:0:0:0:0:0:0:0'))
end

function suite:testIPLessThan()
	self:assertFalse(IPAddress.new('1.2.3.4') < IPAddress.new('1.2.3.4'))
	self:assertFalse(IPAddress.new('1.2.3.5') < IPAddress.new('1.2.3.4'))
	self:assertTrue(IPAddress.new('1.2.3.3') < IPAddress.new('1.2.3.4'))
	self:assertTrue(IPAddress.new('2.0.0.0') < IPAddress.new('10.0.0.0'))
	self:assertTrue(IPAddress.new('2001:a1:b2::') < IPAddress.new('2001:a1:b2::1'))
	self:assertTrue(IPAddress.new('2001:b::') < IPAddress.new('2001:10::'))
end

function suite:testIPLessThanOrEqualTo()
	self:assertTrue(IPAddress.new('1.2.3.4') <= IPAddress.new('1.2.3.4'))
	self:assertFalse(IPAddress.new('1.2.3.5') <= IPAddress.new('1.2.3.4'))
	self:assertTrue(IPAddress.new('1.2.3.3') <= IPAddress.new('1.2.3.4'))
end

function suite:testIPToString()
	self:assertEquals('1.2.3.4', tostring(IPAddress.new('1.2.3.4')))
	self:assertEquals('2001:a1:b2::', tostring(IPAddress.new('2001:a1:b2:0:0:0:0:0')))
end

function suite:testConcatIP()
	self:assertEquals(
		'1.2.3.45.6.7.8',
		IPAddress.new('1.2.3.4') .. IPAddress.new('5.6.7.8')
	)
	self:assertEquals('1.2.3.4foo', IPAddress.new('1.2.3.4') .. 'foo')
end

function suite:testGetIP()
	self:assertEquals('1.2.3.4', IPAddress.new('1.2.3.4'):getIP())
end

function suite:testGetIPErrors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getIP',
		function ()
			IPAddress.new('1.2.3.4').getIP()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getIP',
		function ()
			IPAddress.new('1.2.3.4').getIP(IPAddress.new('5.6.7.8'))
		end
	)
end

function suite:testGetVersion()
	self:assertEquals('IPv4', IPAddress.new('1.2.3.4'):getVersion())
	self:assertEquals('IPv6', IPAddress.new('2001:db8::ff00:12:3456'):getVersion())
end

function suite:testGetVersionErrors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getVersion',
		function ()
			IPAddress.new('1.2.3.4').getVersion()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getVersion',
		function ()
			IPAddress.new('1.2.3.4').getVersion(IPAddress.new('5.6.7.8'))
		end
	)
end

function suite:testIsIPv4()
	self:assertTrue(IPAddress.new('1.2.3.4'):isIPv4())
	self:assertFalse(IPAddress.new('2001:db8::ff00:12:3456'):isIPv4())
end

function suite:testIsIPv4Errors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'isIPv4',
		function ()
			IPAddress.new('1.2.3.4').isIPv4()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'isIPv4',
		function ()
			IPAddress.new('1.2.3.4').isIPv4(IPAddress.new('5.6.7.8'))
		end
	)
end

function suite:testIsIPv6()
	self:assertTrue(IPAddress.new('2001:db8::ff00:12:3456'):isIPv6())
	self:assertFalse(IPAddress.new('1.2.3.4'):isIPv6())
end

function suite:testIsIPv6Errors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'isIPv6',
		function ()
			IPAddress.new('1.2.3.4').isIPv6()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'isIPv6',
		function ()
			IPAddress.new('1.2.3.4').isIPv6(IPAddress.new('5.6.7.8'))
		end
	)
end

function suite:testIsInSubnet()
	self:assertTrue(IPAddress.new('1.2.3.4'):isInSubnet(Subnet.new('1.2.3.0/24')))
	self:assertFalse(IPAddress.new('1.2.3.4'):isInSubnet(Subnet.new('1.2.4.0/24')))
end

function suite:testIsInSubnetFromString()
	self:assertTrue(IPAddress.new('1.2.3.4'):isInSubnet('1.2.3.0/24'))
	self:assertFalse(IPAddress.new('1.2.3.4'):isInSubnet('1.2.4.0/24'))
end

function suite:testIsInSubnetErrors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'isInSubnet',
		function ()
			IPAddress.new('1.2.3.4').isInSubnet()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'isInSubnet',
		function ()
			IPAddress.new('1.2.3.4').isInSubnet(IPAddress.new('5.6.7.8'))
		end
	)
	self:assertTypeError(
		1, 'isInSubnet', 'string or table', 'boolean',
		function ()
			IPAddress.new('1.2.3.4'):isInSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'isInSubnet', 'string or table', 'nil',
		function ()
			IPAddress.new('1.2.3.4'):isInSubnet()
		end
	)
	self:assertCIDRStringError(
		'foo',
		function ()
			IPAddress.new('1.2.3.4'):isInSubnet('foo')
		end
	)
	self:assertObjectError(
		1, 'isInSubnet', 'Subnet',
		function ()
			IPAddress.new('1.2.3.4'):isInSubnet{foo = 'bar'}
		end
	)
end

function suite:testGetSubnet()
	self:assertEquals(
		'1.2.3.0/24',
		IPAddress.new('1.2.3.4'):getSubnet(24):getCIDR()
	)
	self:assertEquals(
		'1.2.3.128/25',
		IPAddress.new('1.2.3.130'):getSubnet(25):getCIDR()
	)
end

function suite:testGetSubnetErrors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getSubnet',
		function ()
			IPAddress.new('1.2.3.4').getSubnet(24)
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getSubnet',
		function ()
			IPAddress.new('1.2.3.4').getSubnet(IPAddress.new('5.6.7.8'), 24)
		end
	)
	self:assertTypeError(
		1, 'getSubnet', 'number', 'boolean',
		function ()
			IPAddress.new('1.2.3.4'):getSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'getSubnet', 'number', 'nil',
		function ()
			IPAddress.new('1.2.3.4'):getSubnet()
		end
	)
end

function suite:testGetSubnetIPv4NumberErrors()
	local message = "bad argument #1 to 'getSubnet' (must be an integer between 0 and 32)"
	self:assertError(message, true, function ()
		IPAddress.new('1.2.3.4'):getSubnet(33)
	end)
	self:assertError(message, true, function ()
		IPAddress.new('1.2.3.4'):getSubnet(-1)
	end)
	self:assertError(message, true, function ()
		IPAddress.new('1.2.3.4'):getSubnet(24.5)
	end)
end

function suite:testGetSubnetIPv6NumberErrors()
	local message = "bad argument #1 to 'getSubnet' (must be an integer between 0 and 128)"
	self:assertError(message, true, function ()
		IPAddress.new('2001:db8::ff00:12:3456'):getSubnet(129)
	end)
	self:assertError(message, true, function ()
		IPAddress.new('2001:db8::ff00:12:3456'):getSubnet(-1)
	end)
	self:assertError(message, true, function ()
		IPAddress.new('2001:db8::ff00:12:3456'):getSubnet(112.5)
	end)
end

function suite:testGetNextIP()
	self:assertEquals('1.2.3.5', tostring(IPAddress.new('1.2.3.4'):getNextIP()))
	self:assertEquals(
		IPAddress.new('2001:db8::ff00:12:3457'),
		IPAddress.new('2001:db8::ff00:12:3456'):getNextIP()
	)
end

function suite:testGetNextIPWraparound()
	self:assertEquals(
		IPAddress.new('0.0.0.0'),
		IPAddress.new('255.255.255.255'):getNextIP()
	)
	self:assertEquals(
		'::',
		tostring(IPAddress.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'):getNextIP())
	)
end

function suite:testGetNextIPErrors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getNextIP',
		function ()
			IPAddress.new('1.2.3.4').getNextIP()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getNextIP',
		function ()
			IPAddress.new('1.2.3.4').getNextIP(IPAddress.new('5.6.7.8'))
		end
	)
end

function suite:testGetPreviousIP()
	self:assertEquals(
		IPAddress.new('1.2.3.3'),
		IPAddress.new('1.2.3.4'):getPreviousIP()
	)
	self:assertEquals(
		IPAddress.new('2001:db8::ff00:12:3455'),
		IPAddress.new('2001:db8::ff00:12:3456'):getPreviousIP()
	)
end

function suite:testGetPreviousIPWraparound()
	self:assertEquals(
		IPAddress.new('255.255.255.255'),
		IPAddress.new('0.0.0.0'):getPreviousIP()
	)
	self:assertEquals(
		IPAddress.new('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'),
		IPAddress.new('::'):getPreviousIP()
	)
end

function suite:testGetPreviousIPErrors()
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getPreviousIP',
		function ()
			IPAddress.new('1.2.3.4').getPreviousIP()
		end
	)
	self:assertSelfParameterError(
		IP_ADDRESS_CLASS, IP_ADDRESS_OBJECT, 'getPreviousIP',
		function ()
			IPAddress.new('1.2.3.4').getPreviousIP(IPAddress.new('5.6.7.8'))
		end
	)
end

function suite:testGetIPMetatable()
	self:assertNotMetatable(getmetatable(IPAddress.new('1.2.3.4')))
end

function suite:testSetIPMetatable()
	self:assertMetatableProtected(IPAddress.new('1.2.3.4'))
end

-------------------------------------------------------------------------------
-- Subnet tests
-------------------------------------------------------------------------------

function suite:testValidCIDRs()
	local function assertValidCIDR(cidr)
		self:assertTrue(type(Subnet.new(cidr)) == 'table')
	end
	assertValidCIDR('1.2.3.0/24')
	assertValidCIDR(' 1.2.3.0/24 ')
	assertValidCIDR('0.0.0.0/0')
	assertValidCIDR('0.0.0.0/32')
	assertValidCIDR('255.255.255.255/32')
	assertValidCIDR('2001:db8::ff00:12:0/122')
	assertValidCIDR('2001:DB8::FF00:12:0/122')
	assertValidCIDR('::/0')
	assertValidCIDR('::/128')
end

function suite:testInvalidCIDRs()
	local function assertInvalidCIDR(cidr)
		self:assertError(
			string.format("'%s' is an invalid CIDR string", cidr),
			true,
			function ()
				Subnet.new(cidr)
			end
		)
	end
	assertInvalidCIDR('foo')
	assertInvalidCIDR('0/0')
	assertInvalidCIDR('/24')
	assertInvalidCIDR('1.2.3/24')
	assertInvalidCIDR(':/0')
	assertInvalidCIDR('1.2.3.4')
	assertInvalidCIDR('0.0.0.0/33')
	assertInvalidCIDR('0.0.0.0/-1')
	assertInvalidCIDR('256.0.0.0/24')
	assertInvalidCIDR('1.2.3.4/24')
	assertInvalidCIDR('1.2.3.0/16')
	assertInvalidCIDR('0.0.0.0/01') -- Leading zero in bit length
	assertInvalidCIDR('2001:db8::ff00:12:3456')
	assertInvalidCIDR('2001:db8::ff00:12:0/foo')
	assertInvalidCIDR('::/-1')
	assertInvalidCIDR('::/129')
	assertInvalidCIDR('gggg:db8::ff00:12:0/122')
	assertInvalidCIDR('2001:db8::ff00:12:3456/122')
	assertInvalidCIDR('2001:db8::ff00:12:0/106')
end

function suite:testSubnetConstructorErrors()
	self:assertTypeError(
		1, 'Subnet.new', 'string', 'boolean',
		function ()
			Subnet.new(true)
		end
	)
	self:assertTypeError(
		1, 'Subnet.new', 'string', 'number',
		function ()
			Subnet.new(7)
		end
	)
	self:assertTypeError(
		1, 'Subnet.new', 'string', 'nil',
		function ()
			Subnet.new()
		end
	)
end

function suite:testSubnetEquals()
	self:assertTrue(Subnet.new('1.2.3.0/24') == Subnet.new('1.2.3.0/24'))
	self:assertFalse(Subnet.new('1.2.3.0/24') == Subnet.new('1.2.0.0/16'))
end

function suite:testConcatSubnet()
	self:assertEquals(
		'1.2.3.0/244.5.6.0/24',
		Subnet.new('1.2.3.0/24') .. Subnet.new('4.5.6.0/24')
	)
	self:assertEquals('1.2.3.0/24foo', Subnet.new('1.2.3.0/24') .. 'foo')
	self:assertEquals('foo1.2.3.0/24', 'foo' .. Subnet.new('1.2.3.0/24'))
end

function suite:testSubnetToString()
	self:assertEquals('1.2.3.0/24', tostring(Subnet.new('1.2.3.0/24')))
	self:assertEquals(
		'2001:db8::ff00:12:0/122',
		tostring(Subnet.new('2001:db8::ff00:12:0/122'))
	)
end

function suite:testSubnetGetmetatable()
	self:assertNotMetatable(getmetatable(Subnet.new('1.2.3.0/24')))
end

function suite:testSubnetSetmetatable()
	self:assertMetatableProtected(Subnet.new('1.2.3.0/24'))
end

function suite:testSubnetGetPrefix()
	self:assertEquals(
		IPAddress.new('1.2.3.0'),
		Subnet.new('1.2.3.0/24'):getPrefix()
	)
end

function suite:testSubnetGetPrefixErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getPrefix',
		function ()
			Subnet.new('1.2.3.0/24').getPrefix()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getPrefix',
		function ()
			Subnet.new('1.2.3.0/24').getPrefix(Subnet.new('4.5.6.0/24'))
		end
	)
end

function suite:testSubnetGetHighestIP()
	self:assertEquals(
		IPAddress.new('1.2.3.255'),
		Subnet.new('1.2.3.0/24'):getHighestIP()
	)
end

function suite:testGetHighestIPFromGetSubnet()
	self:assertEquals(
		IPAddress.new('1.2.3.255'),
		IPAddress.new('1.2.3.4'):getSubnet(24):getHighestIP()
	)
end

function suite:testSubnetGetHighestIPErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getHighestIP',
		function ()
			Subnet.new('1.2.3.0/24').getHighestIP()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getHighestIP',
		function ()
			Subnet.new('1.2.3.0/24').getHighestIP(Subnet.new('4.5.6.0/24'))
		end
	)
end

function suite:testSubnetGetBitLength()
	self:assertEquals(24, Subnet.new('1.2.3.0/24'):getBitLength())
end

function suite:testSubnetGetBitLengthErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getBitLength',
		function ()
			Subnet.new('1.2.3.0/24').getBitLength()
		end
	)
end

function suite:testSubnetGetCIDR()
	self:assertEquals('1.2.3.0/24', Subnet.new('1.2.3.0/24'):getCIDR())
end

function suite:testGetCIDRErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getCIDR',
		function ()
			Subnet.new('1.2.3.0/24').getCIDR()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getCIDR',
		function ()
			Subnet.new('1.2.3.0/24').getCIDR(Subnet.new('4.5.6.0/24'))
		end
	)
end

function suite:testSubnetGetVersion()
	self:assertEquals('IPv4', Subnet.new('1.2.3.0/24'):getVersion())
	self:assertEquals('IPv6', Subnet.new('2001:db8::ff00:0:0/96'):getVersion())
end

function suite:testSubnetGetVersionErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getVersion',
		function ()
			Subnet.new('1.2.3.0/24').getVersion()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'getVersion',
		function ()
			Subnet.new('1.2.3.0/24').getVersion(Subnet.new('4.5.6.0/24'))
		end
	)
end

function suite:testSubnetIsIPv4()
	self:assertTrue(Subnet.new('1.2.3.0/24'):isIPv4())
	self:assertFalse(Subnet.new('2001:db8::ff00:0:0/96'):isIPv4())
end

function suite:testSubnetIsIPv4Errors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'isIPv4',
		function ()
			Subnet.new('1.2.3.0/24').isIPv4()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'isIPv4',
		function ()
			Subnet.new('1.2.3.0/24').isIPv4(Subnet.new('4.5.6.0/24'))
		end
	)
end

function suite:testSubnetIsIPv6()
	self:assertTrue(Subnet.new('2001:db8::ff00:0:0/96'):isIPv6())
	self:assertFalse(Subnet.new('1.2.3.0/24'):isIPv6())
end

function suite:testSubnetIsIPv6Errors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'isIPv6',
		function ()
			Subnet.new('1.2.3.0/24').isIPv6()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'isIPv6',
		function ()
			Subnet.new('1.2.3.0/24').isIPv6(Subnet.new('4.5.6.0/24'))
		end
	)
end

function suite:testSubnetContainsIP()
	self:assertTrue(
		Subnet.new('1.2.3.0/24'):containsIP(IPAddress.new('1.2.3.4'))
	)
	self:assertFalse(
		Subnet.new('1.2.3.0/24'):containsIP(IPAddress.new('1.2.4.4'))
	)
end

function suite:testSubnetContainsIPErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'containsIP',
		function ()
			Subnet.new('1.2.3.0/24').containsIP(IPAddress.new('1.2.3.4'))
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'containsIP',
		function ()
			Subnet.new('1.2.3.0/24').containsIP(
				Subnet.new('4.5.6.0/24'),
				IPAddress.new('1.2.3.4')
			)
		end
	)
	self:assertTypeError(
		1, 'containsIP', 'string or table', 'boolean',
		function ()
			Subnet.new('1.2.3.0/24'):containsIP(false)
		end
	)
	self:assertTypeError(
		1, 'containsIP', 'string or table', 'nil',
		function ()
			Subnet.new('1.2.3.0/24'):containsIP()
		end
	)
	self:assertIPStringError(
		'foo',
		function ()
			Subnet.new('1.2.3.0/24'):containsIP('foo')
		end
	)
	self:assertObjectError(
		1, 'containsIP', 'IPAddress',
		function ()
			Subnet.new('1.2.3.0/24'):containsIP{foo = 'bar'}
		end
	)
end

function suite:testOverlapsSubnet()
	self:assertTrue(
		Subnet.new('1.2.0.0/16'):overlapsSubnet(Subnet.new('1.2.3.0/24'))
	)
	self:assertFalse(
		Subnet.new('1.2.0.0/16'):overlapsSubnet(Subnet.new('1.3.3.0/24'))
	)
end

function suite:testOverlapsSubnetErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'overlapsSubnet',
		function ()
			Subnet.new('1.2.3.0/24').overlapsSubnet(Subnet.new('1.2.0.0/16'))
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'overlapsSubnet',
		function ()
			Subnet.new('1.2.3.0/24').overlapsSubnet(
				Subnet.new('4.5.6.0/24'),
				Subnet.new('1.2.0.0/16')
			)
		end
	)
	self:assertTypeError(
		1, 'overlapsSubnet', 'string or table', 'boolean',
		function ()
			Subnet.new('1.2.3.0/24'):overlapsSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'overlapsSubnet', 'string or table', 'nil',
		function ()
			Subnet.new('1.2.3.0/24'):overlapsSubnet()
		end
	)
	self:assertCIDRStringError(
		'foo',
		function ()
			Subnet.new('1.2.3.0/24'):overlapsSubnet('foo')
		end
	)
	self:assertObjectError(
		1, 'overlapsSubnet', 'Subnet',
		function ()
			Subnet.new('1.2.3.0/24'):overlapsSubnet{foo = 'bar'}
		end
	)
end

function suite:testWalkSubnet()
	do
		local ips = {}
		for ip in Subnet.new('1.2.3.0/30'):walk() do
			ips[#ips + 1] = tostring(ip)
		end
		self:assertEquals(
			'1.2.3.0 1.2.3.1 1.2.3.2 1.2.3.3',
			table.concat(ips, ' ')
		)
	end
	do
		local ips = {}
		for ip in Subnet.new('2001:db8::ff00:0:0/126'):walk() do
			ips[#ips + 1] = tostring(ip)
		end
		self:assertEquals(
			'2001:db8::ff00:0:0 2001:db8::ff00:0:1 2001:db8::ff00:0:2 2001:db8::ff00:0:3',
			table.concat(ips, ' ')
		)
	end
end

function suite:testWalkSubnetErrors()
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'walk',
		function ()
			Subnet.new('1.2.3.0/24').walk()
		end
	)
	self:assertSelfParameterError(
		SUBNET_CLASS, SUBNET_OBJECT, 'walk',
		function ()
			Subnet.new('1.2.3.0/24').walk(Subnet.new('4.5.6.0/24'))
		end
	)
end

-------------------------------------------------------------------------------
-- IPv4Collection tests
-------------------------------------------------------------------------------

function suite:testIPv4CollectionConstructor()
	self:assertIPv4CollectionObject(IPv4Collection.new())
end

function suite:testIPv4CollectionGetVersion()
	self:assertEquals('IPv4', IPv4Collection.new():getVersion())
end

function suite:testIPv4CollectionAddIP()
	self:assertNotError(function () IPv4Collection.new():addIP('1.2.3.4') end)
	self:assertNotError(function () IPv4Collection.new():addIP(IPAddress.new('1.2.3.4')) end)
	suite:assertIPStringError(
		'foo',
		function ()
			IPv4Collection.new():addIP(IPAddress.new('foo'))
		end
	)
	suite:assertIPStringError(
		'1.2.3.0/24',
		function ()
			IPv4Collection.new():addIP(IPAddress.new('1.2.3.0/24'))
		end
	)
end

function suite:testIPv4CollectionAddIPChaining()
	self:assertNotError(function ()
		IPv4Collection.new()
			:addIP('1.2.3.4')
			:addIP('5.6.7.8')
	end)
end

function suite:testIPv4CollectionAddIPErrors()
	self:assertTypeError(
		1, 'addIP', 'string or table', 'boolean',
		function ()
			IPv4Collection.new():addIP(false)
		end
	)
	self:assertTypeError(
		1, 'addIP', 'string or table', 'nil',
		function ()
			IPv4Collection.new():addIP()
		end
	)
	self:assertIPStringError(
		'foo',
		function ()
			IPv4Collection.new():addIP('foo')
		end
	)
	self:assertObjectError(
		1, 'addIP', 'IPAddress',
		function ()
			IPv4Collection.new():addIP{foo = 'bar'}
		end
	)
end

function suite:testIPv4CollectionAddSubnet()
	self:assertNotError(function () IPv4Collection.new():addSubnet('1.2.3.0/24') end)
	self:assertNotError(function () IPv4Collection.new():addSubnet(Subnet.new('1.2.3.0/24')) end)
	suite:assertCIDRStringError(
		'foo',
		function ()
			IPv4Collection.new():addSubnet('foo')
		end
	)
	suite:assertCIDRStringError(
		'1.2.3.4',
		function ()
			IPv4Collection.new():addSubnet('1.2.3.4')
		end
	)
end

function suite:testIPv4CollectionAddSubnetChaining()
	self:assertNotError(function ()
		IPv4Collection.new()
			:addSubnet('1.2.3.0/24')
			:addSubnet('5.6.7.0/24')
	end)
end

function suite:testIPv4CollectionAddSubnetErrors()
	self:assertTypeError(
		1, 'addSubnet', 'string or table', 'boolean',
		function ()
			IPv4Collection.new():addSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'addSubnet', 'string or table', 'nil',
		function ()
			IPv4Collection.new():addSubnet()
		end
	)
	self:assertCIDRStringError(
		'foo',
		function ()
			IPv4Collection.new():addSubnet('foo')
		end
	)
	self:assertObjectError(
		1, 'addSubnet', 'Subnet',
		function ()
			IPv4Collection.new():addSubnet{foo = 'bar'}
		end
	)
end

function suite:testIPv4CollectionContainsIP()
	local collection = IPv4Collection.new()
	collection:addIP('1.2.3.4')
	self:assertEquals(true, collection:containsIP('1.2.3.4'))
	self:assertEquals(true, collection:containsIP(IPAddress.new('1.2.3.4')))
	self:assertEquals(false, collection:containsIP('1.2.3.5'))
end

function suite:testIPv4CollectionContainsIPErrors()
	self:assertTypeError(
		1, 'containsIP', 'string or table', 'boolean',
		function ()
			IPv4Collection.new():containsIP(false)
		end
	)
	self:assertTypeError(
		1, 'containsIP', 'string or table', 'nil',
		function ()
			IPv4Collection.new():containsIP()
		end
	)
	self:assertIPStringError(
		'foo',
		function ()
			IPv4Collection.new():containsIP('foo')
		end
	)
	self:assertObjectError(
		1, 'containsIP', 'IPAddress',
		function ()
			IPv4Collection.new():containsIP{foo = 'bar'}
		end
	)
end

function suite:testIPv4CollectionGetRanges()
	local collection = IPv4Collection.new()
	collection:addSubnet('1.2.0.0/24')
	collection:addSubnet('1.2.1.0/24')
	self:assertRangesEqual(
		{{IPAddress.new('1.2.0.0'), IPAddress.new('1.2.1.255')}},
		collection:getRanges()
	)
	collection:addSubnet('1.2.10.0/24')
	self:assertRangesEqual(
		{
			{IPAddress.new('1.2.0.0'), IPAddress.new('1.2.1.255')},
			{IPAddress.new('1.2.10.0'), IPAddress.new('1.2.10.255')},
		},
		collection:getRanges()
	)
end

function suite:testIPv4CollectionOverlapsSubnet()
	local collection = IPv4Collection.new()
	self:assertEquals(false, collection:overlapsSubnet('1.2.3.0/24'))
	collection:addIP('1.2.3.4')
	self:assertEquals(true, collection:overlapsSubnet('1.2.3.0/24'))
	self:assertEquals(false, collection:overlapsSubnet('5.6.7.0/24'))
end

function suite:testIPv4CollectionOverlapsSubnetObjects()
	local collection = IPv4Collection.new()
	self:assertEquals(false, collection:overlapsSubnet(Subnet.new('1.2.3.0/24')))
	collection:addIP('1.2.3.4')
	self:assertEquals(true, collection:overlapsSubnet(Subnet.new('1.2.3.0/24')))
	self:assertEquals(false, collection:overlapsSubnet(Subnet.new('5.6.7.0/24')))
end

function suite:testIPv4CollectionOverlapsSubnetErrors()
	self:assertTypeError(
		1, 'overlapsSubnet', 'string or table', 'boolean',
		function ()
			IPv4Collection.new():overlapsSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'overlapsSubnet', 'string or table', 'nil',
		function ()
			IPv4Collection.new():overlapsSubnet()
		end
	)
	self:assertCIDRStringError(
		'foo',
		function ()
			IPv4Collection.new():overlapsSubnet('foo')
		end
	)
	self:assertObjectError(
		1, 'overlapsSubnet', 'Subnet',
		function ()
			IPv4Collection.new():overlapsSubnet{foo = 'bar'}
		end
	)
end

function suite:testIPv4CollectionAddFromString()
	local collection = IPv4Collection.new()
	collection:addFromString('foo 1.2.3.4 bar 5.6.7.0/24 baz')
	self:assertTrue(collection:containsIP('1.2.3.4'))
	self:assertTrue(collection:overlapsSubnet('5.6.7.0/24'))
end

function suite:testIPv4CollectionAddFromStringChaining()
	self:assertNotError(function ()
		IPv4Collection.new()
			:addFromString('foo 1.2.3.4')
			:addFromString('bar 5.6.7.8')
	end)
end

function suite:testIPv4CollectionAddFromStringErrors()
	self:assertTypeError(
		1, 'addFromString', 'string', 'boolean',
		function ()
			IPv4Collection.new():addFromString(false)
		end
	)
	self:assertTypeError(
		1, 'addFromString', 'string', 'nil',
		function ()
			IPv4Collection.new():addFromString()
		end
	)
	self:assertTypeError(
		1, 'addFromString', 'string', 'table',
		function ()
			IPv4Collection.new():addFromString{}
		end
	)
	self:assertTypeError(
		1, 'addFromString', 'string', 'number',
		function ()
			IPv4Collection.new():addFromString(7)
		end
	)
end

-------------------------------------------------------------------------------
-- IPv6Collection tests
-------------------------------------------------------------------------------

function suite:testIPv6CollectionConstructor()
	self:assertIPv6CollectionObject(IPv6Collection.new())
end

function suite:testIPv6CollectionGetVersion()
	self:assertEquals('IPv6', IPv6Collection.new():getVersion())
end

function suite:testIPv6CollectionAddIP()
	self:assertNotError(function () IPv6Collection.new():addIP('2001:db8::ff00:12:3456') end)
	self:assertNotError(function () IPv6Collection.new():addIP(IPAddress.new('2001:db8::ff00:12:3456')) end)
	suite:assertIPStringError(
		'foo',
		function ()
			IPv6Collection.new():addIP(IPAddress.new('foo'))
		end
	)
	suite:assertIPStringError(
		'2001:db8::ff00:12:0/112',
		function ()
			IPv6Collection.new():addIP(IPAddress.new('2001:db8::ff00:12:0/112'))
		end
	)
end

function suite:testIPv6CollectionAddIPChaining()
	self:assertNotError(function ()
		IPv6Collection.new()
			:addIP('2001:db8::ff00:0:1234')
			:addIP('2001:db8::ff00:0:5678')
	end)
end

function suite:testIPv6CollectionAddIPErrors()
	self:assertTypeError(
		1, 'addIP', 'string or table', 'boolean',
		function ()
			IPv6Collection.new():addIP(false)
		end
	)
	self:assertTypeError(
		1, 'addIP', 'string or table', 'nil',
		function ()
			IPv6Collection.new():addIP()
		end
	)
	self:assertIPStringError(
		'foo',
		function ()
			IPv6Collection.new():addIP('foo')
		end
	)
	self:assertObjectError(
		1, 'addIP', 'IPAddress',
		function ()
			IPv6Collection.new():addIP{foo = 'bar'}
		end
	)
end

function suite:testIPv6CollectionAddSubnet()
	self:assertNotError(function () IPv6Collection.new():addSubnet('2001:db8::ff00:12:0/112') end)
	self:assertNotError(function () IPv6Collection.new():addSubnet(Subnet.new('2001:db8::ff00:12:0/112')) end)
	suite:assertCIDRStringError(
		'foo',
		function ()
			IPv6Collection.new():addSubnet('foo')
		end
	)
	suite:assertCIDRStringError(
		'2001:db8::ff00:12:3456',
		function ()
			IPv6Collection.new():addSubnet('2001:db8::ff00:12:3456')
		end
	)
end

function suite:testIPv6CollectionAddSubnetChaining()
	self:assertNotError(function ()
		IPv6Collection.new()
			:addSubnet('2001:db8::ff00:0:0/112')
			:addSubnet('2001:db8::ff00:1:0/112')
	end)
end

function suite:testIPv6CollectionAddSubnetErrors()
	self:assertTypeError(
		1, 'addSubnet', 'string or table', 'boolean',
		function ()
			IPv6Collection.new():addSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'addSubnet', 'string or table', 'nil',
		function ()
			IPv6Collection.new():addSubnet()
		end
	)
	self:assertCIDRStringError(
		'foo',
		function ()
			IPv6Collection.new():addSubnet('foo')
		end
	)
	self:assertObjectError(
		1, 'addSubnet', 'Subnet',
		function ()
			IPv6Collection.new():addSubnet{foo = 'bar'}
		end
	)
end

function suite:testIPv6CollectionContainsIP()
	local collection = IPv6Collection.new()
	collection:addIP('2001:db8::ff00:12:3456')
	self:assertEquals(true, collection:containsIP('2001:db8::ff00:12:3456'))
	self:assertEquals(true, collection:containsIP(IPAddress.new('2001:db8::ff00:12:3456')))
	self:assertEquals(false, collection:containsIP('1.2.3.5'))
end

function suite:testIPv6CollectionContainsIPErrors()
	self:assertTypeError(
		1, 'containsIP', 'string or table', 'boolean',
		function ()
			IPv6Collection.new():containsIP(false)
		end
	)
	self:assertTypeError(
		1, 'containsIP', 'string or table', 'nil',
		function ()
			IPv6Collection.new():containsIP()
		end
	)
	self:assertIPStringError(
		'foo',
		function ()
			IPv6Collection.new():containsIP('foo')
		end
	)
	self:assertObjectError(
		1, 'containsIP', 'IPAddress',
		function ()
			IPv6Collection.new():containsIP{foo = 'bar'}
		end
	)
end

function suite:testIPv6CollectionGetRanges()
	local collection = IPv6Collection.new()
	collection:addSubnet('2001:db8::ff00:0:0/112')
	collection:addSubnet('2001:db8::ff00:1:0/112')
	self:assertRangesEqual(
		{{IPAddress.new('2001:db8::ff00:0:0'), IPAddress.new('2001:db8::ff00:1:ffff')}},
		collection:getRanges()
	)
	collection:addSubnet('2001:db8::ff00:10:0/112')
	self:assertRangesEqual(
		{
			{IPAddress.new('2001:db8::ff00:0:0'), IPAddress.new('2001:db8::ff00:1:ffff')},
			{IPAddress.new('2001:db8::ff00:10:0'), IPAddress.new('2001:db8::ff00:10:ffff')},
		},
		collection:getRanges()
	)
end

function suite:testIPv6CollectionOverlapsSubnet()
	local collection = IPv6Collection.new()
	self:assertEquals(false, collection:overlapsSubnet('2001:db8::ff00:12:0/112'))
	collection:addIP('2001:db8::ff00:12:3456')
	self:assertEquals(true, collection:overlapsSubnet('2001:db8::ff00:12:0/112'))
	self:assertEquals(false, collection:overlapsSubnet('2001:db8::ff00:34:0/112'))
end

function suite:testIPv6CollectionOverlapsSubnetObjects()
	local collection = IPv6Collection.new()
	self:assertEquals(false, collection:overlapsSubnet(Subnet.new('2001:db8::ff00:12:0/112')))
	collection:addIP('2001:db8::ff00:12:3456')
	self:assertEquals(true, collection:overlapsSubnet(Subnet.new('2001:db8::ff00:12:0/112')))
	self:assertEquals(false, collection:overlapsSubnet(Subnet.new('2001:db8::ff00:34:0/112')))
end

function suite:testIPv6CollectionOverlapsSubnetErrors()
	self:assertTypeError(
		1, 'overlapsSubnet', 'string or table', 'boolean',
		function ()
			IPv6Collection.new():overlapsSubnet(false)
		end
	)
	self:assertTypeError(
		1, 'overlapsSubnet', 'string or table', 'nil',
		function ()
			IPv6Collection.new():overlapsSubnet()
		end
	)
	self:assertCIDRStringError(
		'foo',
		function ()
			IPv6Collection.new():overlapsSubnet('foo')
		end
	)
	self:assertObjectError(
		1, 'overlapsSubnet', 'Subnet',
		function ()
			IPv6Collection.new():overlapsSubnet{foo = 'bar'}
		end
	)
end

function suite:testIPv6CollectionAddFromString()
	local collection = IPv6Collection.new()
	collection:addFromString('foo 2001:db8::ff00:12:3456 bar 2001:db8::ff00:34:0/112 baz')
	self:assertTrue(collection:containsIP('2001:db8::ff00:12:3456'))
	self:assertTrue(collection:overlapsSubnet('2001:db8::ff00:34:0/112'))
end

function suite:testIPv6CollectionAddFromStringStartingColon()
	local collection = IPv6Collection.new()
	collection:addFromString('::12:1234 foo')
	self:assertTrue(collection:containsIP('::12:1234'))
end

function suite:testIPv6CollectionAddFromStringStartingIndent()
	local collection = IPv6Collection.new()
	collection:addFromString('::As I was saying, 2001:db8::ff00:12:3456 should be blocked. ~~~~')
	self:assertTrue(collection:containsIP('2001:db8::ff00:12:3456'))
	self:assertFalse(collection:containsIP('::'))
end

function suite:testIPv6CollectionAddFromStringChaining()
	self:assertNotError(function ()
		IPv6Collection.new()
			:addFromString('foo 2001:db8::ff00:0:1234')
			:addFromString('bar 2001:db8::ff00:0:5678')
	end)
end

function suite:testIPv6CollectionAddFromStringErrors()
	self:assertTypeError(
		1, 'addFromString', 'string', 'boolean',
		function ()
			IPv6Collection.new():addFromString(false)
		end
	)
	self:assertTypeError(
		1, 'addFromString', 'string', 'nil',
		function ()
			IPv6Collection.new():addFromString()
		end
	)
	self:assertTypeError(
		1, 'addFromString', 'string', 'table',
		function ()
			IPv6Collection.new():addFromString{}
		end
	)
	self:assertTypeError(
		1, 'addFromString', 'string', 'number',
		function ()
			IPv6Collection.new():addFromString(7)
		end
	)
end

return suite
