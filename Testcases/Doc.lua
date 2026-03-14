-- Test cases page for [[Mô đun:Documentation]]. See talk page to run tests.

local doc = require('Mô đun:Documentation/sandbox')
local ScribuntoUnit = require('Mô đun:ScribuntoUnit')
local suite = ScribuntoUnit:new()

--------------------------------------------------------------------------------------------
-- Test case helper functions
--------------------------------------------------------------------------------------------

local function getEnv(page)
	-- Gets an env table using the specified page.
	return doc.getEnvironment{page = page}
end

--------------------------------------------------------------------------------------------
-- Test helper functions
--------------------------------------------------------------------------------------------

function suite:testMessage()
	self:assertEquals('sandbox', doc.message('sandbox-subpage'))
	self:assertEquals('Các trang con của foobar này', doc.message('subpages-link-display', {'foobar'}))
	self:assertEquals(true, doc.message('display-strange-usage-category', nil, 'boolean'))
end

function suite:testMakeToolbar()
	self:assertEquals(nil, doc.makeToolbar())
	self:assertEquals('<span class="documentation-toolbar">(Foo)</span>', doc.makeToolbar('Foo'))
	self:assertEquals('<span class="documentation-toolbar">(Foo &#124; Bar)</span>', doc.makeToolbar('Foo', 'Bar'))
end

function suite:testMakeWikilink()
	self:assertEquals('[[Foo]]', doc.makeWikilink('Foo'))
	self:assertEquals('[[Foo|Bar]]', doc.makeWikilink('Foo', 'Bar'))
end

function suite:testMakeCategoryLink()
	self:assertEquals('[[Thể loại:Foo]]', doc.makeCategoryLink('Foo'))
	self:assertEquals('[[Thể loại:Foo|Bar]]', doc.makeCategoryLink('Foo', 'Bar'))
end

function suite:testMakeUrlLink()
	self:assertEquals('[Foo Bar]', doc.makeUrlLink('Foo', 'Bar'))
end

--------------------------------------------------------------------------------------------
-- Test env table
--------------------------------------------------------------------------------------------

function suite:assertEnvFieldEquals(expected, page, field)
	local env = getEnv(page)
	self:assertEquals(expected, env[field])
end	

function suite:assertEnvTitleEquals(expected, page, titleField)
	local env = getEnv(page)
	local title = env[titleField]
	self:assertEquals(expected, title.prefixedText)
end	

function suite:testEnvTitle()
	self:assertEnvTitleEquals('Wikipedia:Sandbox', 'Wikipedia:Sandbox', 'title')
	self:assertEnvTitleEquals('Bản mẫu:Example/sandbox', 'Bản mẫu:Example/sandbox', 'title')
end

function suite:testEnvBadTitle()
	local env = doc.getEnvironment{page = 'Bad[]Title'}
	local title = env.title
	self:assertEquals(nil, title)
end

function suite:testEnvTemplateTitle()
	self:assertEnvTitleEquals('Bản mẫu:Example', 'Bản mẫu:Example', 'templateTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example', 'Thảo luận Bản mẫu:Example', 'templateTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example', 'Bản mẫu:Example/sandbox', 'templateTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example', 'Thảo luận Bản mẫu:Example/sandbox', 'templateTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example', 'Bản mẫu:Example/testcases', 'templateTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/foo', 'Bản mẫu:Example/foo', 'templateTitle')
	self:assertEnvTitleEquals('Tập tin:Example', 'Thảo luận Tập tin:Example', 'templateTitle')
	self:assertEnvTitleEquals('Tập tin:Example', 'Thảo luận Tập tin:Example/sandbox', 'templateTitle')
end

function suite:testEnvDocTitle()
	self:assertEnvTitleEquals('Bản mẫu:Example/doc', 'Bản mẫu:Example', 'docTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/doc', 'Thảo luận Bản mẫu:Example', 'docTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/doc', 'Bản mẫu:Example/sandbox', 'docTitle')
	self:assertEnvTitleEquals('Thảo luận:Example/doc', 'Example', 'docTitle')
	self:assertEnvTitleEquals('Thảo luận Tập tin:Example.png/doc', 'Tập tin:Example.png', 'docTitle')
	self:assertEnvTitleEquals('Thảo luận Tập tin:Example.png/doc', 'Thảo luận Tập tin:Example.png/sandbox', 'docTitle')
