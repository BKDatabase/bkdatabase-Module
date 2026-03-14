-- Unit tests for [[Module:Category handler]]. Click talk page to run tests.
local m_category_handler = require('Module:Category handler/sandbox')
local chmain = m_category_handler._main
local ScribuntoUnit = require('Module:ScribuntoUnit')
local suite = ScribuntoUnit:new()

-- Define table of defaults
local d = {}

-- Values
d.absent = nil
d.blank = ''
d.negation = '¬'
d.yes = 'yes'
d.no = 'no'
d.subpageOnly = 'only'
d.subpageNo = 'no'

-- Categories
d.category = 'Category:Somecat'
d.category1 = 'Category:Somecat1'
d.category2 = 'Category:Somecat2'

-- Pages
d.article = 'Somearticle'
d.file = 'File:Example.png'
d.talk = 'Talk:Foo'
d.archive = 'User talk:Example/Archive 5'
d.subpage = 'User:Example/test'
d.basepage = 'User:Example'

-- Params
d.archiveParam = 'talk'

--------------------------------------------------------------------------------
-- Test nil
--------------------------------------------------------------------------------

function suite:test_nil()
    self:assertEquals(d.absent, chmain{nil})
end

--------------------------------------------------------------------------------
-- Test defaults
--------------------------------------------------------------------------------

function suite:test_default_current_page()
	-- Will test either module or module talk space, neither of which are categorised by default.
    self:assertEquals(d.absent, chmain{d.category})
end

function suite:test_default_main()
    self:assertEquals(d.category, chmain{d.category, page = d.article})
end

function suite:test_default_file()
    self:assertEquals(d.category, chmain{d.category, page = d.file})
end

--------------------------------------------------------------------------------
-- Test numbered parameters
--------------------------------------------------------------------------------

function suite:test_numbered_main()
    self:assertEquals(d.category, chmain{
		[1] = d.category,
		main = 1,
		page = d.article
	})
end

function suite:test_numbered_two_params()
    self:assertEquals(d.category2, chmain{
		[1] = d.category1,
		[2] = d.category2,
		main = 1,
		file = 2,
		page = d.file
	})
end

--------------------------------------------------------------------------------
-- Test overriding defaults
--------------------------------------------------------------------------------

function suite:test_numbered_main()
    self:assertEquals(d.absent, chmain{
		main = d.category,
		page = d.file
	})
end

--------------------------------------------------------------------------------
-- Test blank namespace parameters
--------------------------------------------------------------------------------

function suite:test_blank_namespace_talk()
    self:assertEquals(d.blank, chmain{
		talk = d.blank,
		other = d.category,
		page = d.talk
	})
end

--------------------------------------------------------------------------------
-- Test other parameter
--------------------------------------------------------------------------------

function suite:test_other_only()
    self:assertEquals(d.category, chmain{
		other = d.category,
	})
end

--------------------------------------------------------------------------------
-- Test nocat parameter
--------------------------------------------------------------------------------

function suite:test_nocat_true()
    self:assertEquals(d.absent, chmain{d.category, page = d.file, nocat = true})
end

function suite:test_nocat_blank()
    self:assertEquals(d.category, chmain{d.category, page = d.file, nocat = ''})
end

function suite:test_nocat_yes()
    self:assertEquals(d.absent, chmain{d.category, page = d.file, nocat = d.yes})
end

function suite:test_nocat_false()
    self:assertEquals(d.category, chmain{
		[d.archiveParam] = d.category,
		page = d.archive,
		nocat = false
	})
end

function suite:test_nocat_no()
    self:assertEquals(d.category, chmain{
		[d.archiveParam] = d.category,
		page = d.archive,
		nocat = d.no
	})
end

--------------------------------------------------------------------------------
-- Test categories parameter
--------------------------------------------------------------------------------

function suite:test_categories_true()
    self:assertEquals(d.category, chmain{
		[d.archiveParam] = d.category,
		page = d.archive,
		categories = true
	})
end

function suite:test_categories_blank()
    self:assertEquals(d.category, chmain{d.category, page = d.file, categories = ''})
end

function suite:test_categories_yes()
    self:assertEquals(d.category, chmain{
		[d.archiveParam] = d.category,
		page = d.archive,
		categories = d.yes
	})
end

function suite:test_categories_false()
    self:assertEquals(d.absent, chmain{
		file = d.category,
		page = d.file,
		categories = false
	})
end

function suite:test_categories_no()
    self:assertEquals(d.absent, chmain{
		file = d.category,
		page = d.file,
		categories = d.no
	})
end

--------------------------------------------------------------------------------
-- Test category2 parameter
--------------------------------------------------------------------------------

function suite:test_category2_no()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		category2 = d.no
	})
end

function suite:test_category2_blank()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		category2 = d.blank
	})
end

function suite:test_category2_negation()
    self:assertEquals(d.category, chmain{
		other = d.category,
		category2 = d.negation
	})
end

function suite:test_category2_blacklist()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = d.archive,
		categories = d.yes
	})
end

--------------------------------------------------------------------------------
-- Test subpage parameter
--------------------------------------------------------------------------------

function suite:test_subpage_no_basepage()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = d.basepage,
		subpage = d.subpageNo
	})
end

function suite:test_subpage_no_subpage()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = d.subpage,
		subpage = d.subpageNo
	})
end

function suite:test_subpage_only_basepage()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = d.basepage,
		subpage = d.subpageOnly
	})
end

function suite:test_subpage_only_subpage()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = d.subpage,
		subpage = d.subpageOnly
	})
