local p = require('Module:UnitTests')
local Text = require('Module:Text').Text()
local TextSandbox = require('Module:Text/sandbox').Text()

-- Tests re-written in Lua from  https://de.wikipedia.org/wiki/Wikipedia:Lua/Modul/Text/Test version 198988523

function p:charTester(m,o)
	self:equals('',o.char(),'')
	self:equals('<code>{65,104,97}</code>',o.char({65,104,97}),'Aha')
	self:equals('<code>{"65",104,97}</code>',o.char({"65",104,97}),'Aha')
	self:equals('<code>{98,108,97},2</code>',o.char({98,108,97},2),'blabla')
	self:equals('<code>{"something"}</code>',mw.ustring.match(o.char({'something'}),"error"),"error")
	self:equals('<code>"something",1,true</code>',o.char('something',1,true),'')
	self:equals('<code>{7,8,9}</code>',mw.ustring.match(Text.char({7,8,9}),"error"),"error")
    self:preprocess_equals_many('{{#invoke:'..m..'|char|','}}', {
        {'65 104 97', 'Aha'},
        {'98 108 97|*=2', 'blabla'},
        {'something|errors=0', ''} })
end

function p:testChar()
    self:charTester('Text',Text)
end

function p:testCharSandbox()
    self:charTester('Text/sandbox',TextSandbox)
end

function p:concatParamsTester(m,o)
	self:equals('',o.concatParams(),'')
	self:equals('<code>{}</code>',o.concatParams({}),'')
	self:equals('<code>A</code>',o.concatParams('A'),'A')
	self:equals('<code>{"A"}</code>',o.concatParams({'A'}),'A')
	self:equals('<code>{"A","B","C"}</code>',o.concatParams({'A','B','C'}),'A|B|C',{nowiki=1})
	self:equals('<code>{"A","B","C"},"-"</code>',o.concatParams({'A','B','C'},'-'),'A-B-C')
	self:equals('<code>{"1","2","3"},nil,"%.2f"</code>',o.concatParams({'1','2','3'},nil,'%.2f'),'1.00|2.00|3.00',{nowiki=1})
	self:preprocess_equals('{{#invoke:'..m..'|concatParams|1|2|3|separator=:|format=%.2f}}',
		'1.00:2.00:3.00')
end

function p:testConcatParams()
    self:concatParamsTester('Text',Text)
end

function p:testConcatParamsSandbox()
    self:concatParamsTester('Text/sandbox',TextSandbox)
end

function p:listToTextTester(m,o)
	self:equals('',o.listToText(),'')
	self:equals('<code>{}</code>',o.listToText({}),'')
	self:equals('<code>A</code>',o.listToText('A'),'A')
	self:equals('<code>{"A"}</code>',o.listToText({'A'}),'A')
	self:equals('<code>{"A","B","C"}</code>',o.listToText({'A','B','C'}),'A, B và C')
	self:equals('<code>{"1","2","3"},"%.2f"</code>',o.listToText({'1','2','3'},'%.2f'),'1.00, 2.00 và 3.00')
	self:preprocess_equals('{{#invoke:'..m..'|listToText|1|2|3|format=%.2f}}',
		'1.00, 2.00 và 3.00')
end

function p:testListToText()
    self:listToTextTester('Text',Text)
end

function p:testListToTextSandbox()
    self:listToTextTester('Text/sandbox', TextSandbox)
end

function p:containsCJKTester(o)
	local function singleTest(arg, expected)
		self:equals('<code>'..arg..'</code>',o.containsCJK(arg),expected)
	end
	self:equals('',o.containsCJK(),false)
	singleTest('Draco Dormiens Nunquam Titillandus',false)
	singleTest('Никогда не щекочи спящего дракона',false)
	singleTest('सोए शेर को न जगाओ',false)
	singleTest('永远不要惊醒卧龙',true)
	singleTest('眠っているドラゴンをくすぐることはありません',true)
	singleTest('잠자는 용을 간지럽히지 마십시오',true)