end

function suite:testEnvSandboxTitle()
	self:assertEnvTitleEquals('Bản mẫu:Example/sandbox', 'Bản mẫu:Example', 'sandboxTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/sandbox', 'Thảo luận Bản mẫu:Example', 'sandboxTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/sandbox', 'Bản mẫu:Example/sandbox', 'sandboxTitle')
	self:assertEnvTitleEquals('Thảo luận:Example/sandbox', 'Example', 'sandboxTitle')
	self:assertEnvTitleEquals('Thảo luận Tập tin:Example.png/sandbox', 'Tập tin:Example.png', 'sandboxTitle')
end

function suite:testEnvTestcasesTitle()
	self:assertEnvTitleEquals('Bản mẫu:Example/testcases', 'Bản mẫu:Example', 'testcasesTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/testcases', 'Thảo luận Bản mẫu:Example', 'testcasesTitle')
	self:assertEnvTitleEquals('Bản mẫu:Example/testcases', 'Bản mẫu:Example/testcases', 'testcasesTitle')
	self:assertEnvTitleEquals('Thảo luận:Example/testcases', 'Example', 'testcasesTitle')
	self:assertEnvTitleEquals('Thảo luận Tập tin:Example.png/testcases', 'Tập tin:Example.png', 'testcasesTitle')
end

function suite:testEnvProtectionLevels()
	local pipeEnv = getEnv('Bản mẫu:?')
	self:assertEquals('autoconfirmed', pipeEnv.protectionLevels.edit[1])
	local sandboxEnv = getEnv('Wikipedia:Sandbox')
	local sandboxEditLevels = sandboxEnv.protectionLevels.edit
	if sandboxEditLevels then -- sandboxEditLevels may also be nil if the page is unprotected
		self:assertEquals(nil, sandboxEditLevels[1])
	else
		self:assertEquals(nil, sandboxEditLevels)
	end
end

function suite:testEnvSubjectSpace()
	self:assertEnvFieldEquals(10, 'Bản mẫu:Sandbox', 'subjectSpace')
	self:assertEnvFieldEquals(10, 'Thảo luận Bản mẫu:Sandbox', 'subjectSpace')
	self:assertEnvFieldEquals(0, 'Foo', 'subjectSpace')
	self:assertEnvFieldEquals(0, 'Thảo luận:Foo', 'subjectSpace')
end

function suite:testEnvDocSpace()
	self:assertEnvFieldEquals(10, 'Bản mẫu:Sandbox', 'docSpace')
	self:assertEnvFieldEquals(828, 'Mô đun:Sandbox', 'docSpace')
	self:assertEnvFieldEquals(1, 'Foo', 'docSpace')
	self:assertEnvFieldEquals(7, 'Tập tin:Example.png', 'docSpace')
	self:assertEnvFieldEquals(9, 'MediaWiki:Watchlist-details', 'docSpace')
	self:assertEnvFieldEquals(15, 'Thể loại:Wikipedians', 'docSpace')
end

function suite:testEnvDocpageBase()
	self:assertEnvFieldEquals('Bản mẫu:Example', 'Bản mẫu:Example', 'docpageBase')
	self:assertEnvFieldEquals('Bản mẫu:Example', 'Bản mẫu:Example/sandbox', 'docpageBase')
	self:assertEnvFieldEquals('Bản mẫu:Example', 'Thảo luận Bản mẫu:Example', 'docpageBase')
	self:assertEnvFieldEquals('Thảo luận Tập tin:Example.png', 'Tập tin:Example.png', 'docpageBase')
	self:assertEnvFieldEquals('Thảo luận Tập tin:Example.png', 'Thảo luận Tập tin:Example.png', 'docpageBase')
	self:assertEnvFieldEquals('Thảo luận Tập tin:Example.png', 'Thảo luận Tập tin:Example.png/sandbox', 'docpageBase')
end

function suite:testEnvCompareUrl()
	-- We use "Bản mẫu:Edit protected" rather than "Bản mẫu:Example" here as it has a space in the title.
	local expected = 'https://vi.wikipedia.org/w/index.php?title=Đặc_biệt%3ASo_sánh_trang&page1=Template%3AEdit+protected&page2=Template%3AEdit+protected%2Fsandbox'
	self:assertEnvFieldEquals(expected, 'Bản mẫu:Edit protected', 'compareUrl') 
	self:assertEnvFieldEquals(expected, 'Bản mẫu:Edit protected/sandbox', 'compareUrl')
	self:assertEnvFieldEquals(nil, 'Bản mẫu:Non-existent template adsfasdg', 'compareUrl')
	self:assertEnvFieldEquals(nil, 'Bản mẫu:Fact', 'compareUrl') -- Exists but doesn't have a sandbox.
