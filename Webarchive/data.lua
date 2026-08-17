--[[--------------------------< C O N F I G U R A T I O N >----------------------------------------------------

global configuration settings

]]

local config = {
	maxurls = 10,																-- Max number of URLs allowed. 
	tname = 'Webarchive',														-- name of calling template. Change if template rename.
	verifydates = true,															-- See documentation. Set false to disable.
	}


--[[--------------------------< U N C A T E G O R I Z E D _ N A M E S P A C E S >------------------------------

List of namespaces that should not be included in citation error categories.

Note: Namespace names should use underscores instead of spaces.

]]

local uncategorized_namespaces = {												-- same list as specified at [[Module:Citation/CS1/Configuration]]
	['Thành_viên']=true, ['Thảo_luận']=true, ['Thảo_luận_Thành_viên']=true, ['Thảo_luận_BKDatabase']=true, ['Thảo_luận_Tập_tin']=true,
	['Thảo_luận_Bản_mẫu']=true, ['Thảo_luận_Trợ_giúp']=true, ['Thảo_luận_Thể_loại']=true, ['Lore_talk']=true,
	['Thảo_luận_Mô_đun']=true, ['Thảo_luận_MediaWiki']=true,
	}

local uncategorized_subpages = {'/[Ss]andbox', '/[Tt]estcases'};				-- list of Lua patterns found in page names of pages we should not categorize

local excepted_pages = {														-- these pages will be categorized if set true; set to nil to disable
	['Thảo luận Mô đun:Webarchive/testcases'] = true,								-- test cases pages used during development
	['Bản mẫu:Webarchive/testcases/Production'] = true,
	}


--[[--------------------------< C A T E G O R I E S >----------------------------------------------------------

this is a table of all categories supported by Module:Webarchive

]]

local categories = {
	archiveis = 'Thể loại:Bản mẫu webarchive dùng liên kết archiveis',
	error = 'Thể loại:Lỗi bản mẫu Webarchive',
	other = 'Thể loại:Bản mẫu webarchive dùng lưu trữ khác',
	unknown = 'Thể loại:Bản mẫu webarchive dùng liên kết không rõ',
	warning = 'Thể loại:Cảnh báo bản mẫu webarchive',
	wayback = 'Thể loại:Bản mẫu webarchive dùng liên kết wayback',
	webcite = 'Thể loại:Bản mẫu webarchive dùng liên kết webcite',
	}


--[[--------------------------< P R E F I X E S >--------------------------------------------------------------

used only with serviceName(), this table holds the two generic tail-text prefixes specified by services['<service name>'][1]

]]

local prefixes = {
	at = 'tại',
	atthe = 'tại',
	}


--[=[-------------------------< S E R V I C E S >--------------------------------------------------------------

this is a table of tables for archive services.  Each service table has:
	[1]=prefix; may be boolean true or false, or text string where:
		true indicates that the prefix is taken from prefixes.atthe
		false indicates that the prefix is taken from prefixes.at
		'text string' is used in lieu of the typical 'at' or 'at the' prefix
	[2]=wikilink target article that describes the service; set to nil if not used
	[3]=wikilink label; the label in [[target|label]]; set to nil if not used; when there is not article ([2] is nil) use this to name the service; see wikiwix in the table
	[4]=service ID; set to nil if not used
	[5]=tracking category key from the categories table; set to nil if not used
	[6]=postfix; text string to be appended at the end of the tail string - see webarchive.loc.gov in the table

]=]

