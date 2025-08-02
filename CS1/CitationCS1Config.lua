local lang_obj = mw.language.getContentLanguage();								-- make a language object for the local language; used here for languages and dates 


--[[--------------------------< S E T T I N G S >--------------------------------------------------------------

boolean settings used to control various things.  these setting located here to make them easy to find

]]
																				-- these settings local to this module only
local local_digits_from_mediawiki = false;										-- for i18n; when true, module fills date_names['local_digits'] from MediaWiki; manual fill required else; always false at en.wiki
local local_date_names_from_mediawiki = false;									-- for i18n; when true, module fills date_names['local']['long'] and date_names['local']['short'] from MediaWiki;
																				-- manual translation required else; ; always false at en.wiki

																				-- these settings exported to other modules
local use_identifier_redirects = true;											-- when true use redirect name for identifier label links; always true at en.wiki
local local_lang_cat_enable = false;											-- when true categorizes pages where |language=<local wiki's language>; always false at en.wiki
local date_name_auto_xlate_enable = false;										-- when true translates English month-names to the local-wiki's language month names; always false at en.wiki
local date_digit_auto_xlate_enable = false;										-- when true translates Western date digit to the local-wiki's language digits (date_names['local_digits']); always false at en.wiki
local enable_sort_keys = true;													-- when true module adds namespace sort keys to error and maintenance category links


--[[--------------------------< U N C A T E G O R I Z E D _ N A M E S P A C E S >------------------------------

List of namespaces that should not be included in citation error categories.
Same as setting notracking = true by default.

Note: Namespace names should use underscores instead of spaces.

]]
local uncategorized_namespaces_t = { 'Thành_viên', 'Thảo_luận', 'Thảo_luận_Thành_viên', 'Thảo_luận_Wikipedia',
	'Thảo_luận_Tập_tin', 'Thảo_luận_Bản_mẫu', 'Thảo_luận_Trợ_giúp', 'Thảo_luận_Thể_loại', 'Thảo_luận_Cổng_thông_tin',
	'Thảo_luận_Mô_đun', 'Thảo_luận_MediaWiki' };

local uncategorized_subpages = {'/[Ss]andbox', '/[Tt]hử', '/[Tt]estcases', '/[Kk]iểm[_ ]thử', '/[^/]*[Ll]og', '/[^/]*[Nn]hật[_ ]trình', '/[Aa]rchive', '/[Ll]ưu'};		-- list of Lua patterns found in page names of pages we should not categorize

--[[
at en.wiki Greek characters are used as sort keys for certain items in a category so that those items are
placed at the end of a category page.  See Wikipedia:Categorization#Sort_keys.  That works well for en.wiki
because English is written using the Latn script.  This may not work well for other languages.  At en.wiki it
is desireable to place content from certain namespaces at the end of a category listing so the module adds sort
keys to error and maintenance category links when rendering a cs1|2 template on a page in that namespace.

i18n: if this does not work well for your language, set <enable_sort_keys> to false.
]]

local name_space_sort_keys = {													-- sort keys to be used with these namespaces:
	[4] = 'ω',																	-- wikipedia; omega
	[10] = 'τ',																	-- template; tau
	[118] = 'Δ', 																-- draft; delta
	['other'] = 'ο',															-- all other non-talk namespaces except main (article); omicron
	}

--[[--------------------------< M E S S A G E S >--------------------------------------------------------------

Translation table

The following contains fixed text that may be output as part of a citation.
This is separated from the main body to aid in future translations of this
module.

]]