end

--------------------------------------------------------------------------------------------
-- Test sandbox notice
--------------------------------------------------------------------------------------------

function suite.getSandboxNoticeTestData(page)
	local env = getEnv(page)
	local templatePage = page:match('^(.*)/sandbox$')
	local image = '[[Tập tin:Sandbox.svg|50px|alt=|link=]]'
	local templateBlurb = 'This is the [[Wikipedia:Template test cases|template sandbox]] page for [[' .. templatePage .. ']]'
	local moduleBlurb = 'This is the [[Wikipedia:Template test cases|module sandbox]] page for [[' .. templatePage .. ']]'
	local otherBlurb = 'This is the sandbox page for [[' .. templatePage .. ']]'
	local diff = '[https://vi.wikipedia.org/w/index.php?title=Đặc_biệt%3ASo_sánh_trang&page1=' .. mw.uri.encode(templatePage) .. '&page2=' .. mw.uri.encode(page) .. ' diff]'
	local testcasesBlurb = 'See also the companion subpage for [[' .. templatePage .. '/testcases|test cases]].'
	local category = '[[Thể loại:Template sandboxes]]'
	local clear = '<div class="documentation-clear"></div>'
	return env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category, clear
end	

function suite:testSandboxNoticeNotSandbox()
	local env = getEnv('Bản mẫu:Example')
	local notice = doc.sandboxNotice({}, env)
	self:assertEquals(nil, notice)
end

function suite:testSandboxNoticeStaticVals()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category, clear = suite.getSandboxNoticeTestData('Bản mẫu:Example/sandbox')
	local notice = doc.sandboxNotice({}, env)

    -- Escape metacharacters (mainly '-')
    clear = clear:gsub( '%p', '%%%0' )

	self:assertStringContains('^' .. clear, notice, false)
	self:assertStringContains(image, notice, true)
	self:assertStringContains(category, notice, true)
end

function suite:testSandboxNoticeTemplateBlurb()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('Bản mẫu:Example/sandbox')
	local notice = doc.sandboxNotice({}, env)
	self:assertStringContains(templateBlurb, notice, true)
end

function suite:testSandboxNoticeModuleBlurb()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('Mô đun:Math/sandbox')
	local notice = doc.sandboxNotice({}, env)
	self:assertStringContains(moduleBlurb, notice, true)
end

function suite:testSandboxNoticeOtherBlurb()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('User:Mr. Stradivarius/sandbox')
	local notice = doc.sandboxNotice({}, env)
	self:assertStringContains(otherBlurb, notice, true)
end

function suite:testSandboxNoticeBlurbDiff()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('Bản mẫu:Example/sandbox')
	local notice = doc.sandboxNotice({}, env)
	if mw.title.getCurrentTitle().isTalk then
		-- This test doesn't work in the debug console due to the use of frame:preprocess({{REVISIONID}}).
		-- The frame test doesn't seem to be working for now, so adding a namespace hack.
		self:assertStringContains(diff, notice, true)
	end
end

function suite:testSandboxNoticeBlurbDiffNoBasePage()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('Mô đun:User:Mr. Stradivarius/sandbox')
	local notice = doc.sandboxNotice({}, env)
	if mw.title.getCurrentTitle().isTalk then
		-- This test doesn't work in the debug console due to the use of frame:preprocess({{REVISIONID}}).
		-- The frame test doesn't seem to be working for now, so adding a namespace hack.
		self:assertNotStringContains(diff, notice, true)
	end
end

function suite:testSandboxNoticeTestcases()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('Bản mẫu:Edit protected/sandbox')
	local notice = doc.sandboxNotice({}, env)
	self:assertStringContains(testcasesBlurb, notice, true)
end

function suite:testSandboxNoticeNoTestcases()
	local env, image, templateBlurb, moduleBlurb, otherBlurb, diff, testcasesBlurb, category = suite.getSandboxNoticeTestData('Bản mẫu:Example/sandbox')
	local notice = doc.sandboxNotice({}, env)
	self:assertNotStringContains(testcasesBlurb, notice, true)
