local p = require('Module:UnitTests')

function p:test_Usage_Examples()
	self:preprocess_equals_preprocess_many('{{#invoke:webarchive/sandbox|webarchive', '}}', '{{#invoke:webarchive|webarchive', '}}', {
		{'|url=https://web.archive.org/web/20160801000000/http://example.com |date=August 1, 2016'},
		{'|url=http://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |date=12 February 2009'},
		{'|url=http://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |date=12 February 2009 |title=Page title'}
	} )
end


function p:test_Template_Examples()
	self:preprocess_equals_preprocess_many('{{#invoke:webarchive/sandbox|webarchive', '}}', '{{#invoke:webarchive|webarchive', '}}', {
		{'|url=https://web.archive.org/web/20160801000000/http://example.com |date=August 1, 2016 |title=Page title'},
		{'|url=https://web.archive.org/web/20160801000000/http://example.com |date=August 1, 2016'},
		{'|url=http://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/'},
		{'|url=https://web.archive.org/web/20160801/http://example.com |title=Page title |date=August 1, 2016 |url2=https://web.archive.org/web/20160901/http://example.com |title2=Page2 title |date2=September 1, 2016'},
		{'|url=https://web.archive.org/web/20160801/http://example.com |date=August 1, 2016 |url2=https://web.archive.org/web/20160901/http://example.com |date2=September 1, 2016'},
		{'|url=https://web.archive.org/web/20160801/http://example.com |title=Page title |url2=https://web.archive.org/web/20160901/http://example.com |title2=Page2 title'},
		})
end

function p:test_Permacc()
	self:preprocess_equals_preprocess_many('{{#invoke:webarchive/sandbox|webarchive', '}}', '{{#invoke:webarchive|webarchive', '}}', {
		{'|url=http://perma.cc/F9NT-22AK |date=2015-04-09'},
		{'|url=http://perma.cc/F9NT-22AK |date=2015-04-09 |title=Mike Pressler Biography'},
	} )
end


function p:test_z1_notdate_archiveis()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/e9AAZ}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/e9AAZ}}'
		)
end


function p:test_z2_missingdate_archiveis1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/}}'
		)
end

function p:test_z2_missingdate_archiveis2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/20160808112330/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/20160808112330/http://example.com/}}'
		)
end

function p:test_z2_missingdate_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/}}'
		)
end

function p:test_z2_missingdate_wayback()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/}}'
		)
end

function p:test_z2_missingdate_wayback_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com}}'
		)
end

function p:test_z2_missingdate_webarchiveloc()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/}}'
		)
end

function p:test_z2_missingdate_webcite()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/}}'
		)
end

function p:test_z2_missingdate_archiveit1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/}}'
		)
end

function p:test_z2_missingdate_archiveit2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/}}'
		)
end

function p:test_z2_missingdate_archiveit3()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/}}'
		)
end


function p:test_z3_wrongdate_archiveis1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/ |date=2017-08-21}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/ |date=2017-08-21}}'
		)
end


function p:test_z3_wrongdate_archiveis2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/20160808112330/http://example.com/ |date=2017-08-21}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/20160808112330/http://example.com/ |date=2017-08-21}}'
		)
end

function p:test_z3_wrongdate_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/ |date=2017-08-21}}',
		'{{#invoke:Webarchive         |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/ |date=2017-08-21}}'
		)
end

function p:test_z3_wrongdate_wayback()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |date=2017-08-21}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |date=2017-08-21}}'
		)
end

function p:test_z3_wrongdate_wayback_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com |date=2016-08-01}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com |date=2016-08-01}}'
		)
end

function p:test_z3_wrongdate_webarchiveloc()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/ |date=2017-08-21}}',
		'{{#invoke:Webarchive         |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/ |date=2017-08-21}}'
		)
end

function p:test_z3_wrongdate_webcite()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |date=2017-08-21}}',
		'{{#invoke:Webarchive         |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |date=2017-08-21}}'
		)
end

function p:test_z3_wrongdate_archiveit1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/ |date=2019-06-22}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/ |date=2019-06-22}}'
		)
end

function p:test_z3_wrongdate_archiveit2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/ |date=2019-10-17}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/ |date=2019-10-17}}'
		)
end

function p:test_z3_wrongdate_archiveit3()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/ |date=2015-12-02}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/ |date=2015-12-02}}'
		)
end


function p:test_z4_index_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/*/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/*/http://example.com/}}'
		)
end

function p:test_z4_index_wayback()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/*/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/*/http://example.com/}}'
		)
end

function p:test_z4_index_webarchiveloc()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=http://webarchive.loc.gov/all/*/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=http://webarchive.loc.gov/all/*/http://example.com/}}'
		)
end

function p:test_z4_index_archiveit1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/all/*/http://example.com/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/all/*/http://example.com/}}'
		)
