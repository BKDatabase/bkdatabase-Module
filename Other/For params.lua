local p = {}
local yesno = require('Module:Yesno')

-- Escape a string for inclusion in a Lua pattern
local function escPattern(s)
	return s:gsub('([%(%)%%%.%[%]%*%+%-%?%^%$])', '%%%1')
end

-- Get the value of a prefixed argument
local function getAffixedArg(args, prefix, suffix, num, optNum)
	return args[prefix .. num .. suffix] or (num == 1 and optNum and args[prefix .. suffix]) or nil
end

-- Get parameters of type "typeName" from module arguments
local function getParams(args, typeName)
	local params = {}
    local i = 1
    local cur = getAffixedArg(args, typeName, '', i, true)

    while cur do
    	table.insert(params, cur)
    	i = i + 1
    	cur = getAffixedArg(args, typeName, '', i, true)
    end

    return params
end

-- Get suffixes of type "typeName" matching the provided prefixes
local function getSuffixes(args, typeName, prefixes)
	local suffixes = {}

	for i, _ in ipairs(prefixes) do
		suffixes[i] = getAffixedArg(args, typeName, '', i, true) or ''
	end

	return suffixes
end

-- Return the function that processes each iteration
local function makeProcessor(frame, parent)
	local noIndex = yesno(frame.args.noindex or false)
	local template = frame.args.call

	if template then
		return function(num, args)
			if not noIndex then args['i'] = num end
			return frame:expandTemplate{title = template, args = args}
		end
	end

	-- Note: The difference between angle brackets and their entities is lost
	local code = mw.text.unstripNoWiki(frame.args[1]):gsub('&lt;', '<'):gsub('&gt;', '>')

	return function(num, args)
		if not noIndex then args['i'] = num end
		return parent:newChild{title = 'Wikitext', args = args}:preprocess(code)
	end
end

-- Create the argument iterator 
local function numPairs(args, parentArgs, prefixes, suffixes, optNum)
	local start = tonumber(args.start or 1)

	-- Sparse mode
	if yesno(args.sparse or false) then
		local nums = {}
		local foundAlready = {}

		-- Check every argument to find prefixed arguments and numbers
	    for k, _ in pairs(parentArgs) do
			-- Check every prefix for a match
	    	for i, prefix in ipairs(prefixes) do
	    		local numStr = tostring(k):match('^' .. escPattern(prefix) .. '(%d*)' .. escPattern(suffixes[i]) .. '$')

	    		if numStr then
	    			local num = tonumber(numStr) or optNum and 1 or nil

	    			if num ~= nil and num >= start and not foundAlready[num] then
						table.insert(nums, num)
						foundAlready[num] = true
					end

	    			break
	    		end
	    	end
	    end

	    table.sort(nums)

	    -- Iterate over each found number
	    local function sequenceIter(a, i)
			i = i + 1
			if a[i] then return i, a[i] end
	    end

	    return sequenceIter, nums, 0
	end

	-- Iterate each number and check for any matches
	local function prefixIter(a, i)
		i = i + 1
    	-- Check every prefix for a match
    	for j, prefix in ipairs(prefixes) do
    		if getAffixedArg(a, prefix, suffixes[j], i, optNum) ~= nil then return i, i end
    	end
	end

	return prefixIter, parentArgs, start - 1
end

function p.main(frame)
	local result = {}
	local parent = frame:getParent()

	local prefixes = getParams(frame.args, 'prefix')
	-- Default to accepting unnamed parameters
	if not prefixes[1] then prefixes[1] = '' end

	local suffixes = getSuffixes(frame.args, 'suffix', prefixes)
	local extras = getParams(frame.args, 'extra')
	local extraSuffixes = getSuffixes(frame.args, 'extrasuffix', extras)
	local fixeds = getParams(frame.args, 'fixed')
	local process = makeProcessor(frame, parent)
	local optNum = yesno(frame.args.optnum or true)

	-- Iterate over each valid number
	for _, num in numPairs(frame.args, parent.args, prefixes, suffixes, optNum) do
		local args = {}

		-- Pass registered fixed arguments
		for _, fixed in ipairs(fixeds) do
			args[fixed] = parent.args[fixed]
		end

		-- Pass extra parameters without their numeric component
		for i, extra in ipairs(extras) do
			local suffix = extraSuffixes[i]
			args[extra .. suffix] = getAffixedArg(parent.args, extra, suffix, num, optNum)
		end

		-- Pass current parameters without their numeric component
		for i, prefix in ipairs(prefixes) do
			local suffix = suffixes[i]
			local name = (prefix ~= '' or suffix ~= '') and prefix .. suffix or '1'
			args[name] = getAffixedArg(parent.args, prefix, suffix, num, optNum)
		end

		table.insert(result, process(num, args))
	end

	-- Combine results using sep and conj
	local sep = frame.args.call and frame.args[1] or frame.args[2] or frame.args.sep or ''
	local conj = frame.args.conj or sep
	return mw.text.listToText(result, sep, conj)
end

return p