end

--------------------------------------------------------------------------------------------
-- Test protection template
-- 
-- There's not much we can do with this until {{pp-meta}} gets rewritten in Lua. At the
-- moment the protection detection only works for the current page, and the testcases pages
-- will be unprotected.
--------------------------------------------------------------------------------------------

function suite:testProtectionTemplateUnprotectedTemplate()
	local env = getEnv('Bản mẫu:Example')
	self:assertEquals(nil, doc.protectionTemplate(env))
end

function suite:testProtectionTemplateProtectedTemplate()
	local env = getEnv('Bản mẫu:Navbox')
	-- Test whether there is some content. We don't care what the content is, as the protection level
	-- detected will be for the current page, not the template.
	self:assertTrue(doc.protectionTemplate(env))
end

function suite:testProtectionTemplateUnprotectedModule()
	local env = getEnv('Mô đun:Example')
	self:assertEquals(nil, doc.protectionTemplate(env))
end

function suite:testProtectionTemplateProtectedModule()
	local env = getEnv('Mô đun:Yesno')
	-- Test whether there is some content. We don't care what the content is, as the protection level
	-- detected will be for the current page, not the template.
	self:assertTrue(doc.protectionTemplate(env))
end

--------------------------------------------------------------------------------------------
-- Test _startBox
--------------------------------------------------------------------------------------------

function suite:testStartBoxContentArg()
	local pattern = '<div class="documentation%-startbox">\n<span class="documentation%-heading" id="documentation%-heading">.-</span></div>'
	local startBox = doc._startBox({content = 'some documentation'}, getEnv('Bản mẫu:Example'))
	self:assertStringContains(pattern, startBox)
end

function suite:testStartBoxHtml()
	self:assertStringContains(
		'<div class="documentation%-startbox">\n<span class="documentation%-heading" id="documentation%-heading">.-</span><span class="mw%-editsection%-like plainlinks">.-</span></div>',
		doc._startBox({}, getEnv('Bản mẫu:Example'))
	)
end

--------------------------------------------------------------------------------------------
-- Test makeStartBoxLinksData
--------------------------------------------------------------------------------------------

function suite:testMakeStartBoxLinksData()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxLinksData({}, env)
	self:assertEquals('Bản mẫu:Example', data.title.prefixedText)
	self:assertEquals('Bản mẫu:Example/doc', data.docTitle.prefixedText)
	self:assertEquals('xem', data.viewLinkDisplay)
	self:assertEquals('sửa', data.editLinkDisplay)
	self:assertEquals('lịch sử', data.historyLinkDisplay)
	self:assertEquals('làm mới', data.purgeLinkDisplay)
	self:assertEquals('tạo', data.createLinkDisplay)
end

function suite:testMakeStartBoxLinksDataTemplatePreload()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxLinksData({}, env)
	self:assertEquals('Bản mẫu:Tài liệu/preload', data.preload)
end

function suite:testMakeStartBoxLinksDataArgsPreload()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxLinksData({preload = 'My custom preload'}, env)
	self:assertEquals('My custom preload', data.preload)
end

--------------------------------------------------------------------------------------------
-- Test renderStartBoxLinks
--------------------------------------------------------------------------------------------

function suite.makeExampleStartBoxLinksData(exists)
	-- Makes a data table to be used with testRenderStartBoxLinksExists and testRenderStartBoxLinksDoesntExist.
	local data = {}
	if exists then
		data.title = mw.title.new('Bản mẫu:Example')
		data.docTitle = mw.title.new('Bản mẫu:Example/doc')
	else
		data.title = mw.title.new('Bản mẫu:NonExistentTemplate')
		data.docTitle = mw.title.new('Bản mẫu:NonExistentTemplate/doc')
	end
	data.viewLinkDisplay = 'xem'
	data.editLinkDisplay = 'sửa'
	data.historyLinkDisplay = 'lịch sử'
	data.purgeLinkDisplay = 'làm mới'
	data.createLinkDisplay = 'tạo'
	data.preload = 'Bản mẫu:MyPreload'
	return data
end