end

function p:test_z4_index_archiveit2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/org-467/*/http://quartos.org/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/org-467/*/http://quartos.org/}}'
		)
end

function p:test_z4_index_archiveit3()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/3348/*/https://www.heritagepreservation.org/}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/3348/*/https://www.heritagepreservation.org/}}'
		)
end


function p:test_z5_mdy_archiveis1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_archiveis2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/20160808112330/http://example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/20160808112330/http://example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_wayback()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_wayback_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_webarchiveloc()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_webcite()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_archiveit1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_archiveit2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/ |title=Example |date=mdy}}'
		)
end

function p:test_z5_mdy_archiveit3()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/ |title=Example |date=mdy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/ |title=Example |date=mdy}}'
		)
end


function p:test_z6_dmy_archiveis1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/2016.08.08-112330/http://example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_archiveis2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://archive.is/20160808112330/http://example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://archive.is/20160808112330/http://example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_wayback()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_wayback_ukgwa()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20191201000000/http://webarchive.nationalarchives.gov.uk/ukgwa/20160801000000/http://example.com |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_webarchiveloc()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=http://webarchive.loc.gov/all/20160801000000/http://example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_webcite()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://www.webcitation.org/5eWaHRbn4?url=http://www.example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_archiveit1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/all/20190621232545/http://example.com/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_archiveit2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/org-467/20191016094633/http://quartos.org/ |title=Example |date=dmy}}'
		)
end

function p:test_z6_dmy_archiveit3()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/ |title=Example |date=dmy}}',
		'{{#invoke:Webarchive         |webarchive |url=https://wayback.archive-it.org/3348/20151201214156/https://www.heritagepreservation.org/ |title=Example |date=dmy}}'
		)
end


function p:test_addlarchives_1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlarchives|url=https://archive.is/zKyrW |date1=11 May 2018 |url2=https://www.webcitation.org/query?url=http%3A%2F%2Fwww.albanianphotography.net%2Fen%2Fnopcsa.html&date=2011-02-25 |date2=25 February 2011}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlarchives|url=https://archive.is/zKyrW |date1=11 May 2018 |url2=https://www.webcitation.org/query?url=http%3A%2F%2Fwww.albanianphotography.net%2Fen%2Fnopcsa.html&date=2011-02-25 |date2=25 February 2011}}'
		)
end

function p:test_addlarchives_2()	-- has malformed |date2=
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlarchives|url2=https://web.archive.org/web/20140903195544/http://www.famitsu.com/biz/ranking/ |date2=20140903 |url=https://archive.is/20140903195702/http://www.famitsu.com/biz/ranking/|date=2014-09-03}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlarchives|url2=https://web.archive.org/web/20140903195544/http://www.famitsu.com/biz/ranking/ |date2=20140903 |url=https://archive.is/20140903195702/http://www.famitsu.com/biz/ranking/|date=2014-09-03}}'
		)
end

function p:test_addlarchives_3()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlarchives|url=https://archive.fo/20120720003512/http://libro.uca.edu/payne2/payne25.htm|date=July 20, 2012 |title=Chapter 25}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlarchives|url=https://archive.fo/20120720003512/http://libro.uca.edu/payne2/payne25.htm|date=July 20, 2012 |title=Chapter 25}}'
		)
end


function p:test_addlpages_1() -- without title
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlpages|url=https://www.webcitation.org/5jhGJ8vA8?url=http%3A%2F%2Farchive.gamespy.com%2Freviews%2Fjune02%2Fneverwinter%2Findex2.shtml|date=September 11, 2009|url2=https://www.webcitation.org/5jhGJWAXG?url=http://archive.gamespy.com/reviews/june02/neverwinter/index3.shtml|date2=2009-09-11}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlpages|url=https://www.webcitation.org/5jhGJ8vA8?url=http%3A%2F%2Farchive.gamespy.com%2Freviews%2Fjune02%2Fneverwinter%2Findex2.shtml|date=September 11, 2009|url2=https://www.webcitation.org/5jhGJWAXG?url=http://archive.gamespy.com/reviews/june02/neverwinter/index3.shtml|date2=2009-09-11}}'
		)
end

function p:test_addlpages_2() -- uses title
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlpages|url=https://www.webcitation.org/5jhGJ8vA8?url=http%3A%2F%2Farchive.gamespy.com%2Freviews%2Fjune02%2Fneverwinter%2Findex2.shtml|date=September 11, 2009||title=Page 2|url2=https://www.webcitation.org/5jhGJWAXG?url=http://archive.gamespy.com/reviews/june02/neverwinter/index3.shtml|date2=2009-09-11|title2=Page 3}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlpages|url=https://www.webcitation.org/5jhGJ8vA8?url=http%3A%2F%2Farchive.gamespy.com%2Freviews%2Fjune02%2Fneverwinter%2Findex2.shtml|date=September 11, 2009||title=Page 2|url2=https://www.webcitation.org/5jhGJWAXG?url=http://archive.gamespy.com/reviews/june02/neverwinter/index3.shtml|date2=2009-09-11|title2=Page 3}}'
		)
