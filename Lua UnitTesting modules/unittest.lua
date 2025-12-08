-- UnitTester provides unit testing for other Lua scripts. For details see [[BKD:Lua#Unit_testing]].
-- For user documentation see talk page.
local UnitTester = {}

local frame, tick, cross, should_highlight
local result_table_header = "{|class=\"wikitable unit-tests-result\"\n|+ %s\n! !! Văn bản !! Mong đợi !! Thực tế"
local result_table_live_sandbox_header = "{|class=\"wikitable unit-tests-result\"\n|+ %s\n! !! Test !! Hiện hành !! Sandbox !! Mong đợi"

local result_table = { n = 0 }
local result_table_mt = {
	insert = function (self, ...)
		local n = self.n
		for i = 1, select('#', ...) do
			local val = select(i, ...)
			if val ~= nil then
				n = n + 1
				self[n] = val
			end
		end
		self.n = n
	end,
	insert_format = function (self, ...)
		self:insert(string.format(...))
	end,
	concat = table.concat
}
result_table_mt.__index = result_table_mt
setmetatable(result_table, result_table_mt)

local num_failures = 0
local num_runs = 0

local function first_difference(s1, s2)
	s1, s2 = tostring(s1), tostring(s2)
    if s1 == s2 then return '' end
    local max = math.min(#s1, #s2)
    for i = 1, max do
        if s1:sub(i,i) ~= s2:sub(i,i) then return i end
    end
    return max + 1
end

local function return_varargs(...)
	return ...
end

function UnitTester:calculate_output(text, expected, actual, options)
	-- Set up some variables for throughout for ease
	num_runs = num_runs + 1
	local options = options or {}
	
	-- Fix any stripmarkers if asked to do so to prevent incorrect fails
	local compared_expected = expected
	local compared_actual = actual
	if options.templatestyles then
		local pattern = '(\127[^\127]*UNIQ%-%-templatestyles%-)(%x+)(%-QINU[^\127]*\127)'
		local _, expected_stripmarker_id = compared_expected:match(pattern)				-- when module rendering has templatestyles strip markers, use ID from expected to prevent false test fail
		if expected_stripmarker_id then
			compared_actual = compared_actual:gsub(pattern, '%1' .. expected_stripmarker_id .. '%3')	-- replace actual id with expected id; ignore second capture in pattern
			compared_expected = compared_expected:gsub(pattern, '%1' .. expected_stripmarker_id .. '%3')		-- account for other strip markers
		end
	end
	if options.stripmarker then
		local pattern = '(\127[^\127]*UNIQ%-%-%l+%-)(%x+)(%-%-?QINU[^\127]*\127)'
		local _, expected_stripmarker_id = compared_expected:match(pattern)
		if expected_stripmarker_id then
			compared_actual = compared_actual:gsub(pattern, '%1' .. expected_stripmarker_id .. '%3')
			compared_expected = compared_expected:gsub(pattern, '%1' .. expected_stripmarker_id .. '%3')
		end
	end
	
	-- Perform the comparison
	local success = compared_actual == compared_expected
	if not success then
		num_failures = num_failures + 1
	end
	
	-- Sort the wikitext for displaying the results
	if options.combined then
		-- We need 2 rows available for the expected and actual columns
		-- Top one is parsed, bottom is unparsed
		local differs_at = self.differs_at and (' \n| rowspan=2|' .. first_difference(compared_expected, compared_actual)) or ''
		-- Local copies of tick/cross to allow for highlighting
		local highlight = (should_highlight and not success and 'style="background:#fc0;" ') or ''
		result_table:insert(													-- Start output
			'| ', highlight, 'rowspan=2|', success and tick or cross,			-- Tick/Cross (2 rows)
			' \n| rowspan=2|', mw.text.nowiki(text), ' \n| ',					-- Text used for the test (2 rows)
			expected, ' \n| ', actual,											-- The parsed outputs (in the 1st row)
			differs_at, ' \n|-\n| ',											-- Where any relevant difference was (2 rows)
			mw.text.nowiki(expected), ' \n| ', mw.text.nowiki(actual),			-- The unparsed outputs (in the 2nd row)
			'\n|-\n'															-- End output
		)
	else
		-- Display normally with whichever option was preferred (nowiki/parsed)
		local differs_at = self.differs_at and (' \n| ' .. first_difference(compared_expected, compared_actual)) or ''
		local formatting = options.nowiki and mw.text.nowiki or return_varargs
		local highlight = (should_highlight and not success and 'style="background:#fc0;"|') or ''
		result_table:insert(													-- Start output
			'| ', highlight, success and tick or cross,							-- Tick/Cross
			' \n| ', mw.text.nowiki(text), ' \n| ',								-- Text used for the test
			formatting(expected), ' \n| ', formatting(actual),					-- The formatted outputs
			differs_at,															-- Where any relevant difference was
			'\n|-\n'															-- End output
		)
	end
end

function UnitTester:preprocess_equals(text, expected, options)
    local actual = frame:preprocess(text)
    self:calculate_output(text, expected, actual, options)
end

function UnitTester:preprocess_equals_many(prefix, suffix, cases, options)
    for _, case in ipairs(cases) do
        self:preprocess_equals(prefix .. case[1] .. suffix, case[2], options)
    end
end

function UnitTester:preprocess_equals_preprocess(text1, text2, options)
	local actual = frame:preprocess(text1)
	local expected = frame:preprocess(text2)
	self:calculate_output(text1, expected, actual, options)
end

function UnitTester:preprocess_equals_compare(live, sandbox, expected, options)
	local live_text = frame:preprocess(live)
	local sandbox_text = frame:preprocess(sandbox)
	local highlight_live = false
	local highlight_sandbox = false
	num_runs = num_runs + 1
	if live_text == expected and sandbox_text == expected then
		result_table:insert('| ', tick)
	else
		result_table:insert('| ', cross)
		num_failures = num_failures + 1

		if live_text ~= expected then
			highlight_live = true
		end

		if sandbox_text ~= expected then
			highlight_sandbox = true
		end
	end
    local formatting = (options and options.nowiki and mw.text.nowiki) or return_varargs
    local differs_at = self.differs_at and (' \n| ' .. first_difference(expected, live_text) or first_difference(expected, sandbox_text)) or ''
    result_table:insert(
			' \n| ',
			mw.text.nowiki(live),
			should_highlight and highlight_live and ' \n|style="background: #fc0;"| ' or ' \n| ',
			formatting(live_text),
			should_highlight and highlight_sandbox and ' \n|style="background: #fc0;"| ' or ' \n| ',
			formatting(sandbox_text),
			' \n| ',
			formatting(expected),
			differs_at,
			"\n|-\n"
	)
end

function UnitTester:preprocess_equals_preprocess_many(prefix1, suffix1, prefix2, suffix2, cases, options)
    for _, case in ipairs(cases) do
        self:preprocess_equals_preprocess(prefix1 .. case[1] .. suffix1, prefix2 .. (case[2] and case[2] or case[1]) .. suffix2, options)
    end
end

function UnitTester:preprocess_equals_sandbox_many(module, function_name, cases, options)
    for _, case in ipairs(cases) do
		local live = module .. "|" .. function_name .. "|" .. case[1] .. "}}"
		local sandbox = module .. "/sandbox|" .. function_name .. "|" .. case[1] .. "}}"
        self:preprocess_equals_compare(live, sandbox, case[2], options)
    end
end

function UnitTester:equals(name, actual, expected, options)
	num_runs = num_runs + 1
    if actual == expected then
        result_table:insert('| ', tick)
    else
        result_table:insert('| ', cross)
        num_failures = num_failures + 1
    end
    local formatting = (options and options.nowiki and mw.text.nowiki) or return_varargs
    local differs_at = self.differs_at and (' \n| ' .. first_difference(expected, actual)) or ''
    local display = options and options.display or return_varargs
    result_table:insert(' \n| ', name, ' \n| ',
    	formatting(tostring(display(expected))), ' \n| ',
    	formatting(tostring(display(actual))), differs_at, "\n|-\n")
end

local function deep_compare(t1, t2, ignore_mt)
    local ty1 = type(t1)
    local ty2 = type(t2)
    if ty1 ~= ty2 then return false end
    if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end

    local mt = getmetatable(t1)
    if not ignore_mt and mt and mt.__eq then return t1 == t2 end

    for k1, v1 in pairs(t1) do
        local v2 = t2[k1]
        if v2 == nil or not deep_compare(v1, v2) then return false end
    end
    for k2, v2 in pairs(t2) do
        local v1 = t1[k2]
        if v1 == nil or not deep_compare(v1, v2) then return false end
    end

    return true
end

local function val_to_str(obj)
    local function table_key_to_str(k)
        if type(k) == 'string' and mw.ustring.match(k, '^[_%a][_%a%d]*$') then
            return k
        else
            return '[' .. val_to_str(k) .. ']'
        end
    end

    if type(obj) == "string" then
        obj = mw.ustring.gsub(obj, "\n", "\\n")
        if mw.ustring.match(mw.ustring.gsub(obj, '[^\'"]', ''), '^"+$') then
            return "'" .. obj .. "'"
        end
        return '"' .. mw.ustring.gsub(obj, '"', '\\"' ) .. '"'

    elseif type(obj) == "table" then
        local result, checked = {}, {}
        for k, v in ipairs(obj) do
            table.insert(result, val_to_str(v))
            checked[k] = true
        end
        for k, v in pairs(obj) do
            if not checked[k] then
                table.insert(result, table_key_to_str(k) .. '=' .. val_to_str(v))
            end
        end
        return '{' .. table.concat(result, ',') .. '}'

    else
        return tostring(obj)
    end
end

function UnitTester:equals_deep(name, actual, expected, options)
	num_runs = num_runs + 1
    if deep_compare(actual, expected) then
        result_table:insert('| ', tick)
    else
        result_table:insert('| ', cross)
        num_failures = num_failures + 1
    end
    local formatting = (options and options.nowiki and mw.text.nowiki) or return_varargs
    local actual_str = val_to_str(actual)
    local expected_str = val_to_str(expected)
    local differs_at = self.differs_at and (' \n| ' .. first_difference(expected_str, actual_str)) or ''
    result_table:insert(' \n| ', name, ' \n| ', formatting(expected_str),
    	' \n| ', formatting(actual_str), differs_at, "\n|-\n")
end

function UnitTester:iterate(examples, func)
	require 'libraryUtil'.checkType('iterate', 1, examples, 'table')
	if type(func) == 'string' then
		func = self[func]
	elseif type(func) ~= 'function' then
		error(("bad argument #2 to 'iterate' (expected function or string, got %s)")
			:format(type(func)), 2)
	end

	for i, example in ipairs(examples) do
		if type(example) == 'table' then
			func(self, unpack(example))
		elseif type(example) == 'string' then
			self:heading(example)
		else
			error(('bad example #%d (expected table, got %s)')
				:format(i, type(example)), 2)
		end
	end
end

function UnitTester:heading(text)
	result_table:insert_format(' ! colspan="%u" style="text-align: left" | %s \n |- \n ',
		self.columns, text)
end

function UnitTester:run(frame_arg)
    frame = frame_arg
    self.frame = frame
    self.differs_at = frame.args['differs_at']
    tick = frame:preprocess('{{Tick}}')
    cross = frame:preprocess('{{Cross}}')

	local table_header = result_table_header
	if frame.args['live_sandbox'] then
		table_header = result_table_live_sandbox_header
	end
	if frame.args.highlight then
		should_highlight = true
	end

	self.columns = 4
    if self.differs_at then
        table_header = table_header .. ' !! Khác nhau tại'
        self.columns = self.columns + 1
    end

    -- Sort results into alphabetical order.
    local self_sorted = {}
    for key, _ in pairs(self) do
        if key:find('^test') then
            table.insert(self_sorted, key)
        end
    end
    table.sort(self_sorted)
    -- Add results to the results table.
    for _, value in ipairs(self_sorted) do
        result_table:insert_format(table_header .. "\n|-\n", value)
        self[value](self)
        result_table:insert("|}\n")
    end

    return (num_runs == 0 and "<b>No tests were run.</b>"
    	or num_failures == 0 and "<b style=\"color:#008000\">All " .. num_runs .. " tests passed.</b>"
    	or "<b style=\"color:#800000\">" .. num_failures .. " of " .. num_runs .. " tests failed.</b>[[Thể loại:Trường hợp kiểm thử Lua sử dụng Mô đun:UnitTests thất bại]]"
    ) .. "\n\n" .. frame:preprocess(result_table:concat())
end

function UnitTester:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local p = UnitTester:new()
function p.run_tests(frame) return p:run(frame) end
return p
