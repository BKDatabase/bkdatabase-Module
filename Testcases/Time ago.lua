-- Unit tests for [[Module:Time ago]]. Click talk page to run tests.
local p = require('Module:UnitTests')
local Date = require('Module:Date')._Date

local nowDateObj = Date('currentdate')
local dates = {
	nowDateObj - '18y',
	Date('July 1 2009'),
	nowDateObj - '4m' + '1d',
	Date('1 July 2049'),
}
local function checker(id, unit)
	-- id = 1, 2, ... : dates[id] is the wanted date
	-- unit = 'date', 'y', 'm', 'w', 'd', 'h'
	local dateObj = dates[id] or error('invalid id: ' .. tostring(id))
	if unit == 'date' then
		return dateObj:text()
	end
	local diff = nowDateObj - dateObj
	if unit == 'h' then
		return math.floor(diff.days_ago * 24)
	end
	return tostring(math.abs(diff:age(unit)))
end

function p:test_main()
	local lang = mw.language.getContentLanguage()

	-- Calculate the time since/until the test dates here, since the expected output is dependent on the current time in most cases.
	local currentTime = lang:formatDate( 'U' )
	local jul09 = currentTime - lang:formatDate( 'U', '1 July 2009' )
	local secondssincejul09 = math.floor( jul09 )
	local minutessincejul09 = math.floor( jul09 / 60 )
	local yearsuntilaug57 = math.floor( ( lang:formatDate ( 'U', '4 August 2057' ) - currentTime ) / 31557600 )

	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|'..checker(3, 'date')..'}}', checker(3, 'm') .. ' months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{CURRENTTIMESTAMP}}}}', '0 seconds ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|'..checker(3, 'date')..'|purge=yes}}', checker(3, 'm') .. ' months ago <span class="plainlinks">([//en.wikipedia.org/w/index.php?title=Module_talk:Time_ago/testcases&action=purge purge])</span>')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{CURRENTTIMESTAMP}}|purge=yes}}', '0 seconds ago <span class="plainlinks">([//en.wikipedia.org/w/index.php?title=Module_talk:Time_ago/testcases&action=purge purge])</span>')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009}}', checker(2, 'y') .. ' years ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=minutes}}', minutessincejul09 .. ' minutes ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=days}}', checker(2, 'd') .. ' days ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=weeks}}', checker(2, 'w') .. ' weeks ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=months}}', checker(2, 'm') .. ' months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2049|magnitude=months}}', checker(4, 'm') .. ' months\' time')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|Julio 1}}', '<strong class="error">Error: first parameter cannot be parsed as a date or time.</strong>')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=fruits}}', secondssincejul09 .. ' seconds ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main}}', '0 seconds ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=HoUrS}}', secondssincejul09 .. ' seconds ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|4 August 2057}}', yearsuntilaug57 .. ' years\' time')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|'..checker(3, 'date')..'|ago=in the past}}', checker(3, 'm') .. ' months in the past')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{CURRENTTIMESTAMP}}|min_magnitude=weeks}}', '0 weeks ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|'..checker(3, 'date')..'|ago=}}', checker(3, 'm') .. ' months')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -12 months -14 days}}|magnitude=months|spellout=yes}}', 'twelve months ago') -- #time always gives one month too few
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -12 months -14 days}}|magnitude=months|spellout=y}}', 'twelve months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -12 months -14 days}}|magnitude=months|spellout=y|spelloutmax=11}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -12 months -14 days}}|magnitude=months|spellout=auto}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -4 years -14 days}}|magnitude=years|spellout=auto}}', 'four years ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|July 1 2009|magnitude=weeks|spellout=yes}}', checker(2, 'w') .. ' weeks ago') -- [[Module:NumberSpell]] can only spell numbers up to 100.
	self:preprocess_equals_preprocess('{{#invoke:Time ago/sandbox|main|'..checker(1, 'date')..'|magnitude=days}}'  , checker(1, 'd')..' days ago')
	self:preprocess_equals_preprocess('{{#invoke:Time ago/sandbox|main|'..checker(1, 'date')..'|magnitude=weeks}}' , checker(1, 'w')..' weeks ago')
	self:preprocess_equals_preprocess('{{#invoke:Time ago/sandbox|main|'..checker(1, 'date')..'|magnitude=months}}', checker(1, 'm')..' months ago')
	self:preprocess_equals_preprocess('{{#invoke:Time ago/sandbox|main|'..checker(1, 'date')..'|magnitude=years}}' , checker(1, 'y')..' years ago')

	-- Testing whether the module is accurate on the day
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -10 years }}}}', '10 years ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -10 years -1 days}}}}', '10 years ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years }}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -1 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -2 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -3 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -4 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -5 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -6 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -7 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -8 days}}}}', '12 months ago')
	self:preprocess_equals('{{#invoke:Time ago/sandbox|main|{{#time: r | -1 years -8 days}}|numeric=y}}', '12')
end

return p