end

function p:testContainsCJK()
    self:containsCJKTester(Text)
end

function p:testContainsCJKSandbox()
    self:containsCJKTester(TextSandbox)
end

function p:getPlainTester(o)
	local function singleTest(arg, expected)
		self:equals('<code><nowiki>'..arg..'</nowiki></code>',
			o.getPlain(arg),expected)
	end
	singleTest('a and b','a and b')
	singleTest('a<!--comment-->b','ab')
	singleTest(' <!--comment-->hello, world<!--comment 2--> ',' hello, world ')
	singleTest('a <nowiki>b</nowiki> c','a b c')
	singleTest("'''a'''","a")
	singleTest("''b''","b")
	singleTest("'''a''' and ''b''","a and b")
	singleTest("a&nbsp;and&nbsp;b","a and b")
	singleTest("'''a'' and '''b''","a and b")
    singleTest("a<!--I am an unclosed comment","a")
	singleTest("'''unclosed bold","unclosed bold")
	singleTest("<!-- hello -- -->'''a'''&nbsp;<!--world-->''<nowiki>b</nowiki>''","a b")
	singleTest("<b>a</b>&nbsp;'''b'''<!-- hello -- world -->,&nbsp;<div style='font-size:100%;'>c</div>","a b, c")
end

function p:testGetPlain()
    self:getPlainTester(Text)
end

function p:testGetPlainSandbox()
    self:getPlainTester(TextSandbox)
end

function p:removeDelimitedTester(o)
	self:equals('comment',o.removeDelimited('a<!--comment-->b','<!--','-->'),'ab')
	self:equals('2 comments',o.removeDelimited(' <!--comment-->hello, world<!--comment 2--> ','<!--','-->'),' hello, world ')
	self:equals('ref',o.removeDelimited('in foo.<ref name=foo>{{cite web|title=Title|url=https://www.example.com}}</ref>','<ref','</ref>'),'in foo.')
end

function p:testRemoveDelimited()
    self:removeDelimitedTester(Text)
end

function p:testRemoveDelimitedSandbox()
    self:removeDelimitedTester(TextSandbox)
end

function p:isLatinTester(o)
	local function singleTest(arg,expected)
		self:equals('<code>'..arg..'</code>',o.isLatinRange(arg),expected)
	end
	self:equals('',o.isLatinRange(),true)
	singleTest('abcd',true)
	singleTest('Ça ira',true)
	singleTest('α – Ω',false)
	singleTest('a日本d',false)
end

function p:testIsLatin()
    self:isLatinTester(Text)
end

function p:testIsLatinSandbox()
    self:isLatinTester(TextSandbox)
end

function p:isQuoteTester(o)
	local function singleTest(arg,expected)
		self:equals('<code>'..arg..'</code>',o.isQuote(arg),expected)
	end
	self:equals('',o.isQuote(),false)
	singleTest('"',true)
	singleTest('日',false)
	singleTest('abc"',false)
end

function p:testIsQuote()
    self:isQuoteTester(Text)
end

function p:testIsQuoteSandbox()
    self:isQuoteTester(TextSandbox)
end

function p:quoteTester(o)
	self:equals('',o.quote(),'“”')
	self:equals('<code>abcd</code>',o.quote('abcd'),'“abcd”')
	self:equals('<code>"abcd"</code>',o.quote('"abcd"'),'“"abcd"”')
	self:equals('fr',o.quote('abcd','fr'),'«&#160;abcd&#160;»')
	self:equals('fr2',o.quote('abcd','fr',2),'‹&#160;abcd&#160;›')
end

function p:testQuote()
    self:quoteTester(Text)
end

function p:testQuoteSandbox()
    self:quoteTester(TextSandbox)
end