function suite:testRenderStartBoxLinksExists()
	local data = suite.makeExampleStartBoxLinksData(true)
	local expected = '&#91;[[Bản mẫu:Example/doc|xem]]&#93; &#91;[[Đặc_biệt:EditPage/Bản mẫu:Example/doc|sửa]]&#93; &#91;[[Đặc_biệt:PageHistory/Bản mẫu:Example/doc|lịch sử]]&#93; &#91;[[Đặc_biệt:Purge/Bản mẫu:Example|làm mới]]&#93;'
	self:assertEquals(expected, doc.renderStartBoxLinks(data))
end

function suite:testRenderStartBoxLinksDoesntExist()
	local data = suite.makeExampleStartBoxLinksData(false)
	local expected = '&#91;[https://vi.wikipedia.org/w/index.php?title=B%E1%BA%A3n_m%E1%BA%ABu:NonExistentTemplate/doc&action=edit&preload=B%E1%BA%A3n+m%E1%BA%ABu%3AMyPreload tạo]&#93; &#91;[[Đặc_biệt:Purge/Bản mẫu:NonExistentTemplate|làm mới]]&#93;'
	self:assertEquals(expected, doc.renderStartBoxLinks(data))
end

--------------------------------------------------------------------------------------------
-- Test makeStartBoxData
--------------------------------------------------------------------------------------------

function suite:testStartBoxDataBlankHeading()
	local data = doc.makeStartBoxData({heading = ''}, {})
	self:assertEquals(nil, data)
end

function suite:testStartBoxDataHeadingTemplate()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxData({}, env)
	local expected = '[[Tập tin:Test Template Info-Icon - Version (2).svg|50px|link=|alt=]] Tài liệu bản mẫu'
	self:assertEquals(expected, data.heading)
end

function suite:testStartBoxDataHeadingModule()
	local env = getEnv('Mô đun:Example')
	local data = doc.makeStartBoxData({}, env)
	local expected = '[[Tập tin:Test Template Info-Icon - Version (2).svg|50px|link=|alt=]] Tài liệu mô đun'
	self:assertEquals(expected, data.heading)
end

function suite:testStartBoxDataHeadingFile()
	local env = getEnv('Tập tin:Example.png')
	local data = doc.makeStartBoxData({}, env)
	local expected = 'Tóm lược'
	self:assertEquals(expected, data.heading)
end

function suite:testStartBoxDataHeadingOther()
	local env = getEnv('User:Example')
	local data = doc.makeStartBoxData({}, env)
	local expected = 'Tài liệu'
	self:assertEquals(expected, data.heading)
end

function suite:testStartBoxDataHeadingStyle()
	local data = doc.makeStartBoxData({['heading-style'] = 'foo:bar'}, {})
	self:assertEquals('foo:bar', data.headingStyleText)
end

function suite:testStartBoxDataHeadingStyleTemplate()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxData({}, env)
	self:assertEquals(nil, data.headingStyleText)
end

function suite:testStartBoxDataHeadingStyleOther()
	local env = getEnv('User:Example')
	local data = doc.makeStartBoxData({}, env)
	self:assertEquals(nil, data.headingStyleText)
end

function suite:testStartBoxDataLinks()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxData({}, env, 'some links')
	self:assertEquals('some links', data.links)
	self:assertEquals('mw-editsection-like plainlinks', data.linksClass)
end

function suite:testStartBoxDataNoLinks()
	local env = getEnv('Bản mẫu:Example')
	local data = doc.makeStartBoxData({}, env)
	self:assertEquals(nil, data.links)
	self:assertEquals(nil, data.linksClass)
	self:assertEquals(nil, data.linksId)
end

--------------------------------------------------------------------------------------------
-- Test renderStartBox
--------------------------------------------------------------------------------------------

function suite:testRenderStartBox()
	local expected = '<div class="documentation-startbox">\n<span id="documentation-heading"></span></div>'
	self:assertEquals(expected, doc.renderStartBox{})
end

function suite:testRenderStartBoxHeadingStyleText()
	self:assertStringContains('\n<span id="documentation-heading" style="foo:bar">', doc.renderStartBox{headingStyleText = 'foo:bar'}, true)
end

function suite:testRenderStartBoxHeading()
	self:assertStringContains('\n<span id="documentation-heading">Foobar</span>', doc.renderStartBox{heading = 'Foobar'}, true)
end

function suite:testRenderStartBoxLinks()
	self:assertStringContains('<span>list of links</span>', doc.renderStartBox{links = 'list of links'}, true)
