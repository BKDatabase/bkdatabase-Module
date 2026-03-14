-- Unit tests for [[Module:{{ROOTPAGENAME}}]]. Click talk page to run tests.
local p = require('Module:UnitTests')
local warning = require('Module:If preview')._warning
local main = require('Module:Check for deprecated parameters')._check
local sandbox = require('Module:Check for deprecated parameters/sandbox')._check

-- Remember to run the tests in preview mode! The test code, below, checks for preview correctness also

local function test(tester,fcn)
    tester:equals('Nothing deprecated',fcn({A1='B1',A2='B2',_category='C',preview='W'},
                               {A0='val'},'caller'),
                  '',{nowiki=1,stripmarkers=1})
    tester:equals('Simple',fcn({A1='B1',A2='B2',_category='C',preview='W'},
                               {A2='val'},'caller'),
                  'C'..warning({'W'}),{nowiki=1,stripmarkers=1})
    tester:equals('Simple with _VALUE_',fcn({A1='B1',A2='B2',_category='C _VALUE_',preview='W _VALUE_'},
                                            {A2='val'},'caller'),
                  'C A2'..warning({'W "A2". Replace with "B2".'}),{nowiki=1,stripmarkers=1})
    tester:equals('Remove',fcn({A1='B1',A2='B2',_category='C',preview='W',_remove='XX; A3; A4'},
                               {A3='val'},'caller'),
                  'C'..warning({'W'}),{nowiki=1,stripmarkers=1})
    tester:equals('Remove with _VALUE_',fcn({A1='B1',A2='B2',_category='C _VALUE_',preview='W _VALUE_',_remove='XX; A3; A4'},
                                            {A3='val'},'caller'),
                  'C A3'..warning({'W "A3". It should be removed.'}),{nowiki=1,stripmarkers=1})
    tester:equals('No preview',fcn({A1='B1',A2='B2',_category='C _VALUE_'},
                               {A2='val'},'caller'),
                  'C A2'..warning({'Page using [[caller]] with deprecated parameter "A2". Replace with "B2".'}),{nowiki=1,stripmarkers=1})
    tester:equals('Blank value',fcn({A1='B1',A2='B2',_category='C _VALUE_',preview='W'},
                               {A2='  '},'caller'),
                  'C A2'..warning({'W'}),{nowiki=1,stripmarkers=1})
    tester:equals('Blank value with ignoreblank',fcn({A1='B1',A2='B2',_category='C _VALUE_',preview='W',ignoreblank=1},
                               {A2='  '},'caller'),
                  '',{nowiki=1,stripmarkers=1})
end

function p:test_main()
    if main then
        test(p,main)
    end
end

function p:test_sandbox()
    if sandbox then
        test(p,sandbox)
    end
end

return p
