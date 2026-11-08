--------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Unit tests for [[Module:Userbox/sandbox]]. Click talk page to run tests.
local ubx = require('Module:Userbox')
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit.new()

local userbox = ubx['_userbox']
local userbox2 = ubx['_userbox-2']
local userboxr = ubx['_userbox-r']
local render = ubx.render
local categories = ubx.categories

--------------------------------------------------------------------------------
-- Sandbox run
--------------------------------------------------------------------------------

function suite.runSandbox(...)
	ubx = require('Module:Userbox/sandbox')
	userbox = ubx['_userbox']
	userbox2 = ubx['_userbox-2']
	userboxr = ubx['_userbox-r']
	render = ubx.render
	categories = ubx.categories
	return suite.run(...)
end

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------

local function inTag(s, tag)
	-- Makes a pattern that tests whether s is inside a given html tag.
	return '<' .. tag .. ' [^>]-' .. s
end

local function inAttr(s, attr)
	-- Makes a pattern that tests whether s is inside a given html attribute.
	return attr .. '="[^"]-' .. s
end

local function inTagAttr(s, tag, attr)
	-- Makes a pattern that tests whether s is inside a given html tag
	-- and a given html attribute.
	return inTag(inAttr(s, attr), tag)
end

local function renderId(data)
	data.showId = true
	return render(data)
end

local function renderId2(data)
	data.showId2 = true
	return render(data)
end

--------------------------------------------------------------------------------
-- Render tests
--------------------------------------------------------------------------------

function suite:testRenderFloat()
    self:assertStringContains(inTagAttr('float:right', 'div', 'style'), render{float = 'right'})
end

function suite:testRenderBorder()
    self:assertStringContains(inTagAttr('border%-width:5px', 'div', 'style'), render{borderWidth = '5px'})
    self:assertStringContains(inTagAttr('border%-color:red', 'div', 'style'), render{borderColor='red'})
    self:assertStringContains(inTagAttr('border%-style:solid', 'div', 'style'), render{borderColor='red'})
end

function suite:testRenderWidth()
    self:assertStringContains(inTagAttr('width:120px', 'div', 'style'), render{width = '120px'})
end

function suite:testRenderUserboxClass()
    self:assertStringContains(inTagAttr('wikipediauserbox', 'div', 'class'), render{})
end

function suite:testRenderBodyClass()
    self:assertStringContains(inTagAttr('foobar', 'div', 'class'), render{bodyClass = 'foobar'})
end

function suite:testRenderBorderCollapse()
    self:assertStringContains(inTagAttr('width:120px', 'table', 'style'), render{width = '120px'})
end

function suite:testRenderTableWidth()
    self:assertStringContains(inTagAttr('width:120px', 'table', 'style'), render{width = '120px'})
end

function suite:testRenderBackgroundColor()
    self:assertStringContains(inTagAttr('background:red', 'table', 'style'), render{backgroundColor = 'red'})
end

--------------------------------------------------------------------------------
-- Render id tests
--------------------------------------------------------------------------------

function suite:testRenderIdWidth()
    self:assertStringContains(inTagAttr('width:50px', 'td', 'style'), renderId{idWidth = '50px'})
end

function suite:testRenderIdHeight()
    self:assertStringContains(inTagAttr('height:50px', 'td', 'style'), renderId{idHeight = '50px'})
end

function suite:testRenderIdBackgroundColor()
    self:assertStringContains(inTagAttr('background:red', 'td', 'style'), renderId{idBackgroundColor = 'red'})
end

function suite:testRenderIdTextAlign()
    self:assertStringContains(inTagAttr('text%-align:center', 'td', 'style'), renderId{idTextAlign = 'center'})
end

function suite:testRenderIdFontSize()
    self:assertStringContains(inTagAttr('font%-size:16pt', 'td', 'style'), renderId{idFontSize = 16})
end

function suite:testRenderIdColor()
    self:assertStringContains(inTagAttr('color:blue', 'td', 'style'), renderId{idColor = 'blue'})
end

function suite:testRenderIdPadding()
    self:assertStringContains(inTagAttr('padding:3px', 'td', 'style'), renderId{idPadding = '3px'})
end

function suite:testRenderIdLineHeight()
    self:assertStringContains(inTagAttr('line%-height:1.5em', 'td', 'style'), renderId{idLineHeight = '1.5em'})
end

function suite:testRenderIdOtherParams()
    self:assertStringContains(inTagAttr('font%-family:serif', 'td', 'style'), renderId{idOtherParams = 'font-family:serif'})
end

function suite:testRenderIdClass()
    self:assertStringContains(inTagAttr('foobar', 'td', 'class'), renderId{idClass = 'foobar'})
end

function suite:testRenderId()
    self:assertStringContains('<td[^>]->Id text.</td>', renderId{id = 'Id text.'})
end

--------------------------------------------------------------------------------
-- Render info tests
--------------------------------------------------------------------------------