end

function suite:testRenderStartBoxLinksClass()
	self:assertStringContains('<span class="linksclass">list of links</span>', doc.renderStartBox{linksClass = 'linksclass', links = 'list of links'}, true)
	self:assertNotStringContains('linksclass', doc.renderStartBox{linksClass = 'linksclass'}, true)
end

function suite:testRenderStartBoxLinksId()
	self:assertStringContains('<span id="linksid">list of links</span>', doc.renderStartBox{linksId = 'linksid', links = 'list of links'}, true)
	self:assertNotStringContains('linksid', doc.renderStartBox{linksId = 'linksid'}, true)
end

--------------------------------------------------------------------------------------------
-- Test _content
--------------------------------------------------------------------------------------------

function suite:testContentArg()
	self:assertEquals('\nsome documentation\n', doc._content({content = 'some documentation'}, {}))
end

function suite:testContentNoContent()
	local env = getEnv('Bản mẫu:This is a non-existent template agauchvaiu')
	self:assertEquals('\n\n', doc._content({}, env))
end

function suite:testContentExists()
	local env = doc.getEnvironment{'Bản mẫu:Documentation/testcases/test3'}
	local docs = mw.getCurrentFrame():preprocess('{{Bản mẫu:Documentation/testcases/test3}}')
	local expected = '\n' .. docs .. '\n'
	self:assertEquals(expected, doc._content({}, env))
end

--------------------------------------------------------------------------------------------
-- Test _endBox
--------------------------------------------------------------------------------------------

function suite:testEndBoxLinkBoxOff()
	local env = getEnv()
	self:assertEquals(nil, doc._endBox({['link box'] = 'off'}, env))
end

function suite:testEndBoxNoDocsOtherNs()
	local env = {
		subjectSpace = 4,
		docTitle = {
			exists = false
		}
	}
	self:assertEquals(nil, doc._endBox({}, env))
end

function suite:testEndBoxAlwaysShowNs()
	self:assertTrue(doc._endBox({}, getEnv('Bản mẫu:Non-existent template asdfalsdhaw')))
	self:assertTrue(doc._endBox({}, getEnv('Mô đun:Non-existent module asdhewbydcyg')))
	self:assertTrue(doc._endBox({}, getEnv('User:Non-existent user ahfliwebalisyday')))
end

function suite:testEndBoxStyles()
	local env = getEnv('Bản mẫu:Example')
	local endBox = doc._endBox({}, env)
	self:assertStringContains('class="documentation-metadata plainlinks"', endBox, true)
end

function suite:testEndBoxLinkBoxArg()
	local env = getEnv()
	self:assertStringContains('Custom link box', doc._endBox({['link box'] = 'Custom link box'}, env))
end

function suite:testEndBoxExperimentBlurbValidNs()
	local expected = 'Editors can experiment in this.-<br />'
	self:assertStringContains(expected, doc._endBox({}, getEnv('Bản mẫu:Example')))
	self:assertStringContains(expected, doc._endBox({}, getEnv('Mô đun:Example')))
	self:assertStringContains(expected, doc._endBox({}, getEnv('User:Example')))
end

function suite:testEndBoxExperimentBlurbInvalidNs()
	local expected = 'Editors can experiment in this.-<br />'
	self:assertNotStringContains(expected, doc._endBox({}, getEnv('Wikipedia:Twinkle'))) -- Wikipedia:Twinkle has an existing /doc subpage
end

function suite:testEndBoxCategoriesBlurb()
	local expected = 'Add categories to the %[%[.-|/doc%]%] subpage%.'
	self:assertStringContains(expected, doc._endBox({}, getEnv('Bản mẫu:Example')))
	self:assertStringContains(expected, doc._endBox({}, getEnv('Mô đun:Example')))
	self:assertStringContains(expected, doc._endBox({}, getEnv('User:Example')))
	self:assertNotStringContains(expected, doc._endBox({[1] = 'Foo'}, getEnv('Bản mẫu:Example')))
	self:assertNotStringContains(expected, doc._endBox({content = 'Bar'}, getEnv('Bản mẫu:Example')))
	self:assertNotStringContains(expected, doc._endBox({}, getEnv('Wikipedia:Twinkle')))
end

--------------------------------------------------------------------------------------------
-- Test makeDocPageBlurb
--------------------------------------------------------------------------------------------

