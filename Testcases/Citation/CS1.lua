-- Unit tests for [[Module:Citation/CS1]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_encyclopedia()
    self:preprocess_equals_preprocess_many('{{cite encyclopedia/new|', '}}', '{{cite encyclopedia|', '}}', {
       { 
[==[
last= LAST
|first= FIRST
|author-link= author-link
|editor-first= EDITOR-FIRST
|editor-last= EDITOR-LAST
|editor-link= EDITOR-LINK
|encyclopedia= ENCYCLOPEDIA
|title= TITLE
|trans-title= TRANS-TITLE
|url=https://en.wikipedia.org/Main_Page
|access-date= access-date
|language= LANGUAGE
|edition= EDITION
|date= DATE
|year= YEAR
|publisher= PUBLISHER 
|volume= VOLUME
|location= LOCATION
|id= ID
|isbn= ISBN
|oclc= OCLC
|doi= 10.DOI
|pages= PAGES
|quote= QUOTE
|ref= REF
]==]
},{
[==[
  last =Golden
  |first = Peter B.
  |author-link =Peter Benjamin Golden
  |editor1-last = Golden
  |editor1-first = Peter B.
  |editor1-link = Peter Benjamin Golden
  |editor2-last =  Ben-Shammai,
  |editor2-first = Haggai
  |editor3-last = Róna-Tas
  |editor3-first = András
  |editor3-link = András Róna-Tas
  |encyclopedia =  The World of the Khazars: New Perspectives
  |title = Khazar Studies: Achievements and Perspectives
  |series = Handbook of Oriental Studies
  |volume = 17
  |publisher = BRILL
  |year = 2007a
  |pages = 7–57
  |isbn = 978-9-004-16042-2
  |url = http://books.google.com/books?id=3ZzXjdyK-CEC&pg=PR2#v=onepage&p=123
  |access-date = February 13, 2013
]==]
}, {
[==[
title=Idaho – MSN Encarta <!-- BOT GENERATED TITLE -->|url=http://encarta.msn.com/encyclopedia_761565515/Idaho.html | archive-url=https://www.webcitation.org/5kwpoRl6A?url=http://encarta.msn.com/encyclopedia_761565515/Idaho.html | archive-date=2009-11-01|url-status=dead
]==] 
}, {
[==[
 url= http://encarta.msn.com/encyclopedia_761594679/martina_hingis.html | title=Martina Hingis | publisher=[[Encarta]] | access-date=31 October 2008 | archive-url=https://www.webcitation.org/5kx7RAO3G?url=http://encarta.msn.com/encyclopedia_761594679/martina_hingis.html | archive-date=1 November 2009|url-status=dead
]==] 
}, {
[==[
archive-url=https://www.webcitation.org/5kwbxqnne?url=http://encarta.msn.com/encyclopedia_761570768/Europe.html | url-status=dead | archive-date=31 October 2009 | title=Europe | last=Microsoft Encarta Online Encyclopaedia 2007 | url=http://encarta.msn.com/encyclopaedia_761570768/Europe.html | access-date=27 December 2007
]==]
}, {
[==[
last=Seberg |first=Ole |year=2007 |editor-last=Heywood |editor-first=Vernon H. |editor2-last=Brummitt |editor2-first=Richard K. |editor3-last=Culham |editor3-first=Alastair |contribution=Alliaceae |title=Flowering Plant Families of the World |pages=340–341 |publication-place=Richmond Hill, Ontario |publisher=Firefly Books |isbn=978-1-55407-206-4 |name-list-style=amp
]==]
}, {
[==[
chapter=Lewinsky scandal |title=The Columbia Encyclopedia, Sixth Edition |publisher=Columbia University Press |year=2008 |url=http://www.encyclopedia.com/topic/Lewinsky_scandal.aspx |access-date=February 9, 2010
]==]
}, {
[==[
last = Gerish | first = Deborah | title = Aimery of Lusignan | editor = Alan V. Murray | encyclopedia = The Crusades: An Encyclopedia | volume = 1 | pages = 24 | publisher = [[ABC-CLIO]] | location = [[Santa Barbara, California|Santa Barbara]] | year = 2006 | url = http://books.google.com/books?id=6cSXSgAACAAJ | oclc = 70122512
]==]
}, {
[==[
author=Skousen, Royal | author-link=Royal Skousen | title=Book of Mormon Editions (1830-1981) | encyclopedia=[[Encyclopedia of Mormonism]] | year=1992 | volume=1 | pages=175–6 | publisher=[[Macmillan Publishers (United States)|Macmillan]] | url=http://eom.byu.edu/index.php/Book_of_Mormon_Editions_(1830-1981) | access-date=2009-02-12
]==]
}, {
[==[
   last = Morère
  | first = J. E.
  | title = Aguilon, François d'
  | encyclopedia = [[Dictionary of Scientific Biography]]
  | volume = 1
  | pages = 81 
  | publisher = Charles Scribner's Sons
  | location = New York
  | year = 1970
  | isbn = 0-684-10114-9
]==]
}, {
[==[
   title = Clipper
  | encyclopedia = New International Encyclopaedia
  | volume = 5
  | pages = 39
  | publisher = Dodd Mead and Company
  | year = 1909
  | quote = Clipper ... probably connected with Dutch ''klepper'', fast horse
  | url =  http://books.google.com/?id=qycVAAAAYAAJ&dq=%22clipper%20ship%22&pg=PA39#v=onepage
  | access-date =6 Mar. 2010
]==]
}, {
[==[
last= Smith |first= Peter |encyclopedia= A concise encyclopedia of the Bahá'í Faith |title= satan |year= 2000 |publisher=Oneworld Publications |location= Oxford |isbn= 1-85168-184-1 |pages= 304
]==]
}, {
[==[
chapter=Ethanol|title=[[#Encyc Chem|Encyclopedia of chemical technology]]|year=1991|page=813|volume=9
]==]
}, {
[==[
 first = William A.
| last = Wallace
| title = Albertus Magnus, Saint
| url = http://www.u.arizona.edu/~aversa/scholastic/Dictionary of%20Scientific%20Biography/Albertus%20Magnus%20(Wallace).pdf
| publisher = Scribner & American Council of Learned Societies
| isbn = 978-0-684-10114-9
| editor-last = Gillispie
| editor-first = Charles
| encyclopedia = [[Dictionary of Scientific Biography]]
| volume=1
| pages=99-103
| location = New York
| year = 1970
]==]
}, {
[==[
last=Kukathas |first=Chandran |author-link=Chandran Kukathas |year=1998 |title=Rand, Ayn (1905–82) |editor-last=Craig |editor-first=Edward (ed) |encyclopedia=[[Routledge Encyclopedia of Philosophy]] |location=New York |publisher=Routledge |volume=8 |pages=55–56 |isbn=0-415-07310-3 |oclc=318280731
]==]
}, {
[==[
last=Morse |first=Stephen J. |encyclopedia=Law Library - American Law and Legal Information |title=Psychopathy - What Is Psychopathy? |url=http://law.jrank.org/pages/1884/Psychopathy-What-psychopathy.html |access-date=2008-09-25 |volume=Crime and Justice Vol 3|archive-url=https://www.webcitation.org/5b5vnGYP0?url=http://law.jrank.org/pages/1884/Psychopathy-What-psychopathy.html |archive-date=2008-09-25 
]==]
}, {
[==[
last= Smith|first= Peter |encyclopedia= A concise encyclopedia of the Bahá'í Faith|title= burial, "death and afterlife", evil, evil spirits, sin |year= 2000|publisher=Oneworld Publications|location= Oxford |isbn= 1-85168-184-1|pages= 96–97, 118–119, 135–136, 322–323
]==]
}, {
[==[
last=Hodges |first=Andrew |editor=Edward N. Zalta |encyclopedia=[[Stanford Encyclopedia of Philosophy]] |title=Alan Turing |url=http://plato.stanford.edu/entries/turing/ |access-date=10 January 2011 |edition=Winter 2009 |date=27 August 2007 |publisher=[[Stanford University]]
]==]
}, {
[==[
editor=[[Pete Palmer]] and Gary Gillette|encyclopedia=The 2005 ESPN Baseball Encyclopedia|title=Introduction|edition=1st Edition|year=2005|publisher=Sterling|location=New York|isbn=1-4027-2568-X
]==]
}, {
[==[
 first = Ernan
| last = McMullin
| title = Robert Bellarmine
| url = http://www.encyclopedia.com/topic/Robert_Bellarmine.aspx#1
| publisher = Scribner & American Council of Learned Societies
| editor-last = Gillispie
| editor-first = Charles
| encyclopedia = [[Dictionary of Scientific Biography]]
| year = 2008
]==]
}, {
[==[
last= |first= | author-link= | title=Islam |year=2007| encyclopedia=Encyclopædia Britannica Online | access-date=2007-11-27|location=|publisher=|url=http://www.britannica.com/eb/article-69190/Islam
]==]
}, {
[==[
author=Bliss, Michael |year=2002 |title=Macleod, John James Rickard |url=http://www.thecanadianencyclopedia.com/articles/john-james-rickard-macleod |encyclopedia=Canadian Encyclopedia
]==]
}, {
[==[
title=Penderecki, Krzysztof|last=Thomas|first=Adrian|editor-last=Sadie|editor-first=Stanley|location=London, England|year=1992|encyclopedia=[[New Grove Dictionary of Opera]]|ISBN=0-333-73432-7
]==]
}, {
[==[
encyclopedia=[[Encyclopedia of Arkansas History & Culture]]|title=Louisiana Purchase|first=Lea Flowers|last=Baker|access-date=2010-09-18|url=http://encyclopediaofarkansas.net/encyclopedia/entry-detail.aspx?entryID=2383
]==]
}, {
[==[
title=Cervantes, Miguel de|encyclopedia=The Encyclopedia Americana|year=1994
]==]
}, {
[==[
editor=Robert M. Besançon | encyclopedia=The Encyclopedia of Physics | edition=3rd | year=1990 | publisher=Van Nostrand Reinhold, New York | isbn = 0-442-00522-9 | pages = 1278–1284 | article=Vacuum Techniques
]==]
}, {
[==[
last = McFarlane | first = Ian | author-link = Ian McFarlane | encyclopedia = [[Encyclopedia of Australian Rock and Pop]] | title = Whammo Homepage | url = http://web.archive.org/web/20040405231007/http://www.whammo.com.au/index.asp | access-date =4 December 2010 | year = 1999 | publisher=[[Allen & Unwin]] | location = [[St Leonards, New South Wales|St Leonards, NSW]] | isbn = 1-86508-072-1 
]==]
}, {
[==[
   last = Campbell
  | first = J.
  | author-link = 
  | title = Rædwald
  | url = http://www.oxforddnb.com/view/article/23265?docPos=1
  | encyclopedia = [[Dictionary of National Biography]]
  | year = 2004
  | editor-last =
  | editor-first = 
  | editor-link = 
  | volume = 
  | location = 
  | doi = 10.1093/ref:odnb/23265 
  | publisher = Oxford University Press
]==]
}, {
[==[
title=Avicenna | encyclopedia=Encyclopaedia of Islam Online 
]==]
}, {
[==[
title=Islam|encyclopedia=Encyclopaedia of Islam Online|author=L. Gardet|author2=J. Jomier
]==]
}, {
[==[
first=Ted |last=Honderich |author-link=Ted Honderich |year=2005 |title=theodicy |encyclopedia=The Oxford Companion to Philosophy |isbn=0-19-926479-1 |quote=[[John Hick]], for example, proposes a theodicy, while [[Alvin Plantinga]] formulates a defence. The idea of human free will often appears in a both of these strategies, but in different ways.
]==]
}, {
[==[
title=AskOxford Search Results&nbsp;– terrorist |encyclopedia=AskOxford |publisher=AskOxford |access-date=2008-07-11 | no-tracking=true
]==]
}, {
[==[
title = Virus.VBS.Redlof.a | encyclopedia = Virus Encyclopedia | publisher = Viruslist.com | date = January 15, 2004 | url = http://www.viruslist.com/viruses/encyclopedia?virusid=25409 | access-date =August 26, 2007
]==]
}, {
[==[
title=Matthew, Tobie (1544?–1628)
|last=Sheils
|first=William Joseph
|encyclopedia=Oxford Dictionary of National Biography
|publisher=Oxford University Press
|year=2004
]==]
}, {
[==[
editor = Thomas Hockey et al. | last = Dalen | first = Benno van | title=Ulugh Beg: Muḥammad Ṭaraghāy ibn Shāhrukh ibn Tīmūr | encyclopedia = The Biographical Encyclopedia of Astronomers | publisher=Springer | year = 2007 | location = New York | pages = 1157–9 | url=http://islamsci.mcgill.ca/RASI/BEA/Ulugh_Beg_BEA.htm | isbn=978-0-387-31022-0
]==]
}, {
[==[
author=Lawson, M. K. |encyclopedia= The Medieval State: Essays Presented to James Campbell |title=Observations Upon a Scene in the Bayeux Tapestry |publisher=Hambledon Press |location=London |pages=73–92 |year=2000
]==]
}, {
[==[
last=Waugh|first=Scott L.|title=Thomas, 1st Earl of Norfolk (1300–1338)|encyclopedia=Oxford Dictionary of National Biography|publisher=Oxford University Press|location=Oxford|year=2004|doi=10.1093/ref:odnb/27196
]==]
}, {
[==[
author=Yorke, Philip Chesney|encyclopedia=Encyclopædia Britannica|title=Anne (1665–1714)|publisher=University Press|location=Cambridge|edition=11th|year=1911
]==]
}, {
[==[
editor-last = Lewis| editor-first = M. Paul| encyclopedia = Ethnologue: Languages of the World| edition = 16 | publisher = SIL International | location = Dallas, Texas| year = 2009| url = http://www.ethnologue.com/show_language.asp?code=deu
]==]
}
    }, {nowiki=false, templatestyles=true})
end

function p:test_news()
    self:preprocess_equals_preprocess_many('{{cite news/new|', '}}', '{{cite news|', '}}', {
       {
[==[ 
  title       = TITLE
 | author      = AUTHOR
 | first       = FIRST
 | last        = LAST
 | author-link  = author-link
 | author-link2 = author-link2
 | author2     = AUTHOR2 
 | author3     = AUTHOR3
 | author4     = AUTHOR4
 | author5     = AUTHOR5
 | author6     = AUTHOR6
 | author7     = AUTHOR7
 | url         = https://en.wikipedia.org/Main_Page
 | format      = FORMAT
 | agency      = AGENCY
 | newspaper   = NEWSPAPER
 | publisher   = PUBLISHER
 | location    = LOCATION
 | isbn        = ISBN
 | issn        = ISSN
 | oclc        = OCLC
 | pmid        = PMID
 | pmc         = PMC
 | bibcode     = BIBCODE
 | doi         = 10.DOI
 | id          = ID
 | date        = DATE
 | page        = PAGE
 | pages       = PAGES
 | at          = AT
 | access-date  = access-date
 | language    = LANGUAGE
 | trans-title = TRANS-TITLE
 | quote       = QUOTE
 | archive-url  = https://web.archive.org/web/20190310131346/https://en.wikipedia.org/wiki/Main_Page
 | archive-date = archive-date
 | url-status  = URLSTATUS
 | ref         = REF
 | no-tracking=true
]==] }, {

[==[ postscript= | title=Auction Record for an Original 'Alice' | url=http://www.nytimes.com/1998/12/11/nyregion/auction-record-for-an-original-alice.html | date=11 December 1998 | periodical=The New York Times | page=B30
]==] }, {

[==[ last=Rabil | title=New York Times Starts Selling Ad Space on Front Page | url=http://www.bloomberg.com/apps/news?pid=20601103&sid=amsJuEA115pI&refer=us | date=January 5, 2009 | first=Sarah | work=Bloomberg L.P. 
]==] }, {

[==[
title=Drugs: Chips trader gets 15 years, 10 strokes
|url=http://www.dailyexpress.com.my/news.cfm?NewsID=48660
|work=Daily Express |location=Kota Kinabalu, Malaysia
|date=29 March 2007 |agency=Bernama
]==] }, {

[==[title=Ученый: тунгусская катастрофа связана с водородным взрывом ядра кометы (Scientist: The Tunguska Catastrophe connected to the hydrogen explosion of a comet nucleus)|url=http://ria.ru/science/20090330/166427555.html|access-date=14 October 2010|newspaper=[[RIA Novosti]]|date=30 March 2009|language=Russian
]==] }, {

[==[  publisher=Apple Inc. | title=Statement by Apple's Board of Directors | url=http://www.apple.com/pr/library/2011/10/05Statement-by-Apples-Board-of-Directors.html | access-date=October 6, 2011 
]==] }, {

[==[  last=Stella | date=14 March 2013 | first=Gian Antonio | title=Tango e battesimo, fidanzata e vangelo l'alfabeto misto di Papa Francesco | newspaper=Corriere della Sera | quote=Mio padre era di Portacomaro (Asti, ndr) e mia madre di Buenos Aires, con sangue piemontese e genovese | url=http://www.corriere.it/esteri/speciali/2013/conclave/notizie/14-mar-papa-tango-fidanzata_1069e952-8c70-11e2-ab2c-711cc67f5f67.shtml | language=Italian | access-date=14 March 2013 
]==] }, {

[==[  archive-url=http://web.archive.org/web/20051001062114/http://www.cnn.com/2005/WORLD/europe/09/23/ | date=23 September 2005 | publisher=CNN | title=Cardinal breaks conclave vow of secrecy | archive-date=1 October 2005 | agency=Associated Press | url=http://www.cnn.com/2005/WORLD/europe/09/23/conclave.diary.ap/index.html | access-date=13 March 2013
]==] }, {

[==[  date=17 March 2013 | author=Miroff, Nick | page=27 | title=Pope's activity in Dirty War Draws Scrutiny | location=Sec. 1 | agency=Washington Post | work=Chicago Tribune | access-date=17 March 2013|
no-tracking=true ]==] }, {

[==[   date=916 | title=Mahdia founded |last=El Fatimi]==] }, {

[==[  author=[[Benedict Anderson]]|title=In the World-Shadow of Bismarck and Nobel|publisher=[[New Left Review]]|date=July–August 2004|url=http://newleftreview.org/II/28/benedict-anderson-in-the-world-shadow-of-bismarck-and-nobel]==] }, {

[==[  url=http://findarticles.com/p/articles/mi_qa3884/is_200603/ai_n17181949/pg_1?tag=artBody;col1|title=City infrastructures and city dwellers: Accommodating the automobile in twentieth-century Paris|access-date=3 August 2008|author=Mathieu Flonneau|publisher=The Journal of Transport History | year=2006]==] }, {

[==[  url=http://news.bbc.co.uk/1/hi/in_depth/4417096.stm|title=Special Report: Riots in France|date=9 November 2005|access-date=17 November 2007|publisher=BBC News ]==] }, {

[==[  url=http://hn.wenweipo.com/news/zhuanti/2012-11-16/23713.html | title=本报独家探访河南邓州习营村 | date=2012-11-16 | publisher=[[Wen Wei Po]] |access-date=2012-11-156]==] }, {

[==[  url=http://www.nytimes.com/2012/11/16/world/asia/new-chinese-leader-offers-few-hints-of-a-shift-in-direction.html|title=New Chinese Leader Offers Few Hints of a Shift in Direction|first=Ian|last=Johnson|date=2012-11-15|work=The New York Times|access-date=2012-11-15]==] }, {

[==[  first=Jonathan | last=Watts | url=http://www.guardian.co.uk/world/2007/oct/26/china.uknews4 |title=Most corrupt officials are from poor families but Chinese royals have a spirit that is not dominated by money | access-date=11 June 2008 |work=The Guardian |location=London  |date= 26 October 2007]==] }, {

[==[  last=Bazar|first=Emily|title=Immigrants Make Pilgrimage to Pope | work=USA Today | date=16 April 2008 | url=http://www.usatoday.com/news/religion/2008-04-15-popeimmigrants_N.htm | access-date=3 May 2008]==] }, {

[==[  author=David Willey |url=http://www.bbc.co.uk/news/world-europe-10645748 |title=Vatican 'speeds up' abuse cases |work=BBC News |date=15 July 2010 |access-date=28 October 2010]==] }, {

[==[  title=The economy of heat |publisher=The Economist |date=2007-04-12 |url=http://www.economist.com/node/8952496?story_id=8952496 |access-date=2008-06-06]==] }, {

[==[  last=Alves |first=Fabio |last2=Caminada |first2=Carlos |title=Brazilian Debt Raised to Investment Grade by S&P |publisher=Reuters |date=2008-04-30 |url=http://www.bloomberg.com/apps/news?pid=newsarchive&sid=a86v4f6_W2Jg |access-date=2008-06-09]==] }, {

[==[   author= | title=Gwynne Shotwell: Executive Profile & Biography | url=http://investing.businessweek.com/research/stocks/private/person.asp?personId=39083380& privcapId=7702894& previousCapId=7702894& previousTitle=Space%20Exploration%20Technologies%20Corp | newspaper=Business Week| publisher=Bloomburg | location=New York | date=2011-12-01| access-date=2011-12-01 | archive-url=https://www.webcitation.org/63bzdtgbl?url=http://investing.businessweek.com/research/stocks/private/person.asp?personId=39083380&privcapId=7702894&previousCapId=7702894&previousTitle=Space%20Exploration%20Technologies%20Corp | url-status=live | archive-date=2011-12-01]==] }, {

[==[  first= Irene | last= Klotz | title= SpaceX's Dragon Capsule Returns Safely To Earth|newspaper=Discovery News|publisher=Discovery Communications | location= Silver Spring, Maryland | date=2010-12-08 | url=http://news.discovery.com/space/spacexs-dragon-capsule-returns-safely-to-earth.html |access-date=2010-12-08|archive-url=https://www.webcitation.org/63c6KAVeX?url=http://news.discovery.com/space/spacexs-dragon-capsule-returns-safely-to-earth.html| archive-date=2011-12-01]==] }, {

[==[  last=Engel|first=Max |title=Launch Market on Cusp of Change |url=http://www.satellitetoday.com/via/satellitegetspersonal/Launch-Market-on-Cusp-of-Change_40648.html |access-date=2013-02-15 |newspaper=Satellite Today |date=2013-03-01<!-- this is the PUBLICATION date of the newsstand issue; it came online on the internet by 15 Feb, but its stated date is 1 March 2013 --> |quote=''SpaceX is not the first private company to try to break through the commercial space launch market. The company, however, appears to be the real thing. Privately funded, it had a vehicle before it got money from NASA, and while NASA’s space station resupply funds are a tremendous boost, SpaceX would have existed without it.'' ]==] }, {

[==[title=Bird flu has jumped to baby seals, scientists discover|url=http://edition.cnn.com/2012/07/31/health/baby-seals-avian-flu/index.html?hpt=hp_c4|access-date=31 July 2012|newspaper=[[CNN]]|date=31 July 2012]==] }, {

[==[url=http://www.guardian.co.uk/film/2010/mar/10/oscars-farrah-fawcett|title=Farrah Fawcett:Oscars director apologises for 'In Memoriam' omission|work=The Guardian |access-date=March 8, 2010 | location=London | first=Ben | last=Child | date=March 10, 2010| archive-url= http://web.archive.org/web/20100414020632/http://www.guardian.co.uk/film/2010/mar/10/oscars-farrah-fawcett| archive-date= April 14, 2010 <!--DASHBot-->| url-status=live]==] }, {

[==[url=http://latimesblogs.latimes.com/files/2009/02/being-a-member.html |title=Being an Oscar voter *doesn't* mean never having to say you're sorry |access-date=October 4, 2009 | work=The Los Angeles Times |url-status=dead]==] }, {

[==[author=[[Donald G. McNeil, Jr.]] |title=Precursor to H.I.V. Was in Monkeys for Millennia |url=http://www.nytimes.com/2010/09/17/health/17aids.html?_r=1&src=me&ref=general |quote=Dr. Marx believes that the crucial event was the introduction into Africa of millions of inexpensive, mass-produced syringes in the 1950s.&nbsp;... suspect that the growth of colonial cities is to blame. Before 1910, no Central African town had more than 10,000 people. But urban migration rose, increasing sexual contacts and leading to red-light districts.|work=[[New York Times]] |date=September 16, 2010 |access-date=2010-09-17 ]==] }, {

[==[ url=http://news.bbc.co.uk/2/hi/technology/7091190.stm|title=BBC News: History of Technology|date=November 15, 2007]==] }, {

[==[ url = http://findarticles.com/p/articles/mi_hb197/is_200401/ai_n5556112| title = The Story Behind Apple's '1984' TV commercial: Big Brother at 20| access-date =May 9, 2008| last = Cellini| first = Adelia | date=January 2004| work = [[Macworld]] 21.1, page 18| archive-url = http://web.archive.org/web/20080626112220/| archive-date = June 26, 2008]==] }, {

[==[ last = Spector| first = G| title = Apple's Jobs Starts New Firm, Targets Education Market| work = [[PC Week]]| page = 109| date = September 24, 1985]==] }, {

[==[ url=http://www.cnn.com/2010/TECH/mobile/06/07/apple.wwdc.preview/index.html | title=Apple unveils iPhone 4, 'biggest leap we've taken' since first model | work=CNN | first1=Brandon |last1=Griggs | first2=John D. |last2= Sutter | date=June 8, 2010 | access-date=July 5, 2010| archive-url= http://web.archive.org/web/20100708063056/| archive-date= July 8, 2010 <!--DASHBot-->| url-status=live]==] }, {

[==[ last=Nichols | date=26 March 2010 | first=Vincent | title=The Church is not trying to cover anything up | url=http://www.timesonline.co.uk/tol/comment/columnists/guest_contributors/article7076344.ece | work=The Times | location=London | access-date=22 May 2010 ]==] }  
    }, {nowiki=false, templatestyles=true})
end

function p:test_journal()
    self:preprocess_equals_preprocess_many('{{cite journal/new|', '}}', '{{cite journal|', '}}', {
       {
[==[
  last1 = LAST1
 | first1 = FIRST1
 | author-link1 = author-link1
 | last2 = LAST2
 | first2 = FIRST2
 | author-link2 = author-link2
 | editor-last = EDITOR-LAST
 | editor-first = EDITOR-FIRST
 | editor-link = EDITOR-LINK
 | date = DATE
 | year = YEAR
 | title = TITLE
 | trans-title = TRANS-TITLE
 | journal = JOURNAL
 | volume = VOLUME
 | issue = ISSUE
 | series = SERIES
 | pages = PAGES
 | location = LOCATION
 | publisher = PUBLISHER
 | language = LANGUAGE
 | format = FORMAT
 | type = TYPE
 | arxiv = ARXIV
 | id = ID
 | isbn = ISBN
 | issn = ISSN
 | oclc = OCLC
 | pmid = PMID
 | pmc = PMC
 | bibcode = BIBCODE
 | doi = 10.DOI
 | access-date = access-date
 | url = https://en.wikipedia.org/Main_Page
 | archive-url = https://web.archive.org/web/20190310131346/https://en.wikipedia.org/wiki/Main_Page
 | archive-date = 1 January 2010
 | lay-source = LAYSOURCE
 | lay-url = https://en.wikipedia.org/Wikipedia
 | lay-date = 2010-01-01
 | quote = QUOTE
 | ref = REF
 | postscript = POSTSCRIPT
|no-tracking = true
]==] }, {

[==[
type=Type | title=Article | format=Format | author=Author | journal=Journal | no-tracking=true
]==] }, {

[==[ 
department=Bryan on Scouting | last=Wendell | title=Calendar of New Merit Badges | url=http://blog.scoutingmagazine.org/merit-badge-calendar/ | journal=Scouting | first=Bryan ]==] },{

[==[ 
archive-url=http://wikiwix.com/cache/?url=http%3A%2F%2Fphysics.aps.org%2Farticles%2Fv3%2F98 | date=November 22, 2010 | doi=10.1103/Physics.3.98 | first1=Paul | volume=3 | editor-first=Gene D. | editor-last=Sprouse | url=http://physics.aps.org/articles/v3/98 | issue=98 | journal=Physics | title=Meet a superpartner at the LHC | issn=1943-2879 | publisher=American Physical Society | archive-date=2011-02-22 | oclc=233971234 | location=New York | bibcode=2010PhyOJ...3...98L | last1=Langacker | access-date=21 February 2011 
]==] }, {

[==[ 
archive-url=http://wikiwix.com/cache/?url=http%3A%2F%2Fphysics.aps.org%2Farticles%2Fv3%2F98 | date=November 22, 2010 | doi=10.1103/Physics.3.98 | doi-access=free | first1=Paul | volume=3 | editor-first=Gene D. | editor-last=Sprouse | url=http://physics.aps.org/articles/v3/98 | issue=98 | journal=Physics | title=Meet a superpartner at the LHC | issn=1943-2879 | publisher=American Physical Society | archive-date=2011-02-22 | oclc=233971234 | location=New York | bibcode=2010PhyOJ...3...98L | last1=Langacker | access-date=21 February 2011 
]==] }, {

[==[ author=Sammy De Grave, N. Dean Pentcheff, Shane T. Ahyong ''et al.'' |year=2009 |title=A classification of living and fossil genera of decapod crustaceans |journal=[[Raffles Bulletin of Zoology]] |volume=Suppl. 21 |pages=1–109 |url=http://rmbr.nus.edu.sg/rbz/biblio/s21/s21rbz1-109.pdf |format=[[Portable Document Format|PDF]]

]==] }, {

[==[ author=Tin-Yam Chan |year=2010 |chapter=Annotated checklist of the world's marine lobsters (Crustacea: Decapoda: Astacidea, Glypheidea, Achelata, Polychelida) |editor=Martyn E. Y. Low and S. H. Tan |title=Annotated checklist of anomuran decapod crustaceans of the world (exclusive of the Kiwaoidea and families Chirostylidae and Galatheidae of the Galatheoidea) and marine lobsters of the world |journal=[[Zootaxa]] |volume=Suppl. 23 |pages=153–181 |url=http://rmbr.nus.edu.sg/rbz/biblio/s23/s23rbz153-181.pdf |format=[[Portable Document Format|PDF]]

]==] }, {

[==[ last=Frątczak|first=Sławomir Z.|language=Polish | url=http://www.glos.com.pl/Archiwum_nowe/Rok+2005/032/strona/Cud.html | archive-url=http://web.archive.org/web/20070708173639/ | archive-date=2007-07-08 | journal=[[Głos (1991)|Głos]]|issue=32/2005 | year=2005 | title=Cud nad Wisłą|access-date=June 18, 2006

]==] }, {

[==[ author= |title=The fourth report on the diagnosis, evaluation, and treatment of high blood pressure in children and adolescents |journal=Pediatrics |volume=114 |issue=2 Suppl 4th Report |pages=555–76 |date=August 2004|pmid=15286277 |doi= 10.1542/peds.114.2.S2.555|url= |author1= National High Blood Pressure Education Program Working Group on High Blood Pressure in Children and Adolescents

]==] }, {

[==[ author= |title=The fourth report on the diagnosis, evaluation, and treatment of high blood pressure in children and adolescents |journal=Pediatrics |volume=114 |issue=2 Suppl 4th Report |pages=555–76 |date=August 2004|pmid=15286277 |doi= 10.1542/peds.114.2.S2.555|hdl=2027/uc1.c095473177|hdl-access=free|url= |author1= National High Blood Pressure Education Program Working Group on High Blood Pressure in Children and Adolescents

]==] }, {

[==[ author=Milazzo S, Ernst E, Lejeune S, Schmidt K |title=Laetrile treatment for cancer |journal=Cochrane Database Syst Rev |issue=2 |pages=CD005476 |year=2006 |pmid=16625640 |doi=10.1002/14651858.CD005476.pub2 |editor1-last=Milazzo |editor1-first=Stefania

]==] }, {

[==[ author=M. F. Land |title=Superposition images are formed by reflection in the eyes of some oceanic decapod Crustacea |journal=[[Nature (journal)|Nature]] |year=1976 |volume=263 |pages=764–765 |doi=10.1038/263764a0 |pmid=995187 |issue=5580
]==] }, {

[==[ author=Dale Tshudy & Loren E. Babcock |year=1997 |title=Morphology-based phylogenetic analysis of the clawed lobsters (family Nephropidae and the new family Chilenophoberidae) |journal=[[Journal of Crustacean Biology]] |volume=17 |issue=2 |pages=253–263 |jstor=1549275
]==] }, {

[==[ author=M. Kottek|author2=J. Grieser|author3=C. Beck|author4=B. Rudolf|author5=F. Rubel|title=World Map of the Köppen-Geiger climate classification updated|journal=Meteorol. Z.|volume=15|pages=259–263|url=http://koeppen-geiger.vu-wien.ac.at/pics/kottek_et_al_2006.gif|doi=10.1127/0941-2948/2006/0130|access-date=April 22, 2009|year=2006
]==] }, {

[==[ last = Boddington | first = Ann | title = Sejanus. Whose Conspiracy? | journal = The American Journal of Philology | volume = 84 | issue = 1 | pages = 1–16 | date = January 1963 | doi = 10.2307/293155 | jstor = 293155
]==] }, {

[==[ vauthors=Zubcevic J, Waki H, Raizada MK, Paton JF |title=Autonomic-immune-vascular interaction: an emerging concept for neurogenic hypertension |journal=Hypertension |volume=57 |issue=6 |pages=1026–33 |date=June 2011 |pmid=21536990 |pmc=3105900 |doi=10.1161/HYPERTENSIONAHA.111.169748 |url=http://hyper.ahajournals.org/content/57/6/1026.long
]==] }, {

[==[ author = Whelton PK |name-list-style=vanc | year = 2002 |title = Primary prevention of hypertension:Clinical and public health advisory from The National High Blood Pressure Education Program | url = | journal = JAMA | volume = 288 | issue = 15| pages = 1882–8 |doi = 10.1001/jama.288.15.1882 | pmid = 12377087 | author2 = He J | author3 = Appel LJ | author4 = Cutler JA | author5 = Havas S | author6 = Kotchen TA | display-authors = 6 | last7 = Roccella | first7 = EJ | last8 = Stout | first8 = R | last9 = Vallbona | first9 = C 
|no-tracking=true ]==] }, {

[==[ vauthors=Alcocer L, Cueto L |title=Hypertension, a health economics perspective |journal=Therapeutic Advances in Cardiovascular Disease |volume=2 |issue=3 |pages=147–55 |date=June 2008 |pmid=19124418 |doi=10.1177/1753944708090572 |url=http://tak.sagepub.com/cgi/pmidlookup?view=long&pmid=19124418 |access-date=2009-06-20
]==] }, {

[==[ title = Are EU Trade Sanctions On Burma Compatible With WTO Law? | journal=Are EU Trade Sanctions on Burma Compatible with WTO Law? | first = Robert | last = Howse | author2 = Jared M. Genser | pages = 166+| id = | url = http://students.law.umich.edu/mjil/article-pdfs/v29n2-howse-genser.pdf | access-date =7 November 2010 | quote = repressive and abusive military regime
]==] }, {

[==[ journal = [[Science (journal)|Science]] | last1 = Wodinsky | first1 = Jerome | title = Hormonal Inhibition of Feeding and Death in Octopus: Control by Optic Gland Secretion | date = 2 December 1977 | volume = 198 | issue = 4320| pages = 948–951 | url = http://www.sciencemag.org/content/198/4320/948.abstract | access-date= 27 November 2011 | doi = 10.1126/science.198.4320.948 
]==] }, {

[==[ vauthors=Karakurt F |title=Comparison of the clinical efficacy of flutamide and spironolactone plus ethinyloestradiol/cyproterone acetate in the treatment of hirsutism: a randomised controlled study |journal=Adv Ther |volume=25 |issue=4 |pages=321–8 |date=April 2008 |isbn=1232500800395 
]==] }, {

[==[ title = Mr. Mackintosh's New God | first = George Jacob | last = Holyoake | author-link = George Holyoake | magazine = [[w:The Oracle of Reason|The Oracle of Reason, Or, Philosophy Vindicated]] | volume = 1 | issue = 23 | year = 1842 | page = 186 | url = http://books.google.com/books?id=BFY9AAAAYAAJ&pg=PA186 | quote = On the contrary, I, as an Atheist, simply profess that I do not see sufficient reason to ''believe'' that there is a god. I do not pretend to ''know'' that there is no god. The whole question of god's existence, ''belief'' or ''disbelief'', a question of probability or of improbability, not knowledge.
]==] }, {

[==[ last1 = Arenillas | first1 = Miguel | last2 = Castillo | first2 = Juan C. | title = Dams from the Roman Era in Spain. Analysis of Design Forms (with Appendix) | journal = 1st International Congress on Construction History [20th–24th January] | publication-place = Madrid | year = 2003 | url = http://www.traianvs.net/textos/presas_in.htm#_ednref4 
]==] }, {

[==[ author=International Union of Crystallography |year=1992 |title=Report of the Executive Committee for 1991 |journal=Acta Crystallogr. A |volume=48 |issue= 6|pages=922 |doi=10.1107/S0108767392008328
]==] }, {

[==[ author=International Union of Crystallography |year=1992 |title=Report of the Executive Committee for 1991 |journal=Acta Crystallogr. A |volume=48 |issue= 6|pages=922 |doi=10.1107/S0108767392008328|pmc=1438678
]==] }, {

[==[ url = http://www.minsocam.org/ammin/AM66/AM66_885.pdf|journal = American Mineralogist|volume = 66|page=885|year= 1981|title= The largest crystals|author = Rickwood, P. C.
]==] }, {

[==[ last=Watling|first=H. R.|title=The bioleaching of sulphide minerals with emphasis on copper sulphides — A review | journal=Hydrometallurgy | year=2006 | volume=84 | issue=1, 2 | pages=81–108 | url=http://infolib.hua.edu.vn/Fulltext/ChuyenDe/ChuyenDe07/CDe53/59.pdf | format=PDF | doi=10.1016/j.hydromet.2006.05.001
]==] }, {

[==[ vauthors=Richmond SJ, Brown SR, Campion PD, Porter AJ, Moffett JA, Jackson DA, Featherstone VA, Taylor AJ |title=Therapeutic effects of magnetic and copper bracelets in osteoarthritis: a randomised placebo-controlled crossover trial|journal=Complement Ther Med.|year=2009|volume=17|issue=5-6|pages=249–256|pmid=19942103|doi=10.1016/j.ctim.2009.07.002
]==] }, {

[==[ author=Kivelson G. M., Russell, C. T. |title=Introduction to Space Physics |publisher=Cambridge University Press |year=1995|isbn=0-521-45714-9
]==] }, {

[==[ last=Quigg| first=Catherine T.| title=Tritium Warning| journal=Bulletin of the Atomic Scientists| volume=40|issue=3| pages=56–57|date=March 1984
]==] }, {

[==[ last1 = Ralston | first1 = NVC | last2 = Raymond | first2 = LJ | year = 2010 | title = Dietary selenium's protective effects against methylmercury toxicity | url = | journal = Toxicology | volume = 278 | issue = | pages = 112–123 
]==] }, {

[==[ author=Aller TA, Wildsoet C |title=Bifocal soft contact lenses as a possible myopia control treatment: a case report involving identical twins |journal=Clin Exp Optom |volume=91 |issue=4 |pages=394–9 |date=July 2008 |pmid=18601670 |doi=10.1111/j.1444-0938.2007.00230.x |url=
]==] }, {

[==[ pmid=17742735|year=1969|last1=Gorman|first1=CF|title=Hoabinhian: A pebble-tool complex with early plant associations in southeast Asia|volume=163|issue=3868|pages=671–3|doi=10.1126/science.163.3868.671|journal=Science
]==] }, {

[==[ last1 = Tormmsdof | first1 = V. | year = 1966 | title = Progressive metamorphose kieseliger karbonatgesteine in den Zentralalpen zwischen Bernina und Simplon | url = | journal = Schweizerische Mineralogische und Petrographische Mitteilungen = Bulletin Suisse de Mineralogie et Petrographie | volume = 46 | issue = | pages = 431–460 
]==] }, {

[==[ author=Kivelson G. M., Russell, C. T. |title=Introduction to Space Physics |publisher=Cambridge University Press |year=1995|isbn=0-521-45714-9
]==] }, {

[==[ author=Ellenberger, C. Leroy|date=Winter 1984 |author-link=C. Leroy Ellenberger |title=Worlds in Collision in Macmillan's Catalogues |journal=Kronos | volume=9 | issue=2 | url=http://www.catastrophism.com/cdrom/pubs/journals/kronos/vol0902/index.htm |access-date=2009-05-16
]==] }, {

[==[ author = Zapolski TC, Cyders MA, Smith GT | title = Positive urgency predicts illegal drug use and risky sexual behavior | journal = Psychol Addict Behav | volume = 23 | issue = 2 | pages = 348–54 | date = June 2009 | pmid = 19586152 | pmc = 2709762 | doi = 10.1037/a0014684 
]==] }, {

[==[ first=J. | last=Blackwell | author2 =M.R. Nagarajan |author3= T.B. Hoitink | title=The Structure of the Hard Segments in MDI/diol/PTMA Polyurethane Elastomers | publisher=American Chemical Society | location=Washington, D.C. | year=1981 | issn=0097-6156/81/0172-0179
]==] }, {

[==[ author=Ehret GB |name-list-style=vanc |title=Genetic variants in novel pathways influence blood pressure and cardiovascular disease risk |journal=Nature |volume=478 |issue=7367 |pages=103–9 |date=October 2011 |pmid=21909115 |doi=10.1038/nature10405 |author2=Munroe PB |author3=Rice KM|display-authors=3 |last4=Bochud |first4=Murielle |last5=Johnson |first5=Andrew D. |last6=Chasman|first6=Daniel I. |last7=Smith |first7=Albert V. |last8=Tobin |first8=Martin D. |last9=Verwoert|first9=Germaine C. |pmc=3340926
]==] }, {

[==[ author=Lewington S, Clarke R, Qizilbash N, Peto R, Collins R |title=Age-specific relevance of usual blood pressure to vascular mortality: a meta-analysis of individual data for one million adults in 61 prospective studies |journal=Lancet |volume=360 |issue=9349 |pages=1903–13 |date=December 2002 |pmid=12493255 |doi= 10.1016/S0140-6736(02)11911-8|url=
]==] }, {

[==[ author = Steiner DF, Oyer PE | title = The biosynthesis of insulin and a probable precursor of insulin by a human islet cell adenoma | journal = Proc. Natl. Acad. Sci. U.S.A. | volume = 57 | issue = 2 | pages = 473–480 | date = February 1967 | pmid = 16591494 | pmc = 335530 | doi = 10.1073/pnas.57.2.473| url = 
]==] }, {

[==[ author = Menting JG, Whittaker J, Margetts MB, Whittaker LJ, Kong GK-W, Smith BJ, Watson CJ, Žáková L, Kletvíková E, JJ, Chan SJ, Steiner DF, Dodson GG, Brzozowski AM, Weiss MA, Ward CW, Lawrence MC | title = How insulin engages its primary binding site on the insulin receptor | journal = Nature | year = 2013 | volume = 493 | issue = 7431 | pages = 241–245 | doi = 10.1038/nature11781 | lay-url = http://www.abc.net.au/news/2013-01-10/australian-researchers-crack-insulin-mechanism/4458974 | lay-source = Australian Broadcasting Commission 
]==] }, {

[==[ author=J Clemens, PG Jones, NH Gilbert|date=|year=1977 |title=Effect of seed treatments on germination in Acacia|journal=Australian Journal of Botany |volume=25 |issue=3 |pages=269–267 |pmid=|doi=10.1071/BT9770269|url=http://www.publish.csiro.au/nid/65/paper/BT9770269.htm
]==] }, {

[==[ title=Martinez Beavers |author=Aleta George |url=http://baynature.org/articles/jan-mar-2008/ear-to-the-ground/martinez-beavers |year=2008 |magazine=Bay Nature |publisher=Bay Nature Institute |access-date=November 6, 2009 
]==] }, {

[==[ author = Weissman KJ, Müller R |title = Protein-protein interactions in multienzyme megasynthetases |journal = ChemBioChem |volume = 9 |issue = 6 |pages = 826–48 |year = 2008 |pmid = 18357594 |doi = 10.1002/cbic.200700751 
]==] }, {

[==[ last1 = Coyne | first1 = Jerry A. | author2 = Barton, Turelli | title = Perspective: A Critique of Sewall Wright's Shifting Balance Theory of Evolution | journal = Evolution | year = 1997 | volume = 51 | issue = 3 | series = 3 | pages = 643–671 | doi = 10.2307/2411143 
]==] }, {

[==[ doi = 10.1086/377226 |title = First-Year Wilkinson Microwave Anisotropy Probe (WMAP) Observations: Determination of Cosmological Parameters |first = D. N. |last = Spergel |journal = The Astrophysical Journal Supplement Series |volume = 148 |year = 2003 |issue = 1 |pages = 175–94 |last2 = Verde |first2 = L. |last3 = Peiris |first3 = H. V. |last4 = Komatsu |first4 = E. |last5 = Nolta |first5 = M. R. |last6 = Bennett |first6 = C. L. |last7 = Halpern |first7 = M. |last8 = Hinshaw |first8 = G. |last9 = Jarosik |first9 = N. |bibcode = 2003ApJS..148..175S |arxiv = astro-ph/0302209 
| no-tracking = true
]==] }
}, {nowiki=false, templatestyles=true})
end

function p:test_book()
    self:preprocess_equals_preprocess_many('{{cite book/new|', '}}', '{{cite book|', '}}', {
       {
[==[
 last                  = LAST
| first                 = FIRST
| author-link            = author-link
| last2               = LAST2
| first2              = FIRST2
| author-link2         = author-link2
| editor-last           = EDITOR-LAST
| editor-first          = EDITOR-FIRST
| editor-link           = EDITOR-LINK
| editor2-last        = EDITOR2-LAST
| editor2-first       = EDITOR2-FIRST
| editor2-link        = EDITOR2-LINK
| others                = OTHERS
| title                 = TITLE
| trans-title           = TRANS-TITLE
| url                   = https://en.wikipedia.org/Main_Page
| archive-url            = https://web.archive.org/web/20190310131346/https://en.wikipedia.org/wiki/Main_Page
| archive-date           = January 1, 2010
| format                = FORMAT
| access-date            = 1 January, 2010
| type                  = TYPE
| edition               = EDITION
| series                = SERIES
| volume                = VOLUME
| date                  = DATE
| origyear              = ORIGYEAR
| year                  = YEAR
| publisher             = PUBLISHER
| location              = LOCATION
| language              = LANGUAGE
| isbn                  = ISBN
| oclc                  = OCLC
| lccn                  = LCCN
| doi                   = 10.DOI
| bibcode               = BIBCODE
| id                    = ID
| page                  = PAGE
| pages                 = PAGES
| nopp                  = NOPP
| at                    = AT
| chapter               = CHAPTER
| trans-chapter         = TRANS-CHAPTER
| chapterurl            = https://en.wikipedia.org/Main_Page#top
| quote                 = QUOTE
| ref                   = REF
| lay-url               = https://en.wikipedia.org/Wikipedia
| lay-date               = 2010-01-01
| author-mask           = AUTHOR-MASK
| display-authors       = 10
| postscript            = POSTSCRIPT
| no-tracking = true
]==] }, {

[==[ last=Rabinovich|first=Viktor Abramovich |author2=Vasserman, A. A.|author3=Nedostup, V. I. |author4=Veksler, L. S.|title=Thermophysical properties of neon, argon, krypton, and xenon|year=1988|edition=English-language |publisher=Hemisphere Publishing Corp. |location=Washington, DC|isbn=0-89116-675-0 |url=http://adsabs.harvard.edu/abs/1988wdch...10.....R |access-date=2009-04-02
]==] }, {

[==[ author=Anonymous|editor=Daniel Coit Gilman |editor2=Harry Thurston Peck |editor3=Frank Moore Colby |year=1904|title=The New International Encyclopædia |publisher=Dodd, Mead and Company|page=906
]==] }, {

[==[ pages=1328–1334|title=Linus Pauling: Selected Scientific Papers|volume=2|editor=Pauling, Linus |editor2=Kamb, Barclay |place=River Edge, New Jersey|publisher=World Scientific |year=2001|isbn=981-02-2940-2|url=http://books.google.com/?id=2QduA19d_X8C&pg=PA1329
]==] }, {

[==[ title=Soedirman: Bapak Tentara Indonesia |trans-title=Soedirman: Father of the Indonesian Military |language=Indonesian |last=Adi |first=A. Kresna |publisher=Mata Padi Pressindo |isbn=978-602-95337-1-2 |location=Yogyakarta |year=2011
]==] }, {

[==[ url=http://books.google.ca/books?id=WrkzPcxBnLMC |title=Takhta untuk Rakyat: Celah-celah Kehidupan Sultan Hamengku Buwono IX |trans-title=Serving the People: The Life Story of Sultan Hamengku Buwono IX |language=Indonesian |isbn=978-979-22-6767-9 |editor1-first=Mohamad |editor1-last=Roem |editor1-link=Mohamad Roem |editor2-first=Mochtar |editor2-last=Lubis |editor2-link=Mochtar Lubis |editor3-first=Kustiniyati |editor3-last=Mochtar |editor4-first=Maimoen |editor4-last=S. |last=Nasution |first=A. H. |author-link=Abdul Haris Nasution |publisher=Gramedia Pustaka Utama |location=Jakarta |year=2011 |origyear=1982 |edition=Revised 
|no-tracking=true ]==] }, {

[==[ author=Luhmann J. G., Russell C. T. |editor=J. H. Shirley and R. W. Fainbridge |title=Venus: Magnetic Field and Magnetosphere |work=Encyclopedia of Planetary Sciences |publisher=Chapman and Hall, New York|year=1997 |url=http://www-spc.igpp.ucla.edu/personnel/russell/papers/venus_mag/ |access-date=2009-06-28|isbn=978-1-4020-4520-2
]==] }, {

[==[ author=Feldman, M. S.; Ferrara, L. A.; Havenstein, P. L.; Volonte, J. E.; Whipple, P. H. |title=Manned Venus Flyby, February 1, 1967 |publisher=Bellcomm, Inc |url=http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19790072165_1979072165.pdf |format=PDF|year=1967
]==] }, {

[==[ last=Rose |first=Herbert Jennings |author-link=H.J. Rose |title=A Handbook of Greek Mythology |edition=1st |year=1959 |publisher=E.P. Dutton & Co. |location=New York |language= |isbn=0-525-47041-7 |pages=173
]==] }, {

[==[ url=http://www.ethnologue.com/show_country.asp?name=AR|title=Languages of Argentina|work=Ethnologue: Languages of the World|edition=16th|editor=Lewis, M. Paul|publisher=SIL International|place=Dallas|year=2009
]==] }, {

[==[ editor=Jean Chrétien Ferdinand Hoefer |contribution=Labarraque, Antoine-Germain |title=Nouvelle biographie universelle |volume=28 |pages=323–324 |ol=24229911M 
]==] }, {

[==[ last=Crepeau |first=Bob |title=Niels Bohr: The Atomic Model |journal=Great Scientific Minds |publisher=Great Neck Publishing |date=2006-01-01 |isbn=1-4298-0723-7
]==] }, {

[==[ last=Holderness |first=Mary |title=Journey from Riga to the Crimea, with some account of the manners and customs of the colonists of new Russia. |year=1823 |publisher=Sherwood, Jones and co. |location=London |oclc=5073195 |page=316 |lccn=04024846
]==] }, {

[==[ author=Herbst, T. M.; Rix, H.-W.|year=1999 |editor=Guenther, Eike; Stecklum, Bringfried; Klose, Sylvio|title=Star Formation and Extrasolar Planet Studies with Near-Infrared Interferometry on the LBT |book-title=Optical and Infrared Spectroscopy of Circumstellar Matter, ASP Conference Series, Vol. 188. |isbn=1-58381-014-5|pages=341–350 |bibcode=1999ASPC..188..341H |publisher=Astronomical Society of the Pacific |location=San Francisco, Calif.
]==] }, {

[==[ author = Marius Turda| title = The idea of national superiority in Central Europe, 1880-1918| year = 2004| publisher = Edwin Mellen Press| isbn = 978-0-7734-6180-2 ]==] }, {

[==[ author=Bhagavan NV|title=Medical Biochemistry |publisher=Harcourt/Academic Press |location=San Diego |year=2002 |isbn=0-12-095440-0|url=http://books.google.com/?id=vT9YttFTPi0C&printsec=frontcover]==] }, {

[==[ author=Edgar Thorpe|title=The Pearson CSAT Manual 2012|url=http://books.google.com/books?id=1cruroSVFoUC&pg=RA3-PA38|access-date=18 November 2012|year=2012|publisher=Pearson Education India|isbn=978-81-317-6734-4|page=3]==] }, {

[==[ author=Iyengar PTS |year=2001 |title=History Of The Tamils: From the Earliest Times to 600 A.D. |publisher=Asian Educational Services |isbn=81-206-0145-9 |url=http://books.google.com/books?id=ERq-OCn2cloC |pages=192–195 |access-date=29 December 2008 ]==] }, {

[==[ author=Motilal (UK) Books of India|title=Tourist Guide Kerala|url=http://books.google.com/books?id=ZYfRBcLdTNYC&pg=PA11|access-date=18 November 2012|date=1 February 2008|publisher=Sura Books|isbn=978-81-7478-164-2|page=11]==] }, {

[==[ author=S. N. Sadasivan|title=River Disputes in India: Kerala Rivers Under Siege|url=http://books.google.com/books?id=hhrRboi5kOcC&pg=PA223|access-date=18 November 2012|year=2003|publisher=Mittal Publications|isbn=978-81-7099-913-3|page=223]==] }, {

[==[ author1=Joseph Needham|author2=Gwei-Djen Lu|author3=Ling Wang|title=Science and civilisation in China, Volume 5, Part 7|year=1987|publisher=Cambridge University Press|isbn=978-0-521-30358-3|pages=48–50]==] }, {

[==[ editor=Mark W. Denny |editor2=Steven Dean Gaines |year=2007 |title=Encyclopedia of tidepools and rocky shores |publisher=[[University of California Press]] |isbn=978-0-520-25118-2 |author=Carlos Robles |chapter=Lobsters |pages=333–335 |url=http://books.google.co.uk/books?id=uufQnE7MzMkC&pg=PA333]==] }, {

[==[ first=Elena|last=Aprile|author2=Bolotnikov, Aleksey E. |author3=Doke, Tadayoshi |title=Noble Gas Detectors|publisher=Wiley-VCH|year=2006 |isbn=3-527-60963-6|url=http://books.google.com/?id=tsnHM8x6cHAC&pg=PT1|pages=8–9]==] }, {

[==[ first=Sidney F. |last=Ray |title=Applied Photographic Optics: Lenses and Optical Systems for Photography, Film, Video, Electronic and Digital Imaging |location= |publisher=Focal Press |year=2002 |isbn=0-240-51540-4 |page=40 |url=http://www.google.com/books?id=cuzYl4hx-B8C&printsec=frontcover#PPA40,M1 ]==] }, {

[==[ last = Koch | first = John | title = Tartessian: Celtic from the Southwest at the Dawn of History in Acta Palaeohispanica X Palaeohispanica 9 (2009)| publisher=Palaeohispanica | year = 2009 | pages = 339–351 | url = http://ifc.dpz.es/recursos/publicaciones/29/54/26koch.pdf | id = | issn = 1578-5386 | access-date =17 May 2010 ]==] }, {

[==[ last = Rhodes |first = Richard |year = 1986 |title = The Making of the Atomic Bomb |isbn = 0-671-65719-4 |pages = 659–660 |publisher = Simon & Schuster |location = New York]==] }, {

[==[ last = Watt | first = William Montgomery |author-link = William Montgomery Watt| title = [[Muhammad at Mecca (book)|Muhammad at Mecca]]| publisher=Oxford University Press | year = 1953 | id =]==] }, {

[==[ last=Cooper |first=J.C. |title=Symbolic and Mythological Animals |pages=25–26 |year=1992 |publisher=Aquarian Press |location=London |isbn=1-85538-118-4]==] }, {

[==[ last=Finnegan |first=Dana G. |author2 = Emily B. McNally |title=Counseling Lesbian, Gay, Bisexual, and Transgender Substance Abusers: Dual Identities |publisher=Haworth Press |date=2002|isbn= 1-56023-925-5 |url =http://books.google.com/books?id=I32nHF_gaTsC ]==] }, {

[==[ title=[[Ellipsis|Dots...]] |author=Doe, Dotty D. | publisher=[[McGraw-Hill|Dot Corp.]] |series=Dot Books Etc. |pages=23 ''[[ff.]]'' |id=Std. ]==] }, {

[==[ last=Hume |first=David |author-link=David Hume |title=[[s:An Enquiry Concerning Human Understanding|An Enquiry Concerning Human Understanding]] |year=1748 |location=London]==] }, {

[==[ last=Köse|first=Yavuz|editor-last=Atabaki|editor-first=Touraj|editor2-last=Brockett|editor2-first=Gavin|chapter=Vertical Bazaars of Modernity: Western Department Stores and Their Staff in Istanbul (1889–1921)|title=Ottoman and Republican Turkish Labour History|publisher=Cambridge University Press|location=Cambridge, Eng.|year=2009|isbn=978-0-521-12805-6|pages=91–114]==] }, {

[==[ last=Roebuck|first=Carl|title=Ionian Trade and Colonization|year=1959|series=Monographs on Archaeology and Fine Arts|publisher=Archaeological Institute of America|location=New York|isbn=978-0-89005-528-1]==] }, {

[==[ last=Wiberg|first= Egon|author2= Wiberg, Nils |author3=Holleman, Arnold Frederick |title=Inorganic Chemistry |publisher=Academic Press|year=2001|isbn=0-12-352651-5]==] }, {

[==[ last1=Masters|first1=Bruce Alan|last2=Ágoston|first2=Gábor|year=2009|title=Encyclopedia of the Ottoman Empire|publisher=Infobase Publishing|location=New York|isbn=978-1-4381-1025-7]==] }, {

[==[ url=http://books.google.ca/books?id=LjzZ_rVv_2MC&pg=PA30 |title=Villes et organisation de l'espace en Afrique |pages=30–31 |first1=Jérôme |last1=Aloko-N'Guessan |first2=Amadou |last2=Diallo |first3=Kokou Henri |last3=Motcho |publisher=KARTHALA Editions |year=2010 |ISBN=2-8111-0339-2]==] }, {

[==[ title = Statics: Analysis and Design of Systems in Equilibrium | last = Sheppard and Tongue | publisher = Wiley and Sons | year = 2005 | page = 618 | quote = In general, for given contacting surfaces, ''μ''<sub>k</sub> < ''μ''<sub>s</sub> | isbn = 0-471-37299-4]==] }, {

[==[ title=A Concise History of Modern India |first1=Barbara D. |last1=Metcalf |first2=Thomas R. |last2=Metcalf |author-link1=Barbara D. Metcalf |author-link2=Thomas R. Metcalf |edition=Second |location=Cambridge |publisher=Cambridge University Press |year=2006 |pages=20–21 |isbn=978-0-521-86362-9]==] }, {

[==[ title=Geochemical processes in soil and groundwater: measurement—modelling—upscaling |first1=Horst D. |last1=Schulz |first2=Astrid |last2=Hadeler |author3=Deutsche Forschungsgemeinschaft |publisher=Wiley-VCH |year=2003 |isbn=3-527-27766-8 |page=67 |url=http://books.google.com/books?id=Fo1PjKW9GpUC]==] }, {

[==[ title=Normans: The History of a Dynasty|last=Crouch|first=David|year=2006|publisher=Hambledon Continuum|isbn=978-1-85285-595-6Z]==] }, {

[==[ title=Southeastern Ceremonial Complex : Chronology, Content, Context|editor=King, Adam|author1=Kelly, John E.|author2=Brown, James A.|author3=Hamlin, Jenn M.|author4=Kelly, Lucretia S.|author5=Kozuch, Laura|author6=Parker, Kathryn|author7=Van Nest, Julieann|chapter=Mound 34 : The Context for the Early Evidence of the Southeastern Ceremonial Complex at Cahokia|pages=57–87|isbn=978-0-8173-5409-1|publisher=University of Alabama Press]==] }, {

[==[ url = http://books.google.ca/books?id=0M4Pl_VCExgC | title = Forgotten Wars: Freedom and Revolution in Southeast Asia | isbn = 978-0-674-02153-2 | last1 = Bayly | first1 = Christopher Alan | last2 = Harper | first2 = Timothy Norman | year = 2007 | location = Cambridge | publisher = Belknap Press ]==] }, {

[==[ url = http://books.google.de/books?id=iX194mHFAcYC&pg=PA11 | page = 11 | title = The Correspondence of Michael Faraday | isbn = 978-0-86341-251-6 | author1 = Faraday, Michael | author2 = James, Frank A. J. L | year = 1999]==] }, {

[==[ url=http://books.google.com/?id=COcVgAtqeKkC&pg=PA473|page=473|title=Handbook of semiconductor silicon technology|first1=William C.|last1=O'Mara|first2=Robert B.|last2 =Herring| first3=Lee Philip|last3=Hunt|publisher=William Andrew|year=1990|isbn=978-0-8155-1237-0]==] }, {

[==[ last=Sedgwick |first=John |title=Popular Filmgoing In 1930s Britain: A Choice of Pleasures |publisher=[[University of Exeter Press]] |year=2000 |isbn=9780859896603 |pages=[http://books.google.com/books?id=YsUfc8Ijb-wC&pg=PA146 146]–148 ]==] }, {

[==[ chapter=Naturalism and Physicalism | last=Fales | postscript=, | first=Evan ]==] }, {

[==[ trans-title=My Book in English | last=Pan | location=Neverland | date=1965 | first=Peter | publisher=Foreign Books 
|no-tracking = true ]==] }, {

[==[ trans-title=My Book in English | last=Pan | location=Neverland | date=1965 | first=Peter | publisher=Foreign Books | url = http://www.foo.com/
|no-tracking = true ]==] }, {

[==[ first5=FifthFirst | last1=FirstLast | last3=ThirdLast | last2=SecondLast | first2=SecondFirst | first4=FourthFirst | author-mask=with | last4=FourthLast | first1=FirstFirst | title=Title | last5=FifthLast | first3=ThirdFirst ]==] }

}, {nowiki=false, templatestyles=true})
end

function p:test_web()
    self:preprocess_equals_preprocess_many('{{cite web/new|', '}}', '{{cite web|', '}}', {
       {
[==[ 
 url          = URL
 |title        = TITLE
 |last1        = LAST1
 |first1       = FIRST1
 |author-link1  = author-link1
 |last2        = LAST2
 |first2       = FIRST2
 |author-link2  = author-link2
 |date         = DATE
 |year         = YEAR
 |editor-last  = EDITOR-LAST
 |editor-first = EDITOR-FIRST
 |editor       = EDITOR
 |editor-link  = EDITOR-LINK
 |editor1-last = EDITOR1-LAST
 |editor1-first= EDITOR1-FIRST
 |editor1-link = EDITOR1-LINK
 |editor2-last = EDITOR2-LAST
 |editor2-first= EDITOR2-FIRST
 |editor2-link = EDITOR2-LINK
 |work         = WORK
 |series       = SERIES
 |publisher    = PUBLISHER
 |location     = LOCATION
 |page         = PAGE
 |pages        = PAGES
 |at           = AT
 |language     = LANGUAGE
 |trans-title  = TRANS-TITLE
 |type         = TYPE
 |format       = FORMAT
 |arxiv        = ARXIV
 |asin         = ASIN
 |bibcode      = BIBCODE
 |doi          = 10.DOI
 |doi-broken-date = 10 June 2015
 |isbn         = ISBN
 |issn         = ISSN
 |jfm          = JFM
 |jstor        = JSTOR
 |lccn         = LCCN
 |mr           = MR
 |oclc         = OCLC
 |ol           = OL
 |osti         = OSTI
 |pmc          = PMC
 |pmid         = PMID
 |rfc          = RFC
 |ssrn         = SSRN
 |zbl          = ZBL
 |id           = ID
 |archive-url   = https://web.archive.org/web/20190310131346/https://en.wikipedia.org/wiki/Main_Page
 |archive-date  = archive-date
 |url-status   = URLSTATUS
 |access-date   = access-date
 |quote        = QUOTE
 |ref          = REF
 |postscript   = POSTSCRIPT
|no-tracking = true
]==] }, {

[==[ url= http://www.indec.mecon.ar/nuevaweb/cuadros/2/proyecciones_provinciales_vol31.pdf |title= Proyecciones provinciales de población por sexo y grupos de edad 2001–2015 |work=Gustavo Pérez |format= PDF |publisher=[[INDEC]] |page= 16 |language= español
]==] }, {

[==[ url=http://www.gamesbids.com/eng/index.php?news=1177787226 |title= Delhi To Bid For 2020 Summer Games|access-date=5 August 2007 |date=28 April 2007 |work= gamesbids.com|publisher= Menscerto Inc. 
]==] }, {

[==[ author=Staff|year=2007 |url=http://www.infoplease.com/ce6/sci/A0852881.html |title=Xenon|work=Columbia Electronic Encyclopedia |edition=6th|publisher=Columbia University Press |access-date=2007-10-23
]==] }, {

[==[ url=http://shook.pragmatism.org/skepticismaboutthesupernatural.pdf | title=Skepticism about the Supernatural | author=Shook, John R. | access-date=2012-10-02
]==] }, {

[==[ title=Bintang Mahaputera Adipurna |language=Indonesian |url=http://www.setneg.go.id/index.php?option=com_tandajasa&Itemid=43&cat=2&id=6 |work=Awards of the Republic of Indonesia |publisher=Indonesian State Secretariat |access-date=17 May 2012
]==] }, {

[==[ url=http://www.fs.fed.us/r9/publications/success_story_updates/2003-05.pdf |format=PDF|title=Success Stories |access-date=2008-04-20 |author=US Forest Service |date=May 2003 |chapter=Mules Key in Accomplishing Trail Work |publisher=US Department of Agriculture |page=4
]==] }, {

[==[ url=http://www.ommbid.com/ |title= Galactosemia |chapter=72 |author=Fridovich-Keil JL, Walter JH |format= |work=The Online Metabolic and Molecular Bases of Inherited Disease |access-date=
]==] }, {

[==[ author=Vijverberg et al. | title=Similar mode of action of pyrethroids and DDT on sodium channel gating in myelinated nerves | url=http://www.nature.com/nature/journal/v295/n5850/abs/295601a0.html | journal=Nature | volume=42 | issue=295 | year=1982 | access-date=2012-04-28
]==] }, {

[==[ url= http://www.ign.gob.ar/AreaProfesional/Geografia/DatosArgentina|title= Datos de la República Argentina|language = Spanish|trans-title = Data of the Argentine Republic|author= Rubén Albanese|year= 2009|publisher= Instituto Geográfico Nacional
]==] }, {

[==[ url=http://www.cornellpress.cornell.edu/book/?GCOI=80140100965480|author=Bamber, G.J., Gittell, J.H., Kochan, T.A. & von Nordenflytch, A. |year=2009 |title=Up in the Air: How Airlines Can Improve Performance by Engaging their Employees|publisher=Cornell University Press, Ithaca |chapter=Chapter 5
]==] }, {

[==[ access-date=2007-07-21|url=http://www.roman-emperors.org/assobd.htm#t-inx|title=De Imperatoribus Romanis|work=An Online Encyclopedia of Roman Emperors|quote= Battle of Sarmizegetusa (Sarmizegetuza), A.D. 105. During Trajan's reign one of the most important Roman successes was the victory over the Dacians. The first important confrontation between the Romans and [[Dacia|the Dacians]] had taken place in the year 87 and was initiated by Domitian. The [[praetorian prefect]] Cornelius Fuscus led five or six legions across the Danube on a bridge of ships and advanced towards [[Banat]] (in [[Romania]]). The Romans were surprised by a Dacian attack at Tapae (near the village of [[Bucova]], in Romania). [[Legion V Alaude]] was crushed and Cornelius Fuscus was killed. The victorious [[Dacia]]n general was originally known as [[Diurpaneus]] (see Manea, p.109), but after this victory he was called [[Decebalus]] (the brave one). ]==] }, {

[==[ author = Fermilab | year = 2006 | title = Jobs at Fermilab: Employer Awards | url = http://lss.fnal.gov/employ/employer_awards.html | access-date = 2006-01-06 |archive-url = http://web.archive.org/web/20070110184255/http://lss.fnal.gov/employ/employer_awards.html |archive-date = January 10, 2007]==] }, {

[==[ author=Posted 8 April 2000 by admin |url=http://www.foodfirst.org/media/opeds/2000/4-greenrev.html |title=Food First/Institute for Food and Development Policy |publisher=Foodfirst.org |date=8 April 2000 |access-date=25 August 2010]==] }, {

[==[ first=Ray P.|last=Norris|pages=1–4 |title=Searching for the Astronomy of Aboriginal Australians |work=Conference Proceedings | year=2004 |publisher=Australia Telescope National Facility | url=http://www.atnf.csiro.au/research/AboriginalAstronomy/literature/Norris2007b.pdf |format=PDF | access-date=2009-05-16]==] }, {

[==[ title =The National Revolution, 1945–50 | work =Country Studies, Indonesia | publisher =U.S. Library of Congress | date = | url =http://countrystudies.us/indonesia/16.htm | doi = | access-date = ]==] }, {

[==[ last= Smith |first= Joseph Jr |author-link= Joseph Smith Jr |title= Pearl Of Great Price |url= http://lds.org/library/display/0,4945,106-1-2-1,FF.html |postscript= <!-- Bot inserted parameter. Either remove it; or change its value to "." for the cite to end in a ".", as necessary. -->]==] }, {

[==[ last=Cooler | first=Richard M. | title=The Art and Culture of Burma | year=2002 | url=http://www.seasite.niu.edu/burmese/cooler/BurmaArt_TOC.htm | publisher=Northern Illinois University | location=DeKalb ]==] }, {

[==[ last=Food|first=BBC|title=Tapenade | url=http://www.bbc.co.uk/food/tapenade | work=BBC Food | publisher=British Broadcasting Corporation | access-date=4 July 2011]==] }, {

[==[ last=Nave| first=C. R.|title=Deuterium-Tritium Fusion| work=HyperPhysics| publisher=Georgia State University| year=2006| url=http://hyperphysics.phy-astr.gsu.edu/Hbase/nucene/fusion.html| access-date=2008-03-08]==] }, {

[==[ last=Stern|first=David P.|date=2005-02-13| url=http://www-spof.gsfc.nasa.gov/stargaze/Q7.htm| title=Wave Mechanics| publisher=NASA Goddard Space Flight Center| access-date=2008-04-16]==] }, {

[==[ publisher=[http://www.metalfromfinland.com/ MetalFromFinland.com] | title=Nightwish's 'Amaranth' Single Available As Flower-Fragrance-Shaped Picture Disc | url=http://www.metalfromfinland.com/news/2010-01-29_11:19/nightwishs_amaranth_single_available_as_flowerfragranceshaped_picture_disc | date= 2010-01-29 | access-date=2010-01-13]==] }, {

[==[ title = How Wildfires Work|author= Bonsor, Kevin| publisher = [[HowStuffWorks]]| url = http://science.howstuffworks.com/wildfire.htm|access-date=2007-07-23| archive-url= http://web.archive.org/web/20070714174036/http://science.howstuffworks.com/wildfire.htm| archive-date= 14 July 2007 <!--DASHBot-->| url-status=live]==] }, {

[==[ title = The real Chubby Checker, 71, was born with the name Ernest Evans. He trademarked his stage name in 1997|url = http://www.guardian.co.uk/music/2013/feb/14/chubby-checker-sues-hewlett-packard|access-date = February 14, 2013]==] }, {

[==[ title=A Long Lipid, a Long Name: Docosahexaenoic Acid|url=http://www.samuelfurse.com/2011/12/a-long-name-a-long-lipid-docosahexaenoic-acid/|work=The Lipid Chronicles|access-date=2011-12-31]==] }, {

[==[ title=California Symbols |publisher=California State Capitol Museum |url=http://www.capitolmuseum.ca.gov/VirtualTour.aspx?content1=1278&Content2=1374&Content3=1294 |access-date=2007-09-14| archive-url= http://web.archive.org/web/20071012123245/http://capitolmuseum.ca.gov/VirtualTour.aspx?content1=1278&Content2=1374&Content3=1294| archive-date= 12 October 2007 <!--DASHBot-->| url-status=live]==] }, {

[==[ title=Maternal and Neonatal Tetanus Elimination by 2005 | date = November 2000 | publisher = UNICEF | url=http://www.unicef.org/immunization/files/MNTE_strategy_paper.pdf | access-date=2007-01-26 ]==] }, {

[==[ title=Population Estimates|url=http://www.census.gov/popest/data/cities/totals/2011/files/SUB-EST2011-IP.csv|publisher={{URL|1=http://en.wikipedia.org/wiki/United_States_Census_Bureau|2=United States Census Bureau}} ]==] }, {

[==[ title=The Structure of a Membrane|url=http://www.samuelfurse.com/2011/11/the-structure-of-a-membrane/|work=The Lipid Chronicles|access-date=2011-12-31]==] }, {

[==[ title=Unit of thermodynamic temperature (kelvin) |work=SI Brochure, 8th edition |pages=Section 2.1.1.5 |url=http://www1.bipm.org/en/si/si_brochure/chapter2/2-1/2-1-1/kelvin.html |publisher=Bureau International des Poids et Mesures |year=1967 |access-date=2008-02-06]==] }, {

[==[ url = http://pogoda.ru.net/climate/33345.htm | title = Weather and Climate - The Climate of Kiev | publisher = Weather and Climate (Погода и климат) | access-date = March 1, 2013 | language = Russian]==] }, {

[==[ url = http://www.lanl.gov/history/people/R_Schreiber.shtml |title = Raemer Schreiber |work = Staff Biographies |publisher = Los Alamos National Laboratory |location = Los Alamos (NM) |author = LANL contributors |access-date = November 16, 2008 ]==] }, {

[==[ url= http://berkleycenter.georgetown.edu/resources/countries/argentina |title=Argentina |publisher=[[Berkley Center for Religion, Peace, and World Affairs]]]==] }, {

[==[ url=http://213.253.134.43/oecd/pdfs/browseit/0406041E.PDF|format=PDF|title=Competitive Cities in the Global Economy|author=OECD|access-date=30 April 2009|author-link=Organisation for Economic Co-operation and Development]==] }, {

[==[ url=http://factfinder2.census.gov/bkmk/table/1.0/en/ACS/11_1YR/DP03/1600000US1714000| title=Selected Economic Characteristics: 2011 American Community Survey 1-Year Estimates (DP03): Chicago city, Illinois| publisher=U.S. Census Bureau, American Factfinder| access-date=February 8, 2013]==] }, {

[==[ url=http://liftoff.msfc.nasa.gov/academy/astronauts/training.html | archive-url=http://web.archive.org/web/20070910124735/http://liftoff.msfc.nasa.gov/academy/astronauts/training.html | archive-date=2007-09-10 | title=Selection and Training of Astronauts|access-date=October 4, 2007 |publisher=NASA|year=1995|author=NASA]==] }, {

[==[ url=http://quod.lib.umich.edu/cgi/t/text/text-idx?c=jii;view=text;rgn=main;idno=4750978.0016.105 |title =Environmental and Structural Inequalities in Greater Accra |access-date =22 July 2010|publisher =The Journal of the International Institute]==] }, {

[==[ url=http://users.rcn.com/jkimball.ma.ultranet/BiologyPages/T/Telomeres.html |author=John W. Kimball |date=November 25, 2008 |title=Telomeres]==] }, {

[==[ url=http://worldaerodata.com/wad.cgi?id=GH02526&sch=DGAA | title=Kotoka International Airport|publisher=World Aero Data|year=2009|access-date=29 October 2009]==] }, {

[==[ url=http://www.bbc.co.uk/wales/music/sites/big_weekend/ | title=BBC Wales – Big Weekend|access-date=23 February 2008]==] }, {

[==[ url=http://www.chem.umn.edu/class/2301/barany03f/fun/beautiful1.pdf |title=Chemistry at its Most Beautiful |access-date=2007-09-13|last=Freemantel|first=Michael |date=August 25, 2003|format=PDF |publisher=Chemical & Engineering News]==] }, {

[==[ url=http://www.dublincity.ie/RecreationandCulture/DublinCityParks/Pages/Facts%20About%20Our%20Parks.aspx |title=Dublin City Council – ''Facts About Our Parks'' |publisher=Dublincity.ie |date= |access-date=14 January 2012]==] }, {

[==[ url=http://www.fws.gov/news/NewsReleases/showNews.cfm?newsId=9191BAAD-F8E8-0097-B3670BDF3849EBF2|title=Fish and Wildlife Service Awards $800,000 in Grants to Explore Cause, Control of White-Nose Syndrome in Bats|date=2009-10-26|publisher=[[United States Fish and Wildlife Service]]|access-date=2009-10-30]==] }, {

[==[ url=http://www.guinnessworldrecords.com/content_pages/record.asp?recordid=51451 |publisher=[[Guinness World Records]] |title=Heaviest marine crustacean |access-date=August 3, 2006 |archive-url=http://web.archive.org/web/20060528192250/ |archive-date=May 28, 2006]==] }, {

[==[ url=http://www.hurriyetdailynews.com/default.aspx?pageid=438&n=new-card-alternative-to-akbil-raises-questions-2010-07-16|last=Songün|first=Sevim|work=Hürriyet Daily News|title=Istanbul Commuters Skeptical of Transit Change|date=16 July 2010|access-date=5 July 2012]==] }, {

[==[ url=http://www.lboro.ac.uk/gawc/world2008t.html |title=The World According to GaWC 2008 |work=Globalization and World Cities Research Network|publisher=GaWC Loughborough University |access-date=April 29, 2009]==] }, {

[==[ url=http://www.medicinenet.com/yaws/page4.htm|title=Yaws|access-date=5 August 2012|authors=Davis, Charles Patrick; Stoppler, Melissa Conrad|publisher=MedicineNet.com]==] }, {

[==[ url=http://www.autoblog.com/2010/03/29/hennessey-venom-gt-a-600k-mid-engine-cobra-for-the-21st-centur/ |title=Hennessey Venom GT: A $600k mid-engine Cobra for the 21st Century |access-date=2010-03-29 |last=Lavrinc |first=Damon |date=2010-03-29 |work=[[Autoblog.com|Autoblog]] |publisher=[[Weblogs, Inc.]] ]==] }

}, {nowiki=false, templatestyles=true})
end

function p:test_citation()
    self:preprocess_equals_preprocess_many('{{citation/new|', '}}', '{{citation|', '}}', { {
[==[
author  = AUTHOR
| last    = LAST
| first   = FIRST
| author2 = AUTHOR2
| last2   = LAST2
| first2  = FIRST2
| author-link  = AUTHOR-LINK
| author2-link = AUTHOR-LINK2
| author-mask = AUTHOR-MASK
| display-authors = et al
| editor        = EDITOR
| editor-last   = EDITOR-LAST
| editor-first  = EDITOR-FIRST
| editor2       = EDITOR2
| editor2-last  = EDITOR2-LAST
| editor2-first = EDITOR2-FIRST
| editor-link   = EDITOR-LINK
| editor2-link  = EDITOR2-LINK
| others   = OTHERS
| publication-date = PUBLICATION-DATE
| date     = DATE
| year     = YEAR
| origyear = ORIGYEAR
| title    = TITLE
| chapter  = CHAPTER
| chapter-url  = https://en.wikipedia.org/Main_Page#top
| contribution = CONTRIBUTION
| contribution-url = CONTRIBUTON-URL
| type    = TYPE
| journal = JOURNAL
| periodical = PERIODICAL
| newspaper  = NEWSPAPER
| magazine   = MAGAZINE
| work = WORK
| edition = EDITION
| series  = SERIES
| volume  = VOLUME
| issue   = ISSUE
| publisher = PUBLISHER
| publication-place = PUBLICATION-PLACE
| place    = PLACE
| language = LANGUAGE
| page  = PAGE
| pages = PAGES
| nopp  = NOPP
| at   = AT
| id   = ID
| isbn = ISBN
| issn = ISSN
| oclc = OCLC
| pmid = PMID
| pmc  = PMC
| bibcode = BIBCODE
| doi = 10.DOI
| doi-inactive-date = 10 June 2015
| url = https://en.wikipedia.org/Main_Page
| access-date  = access-date
| format      = FORMAT
| archive-url  = https://web.archive.org/web/20190310131346/https://en.wikipedia.org/wiki/Main_Page
| archive-date = January 1, 2010
| quote      = QUOTE
| lay-url = https://en.wikipedia.org/Wikipedia
| lay-source  = LAYSOURCE
| lay-date    = 2010-01-01
| postscript =
| ref = REF
| no-tracking = true
]==] }, {

[==[  author=Anonymous|editor=Daniel Coit Gilman, Harry Thurston Peck, Frank Moore Colby |year=1904|title=The New International Encyclopædia |publisher=Dodd, Mead and Company|page=906
]==] }, {

[==[  pages=1328–1334|title=Linus Pauling: Selected Scientific Papers|volume=2|editor=Pauling, Linus; Kamb, Barclay |place=River Edge, New Jersey|publisher=World Scientific |year=2001|isbn=981-02-2940-2|url=http://books.google.com/?id=2QduA19d_X8C&pg=PA1329
]==] }, {

[==[  title=Soedirman: Bapak Tentara Indonesia |trans-title=Soedirman: Father of the Indonesian Military |language=Indonesian |last=Adi |first=A. Kresna |publisher=Mata Padi Pressindo |isbn=978-602-95337-1-2 |location=Yogyakarta |year=2011
]==] }, {

[==[  url=http://books.google.ca/books?id=WrkzPcxBnLMC |title=Takhta untuk Rakyat: Celah-celah Kehidupan Sultan Hamengku Buwono IX |trans-title=Serving the People: The Life Story of Sultan Hamengku Buwono IX |language=Indonesian |isbn=978-979-22-6767-9 |editor1-first=Mohamad |editor1-last=Roem |editor1-link=Mohamad Roem |editor2-first=Mochtar |editor2-last=Lubis |editor2-link=Mochtar Lubis |editor3-first=Kustiniyati |editor3-last=Mochtar |editor4-first=Maimoen |editor4-last=S. |last=Nasution |first=A. H. |author-link=Abdul Haris Nasution |publisher=Gramedia Pustaka Utama |location=Jakarta |year=2011 |origyear=1982 |edition=Revised 
| no-tracking=true]==] }, {

[==[  author=Luhmann J. G., Russell C. T. |editor=J. H. Shirley and R. W. Fainbridge |title=Venus: Magnetic Field and Magnetosphere |work=Encyclopedia of Planetary Sciences |publisher=Chapman and Hall, New York|year=1997 |url=http://www-spc.igpp.ucla.edu/personnel/russell/papers/venus_mag/ |access-date=2009-06-28|isbn=978-1-4020-4520-2
]==] }, {

[==[  author=Feldman, M. S.; Ferrara, L. A.; Havenstein, P. L.; Volonte, J. E.; Whipple, P. H. |title=Manned Venus Flyby, February 1, 1967 |publisher=Bellcomm, Inc |url=http://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19790072165_1979072165.pdf |format=PDF|year=1967
]==] }, {

[==[  last=Rose |first=Herbert Jennings |author-link=H.J. Rose |title=A Handbook of Greek Mythology |edition=1st |year=1959 |publisher=E.P. Dutton & Co. |location=New York |language= |isbn=0-525-47041-7 |pages=173
]==] }, {

[==[  url=http://www.ethnologue.com/show_country.asp?name=AR|title=Languages of Argentina|work=Ethnologue: Languages of the World|edition=16th|editor=Lewis, M. Paul|publisher=SIL International|place=Dallas|year=2009
]==] }, {

[==[  editor=Jean Chrétien Ferdinand Hoefer |contribution=Labarraque, Antoine-Germain |title=Nouvelle biographie universelle |volume=28 |pages=323–324 |ol=24229911M 
]==] }, {

[==[  author=Herbst, T. M.; Rix, H.-W.|year=1999 |editor=Guenther, Eike; Stecklum, Bringfried; Klose, Sylvio|title=Star Formation and Extrasolar Planet Studies with Near-Infrared Interferometry on the LBT |book-title=Optical and Infrared Spectroscopy of Circumstellar Matter, ASP Conference Series, Vol. 188. |isbn=1-58381-014-5|pages=341–350 |bibcode=1999ASPC..188..341H |publisher=Astronomical Society of the Pacific |location=San Francisco, Calif.
]==] }, {

[==[  date=4 June 2007|title=The List of Wetlands of International Importance | publisher=The Secretariat of the Convention on Wetlands | page=18 | url=http://www.ramsar.org/sitelist.pdf | access-date=20 June 2007 | format=PDF | archive-url=http://web.archive.org/web/20070621011113/http://www.ramsar.org/sitelist.pdf | archive-date=21 June 2007
]==] }, {

[==[  last=Schmidt|first=Hans-Peter|chapter=Mithra i: Mithra in Old Indian and Mithra in Old Iranian|year=2006|title=Encyclopædia Iranica|volume=OT 10|location=New York|publisher=iranica.com|url=http://www.iranicaonline.org/articles/mithra-i|format=
]==] }, {

[==[  last1=Canard |first1=M. |editor1-first=P. |editor1-last=Bearman |editor2-first=Th. |editor2-last=Bianquis |editor3-first=C.E. |editor3-last=Bosworth |editor4-first=E. |editor4-last=van Donzel |editor5-first=W.P. |editor5-last=Heinrichs |editor3-link=Clifford Edmund Bosworth |title=Encyclopaedia of Islam, Second Edition |year=2011 |publisher=Brill Online |location=Leiden |chapter=al-ḎJazīra, Ḏjazīrat Aḳūr or Iḳlīm Aḳūr |oclc=624382576
]==] }, {

[==[  last=Block|first=Steven M.|title=The growing threat of biological weapons|url=http://www.americanscientist.org/issues/feature/the-growing-threat-of-biological-weapons|access-date=2009-05-22|volume=89:1|year=2001|publisher=American Scientist|doi=10.1511/2001.1.28|journal=American Scientist|page=28]==] }, {

[==[  year=2011|title=Human Development Report 2011|chapter=Table 1: Human Development Index and its Components|publisher=[[United Nations]]|chapter-url=http://hdr.undp.org/en/media/HDR_2011_EN_Table1.pdf|format=PDF|ref=]==] }, {

[==[  author=Bhagavan NV|title=Medical Biochemistry |publisher=Harcourt/Academic Press |location=San Diego |year=2002 |isbn=0-12-095440-0|url=http://books.google.com/?id=vT9YttFTPi0C&printsec=frontcover]==] }, {

[==[  author=Motilal (UK) Books of India|title=Tourist Guide Kerala|url=http://books.google.com/books?id=ZYfRBcLdTNYC&pg=PA11|access-date=18 November 2012|date=1 February 2008|publisher=Sura Books|isbn=978-81-7478-164-2|page=11]==] }, {

[==[  author1=Joseph Needham|author2=Gwei-Djen Lu|author3=Ling Wang|title=Science and civilisation in China, Volume 5, Part 7|year=1987|publisher=Cambridge University Press|isbn=978-0-521-30358-3|pages=48–50]==] }, {

[==[  chapter=Naturalism and Physicalism | last=Fales | postscript=, | first=Evan ]==] }, {

[==[  date=5 October 2009|title=India, Russia Review Defence Ties|publisher=[[The Hindu]]|url=http://www.thehindu.com/news/national/article2514142.ece|access-date=8 October 2011]==] }, {

[==[  first=Elena|last=Aprile|author2=Bolotnikov, Aleksey E. |author3=Doke, Tadayoshi |title=Noble Gas Detectors|publisher=Wiley-VCH|year=2006 |isbn=3-527-60963-6|url=http://books.google.com/?id=tsnHM8x6cHAC&pg=PT1|pages=8–9]==] }, {

[==[  first=Maurice | last=Loir | title=L'escadre de l'amiral Courbet | location=Paris | publisher=Berger-Levrault | year=1886 | postscript=. ]==] }, {

[==[  last = Bennett | first = Ralph | title = Behind the Battle: Intelligence in the War with Germany | place = London | publisher = Random House | origyear = 1994 | year = 1999 | edition = Pimlico: New and Enlarged | isbn = 0-7126-6521-8 ]==] }, {

[==[  last = Hunt | first = David | author-link = David Hunt (diplomat) | title = The raid on Coventry | newspaper = The Times | pages = 11 | date = 28 August 1976 ]==] }, {

[==[  last = Rhodes |first = Richard |year = 1986 |title = The Making of the Atomic Bomb |isbn = 0-671-65719-4 |pages = 659–660 |publisher = Simon & Schuster |location = New York]==] }, {

[==[  last = Watt | first = William Montgomery |author-link = William Montgomery Watt| title = [[Muhammad at Mecca (book)|Muhammad at Mecca]]| publisher=Oxford University Press | year = 1953 | id =]==] }, {

[==[  last=Cooper |first=J.C. |title=Symbolic and Mythological Animals |pages=25–26 |year=1992 |publisher=Aquarian Press |location=London |isbn=1-85538-118-4]==] }, {

[==[  last=Horton|first=Michael|author-link=Michael Horton (theologian)|title=For Calvinism|url=http://books.google.com/books?id=ezoDtwAACAAJ|access-date=17 January 2013|date=18 October 2011|publisher=Zondervan Books|isbn=978-0-310-32465-2|page=15]==] }, {

[==[  last=Jacobs|first=Bruno|chapter=Mithra|title=Iconography of Deities and Demons in the Ancient Near East|series=(Electronic Pre-Publication)|location=Leiden|publisher=U Zürich/Brill| year=2006|url=http://www.religionswissenschaft.unizh.ch/idd/prepublications/e_idd_mithra.pdf Iconography of Mithra]==] }, {

[==[  last=Malandra|first=William|year=1983|isbn=0-8166-1115-7|title=An Introduction to Ancient Iranian Religion|location=Minneapolis|publisher=University of Minnesota Press]==] }, {

[==[  last=Metzner|first =Paul|year=1998|title=Crescendo of the Virtuoso: Spectacle, Skill, and Self-Promotion in Paris during the Age of Revolution|publisher=University of California Press]==] }, {

[==[  last=Raichlen|first=S.|date=10 May 2011|title=A Tandoor Oven Brings India's Heat to the Backyard|publisher=The New York Times|url=http://www.nytimes.com/2011/05/11/dining/a-tandoor-oven-brings-indias-heat-to-the-backyard.html|access-date=14 June 2011]==] }, {

[==[  last=Sripati|first=V.|year=1998|title=Toward Fifty Years of Constitutionalism and Fundamental Rights in India: Looking Back to See Ahead (1950–2000)|journal=American University International Law Review|volume=14|issue=2|pages=413–496]==] }, {

[==[  last1=Ali|first1=J. R.|last2=Aitchison|first2=J. C.|year=2005|title=Greater India|journal=Earth-Science Reviews|volume=72|issue=3–4|pages=170–173|doi=10.1016/j.earscirev.2005.07.005]==] }, {

[==[  last1=Eitzen|first1=E.|last2=Takafuji|first2=E.|title=Military Medicine: Medical Aspects of Chemical and Biological Warfare|url=|year=1997|publisher=Office of the Surgeon General, Department of the Army|chapter=Historical Overview of Biological Warfare]==] }, {

[==[  last1=Heitzman|first1=J.|last2=Worden|first2=R. L.|date=August 1996|title=India: A Country Study|series=Area Handbook Series|publisher=[[Library of Congress]]|place=Washington, D.C.|isbn=978-0-8444-0833-0]==] }, {

[==[  last1=Masters|first1=Bruce Alan|last2=Ágoston|first2=Gábor|year=2009|title=Encyclopedia of the Ottoman Empire|publisher=Infobase Publishing|location=New York|isbn=978-1-4381-1025-7]==] }, {

[==[  url=http://books.google.ca/books?id=LjzZ_rVv_2MC&pg=PA30 |title=Villes et organisation de l'espace en Afrique |pages=30–31 |first1=Jérôme |last1=Aloko-N'Guessan |first2=Amadou |last2=Diallo |first3=Kokou Henri |last3=Motcho |publisher=KARTHALA Editions |year=2010 |ISBN=2-8111-0339-2]==] }, {

[==[  title = Statics: Analysis and Design of Systems in Equilibrium | last = Sheppard and Tongue | publisher = Wiley and Sons | year = 2005 | page = 618 | quote = In general, for given contacting surfaces, ''μ''<sub>k</sub> < ''μ''<sub>s</sub> | isbn = 0-471-37299-4]==] }, {

[==[  title=Ancient Egyptian Rhetoric in the Old and Middle Kingdoms|author=David Hutto‌|journal=[[Rhetorica]]|date=Summer 2002|volume=20|issue=3|publisher=[[University of California Press]]|pages=213–233|doi=10.1525/rh.2002.20.3.213]==] }, {

[==[  title=Civilizations of ancient Iraq |last1=Foster |first1=Benjamin R. |last2=Polinger Foster |first2=Karen |year=2009 |publisher=Princeton University Press |location=Princeton |isbn=978-0-691-13722-3 ]==] }, {

[==[  title=India | publisher=[[International Monetary Fund]] | url=http://www.imf.org/external/pubs/ft/weo/2011/02/weodata/weorept.aspx? | access-date=14 October 2011]==] }, {

[==[  title=New Interstellar Boundary Explorer data show heliosphere's long-theorized bow shock does not exist | date=May 10, 2012 | work=Phys.org | url=http://phys.org/news/2012-05-interstellar-boundary-explorer-heliosphere-long-theorized.html | access-date=2012-02-11 ]==] }, {

[==[  title=The European Flag|publisher=[[Europa (web portal)]]|url=http://europa.eu/abc/symbols/emblem/index_en.htm|access-date=4 August 2007]==] }, {

[==[  url = http://english.president.go.kr/tours/place_buildings/main_office.php | title = Cheong Wa Dae / The Blue House | quote = The Main Building and its two annexes are covered with a total of 150,000 traditional Korean blue roof tiles (hence, the name "Blue House" is also commonly used when referring to Cheongwadae). ]==] }, {

[==[  url=https://www.regione.sardegna.it/j/v/86?v=9&c=72&s=1&file=1997026 |title=Legge Regionale 15 ottobre 1997, n. 26 |year=1997 |publisher=Regione Sardegna |access-date=]==] },  {

[==[  title = Studies on Archaic Chinese
  | last = Li | first = Fang-Kuei | author-link = Li Fang-Kuei
  | others = Gilbert L. Mattos (trans.)
  | journal = Monumenta Serica | volume = 31 | year = 1974–75
  | pages = 219–287
  | postscript = .
]==] }, { [==[
    title = Studies on Archaic Chinese
  | last = Li | first = Fang-Kuei | author-link = Li Fang-Kuei
  | others = Gilbert L. Mattos (trans.)
  | journal = Monumenta Serica | volume = 31 | year = 1974–1975
  | pages = 219–287
  | postscript = .
]==] } }, {nowiki=false, templatestyles=true})
end

return p