function suite:testRenderInfoTextAlign()
    self:assertStringContains(inTagAttr('text%-align:center', 'td', 'style'), render{infoTextAlign = 'center'})
end

function suite:testRenderInfoFontSize()
    self:assertStringContains(inTagAttr('font%-size:16pt', 'td', 'style'), render{infoFontSize = '16pt'})
end

function suite:testRenderInfoPadding()
    self:assertStringContains(inTagAttr('padding:3px', 'td', 'style'), render{infoPadding = '3px'})
end

function suite:testRenderInfoHeight()
    self:assertStringContains(inTagAttr('height:50px', 'td', 'style'), render{infoHeight = '50px'})
end

function suite:testRenderInfoLineHeight()
    self:assertStringContains(inTagAttr('line%-height:1.5em', 'td', 'style'), render{infoLineHeight = '1.5em'})
end

function suite:testRenderInfoColor()
    self:assertStringContains(inTagAttr('color:blue', 'td', 'style'), render{infoColor = 'blue'})
end

function suite:testRenderInfoOtherParams()
    self:assertStringContains(inTagAttr('font%-family:serif', 'td', 'style'), render{infoOtherParams = 'font-family:serif'})
end

function suite:testRenderInfoClass()
    self:assertStringContains(inTagAttr('foobar', 'td', 'class'), render{infoClass = 'foobar'})
end

function suite:testRenderInfo()
    self:assertStringContains('<td[^>]->Info text.</td>', render{info = 'Info text.'})
end

--------------------------------------------------------------------------------
-- Render id2 tests
--------------------------------------------------------------------------------

function suite:testRenderId2Width()
    self:assertStringContains(inTagAttr('width:50px', 'td', 'style'), renderId2{id2Width = '50px'})
end

function suite:testRenderId2Height()
    self:assertStringContains(inTagAttr('height:50px', 'td', 'style'), renderId2{id2Height = '50px'})
end

function suite:testRenderId2BackgroundColor()
    self:assertStringContains(inTagAttr('background:red', 'td', 'style'), renderId2{id2BackgroundColor = 'red'})
end

function suite:testRenderId2TextAlign()
    self:assertStringContains(inTagAttr('text%-align:center', 'td', 'style'), renderId2{id2TextAlign = 'center'})
end

function suite:testRenderId2FontSize()
    self:assertStringContains(inTagAttr('font%-size:16pt', 'td', 'style'), renderId2{id2FontSize = 16})
end

function suite:testRenderId2Color()
    self:assertStringContains(inTagAttr('color:blue', 'td', 'style'), renderId2{id2Color = 'blue'})
end

function suite:testRenderId2Padding()
    self:assertStringContains(inTagAttr('padding:3px', 'td', 'style'), renderId2{id2Padding = '3px'})
end

function suite:testRenderId2LineHeight()
    self:assertStringContains(inTagAttr('line%-height:1.5em', 'td', 'style'), renderId2{id2LineHeight = '1.5em'})
end

function suite:testRenderId2OtherParams()
    self:assertStringContains(inTagAttr('font%-family:serif', 'td', 'style'), renderId2{id2OtherParams = 'font-family:serif'})
end

function suite:testRenderId2()
    self:assertStringContains('<td[^>]->Id2 text.</td>', renderId2{id2 = 'Id2 text.'})
end

--------------------------------------------------------------------------------
-- Userbox div and table tag tests
--------------------------------------------------------------------------------

function suite:testUserboxFloat()
    self:assertEquals(nil, userbox{}.float)
    self:assertEquals('right', userbox{float = 'right'}.float)
end

function suite:testUserboxBorderWidth()
    self:assertEquals(nil, userbox{}.borderWidth)
    self:assertEquals('2px', userbox{['border-width'] = '2'}.borderWidth)
    self:assertEquals('3px', userbox{['border-s'] = '3'}.borderWidth)
end

function suite:testUserboxBorderColor()
    self:assertEquals(nil, userbox{}.borderColor)
    self:assertEquals('red', userbox{['border-color'] = 'red'}.borderColor)
    self:assertEquals('yellow', userbox{[1] = 'yellow'}.borderColor)
    self:assertEquals('blue', userbox{['border-c'] = 'blue'}.borderColor)
    self:assertEquals('green', userbox{['id-c'] = 'green'}.borderColor)
end

function suite:testUserboxWidth()
    self:assertEquals(nil, userbox{}.width)
    self:assertEquals('236px', userbox{['border-s'] = '2'}.width)
end

function suite:testUserboxBodyClass()
    self:assertEquals(nil, userbox{}.bodyClass)
    self:assertEquals('foobar', userbox{bodyclass = 'foobar'}.bodyClass)
end

