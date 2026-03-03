require('strict')
local libraryUtil = require("libraryUtil")
local checkType = libraryUtil.checkType
local checkTypeForNamedArg = libraryUtil.checkTypeForNamedArg

local defaultOptions = {
	pretty = false,
	tabs = true,
	semicolons = false,
	spaces = 4,
	sortKeys = true,
	depth = 0,
}

-- Define the reprRecursive variable here so that we can call the reprRecursive
-- function from renderSequence and renderKeyValueTable without getting
-- "Tried to read nil global reprRecursive" errors.
local reprRecursive

local luaKeywords = {
	["and"]      = true,
	["break"]    = true,
	["do"]       = true,
	["else"]     = true,
	["elseif"]   = true,
	["end"]      = true,
	["false"]    = true,
	["for"]      = true,
	["function"] = true,
	["if"]       = true,
	["in"]       = true,
	["local"]    = true,
	["nil"]      = true,
	["not"]      = true,
	["or"]       = true,
	["repeat"]   = true,
	["return"]   = true,
	["then"]     = true,
	["true"]     = true,
	["until"]    = true,
	["while"]    = true,
}

--[[
-- Whether the given value is a valid Lua identifier (i.e. whether it can be
-- used as a variable name.)
--]]
local function isLuaIdentifier(str)
	return type(str) == "string"
		-- Must start with a-z, A-Z or underscore, and can only contain
		-- a-z, A-Z, 0-9 and underscore
		and str:find("^[%a_][%a%d_]*$") ~= nil
		-- Cannot be a Lua keyword
		and not luaKeywords[str]
end

--[[
-- Render a string representation.
--]]
local function renderString(s)
	return (("%q"):format(s):gsub("\\\n", "\\n"))
end

--[[
-- Render a number representation.
--]]
local function renderNumber(n)
	if n == math.huge then
		return "math.huge"
	elseif n == -math.huge then
		return "-math.huge"
	else
		return tostring(n)
	end
end

--[[
-- Whether a table has a __tostring metamethod.
--]]
local function hasTostringMetamethod(t)
	return getmetatable(t) and type(getmetatable(t).__tostring) == "function"
end

--[[
-- Pretty print a sequence of string representations.
-- This can be made to represent different constructs depending on the values
-- of prefix, suffix, and separator. The amount of whitespace is controlled by
-- the depth and indent parameters.
--]]
local function prettyPrintItemsAtDepth(items, prefix, suffix, separator, indent, depth)
	local whitespaceAtCurrentDepth = "\n" .. indent:rep(depth)
	local whitespaceAtNextDepth = whitespaceAtCurrentDepth .. indent
	local ret = {prefix, whitespaceAtNextDepth}
	local first = items[1]
	if first ~= nil then
		table.insert(ret, first)
	end
	for i = 2, #items do
		table.insert(ret, separator)
		table.insert(ret, whitespaceAtNextDepth)
		table.insert(ret, items[i])
	end
	table.insert(ret, whitespaceAtCurrentDepth)
	table.insert(ret, suffix)
	return table.concat(ret)
end

--[[
-- Render a sequence of string representations.
-- This can be made to represent different constructs depending on the values of
-- prefix, suffix and separator.
--]]
local function renderItems(items, prefix, suffix, separator)
	return prefix .. table.concat(items, separator .. " ") .. suffix
end

--[[
-- Render a regular table (a non-cyclic table with no __tostring metamethod).
-- This can be a sequence table, a key-value table, or a mix of the two.
--]]
local function renderNormalTable(t, context, depth)
	local items = {}

	-- Render the items in the sequence part
	local seen = {}
	for i, value in ipairs(t) do
		table.insert(items, reprRecursive(t[i], context, depth + 1))
		seen[i] = true
	end
	
	-- Render the items in the key-value part	
	local keyOrder = {}
	local keyValueStrings = {}
	for k, v in pairs(t) do
		if not seen[k] then
			local kStr = isLuaIdentifier(k) and k or ("[" .. reprRecursive(k, context, depth + 1) .. "]")
			local vStr = reprRecursive(v, context, depth + 1)
			table.insert(keyOrder, kStr)
			keyValueStrings[kStr] = vStr
		end
	end
	if context.sortKeys then
		table.sort(keyOrder)
	end
	for _, kStr in ipairs(keyOrder) do
		table.insert(items, string.format("%s = %s", kStr, keyValueStrings[kStr]))
	end
	
	-- Render the table structure
	local prefix = "{"
	local suffix = "}"
	if context.pretty then
		return prettyPrintItemsAtDepth(
			items,
			prefix,
			suffix,
			context.separator,
			context.indent,
			depth
		)
	else
		return renderItems(items, prefix, suffix, context.separator)
	end