local messages = {
	['agency'] = '$1 $2',														-- $1 is sepc, $2 is agency
	['archived-dead'] = '$1 lưu trữ $2',
	['archived-live'] = '$1 bản gốc $2',
	['archived-unfit'] = 'Bản gốc lưu trữ ',
	['archived'] = 'Lưu trữ',
	['by'] = 'Bởi',																-- contributions to authored works: introduction, foreword, afterword
	['cartography'] = '$1 thiết kế bản đồ',
	['editor'] = 'biên tập',
	['editors'] = 'biên tập',
	['edition'] = '(ấn bản thứ $1)',
	['episode'] = 'Tập $1',
	['et al'] = 'và đồng nghiệp',
	['in'] = 'Trong',																-- edited works
	['inactive'] = 'không hoạt động',
	['inset'] = 'Bản đồ lồng $1',
	['interview'] = 'Phỏng vấn viên $1',										
	['mismatch'] = '<code class="cs1-code">&#124;$1=</code> / <code class="cs1-code">&#124;$2=</code> không khớp',	-- $1 is year param name; $2 is date param name
	['newsgroup'] = '[[Nhóm tin Usenet|Nhóm tin]]:&nbsp;$1',
	['notitle'] = 'Không tên',													-- for |title=(()) and (in the future) |title=none
	['original'] = 'Bản gốc',
	['origdate'] = ' [$1]',
	['published'] = ' (xuất bản $1)',
	['retrieved'] = 'Truy cập $1',
	['season'] = 'Mùa $1',
	['section'] = '§&nbsp;$1',
	['sections'] = '§§&nbsp;$1',
	['series'] = '$1 $2',														-- $1 is sepc, $2 is series
	['seriesnum'] = 'Loạt $1',
	['translated'] = '$1 biên dịch',
	['type'] = ' ($1)',															-- for titletype
	['written'] = 'Soạn tại $1',

	['vol'] = '$1 Quyển&nbsp;$2',												-- $1 is sepc; bold journal style volume is in presentation{}
	['vol-no'] = '$1 Quyển&nbsp;$2 số&nbsp;$3',								-- sepc, volume, issue (alternatively insert $1 after $2, but then we'd also have to change capitalization)
	['issue'] = '$1 Số&nbsp;$2',												-- $1 is sepc

	['art'] = '$1 Số&nbsp;$2',												-- $1 is sepc; for {{cite conference}} only
	['vol-art'] = '$1 Quyển&nbsp;$2, số&nbsp;$3',								-- sepc, volume, article-number; for {{cite conference}} only

	['j-vol'] = '$1 $2',														-- sepc, volume; bold journal volume is in presentation{}
	['j-issue'] = ' ($1)',
	['j-article-num'] = ' $1',													-- TODO: any punctuation here? static text?

	['nopp'] = '$1 $2';															-- page(s) without prefix; $1 is sepc

	['p-prefix'] = "$1 tr.&nbsp;$2",												-- $1 is sepc
	['pp-prefix'] = "$1 tr.&nbsp;$2",											-- $1 is sepc
	['j-page(s)'] = ': $1',														-- same for page and pages

	['sheet'] = '$1 Tờ&nbsp;$2',												-- $1 is sepc
	['sheets'] = '$1 Tờ&nbsp;$2',											-- $1 is sepc
	['j-sheet'] = ': Tờ&nbsp;$1',
	['j-sheets'] = ': Tờ&nbsp;$1',
	
	['language'] = '(bằng tiếng $1)',
	['via'] = " &ndash; qua $1",
	['event'] = 'Sự kiện xảy ra vào lúc',
	['minutes'] = 'phút',
	
	-- Determines the location of the help page
	['help page link'] = 'Trợ giúp:Lỗi CS1',
	['help page label'] = 'trợ giúp',
	
	-- categories
	['cat wikilink'] = '[[Thể loại:$1]]',										-- $1 is the category name
	['cat wikilink sk'] = '[[Thể loại:$1|$2]]',									-- $1 is the category name; $2 is namespace sort key
	[':cat wikilink'] = '[[:Thể loại:$1|liên kết]]',								-- category name as maintenance message wikilink; $1 is the category name

	-- Internal errors (should only occur if configuration is bad)
	['undefined_error'] = 'Xuất hiện lỗi không xác định',
	['unknown_ID_key'] = 'Khóa ID không rõ: ',								-- an ID key in id_handlers not found in ~/Identifiers func_map{}
	['unknown_ID_access'] = 'Từ khóa truy cập ID không rõ: ',					-- an ID access keyword in id_handlers not found in keywords_lists['id-access']{}
	['unknown_argument_map'] = 'Ánh xạ đối số không rõ cho biến số này',
	['bare_url_no_origin'] = 'Đã tìm thấy URL trần nhưng phần chỉ nguồn gốc là vô giá trị (nil)',
	
	['warning_msg_e'] = '<span style="color:#d33">Một hay nhiều bản mẫu <code style="color: inherit; background: inherit; border: none; padding: inherit;">&#123;{$1}}</code> đã gặp lỗi chú thích CS1</span>. Cảnh báo này được hiển thị công khai ([[Trợ giúp:Lỗi CS1#Kiểm soát hiển thị thông báo lỗi|trợ giúp]]).';	-- $1 is template link
	['warning_msg_m'] = '<span style="color:#3a3">Một hay nhiều bản mẫu <code style="color: inherit; background: inherit; border: none; padding: inherit;">&#123;{$1}}</code> có thông báo quản lý chú thích CS1</span>. Thông báo này không được hiển thị công khai ([[Trợ giúp:Lỗi CS1#Kiểm soát hiển thị thông báo lỗi|trợ giúp]]).';	-- $1 is template link
	}


--[[--------------------------< C I T A T I O N _ C L A S S _ M A P >------------------------------------------

this table maps the value assigned to |CitationClass= in the cs1|2 templates to the canonical template name when
the value assigned to |CitationClass= is different from the canonical template name.  |CitationClass= values are
used as class attributes in the <cite> tag that encloses the citation so these names may not contain spaces while
the canonical template name may.  These names are used in warning_msg_e and warning_msg_m to create links to the
template's documentation when an article is displayed in preview mode.

Most cs1|2 template |CitationClass= values at en.wiki match their canonical template names so are not listed here.

]]

	local citation_class_map_t = {												-- TODO: if kept, these and all other config.CitationClass 'names' require some sort of i18n
		['arxiv'] = 'arXiv',
		['audio-visual'] = 'video',
		['AV-media-notes'] = 'ghi chú album',
		['biorxiv'] = 'bioRxiv',
		['book'] = 'sách',
		['citeseerx'] = 'CiteSeerX',
		['conference'] = 'hội thảo',
		['document'] = 'tài liệu',
		['encyclopaedia'] = 'bách khoa toàn thư',
		['episode'] = 'phần chương trình',
		['interview'] = 'phỏng vấn',
		['journal'] = 'tập san học thuật',
		['magazine'] = 'tạp chí',
		['mailinglist'] = 'danh sách thư',
		['map'] = 'bản đồ',
		['medrxiv'] = 'medRxiv',
		['news'] = 'báo',
		['newsgroup'] = 'nhóm tin',
		['pressrelease'] = 'thông cáo báo chí',
		['report'] = 'báo cáo',
		['serial'] = 'loạt chương trình',
		['sign'] = 'bảng thông tin',
		['speech'] = 'diễn văn',
		['ssrn'] = 'SSRN',
		['techreport'] = 'báo cáo kỹ thuật',
		['thesis'] = 'luận văn',
		['web'] = 'web',
		}


--[=[-------------------------< E T _ A L _ P A T T E R N S >--------------------------------------------------

This table provides Lua patterns for the phrase "et al" and variants in name text
(author, editor, etc.). The main module uses these to identify and emit the 'etal' message.

]=]

local et_al_patterns = {
	"[;,]? *[\"']*%f[%a][Ee][Tt]%.? *[Aa][Ll][%.;,\"']*$",						-- variations on the 'et al' theme
	"[;,]? *[\"']*%f[%a][Ee][Tt]%.? *[Aa][Ll][Ii][AaIi][Ee]?[%.;,\"']*$",		-- variations on the 'et alia', 'et alii' and 'et aliae' themes (false positive 'et aliie' unlikely to match)
	"[;,]? *%f[%a]and [Oo]thers",												-- an alternative to et al.
	"%[%[ *[Ee][Tt]%.? *[Aa][Ll]%.? *%]%]",										-- a wikilinked form
	"%(%( *[Ee][Tt]%.? *[Aa][Ll]%.? *%)%)",										-- a double-bracketed form (to counter partial removal of ((...)) syntax)
	"[%(%[] *[Ee][Tt]%.? *[Aa][Ll]%.? *[%)%]]",									-- a bracketed form
	"[;,]? *%f[%a]và *[Đđ]ồng *nghiệp",
	}


--[[--------------------------< P R E S E N T A T I O N >------------------------

Fixed presentation markup.  Originally part of citation_config.messages it has
been moved into its own, more semantically correct place.

]]

local presentation = 
	{
	-- .citation-comment class is specified at Help:CS1_errors#Controlling_error_message_display
	['hidden-error'] = '<span class="cs1-hidden-error citation-comment">$1</span>',
	['visible-error'] = '<span class="cs1-visible-error citation-comment">$1</span>',
	['hidden-maint'] = '<span class="cs1-maint citation-comment">$1</span>',
	
	['accessdate'] = '<span class="reference-accessdate">$1$2</span>',			-- to allow editors to hide accessdate using personal CSS

	['bdi'] = '<bdi$1>$2</bdi>',												-- bidirectional isolation used with |script-title= and the like

	['cite'] = '<cite class="$1">$2</cite>';									-- for use when citation does not have a namelist and |ref= not set so no id="..." attribute
	['cite-id'] = '<cite id="$1" class="$2">$3</cite>';							-- for use when when |ref= is set or when citation has a namelist

	['format'] = ' <span class="cs1-format">($1)</span>',						-- for |format=, |chapter-format=, etc.
	['interwiki'] = ' <span class="cs1-format">[bằng tiếng $1]</span>',					-- for interwiki-language-linked author, editor, etc
	['interproj'] = ' <span class="cs1-format">[từ $1]</span>',					-- for interwiki-project-linked author, editor, etc (:d: and :s: supported; :w: ignored)

	-- various access levels, for |access=, |doi-access=, |arxiv=, ...
	-- narrow no-break space &#8239; may work better than nowrap CSS. Or not? Browser support?

	['ext-link-access-signal'] = '<span class="$1" title="$2">$3</span>',		-- external link with appropriate lock icon
		['free'] = {class='id-lock-free', title='Truy cập miễn phí'},			-- classes defined in Module:Citation/CS1/styles.css
		['registration'] = {class='id-lock-registration', title='Yêu cầu đăng ký miễn phí'},
		['limited'] = {class='id-lock-limited', title='Truy cập miễn phí trong giới hạn, thường yêu cầu đăng ký mua'},
		['subscription'] = {class='id-lock-subscription', title='Yêu cầu đăng ký mua quyền truy cập'},

	['interwiki-icon'] = '<span class="$1" title="$2">$3</span>',
		['class-wikisource'] = 'cs1-ws-icon',

	['italic-title'] = "''$1''",

	['kern-left'] = '<span class="cs1-kern-left"></span>$1',					-- spacing to use when title contains leading single or double quote mark
	['kern-right'] = '$1<span class="cs1-kern-right"></span>',					-- spacing to use when title contains trailing single or double quote mark

	['nowrap1'] = '<span class="nowrap">$1</span>',								-- for nowrapping an item: <span ...>yyyy-mm-dd</span>
	['nowrap2'] = '<span class="nowrap">$1</span> $2',							-- for nowrapping portions of an item: <span ...>dd mmmm</span> yyyy (note white space)

	['ocins'] = '<span title="$1" class="Z3988"></span>',
	
	['parameter'] = '<code class="cs1-code">&#124;$1=</code>',
	
	['ps_cs1'] = '.';															-- CS1 style postscript (terminal) character
	['ps_cs2'] = '';															-- CS2 style postscript (terminal) character (empty string)

	['quoted-text'] = '<q>$1</q>',												-- for wrapping |quote= content
	['quoted-title'] = '"$1"',

	['sep_cs1'] = '.',															-- CS1 element separator
	['sep_cs2'] = ',',															-- CS2 separator
	['sep_nl'] = ';',															-- CS1|2 style name-list separator between names is a semicolon
	['sep_nl_and'] = ' và ',													-- used as last nl sep when |name-list-style=and and list has 2 items
	['sep_nl_end'] = '; và ',													-- used as last nl sep when |name-list-style=and and list has 3+ names
	['sep_name'] = ', ',														-- CS1|2 style last/first separator is <comma><space>
	['sep_nl_vanc'] = ',',														-- Vancouver style name-list separator between authors is a comma
	['sep_name_vanc'] = ' ',													-- Vancouver style last/first separator is a space

	['sep_list'] = ', ',														-- used for |language= when list has 3+ items except for last sep which uses sep_list_end
	['sep_list_pair'] = ' và ',												-- used for |language= when list has 2 items
	['sep_list_end'] = ', và ',												-- used as last list sep for |language= when list has 3+ items
	
	['trans-italic-title'] = "&#91;''$1''&#93;",
	['trans-quoted-title'] = "&#91;$1&#93;",									-- for |trans-title= and |trans-quote=
	['vol-bold'] = '$1 <b>$2</b>',												-- sepc, volume; for bold journal cites; for other cites ['vol'] in messages{}
	}

	
--[[--------------------------< A L I A S E S >---------------------------------

Aliases table for commonly passed parameters.

Parameter names on the right side in the assignments in this table must have been
defined in the Whitelist before they will be recognized as valid parameter names

]]

local aliases = {
	['AccessDate'] = {'access-date', 'accessdate', 'ngày truy cập', 'ngày truy nhập'},								-- Used by InternetArchiveBot
	['Agency'] = {'agency', 'thông tấn xã', 'hãng thông tấn', 'hãng tin tức'},
	['ArchiveDate'] = {'archive-date', 'archivedate', 'ngày lưu trữ'},							-- Used by InternetArchiveBot
	['ArchiveFormat'] = {'archive-format', 'định dạng lưu trữ'},
	['ArchiveURL'] = {'archive-url', 'archiveurl', 'url lưu trữ'},								-- Used by InternetArchiveBot
	['ArticleNumber'] = {'article-number', 'số bài viết'},
	['ASINTLD'] = {'ASIN-TLD', 'asin-tld', 'TLD ASIN', 'tên miền cấp cao nhất ASIN'},
	['At'] = {'at', 'tại'},																-- Used by InternetArchiveBot
	['Authors'] = {'people', 'credits', 'người', 'nhiều người', 'những người', 'ghi công'},
	['BookTitle'] = {'book-title', 'booktitle', 'tên sách', 'tựa sách'},
	['Cartography'] = {'cartography', 'thiết kế bản đồ'},
	['Chapter'] = {'chapter', 'contribution', 'entry', 'article', 'section', 'chương', 'mục'},
	['ChapterFormat'] = {'chapter-format', 'contribution-format', 'entry-format',
		'article-format', 'section-format', 'định dạng chương', 'định dạng mục'};
	['ChapterURL'] = {'chapter-url', 'contribution-url', 'entry-url', 'article-url',
		'section-url', 'chapterurl', 'url chương'},	-- Used by InternetArchiveBot
	['ChapterUrlAccess'] = {'chapter-url-access', 'contribution-url-access',
		'entry-url-access', 'article-url-access', 'section-url-access', 'quyền truy cập url chương'},		-- Used by InternetArchiveBot
	['Class'] = {'class', 'lớp'},														-- cite arxiv and arxiv identifier
	['Collaboration'] = {'collaboration', 'cộng tác'},
	['Conference'] = {'conference', 'event', 'hội thảo', 'hội nghị', 'sự kiện'},
	['ConferenceFormat'] = {'conference-format', 'định dạng hội thảo', 'định dạng hội nghị', 'định dạng sự kiện'},
	['ConferenceURL'] = {'conference-url', 'url hội nghị', 'url hội thảo', 'url sự kiện'},										-- Used by InternetArchiveBot
	['Date'] = {'date', 'air-date', 'airdate', 'ngày tháng', 'ngày', 'ngày phát', 'ngày phát sóng'},									-- air-date and airdate for cite episode and cite serial only
	['Degree'] = {'degree', 'học vị'},
	['DF'] = 'df',
	['DisplayAuthors'] = {'display-authors', 'display-subjects', 'số tác giả'},
	['DisplayContributors'] = 'display-contributors',
	['DisplayEditors'] = {'display-editors', 'số biên tập viên', 'số biên tập'},
	['DisplayInterviewers'] = 'display-interviewers',
	['DisplayTranslators'] = 'display-translators',
	['Docket'] = {'docket', 'sổ hiệu'},
	['DoiBroken'] = {'doi-broken-date', 'ngày hư DOI', 'DOI hư', 'DOI hỏng', 'ngày hư doi', 'doi hư', 'doi hỏng'},
	['Edition'] = {'edition', 'ấn bản', 'bản thứ', 'lần in'},
	['Embargo'] = {'pmc-embargo-date', 'cấm vận'},
	['Encyclopedia'] = {'encyclopedia', 'encyclopaedia', 'dictionary', 'bách khoa toàn thư', 'bách khoa thư', 'từ điển bách khoa', 'từ điển', 'tự điển'},			-- cite encyclopedia only
	['Episode'] = {'episode', 'phần', 'tập'},													-- cite serial only TODO: make available to cite episode?
	['Format'] = {'format', 'định dạng'},
	['ID'] = {'id', 'ID', 'mã số', 'docket', 'số ghi án'},
	['Inset'] = {'inset', 'bản đồ lồng'},
	['Issue'] = {'issue', 'number', 'số'},
	['Language'] = {'language', 'lang', 'ngôn ngữ'},
	['MailingList'] = {'mailing-list', 'mailinglist', 'danh sách thư'},							-- cite mailing list only
	['Map'] = {'map', 'bản đồ'},															-- cite map only
	['MapFormat'] = {'map-format', 'định dạng bản đồ'},												-- cite map only
	['MapURL'] = {'map-url', 'mapurl', 'url bản đồ'},											-- cite map only -- Used by InternetArchiveBot
	['MapUrlAccess'] = {'map-url-access', 'quyền truy cập url bản đồ'},									-- cite map only -- Used by InternetArchiveBot
	['Minutes'] = {'minutes', 'phút'},
	['Mode'] = {'mode', 'chế độ'},
	['NameListStyle'] = {'name-list-style', 'kiểu danh sách tên'},
	['Network'] = {'network', 'mạng'},
	['Newsgroup'] = {'newsgroup', 'nhóm tin', 'nhóm tin tức'},												-- cite newsgroup only
	['NoPP'] = {'no-pp', 'nopp', 'không trang'},
	['NoTracking'] = {'no-tracking', 'template-doc-demo', 'không theo dõi'},
	['Number'] = {'number', 'số'},														-- this case only for cite techreport
	['OrigDate'] = {'orig-date', 'orig-year', 'origyear', 'ngày gốc', 'năm gốc'},
	['Others'] = {'others', 'người khác', 'người phỏng vấn'},
	['Page'] = {'page', 'p', 'trang', 'tr'},													-- Used by InternetArchiveBot
	['Pages'] = {'pages', 'pp', 'các trang'},												-- Used by InternetArchiveBot
	['Periodical'] = {'journal', 'tập san', 'tập san học thuật', 'magazine', 'tạp chí', 'newspaper', 'báo', 'ấn phẩm', 'periodical', 'website', 'trang web', 'trang mạng', 'work', 'tác phẩm', 'công trình'},
	['Place'] = {'place', 'location', 'nơi', 'thành phố', 'vị trí', 'địa điểm'},
	['PostScript'] = {'postscript', 'tái bút'},
	['PublicationDate'] = {'publication-date', 'publicationdate', 'ngày xuất bản'},
	['PublicationPlace'] = {'publication-place', 'publicationplace', 'nơi xuất bản', 'thành phố xuất bản'},
	['PublisherName'] = {'publisher', 'institution', 'nhà xuất bản', 'nxb', 'nhà phân phối', 'học viện'},
	['Quote'] = {'quote', 'quotation', 'trích dẫn'},
	['QuotePage'] = {'quote-page', 'trang trích dẫn'},
	['QuotePages'] = {'quote-pages', 'các trang trích dẫn'},
	['Ref'] = {'ref', 'tham khảo'},
	['Scale'] = {'scale', 'tỷ lệ', 'tỉ lệ'},
	['ScriptChapter'] = {'script-chapter', 'script-contribution', 'script-entry', 'script-article', 'script-section'},
	['ScriptEncyclopedia'] = {'script-encyclopedia', 'script-encyclopaedia'},	-- cite encyclopedia only
	['ScriptMap'] = 'script-map',
	['ScriptPeriodical'] = {'script-journal', 'script-magazine', 'script-newspaper',
		'script-periodical', 'script-website', 'script-work'},
	['ScriptQuote'] = 'script-quote',
	['ScriptTitle'] = {'script-title', 'tiêu đề chữ khác'},											-- Used by InternetArchiveBot
	['Season'] = {'season', 'mùa'},
	['Sections'] = {'sections',	'các mục'},												-- cite map only
	['Series'] = {'series', 'version', 'đợt', 'loạt', 'phiên bản'},
	['SeriesLink'] = {'series-link', 'serieslink', 'lk loạt', 'liên kết loạt'},
	['SeriesNumber'] = {'series-number', 'series-no', 'số loạt'},
	['Sheet'] = {'sheet', 'tờ'},														-- cite map only
	['Sheets'] = {'sheets', 'các tờ'},														-- cite map only
	['Station'] = {'station', 'kênh', 'đài'},
	['Time'] = {'time', 'thời gian', 'thì giờ'},
	['TimeCaption'] = {'time-caption', 'chú thích thời gian', 'chú thích thì giờ'},
	['Title'] = {'title', 'tựa đề', 'tiêu đề', 'tên bài'},														-- Used by InternetArchiveBot
	['TitleLink'] = {'title-link', 'episode-link', 'episodelink', 'lk tựa đề', 'liên kết tựa đề', 'lk tiêu đề', 'liên kết tiêu đề', 'lk tên bài', 'liên kết tên bài', 'lk phần', 'liên kết phần', 'lk tập', 'liên kết tập'},	-- Used by InternetArchiveBot
	['TitleNote'] = {'title-note', 'department', 'tờ'},
	['TitleType'] = {'type', 'medium', 'kiểu', 'phương tiện'},
	['TransChapter'] = {'trans-article', 'trans-chapter', 'trans-contribution',
		'trans-entry', 'trans-section', 'dịch chương'},
	['Transcript'] = {'transcript', 'bản sao', 'bản chép lời'},
	['TranscriptFormat'] = {'transcript-format', 'định dạng bản sao', 'định dạng bản chép lời'},
	['TranscriptURL'] = {'transcript-url', 'transcripturl', 'lk bản sao', 'liên kết bản sao', 'lk bản chép lời', 'liên kết bản chép lời'},					-- Used by InternetArchiveBot
	['TransEncyclopedia'] = {'trans-encyclopedia', 'trans-encyclopaedia'},		-- cite encyclopedia only
	['TransMap'] = {'trans-map', 'dịch tên bản đồ'},													-- cite map only
	['TransPeriodical'] = {'trans-journal', 'trans-magazine', 'trans-newspaper', 'trans-periodical', 'trans-website',
		'trans-work', 'dịch tên tập san', 'dịch tên tập san học thuật', 'dịch tên tạp chí', 'dịch tên báo', 'dịch tên ấn phẩm',
		'dịch tên website', 'dịch tên trang web', 'dịch tên trang mạng', 'dịch tên tác phẩm', 'dịch tên công trình'},
	['TransQuote'] = {'trans-quote', 'dịch trích dẫn'},
	['TransTitle'] = {'trans-title', 'dịch tựa đề', 'dịch tiêu đề', 'dịch tên bài'},												-- Used by InternetArchiveBot
	['URL'] = {'url', 'URL', 'địa chỉ'},													-- Used by InternetArchiveBot
	['UrlAccess'] = {'url-access', 'quyền truy cập url'},												-- Used by InternetArchiveBot
	['UrlStatus'] = {'url-status', 'trạng thái url'},												-- Used by InternetArchiveBot
	['Vauthors'] = 'vauthors',
	['Veditors'] = 'veditors',
	['Via'] = {'via', 'qua'},
	['Volume'] = {'volume', 'cuốn', 'vol'},
	['Year'] = {'year', 'năm'},

	['AuthorList-First'] = {"first#", "author-first#", "author#-first", "author-given#", "author#-given",
		"subject-first#", "subject#-first", "subject-given#", "subject#-given",
		"given#", "tên #", "tên#"},
	['AuthorList-Last'] = {"last#", "author-last#", "author#-last", "author-surname#", "author#-surname",
		"subject-last#", "subject#-last", "subject-surname#", "subject#-surname",
		"author#", 'host#', "subject#", "surname#", "họ #", "họ#", "tác giả #", "tác giả#"},
	['AuthorList-Link'] = {"author-link#", "author#-link", "subject-link#",
		"subject#-link", "authorlink#", "author#link", "lk tác giả #", "lk tác giả#"},
	['AuthorList-Mask'] = {"author-mask#", "author#-mask", "subject-mask#", "subject#-mask"},

	['ContributorList-First'] = {'contributor-first#', 'contributor#-first',
		'contributor-given#', 'contributor#-given'},
	['ContributorList-Last'] = {'contributor-last#', 'contributor#-last',
		'contributor-surname#', 'contributor#-surname', 'contributor#'},
	['ContributorList-Link'] = {'contributor-link#', 'contributor#-link'},
	['ContributorList-Mask'] = {'contributor-mask#', 'contributor#-mask'},

	['EditorList-First'] = {"editor-first#", "editor#-first", "editor-given#", "editor#-given",
		"tên biên tập #", "tên biên tập#", "tên biên tập viên #", "tên biên tập viên#"},
	['EditorList-Last'] = {"editor-last#", "editor#-last", "editor-surname#",
		"editor#-surname", "editor#",
		"họ biên tập #", "họ biên tập#", "họ biên tập viên #", "họ biên tập viên#"},
	['EditorList-Link'] = {"editor-link#", "editor#-link",
		"lk biên tập #", "lk biên tập#", "liên kết biên tập #", "liên kết biên tập#",
		"lk biên tập viên #", "lk biên tập viên#", "liên kết biên tập viên #", "liên kết biên tập viên#"},
	['EditorList-Mask'] = {"editor-mask#", "editor#-mask"},
	
	['InterviewerList-First'] = {'interviewer-first#', 'interviewer#-first',
		'interviewer-given#', 'interviewer#-given', 'tên phỏng vấn viên #', 'tên phỏng vấn viên#'},
	['InterviewerList-Last'] = {'interviewer-last#', 'interviewer#-last',
		'interviewer-surname#', 'interviewer#-surname', 'interviewer#', 'họ phỏng vấn viên #', 'họ phỏng vấn viên#'},
	['InterviewerList-Link'] = {'interviewer-link#', 'interviewer#-link',
		'liên kết phỏng vấn viên #', 'liên kết phỏng vấn viên#', 'lk phỏng vấn viên #', 'lk phỏng vấn viên#'},
	['InterviewerList-Mask'] = {'interviewer-mask#', 'interviewer#-mask'},

	['TranslatorList-First'] = {'translator-first#', 'translator#-first',
		'translator-given#', 'translator#-given', 'tên dịch giả #', 'tên dịch giả#'},
	['TranslatorList-Last'] = {'translator-last#', 'translator#-last',
		'translator-surname#', 'translator#-surname', 'translator#', 'họ dịch giả #', 'họ dịch giả#'},
	['TranslatorList-Link'] = {'translator-link#', 'translator#-link', 'liên kết dịch giả #', 'liên kết dịch giả#',
		'lk dịch giả #', 'lk dịch giả#'},
	['TranslatorList-Mask'] = {'translator-mask#', 'translator#-mask'},
	}


--[[--------------------------< P U N C T _ S K I P >---------------------------

builds a table of parameter names that the extraneous terminal punctuation check should not check.

]]

local punct_meta_params = {														-- table of aliases[] keys (meta parameters); each key has a table of parameter names for a value
	'BookTitle', 'Chapter', 'ScriptChapter', 'ScriptTitle', 'Title', 'TransChapter', 'Transcript', 'TransMap',	'TransTitle',	-- title-holding parameters
	'AuthorList-Mask', 'ContributorList-Mask', 'EditorList-Mask', 'InterviewerList-Mask', 'TranslatorList-Mask',	-- name-list mask may have name separators
	'PostScript', 'Quote', 'ScriptQuote', 'TransQuote', 'Ref',											-- miscellaneous
	'ArchiveURL', 'ChapterURL', 'ConferenceURL', 'MapURL', 'TranscriptURL', 'URL',						-- URL-holding parameters
	}

local url_meta_params = {														-- table of aliases[] keys (meta parameters); each key has a table of parameter names for a value
	'ArchiveURL', 'ChapterURL', 'ConferenceURL', 'ID', 'MapURL', 'TranscriptURL', 'URL',		-- parameters allowed to hold urls
	'Page', 'Pages', 'At', 'QuotePage', 'QuotePages',							-- insource locators allowed to hold urls
	}

local function build_skip_table (skip_t, meta_params)
	for _, meta_param in ipairs (meta_params) do								-- for each meta parameter key
		local params = aliases[meta_param];										-- get the parameter or the table of parameters associated with the meta parameter name
		if 'string' == type (params) then
			skip_t[params] = 1;													-- just a single parameter
		else
			for _, param in ipairs (params) do									-- get the parameter name
				skip_t[param] = 1;												-- add the parameter name to the skip table
				local count;
				param, count = param:gsub ('#', '');							-- remove enumerator marker from enumerated parameters
				if 0 ~= count then												-- if removed
					skip_t[param] = 1;											-- add param name without enumerator marker
				end
			end
		end
	end
	return skip_t;
end

local punct_skip = {};
local url_skip = {};


--[[--------------------------< S I N G L E - L E T T E R   S E C O N D - L E V E L   D O M A I N S >----------

this is a list of tlds that are known to have single-letter second-level domain names.  This list does not include
ccTLDs which are accepted in is_domain_name().

]]

local single_letter_2nd_lvl_domains_t = {'cash', 'company', 'foundation', 'media', 'org', 'today'};


--[[-----------< S P E C I A L   C A S E   T R A N S L A T I O N S >------------

This table is primarily here to support internationalization.  Translations in
this table are used, for example, when an error message, category name, etc.,
is extracted from the English alias key.  There may be other cases where
this translation table may be useful.

]]
local is_Latn = 'A-Za-z\195\128-\195\150\195\152-\195\182\195\184-\198\191\199\132-\201\143\225\184\128-\225\187\191';
local special_case_translation = {
	['AuthorList'] = 'danh sách tác giả',											-- used to assemble maintenance category names
	['ContributorList'] = 'danh sách đồng nghiệp',									-- translation of these names plus translation of the base maintenance category names in maint_cats{} table below
	['EditorList'] = 'danh sách biên tập viên',											-- must match the names of the actual categories
	['InterviewerList'] = 'danh sách phỏng vấn viên',									-- this group or translations used by name_has_ed_markup() and name_has_mult_names()
	['TranslatorList'] = 'danh sách dịch giả',
	
																				-- Lua patterns to match pseudo-titles used by InternetArchiveBot and others as placeholder for unknown |title= value
	['archived_copy'] = {														-- used with CS1 maint: Archive[d] copy as title
		['en'] = '^archived?%s+copy$',											-- for English; translators: keep this because templates imported from en.wiki
		['local'] = nil,														-- translators: replace ['local'] = nil with lowercase translation only when bots or tools create generic titles in your language
		},

																				-- Lua patterns to match generic titles; usually created by bots or reference filling tools
																				-- translators: replace ['local'] = nil with lowercase translation only when bots or tools create generic titles in your language
		-- generic titles and patterns in this table should be lowercase only
		-- leave ['local'] nil except when there is a matching generic title in your language
		-- boolean 'true' for plain-text searches; 'false' for pattern searches

	['generic_titles'] = {
		['accept'] = {
			},
		['reject'] = {
			{['en'] = {'^wayback%s+machine$', false},				['local'] = nil},
			{['en'] = {'are you a robot', true},					['local'] = nil},
			{['en'] = {'hugedomains', true},						['local'] = nil},
			{['en'] = {'^[%(%[{<]?no +title[>}%]%)]?$', false},		['local'] = nil},
			{['en'] = {'page not found', true},						['local'] = nil},
			{['en'] = {'subscribe to read', true},					['local'] = nil},
			{['en'] = {'^[%(%[{<]?unknown[>}%]%)]?$', false},		['local'] = nil},
			{['en'] = {'website is for sale', true},				['local'] = nil},
			{['en'] = {'^404', false},								['local'] = nil},
			{['en'] = {'error[ %-]404', false},						['local'] = nil},
			{['en'] = {'internet archive wayback machine', true},	['local'] = nil},
			{['en'] = {'log into facebook', true},					['local'] = nil},
			{['en'] = {'login • instagram', true},					['local'] = nil},
			{['en'] = {'redirecting...', true},						['local'] = nil},
			{['en'] = {'usurped title', true},						['local'] = nil},	-- added by a GreenC bot
			{['en'] = {'webcite query result', true},				['local'] = nil},
			{['en'] = {'wikiwix\'s cache', true},					['local'] = nil},
			}
		},

		-- boolean 'true' for plain-text searches, search string must be lowercase only
		-- boolean 'false' for pattern searches
		-- leave ['local'] nil except when there is a matching generic name in your language

	['generic_names'] = {
		['accept'] = {
			{['en'] = {'%[%[[^|]*%(author%) *|[^%]]*%]%]', false},				['local'] = nil},
			},
		['reject'] = {
			{['en'] = {'about us', true},										['local'] = nil},
			{['en'] = {'%f[%a][Aa]dvisor%f[%A]', false},						['local'] = nil},
			{['en'] = {'allmusic', true},										['local'] = nil},
			{['en'] = {'%f[%a][Aa]uthor%f[%A]', false},							['local'] = nil},
			{['en'] = {'^[Bb]ureau$', false},									['local'] = nil},
			{['en'] = {'business', true},										['local'] = nil},
			{['en'] = {'cnn', true},											['local'] = nil},
			{['en'] = {'collaborator', true},									['local'] = nil},
			{['en'] = {'^[Cc]ompany$', false},									['local'] = nil},
			{['en'] = {'contributor', true},									['local'] = nil},
			{['en'] = {'contact us', true},										['local'] = nil},
			{['en'] = {'correspondent', true},									['local'] = nil},
			{['en'] = {'^[Dd]esk$', false},										['local'] = nil},
			{['en'] = {'directory', true},										['local'] = nil},
			{['en'] = {'%f[%(%[][%(%[]%s*eds?%.?%s*[%)%]]?$', false},			['local'] = nil},
			{['en'] = {'[,%.%s]%f[e]eds?%.?$', false},							['local'] = nil},
			{['en'] = {'^eds?[%.,;]', false},									['local'] = nil},
			{['en'] = {'^[%(%[]%s*[Ee][Dd][Ss]?%.?%s*[%)%]]', false},			['local'] = nil},
			{['en'] = {'%f[%a][Ee]dited%f[%A]', false},							['local'] = nil},
			{['en'] = {'%f[%a][Ee]ditors?%f[%A]', false},						['local'] = nil},
			{['en'] = {'%f[%a][Ee]mail%f[%A]', false},							['local'] = nil},
			{['en'] = {'facebook', true},										['local'] = nil},
			{['en'] = {'google', true},											['local'] = nil},
			{['en'] = {'^[Gg]roup$', false},									['local'] = nil},
			{['en'] = {'home page', true},										['local'] = nil},
			{['en'] = {'^[Ii]nc%.?$', false},									['local'] = nil},
			{['en'] = {'instagram', true},										['local'] = nil},
			{['en'] = {'interviewer', true},									['local'] = nil},
			{['en'] = {'^[Ll]imited$', false},									['local'] = nil},
			{['en'] = {'linkedIn', true},										['local'] = nil},
			{['en'] = {'^[Nn]ews$', false},										['local'] = nil},
			{['en'] = {'[Nn]ews[ %-]?[Rr]oom', false},							['local'] = nil},
			{['en'] = {'pinterest', true},										['local'] = nil},
			{['en'] = {'policy', true},											['local'] = nil},
			{['en'] = {'privacy', true},										['local'] = nil},
			{['en'] = {'reuters', true},										['local'] = nil},
			{['en'] = {'translator', true},										['local'] = nil},
			{['en'] = {'tumblr', true},											['local'] = nil},
			{['en'] = {'twitter', true},										['local'] = nil},
			{['en'] = {'site name', true},										['local'] = nil},
			{['en'] = {'statement', true},										['local'] = nil},
			{['en'] = {'submitted', true},										['local'] = nil},
			{['en'] = {'super.?user', false},									['local'] = nil},
			{['en'] = {'%f['..is_Latn..'][Uu]ser%f[^'..is_Latn..']', false},	['local'] = nil},
			{['en'] = {'verfasser', true},										['local'] = nil},
			}
	}
	}


--[[--------------------------< D A T E _ N A M E S >----------------------------------------------------------

This table of tables lists local language date names and fallback English date names.
The code in Date_validation will look first in the local table for valid date names.
If date names are not found in the local table, the code will look in the English table.

Because citations can be copied to the local wiki from en.wiki, the English is
required when the date-name translation function date_name_xlate() is used.

In these tables, season numbering is defined by
Extended Date/Time Format (EDTF) Specification (https://www.loc.gov/standards/datetime/)
which became part of ISO 8601 in 2019.  See '§Sub-year groupings'. The standard
defines various divisions using numbers 21-41. CS1|2 only supports generic seasons.
EDTF does support the distinction between north and south hemisphere seasons
but CS1|2 has no way to make that distinction.

33-36 = Quarter 1, Quarter 2, Quarter 3, Quarter 4 (3 months each)

The standard does not address 'named' dates so, for the purposes of CS1|2,
Easter and Christmas are defined here as 98 and 99, which should be out of the
ISO 8601 (EDTF) range of uses for a while.

local_date_names_from_mediawiki is a boolean.  When set to:
	true – module will fetch local month names from MediaWiki for both date_names['local']['long'] and date_names['local']['short']; this will unconditionally overwrite manual translations
	false – module will *not* fetch local month names from MediaWiki

Caveat lector:  There is no guarantee that MediaWiki will provide short month names.  At your wiki you can test
the results of the MediaWiki fetch in the debug console with this command (the result is alpha sorted):
	=mw.dumpObject (p.date_names['local'])

While the module can fetch month names from MediaWiki, it cannot fetch the quarter, season, and named date names
from MediaWiki.  Those must be translated manually.

]]

local local_date_names_from_mediawiki = true;									-- when false, manual translation required for date_names['local']['long'] and date_names['local']['short']; overwrites manual translations
																				-- when true, module fetches long and short month names from MediaWiki
local date_names = {
	['en'] = {																	-- English
		['long']	= {['January'] = 1, ['February'] = 2, ['March'] = 3, ['April'] = 4, ['May'] = 5, ['June'] = 6, ['July'] = 7, ['August'] = 8, ['September'] = 9, ['October'] = 10, ['November'] = 11, ['December'] = 12},
		['short']	= {['Jan'] = 1, ['Feb'] = 2, ['Mar'] = 3, ['Apr'] = 4, ['May'] = 5, ['Jun'] = 6, ['Jul'] = 7, ['Aug'] = 8, ['Sep'] = 9, ['Oct'] = 10, ['Nov'] = 11, ['Dec'] = 12},
		['quarter'] = {['First Quarter'] = 33, ['Second Quarter'] = 34, ['Third Quarter'] = 35, ['Fourth Quarter'] = 36},
		['season']	= {['Winter'] = 24, ['Spring'] = 21, ['Summer'] = 22, ['Fall'] = 23, ['Autumn'] = 23},
		['named']	= {['Easter'] = 98, ['Christmas'] = 99},
		},
																				-- when local_date_names_from_mediawiki = false
	['local'] = {																-- replace these English date names with the local language equivalents
		['long']	= {
			['tháng một']=1, ['tháng hai']=2, ['tháng ba']=3, ['tháng tư']=4, ['tháng năm']=5, ['tháng sáu']=6, ['tháng bảy']=7, ['tháng tám']=8, ['tháng chín']=9, ['tháng mười']=10, ['tháng mười một']=11, ['tháng mười hai']=12,
			['Tháng một']=1, ['Tháng hai']=2, ['Tháng ba']=3, ['Tháng tư']=4, ['Tháng năm']=5, ['Tháng sáu']=6, ['Tháng bảy']=7, ['Tháng tám']=8, ['Tháng chín']=9, ['Tháng mười']=10, ['Tháng mười một']=11, ['Tháng mười hai']=12,
			['tháng Một']=1, ['tháng Hai']=2, ['tháng Ba']=3, ['tháng Tư']=4, ['tháng Năm']=5, ['tháng Sáu']=6, ['tháng Bảy']=7, ['tháng Tám']=8, ['tháng Chín']=9, ['tháng Mười']=10, ['tháng Mười một']=11, ['tháng Mười hai']=12,
			['Tháng Một']=1, ['Tháng Hai']=2, ['Tháng Ba']=3, ['Tháng Tư']=4, ['Tháng Năm']=5, ['Tháng Sáu']=6, ['Tháng Bảy']=7, ['Tháng Tám']=8, ['Tháng Chín']=9, ['Tháng Mười']=10, ['Tháng Mười một']=11, ['Tháng Mười hai']=12,
			['tháng Mười Một']=11, ['tháng Mười Hai']=12,
			['Tháng Mười Một']=11, ['Tháng Mười Hai']=12},
		['short']	= {
			['tháng 1']=1, ['tháng 2']=2, ['tháng 3']=3, ['tháng 4']=4, ['tháng 5']=5, ['tháng 6']=6, ['tháng 7']=7, ['tháng 8']=8, ['tháng 9']=9, ['tháng 10']=10, ['tháng 11']=11, ['tháng 12']=12,
			['Tháng 1']=1, ['Tháng 2']=2, ['Tháng 3']=3, ['Tháng 4']=4, ['Tháng 5']=5, ['Tháng 6']=6, ['Tháng 7']=7, ['Tháng 8']=8, ['Tháng 9']=9, ['Tháng 10']=10, ['Tháng 11']=11, ['Tháng 12']=12,
			['tháng 01']=1, ['tháng 02']=2, ['tháng 03']=3, ['tháng 04']=4, ['tháng 05']=5, ['tháng 06']=6, ['tháng 07']=7, ['tháng 08']=8, ['tháng 09']=9,
			['Tháng 01']=1, ['Tháng 02']=2, ['Tháng 03']=3, ['Tháng 04']=4, ['Tháng 05']=5, ['Tháng 06']=6, ['Tháng 07']=7, ['Tháng 08']=8, ['Tháng 09']=9},
		['quarter'] = {
			['quý 1'] = 33, ['quý 2'] = 34, ['quý 3'] = 35, ['quý 4'] = 36,
            ['Quý 1'] = 33, ['Quý 2'] = 34, ['Quý 3'] = 35, ['Quý 4'] = 36,
            ['quí 1'] = 33, ['quí 2'] = 34, ['quí 3'] = 35, ['quí 4'] = 36,
            ['Quí 1'] = 33, ['Quí 2'] = 34, ['Quí 3'] = 35, ['Quí 4'] = 36},
		['season']	= {
			['mùa đông'] = 24, ['mùa xuân'] = 21, ['mùa hè'] = 22, ['mùa hạ'] = 22, ['mùa thu'] = 23,
            ['Mùa đông'] = 24, ['Mùa xuân'] = 21, ['Mùa hè'] = 22, ['Mùa hạ'] = 22, ['Mùa thu'] = 23,
            ['mùa Đông'] = 24, ['mùa Xuân'] = 21, ['mùa Hè'] = 22, ['mùa Hạ'] = 22, ['mùa Thu'] = 23,
            ['Mùa Đông'] = 24, ['Mùa Xuân'] = 21, ['Mùa Hè'] = 22, ['Mùa Hạ'] = 22, ['Mùa Thu'] = 23},
		['named']	= {
			['Phục sinh'] = 98, ['Lễ Phục sinh'] = 98,
			['Giáng sinh'] = 99, ['Giáng Sinh']=99, ['Lễ Giáng Sinh']=99, ['Lễ Giáng sinh']=99, ['Noel']=99, ['Nô-en']=99},
		},
	['inv_local_long'] = {},													-- used in date reformatting & translation; copy of date_names['local'].long where k/v are inverted: [1]='<local name>' etc.
	['inv_local_short'] = {},													-- used in date reformatting & translation; copy of date_names['local'].short where k/v are inverted: [1]='<local name>' etc.
	['inv_local_quarter'] = {},													-- used in date translation; copy of date_names['local'].quarter where k/v are inverted: [1]='<local name>' etc.
	['inv_local_season'] = {},													-- used in date translation; copy of date_names['local'].season where k/v are inverted: [1]='<local name>' etc.
	['inv_local_named'] = {},													-- used in date translation; copy of date_names['local'].named where k/v are inverted: [1]='<local name>' etc.
	['local_digits'] = {['0'] = '0', ['1'] = '1', ['2'] = '2', ['3'] = '3', ['4'] = '4', ['5'] = '5', ['6'] = '6', ['7'] = '7', ['8'] = '8', ['9'] = '9'},	-- used to convert local language digits to Western 0-9
	['xlate_digits'] = {},
	}

if local_date_names_from_mediawiki then											-- if fetching local month names from MediaWiki is enabled
	local long_t = {};
	local short_t = {};
	for i=1, 12 do																-- loop 12x and 
		local name = lang_obj:formatDate('F', '2022-' .. i .. '-1');			-- get long month name for each i
		long_t[name] = i;														-- save it
		name = lang_obj:formatDate('M', '2022-' .. i .. '-1');					-- get short month name for each i
		short_t[name] = i;														-- save it
	end
	date_names['local']['long'] = long_t;										-- write the long table – overwrites manual translation
	date_names['local']['short'] = short_t;										-- write the short table – overwrites manual translation
end
																				-- create inverted date-name tables for reformatting and/or translation
for _, invert_t in pairs {{'long', 'inv_local_long'}, {'short', 'inv_local_short'}, {'quarter', 'inv_local_quarter'}, {'season', 'inv_local_season'}, {'named', 'inv_local_named'}} do
	for name, i in pairs (date_names['local'][invert_t[1]]) do					-- this table is ['name'] = i
		date_names[invert_t[2]][i] = name;										-- invert to get [i] = 'name' for conversions from ymd
	end
end

if local_digits_from_mediawiki then												-- if fetching local digits from MediaWiki is enabled
	local digits_t = {};
	for i=0, 9 do																-- loop 10x and 
		digits_t [lang_obj:formatNum (i)] = tostring (i);						-- format the loop indexer as local lang table index and assign loop indexer (a string) as the value
	end
	date_names['local_digits'] = digits_t;
end

for ld, ed in pairs (date_names.local_digits) do								-- make a digit translation table for simple date translation from en to local language using local_digits table
	date_names.xlate_digits [ed] = ld;											-- en digit becomes index with local digit as the value
end

local df_template_patterns = {													-- table of redirects to {{Use dmy dates}} and {{Use mdy dates}}
	-- '{{ *[Uu]se +(dmy) +dates *[|}]',	-- 1159k								-- sorted by approximate transclusion count
	-- '{{ *[Uu]se +(mdy) +dates *[|}]',	-- 212k
	-- '{{ *[Uu]se +(MDY) +dates *[|}]',	-- 788
	-- '{{ *[Uu]se +(DMY) +dates *[|}]',	-- 343
	-- '{{ *([Mm]dy) *[|}]',				-- 176
	-- '{{ *[Uu]se *(dmy) *[|}]',			-- 156 + 18
	-- '{{ *[Uu]se *(mdy) *[|}]',			-- 149 + 11
	-- '{{ *([Dd]my) *[|}]',				-- 56
	-- '{{ *[Uu]se +(MDY) *[|}]',			-- 5
	-- '{{ *([Dd]MY) *[|}]',				-- 3
	-- '{{ *[Uu]se(mdy)dates *[|}]',		-- 1
	-- '{{ *[Uu]se +(DMY) *[|}]',			-- 0
	-- '{{ *([Mm]DY) *[|}]',				-- 0
	}

local title_object = mw.title.getCurrentTitle();
local content;																	-- done this way  so that unused templates appear in unused-template-reports; self-transcluded makes them look like they are used
if 10 ~= title_object.namespace then											-- all namespaces except Template
	content = title_object:getContent() or '';									-- get the content of the article or ''; new pages edited w/ve do not have 'content' until saved; ve does not preview; phab:T221625
end

local function get_date_format ()
	if not content then															-- nil content when we're in template
		return nil;																-- auto-formatting does not work in Template space so don't set global_df
	end
	for _, pattern in ipairs (df_template_patterns) do							-- loop through the patterns looking for {{Use dmy dates}} or {{Use mdy dates}} or any of their redirects
		local start, _, match = content:find(pattern);							-- match is the three letters indicating desired date format
		if match then
			local use_dates_template = content:match ('%b{}', start);			-- get the whole template
			if use_dates_template:match ('| *cs1%-dates *= *[lsy][sy]?') then	-- look for |cs1-dates=publication date length access-/archive-date length
				return match:lower() .. '-' .. use_dates_template:match ('| *cs1%-dates *= *([lsy][sy]?)');
			else
				return match:lower() .. '-all';									-- no |cs1-dates= k/v pair; return value appropriate for use in |df=
			end
		end
	end
end

local global_df;																-- TODO: add this to <global_cs1_config_t>?


--[[-----------------< V O L U M E ,  I S S U E ,  P A G E S >------------------

These tables hold cite class values (from the template invocation) and identify those templates that support
|volume=, |issue=, and |page(s)= parameters.  Cite conference and cite map require further qualification which
is handled in the main module.

]]

local templates_using_volume = {'citation', 'audio-visual', 'book', 'conference', 'encyclopaedia', 'interview', 'journal', 'magazine', 'map', 'news', 'report', 'techreport', 'thesis'}
local templates_using_issue = {'citation', 'conference', 'episode', 'interview', 'journal', 'magazine', 'map', 'news', 'podcast'}
local templates_not_using_page = {'audio-visual', 'episode', 'mailinglist', 'newsgroup', 'podcast', 'serial', 'sign', 'speech'}

--[[

These tables control when it is appropriate for {{citation}} to render |volume= and/or |issue=.  The parameter
names in the tables constrain {{citation}} so that its renderings match the renderings of the equivalent cs1
templates.  For example, {{cite web}} does not support |volume= so the equivalent {{citation |website=...}} must
not support |volume=.

]]

local citation_no_volume_t = {													-- {{citation}} does not render |volume= when these parameters are used
	'website', 'mailinglist', 'script-website',
	}
local citation_issue_t = {														-- {{citation}} may render |issue= when these parameters are used
	'journal', 'magazine', 'newspaper', 'periodical', 'work',
	'script-journal', 'script-magazine', 'script-newspaper', 'script-periodical', 'script-work',
	}

--[[

Patterns for finding extra text in |volume=, |issue=, |page=, |pages=

]]

local vol_iss_pg_patterns = {
	good_ppattern = '^P[^%.PpGg]',												-- OK to begin with uppercase P: P7 (page 7 of section P), but not p123 (page 123); TODO: this allows 'Pages' which it should not
	bad_ppatterns = {															-- patterns for |page= and |pages=
		'^[Pp][PpGg]?%.?[ %d]',
		'^[Pp][Pp]?%.&nbsp;',													-- from {{p.}} and {{pp.}} templates
		'^[Pp]ages?',
		'^[Pp]gs.?',
		},
	vi_patterns_t = {															-- combined to catch volume-like text in |issue= and issue-like text in |volume=
		'^volumes?',															-- volume-like text
		'^vols?[%.:=]?',

		'^issues?',																--issue-like text
		'^iss[%.:=]?',
		'^numbers?',
		'^nos?%A',																-- don't match 'november' or 'nostradamus'
		'^nr[%.:=]?',
		'^n[%.:= ]',															-- might be a valid issue without separator (space char is sep char here)
		'^n°',																	-- 'n' with degree sign (U+00B0)
		'^№',																	-- precomposed unicode numero character (U+2116)
		},
	}

--[[--------------------------< K E Y W O R D S >-------------------------------

These tables hold keywords for those parameters that have defined sets of acceptable keywords.

]]

--[[-------------------< K E Y W O R D S   T A B L E >--------------------------

this is a list of keywords; each key in the list is associated with a table of
synonymous keywords possibly from different languages.

for I18N: add local-language keywords to value table; do not change the key.
For example, adding the German keyword 'ja':
	['affirmative'] = {'yes', 'true', 'y', 'ja'},

Because CS1|2 templates from en.wiki articles are often copied to other local wikis,
it is recommended that the English keywords remain in these tables.

]]

local keywords = {
	['amp'] = {'&', 'amp', 'ampersand'}, 										-- |name-list-style=
	['and'] = {'and', 'serial', 'và'},												-- |name-list-style=
	['affirmative'] = {'yes', 'true', 'y', 'có'},										-- |no-tracking=, |no-pp= -- Used by InternetArchiveBot
	['afterword'] = {'afterword', 'lời bạt'},												-- |contribution=
	['bot: unknown'] = {'bot: unknown'},										-- |url-status= -- Used by InternetArchiveBot
	['cs1'] = {'cs1'},															-- |mode=
	['cs2'] = {'cs2'},															-- |mode=
	['dead'] = {'dead', 'hư', 'hỏng', 'hư hỏng', 'deviated', 'sai', 'lệch', 'sai lệch', 'thay đổi'},											-- |url-status= -- Used by InternetArchiveBot
	['dmy'] = {'dmy'},															-- |df=
	['dmy-all'] = {'dmy-all'},													-- |df=
	['foreword'] = {'foreword', 'lời tựa'},												-- |contribution=
	['free'] = {'free', 'miễn phí', 'tự do', 'mở'},														-- |<id>-access= -- Used by InternetArchiveBot
	['harv'] = {'harv'},														-- |ref=; this no longer supported; is_valid_parameter_value() called with <invert> = true
	['introduction'] = {'introduction', 'lời giới thiệu', 'lời đầu'},										-- |contribution=
	['limited'] = {'limited', 'hạn chế', 'bị giới hạn'},													-- |url-access= -- Used by InternetArchiveBot
	['live'] = {'live', 'sống', 'hoạt động', 'đang hoạt động', 'còn hoạt động'},														-- |url-status= -- Used by InternetArchiveBot
	['mdy'] = {'mdy'},															-- |df=
	['mdy-all'] = {'mdy-all'},													-- |df=
	['none'] = {'none', 'không có', 'không'},														-- |postscript=, |ref=, |title=, |type= -- Used by InternetArchiveBot
	['off'] = {'off', 'tắt', 'ẩn'},															-- |title= (potentially also: |title-link=, |postscript=, |ref=, |type=)
	['preface'] = {'preface', 'lời nói đầu'},													-- |contribution=
	['registration'] = {'registration', 'đăng ký', 'đăng kí', 'đăng nhập', 'tài khoản'},										-- |url-access= -- Used by InternetArchiveBot
	['subscription'] = {'subscription', 'đăng ký mua', 'đăng kí mua', 'trả phí'},										-- |url-access= -- Used by InternetArchiveBot
	['unfit'] = {'unfit', 'không hợp lệ'},														-- |url-status= -- Used by InternetArchiveBot
	['usurped'] = {'usurped', 'chiếm đoạt', 'cướp đoạt'},													-- |url-status= -- Used by InternetArchiveBot
	['vanc'] = {'vanc'},														-- |name-list-style=
	['ymd'] = {'ymd'},															-- |df=
	['ymd-all'] = {'ymd-all'},													-- |df=
	--	['yMd'] = {'yMd'},														-- |df=; not supported at en.wiki
	--	['yMd-all'] = {'yMd-all'},												-- |df=; not supported at en.wiki
	}


--[[------------------------< X L A T E _ K E Y W O R D S >---------------------

this function builds a list, keywords_xlate{}, of the keywords found in keywords{} where the values from keywords{}
become the keys in keywords_xlate{} and the keys from keywords{} become the values in keywords_xlate{}:
	['affirmative'] = {'yes', 'true', 'y'},		-- in keywords{}
becomes
	['yes'] = 'affirmative',					-- in keywords_xlate{}
	['true'] = 'affirmative',
	['y'] = 'affirmative',

the purpose of this function is to act as a translator between a non-English keyword and its English equivalent
that may be used in other modules of this suite

]]

local function xlate_keywords ()
	local out_table = {};														-- output goes here
	for k, keywords_t in pairs (keywords) do									-- spin through the keywords table
		for _, keyword in ipairs (keywords_t) do								-- for each keyword
			out_table[keyword] = k;												-- create an entry in the output table where keyword is the key
		end
	end
	
	return out_table;
end

local keywords_xlate = xlate_keywords ();										-- the list of translated keywords


--[[----------------< M A K E _ K E Y W O R D S _ L I S T >---------------------

this function assembles, for parameter-value validation, the list of keywords appropriate to that parameter.

keywords_lists{}, is a table of tables from keywords{}

]]

local function make_keywords_list (keywords_lists)
	local out_table = {};														-- output goes here
	
	for _, keyword_list in ipairs (keywords_lists) do							-- spin through keywords_lists{} and get a table of keywords
		for _, keyword in ipairs (keyword_list) do								-- spin through keyword_list{} and add each keyword, ...
			table.insert (out_table, keyword);									-- ... as plain text, to the output list
		end
	end
	return out_table;
end


--[[----------------< K E Y W O R D S _ L I S T S >-----------------------------

this is a list of lists of valid keywords for the various parameters in [key].
Generally the keys in this table are the canonical en.wiki parameter names though
some are contrived because of use in multiple differently named parameters:
['yes_true_y'], ['id-access'].

The function make_keywords_list() extracts the individual keywords from the
appropriate list in keywords{}.

The lists in this table are used to validate the keyword assignment for the
parameters named in this table's keys.

]]

local keywords_lists = {
	['yes_true_y'] = make_keywords_list ({keywords.affirmative}),
	['contribution'] = make_keywords_list ({keywords.afterword, keywords.foreword, keywords.introduction, keywords.preface}),
	['df'] = make_keywords_list ({keywords.dmy, keywords['dmy-all'], keywords.mdy, keywords['mdy-all'], keywords.ymd, keywords['ymd-all']}),
	--	['df'] = make_keywords_list ({keywords.dmy, keywords['dmy-all'], keywords.mdy, keywords['mdy-all'], keywords.ymd, keywords['ymd-all'], keywords.yMd, keywords['yMd-all']}),	-- not supported at en.wiki
	['mode'] = make_keywords_list ({keywords.cs1, keywords.cs2}),
	['name-list-style'] = make_keywords_list ({keywords.amp, keywords['and'], keywords.vanc}),
	['ref'] = make_keywords_list ({keywords.harv}),								-- inverted check; |ref=harv no longer supported
	['url-access'] = make_keywords_list ({keywords.subscription, keywords.limited, keywords.registration}),
	['url-status'] = make_keywords_list ({keywords.dead, keywords.live, keywords.unfit, keywords.usurped, keywords['bot: unknown']}),
	['id-access'] = make_keywords_list ({keywords.free}),
	}


--[[--------------------------< C S 1 _ C O N F I G _ G E T >--------------------------------------------------

fetch and validate values from {{cs1 config}} template to fill <global_cs1_config_t>

no error messages; when errors are detected, the parameter value from {{cs1 config}} is blanked.

Supports all parameters and aliases associated with the metaparameters: DisplayAuthors, DisplayContributors,
DisplayEditors, DisplayInterviewers, DisplayTranslators, NameListStyle, and Mode.  The DisplayWhatever metaparameters
accept numeric values only (|display-authors=etal and the like is not supported).

]]

local global_cs1_config_t = {};													-- TODO: add value returned from get_date_format() to this table?

local function get_cs1_config ()
	if not content then															-- nil content when we're in template
		return nil;																-- auto-formatting does not work in Template space so don't set global_df
	end

	local start = content:find('{{ *[Cc][Ss]1 config *[|}]');					-- <start> is offset into <content> when {{cs1 config}} found; nil else
	if start then
		local cs1_config_template = content:match ('%b{}', start);				-- get the whole template

		if not cs1_config_template then
			return nil;
		end

		local params_t = mw.text.split (cs1_config_template:gsub ('^{{%s*', ''):gsub ('%s*}}$', ''), '%s*|%s*');	-- remove '{{' and '}}'; make a sequence of parameter/value pairs (split on the pipe)
		table.remove (params_t, 1);												-- remove the template name because it isn't a parameter/value pair

		local config_meta_params_t = {'DisplayAuthors', 'DisplayContributors', 'DisplayEditors', 'DisplayInterviewers', 'DisplayTranslators', 'NameListStyle', 'Mode'};
		local meta_param_map_t = {};											-- list of accepted parameter names usable in {{cs1 config}} goes here
		
		for _, meta_param in ipairs (config_meta_params_t) do					-- for i18n using <config_meta_params_t>, map template parameter names to their metaparameter equivalents
			if 'table' == type (aliases[meta_param]) then						-- if <meta_param> is a sequence, 
				for _, param in ipairs (aliases[meta_param]) do					-- extract its contents
					meta_param_map_t[param] = meta_param;						-- and add to <meta_param_map_t>
				end
			else
				meta_param_map_t[aliases[meta_param]] = meta_param;				-- not a sequence so just add the parameter to <meta_param_map_t>
			end
		end

		local keywords_t = {};													-- map valid keywords to their associate metaparameter; reverse form of <keyword_lists[key] for these metaparameters
		for _, metaparam_t in ipairs ({{'NameListStyle', 'name-list-style'}, {'Mode', 'mode'}}) do	-- only these metaparameter / keywords_lists key pairs
			for _, keyword in ipairs (keywords_lists[metaparam_t[2]]) do		-- spin through the list of keywords
				keywords_t[keyword] = metaparam_t[1];							-- add [keyword] = metaparameter to the map
			end
		end

		for _, param in ipairs (params_t) do									-- spin through the {{cs1 config}} parameters and fill <global_cs1_config_t>
			local k, v = param:match ('([^=]-)%s*=%s*(.+)');					-- <k> is the parameter name; <v> is parameter's assigned value
			if k then
				if k:find ('^display') then										-- if <k> is one of the |display-<namelist>= parameters
					if v:match ('%d+') then										-- the assigned value must be digits; doesn't accept 'etal'
						global_cs1_config_t[meta_param_map_t[k]]=v;				-- add the display param and its value to globals table
					end
				else
					if keywords_t[v] == meta_param_map_t[k] then				-- keywords_t[v] returns nil or the metaparam name; these must be the same
						global_cs1_config_t[meta_param_map_t[k]]=v;				-- add the parameter and its value to globals table
					end
				end
			end
		end
	end
end

get_cs1_config ();																-- fill <global_cs1_config_t>


--[[---------------------< S T R I P M A R K E R S >----------------------------

Common pattern definition location for stripmarkers so that we don't have to go
hunting for them if (when) MediaWiki changes their form.

]]

local stripmarkers = {
	['any'] = '\127[^\127]*UNIQ%-%-(%a+)%-[%a%d]+%-QINU[^\127]*\127',			-- capture returns name of stripmarker
	['math'] = '\127[^\127]*UNIQ%-%-math%-[%a%d]+%-QINU[^\127]*\127'			-- math stripmarkers used in coins_cleanup() and coins_replace_math_stripmarker()
	}


--[[------------< I N V I S I B L E _ C H A R A C T E R S >---------------------

This table holds non-printing or invisible characters indexed either by name or
by Unicode group. Values are decimal representations of UTF-8 codes.  The table
is organized as a table of tables because the Lua pairs keyword returns table
data in an arbitrary order.  Here, we want to process the table from top to bottom
because the entries at the top of the table are also found in the ranges specified
by the entries at the bottom of the table.

Also here is a pattern that recognizes stripmarkers that begin and end with the
delete characters.  The nowiki stripmarker is not an error but some others are
because the parameter values that include them become part of the template's
metadata before stripmarker replacement.

]]

local invisible_defs = {
	del = '\127',																-- used to distinguish between stripmarker and del char
	zwj = '\226\128\141',														-- used with capture because zwj may be allowed
	}

local invisible_chars = {
	{'replacement', '\239\191\189'},											-- U+FFFD, EF BF BD
	{'zero width joiner', '('.. invisible_defs.zwj .. ')'},						-- U+200D, E2 80 8D; capture because zwj may be allowed
	{'zero width space', '\226\128\139'},										-- U+200B, E2 80 8B
	{'hair space', '\226\128\138'},												-- U+200A, E2 80 8A
	{'soft hyphen', '\194\173'},												-- U+00AD, C2 AD
	{'horizontal tab', '\009'},													-- U+0009 (HT), 09
	{'line feed', '\010'},														-- U+000A (LF), 0A
	{'no-break space', '\194\160'},												-- U+00A0 (NBSP), C2 A0
	{'carriage return', '\013'},												-- U+000D (CR), 0D
	{'stripmarker', stripmarkers.any},											-- stripmarker; may or may not be an error; capture returns the stripmaker type
	{'delete', '('.. invisible_defs.del .. ')'},								-- U+007F (DEL), 7F; must be done after stripmarker test; capture to distinguish isolated del chars not part of stripmarker
	{'C0 control', '[\000-\008\011\012\014-\031]'},								-- U+0000–U+001F (NULL–US), 00–1F (except HT, LF, CR (09, 0A, 0D))
	{'C1 control', '[\194\128-\194\159]'},										-- U+0080–U+009F (XXX–APC), C2 80 – C2 9F
	--	{'Specials', '[\239\191\185-\239\191\191]'},								-- U+FFF9-U+FFFF, EF BF B9 – EF BF BF
	--	{'Private use area', '[\238\128\128-\239\163\191]'},						-- U+E000–U+F8FF, EE 80 80 – EF A3 BF
	--	{'Supplementary Private Use Area-A', '[\243\176\128\128-\243\191\191\189]'},	-- U+F0000–U+FFFFD, F3 B0 80 80 – F3 BF BF BD
	--	{'Supplementary Private Use Area-B', '[\244\128\128\128-\244\143\191\189]'},	-- U+100000–U+10FFFD, F4 80 80 80 – F4 8F BF BD
	}

--[[

Indic script makes use of zero width joiner as a character modifier so zwj
characters must be left in.  This pattern covers all of the unicode characters
for these languages:
	Devanagari					0900–097F – https://unicode.org/charts/PDF/U0900.pdf
		Devanagari extended		A8E0–A8FF – https://unicode.org/charts/PDF/UA8E0.pdf
	Bengali						0980–09FF – https://unicode.org/charts/PDF/U0980.pdf
	Gurmukhi					0A00–0A7F – https://unicode.org/charts/PDF/U0A00.pdf
	Gujarati					0A80–0AFF – https://unicode.org/charts/PDF/U0A80.pdf
	Oriya						0B00–0B7F – https://unicode.org/charts/PDF/U0B00.pdf
	Tamil						0B80–0BFF – https://unicode.org/charts/PDF/U0B80.pdf
	Telugu						0C00–0C7F – https://unicode.org/charts/PDF/U0C00.pdf
	Kannada						0C80–0CFF – https://unicode.org/charts/PDF/U0C80.pdf
	Malayalam					0D00–0D7F – https://unicode.org/charts/PDF/U0D00.pdf
plus the not-necessarily Indic scripts for Sinhala and Burmese:
	Sinhala						0D80-0DFF - https://unicode.org/charts/PDF/U0D80.pdf
	Myanmar						1000-109F - https://unicode.org/charts/PDF/U1000.pdf
		Myanmar extended A		AA60-AA7F - https://unicode.org/charts/PDF/UAA60.pdf
		Myanmar extended B		A9E0-A9FF - https://unicode.org/charts/PDF/UA9E0.pdf
the pattern is used by has_invisible_chars() and coins_cleanup()

]]

local indic_script = '[\224\164\128-\224\181\191\224\163\160-\224\183\191\225\128\128-\225\130\159\234\167\160-\234\167\191\234\169\160-\234\169\191]';

-- list of emoji that use a zwj character (U+200D) to combine with another emoji
-- from: https://unicode.org/Public/emoji/16.0/emoji-zwj-sequences.txt; version: 16.0; 2024-08-14
-- table created by: [[:en:Module:Make emoji zwj table]]
local emoji_t = {																-- indexes are decimal forms of the hex values in U+xxxx
	[8596] = true,																-- U+2194 ↔ left right arrow
	[8597] = true,																-- U+2195 ↕ up down arrow
	[9760] = true,																-- U+2620 ☠ skull and crossbones
	[9792] = true,																-- U+2640 ♀ female sign
	[9794] = true,																-- U+2642 ♂ male sign
	[9877] = true,																-- U+2695 ⚕ staff of aesculapius
	[9878] = true,																-- U+2696 ⚖ scales
	[9895] = true,																-- U+26A7 ⚧ male with stroke and male and female sign
	[9992] = true,																-- U+2708 ✈ airplane
	[10052] = true,																-- U+2744 ❄ snowflake
	[10084] = true,																-- U+2764 ❤ heavy black heart
	[10145] = true,																-- U+27A1 ➡ black rightwards arrow
	[11035] = true,																-- U+2B1B ⬛ black large square
	[127752] = true,															-- U+1F308 🌈 rainbow
	[127787] = true,															-- U+1F32B 🌫 fog
	[127806] = true,															-- U+1F33E 🌾 ear of rice
	[127859] = true,															-- U+1F373 🍳 cooking
	[127868] = true,															-- U+1F37C 🍼 baby bottle
	[127876] = true,															-- U+1F384 🎄 christmas tree
	[127891] = true,															-- U+1F393 🎓 graduation cap
	[127908] = true,															-- U+1F3A4 🎤 microphone
	[127912] = true,															-- U+1F3A8 🎨 artist palette
	[127979] = true,															-- U+1F3EB 🏫 school
	[127981] = true,															-- U+1F3ED 🏭 factory
	[128102] = true,															-- U+1F466 👦 boy
	[128103] = true,															-- U+1F467 👧 girl
	[128104] = true,															-- U+1F468 👨 man
	[128105] = true,															-- U+1F469 👩 woman
	[128139] = true,															-- U+1F48B 💋 kiss mark
	[128165] = true,															-- U+1F4A5 💥 collision symbol
	[128168] = true,															-- U+1F4A8 💨 dash symbol
	[128171] = true,															-- U+1F4AB 💫 dizzy symbol
	[128187] = true,															-- U+1F4BB 💻 personal computer
	[128188] = true,															-- U+1F4BC 💼 brief case
	[128293] = true,															-- U+1F525 🔥 fire
	[128295] = true,															-- U+1F527 🔧 wrench
	[128300] = true,															-- U+1F52C 🔬 microscope
	[128488] = true,															-- U+1F5E8 🗨 left speech bubble
	[128640] = true,															-- U+1F680 🚀 rocket
	[128658] = true,															-- U+1F692 🚒 fire engine
	[129001] = true,															-- U+1F7E9 🟩 large green square
	[129003] = true,															-- U+1F7EB 🟫 large brown square
	[129309] = true,															-- U+1F91D 🤝 handshake
	[129455] = true,															-- U+1F9AF 🦯 probing cane
	[129456] = true,															-- U+1F9B0 🦰 emoji component red hair
	[129457] = true,															-- U+1F9B1 🦱 emoji component curly hair
	[129458] = true,															-- U+1F9B2 🦲 emoji component bald
	[129459] = true,															-- U+1F9B3 🦳 emoji component white hair
	[129466] = true,															-- U+1F9BA 🦺 safety vest
	[129468] = true,															-- U+1F9BC 🦼 motorized wheelchair
	[129469] = true,															-- U+1F9BD 🦽 manual wheelchair
	[129489] = true,															-- U+1F9D1 🧑 adult
	[129490] = true,															-- U+1F9D2 🧒 child
	[129657] = true,															-- U+1FA79 🩹 adhesive bandage
	[129778] = true,															-- U+1FAF2 🫲 leftwards hand
	}


--[[----------------------< L A N G U A G E   S U P P O R T >-------------------

These tables and constants support various language-specific functionality.

]]

--local this_wiki_code = mw.getContentLanguage():getCode();						-- get this wiki's language code
local this_wiki_code = lang_obj:getCode();										-- get this wiki's language code
if string.match (mw.site.server, 'wikidata') then
		this_wiki_code = mw.getCurrentFrame():callParserFunction('int', {'lang'}); -- on Wikidata so use interface language setting instead
	end

local mw_languages_by_tag_t = mw.language.fetchLanguageNames (this_wiki_code, 'all');	-- get a table of language tag/name pairs known to Wikimedia; used for interwiki tests
local mw_languages_by_name_t = {};
	for k, v in pairs (mw_languages_by_tag_t) do								-- build a 'reversed' table name/tag language pairs know to MediaWiki; used for |language=
		v = mw.ustring.lower (v);												-- lowercase for tag fetch; get name's proper case from mw_languages_by_tag_t[<tag>]
		if mw_languages_by_name_t[v] then										-- when name already in the table
			if 2 == #k or 3 == #k then											-- if tag does not have subtags
				mw_languages_by_name_t[v] = k;									-- prefer the shortest tag for this name
			end
		else																	-- here when name not in the table
			mw_languages_by_name_t[v] = k;										-- so add name and matching tag
		end
	end

local inter_wiki_map = {};														-- map of interwiki prefixes that are language-code prefixes
	for k, v in pairs (mw.site.interwikiMap ('local')) do						-- spin through the base interwiki map (limited to local)
		if mw_languages_by_tag_t[v["prefix"]] then								-- if the prefix matches a known language tag
			inter_wiki_map[v["prefix"]] = true;									-- add it to our local map
		end
	end


--[[--------------------< S C R I P T _ L A N G _ C O D E S >-------------------

This table is used to hold ISO 639-1 two-character and ISO 639-3 three-character
language codes that apply only to |script-title= and |script-chapter=

]]

local script_lang_codes = {
	'ab', 'am', 'ar', 'az', 'be', 'bg', 'bn', 'bo', 'bs', 'ce', 'chr', 'dv', 'dz',
	'el', 'fa', 'grc', 'gu', 'he', 'hi', 'hy', 'ja', 'ka', 'kk', 'km', 'kn', 'ko',
	'ku', 'ky', 'lo', 'mk', 'ml', 'mn', 'mni', 'mr', 'my', 'ne', 'or', 'ota',
	'pa', 'ps', 'ru', 'sd', 'si', 'sr', 'syc', 'ta', 'te', 'tg', 'th', 'ti', 'tt',
	'ug', 'uk', 'ur', 'uz', 'yi', 'yue', 'zh', 'zgh'
	};


--[[---------------< L A N G U A G E   R E M A P P I N G >----------------------

These tables hold language information that is different (correct) from MediaWiki's definitions

For each ['<tag>'] = 'language name' in lang_code_remap{} there must be a matching ['language name'] = {'language name', '<tag>'} in lang_name_remap{}

lang_tag_remap{}:
	key is always lowercase ISO 639-1, -2, -3 language tag or a valid lowercase IETF language tag
	value is properly spelled and capitalized language name associated with <tag>
	only one language name per <tag>;
	key/value pair must have matching entry in lang_name_remap{}

lang_name_remap{}:
	key is always lowercase language name
	value is a table the holds correctly spelled and capitalized language name [1] and associated tag [2] (tag must match a tag key in lang_tag_remap{})
	may have multiple keys referring to a common preferred name and tag; For example:
		['kolsch'] and ['kölsch'] both refer to 'Kölsch' and 'ksh'

]]

local lang_tag_remap = {														-- used for |language= and |script-title= / |script-chapter=
	-- ['als'] = 'Albania Tosk',													-- MediaWiki returns Alemannisch 
	-- ['bh'] = 'Bihar',															-- MediaWiki uses 'bh' as a subdomain name for Bhojpuri Wikipedia: bh.wikipedia.org
	-- ['bla'] = 'Blackfoot',														-- MediaWiki/IANA/ISO 639: Siksika; use en.wiki preferred name
	-- ['bn'] = 'Bengal',															-- MediaWiki returns Bangla
	-- ['ca-valencia'] = 'Valencia',												-- IETF variant of Catalan
	-- ['crh'] = 'Tatar Crưm',
	-- ['fkv'] = 'Kven',															-- MediaWiki returns Kvensk
	-- ['gsw'] = 'Đức Thụy Sĩ',
	-- ['ilo'] = 'Ilokano',														-- MediaWiki/IANA/ISO 639: Iloko; use en.wiki preferred name
	-- ['ksh'] = 'Kölsch',															-- MediaWiki: Colognian; use IANA/ISO 639 preferred name
	-- ['ksh-x-colog'] = 'Köln',												-- override MediaWiki ksh; no IANA/ISO 639 code for Colognian; IETF private code created at Module:Lang/data
	-- ['mis-x-ripuar'] = 'Ripuarian',												-- override MediaWiki ksh; no IANA/ISO 639 code for Ripuarian; IETF private code created at Module:Lang/data
	-- ['nan-tw'] = 'Phúc Kiến Đài Loan',											-- make room for MediaWiki/IANA/ISO 639 nan: Min Nan Chinese and support en.wiki preferred name
	-- ['sr-ec'] = 'Serbia (hệ Cyrillic)',									-- MediaWiki returns српски (ћирилица)
	-- ['sr-el'] = 'Serbia (hệ Latinh)',										-- MediaWiki returns srpski (latinica)
	}

local lang_name_remap = {														-- used for |language=; names require proper capitalization; tags must be lowercase
	['bn'] = {'tiếng Bengal', 'bn'},												-- MediaWiki returns Bangla (the endonym) but we want Bengali (the exonym); here we remap
	['bho'] = {'tiếng Bhojpur', 'bho'},											-- MediaWiki uses 'bh' as a subdomain name for Bhojpuri Wikipedia: bh.wikipedia.org
	['bh'] = {'tiếng Bihar', 'bh'},												-- MediaWiki replaces 'Bihari' with 'Bhojpuri' so 'Bihari' cannot be found
	['bla'] = {'tiếng Blackfoot', 'bla'},										-- MediaWiki/IANA/ISO 639: Siksika; use en.wiki preferred name
	['ksh-x-colog'] = {'tiếng Köln', 'ksh-x-colog'},								-- MediaWiki preferred name for ksh
	['ilo'] = {'tiếng Ilokano', 'ilo'},											-- MediaWiki/IANA/ISO 639: Iloko; use en.wiki preferred name
	['ksh'] = {'tiếng Kölsch', 'ksh'},												-- use IANA/ISO 639 preferred name (use non-diacritical o instead of umlaut ö)
	['fkv'] = {'tiếng Kven', 'fkv'},													-- Unicode CLDR have decided not to support English language name for these two...
	['mis-x-ripuar'] = {'tiếng Ripuarian', 'mis-x-ripuar'},								-- group of dialects; no code in MediaWiki or in IANA/ISO 639
	['gsw'] = {'tiếng Đức Thụy Sĩ', 'gsw'},
	['nan-tw'] = {'tiếng Phúc Kiến Đài Loan', 'nan-tw'},					-- make room for MediaWiki/IANA/ISO 639 nan: Min Nan Chinese 
	['als'] = {'tiếng Albania Tosk', 'als'},								-- MediaWiki replaces 'Tosk Albanian' with 'Alemannisch' so 'Tosk Albanian' cannot be found
	['ca-valencia'] = {'tiếng Valencia', 'ca-valencia'},								-- variant of Catalan; categorizes as Valencian
	
	['af'] = {'tiếng Afrikaans', 'af'},
	['crh'] = {'tiếng Tatar Crưm', 'crh'},
	['nd'] = {'tiếng Bắc Ndebele', 'nd'},
	['nr'] = {'tiếng Nam Ndebele', 'nr'},
	['os'] = {'tiếng Ossetia', 'os'},
	['ps'] = {'tiếng Pashtun', 'ps'},
	['sc'] = {'tiếng Sardegna', 'sc'},
	['sd'] = {'tiếng Sindh', 'sd'},
	['se'] = {'tiếng Bắc Sami', 'se'},
	['st'] = {'tiếng Nam Sotho', 'st'},
	['ug'] = {'tiếng Duy Ngô Nhĩ', 'ug'},
	['wa'] = {'tiếng Wallon', 'wa'},
	['za'] = {'tiếng Tráng', 'za'},
	['elx'] = {'tiếng Elam', 'elx'},
	['ckb'] = {'tiếng Soran', 'ckb'},
	['ka'] = {'tiếng Gruzia', 'ka'},
	
	['ar-001'] = {'tiếng Ả Rập', 'ar'},
	['az-cyrl'] = {'tiếng Azerbaijan', 'az'},
	['be-tarask'] = {'tiếng Belarus', 'be'},
	['be-x-old'] = {'tiếng Belarus', 'be'},
	['de-1901'] = {'tiếng Đức', 'de'},
	['de-at'] = {'tiếng Đức', 'de'},
	['de-ch'] = {'tiếng Đức', 'de'},
	['de-formal'] = {'tiếng Đức', 'de'},
	['el-cy'] = {'tiếng Hy Lạp', 'el'},
	['en-au'] = {'tiếng Anh', 'en'},
	['en-ca'] = {'tiếng Anh', 'en'},
	['en-gb'] = {'tiếng Anh', 'en'},
	['en-in'] = {'tiếng Anh', 'en'},
	['en-jm'] = {'tiếng Anh', 'en'},
	['en-nz'] = {'tiếng Anh', 'en'},
	['en-us'] = {'tiếng Anh', 'en'},
	['eo-hsistemo'] = {'tiếng Quốc Tế Ngữ', 'eo'},
	['eo-xsistemo'] = {'tiếng Quốc Tế Ngữ', 'eo'},
	['es-419'] = {'tiếng Tây Ban Nha', 'es'},
	['es-es'] = {'tiếng Tây Ban Nha', 'es'},
	['es-formal'] = {'tiếng Tây Ban Nha', 'es'},
	['es-mx'] = {'tiếng Tây Ban Nha', 'es'},
	['fr-ca'] = {'tiếng Pháp', 'fr'},
	['fr-ch'] = {'tiếng Pháp', 'fr'},
	['hi-kthi'] = {'tiếng Hindi', 'hi'},
	['hi-latn'] = {'tiếng Hindi', 'hi'},
	['hu-formal'] = {'tiếng Hungary', 'hu'},
	['it'] = {'tiếng Ý', 'it'},
	['it-ch'] = {'tiếng Ý', 'it'},
	['it-it'] = {'tiếng Ý', 'it'},
	['it-sm'] = {'tiếng Ý', 'it'},
	['it-va'] = {'tiếng Ý', 'it'},
	['ja-hani'] = {'tiếng Nhật', 'ja'},
	['ja-hira'] = {'tiếng Nhật', 'ja'},
	['ja-hrkt'] = {'tiếng Nhật', 'ja'},
	['ja-kana'] = {'tiếng Nhật', 'ja'},
	['jv-java'] = {'tiếng Java', 'jv'},
	['kk-arab'] = {'tiếng Kazakh', 'kk'},
	['kk-cn'] = {'tiếng Kazakh', 'kk'},
	['kk-cyrl'] = {'tiếng Kazakh', 'kk'},
	['kk-kz'] = {'tiếng Kazakh', 'kk'},
	['kk-latn'] = {'tiếng Kazakh', 'kk'},
	['kk-tr'] = {'tiếng Kazakh', 'kk'},
	['ko-hani'] = {'tiếng Hàn', 'ko'},
	['ko-kore'] = {'tiếng Hàn', 'ko'},
	['ko-kp'] = {'tiếng Hàn', 'ko'},
	['ks-arab'] = {'tiếng Kashmir', 'ks'},
	['ks-deva'] = {'tiếng Kashmir', 'ks'},
	['ku-arab'] = {'tiếng Kurd', 'ku'},
	['ku-latn'] = {'tiếng Kurd', 'ku'},
	['mn-mong'] = {'tiếng Mông Cổ', 'mn'},
	['ms-arab'] = {'tiếng Mã Lai', 'ms'},
	['nl-be'] = {'tiếng Hà Lan', 'nl'},
	['nl-informal'] = {'tiếng Hà Lan', 'nl'},
	['pi-sidd'] = {'tiếng Pali', 'pi'},
	['ps-af'] = {'tiếng Pashtun', 'ps'},
	['ps-pk'] = {'tiếng Pashtun', 'ps'},
	['pt-ao1990'] = {'tiếng Bồ Đào Nha', 'pt'},
	['pt-br'] = {'tiếng Bồ Đào Nha', 'pt'},
	['pt-colb1945'] = {'tiếng Bồ Đào Nha', 'pt'},
	['pt-pt'] = {'tiếng Bồ Đào Nha', 'pt'},
	['rm-puter'] = {'tiếng Romansh', 'rm'},
	['rm-rumgr'] = {'tiếng Romansh', 'rm'},
	['rm-surmiran'] = {'tiếng Romansh', 'rm'},
	['rm-sursilv'] = {'tiếng Romansh', 'rm'},
	['rm-sutsilv'] = {'tiếng Romansh', 'rm'},
	['rm-vallader'] = {'tiếng Romansh', 'rm'},
	['ro-md'] = {'tiếng Romania', 'ro'},
	['sa-sidd'] = {'tiếng Phạn', 'sa'},
	['sd-deva'] = {'tiếng Sindh', 'sd'},
	['sd-gujr'] = {'tiếng Sindh', 'sd'},
	['sd-khoj'] = {'tiếng Sindh', 'sd'},
	['sd-sind'] = {'tiếng Sindh', 'sd'},
	['se-fi'] = {'tiếng Bắc Sami', 'se'},
	['se-no'] = {'tiếng Bắc Sami', 'se'},
	['se-se'] = {'tiếng Bắc Sami', 'se'},
	['sh-cyrl'] = {'tiếng Serbo-Croatia', 'sh'},
	['sh-latn'] = {'tiếng Serbo-Croatia', 'sh'},
	['sr-cyrl'] = {'tiếng Serbia', 'sr'},
	['sr-ec'] = {'tiếng Serbia', 'sr'},
	['sr-el'] = {'tiếng Serbia', 'sr'},
	['sr-latn'] = {'tiếng Serbia', 'sr'},
	['sr-me'] = {'tiếng Montenegro', 'sr-me'},
	['sw-cd'] = {'tiếng Swahili', 'sw-cd'},
	['tg-cyrl'] = {'tiếng Tajik', 'tg'},
	['tg-latn'] = {'tiếng Tajik', 'tg'},
	['tt-cyrl'] = {'tiếng Tatar', 'tt'},
	['tt-latn'] = {'tiếng Tatar', 'tt'},
	['ug-arab'] = {'tiếng Duy Ngô Nhĩ', 'ug'},
	['ug-latn'] = {'tiếng Duy Ngô Nhĩ', 'ug'},
	['uz-cyrl'] = {'tiếng Uzbek', 'uz'},
	['uz-latn'] = {'tiếng Uzbek', 'uz'},
	['zh-classical'] = {'tiếng Trung', 'zh'},
	['zh-cn'] = {'tiếng Trung', 'zh'},
	['zh-hans'] = {'tiếng Trung', 'zh'},
	['zh-hant'] = {'tiếng Trung', 'zh'},
	['zh-hk'] = {'tiếng Trung', 'zh'},
	['zh-min-nan'] = {'tiếng Mân Nam', 'zh-min-nan'},
	['zh-mo'] = {'tiếng Trung', 'zh'},
	['zh-my'] = {'tiếng Trung', 'zh'},
	['zh-sg'] = {'tiếng Trung', 'zh'},
	['zh-tw'] = {'tiếng Trung', 'zh'},
	['zh-yue'] = {'tiếng Quảng Châu', 'zh-yue'},
	}


--[[---------------< P R O P E R T I E S _ C A T E G O R I E S >----------------

Properties categories. These are used for investigating qualities of citations.

]]

local prop_cats = {
	['foreign-lang-source'] = 'Nguồn CS1 tiếng $1 ($2)',					-- |language= categories; $1 is foreign-language name, $2 is ISO639-1 code
	['foreign-lang-source-2'] = 'Nguồn CS1 ngoại ngữ (ISO 639-2)|$1',	-- |language= category; a cat for ISO639-2 languages; $1 is the ISO 639-2 code used as a sort key
	['interproj-linked-name'] = 'Nguồn CS1 có tên liên kết đến dự án khác|$1',				-- any author, editor, etc that has an interproject link; $1 is interproject tag used as a sort key
	['interwiki-linked-name'] = 'Nguồn CS1 có tên liên kết đến wiki ngôn ngữ khác|$1',				-- any author, editor, etc that has an interwiki link; $1 is interwiki tag used as a sort key; yeilds to interproject
	['local-lang-source'] = 'Nguồn CS1 tiếng $1 ($2)',						-- |language= categories; $1 is local-language name, $2 is ISO639-1 code; not emitted when local_lang_cat_enable is false
	['location-test'] = 'Thử địa điểm CS1',
	['long-vol'] = 'CS1: giá trị quyển dài',									-- probably temporary cat to identify scope of |volume= values longer than 4 characters
	['script'] = 'Nguồn CS1 có chữ $1 ($2)',							-- |script-title=xx: has matching category; $1 is language name, $2 is language tag
	['tracked-param'] = 'Nguồn CS1 có tham số theo dõi: $1',							-- $1 is base (enumerators removed) parameter name
	['unfit'] = 'CS1: URL không phù hợp',												-- |url-status=unfit or |url-status=usurped; used to be a maint cat
	['vanc-accept'] = 'CS1: tên Vancouver có chứa ký tự đánh dấu được chấp nhận',					-- for |vauthors=/|veditors= with accept-as-written markup
	['year-range-abbreviated'] = 'CS1: dãy năm viết tắt',					-- probably temporary cat to identify scope of |date=, |year= values using YYYY–YY form
	}


--[[-------------------< T I T L E _ T Y P E S >--------------------------------

Here we map a template's CitationClass to TitleType (default values for |type= parameter)

]]

local title_types = {
	['AV-media-notes'] = 'Ghi chú album',
	['document'] = 'Tài liệu',
	['interview'] = 'Phỏng vấn',
	['mailinglist'] = 'Danh sách thư',
	['map'] = 'Bản đồ',
	['podcast'] = 'Podcast',
	['pressrelease'] = 'Thông cáo báo chí',
	['report'] = 'Báo cáo',
	['speech'] = 'Diễn văn',
	['techreport'] = 'Báo cáo kỹ thuật',
	['thesis'] = 'Luận văn',
	}


--[[--------------------------< B U I L D _ K N O W N _ F R E E _ D O I _ R E G I S T R A N T S _ T A B L E >--

build a table of doi registrants known to be free-to-read  In a doi, the registrant ID is the series of digits
between the '10.' and the first '/': in doi 10.1100/sommat, 1100 is the registrant ID

see §3.2.2 DOI prefix of the Doi Handbook p. 43
https://www.doi.org/doi-handbook/DOI_Handbook_Final.pdf#page=43

]]

local function build_free_doi_registrants_table()
	local registrants_t = {};
	for _, v in ipairs ({
		'1045', '1074', '1096', '1100', '1155', '1186', '1194', '1371', '1629', '1989', '1999', '2147', '2196', '3285', '3389', '3390',
		'3748', '3814', '3847', '3897', '4061', '4089', '4103', '4172', '4175', '4230', '4236', '4239', '4240', '4249', '4251',
		'4252', '4253', '4254', '4291', '4292', '4329', '4330', '4331', '5194', '5210', '5306', '5312', '5313', '5314',
		'5315', '5316', '5317', '5318', '5319', '5320', '5321', '5334', '5402', '5409', '5410', '5411', '5412',
		'5492', '5493', '5494', '5495', '5496', '5497', '5498', '5499', '5500', '5501', '5527', '5528', '5662',
		'6064', '6219', '7167', '7217', '7287', '7482', '7490', '7554', '7717', '7759', '7766', '11131', '11569', '11647',
		'11648', '12688', '12703', '12715', '12942', '12998', '13105', '14256', '14293', '14303', '15215', '15347', '15412', '15560', '16995',
		'17645', '18637', '19080', '19173', '20944', '21037', '21468', '21767', '22261', '22323', '22459', '24105', '24196', '24966',
		'26775', '30845', '32545', '35711', '35712', '35713', '35995', '36648', '37126', '37532', '37871', '47128',
		'47622', '47959', '52437', '52975', '53288', '54081', '54947', '55667', '55914', '57009', '58647', '59081',
		}) do
			registrants_t[v] = true;											-- build a k/v table of known free-to-read doi registrants
	end

	return registrants_t;
end

local extended_registrants_t = {												-- known free registrants identifiable by the doi suffix incipit
	['1002'] = {'aelm', 'leap'},												-- Advanced Electronic Materials, Learned Publishing
	['1016'] = {'j.heliyon', 'j.nlp', 'j.proche'},								-- Heliyon, Natural Language Processing, Procedia Chemistry
	['1017'] = {'nlp'},															-- Natural Language Processing Journal
	['1046'] = {'j.1365-8711', 'j.1365-246x'},									-- MNRAS, GJI
	['1093'] = {'mnras', 'mnrasl', 'gji', 'rasti'},								-- MNRAS, MNRAS Letters, GJI, RASTI
	['1099'] = {'acmi', 'mic', '00221287', 'mgen'},                             -- Access Microbiology, Microbiology, Journal of General Microbiology, Microbial Genomics
	['1111'] = {'j.1365-2966', 'j.1745-3933', 'j.1365-246X'},					-- MNRAS, MNRAS Letters, GJI
	['1210'] = {'jendso','jcemcr'},												-- Journal of the Endocrine Society, JCEM Case Reports
	['4171'] = {'dm','mag'},												    -- Documenta Mathematica, EMS Magazine
	['14231'] = {'ag'},															-- Algebraic Geometry
	}


--[[===================<< E R R O R   M E S S A G I N G >>======================
]]

--[[----------< E R R O R   M E S S A G E   S U P P L I M E N T S >-------------

I18N for those messages that are supplemented with additional specific text that
describes the reason for the error

TODO: merge this with special_case_translations{}?
]]

local err_msg_supl = {
	['char'] = 'ký tự không hợp lệ',												-- |isbn=, |sbn=
	['check'] = 'giá trị tổng kiểm',														-- |isbn=, |sbn=
	['flag'] = 'cờ',															-- |archive-url=
	['form'] = 'định dạng không hợp lệ',													-- |isbn=, |sbn=
	['group'] = 'số nhóm không hợp lệ',												-- |isbn=
	['initials'] = 'chữ đầu',													-- Vancouver
	['invalid language code'] = 'mã ngôn ngữ không hợp lệ',						-- |script-<param>=
	['journal'] = 'tập san học thuật',													-- |bibcode=
	['length'] = 'số con số',														-- |isbn=, |bibcode=, |sbn=
	['liveweb'] = 'liveweb',													-- |archive-url=
	['missing comma'] = 'thiếu dấu phẩy',										-- Vancouver
	['missing prefix'] = 'thiếu tiền tố',										-- |script-<param>=
	['missing title part'] = 'thiếu phần tiêu đề',								-- |script-<param>=
	['name'] = 'tên',															-- Vancouver
	['non-Latin char'] = 'ký tự không phải chữ Latinh',									-- Vancouver
	['path'] = 'đường dẫn',															-- |archive-url=
	['prefix'] = 'tiền tố không hợp lệ',												-- |isbn=
	['punctuation'] = 'chấm câu',											-- Vancouver
	['save'] = 'lệnh lưu',													-- |archive-url=
	['suffix'] = 'hậu tố',														-- Vancouver
	['timestamp'] = 'dấu thời gian',												-- |archive-url=
	['unknown language code'] = 'mã ngôn ngữ không rõ',						-- |script-<param>=
	['value'] = 'giá trị',														-- |bibcode=
	['year'] = 'năm',															-- |bibcode=
	}


--[[--------------< E R R O R _ C O N D I T I O N S >---------------------------

Error condition table.  This table has two sections: errors at the top, maintenance
at the bottom.  Maint 'messaging' does not have a 'message' (message=nil)

The following contains a list of IDs for various error conditions defined in the
code.  For each ID, we specify a text message to display, an error category to
include, and whether the error message should be wrapped as a hidden comment.

Anchor changes require identical changes to matching anchor in Help:CS1 errors

TODO: rename error_conditions{} to something more generic; create separate error
and maint tables inside that?

]]

local error_conditions = {
	err_accessdate_missing_url = {
		message = '<code class="cs1-code">&#124;ngày truy cập=</code> cần <code class="cs1-code">&#124;url=</code>',
		anchor = 'accessdate_missing_url',
		category = 'Lỗi CS1: ngày truy cập thiếu URL',
		hidden = false
 		},
	err_apostrophe_markup = {
		message = 'Không cho phép mã đánh dấu trong: <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'apostrophe_markup',
		category = 'Lỗi CS1: mã đánh dấu',
		hidden = false
 		},
 	err_archive_date_missing_url = {
		message = '<code class="cs1-code">&#124;ngày lưu trữ=</code> cần <code class="cs1-code">&#124;url lưu trữ=</code>',
		anchor = 'archive_date_missing_url',
		category = 'Lỗi CS1: URL lưu trữ',
		hidden = false
		},
	err_archive_date_url_ts_mismatch = {
		message = 'dấu thời gian <code class="cs1-code">&#124;ngày lưu trữ=</code> / <code class="cs1-code">&#124;url lưu trữ=</code> không khớp; đề xuất $1',
		anchor = 'archive_date_url_ts_mismatch',
		category = 'Lỗi CS1: URL lưu trữ',
		hidden = false
		},
	err_archive_missing_date = {
		message = '<code class="cs1-code">&#124;url lưu trữ=</code> cần <code class="cs1-code">&#124;ngày lưu trữ=</code>',
		anchor = 'archive_missing_date',
		category = 'Lỗi CS1: URL lưu trữ',
		hidden = false
		},
	err_archive_missing_url = {
		message = '<code class="cs1-code">&#124;url lưu trữ=</code> cần <code class="cs1-code">&#124;url=</code>',
		anchor = 'archive_missing_url',
		category = 'Lỗi CS1: URL lưu trữ',
		hidden = false
		},
	err_archive_url = {
		message = '<code class="cs1-code">&#124;archive-url=</code> bị hỏng: $1',	-- $1 is error message detail
		anchor = 'archive_url',
		category = 'Lỗi CS1: URL lưu trữ',
		hidden = false
		},
	err_arxiv_missing = {
		message = 'Cần <code class="cs1-code">&#124;arxiv=</code>',
		anchor = 'arxiv_missing',
		category = 'Lỗi CS1: arXiv',											-- same as bad arxiv
		hidden = false
		},
	err_asintld_missing_asin = {
		message = '<code class="cs1-code">&#124;$1=</code> requires <code class="cs1-code">&#124;asin=</code>',	-- $1 is parameter name
		anchor = 'asintld_missing_asin',
		category = 'Lỗi CS1: ASIN TLD',
		hidden = false
		},
	
	
	err_bad_arxiv = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;arxiv=</code>',
		anchor = 'bad_arxiv',
		category = 'Lỗi CS1: arXiv',
		hidden = false
		},
	err_bad_asin = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;asin=</code>',
		anchor = 'bad_asin',
		category ='Lỗi CS1: ASIN',
		hidden = false
		},
	err_bad_asin_tld = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;asin-tld=</code>',
		anchor = 'bad_asin_tld',
		category ='Lỗi CS1: ASIN TLD',
		hidden = false
		},
	err_bad_bibcode = {
		message = 'Kiểm tra <code class="cs1-code">&#124;bibcode=</code> $1',		-- $1 is error message detail
		anchor = 'bad_bibcode',
		category = 'Lỗi CS1: bibcode',
		hidden = false
		},
	err_bad_biorxiv = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;biorxiv=</code>',
		anchor = 'bad_biorxiv',
		category = 'Lỗi CS1: bioRxiv',
		hidden = false
		},
	
	err_bad_citeseerx = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;citeseerx=</code>',
		anchor = 'bad_citeseerx',
		category = 'Lỗi CS1: citeseerx',
		hidden = false
		},
	err_bad_date = {
		message = 'Kiểm tra giá trị ngày tháng trong: $1',									-- $1 is a parameter name list
		anchor = 'bad_date',
		category = 'Lỗi CS1: ngày tháng',
		hidden = false
		},
	
	err_bad_doi = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;doi=</code>',
		anchor = 'bad_doi',
		category = 'Lỗi CS1: DOI',
		hidden = false
		},
	err_bad_hdl = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;hdl=</code>',
		anchor = 'bad_hdl',
		category = 'Lỗi CS1: HDL',
		hidden = false
		},
	err_bad_isbn = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;isbn=</code>: $1',	-- $1 is error message detail
		anchor = 'bad_isbn',
		category = 'Lỗi CS1: ISBN',
		hidden = false
		},
	err_bad_ismn = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;ismn=</code>',
		anchor = 'bad_ismn',
		category = 'Lỗi CS1: ISMN',
		hidden = false
		},
	err_bad_issn = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;$1issn=</code>',	-- $1 is 'e' or '' for eissn or issn
		anchor = 'bad_issn',
		category = 'Lỗi CS1: ISSN',
		hidden = false
		},
	err_bad_jfm = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;jfm=</code>',
		anchor = 'bad_jfm',
		category = 'Lỗi CS1: JFM',
		hidden = false
		},
	err_bad_jstor = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;jstor=</code>',
		anchor = 'bad_jstor',
		category = 'Lỗi CS1: JSTOR',
		hidden = false
		},
	err_bad_lccn = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;lccn=</code>',
		anchor = 'bad_lccn',
		category = 'Lỗi CS1: LCCN',
		hidden = false
		},
	err_bad_medrxiv = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;medrxiv=</code>',
		anchor = 'bad_medrxiv',
		category = 'Lỗi CS1: medRxiv',
		hidden = false
		},
		err_bad_mr = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;mr=</code>',
		anchor = 'bad_mr',
		category = 'Lỗi CS1: MR',
		hidden = false
		},
	err_bad_oclc = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;oclc=</code>',
		anchor = 'bad_oclc',
		category = 'Lỗi CS1: OCLC',
		hidden = false
		},
	err_bad_ol = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;ol=</code>',
		anchor = 'bad_ol',
		category = 'Lỗi CS1: OL',
		hidden = false
		},
	err_bad_osti = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;osti=</code>',
		anchor = 'bad_osti',
		category = 'Lỗi CS1: OSTI',
		hidden = false
		},
	err_bad_paramlink = {														-- for |title-link=, |author/editor/translator-link=, |series-link=, |episode-link=
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;$1=</code>',		-- $1 is parameter name
		anchor = 'bad_paramlink',
		category = 'Lỗi CS1: liên kết tham số',
		hidden = false
		},
	err_bad_pmc = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;pmc=</code>',
		anchor = 'bad_pmc',
		category = 'Lỗi CS1: PMC',
		hidden = false
		},
	err_bad_pmid = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;pmid=</code>',
		anchor = 'bad_pmid',
		category = 'Lỗi CS1: PMID',
		hidden = false
		},
	err_bad_rfc = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;rfc=</code>',
		anchor = 'bad_rfc',
		category = 'Lỗi CS1: RFC',
		hidden = false
		},
	err_bad_s2cid = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;s2cid=</code>',
		anchor = 'bad_s2cid',
		category = 'Lỗi CS1: S2CID',
		hidden = false
		},
	err_bad_sbn = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;sbn=</code>: $1',	-- $1 is error message detail
		anchor = 'bad_sbn',
		category = 'Lỗi CS1: SBN',
		hidden = false
		},
	err_bad_ssrn = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;ssrn=</code>',
		anchor = 'bad_ssrn',
		category = 'Lỗi CS1: SSRN',
		hidden = false
		},
	err_bad_url = {
		message = 'Kiểm tra giá trị $1',												-- $1 is parameter name
		anchor = 'bad_url',
		category = 'Lỗi CS1: URL',
		hidden = false
		},
	err_bad_usenet_id = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;message-id=</code>',
		anchor = 'bad_message_id',
		category = 'Lỗi CS1: message-id',
		hidden = false
		},
	err_bad_zbl = {
		message = 'Kiểm tra giá trị <code class="cs1-code">&#124;zbl=</code>',
		anchor = 'bad_zbl',
		category = 'Lỗi CS1: Zbl',
		hidden = false
		},
	err_bare_url_missing_title = {
		message = '$1 missing title',											-- $1 is parameter name
		anchor = 'bare_url_missing_title',
		category = 'Lỗi CS1: URL trần',
		hidden = false
		},
	err_biorxiv_missing = {
		message = 'Cần <code class="cs1-code">&#124;biorxiv=</code>',
		anchor = 'biorxiv_missing',
		category = 'Lỗi CS1: bioRxiv',											-- same as bad bioRxiv
		hidden = false
		},
	err_chapter_ignored = {
		message = '<code class="cs1-code">&#124;$1=</code> bị bỏ qua',			-- $1 is parameter name
		anchor = 'chapter_ignored',
		category = 'Lỗi CS1: chương bị bỏ qua',
		hidden = false
		},
	err_citation_missing_title = {
		message = '<code class="cs1-code">&#124;$1=</code> trống hay bị thiếu',	-- $1 is parameter name
		anchor = 'citation_missing_title',
		category = 'Lỗi CS1: thiếu tựa đề',
		hidden = false
		},
	err_citeseerx_missing = {
		message = 'Cần <code class="cs1-code">&#124;citeseerx=</code>',
		anchor = 'citeseerx_missing',
		category = 'Lỗi CS1: citeseerx',										-- same as bad citeseerx
		hidden = false
		},
	err_cite_web_url = {														-- this error applies to cite web and to cite podcast
		message = '<code class="cs1-code">&#124;url=</code> trống hay bị thiếu',
		anchor = 'cite_web_url',
		category = 'Lỗi CS1: cần URL',
		hidden = false
		},
	err_class_ignored = {
		message = '<code class="cs1-code">&#124;lớp=</code> bị bỏ qua',
		anchor = 'class_ignored',
		category = 'Lỗi CS1: lớp',
		hidden = false
		},
	err_contributor_ignored = {
		message = '<code class="cs1-code">&#124;contributor=</code> bị bỏ qua',
		anchor = 'contributor_ignored',
		category = 'Lỗi CS1: đồng nghiệp',
		hidden = false
		},
	err_contributor_missing_required_param = {
		message = '<code class="cs1-code">&#124;đồng nghiệp=</code> cần <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'contributor_missing_required_param',
		category = 'Lỗi CS1: đồng nghiệp',
		hidden = false
		},

	err_deprecated_params = {
		message = 'Chú thích sử dụng tham số <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'deprecated_params',
		category = 'Lỗi CS1: tham số lỗi thời',
		hidden = false
		},
	err_disp_name = {
		message = '<code class="cs1-code">&#124;$1=$2</code> không hợp lệ',			-- $1 is parameter name; $2 is the assigned value
		anchor = 'disp_name',
		category = 'Lỗi CS1: số tên hiển thị',
		hidden = false,
		},
	err_doibroken_missing_doi = {
		message = '<code class="cs1-code">&#124;$1=</code> cần <code class="cs1-code">&#124;doi=</code>',	-- $1 is parameter name
		anchor = 'doibroken_missing_doi',
		category = 'Lỗi CS1: DOI',
		hidden = false
		},
	err_embargo_missing_pmc = {
		message = '<code class="cs1-code">&#124;$1=</code> requires <code class="cs1-code">&#124;pmc=</code>',	-- $1 is parameter name
		anchor = 'embargo_missing_pmc',
		category = 'Lỗi CS1: PMC embargo',
		hidden = false
		},
	err_empty_citation = {
		message = 'Chú thích trống',
		anchor = 'empty_citation',
		category = 'Lỗi CS1: chú thích trống',
		hidden = false
		},
	err_etal = {
		message = '“Và đồng nghiệp” được ghi trong: <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'explicit_et_al',
		category = 'Lỗi CS1: và-đồng-nghiệp rõ ràng',
		hidden = false
		},
	err_extra_text_edition = {
		message = '<code class="cs1-code">&#124;ấn bản=</code> có văn bản dư',
		anchor = 'extra_text_edition',
		category = 'Lỗi CS1: văn bản thừa: ấn bản',
		hidden = false,
		},
	err_extra_text_issue = {
		message = '<code class="cs1-code">&#124;$1=</code> có văn bản dư',		-- $1 is parameter name
		anchor = 'extra_text_issue',
		category = 'Lỗi CS1: văn bản thừa: số',
		hidden = false,
		},
	err_extra_text_pages = {
		message = '<code class="cs1-code">&#124;$1=</code> có văn bản dư',		-- $1 is parameter name
		anchor = 'extra_text_pages',
		category = 'Lỗi CS1: văn bản thừa: trang',
		hidden = false,
		},
	err_extra_text_volume = {
		message = '<code class="cs1-code">&#124;$1=</code> có văn bản thừa',		-- $1 is parameter name
		anchor = 'extra_text_volume',
		category = 'Lỗi CS1: văn bản thừa: volume',
		hidden = true,
		},
	err_first_missing_last = {
		message = '<code class="cs1-code">&#124;$1=</code> thiếu <code class="cs1-code">&#124;$2=</code>',	-- $1 is first alias, $2 is matching last alias
		anchor = 'first_missing_last',
		category = 'Lỗi CS1: thiếu tên', -- author, contributor, editor, interviewer, translator
		hidden = false
		},
	err_format_missing_url = {
		message = '<code class="cs1-code">&#124;$1=</code> cần <code class="cs1-code">&#124;$2=</code>',	-- $1 is format parameter $2 is url parameter
		anchor = 'format_missing_url',
		category = 'Lỗi CS1: định dạng thiếu URL',
		hidden = false
		},
	err_generic_name = {
		message = '<code class="cs1-code">&#124;$1=</code> có tên chung',	-- $1 is parameter name
		anchor = 'generic_name',
		category = 'Lỗi CS1: tên chung',
		hidden = false,
		},
	err_generic_title = {
		message = 'Chú thích có tiêu đề chung',
		anchor = 'generic_title',
		category = 'Lỗi CS1: tiêu đề chung',
		hidden = false,
		},
	err_invalid_isbn_date = {
		message = 'ISBN / Ngày không hợp lệ',
		anchor = 'invalid_isbn_date',
		category = 'Lỗi CS1: ngày ISBN',
		hidden = false
		},
	err_invalid_param_val = {
		message = '<code class="cs1-code">&#124;$1=$2</code> không hợp lệ',			-- $1 is parameter name $2 is parameter value
		anchor = 'invalid_param_val',
		category = 'Lỗi CS1: giá trị tham số không hợp lệ',
		hidden = false
		},
	err_invisible_char = {
		message = '$1 trong $2 tại ký tự số $3',									-- $1 is invisible char $2 is parameter name $3 is position number
		anchor = 'invisible_char',
		category = 'Lỗi CS1: ký tự ẩn',
		hidden = false
		},
	err_medrxiv_missing = {
		message = '<code class="cs1-code">&#124;medrxiv=</code> là bắt buộc',
		anchor = 'medrxiv_missing',
		category = 'Lỗi CS1: medRxiv',										-- same as bad medRxiv
		hidden = false
		},
	err_missing_name = {
		message = '<code class="cs1-code">&#124;$1$2=</code> bị thiếu',			-- $1 is modified NameList; $2 is enumerator
		anchor = 'missing_name',
		category = 'Lỗi CS1: thiếu tên',									-- author, contributor, editor, interviewer, translator
		hidden = false
		},
	err_missing_periodical = {
		message = 'Chú thích $1 cần <code class="cs1-code">&#124;$2=</code>',	-- $1 is cs1 template name; $2 is canonical periodical parameter name for cite $1
		anchor = 'missing_periodical',
		category = 'Lỗi CS1: thiếu tạp chí',
		hidden = true
		},
	err_missing_pipe = {
		message = 'Thiếu dấu sổ thẳng trong: <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'missing_pipe',
		category = 'Lỗi CS1: thiếu dấu sổ thẳng',
		hidden = false
		},
	err_missing_publisher = {
		message = 'Chú thích $1 cần <code class="cs1-code">&#124;$2=</code>',	-- $1 is cs1 template name; $2 is canonical publisher parameter name for cite $1
		anchor = 'missing_publisher',
		category = 'Lỗi CS1: thiếu nhà xuất bản',
		hidden = false
		},
	err_numeric_names = {
		message = '<code class="cs1-code">&#124;$1=</code> có tên số',	-- $1 is parameter name',
		anchor = 'numeric_names',
		category = 'Lỗi CS1: tên số',
		hidden = false,
		},
	err_param_access_requires_param = {
		message = '<code class="cs1-code">&#124;$1-access=</code> cần <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'param_access_requires_param',
		category = 'Lỗi CS1: param-access',
		hidden = false
		},
	err_param_has_ext_link = {
		message = 'Liên kết ngoài trong <code class="cs1-code">$1</code>',			-- $1 is parameter name
		anchor = 'param_has_ext_link',
		category = 'Lỗi CS1: liên kết ngoài',
		hidden = false
		},
	err_param_has_twl_url = {
		message = 'Liên kết Wikipedia Library trong <code class="cs1-code">$1</code>',	-- $1 is parameter name
		anchor = 'param_has_twl_url',
		category = 'Lỗi CS1: URL',
		hidden = false
		},
	err_parameter_ignored = {
		message = 'Đã bỏ qua tham số không rõ <code class="cs1-code">&#124;$1=</code>',	-- $1 is parameter name
		anchor = 'parameter_ignored',
		category = 'Lỗi CS1: tham số không rõ',
		hidden = false
		},
	err_parameter_ignored_suggest = {
		message = 'Đã bỏ qua tham số không rõ <code class="cs1-code">&#124;$1=</code> (gợi ý <code class="cs1-code">&#124;$2=</code>)',	-- $1 is unknown parameter $2 is suggested parameter name
		anchor = 'parameter_ignored_suggest',
		category = 'Lỗi CS1: tham số không rõ',
		hidden = false
		},
	err_periodical_ignored = {
		message = 'Đã bỏ qua <code class="cs1-code">&#124;$1=</code>',			-- $1 is parameter name
		anchor = 'periodical_ignored',
		category = 'Lỗi CS1: ấn phẩm bị bỏ qua',
		hidden = false
		},
	err_redundant_parameters = {
		message = 'Đã định rõ hơn một tham số trong $1',						-- $1 is error message detail
		anchor = 'redundant_parameters',
		category = 'Lỗi CS1: tham số thừa',
		hidden = false
		},
	err_script_parameter = {
		message = '<code class="cs1-code">&#124;$1=</code> không hợp lệ: $2',	-- $1 is parameter name $2 is script language code or error detail
		anchor = 'script_parameter',
		category = 'Lỗi CS1: tham số hệ thống viết',
		hidden = false
		},
	err_ssrn_missing = {
		message = 'Cần <code class="cs1-code">&#124;ssrn=</code>',
		anchor = 'ssrn_missing',
		category = 'Lỗi CS1: SSRN',												-- same as bad arxiv
		hidden = false
		},
	err_text_ignored = {
		message = 'Đã bỏ qua văn bản “$1”',										-- $1 is ignored text
		anchor = 'text_ignored',
		category = 'Lỗi CS1: tham số không tên',
		hidden = false
		},
	err_trans_missing_title = {
		message = '<code class="cs1-code">&#124;dịch $1=</code> cần <code class="cs1-code">&#124;$1=</code> hoặc <code class="cs1-code">&#124;script-$1=</code>',	-- $1 is base parameter name
		anchor = 'trans_missing_title',
		category = 'Lỗi CS1: dịch tiêu đề',
		hidden = false
		},
	err_param_unknown_empty = {
		message = 'Chú thích có $1 tham số trống không rõ: $2',					-- $1 is 'các' or empty space; $2 is emty unknown param list
		anchor = 'param_unknown_empty',
		category = 'Lỗi CS1: tham số trống không rõ',
		hidden = false
		},
	err_vancouver = {
		message = 'Lỗi văn phong Vancouver: $1 trong tên $2',					-- $1 is error detail, $2 is the nth name
		anchor = 'vancouver',
		category = 'Lỗi CS1: văn phong Vancouver',
		hidden = false
		},
	err_wikilink_in_url = {
		message = 'Tựa đề URL chứa liên kết wiki',								-- uses ndash
		anchor = 'wikilink_in_url',
		category = 'Lỗi CS1: URL chứa liên kết wiki',							-- uses ndash
		hidden = false
		},