function suite:testUserboxBackgroundColor()
    self:assertEquals(nil, userbox{}.backgroundColor)
    self:assertEquals('red', userbox{['info-background'] = 'red'}.backgroundColor)
    self:assertEquals('yellow', userbox{[2] = 'yellow'}.backgroundColor)
    self:assertEquals('blue', userbox{['info-c'] = 'blue'}.backgroundColor)
end

--------------------------------------------------------------------------------
-- Userbox id tests
--------------------------------------------------------------------------------

function suite:testUserboxId()
    self:assertEquals(nil, userbox{}.id)
    self:assertEquals('Id text.', userbox{logo = 'Id text.'}.id)
    self:assertEquals('More id text.', userbox{[3] = 'More id text.'}.id)
    self:assertEquals('Even more id text.', userbox{id = 'Even more id text.'}.id)
end

function suite:testUserboxShowId()
    self:assertEquals(true, userbox{id = 'Id text.'}.showId)
    self:assertEquals(false, userbox{}.showId)
end

function suite:testUserboxIdWidth()
    self:assertEquals(nil, userbox{}.idWidth)
    self:assertEquals('50px', userbox{['logo-width'] = '50'}.idWidth)
    self:assertEquals('55px', userbox{['id-w'] = '55'}.idWidth)
end

function suite:testUserboxIdHeight()
    self:assertEquals(nil, userbox{}.idHeight)
    self:assertEquals('50px', userbox{['logo-height'] = '50'}.idHeight)
    self:assertEquals('55px', userbox{['id-h'] = '55'}.idHeight)
end

function suite:testUserboxIdBackgroundColor()
    self:assertEquals(nil, userbox{}.idBackgroundColor)
    self:assertEquals('red', userbox{['logo-background'] = 'red'}.idBackgroundColor)
    self:assertEquals('yellow', userbox{[1] = 'yellow'}.idBackgroundColor)
    self:assertEquals('blue', userbox{['id-c'] = 'blue'}.idBackgroundColor)
end

function suite:testUserboxIdTextAlign()
    self:assertEquals(nil, userbox{}.idTextAlign)
    self:assertEquals('right', userbox{['id-a'] = 'right'}.idTextAlign)
end

function suite:testUserboxIdFontSize()
    self:assertEquals(nil, userbox{}.idFontSize)
    self:assertEquals(16, userbox{['logo-size'] = '16'}.idFontSize)
    self:assertEquals(18, userbox{[5] = '18'}.idFontSize)
    self:assertEquals(20, userbox{['id-s'] = '20'}.idFontSize)
end

function suite:testUserboxIdColor()
    self:assertEquals(nil, userbox{}.idColor)
    self:assertEquals('red', userbox{['logo-color'] = 'red'}.idColor)
    self:assertEquals('blue', userbox{['id-fc'] = 'blue'}.idColor)
end

function suite:testUserboxIdPadding()
    self:assertEquals(nil, userbox{}.idPadding)
    self:assertEquals('1px 1px 1px 1px', userbox{['logo-padding'] = '1px 1px 1px 1px'}.idPadding)
    self:assertEquals('2px 2px 2px 2px', userbox{['id-p'] = '2px 2px 2px 2px'}.idPadding)
end

function suite:testUserboxIdLineHeight()
    self:assertEquals(nil, userbox{}.idLineHeight)
    self:assertEquals('1.5em', userbox{['logo-line-height'] = '1.5em'}.idLineHeight)
    self:assertEquals('1.75em', userbox{['id-lh'] = '1.75em'}.idLineHeight)
end

function suite:testUserboxIdOtherParams()
    self:assertEquals(nil, userbox{}.idOtherParams)
    self:assertEquals('font-family:serif', userbox{['logo-other-param'] = 'font-family:serif'}.idOtherParams)
    self:assertEquals('font-family:times', userbox{['id-op'] = 'font-family:times'}.idOtherParams)
end

function suite:testUserboxIdClass()
    self:assertEquals(nil, userbox{}.idClass)
    self:assertEquals('foobar', userbox{['id-class'] = 'foobar'}.idClass)
end

--------------------------------------------------------------------------------
-- Userbox info tests
--------------------------------------------------------------------------------

function suite:testUserboxInfo()
    self:assertEquals("<code>{{{info}}}</code>", userbox{}.info)
    self:assertEquals('Info text.', userbox{info = 'Info text.'}.info)
    self:assertEquals('More info text.', userbox{[4] = 'More info text.'}.info)
end

function suite:testUserboxInfoTextAlign()
    self:assertEquals(nil, userbox{}.infoTextAlign)
    self:assertEquals('right', userbox{['info-a'] = 'right'}.infoTextAlign)
end

function suite:testUserboxInfoFontSize()
    self:assertEquals(nil, userbox{}.infoFontSize)
    self:assertEquals('10pt', userbox{['info-size'] = 10}.infoFontSize)
    self:assertEquals('12pt', userbox{['info-s'] = 12}.infoFontSize)
end