end

--[[
-- Render the given table.
-- As well as rendering regular tables, this function also renders cyclic tables
-- and tables with a __tostring metamethod.
--]]
local function renderTable(t, context, depth)
	if hasTostringMetamethod(t) then
		return tostring(t)
	elseif context.shown[t] then
		return "{CYCLIC}"
	end
	context.shown[t] = true
	local result = renderNormalTable(t, context, depth)
	context.shown[t] = false
	return result
end

--[[
-- Recursively render a string representation of the given value.
--]]
function reprRecursive(value, context, depth)
	if value == nil then
		return "nil"
	end
	local valueType = type(value)
	if valueType == "boolean" then
		return tostring(value)
	elseif valueType == "number" then
		return renderNumber(value)
	elseif valueType == "string" then
		return renderString(value)
	elseif valueType == "table" then
		return renderTable(value, context, depth)
	else
		return "<" .. valueType .. ">"
	end
end

--[[
-- Normalize a table of options passed by the user.
-- Any values not specified will be assigned default values.
--]]
local function normalizeOptions(options)
	options = options or {}
	local ret = {}
	for option, defaultValue in pairs(defaultOptions) do
		local value = options[option]
		if value ~= nil then
			if type(value) == type(defaultValue) then
				ret[option] = value
			else
				error(
					string.format(
						'Invalid type for option "%s" (expected %s, received %s)',
						option,
						type(defaultValue),
						type(value)
					),
					3
				)
			end
		else
			ret[option] = defaultValue
		end
	end
	return ret
end

--[[
-- Get the indent from the options table.
--]]
local function getIndent(options)
	if options.tabs then
		return "\t"
	else
		return string.rep(" ", options.spaces)
	end
end

--[[
-- Render a string representation of the given value.
--]]
local function repr(value, options)
	checkType("repr", 2, options, "table", true)
	
	options = normalizeOptions(options)
	local context = {}

	context.pretty = options.pretty
	if context.pretty then
		context.indent = getIndent(options)
	else
		context.indent = ""
	end
	
	if options.semicolons then
		context.separator = ";"
	else
		context.separator = ","
	end
	
	context.sortKeys = options.sortKeys
	context.shown = {}
	local depth = options.depth
	
	return reprRecursive(value, context, depth)
end

--[[
-- Render a string representation of the given function invocation.
--]]
local function invocationRepr(keywordArgs)
	checkType("invocationRepr", 1, keywordArgs, "table")
	checkTypeForNamedArg("invocationRepr", "funcName", keywordArgs.funcName, "string")
	checkTypeForNamedArg("invocationRepr", "args", keywordArgs.args, "table", true)
	checkTypeForNamedArg("invocationRepr", "options", keywordArgs.options, "table", true)
	
	local options = normalizeOptions(keywordArgs.options)
	local depth = options.depth

	options.depth = depth + 1
	local items = {}
	if keywordArgs.args then
		for _, arg in ipairs(keywordArgs.args) do
			table.insert(items, repr(arg, options))
		end
	end

	local prefix = "("
	local suffix = ")"
	local separator = ","
	local renderedArgs
	if options.pretty then
		renderedArgs = prettyPrintItemsAtDepth(
			items,
			prefix,
			suffix,
			separator,
			getIndent(options),
			depth
		)
	else
		renderedArgs = renderItems(items, prefix, suffix, separator)
	end
	return keywordArgs.funcName .. renderedArgs
end

return {
	_isLuaIdentifier = isLuaIdentifier,
	repr = repr,
	invocationRepr = invocationRepr,
}
