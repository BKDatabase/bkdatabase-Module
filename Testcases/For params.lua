-- Unit tests for [[Module:For params]]. Click talk page to run tests.
local p = {}
local TableTools = require('Module:TableTools')

local tests = {
	-- Unnamed parameters only
	{
		name = 'Basic',
		args = {'<nowiki>{{{1}}}</nowiki>'},
		parentArgs = {'A', 'B', 'C'}
	},
	{
		name = 'No parent args',
		args = {'<nowiki>{{{1}}}</nowiki>'},
		parentArgs = {}
	},
	{
		name = 'Separator',
		args = {'<nowiki>{{{1}}}</nowiki>', sep = '{{sp}}+{{sp}}'},
		parentArgs = {'A', 'B', 'C'}
	},
	{
		name = 'Whitespace separator',
		args = {'<nowiki>* {{{1}}}</nowiki>', '\n'},
		parentArgs = {'A', 'B', 'C'}
	},
	{
		name = 'Conjunction',
		args = {'<nowiki>{{{1}}}</nowiki>', ' + ', conj = '{{sp}}={{sp}}'},
		parentArgs = {'A', 'B', 'C'}
	},
	{
		name = 'Start',
		args = {'<nowiki>{{{i}}} = {{{1}}}</nowiki>', ', ', start = 3},
		parentArgs = {'A', 'B', 'C', 'D', 'E'}
	},
	{
		name = 'Fixed',
		args = {'<nowiki>{{{1}}}{{{suffix}}}</nowiki>', ' + ', fixed = 'suffix'},
		parentArgs = {'A', 'B', 'C', suffix = 'i'}
	},
	{
		name = 'Sparse',
		args = {'<nowiki>{{{i}}} = {{{1}}}</nowiki>', ', ', sparse = 'y'},
		parentArgs = {'A', 'B', 'C', 'D', [1000] = 'E'}
	},
	{
		name = 'Sparse and start',
		args = {'<nowiki>{{{i}}} = {{{1}}}</nowiki>', start = 3, ', ', sparse = 'y'},
		parentArgs = {'A', 'B', 'C', 'D', [1000] = 'E'}
	},
	{
		name = 'No index',
		args = {'<nowiki>{{{i}}} should not be substituted</nowiki>.', ' ', noindex = 'y'},
		parentArgs = {'A', 'B', 'C'}
	},
	-- Prefixed parameters
	{
		name = 'Prefix',
		args = {'<nowiki>{{{var}}}</nowiki>', ' + ', prefix = 'var'},
		parentArgs = {var1 = 'A', var2 = 'B', var3 = 'C'}
	},
	{
		name = 'No first number',
		args = {'<nowiki>{{{var}}}</nowiki>', ' + ', prefix = 'var'},
		parentArgs = {var = 'A', var2 = 'B', var3 = 'C'}
	},
	{
		name = 'First number required',
		args = {'<nowiki>{{{var}}}</nowiki>', ' + ', prefix = 'var', optnum = 'n'},
		parentArgs = {var = 'A', var2 = 'B', var3 = 'C'}
	},
	{
		name = 'Sparse prefix',
		args = {'<nowiki>{{{var}}}</nowiki>', ' + ', prefix = 'var', sparse = 'y'},
		parentArgs = {var1 = 'A', var2 = 'B', var30 = 'C'}
	},
	{
		name = 'Sparse no number first',
		args = {'<nowiki>{{{var}}}</nowiki>', ' + ', prefix = 'var', sparse = 'y'},
		parentArgs = {var = 'A', var2 = 'B', var30 = 'C'}
	},
	{
		name = 'Sparse first number required',
		args = {'<nowiki>{{{var}}}</nowiki>', ' + ', prefix = 'var', sparse = 'y', optnum = 'n'},
		parentArgs = {var = 'A', var2 = 'B', var30 = 'C'}
	},
	-- Suffixed parameters
	{
		name = 'Suffix',
		args = {'<nowiki>{{{variable}}}</nowiki>', ' + ', prefix = 'var', suffix = 'iable'},
		parentArgs = {var1iable = 'A', var2iable = 'B', var3iable = 'C'}
	},
	{
		name = 'Suffix no first number',
		args = {'<nowiki>{{{variable}}}</nowiki>', ' + ', prefix = 'var', suffix = 'iable'},
		parentArgs = {variable = 'A', var2iable = 'B', var3iable = 'C'}
	},
	{
		name = 'Suffix first number required',
		args = {'<nowiki>{{{variable}}}</nowiki>', ' + ', prefix = 'var', suffix = 'iable', optnum = 'n'},
		parentArgs = {variable = 'A', var2iable = 'B', var3iable = 'C'}
	},
	{
		name = 'Sparse suffix',
		args = {'<nowiki>{{{variable}}}</nowiki>', ' + ', prefix = 'var', suffix = 'iable', sparse = 'y'},
		parentArgs = {var1iable = 'A', var2iable = 'B', var30iable = 'C'}
	},
	{
		name = 'Sparse suffix no number first',
		args = {'<nowiki>{{{variable}}}</nowiki>', ' + ', prefix = 'var', suffix = 'iable', sparse = 'y'},
		parentArgs = {variable = 'A', var2iable = 'B', var30iable = 'C'}
	},
	{
		name = 'Sparse suffix first number required',
		args = {'<nowiki>{{{variable}}}</nowiki>', ' + ', prefix = 'var', suffix = 'iable', sparse = 'y', optnum = 'n'},
		parentArgs = {variable = 'A', var2iable = 'B', var30iable = 'C'}
	},
	{
		name = 'Suffix only, unset prefix',
		args = {'<nowiki>{{{item}}}</nowiki>', ' + ', suffix = 'item'},
		parentArgs = {['1item'] = 'A', ['2item'] = 'B', ['3item'] = 'C'}
	},
	{
		name = 'Suffix only, blank prefix',
		args = {'<nowiki>{{{item}}}</nowiki>', ' + ', prefix = '', suffix = 'item'},
		parentArgs = {['1item'] = 'A', ['2item'] = 'B', ['3item'] = 'C'}
	},
	-- Multiple prefixes
	{
		name = 'Multiple prefixes',
		args = {
			"<nowiki>{{{i}}}{{#if:{{{header|}}}|{{sp}}('''{{{header}}}''')}} = {{{item|''No item''}}}</nowiki>",
			prefix1 = 'item', prefix2 = 'header', ', ', sparse = 'n'
		},
		parentArgs = {item1 = 'ITM1', header1 = 'HDR1', item2 = 'ITM2', header3 = 'HDR3', item100 = 'Ignored'}
	},
	{
		name = 'Multiple prefixes sparse',
		args = {
			"<nowiki>{{{i}}}{{#if:{{{header|}}}|{{sp}}('''{{{header}}}''')}} = {{{item|''No item''}}}</nowiki>",
			prefix1 = 'item', prefix2 = 'header', ', ', sparse = 'y'
		},
		parentArgs = {item3 = 'ITM3', header3 = 'HDR3', item4 = 'ITM4', header5 = 'HDR5', item100 = 'ITM100'}
	},
	{
		name = 'Multiple prefixes with suffix',
		args = {
			"<nowiki>{{{person|{{{person_name|}}}}}}</nowiki>",
			prefix1 = 'person', prefix2 = 'person', suffix2 = '_name', ', ', conj = ', and&#32;'
		},
		parentArgs = {person1 = 'Mr. 1', person1_name = 'Ignored', person2 = 'Ms. 2', person3_name = 'Ms. 3', person100 = 'Ignored'}
	},
	{
		name = 'Multiple prefixes with suffix sparse',
		args = {
			"<nowiki>{{{person|{{{person_name|}}}}}}</nowiki>",
			prefix1 = 'person', prefix2 = 'person', suffix2 = '_name', ', ', conj = ', and&#32;', sparse = 'y'
		},
		parentArgs = {person3 = 'Mr. 3', person3_name = 'Ignored', person4 = 'Ms. 4', person5_name = 'Ms. 5', person100 = 'Mr. 100'}
	},
	-- Extra
	{
		name = 'Prefix extra',
		args = {
			"<nowiki>{{{i}}}{{#if:{{{header|}}}|{{sp}}('''{{{header}}}''')}} = {{{item}}}</nowiki>",
			prefix = 'item', extra = 'header', ', '
		},
		parentArgs = {item1 = 'ITM1', header1 = 'HDR1', item2 = 'ITM2', header3 = 'Ignored'}
	},
	{
		name = 'Multiple extras',
		args = {
			"<nowiki>''{{{name}}}'': Born: {{{born|Unknown}}}, Died: {{{died|N/A}}}</nowiki>",
			prefix = 'name', extra1 = 'born', extra2 = 'died', '<br>'
		},
		parentArgs = {
			name = 'James', born = '1905', died = '1982',
			name2 = 'Bob', born2 = '2000',
			name3 = 'John', died3 = '2012',
			name4 = 'Ryan'
		}
	},
	{
		name = 'Multiple extras with suffix',
		args = {
			"<nowiki>''{{{person_name}}}'': Born: {{{person_born|Unknown}}}, Died: {{{person_died|N/A}}}</nowiki>",
			prefix = 'person', suffix = '_name',
			extra1 = 'person', extrasuffix1 = '_born',
			extra2 = 'person', extrasuffix2 = '_died',
			'<br>'
		},
		parentArgs = {
			person1_name = 'James', person1_born = '1905', person1_died = '1982',
			person2_name = 'Bob', person2_born = '2000',
			person3_name = 'John', person3_died = '2012',
			person4_name = 'Ryan'
		}
	},
	{
		name = 'Multiple extras with suffix using opt num',
		args = {
			"<nowiki>''{{{person_name}}}'': Born: {{{person_born|Unknown}}}, Died: {{{person_died|N/A}}}</nowiki>",
			prefix = 'person', suffix = '_name',
			extra1 = 'person', extrasuffix1 = '_born',
			extra2 = 'person', extrasuffix2 = '_died',
			'<br>'
		},
		parentArgs = {
			person_name = 'James', person_born = '1905', person_died = '1982',
			person2_name = 'Bob', person2_born = '2000',
			person3_name = 'John', person3_died = '2012',
			person4_name = 'Ryan'
		}
	},
	-- Call
	{
		name = 'Call',
		args = {call = '2x'},
		parentArgs = {'A', 'B', 'C'}
	},
	{
		name = 'Call and whitespace separator',
		args = {call = '2x', ' & '},
		parentArgs = {'A', 'B', 'C'}
	},
	-- Wikitext parsing
	{
		name = '&#123;&#123;&#123;|default&#125;&#125;&#125;',
		args = {'<nowiki>{{{|default}}}</nowiki>'},
		parentArgs = {'A'}
	},
	{
		name = 'Doesn\'t over-parse',
		args = {'<nowiki>{{{1}}}</nowiki>'},
		parentArgs = {'{{1x|Should be unparsed}}'}
	},
}