function suite:testUserboxInfoHeight()
    self:assertEquals(nil, userbox{}.infoHeight)
    self:assertEquals('50px', userbox{['logo-height'] = '50'}.infoHeight)
    self:assertEquals('55px', userbox{['id-h'] = '55'}.infoHeight)
end

function suite:testUserboxInfoPadding()
    self:assertEquals(nil, userbox{}.infoPadding)
    self:assertEquals('1px 1px 1px 1px', userbox{['info-padding'] = '1px 1px 1px 1px'}.infoPadding)
    self:assertEquals('2px 2px 2px 2px', userbox{['info-p'] = '2px 2px 2px 2px'}.infoPadding)
end

function suite:testUserboxInfoLineHeight()
    self:assertEquals(nil, userbox{}.infoLineHeight)
    self:assertEquals('1.5em', userbox{['info-line-height'] = '1.5em'}.infoLineHeight)
    self:assertEquals('1.75em', userbox{['info-lh'] = '1.75em'}.infoLineHeight)
end

function suite:testUserboxInfoColor()
    self:assertEquals(nil, userbox{}.infoColor)
    self:assertEquals('red', userbox{['info-color'] = 'red'}.infoColor)
    self:assertEquals('blue', userbox{['info-fc'] = 'blue'}.infoColor)
end

function suite:testUserboxInfoOtherParams()
    self:assertEquals(nil, userbox{}.infoOtherParams)
    self:assertEquals('font-family:serif', userbox{['info-other-param'] = 'font-family:serif'}.infoOtherParams)
    self:assertEquals('font-family:times', userbox{['info-op'] = 'font-family:times'}.infoOtherParams)
end

function suite:testUserboxInfoClass()
    self:assertEquals(nil, userbox{}.infoClass)
    self:assertEquals('foobar', userbox{['info-class'] = 'foobar'}.infoClass)
end

--------------------------------------------------------------------------------
-- Userbox2 div and table tag tests
--------------------------------------------------------------------------------

function suite:testUserbox2Float()
    self:assertEquals(nil, userbox2{}.float)
    self:assertEquals('right', userbox2{float = 'right'}.float)
end

function suite:testUserbox2BorderWidth()
    self:assertEquals(nil, userbox2{}.borderWidth)
    self:assertEquals('2px', userbox2{[9] = '2'}.borderWidth)
    self:assertEquals('3px', userbox2{['border-s'] = '3'}.borderWidth)
end


function suite:testUserbox2BorderColor()
    self:assertEquals(nil, userbox2{}.borderColor)
    self:assertEquals('red', userbox2{[1] = 'red'}.borderColor)
    self:assertEquals('blue', userbox2{['border-c'] = 'blue'}.borderColor)
    self:assertEquals('green', userbox2{['id1-c'] = 'green'}.borderColor)
end


function suite:testUserbox2Width()
    self:assertEquals(nil, userbox2{}.width)
end

function suite:testUserbox2BodyClass()
    self:assertEquals(nil, userbox2{}.bodyClass)
    self:assertEquals('foobar', userbox2{bodyclass = 'foobar'}.bodyClass)
end

function suite:testUserbox2BackgroundColor()
    self:assertEquals(nil, userbox2{}.backgroundColor)
    self:assertEquals('yellow', userbox2{[2] = 'yellow'}.backgroundColor)
    self:assertEquals('blue', userbox2{['info-c'] = 'blue'}.backgroundColor)
end

--------------------------------------------------------------------------------
-- Userbox2 id tests
--------------------------------------------------------------------------------

function suite:testUserbox2Id()
    self:assertEquals('id1', userbox2{}.id)
    self:assertEquals('Id text.', userbox2{logo = 'Id text.'}.id)
    self:assertEquals('More id text.', userbox2{[3] = 'More id text.'}.id)
    self:assertEquals('Even more id text.', userbox2{id1 = 'Even more id text.'}.id)
end
function suite:testUserbox2ShowId()
    self:assertEquals(true, userbox2{}.showId)
end

function suite:testUserbox2IdWidth()
    self:assertEquals(nil, userbox2{}.idWidth)
    self:assertEquals('50px', userbox2{['id1-w'] = '50'}.idWidth)
end

function suite:testUserbox2IdHeight()
    self:assertEquals(nil, userbox2{}.idHeight)
    self:assertEquals('50px', userbox2{['id-h'] = '50'}.idHeight)
end

function suite:testUserbox2IdBackgroundColor()
    self:assertEquals(nil, userbox2{}.idBackgroundColor)
    self:assertEquals('yellow', userbox2{[1] = 'yellow'}.idBackgroundColor)
    self:assertEquals('blue', userbox2{['id1-c'] = 'blue'}.idBackgroundColor)
end

function suite:testUserbox2IdTextAlign()
    self:assertEquals(nil, userbox2{}.idTextAlign)
end