function suite:testDocPageBlurbError()
	self:assertEquals(nil, doc.makeDocPageBlurb({}, {}))
end

function suite:testDocPageBlurbTemplateDocExists()
	local env = getEnv('Bản mẫu:Documentation')
	local expected = '[[Wikipedia:Tài liệu bản mẫu|Tài liệu]] bên trên [[:en:Wikipedia:Transclusion|được truyền tải]] từ [[Bản mẫu:Documentation/doc]]. <span class="documentation-toolbar">([[Đặc_biệt:EditPage/Bản mẫu:Documentation/doc|sửa]] &#124; [[Đặc_biệt:PageHistory/Bản mẫu:Documentation/doc|lịch sử]])</span><br />'
	self:assertEquals(expected, doc.makeDocPageBlurb({}, env))
end

function suite:testDocPageBlurbTemplateDocDoesntExist()
	local env = getEnv('Bản mẫu:Non-existent template ajlkfdsa')
	self:assertEquals(nil, doc.makeDocPageBlurb({}, env))
end

function suite:testDocPageBlurbModuleDocExists()
	local env = getEnv('Mô đun:Example')
	local expected = '[[Wikipedia:Tài liệu bản mẫu|Tài liệu]] bên trên [[:en:Wikipedia:Transclusion|được truyền tải]] từ [[Mô đun:Example/doc]]. <span class="documentation-toolbar">([[Đặc_biệt:EditPage/Mô đun:Example/doc|sửa]] &#124; [[Đặc_biệt:PageHistory/Mô đun:Example/doc|lịch sử]])</span><br />'
	self:assertEquals(expected, doc.makeDocPageBlurb({}, env))
end

function suite:testDocPageBlurbModuleDocDoesntExist()
	local env = getEnv('Mô đun:Non-existent module ajlkfdsa')
	local expected = 'Bạn có thể muốn [https://vi.wikipedia.org/w/index.php?title=M%C3%B4_%C4%91un:Non-existent_module_ajlkfdsa/doc&action=edit&preload=B%E1%BA%A3n+m%E1%BA%ABu%3AT%C3%A0i+li%E1%BB%87u%2Fpreload-module-doc tạo] một trang tài liệu cho [[:en:Wikipedia:Lua|mô đun Scribunto]] này.<br />'
	self:assertEquals(expected, doc.makeDocPageBlurb({}, env))
end

--------------------------------------------------------------------------------------------
-- Test makeExperimentBlurb
--------------------------------------------------------------------------------------------

function suite:testExperimentBlurbTemplate()
	local env = getEnv('Bản mẫu:Example')
	self:assertStringContains("Editors can experiment in this template's .- and .- pages.", doc.makeExperimentBlurb({}, env), false)
end

function suite:testExperimentBlurbModule()
	local env = getEnv('Mô đun:Example')
	self:assertStringContains("Editors can experiment in this module's .- and .- pages.", doc.makeExperimentBlurb({}, env), false)
end

function suite:testExperimentBlurbSandboxExists()
	local env = getEnv('Bản mẫu:Edit protected')
	local pattern = '[[Bản mẫu:Edit protected/sandbox|sandbox]] <span class="documentation-toolbar">([[Đặc_biệt:EditPage/Bản mẫu:Edit protected/sandbox|edit]] &#124; [https://vi.wikipedia.org/w/index.php?title=Đặc_biệt%3ASo_sánh_trang&page1=Template%3AEdit+protected&page2=Template%3AEdit+protected%2Fsandbox diff])</span>'
	self:assertStringContains(pattern, doc.makeExperimentBlurb({}, env), true)
end

function suite:testExperimentBlurbSandboxDoesntExist()
	local env = getEnv('Bản mẫu:Non-existent template sajdfasd')
	local pattern = 'sandbox <span class="documentation-toolbar">([https://vi.wikipedia.org/w/index.php?title=Bản_mẫu:Non-existent_template_sajdfasd/sandbox&action=edit&preload=Template%3ADocumentation%2Fpreload-sandbox create] &#124; [https://vi.wikipedia.org/w/index.php?title=Bản_mẫu:Non-existent_template_sajdfasd/sandbox&preload=Template%3ADocumentation%2Fmirror&action=edit&summary=Create+sandbox+version+of+%5B%5BTemplate%3ANon-existent+template+sajdfasd%5D%5D mirror])</span>'
	self:assertStringContains(pattern, doc.makeExperimentBlurb({}, env), true)
