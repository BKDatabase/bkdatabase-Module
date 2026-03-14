-- we never call cs1 directly because it doesn't have a nice implementation
-- as a module, so comment out below line
-- local myModule = require('Module:Citation/CS1') -- the module to be tested
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

-- merge keys and values into one table
local function merge(t1, t2)
	local t3 = {}
	for k, v in pairs(t1) do
		t3[k] = v
	end
	for k, v in pairs(t2) do
		t3[k] = v
	end
	return t3
end

-- Finds the citeref in an expanded CS1/2 template. Takes a test_parameters
-- table and a specific template invoke's args. The test_parameters table has
-- the following fields:
-- * base_args, a table representing the template args common to the test case.
-- * pattern, a string to find in the expanded template
-- * frame, usually from mw.getCurrentFrame()
-- * template, a string which is the name of the template to test.
-- targs is a table of the template arguments unique to the specific assertion.
local function citeref(test_parameters, targs)
	
	local merged_args = merge(test_parameters.base_args, targs)
	local expansion = test_parameters.frame:expandTemplate{
		title = test_parameters.template, args = merged_args
	}
	
	local _, _, citeref_value = mw.ustring.find(expansion, test_parameters.pattern)
	if not citeref_value then
		citeref_value = ''
	end
	return citeref_value
end

-- Tests to ensure author masks don't corrupt the CITEREF
function suite:testAuthorMask()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_', year = '2020' }
	}
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {chapter = 'CH'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {['author-mask'] = 'A1'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {['author-mask1'] = '2'}))
end

-- Tests what happens with various counts of contributors, authors, and editors
function suite:testCounts()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', year = '2020' }
	}
	self:assertEquals( '', citeref(env, {chapter = 'CH'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {author = '_A1_'}))
	self:assertEquals( '', citeref(env, {contributor = 'C1'}))
	self:assertEquals( '', citeref(env, {contributor = 'C1', contribution = 'CON'}))
	self:assertEquals( 'CITEREF_E1_2020', citeref(env, {editor = '_E1_'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {author = '_A1_', contributor = '_C1_'}))
	self:assertEquals( 'CITEREF_C1_2020', citeref(env, {author = '_A1_', contributor = '_C1_', contribution = 'CON'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {author = '_A1_', editor = '_E1_'}))
	self:assertEquals( 'CITEREF_E1_2020', citeref(env, {editor = '_E1_', contributor = '_C1_'}))
	self:assertEquals( 'CITEREF_E1_2020', citeref(env, {editor = '_E1_', contributor = '_C1_', contribution = 'CON'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {author = '_A1_', contributor = '_C1_', editor = '_E1_'}))
	self:assertEquals( 'CITEREF_C1_2020', citeref(env, {author = '_A1_', contributor = '_C1_', editor = '_E1_', contribution = 'CON'}))
	self:assertEquals( 'CITEREF_A1_A2_A3_A4_2020', citeref(env, {author = '_A1_', author2 = 'A2_', author3 = 'A3_', author4 = 'A4_'}))
	self:assertEquals( 'CITEREF_A1_A2_A3_A4_2020', citeref(env, {author = '_A1_', author2 = 'A2_', author3 = 'A3_', author4 = 'A4_', author5 = 'A5_'}))
	self:assertEquals( 'CITEREF_C1_C2_C3_2020', citeref(env, {author = '_A1_', contributor = '_C1_', contributor2 = 'C2_', contributor3 = 'C3_', contribution = 'CON'}))
	self:assertEquals( 'CITEREF_E1_E2_2020', citeref(env, {editor = '_E1_', editor2 = 'E2_'}))
end

-- Tests date resolution code, including anchor years.
function suite:testDates()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_' }
	}
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {year='2020'}))
	self:assertEquals( 'CITEREF_A1_c\._2020', citeref(env, {date='c. 2020'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {date='1 January 2020'}))
	self:assertEquals( 'CITEREF_A1_2020a', citeref(env, {date='1 January 2020a'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {date='1 January 2020', year='2020'}))
	self:assertEquals( 'CITEREF_A1_2020a', citeref(env, {date='1 January 2020', year='2020a'}))
	self:assertEquals( 'CITEREF_A1_2020', citeref(env, {date='2020-01-01', year='2020'}))
	self:assertEquals( 'CITEREF_A1_2020a', citeref(env, {date='2020-01-01', year='2020a'}))
end

function suite:testDatesMaint()
	local frame = mw.getCurrentFrame()
	local base_args = {title = 'T', author = '_A1_', year = '2020'}
	local template = 'cite book/new'
	local maint = 'CS1 maint: date and year'
	
	self:assertStringContains(maint, frame:expandTemplate{
		title = template, args = merge(base_args, { date = '1 January 2020'})
	})
	self:assertStringContains(maint, frame:expandTemplate{
		title = template, args = merge(base_args, { date = '2020-01-01'})
	})
end

-- should fail: extra unexpected nd in the anchor, plus trailingauthordash below
-- TODO: Should that change? I've seen workarounds in the wild.
function suite:testDatesExtraNd()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_' }
	}
	
	self:assertEquals( 'CITEREF_A1_', citeref(env, {date='nd'}))
end

-- should fail: extra unexpected n.d. in the anchor
-- TODO: Should that change? I've seen workarounds in the wild.
function suite:testDatesExtraNdPunct()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_' }
	}
	self:assertEquals( 'CITEREF_A1_', citeref(env, {date='n.d.'}))
end

-- Tests to ensure display name settings don't corrupt the CITEREF
function suite:testDisplayNames()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_', author2 = 'A2_', date = '2020' }
	}
	self:assertEquals( 'CITEREF_A1_A2_2020', citeref(env, {chapter = 'CH'}))
	self:assertEquals( 'CITEREF_A1_A2_2020', citeref(env, {['display-authors'] = '0'}))
	self:assertEquals( 'CITEREF_A1_A2_2020', citeref(env, {['display-authors'] = '1'}))
	self:assertEquals( 'CITEREF_A1_A2_2020', citeref(env, {['display-authors'] = 'etal'}))