function suite:testUserbox2IdFontSize()
    self:assertEquals(nil, userbox2{}.idFontSize)
    self:assertEquals(16, userbox2{['id1-s'] = '16'}.idFontSize)
end

function suite:testUserbox2IdLineHeight()
    self:assertEquals(nil, userbox2{}.idLineHeight)
    self:assertEquals('1.5em', userbox2{['id1-lh'] = '1.5em'}.idLineHeight)
end

function suite:testUserbox2IdColor()
    self:assertEquals(nil, userbox2{}.idColor)
    self:assertEquals('blue', userbox2{['id1-fc'] = 'blue'}.idColor)
end

function suite:testUserbox2IdPadding()
    self:assertEquals(nil, userbox2{}.idPadding)
    self:assertEquals('1px 1px 1px 1px', userbox2{['id1-p'] = '1px 1px 1px 1px'}.idPadding)
end

function suite:testUserbox2IdOtherParams()
    self:assertEquals(nil, userbox2{}.idOtherParams)
    self:assertEquals('font-family:times', userbox2{['id1-op'] = 'font-family:times'}.idOtherParams)
end

--------------------------------------------------------------------------------
-- Userbox2 info tests
--------------------------------------------------------------------------------

function suite:testUserbox2Info()
    self:assertEquals("<code>{{{info}}}</code>", userbox2{}.info)
    self:assertEquals('Info text.', userbox2{[4] = 'Info text.'}.info)
    self:assertEquals('More info text.', userbox2{info = 'More info text.'}.info)
end

function suite:testUserbox2InfoTextAlign()
    self:assertEquals(nil, userbox2{}.infoTextAlign)
    self:assertEquals('right', userbox2{['info-a'] = 'right'}.infoTextAlign)
end

function suite:testUserbox2InfoFontSize()
    self:assertEquals(nil, userbox2{}.infoFontSize)
    self:assertEquals('10pt', userbox2{['info-s'] = '10'}.infoFontSize)
end

function suite:testUserbox2InfoColor()
    self:assertEquals(nil, userbox2{}.infoColor)
    self:assertEquals('red', userbox2{[8] = 'red'}.infoColor)
    self:assertEquals('blue', userbox2{['info-fc'] = 'blue'}.infoColor)
end

function suite:testUserbox2InfoPadding()
    self:assertEquals(nil, userbox2{}.infoPadding)
    self:assertEquals('1px 1px 1px 1px', userbox2{['info-p'] = '1px 1px 1px 1px'}.infoPadding)
end

function suite:testUserbox2InfoLineHeight()
    self:assertEquals(nil, userbox2{}.infoLineHeight)
    self:assertEquals('1.5em', userbox2{['info-lh'] = '1.5em'}.infoLineHeight)
end

function suite:testUserbox2InfoOtherParams()
    self:assertEquals(nil, userbox2{}.infoOtherParams)
    self:assertEquals('font-family:times', userbox2{['info-op'] = 'font-family:times'}.infoOtherParams)
end

--------------------------------------------------------------------------------
-- Userbox2 id2 tests
--------------------------------------------------------------------------------

function suite:testUserbox2Id2()
    self:assertEquals('id2', userbox2{}.id2)
    self:assertEquals('Id2 text.', userbox2{logo = 'Id2 text.'}.id2)
    self:assertEquals('More id2 text.', userbox2{[5] = 'More id2 text.'}.id2)
    self:assertEquals('Even more id2 text.', userbox2{id2 = 'Even more id2 text.'}.id2)
end

function suite:testUserbox2ShowId2()
    self:assertEquals(true, userbox2{}.showId2)
end

function suite:testUserbox2Id2Width()
    self:assertEquals(nil, userbox2{}.id2Width)
    self:assertEquals('50px', userbox2{['id2-w'] = '50'}.id2Width)
end

function suite:testUserbox2Id2Height()
    self:assertEquals(nil, userbox2{}.id2Height)
    self:assertEquals('50px', userbox2{['id-h'] = '50'}.id2Height)
end

function suite:testUserbox2Id2BackgroundColor()
    self:assertEquals(nil, userbox2{}.id2BackgroundColor)
    self:assertEquals('yellow', userbox2{[7] = 'yellow'}.id2BackgroundColor)
    self:assertEquals('blue', userbox2{['id2-c'] = 'blue'}.id2BackgroundColor)
    self:assertEquals('red', userbox2{[1] = 'red'}.id2BackgroundColor)
end

function suite:testUserbox2Id2TextAlign()
    self:assertEquals(nil, userbox2{}.id2TextAlign)
end

function suite:testUserbox2Id2FontSize()
    self:assertEquals(nil, userbox2{}.id2FontSize)
    self:assertEquals(16, userbox2{['id2-s'] = '16'}.id2FontSize)
end

function suite:testUserbox2Id2LineHeight()
    self:assertEquals(nil, userbox2{}.id2LineHeight)
    self:assertEquals('1.5em', userbox2{['id2-lh'] = '1.5em'}.id2LineHeight)