local function joinArgs(args)
	local res = ''
	
	for k, v in TableTools.sortedPairs(args) do
		res = res .. '|' .. (type(k) ~= 'number' and k .. '=' or '') .. v
	end
	
	return res
end

function p.test(frame)
	local out = ''
	
	for _, cfg in ipairs(tests) do
		out = out .. '==' .. cfg.name .. '==\n'
		
		local paramsStr = joinArgs(cfg.args)
		local parentParamsStr = joinArgs(cfg.parentArgs)
		local sourceCode = '{{#invoke:For params|main' .. paramsStr .. '}}'
		
		out = out .. frame:callParserFunction(
			'#tag',
			{'syntaxhighlight', sourceCode, lang = 'wikitext'}
		) .. '\n'

		out = out .. frame:callParserFunction(
			'#tag',
			{'syntaxhighlight', '{{_TEMPLATE_' .. parentParamsStr .. '}}', lang = 'wikitext'}
		) .. '\n'

		cfg.parentArgs.sourceCode = sourceCode
		local liveRes = frame:expandTemplate{
			title = 'Template:Call wikitext',
			args = cfg.parentArgs
		}
		out = out .. "<p>'''Live'''<br>" .. (liveRes ~= '' and liveRes or "''No output''") .. "</p>" .. '\n'

		cfg.parentArgs.sourceCode = '{{#invoke:For params/sandbox|main' .. paramsStr .. '}}'
		local sandboxRes = frame:expandTemplate{
			title = 'Template:Call wikitext',
			args = cfg.parentArgs
		}
		out = out .. "<p>'''Sandbox'''<br>" .. (sandboxRes ~= '' and sandboxRes or "''No output''") .. "</p>" .. '\n'
	end
	
	return out
end

return p