end

function p:test_addlpages_3()	-- uses title (Title 1) and not title (page 2)
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlpages|url=https://www.webcitation.org/5jhGJ8vA8?url=http%3A%2F%2Farchive.gamespy.com%2Freviews%2Fjune02%2Fneverwinter%2Findex2.shtml|date=September 11, 2009||title=Title 1|url2=https://www.webcitation.org/5jhGJWAXG?url=http://archive.gamespy.com/reviews/june02/neverwinter/index3.shtml|date2=2009-09-11}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlpages|url=https://www.webcitation.org/5jhGJ8vA8?url=http%3A%2F%2Farchive.gamespy.com%2Freviews%2Fjune02%2Fneverwinter%2Findex2.shtml|date=September 11, 2009||title=Title 1|url2=https://www.webcitation.org/5jhGJWAXG?url=http://archive.gamespy.com/reviews/june02/neverwinter/index3.shtml|date2=2009-09-11}}'
		)
end

function p:test_addlpages_4()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |date=September 24, 2009|url=https://www.webcitation.org/5k2BxXFOx?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p2.html|title=Page 2|url2=https://www.webcitation.org/5k2ByyK40?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p3.html|date2=2009-09-24|title2=Page 3|url3=https://www.webcitation.org/5k2C0MCbs?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p4.html|date3=2009-09-24|title3=Page 4|url4=https://www.webcitation.org/5k2C1rcsV?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p5.html|date4=2009-09-24|title4=Page 5}}',
		'{{#invoke:Webarchive		  |webarchive |date=September 24, 2009|url=https://www.webcitation.org/5k2BxXFOx?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p2.html|title=Page 2|url2=https://www.webcitation.org/5k2ByyK40?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p3.html|date2=2009-09-24|title2=Page 3|url3=https://www.webcitation.org/5k2C0MCbs?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p4.html|date3=2009-09-24|title3=Page 4|url4=https://www.webcitation.org/5k2C1rcsV?url=http://pc.gamespy.com/pc/neverwinter-nights-2-adventure-pack-mysteries-of-westgate/873407p5.html|date4=2009-09-24|title4=Page 5}}'
		)
end

function p:test_addlpages_5()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |format=addlpages|url1=https://web.archive.org/web/20040722032824/http://www.nationalgeographic.com/adventure/0404/adventure_books_1-19.html |date1=22 July 2004|url2=https://web.archive.org/web/20040831001431/http://www.nationalgeographic.com/adventure/0404/adventure_books_20-39.html|date2=2004-08-31|url3=https://web.archive.org/web/20040831001359/http://www.nationalgeographic.com/adventure/0404/adventure_books_40-59.html|date3=2004-08-31|url4=https://web.archive.org/web/20040830100950/http://www.nationalgeographic.com/adventure/0404/adventure_books_60-79.html|date4=2004-08-31|url5=https://web.archive.org/web/20040831001341/http://www.nationalgeographic.com/adventure/0404/adventure_books_80-100.html|date5=2004-08-31}}',
		'{{#invoke:Webarchive		  |webarchive |format=addlpages|url1=https://web.archive.org/web/20040722032824/http://www.nationalgeographic.com/adventure/0404/adventure_books_1-19.html |date1=22 July 2004|url2=https://web.archive.org/web/20040831001431/http://www.nationalgeographic.com/adventure/0404/adventure_books_20-39.html|date2=2004-08-31|url3=https://web.archive.org/web/20040831001359/http://www.nationalgeographic.com/adventure/0404/adventure_books_40-59.html|date3=2004-08-31|url4=https://web.archive.org/web/20040830100950/http://www.nationalgeographic.com/adventure/0404/adventure_books_60-79.html|date4=2004-08-31|url5=https://web.archive.org/web/20040831001341/http://www.nationalgeographic.com/adventure/0404/adventure_books_80-100.html|date5=2004-08-31}}'
		)
end

function p:test_sequencegap()
	self:preprocess_equals_preprocess(
		'{{#invoke:Webarchive/sandbox |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |title=Example |date=2016-08-01 |url3=https://web.archive.org/web/20160802000000/http://example.com/ |title3=Example |date3=2016-08-02}}',
		'{{#invoke:Webarchive         |webarchive |url=https://web.archive.org/web/20160801000000/http://example.com/ |title=Example |date=2016-08-01 |url3=https://web.archive.org/web/20160802000000/http://example.com/ |title3=Example |date3=2016-08-01}}'
		)
end


return p