end

function suite:testUserbox2Id2Color()
    self:assertEquals(nil, userbox2{}.id2Color)
    self:assertEquals('blue', userbox2{['id2-fc'] = 'blue'}.id2Color)
end

function suite:testUserbox2Id2Padding()
    self:assertEquals(nil, userbox2{}.id2Padding)
    self:assertEquals('1px 1px 1px 1px', userbox2{['id2-p'] = '1px 1px 1px 1px'}.id2Padding)
end

function suite:testUserbox2Id2OtherParams()
    self:assertEquals(nil, userbox2{}.id2OtherParams)
    self:assertEquals('font-family:times', userbox2{['id2-op'] = 'font-family:times'}.id2OtherParams)
end

--------------------------------------------------------------------------------
-- Userboxr div and table tag tests
--------------------------------------------------------------------------------

function suite:testUserboxrFloat()
    self:assertEquals(nil, userboxr{}.float)
    self:assertEquals('right', userboxr{float = 'right'}.float)
end

function suite:testUserboxrBorderWidth()
    self:assertEquals(nil, userboxr{}.borderWidth)
    self:assertEquals('2px', userboxr{['border-width'] = '2'}.borderWidth)
    self:assertEquals('3px', userboxr{['border-s'] = '3'}.borderWidth)
end

function suite:testUserboxrBorderColor()
    self:assertEquals(nil, userboxr{}.borderColor)
    self:assertEquals('red', userboxr{['border-color'] = 'red'}.borderColor)
    self:assertEquals('yellow', userboxr{[1] = 'yellow'}.borderColor)
    self:assertEquals('blue', userboxr{['border-c'] = 'blue'}.borderColor)
    self:assertEquals('green', userboxr{['id-c'] = 'green'}.borderColor)
end


function suite:testUserboxrWidth()
    self:assertEquals(nil, userboxr{}.width)
end

function suite:testUserboxrBodyClass()
    self:assertEquals(nil, userboxr{}.bodyClass)
    self:assertEquals('foobar', userboxr{bodyclass = 'foobar'}.bodyClass)
end

function suite:testUserboxrBackgroundColor()
    self:assertEquals(nil, userboxr{}.backgroundColor)
    self:assertEquals('red', userboxr{['info-background'] = 'red'}.backgroundColor)
    self:assertEquals('yellow', userboxr{[2] = 'yellow'}.backgroundColor)
    self:assertEquals('blue', userboxr{['info-c'] = 'blue'}.backgroundColor)
end

--------------------------------------------------------------------------------
-- Userboxr info tests
--------------------------------------------------------------------------------

function suite:testUserboxrInfo()
    self:assertEquals("<code>{{{info}}}</code>", userboxr{}.info)
    self:assertEquals('Info text.', userboxr{info = 'Info text.'}.info)
    self:assertEquals('More info text.', userboxr{[4] = 'More info text.'}.info)
end
function suite:testUserboxrInfoTextAlign()
    self:assertEquals(nil, userboxr{}.infoTextAlign)
    self:assertEquals('right', userboxr{['info-align'] = 'right'}.infoTextAlign)
    self:assertEquals('center', userboxr{['info-a'] = 'center'}.infoTextAlign)
end

function suite:testUserboxrInfoFontSize()
    self:assertEquals(nil, userboxr{}.infoFontSize)
    self:assertEquals('10pt', userboxr{['info-size'] = '10'}.infoFontSize)
    self:assertEquals('12pt', userboxr{['info-s'] = '12'}.infoFontSize)
end


function suite:testUserboxrInfoPadding()
    self:assertEquals(nil, userboxr{}.infoPadding)
    self:assertEquals('1px 1px 1px 1px', userboxr{['info-padding'] = '1px 1px 1px 1px'}.infoPadding)
    self:assertEquals('2px 2px 2px 2px', userboxr{['info-p'] = '2px 2px 2px 2px'}.infoPadding)
end

function suite:testUserboxrInfoLineHeight()
    self:assertEquals(nil, userboxr{}.infoLineHeight)
    self:assertEquals('1.5em', userboxr{['info-line-height'] = '1.5em'}.infoLineHeight)
    self:assertEquals('1.75em', userboxr{['info-lh'] = '1.75em'}.infoLineHeight)
end


function suite:testUserboxrInfoColor()
    self:assertEquals(nil, userboxr{}.infoColor)
    self:assertEquals('red', userboxr{['info-color'] = 'red'}.infoColor)
    self:assertEquals('blue', userboxr{['info-fc'] = 'blue'}.infoColor)
end

function suite:testUserboxrInfoOtherParams()
    self:assertEquals(nil, userboxr{}.infoOtherParams)
    self:assertEquals('font-family:serif', userboxr{['info-other-param'] = 'font-family:serif'}.infoOtherParams)
    self:assertEquals('font-family:times', userboxr{['info-op'] = 'font-family:times'}.infoOtherParams)