end

--------------------------------------------------------------------------------
-- Test blacklist
--------------------------------------------------------------------------------

function suite:test_blacklist_archives()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'User talk:Example/Archive 5',
	})
end

function suite:test_blacklist_archives_lowercase()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'User talk:Example/archive 5',
	})
end

function suite:test_blacklist_archives_notarchive()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = 'User talk:Example/Archove 5',
	})
end

function suite:test_blacklist_archives_incident_archive()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = "BKDatabase:Administrators' noticeboard/IncidentArchive 5",
	})
end

function suite:test_blacklist_main_page()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'Main Page',
	})
end

function suite:test_blacklist_main_page_talk()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = 'Talk:Main Page',
	})
end

function suite:test_blacklist_cascade()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'BKDatabase:Cascade-protected items',
	})
end

function suite:test_blacklist_cascade_slash()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'BKDatabase:Cascade-protected items/',
	})
end

function suite:test_blacklist_cascade_subpage()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'BKDatabase:Cascade-protected items/Foo',
	})
end

function suite:test_blacklist_cascade_not_subpage()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = 'BKDatabase:Cascade-protected itemsFoo',
	})
end

function suite:test_blacklist_cascade_talk()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = 'BKDatabase talk:Cascade-protected items',
	})
end

function suite:test_blacklist_ubx()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'User:UBX',
	})
end

function suite:test_blacklist_ubx_talk()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'User talk:UBX',
	})
end

function suite:test_blacklist_ubx_subpage()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'User:UBX/Userboxes',
	})
end

function suite:test_blacklist_ubx_talk_subpage()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'User talk:UBX/Userboxes',
	})
end

function suite:test_blacklist_template_index_basepage()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = 'BKDatabase:Template index',
	})
end

function suite:test_blacklist_template_index_slash()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'BKDatabase:Template index/',
	})
end

function suite:test_blacklist_template_index_not_subpage()
    self:assertEquals(d.category, chmain{
		other = d.category,
		page = 'BKDatabase:Template indexFoo',
	})
end

function suite:test_blacklist_template_index_subpage()
    self:assertEquals(d.absent, chmain{
		other = d.category,
		page = 'BKDatabase:Template index/Cleanup',
	})
end

--------------------------------------------------------------------------------
-- Test namespace params
--------------------------------------------------------------------------------

function suite:test_main()
    self:assertEquals(d.category, chmain{
		main = d.category,
		page = 'Some article',
	})
end

function suite:test_talk()
    self:assertEquals(d.category, chmain{
		talk = d.category,
		page = 'Talk:Some article',
	})
end

function suite:test_user()
    self:assertEquals(d.category, chmain{
		user = d.category,
		page = 'User:Example',
	})
end

function suite:test_user_talk()
    self:assertEquals(d.category, chmain{
		talk = d.category,
		page = 'User talk:Example',
	})
    self:assertEquals(d.absent, chmain{
		['user talk'] = d.category,
		page = 'User talk:Example',
	})
    self:assertEquals(d.absent, chmain{
		['user_talk'] = d.category,
		page = 'User talk:Example',
	})
end

function suite:test_BKDatabase()
    self:assertEquals(d.category, chmain{
		BKDatabase = d.category,
		page = 'BKDatabase:Example',
	})
end

function suite:test_BKDatabase()
    self:assertEquals(d.category, chmain{
		BKDatabase = d.category,
		page = 'BKDatabase:Example',
	})
end

function suite:test_project()
    self:assertEquals(d.category, chmain{
		project = d.category,
		page = 'BKDatabase:Example',
	})
end

function suite:test_wp()
    self:assertEquals(d.category, chmain{
		wp = d.category,
		page = 'BKDatabase:Example',
	})
end

function suite:test_file()
    self:assertEquals(d.category, chmain{
		file = d.category,
		page = 'File:Example.png',
	})
end

function suite:test_image()
    self:assertEquals(d.category, chmain{
		image = d.category,
		page = 'File:Example.png',
	})
end

function suite:test_mediawiki()
    self:assertEquals(d.category, chmain{
		mediawiki = d.category,
		page = 'MediaWiki:Protectedpagetext',
	})
end

function suite:test_template()
    self:assertEquals(d.category, chmain{
		template = d.category,
		page = 'Template:Example',
	})
end

function suite:test_help()
    self:assertEquals(d.category, chmain{
		help = d.category,
		page = 'Help:Editing',
	})
end

function suite:test_category()
    self:assertEquals(d.category, chmain{
		category = d.category,
		page = 'Category:BKDatabasens',
	})
end

function suite:test_category()
    self:assertEquals(d.category, chmain{
		category = d.category,
		page = 'Category:BKDatabasens',
	})
end

function suite:test_portal()
    self:assertEquals(d.category, chmain{
		portal = d.category,
		page = 'Portal:France',
	})
end

function suite:test_draft()
    self:assertEquals(d.category, chmain{
		draft = d.category,
		page = 'Draft:Example',
	})
end

function suite:test_timedtext()
    self:assertEquals(d.category, chmain{
		timedtext = d.category,
		page = 'TimedText:Example',
	})
end

function suite:test_module()
    self:assertEquals(d.category, chmain{
		module = d.category,
		page = 'Module:Sandbox',
	})
end

function suite:test_special()
    self:assertEquals(d.category, chmain{
		special = d.category,
		page = 'Special:WhatLinksHere',
	})
end

function suite:test_media()
    self:assertEquals(d.category, chmain{
		media = d.category,
		page = 'Media:Example.png',
	})
end

return suite