--[[--------------------------< M A I N T >-------------------------------------

maint messages do not have a message (message = nil); otherwise the structure
is the same as error messages

]]

	maint_archived_copy = {
		message = nil,
		anchor = 'archived_copy',
		category = 'Quản lý CS1: bản lưu trữ là tiêu đề',
		hidden = true,
		},
	maint_bibcode = {
		message = nil,
		anchor = 'bibcode',
		category = 'Quản lý CS1: bibcode',
		hidden = true,
		},
	maint_location_no_publisher = {												-- cite book, conference, encyclopedia; citation as book cite or encyclopedia cite
		message = nil,
		anchor = 'location_no_publisher',
		category = 'Quản lý CS1: địa điểm thiếu nhà xuất bản',
		hidden = true,
		},
	maint_bot_unknown = {
		message = nil,
		anchor = 'bot:_unknown',
		category = 'Quản lý CS1: bot: trạng thái URL ban đầu không rõ',
		hidden = true,
		},
	maint_date_auto_xlated = {													-- date auto-translation not supported by en.wiki
		message = nil,
		anchor = 'date_auto_xlated',
		category = 'Quản lý CS1: ngày được dịch tự động',
		hidden = true,
		},
	maint_date_format = {
		message = nil,
		anchor = 'date_format',
		category = 'Quản lý CS1: định dạng ngày tháng',
		hidden = true,
		},
	maint_date_year = {
		message = nil,
		anchor = 'date_year',
		category = 'Quản lý CS1: ngày tháng và năm',
		hidden = true,
		},
	maint_doi_ignore = {
		message = nil,
		anchor = 'doi_ignore',
		category = 'Quản lý CS1: lỗi DOI bị bỏ qua',
		hidden = true,
		},
	maint_doi_inactive = {
		message = nil,
		anchor = 'doi_inactive',
		category = 'Quản lý CS1: DOI không hoạt động',
		hidden = true,
		},
	maint_doi_inactive_dated = {
		message = nil,
		anchor = 'doi_inactive_dated',
		category = 'Quản lý CS1: DOI không hoạt động tính đến $2$3$1',						-- $1 is year, $2 is month-name or empty string, $3 is space or empty string
		hidden = true,
		},
	maint_doi_unflagged_free = {
		message = nil,
		anchor = 'doi_unflagged_free',
		category = 'Quản lý CS1: DOI truy cập mở nhưng không được đánh ký hiệu',
		hidden = true,
		},
	maint_extra_punct = {
		message = nil,
		anchor = 'extra_punct',
		category = 'Quản lý CS1: dấu chấm câu dư',
		hidden = true,
		},
	maint_id_limit_load_fail = {												-- applies to all cs1|2 templates on a page; 
		message = nil,															-- maint message (category link) never emitted
		anchor = 'id_limit_load_fail',
		category = 'Quản lý CS1: Tải giới hạn ID không thành công',
		hidden = true,
		},
	maint_isbn_ignore = {
		message = nil,
		anchor = 'ignore_isbn_err',
		category = 'Quản lý CS1: lỗi ISBN bị bỏ qua',
		hidden = true,
		},
	maint_issn_ignore = {
		message = nil,
		anchor = 'ignore_issn',
		category = 'Quản lý CS1: lỗi ISSN bị bỏ qua',
		hidden = true,
		},
	maint_jfm_format = {
		message = nil,
		anchor = 'jfm_format',
		category = 'Quản lý CS1: định dạng JFM',
		hidden = true,
		},
	maint_location = {
		message = nil,
		anchor = 'location',
		category = 'Quản lý CS1: địa điểm',
		hidden = true,
	},
	maint_mr_format = {
		message = nil,
		anchor = 'mr_format',
		category = 'Quản lý CS1: định dạng MR',
		hidden = true,
	},
	maint_mult_names = {
		message = nil,
		anchor = 'mult_names',
		category = 'Quản lý CS1: nhiều tên: $1',								-- $1 is '<name>s list'; gets value from special_case_translation table
		hidden = true,
		},
	maint_numeric_names = {
		message = nil,
		anchor = 'numeric_names',
		category = 'Quản lý CS1: tên số: $1',								-- $1 is '<name>s list'; gets value from special_case_translation table
		hidden = true,
		},
	maint_others = {
		message = nil,
		anchor = 'others',
		category = 'Quản lý CS1: khác',
		hidden = true,
		},
	maint_others_avm = {
		message = nil,
		anchor = 'others_avm',
		category = 'Quản lý CS1: tham số others trong cite AV media',
		hidden = true,
	},
	maint_overridden_setting = {
		message = nil,
		anchor = 'overridden',
		category = 'Quản lý CS1: thiết lập ghi đè',
		hidden = true,
		},
	maint_pmc_embargo = {
		message = nil,
		anchor = 'embargo',
		category = 'Quản lý CS1: cấm vận PMC hết hạn',
		hidden = true,
		},
	maint_pmc_format = {
		message = nil,
		anchor = 'pmc_format',
		category = 'Quản lý CS1: định dạng PMC',
		hidden = true,
		},
	maint_postscript = {
		message = nil,
		anchor = 'postscript',
		category = 'Quản lý CS1: postscript',
		hidden = true,
	},
	maint_publisher_location = {
		message = nil,
		anchor = 'publisher_location',
		category = 'Quản lý CS1: địa điểm nhà xuất bản',
		hidden = true,
	},
	maint_ref_duplicates_default = {
		message = nil,
		anchor = 'ref_default',
		category = 'Quản lý CS1: ref trùng mặc định',
		hidden = true,
	},
	maint_unknown_lang = {
		message = nil,
		anchor = 'unknown_lang',
		category = 'Quản lý CS1: ngôn ngữ không rõ',
		hidden = true,
		},
	maint_untitled = {
		message = nil,
		anchor = 'untitled',
		category = 'Quản lý CS1: tạp chí không tên',
		hidden = true,
		},
	maint_url_status = {
		message = nil,
		anchor = 'url_status',
		category = 'Quản lý CS1: trạng thái URL',
		hidden = true,
		},
	maint_year= {
		message = nil,
		anchor = 'year',
		category = 'Quản lý CS1: năm',
		hidden = true,
		},
	maint_zbl = {
		message = nil,
		anchor = 'zbl',
		category = 'Quản lý CS1: Zbl',
		hidden = true,
		},
	}