end

--------------------------------------------------------------------------------
-- Userboxr id2 tests
--------------------------------------------------------------------------------

function suite:testUserboxrId2()
    self:assertEquals('id', userboxr{}.id2)
    self:assertEquals('Id text.', userboxr{logo = 'Id text.'}.id2)
    self:assertEquals('More id text.', userboxr{[3] = 'More id text.'}.id2)
    self:assertEquals('Even more id text.', userboxr{id = 'Even more id text.'}.id2)
end


function suite:testUserboxrShowId()
    self:assertEquals(true, userboxr{}.showId2)
end

function suite:testUserboxrId2Width()
    self:assertEquals(nil, userboxr{}.id2Width)
    self:assertEquals('50px', userboxr{['logo-width'] = '50'}.id2Width)
    self:assertEquals('55px', userboxr{['id-w'] = '55'}.id2Width)
end

function suite:testUserboxrId2Height()
    self:assertEquals(nil, userboxr{}.id2Height)
    self:assertEquals('50px', userboxr{['logo-height'] = '50'}.id2Height)
    self:assertEquals('55px', userboxr{['id-h'] = '55'}.id2Height)
end

function suite:testUserboxrId2BackgroundColor()
    self:assertEquals(nil, userboxr{}.id2BackgroundColor)
    self:assertEquals('red', userboxr{['logo-background'] = 'red'}.id2BackgroundColor)
    self:assertEquals('yellow', userboxr{[1] = 'yellow'}.id2BackgroundColor)
    self:assertEquals('blue', userboxr{['id-c'] = 'blue'}.id2BackgroundColor)
end

function suite:testUserboxrId2TextAlign()
    self:assertEquals(nil, userboxr{}.id2TextAlign)
    self:assertEquals('right', userboxr{['id-a'] = 'right'}.id2TextAlign)
end

function suite:testUserboxrId2FontSize()
    self:assertEquals(nil, userboxr{}.id2FontSize)
    self:assertEquals(16, userboxr{['logo-size'] = '16'}.id2FontSize)
    self:assertEquals(18, userboxr{[5] = '18'}.id2FontSize)
    self:assertEquals(20, userboxr{['id-s'] = '20'}.id2FontSize)
end

function suite:testUserboxrId2Color()
    self:assertEquals(nil, userboxr{}.id2Color)
    self:assertEquals('red', userboxr{['logo-color'] = 'red'}.id2Color)
    self:assertEquals('blue', userboxr{['id-fc'] = 'blue'}.id2Color)
end

function suite:testUserboxrId2Padding()
    self:assertEquals(nil, userboxr{}.id2Padding)
    self:assertEquals('1px 1px 1px 1px', userboxr{['logo-padding'] = '1px 1px 1px 1px'}.id2Padding)
    self:assertEquals('2px 2px 2px 2px', userboxr{['id-p'] = '2px 2px 2px 2px'}.id2Padding)
end

function suite:testUserboxrId2LineHeight()
    self:assertEquals(nil, userboxr{}.id2LineHeight)
    self:assertEquals('1.5em', userboxr{['logo-line-height'] = '1.5em'}.id2LineHeight)
    self:assertEquals('1.75em', userboxr{['id-lh'] = '1.75em'}.id2LineHeight)
end

function suite:testUserboxrId2OtherParams()
    self:assertEquals(nil, userboxr{}.id2OtherParams)
    self:assertEquals('font-family:serif', userboxr{['logo-other-param'] = 'font-family:serif'}.id2OtherParams)
    self:assertEquals('font-family:times', userboxr{['id-op'] = 'font-family:times'}.id2OtherParams)
end

--------------------------------------------------------------------------------
-- Categories tests
--------------------------------------------------------------------------------

local function mainspaceCats(args)
	return categories(args, 'Foo')
end

local function templateCats(args)
	return categories(args, 'Template:Edit protected')
end

local function userCats(args)
	return categories(args, 'User:Example')
end

local function templateSubpageCats(args)
	return categories(args, 'Template:Edit protected/sandbox')
end

local function userSubpageCats(args)
	return categories(args, 'User:Example/Lipsum')
end

local userBasepage = 'Example'
local templateBasepage = 'Edit protected'

function suite:testUserCategories()
	self:assertEquals('[[Category:Foobar]]', userCats{usercategory = 'Foobar'})
	self:assertEquals('[[Category:Foobar2]]', userCats{usercategory2 = 'Foobar2'})
	self:assertEquals('[[Category:Foobar3]]', userCats{usercategory3 = 'Foobar3'})
end

function suite:testTemplateCategories()
	self:assertEquals(nil, templateCats{usercategory = 'Foobar'})
	self:assertEquals(nil, templateCats{usercategory2 = 'Foobar2'})
	self:assertEquals(nil, templateCats{usercategory3 = 'Foobar3'})
