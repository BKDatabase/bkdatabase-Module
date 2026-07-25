--------------------------------------------------------------------------------
-- This module provies helper functions for manipulating Lua functions.
--
-- @module func
-- @alias  p
-- @author ExE Boss
--------------------------------------------------------------------------------

require("strict");
local checkTypeMulti = require("libraryUtil").checkTypeMulti;

local p = {};

--------------------------------------------------------------------------------
-- Creates a bound function that calls `func` with the varargs passed to `bind`
-- preceding the varargs passed to the newly created bound function.
--
-- @param {function} func
-- @param {any} ...
-- @return {function}
-- @see https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Function/bind
--------------------------------------------------------------------------------
function p.bind(func, ...)
	checkTypeMulti("bind", 1, func, { "table", "function" });

	local length = select("#", ...);
	local args = {...};

	return function(...)
		local callArgs = { unpack(args, 1, length) };
		local innerLength = select("#", ...);
		for i = 1, innerLength do
			callArgs[length + i] = select(i, ...);
		end
		return func(unpack(callArgs, 1, innerLength + length));
	end
end

return p;