--[[--------------------------< I D _ L I M I T S _ D A T A _ T >----------------------------------------------

fetch id limits for certain identifiers from c:Data:CS1/Identifier limits.tab.  This source is a json tabular 
data file maintained at wikipedia commons.  Convert the json format to a table of k/v pairs.

The values from <id_limits_data_t> are used to set handle.id_limit.

From 2025-02-21, MediaWiki is broken.  Use this link to edit the tablular data file:
	https://commons.wikimedia.org/w/index.php?title=Data:CS1/Identifier_limits.tab&action=edit
See Phab:T389105

]]

local id_limits_data_t = {};

local use_commons_data = true;													-- set to false if your wiki does not have access to mediawiki commons; then,
if false == use_commons_data then												-- update this table from https://commons.wikimedia.org/wiki/Data:CS1/Identifier_limits.tab; last update: 2025-02-21
	id_limits_data_t = {['OCLC'] = 10450000000, ['OSTI'] = 23010000, ['PMC'] = 11900000, ['PMID'] = 40400000, ['RFC'] = 9300, ['SSRN'] = 5200000, ['S2CID'] = 276000000};	-- this table must be maintained locally

else																			-- here for wikis that do have access to mediawiki commons
	local load_fail_limit = 99999999999;										-- very high number to avoid error messages on load failure
	id_limits_data_t = {['OCLC'] = load_fail_limit, ['OSTI'] = load_fail_limit, ['PMC'] = load_fail_limit, ['PMID'] = load_fail_limit, ['RFC'] = load_fail_limit, ['SSRN'] = load_fail_limit, ['S2CID'] = load_fail_limit};

	local id_limits_data_load_fail = false;										-- flag; assume that we will be successful when loading json id limit tabular data
	
	local tab_data_t = mw.ext.data.get ('CS1/Identifier limits.tab').data;		-- attempt to load the json limit data from commons into <tab_data_t>
	if false == tab_data_t then													-- undocumented 'feature': mw.ext.data.get() sometimes returns false
		id_limits_data_load_fail = true;										-- set the flag so that Module:Citation/CS1 can create an unannotated maint category
	else
		for _, limit_t in ipairs (tab_data_t) do								-- overwrite default <load_fail_limit> values
			id_limits_data_t[limit_t[1]] = limit_t[2];							-- <limit[1]> is identifier; <limit[2]> is upper limit for that identifier
		end
	end