end

function suite:testExperimentBlurbTestcasesExist()
	local env = getEnv('Bản mẫu:Edit protected')
	local pattern = '[[Bản mẫu:Edit protected/testcases|testcases]] <span class="documentation-toolbar">([[Đặc_biệt:EditPage/Bản mẫu:Edit protected/testcases|edit]])</span>'
	self:assertStringContains(pattern, doc.makeExperimentBlurb({}, env), true)
end

function suite:testExperimentBlurbTestcasesDontExist()
	local env = getEnv('Bản mẫu:Non-existent template sajdfasd')
	local pattern = 'testcases <span class="documentation-toolbar">([https://vi.wikipedia.org/w/index.php?title=Bản_mẫu:Non-existent_template_sajdfasd/testcases&action=edit&preload=Template%3ADocumentation%2Fpreload-testcases create])</span>'
	self:assertStringContains(pattern, doc.makeExperimentBlurb({}, env), true)
end

--------------------------------------------------------------------------------------------
-- Test makeCategoriesBlurb
--------------------------------------------------------------------------------------------

function suite:testMakeCategoriesBlurb()
	local env = getEnv('Bản mẫu:Example')
	self:assertEquals('Xin hãy bổ sung các thể loại vào trang con [[Bản mẫu:Example/doc|/doc]].', doc.makeCategoriesBlurb({}, env))
end

--------------------------------------------------------------------------------------------
-- Test makeSubpagesBlurb
--------------------------------------------------------------------------------------------

function suite:testMakeSubpagesBlurbTemplate()
	local env = getEnv('Bản mẫu:Example')
	self:assertEquals('[[Đặc_biệt:Tiền_tố/Bản mẫu:Example/|Các trang con của bản mẫu này]].', doc.makeSubpagesBlurb({}, env))
end

function suite:testMakeSubpagesBlurbModule()
	local env = getEnv('Mô đun:Example')
	self:assertEquals('[[Đặc_biệt:Tiền_tố/Mô đun:Example/|Các trang con của mô đun này]].', doc.makeSubpagesBlurb({}, env))
end

function suite:testMakeSubpagesBlurbOther()
	local env = getEnv('Tập tin:Example.png')
	self:assertEquals('[[Đặc_biệt:Tiền_tố/Tập tin:Example.png/|Các trang con của trang này]].', doc.makeSubpagesBlurb({}, env))
end
--------------------------------------------------------------------------------------------
-- Test addTrackingCategories
--------------------------------------------------------------------------------------------

function suite.getStrangeUsageCat()
	return '[[Thể loại:Các trang Wikipedia có cách sử dụng ((tài liệu)) lạ]]'
end

function suite:testAddTrackingCategoriesTemplatePage()
	local env = getEnv('Bản mẫu:Example')
	self:assertEquals('', doc.addTrackingCategories(env))
end

function suite:testAddTrackingCategoriesDocPage()
	local env = getEnv('Bản mẫu:Example/doc')
	self:assertEquals(self.getStrangeUsageCat(), doc.addTrackingCategories(env))
end

function suite:testAddTrackingCategoriesTestcasesPage()
	local env = getEnv('Bản mẫu:Example/testcases')
	self:assertEquals(self.getStrangeUsageCat(), doc.addTrackingCategories(env))
end

function suite:testAddTrackingCategoriesModuleDoc()
	local env = getEnv('Mô đun:Math/doc')
	self:assertEquals(self.getStrangeUsageCat(), doc.addTrackingCategories(env))
end

function suite:testAddTrackingCategoriesModuleTestcases()
	local env = getEnv('Mô đun:Math/testcases')
	self:assertEquals('', doc.addTrackingCategories(env))
end

function suite:testAddTrackingCategoriesInvalidTitle()
	local env = getEnv('Bản mẫu:Foo[]Bar')
	self:assertEquals(nil, doc.addTrackingCategories(env))
end

--------------------------------------------------------------------------------------------
-- Whitespace tests
--------------------------------------------------------------------------------------------

function suite:testNoTrailingWhitespace()
	self:assertStringContains('of this template%]%].</div></div>$', doc._main{page = 'Bản mẫu:Example'})
end

return suite