function p:quoteUnquotedTester(o)
	self:equals('',o.quoteUnquoted(),'')
	self:equals('<code>abcd</code>',o.quoteUnquoted('abcd'),'“abcd”')
	self:equals('<code>"abcd"</code>',o.quoteUnquoted('"abcd"'),'"abcd"')
	self:equals('fr',o.quoteUnquoted('abcd','fr'),'«&#160;abcd&#160;»')
	self:equals('fr2',o.quoteUnquoted('abcd','fr',2),'‹&#160;abcd&#160;›')
end

function p:testQuoteUnquoted()
    self:quoteUnquotedTester(Text)
end

function p:testQuoteUnquotedSandbox()
    self:quoteUnquotedTester(TextSandbox)
end

function p:removeDiacriticsTester(o)
	local function singleTest(arg,expected)
		self:equals('<code>'..arg..'</code>',o.removeDiacritics(arg),expected)
	end
	self:equals('',o.removeDiacritics(),'')
	singleTest('abcd','abcd')
	singleTest('âbçdé','abcde')
	singleTest('a日本d','a日本d')
end

function p:testRemoveDiacritics()
    self:removeDiacriticsTester(Text)
end

function p:testRemoveDiacriticsSandbox()
    self:removeDiacriticsTester(TextSandbox)
end

function p:sentenceTerminatedTester(o)
	local function singleTest(arg,expected)
		self:equals('<code><nowiki>'..arg..'</nowiki></code>',
			o.sentenceTerminated(arg),expected)
	end
	singleTest('Hello',false)
	singleTest('(Hello)',false)
	singleTest('Hello.',true)
	singleTest('„Deutsche“',false)
	singleTest('„Deutsche?“',true)
	singleTest('"English?"',true)
	singleTest('[[Hello!]]',true)
end

function p:testSentenceTerminated()
    self:sentenceTerminatedTester(Text)
end

function p:testSentenceTerminatedSandbox()
    self:sentenceTerminatedTester(TextSandbox)
end

function p:ucFirstAllTester(o)
	local function singleTest(arg,expected)
		self:equals('<code>'..tostring(arg)..'</code>',o.ucfirstAll(arg),expected)
	end
	self:equals('',o.ucfirstAll(),'')
	singleTest(25,'25')
	singleTest('Help test me','Help Test Me')
	singleTest('an der Schönen','An Der Schönen')
	singleTest('an der Schönen &lauen','An Der Schönen &Lauen')
	self:equals('HTML ndash',o.ucfirstAll('an der Schönen &lauen donau &ndash; X y z'),
		'An Der Schönen &amp;Lauen Donau '..mw.text.decode('&ndash;',true)..' X Y Z')
	self:equals('HTML nbsp',o.ucfirstAll('a&nbsp;b'),'A&nbsp;B')
	self:equals('many HTML',o.ucfirstAll("&amp;&lt;&gt;&nbsp;&#8201;&#8204;&#8205;&#8206;&#8207;"),
		'&amp;&lt;&gt;&nbsp;'..mw.text.decode("&#8201;&#8204;&#8205;&#8206;&#8207;"))
end

function p:testUCFirstAll()
    self:ucFirstAllTester(Text)
end

function p:testUCFirstAllSandbox()
    self:ucFirstAllTester(TextSandbox)
end


function p:uprightNonLatin(o)
	local function singleTest(arg,expected)
		self:equals('<code>'..arg..'</code>',o.uprightNonlatin(arg),expected,{nowiki=1})
	end
	singleTest('abc','abc')
	singleTest('abc ','abc ')
	singleTest('Musṭafah','Musṭafah')
	singleTest('μm','μm')
    singleTest('1 α-particle','1 α-particle')
	singleTest('Method 3α','Method 3α')
	singleTest('ΣΨΩ',"<span dir='auto' style='font-style:normal'>ΣΨΩ</span>")
    singleTest('abcΣΨΩxyz',
		"abc<span dir='auto' style='font-style:normal'>ΣΨΩ</span>xyz")
	singleTest('abЩyz',"ab<span dir='auto' style='font-style:normal'>Щ</span>yz")
	singleTest('Войната 1915 година. Втора Македония',
		"<span dir='auto' style='font-style:normal'>Войната 1915 година. Втора Македония</span>")
	singleTest('a日本d',"a<span dir='auto' style='font-style:normal'>日本</span>d")