end


--[[--------------------------< I D _ H A N D L E R S >--------------------------------------------------------

The following contains a list of values for various defined identifiers.  For each
identifier we specify a variety of information necessary to properly render the
identifier in the citation.

	parameters: a list of parameter aliases for this identifier; first in the list is the canonical form
	link: Wikipedia article name
	redirect: a local redirect to a local Wikipedia article name;  at en.wiki, 'ISBN (identifier)' is a redirect to 'International Standard Book Number'
	q: Wikidata q number for the identifier
	label: the label preceding the identifier; label is linked to a Wikipedia article (in this order):
		redirect from id_handlers['<id>'].redirect when use_identifier_redirects is true
		Wikidata-supplied article name for the local wiki from id_handlers['<id>'].q
		local article name from id_handlers['<id>'].link
	prefix: the first part of a URL that will be concatenated with a second part which usually contains the identifier
	suffix: optional third part to be added after the identifier
	encode: true if URI should be percent-encoded; otherwise false
	COinS: identifier link or keyword for use in COinS:
		for identifiers registered at info-uri.info use: info:.... where '...' is the appropriate identifier label 
		for identifiers that have COinS keywords, use the keyword: rft.isbn, rft.issn, rft.eissn
		for |asin= and |ol=, which require assembly, use the keyword: url
		for others make a URL using the value in prefix/suffix and #label, use the keyword: pre (not checked; any text other than 'info', 'rft', or 'url' works here)
		set to nil to leave the identifier out of the COinS
	separator: character or text between label and the identifier in the rendered citation
	id_limit: for those identifiers with established limits, this property holds the upper limit
	access: use this parameter to set the access level for all instances of this identifier.
		the value must be a valid access level for an identifier (see ['id-access'] in this file).
	custom_access: to enable custom access level for an identifier, set this parameter
		to the parameter that should control it (normally 'id-access')
		
]]