end

function suite:testMultipleUserCategories()
	self:assertEquals(
		'[[Category:Foobar]][[Category:Foobar2]][[Category:Foobar3]]',
		userCats{usercategory = 'Foobar', usercategory2 = 'Foobar2', usercategory3 = 'Foobar3'}
	)
end

function suite:testMultipleTemplateCategories()
	self:assertEquals(
		nil,
		templateCats{usercategory = 'Foobar', usercategory2 = 'Foobar2', usercategory3 = 'Foobar3'}
	)
end

function suite:testNocat()
	self:assertEquals(nil, userCats{nocat = 'true', usercategory = 'Foobar'})
	self:assertEquals(nil, templateCats{nocat = 'true', usercategory = 'Foobar'})
end

function suite:testNoCategories()
	self:assertEquals('', userCats{})
	self:assertEquals(nil, templateCats{})
end

function suite:testUserCategorySubpages()
	self:assertEquals('[[Category:Foobar]]', userSubpageCats{usercategory = 'Foobar'})
	self:assertEquals('[[Category:Foobar]]', userCats{usercategory = 'Foobar'})
end

function suite:testTemplateCategorySubpages()
	self:assertEquals(nil, templateSubpageCats{usercategory = 'Foobar'})
	self:assertEquals(nil, templateCats{usercategory = 'Foobar'})
end

function suite:testUserCategoryNoSubpages()
	self:assertEquals(nil, userSubpageCats{usercategory = 'Foobar', notcatsubpages = 'yes'})
	self:assertEquals('[[Category:Foobar]]', userCats{usercategory = 'Foobar', notcatsubpages = 'yes'})
end

function suite:testTemplateCategoryNoSubpages()
	self:assertEquals(nil, templateSubpageCats{usercategory = 'Foobar', notcatsubpages = 'yes'})
	self:assertEquals(nil, templateCats{usercategory = 'Foobar', notcatsubpages = 'yes'})
end

function suite:assertHasContrastCat(args, title, yes)
	local oldTitle = mw.title.getCurrentTitle
	mw.title.getCurrentTitle = function() return mw.title.new(title) end
	local data = userbox(args)
	local output = render(data)
	mw.title.getCurrentTitle = oldTitle
	if yes then
		self:assertStringContains("[[Category:Userboxes with insufficient color contrast]]", output, true, nil, 1)
	else
		self:assertNotStringContains("[[Category:Userboxes with insufficient color contrast]]", output, true, nil, 1)
	end
end
function suite:testInfoContrastTemplate()
	self:assertHasContrastCat({info = 'info', ['info-color'] = '#000000', ['info-background'] = '#000001'}, "Template:Foo", true)
	self:assertHasContrastCat({info = 'info', ['info-color'] = '#000000', ['info-background'] = '#FFFFFF'}, "Template:Foo", false)
end

function suite:testInfoContrastUser()
	self:assertHasContrastCat({info = 'info', ['info-color'] = '#000000', ['info-background'] = '#000001'}, "User:Foo", false)
	self:assertHasContrastCat({info = 'info', ['info-color'] = '#000000', ['info-background'] = '#FFFFFF'}, "User:Foo", false)
end

function suite:testInfoContrastUserSubpage()
	self:assertHasContrastCat({info = 'info', ['info-color'] = '#000000', ['info-background'] = '#000001'}, "User:Foo/bar", true)
	self:assertHasContrastCat({info = 'info', ['info-color'] = '#000000', ['info-background'] = '#FFFFFF'}, "User:Foo/bar", false)
end

function suite:testIdContrastTemplate()
	self:assertHasContrastCat({info = 'info', logo = 'id', ['logo-color'] = '#000000', ['logo-background'] = '#000001'}, "Template:Foo", true)
	self:assertHasContrastCat({info = 'info', logo = 'id', ['logo-color'] = '#000000', ['logo-background'] = '#FFFFFF'}, "Template:Foo", false)
end

function suite:testIdContrastUser()
	self:assertHasContrastCat({info = 'info', logo = 'id', ['logo-color'] = '#000000', ['logo-background'] = '#000001'}, "User:Foo", false)
	self:assertHasContrastCat({info = 'info', logo = 'id', ['logo-color'] = '#000000', ['logo-background'] = '#FFFFFF'}, "User:Foo", false)
end

function suite:testIdContrastUserSubpage()
	self:assertHasContrastCat({info = 'info', logo = 'id', ['logo-color'] = '#000000', ['logo-background'] = '#000001'}, "User:Foo/bar", true)
	self:assertHasContrastCat({info = 'info', logo = 'id', ['logo-color'] = '#000000', ['logo-background'] = '#FFFFFF'}, "User:Foo/bar", false)
end

function suite:testMainspaceCategory()
	self:assertEquals('[[Category:Pages with templates in the wrong namespace]]', mainspaceCats{info = 'info'})
end

return suite