end

function p:testUprightNonLatin()
    self:uprightNonLatin(Text)
end

function p:testUprightNonLatinSandbox()
    self:uprightNonLatin(TextSandbox)
end

function p:exportTester(m)
    self:preprocess_equals_many('{{#invoke:'..m..'|','}}', {
	  {'containsCJK|a',""},
	  {'containsCJK|日',"1"},
	  {'isLatinRange|日',""},
	  {'isLatinRange|a',"1"},
	  {'isQuote|日',""},
	  {'isQuote|„',"1"},
	  {'sentenceTerminated|日',""},
	  {'sentenceTerminated|a.',"1"},
	  {'getPlain|a',"a"},
	  {'removeDiacritics|a',"a"},
	  {'ucfirstAll|a',"A"},
	  {'uprightNonlatin|a',"a"}}
    )
end

function p:testExport()
    self:exportTester('Text')
end

function p:testExportSandbox()
    self:exportTester('Text/sandbox')
end

function p:splitTester(m,o)
	self:equals_deep('"?a?b?c?d?e?f?", "c"', o.split("?a?b?c?d?e?f?", "c"), mw.text.split("?a?b?c?d?e?f?", "c"))
	self:equals_deep('"?a?b?c?d?e?f?", "?"', o.split("?a?b?c?d?e?f?", "?"), mw.text.split("?a?b?c?d?e?f?", "?"))
	self:equals_deep('"?a?b?c?d?e?f?", ""', o.split("?a?b?c?d?e?f?", ""), mw.text.split("?a?b?c?d?e?f?", ""))
	self:equals_deep('"?a?b?c?d?e?f?", "z"', o.split("?a?b?c?d?e?f?", "z"), mw.text.split("?a?b?c?d?e?f?", "z"))
	self:equals_deep('"?a?b?c?d?e?f?", "[bdf]"', o.split("?a?b?c?d?e?f?", "[bdf]"), mw.text.split("?a?b?c?d?e?f?", "[bdf]"))
	self:equals_deep('"?a?b?c?d?e?f?", "[bdf]", true', o.split("?a?b?c?d?e?f?", "[bdf]", true), mw.text.split("?a?b?c?d?e?f?", "[bdf]", true))
	self:preprocess_equals_many('{{#invoke:'..m..'|split|?a?b?c?|','}}', {
		{'c', mw.text.split("?a?b?c?", "c")[1]},
		{'?', mw.text.split("?a?b?c?", "?")[1]},
		{'?|false|2', mw.text.split("?a?b?c?", "?")[2]},
		{'?|false|-2', mw.text.split("?a?b?c?", "?")[#mw.text.split("?a?b?c?", "?") - 2 + 1]},
		{'|false|2', mw.text.split("?a?b?c?", "")[2]},
		{'z', mw.text.split("?a?b?c?", "z")[1]},
		{'[bc]', mw.text.split("?a?b?c?", "[bc]")[1]},
		{'[bc]|true', mw.text.split("?a?b?c?", "[bc]", true)[1]},
	})
end

function p:testSplit()
    self:splitTester('Text',Text)
end

function p:testSplitSandbox()
    self:splitTester('Text/sandbox',TextSandbox)
end

function p:zipTester(m)
    self:preprocess_equals('{{#invoke:'..m..'|zip|a,b,c|1,2,3|sep=,|isep=-|osep=/}}',"a-1/b-2/c-3")
    self:preprocess_equals('{{#invoke:'..m..'|zip|a b  c|x y z|1 2 3|sep=%s+|isep=-|osep=/}}',"a-x-1/b-y-2/c-z-3")
end

function p:testZip()
    self:zipTester('Text')
end

function p:testZipSandbox()
    self:zipTester('Text/sandbox')
end

return p