local id_handlers = {
	['ARXIV'] = {
		parameters = {'arxiv', 'eprint'},
		link = 'arXiv',
		redirect = 'arXiv',
		q = 'Q118398',
		label = 'arXiv',
		prefix = 'https://arxiv.org/abs/',
		encode = false,
		COinS = 'info:arxiv',
		separator = ':',
		access = 'free',														-- free to read
		},
	['ASIN'] = {
		parameters = { 'asin', 'ASIN' },
		link = 'Mã số định danh chuẩn Amazon',
		redirect = 'Mã số định danh chuẩn Amazon',
		q = 'Q1753278',
		label = 'ASIN',
		prefix = 'https://www.amazon.',
		COinS = 'url',
		separator = '&nbsp;',
		encode = false;
		},
	['BIBCODE'] = {
		parameters = {'bibcode'},
		link = 'Bibcode',
		redirect = 'Bibcode',
		q = 'Q25754',
		label = 'Bibcode',
		prefix = 'https://ui.adsabs.harvard.edu/abs/',
		encode = false,
		COinS = 'info:bibcode',
		separator = ':',
		custom_access = 'bibcode-access',
		},
	['BIORXIV'] = {
		parameters = {'biorxiv'},
		link = 'bioRxiv',
		redirect = 'bioRxiv',
		q = 'Q19835482',
		label = 'bioRxiv',
		prefix = 'https://doi.org/',
		COinS = 'pre',															-- use prefix value
		access = 'free',														-- free to read
		encode = true,
		separator = '&nbsp;',
		},
	['CITESEERX'] = {
		parameters = {'citeseerx'},
		link = 'CiteSeerX',
		redirect = 'CiteSeerX',
		q = 'Q2715061',
		label = 'CiteSeerX',
		prefix = 'https://citeseerx.ist.psu.edu/viewdoc/summary?doi=',
		COinS =  'pre',															-- use prefix value
		access = 'free',														-- free to read
		encode = true,
		separator = '&nbsp;',
		},
	['DOI'] = {																	-- Used by InternetArchiveBot
		parameters = { 'doi', 'DOI'},
		link = 'DOI',
		redirect = 'doi',
		q = 'Q25670',
		label = 'doi',
		prefix = 'https://doi.org/',
		COinS = 'info:doi',
		separator = ':',
		encode = true,
		custom_access = 'doi-access',
		},
	['EISSN'] = {
		parameters = {'eissn', 'EISSN'},
		link = 'ISSN',
		redirect = 'eISSN',
		q = 'Q46339674',
		label = 'eISSN',
		prefix = 'https://search.worldcat.org/issn/',
		COinS = 'rft.eissn',
		encode = false,
		separator = '&nbsp;',
		},
	['HDL'] = {
		parameters = { 'hdl', 'HDL' },
		link = 'Handle System',
		redirect = 'hdl',
		q = 'Q3126718',
		label = 'hdl',
		prefix = 'https://hdl.handle.net/',
		COinS = 'info:hdl',
		separator = ':',
		encode = true,
		custom_access = 'hdl-access',
		},
	['ISBN'] = {																-- Used by InternetArchiveBot
		parameters = {'isbn', 'ISBN'},
		link = 'ISBN',
		redirect = 'ISBN',
		q = 'Q33057',
		label = 'ISBN',
		prefix = 'Đặc biệt:Nguồn sách/',
		COinS = 'rft.isbn',
		separator = '&nbsp;',
		},
	['ISMN'] = {
		parameters = {'ismn', 'ISMN'},
		link = 'International Standard Music Number',
		redirect = 'ISMN',
		q = 'Q1666938',
		label = 'ISMN',
		prefix = '',															-- not currently used;
		COinS = nil,															-- nil because we can't use pre or rft or info:
		separator = '&nbsp;',
		},
	['ISSN'] = {
		parameters = {'issn', 'ISSN'},
		link = 'International Standard Serial Number',
		redirect = 'ISSN',
		q = 'Q131276',
		label = 'ISSN',
		prefix = 'https://search.worldcat.org/issn/',
		COinS = 'rft.issn',
		encode = false,
		separator = '&nbsp;',
		},
	['JFM'] = {
		parameters = {'jfm', 'JFM'},
		link = 'Jahrbuch über die Fortschritte der Mathematik',
		redirect = 'JFM',
		q = '',
		label = 'JFM',
		prefix = 'https://zbmath.org/?format=complete&q=an:',
		COinS = 'pre',															-- use prefix value
		encode = true,
		separator = '&nbsp;',
		},
	['JSTOR'] = {
		parameters = {'jstor', 'JSTOR'},
		link = 'JSTOR',
		redirect = 'JSTOR',
		q = 'Q1420342',
		label = 'JSTOR',
		prefix = 'https://www.jstor.org/stable/',
		COinS = 'pre',															-- use prefix value
		encode = false,
		separator = '&nbsp;',
		custom_access = 'jstor-access',
		},
	['LCCN'] = {
		parameters = {'lccn', 'LCCN'},
		link = 'Library of Congress Control Number',
		redirect = 'LCCN',
		q = 'Q620946',
		label = 'LCCN',
		prefix = 'https://lccn.loc.gov/',
		COinS = 'info:lccn',
		encode = false,
		separator = '&nbsp;',
		},
	['MEDRXIV'] = {
		parameters = {'medrxiv'},
		link = 'medRxiv',
		redirect = 'medRxiv',
		q = 'Q58465838',
		label = 'medRxiv',
		prefix = 'https://www.medrxiv.org/content/',
		COinS = 'pre',															-- use prefix value
		access = 'free',														-- free to read
		encode = false,
		separator = '&nbsp;',
		},
	['MR'] = {
		parameters = {'mr', 'MR'},
		link = 'Mathematical Reviews',
		redirect = 'MR',
		q = 'Q211172',
		label = 'MR',
		prefix = 'https://mathscinet.ams.org/mathscinet-getitem?mr=',
		COinS = 'pre',															-- use prefix value
		encode = true,
		separator = '&nbsp;',
		},
	['OCLC'] = {
		parameters = {'oclc', 'OCLC'},
		link = 'OCLC',
		redirect = 'OCLC',
		q = 'Q190593',
		label = 'OCLC',
		prefix = 'https://search.worldcat.org/oclc/',
		COinS = 'info:oclcnum',
		encode = true,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.OCLC or 0,
		},
	['OL'] = {
		parameters = { 'ol', 'OL' },
		link = 'Open Library',
		redirect = 'OL',
		q = 'Q1201876',
		label = 'OL',
		prefix = 'https://openlibrary.org/',
		COinS = 'url',
		separator = '&nbsp;',
		encode = true,
		custom_access = 'ol-access',
		},
	['OSTI'] = {
		parameters = {'osti', 'OSTI'},
		link = 'Office of Scientific and Technical Information',
		redirect = 'OSTI',
		q = 'Q2015776',
		label = 'OSTI',
		prefix = 'https://www.osti.gov/biblio/',
		COinS = 'pre',															-- use prefix value
		encode = true,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.OSTI or 0,
		custom_access = 'osti-access',
		},
	['PMC'] = {
		parameters = {'pmc', 'PMC'},
		link = 'PubMed Central',
		redirect = 'PMC',
		q = 'Q229883',
		label = 'PMC',
		prefix = 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC',
		suffix = '',
		COinS = 'pre',															-- use prefix value
		encode = true,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.PMC or 0,
		access = 'free',														-- free to read
		},
	['PMID'] = {
		parameters = {'pmid', 'PMID'},
		link = 'PubMed Identifier',
		redirect = 'PMID',
		q = 'Q2082879',
		label = 'PMID',
		prefix = 'https://pubmed.ncbi.nlm.nih.gov/',
		COinS = 'info:pmid',
		encode = false,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.PMID or 0,
		},
	['RFC'] = {
		parameters = {'rfc', 'RFC'},
		link = 'Request for Comments',
		redirect = 'RFC',
		q = 'Q212971',
		label = 'RFC',
		prefix = 'https://tools.ietf.org/html/rfc',
		COinS = 'pre',															-- use prefix value
		encode = false,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.RFC or 0,
		access = 'free',														-- free to read
		},
	['SBN'] = {
		parameters = {'sbn', 'SBN'},
		link = 'Standard Book Number',											-- redirect to International_Standard_Book_Number#History
		redirect = 'SBN',
		label = 'SBN',
		prefix = 'Đặc biệt:Nguồn sách/0-',										-- prefix has leading zero necessary to make 9-digit sbn a 10-digit isbn
		COinS = nil,															-- nil because we can't use pre or rft or info:
		separator = '&nbsp;',
		},
	['SSRN'] = {
		parameters = {'ssrn', 'SSRN'},
		link = 'Social Science Research Network',
		redirect = 'SSRN',
		q = 'Q7550801',
		label = 'SSRN',
		prefix = 'https://papers.ssrn.com/sol3/papers.cfm?abstract_id=',
		COinS = 'pre',															-- use prefix value
		encode = true,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.SSRN or 0,
		custom_access = 'ssrn-access',
		},
	['S2CID'] = {
		parameters = {'s2cid', 'S2CID'},
		link = 'Semantic Scholar',
		redirect = 'S2CID',
		q = 'Q22908627',
		label = 'S2CID',
		prefix = 'https://api.semanticscholar.org/CorpusID:',
		COinS = 'pre',															-- use prefix value
		encode = false,
		separator = '&nbsp;',
		id_limit = id_limits_data_t.S2CID or 0,
		custom_access = 's2cid-access',
		},
	['USENETID'] = {
		parameters = {'message-id'},
		link = 'Usenet',
		redirect = 'Usenet',
		q = 'Q193162',
		label = 'Usenet:',
		prefix = 'news:',
		encode = false,
		COinS = 'pre',															-- use prefix value
		separator = '&nbsp;',
		},
	['ZBL'] = {
		parameters = {'zbl', 'ZBL' },
		link = 'Zentralblatt MATH',
		redirect = 'Zbl',
		q = 'Q190269',
		label = 'Zbl',
		prefix = 'https://zbmath.org/?format=complete&q=an:',
		COinS = 'pre',															-- use prefix value
		encode = true,
		separator = '&nbsp;',
		},
	}