end

-- Tests what happens for certain values of ref
function suite:testRef()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = '(id=\"CITEREF%S-\")',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_', year = '2020' }
	}
	-- TODO test citation for equivalent value
	self:assertEquals( 'id=\"CITEREF_A1_2020\"', citeref(env, {chapter = 'CH'}))
	self:assertEquals( '', citeref(env, {ref = 'none'}))
	self:assertEquals( 'id=\"CITEREF_A1_2020\"', citeref(env, {ref = 'CITEREF_A1_2020'}))

end

-- slightly different setup; we want to test that the input ID is the output ID
function suite:testRefREF()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = '(id=\"REF\")',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_', year = '2020' }
	}
	self:assertEquals( 'id=\"REF\"', citeref(env, {ref = 'REF'}))
end

-- tests for expected presence of maintenance messages in ref
function suite:testRefMaint()
	local frame = mw.getCurrentFrame()
	local base_args = {title = 'T', author = '_A1_', date = '2020'}
	
	self:assertStringContains('CS1 maint: ref duplicates default', frame:expandTemplate{
		title = 'cite book/new', args = merge(base_args, { ref = 'CITEREF_A1_2020'})
	})
	self:assertStringContains('Invalid <code class=\"cs1%-code\">&#124;ref=harv</code>', frame:expandTemplate{
		title = 'cite book/new', args = merge(base_args, { ref = 'harv'})
	})
end

-- should fail: missing trailing underscore in anchor; not sure if that's desirable
-- or if that can change
-- TODO: Ask someone.
function suite:testTrailingAuthorDash()
	local env = {
		frame = mw.getCurrentFrame(),
		pattern = 'id=\"(CITEREF%S-)\"',
		template = 'cite book/new',
		base_args = { title = 'T', author = '_A1_' }
	}
	self:assertEquals( 'CITEREF_A1_', citeref(env, {chapter='CH'}))
end

return suite