local services = {
	['archive.ec'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.fo'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.is'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.li'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.md'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.org'] = {true, 'w:Wayback Machine', 'Wayback Machine', 'wayback', categories.wayback},
	['archive.ph'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.today'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive.vn'] = {false, 'w:archive.today', 'archive.today', 'archiveis', categories.archiveis},
	['archive-it.org'] = {false, 'w:Archive-It', 'Archive-It', 'archiveit'},
	['arquivo.pt'] = {true, nil, 'Portuguese Web Archive'},
	['bibalex.org'] = {false, 'w:Bibliotheca Alexandrina#Internet Archive partnership', 'Bibliotheca Alexandrina'},
	['collectionscanada'] = {true, 'w:Canadian Government Web Archive', 'Canadian Government Web Archive'},
	['europarchive.org'] = {true, 'w:National Library of Ireland', 'National Library of Ireland'},
	['freezepage.com'] = {false, nil, 'Freezepage'},
	['haw.nsk'] = {true, 'w:Croatian Web Archive (HAW)', 'Croatian Web Archive (HAW)'},
	['langzeitarchivierung.bib-bvb.de'] = {false, 'w:Bavarian State Library', 'Bavarian State Library'},
	['loc.gov'] = {true, 'w:Library of Congress', 'Library of Congress'},
	['nationalarchives.gov.uk'] = {true, 'w:UK Government Web Archive', 'UK Government Web Archive', 'ukgwa'},
	['nlb.gov.sg'] = {false, 'w:Web Archive Singapore', 'Web Archive Singapore'},
	['parliament.uk'] = {true, 'w:UK Parliament\'s Web Archive', 'UK Parliament\'s Web Archive'},
	['perma.cc'] = {false, 'w:Perma.cc', 'Perma.cc'},
	['perma-archives.cc'] = {false, 'w:Perma.cc', 'Perma.cc'},
	['proni.gov'] = {true, 'w:Public Record Office of Northern Ireland', 'Public Record Office of Northern Ireland'},
	['screenshots.com'] = {false, nil, 'Screenshots'},
	['stanford.edu'] = {true, 'w:Stanford University Libraries', 'Stanford Web Archive'},
	['timetravel.mementoweb.org'] = {false, 'w:Memento Project', 'Memento Project'},
	['uni-lj.si'] = {true, nil, 'Slovenian Web Archive'},
	['veebiarhiiv.digar.ee'] = {true, nil, 'Estonian Web Archive'},
	['vefsafn.is'] = {true, 'w:National and University Library of Iceland', 'National and University Library of Iceland'},
	['webarchive.bac-lac.gc.ca'] = {false, 'w:Library and Archives Canada', 'Library and Archives Canada'},
	['webarchive.loc.gov'] = {true, 'w:Library of Congress', 'Library of Congress', 'locwebarchives', nil, 'Web Archives'},
	['webarchive.nla.gov.au'] = {true, 'w:Australian Web Archive', 'Australian Web Archive'},
	['webarchive.org.uk'] = {true, 'w:UK Web Archive', 'UK Web Archive'},
	['webcache.googleusercontent.com'] = {false, nil, 'Google Cache'},
	['webcitation.org'] = {false, 'w:WebCite', 'WebCite', 'webcite', categories.webcite},
	['webharvest.gov'] = {true, 'w:National Archives and Records Administration', 'National Archives and Records Administration'},
	['webrecorder.io'] = {false, 'w:webrecorder.io', 'webrecorder.io'},
	['wikiwix.com'] = {false, nil, 'Wikiwix'},
	['yorku.ca'] = {false, 'w:York University Libraries', 'York University Digital Library'},
	}


--[[--------------------------< S T A T I C   T E X T >--------------------------------------------------------

for internationalzation

]]

local s_text = {
	addlarchives = 'Lưu trữ khác',
	addlpages = 'Các trang khác lưu trữ ngày',							-- TODO why the &nbsp; there? replace with regular space?
	Archive_index = 'Xem toàn bộ lưu trữ',
	Archived = 'Lưu trữ',
	archived = 'lưu trữ ngày',
	archive = 'toàn bộ',
	Page = 'Trang',
	}


--[[--------------------------< E R R _ W A R N _ M S G S >----------------------------------------------------

these tables hold error and warning message text

]]

local err_warn_msgs = {
	date_err = '(Lỗi ngày)',													-- decodeWebciteDate, decodeWaybackDate, decodeArchiveisDate
	date_miss = '(Thiếu ngày)',												-- parseExtraArgs
	ts_short = '(Độ dài dấu thời gian)',										-- decodeWaybackDate timestamp less than 8 digits
	ts_date = '(Dấu thời gian không hợp lệ)',										-- decodeWaybackDate timestamp not a valid date
	unknown_url = '(Lỗi: URL lưu trữ không rõ)',								-- serviceName
	unnamed_params = '(Tham số vị trí đã bị bỏ qua)',

--warnings
	mismatch = '<sup>(Ngày không khớp)</sup>',									-- webarchive
	ts_len = '<sup>(Độ dài dấu thời gian)</sup>',									-- decodeWaybackDate, decodeArchiveisDate timestamp not 14 digits
	ts_cal = '<sup>(Lịch)</sup>',											-- decodeWaybackDate timestamp has trailing splat
	}


local crit_err_msgs = {															-- critical error messages
	conflicting = 'Mâu thuẫn giữa |$1= và |$2=',
	empty = 'URL trống',
--	iabot1 = 'https://web.http',												-- TODO: these iabot bugs perportedly fixed; removing these causes lua script error
--	iabot2 = 'URL không hợp lệ',														-- at Template:Webarchive/testcases/Production; resolve that before deleting these messages
	invalid_url = 'URL không hợp lệ',
	ts_nan = 'Dấu thời gian không phải là số',
	unknown = 'Lỗi không xác định. Xin hãy báo cáo tại trang thảo luận của bản mẫu',
	}



--[[--------------------------< D A T E   I N T E R N A T I O N A L I Z A T I O N >----------------------------

these tables hold data that is used when converting date formats from non-English languages (because mw.language.getContentLanguage:formatDate()
doesn't understand non-English month names)

]]

local month_num = {																-- retain English language names even though they may not be strictly required on the local wiki
	['January'] = 1, ['February'] = 2, ['March'] = 3, ['April'] = 4, ['May'] = 5, ['June'] = 6, ['July'] = 7, ['August'] = 8, ['September'] = 9, ['October'] = 10, ['November'] = 11, ['December'] = 12,
	['Jan'] = 1, ['Feb'] = 2, ['Mar'] = 3, ['Apr'] = 4, ['May'] = 5, ['Jun'] = 6, ['Jul'] = 7, ['Aug'] = 8, ['Sep'] = 9, ['Oct'] = 10, ['Nov'] = 11, ['Dec'] = 12,
-- add local wiki month-names to number translation here
	['tháng 1 năm'] = 1, ['tháng 2 năm'] = 2, ['tháng 3 năm'] = 3, ['tháng 4 năm'] = 4, ['tháng 5 năm'] = 5, ['tháng 6 năm'] = 6, ['tháng 7 năm'] = 7, ['tháng 8 năm'] = 8, ['tháng 9 năm'] = 9, ['tháng 10 năm'] = 10, ['tháng 11 năm'] = 11, ['tháng 12 năm'] = 12,
	};

																				-- when the local wiki uses non-western digits in dates, local wiki digits must be
																				-- translated to western digits; lua only understands western digits
local digits = {																-- use this table to aid translation
--	[''] = 0, [''] = 1, [''] = 2, [''] = 3, [''] = 4, [''] = 5, [''] = 6, [''] = 7, [''] = 8, [''] = 9,	-- fill these table indexes with local digits
	enable = false																-- set to true to enable local-digit to western-digit translation
	};


--[[--------------------------< P A R A M E T E R   I N T E R N A T I O N A L I Z A T I O N >------------------

this table holds tables of parameter names and their non-English aliases.  In the enum_params table '#' is a single
character placeholder for 1 or more digit characters

parameter names in this table shall be lowercase
]]

local params = {
	['url'] = {'url'},
	['date'] = {'date', 'datum'},
	['title'] = {'title', 'titel'},
	['nolink'] = {'nolink'},
	['format'] = {'format'}
	}

local enum_params = {
	['url#'] = {'url#'},
	['date#'] = {'date#', 'datum#'},
	['title#'] = {'title#', 'titel#'},
	}

local format_vals = {															-- |format= accepts two values; add local language variants here
	['addlpages'] = {'addlpages'},
	['addlarchives'] = {'addlarchives'},
	}


--[[--------------------------< E X P O R T E D   T A B L E S >------------------------------------------------
]]

return {
	categories = categories,
	config = config,
	crit_err_msgs = crit_err_msgs,
	digits = digits,
	enum_params = enum_params,
	err_warn_msgs = err_warn_msgs,
	excepted_pages = excepted_pages,
	format_vals = format_vals,
	month_num = month_num,
	params = params,
	prefixes = prefixes,
	services = services,
	s_text = s_text,
	uncategorized_namespaces = uncategorized_namespaces,
	uncategorized_subpages = uncategorized_subpages,
	}