--[[--------------------------< E X P O R T S >---------------------------------
]]

return 	{
	use_identifier_redirects = use_identifier_redirects,						-- booleans defined in the settings at the top of this module
	local_lang_cat_enable = local_lang_cat_enable,
	date_name_auto_xlate_enable = date_name_auto_xlate_enable,
	date_digit_auto_xlate_enable = date_digit_auto_xlate_enable,
	enable_sort_keys = enable_sort_keys,
	
																				-- tables and variables created when this module is loaded
	global_df = get_date_format (),												-- this line can be replaced with "global_df = 'dmy-all'," to have all dates auto translated to dmy format.
	global_cs1_config_t = global_cs1_config_t,									-- global settings from {{cs1 config}}
	punct_skip = build_skip_table (punct_skip, punct_meta_params),
	url_skip = build_skip_table (url_skip, url_meta_params),
	known_free_doi_registrants_t = build_free_doi_registrants_table(),
	id_limits_data_load_fail = id_limits_data_load_fail,						-- true when commons tabular identifier-limit data fails to load

	name_space_sort_keys = name_space_sort_keys,
	aliases = aliases,
	special_case_translation = special_case_translation,
	date_names = date_names,
	err_msg_supl = err_msg_supl,
	error_conditions = error_conditions,
	editor_markup_patterns = editor_markup_patterns,
	et_al_patterns = et_al_patterns,
	extended_registrants_t = extended_registrants_t,
	id_handlers = id_handlers,
	keywords_lists = keywords_lists,
	keywords_xlate = keywords_xlate,
	stripmarkers = stripmarkers,
	invisible_chars = invisible_chars,
	invisible_defs = invisible_defs,
	indic_script = indic_script,
	emoji_t = emoji_t,
	maint_cats = maint_cats,
	messages = messages,
	presentation = presentation,
	prop_cats = prop_cats,
	script_lang_codes = script_lang_codes,
	lang_tag_remap = lang_tag_remap,
	lang_name_remap = lang_name_remap,
	this_wiki_code = this_wiki_code,
	title_types = title_types,
	uncategorized_namespaces = uncategorized_namespaces_t,
	uncategorized_subpages = uncategorized_subpages,
	templates_using_volume = templates_using_volume,
	templates_using_issue = templates_using_issue,
	templates_not_using_page = templates_not_using_page,
	vol_iss_pg_patterns = vol_iss_pg_patterns,
	single_letter_2nd_lvl_domains_t = single_letter_2nd_lvl_domains_t,
	
	inter_wiki_map = inter_wiki_map,
	mw_languages_by_tag_t = mw_languages_by_tag_t,
	mw_languages_by_name_t = mw_languages_by_name_t,
	citation_class_map_t = citation_class_map_t,

	citation_issue_t = citation_issue_t,
	citation_no_volume_t = citation_no_volume_t,
	}
