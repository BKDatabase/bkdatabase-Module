local T = require('Module:Transcluder/sandbox')
local ScribuntoUnit = require('Module:ScribuntoUnit')
local Suite = ScribuntoUnit:new()

function Suite:testCategories()
	self:assertThrows( function() T.getCategories() end )
	self:assertThrows( function() T.getCategories({}) end )
	self:assertThrows( function() T.getCategories(false) end )

	self:assertDeepEquals( {}, T.getCategories('') )
	self:assertDeepEquals( {}, T.getCategories('a') )
	self:assertDeepEquals( {'[[Category:X1]]'}, T.getCategories('[[Category:X1]]') )
	self:assertDeepEquals( {'[[Category:X1|]]'}, T.getCategories('[[Category:X1|]]') )
	self:assertDeepEquals( {'[[Category:X1| ]]'}, T.getCategories('[[Category:X1| ]]') )
	self:assertDeepEquals( {'[[Category:X1|X2]]'}, T.getCategories('[[Category:X1|X2]]') )
	self:assertDeepEquals( {'[[Category:X1]]','[[Category:X2]]'}, T.getCategories('[[Category:X1]][[Category:X2]]') )
	self:assertDeepEquals( {'[[Category:X1]]','[[Category:X2]]'}, T.getCategories('\n[[Category:X1]]\n[[Category:X2]]\nc') )
	self:assertDeepEquals( {}, T.getCategories('[[Category:X1]]', 0) )
	self:assertDeepEquals( {'[[Category:X2]]'}, T.getCategories('[[Category:X1]][[Category:X2]]', 2 ) )
	self:assertDeepEquals( {'[[Category:X2]]','[[Category:X3]]'}, T.getCategories('[[Category:X1]][[Category:X2]][[Category:X3]]', '2-3') )
	self:assertDeepEquals( {'[[Category:X2]]'}, T.getCategories('[[Category:X1]][[Category:X2]][[Category:X3]]', 'X2') )
	self:assertDeepEquals( {'[[Category:X1]]','[[Category:X3]]'}, T.getCategories('[[Category:X1]][[Category:X2]][[Category:X3]]', '-X2') )

	self:assertEquals( '[[Category:X1]]', T.get('Module:Transcluder/testpage#Categories', { categories = 1 } ) )
	self:assertEquals( '[[Category:X2]]', T.get('Module:Transcluder/testpage#Categories', { categories = 2 } ) )
	self:assertEquals( '[[Category:X1]]\n\n[[Category:X3]]', T.get('Module:Transcluder/testpage#Categories', { categories = '-X2' } ) )
end

function Suite:testErrors()
	self:assertThrows( function() T.get() end, 'No page given' )
	self:assertThrows( function() T.get('') end, 'No page given' )
	self:assertThrows( function() T.get(' ') end, 'No page given' )
	self:assertThrows( function() T.get('2 > 1') end, 'Title «2 > 1» is not valid' )
	self:assertThrows( function() T.get('Non-existent page') end, "Page 'Non-existent page' not found" )
	self:assertThrows( function() T.get('Module:Transcluder/testpage#Non-existent section') end, "Section 'Non-existent section' not found" )
end

function Suite:testFiles()
	self:assertThrows( function() T.getFiles() end )
	self:assertThrows( function() T.getFiles({}) end )
	self:assertThrows( function() T.getFiles(false) end )

	self:assertDeepEquals( {}, T.getFiles('') )
	self:assertDeepEquals( {}, T.getFiles('a') )
	self:assertDeepEquals( {'[[File:A.png]]'}, T.getFiles('[[File:A.png]]') )
	self:assertDeepEquals( {'[[Image:A.png]]'}, T.getFiles('[[Image:A.png]]') )
	self:assertDeepEquals( {'[[File:A.png]]','[[File:B.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]]') )
	self:assertDeepEquals( {'[[File:A.png]]','[[File:B.png]]'}, T.getFiles('\n[[File:A.png]]\n[[File:B.png]]\nc') )
	self:assertDeepEquals( {}, T.getFiles('[[File:A.png]]', 0 ) )
	self:assertDeepEquals( {'[[File:B.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]]', 2 ) )
	self:assertDeepEquals( {'[[File:A.png]]','[[File:C.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', '-2' ) )
	self:assertDeepEquals( {'[[File:B.png]]','[[File:C.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', '2-3') )
	self:assertDeepEquals( {'[[File:A.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', 'A.png') )
	self:assertDeepEquals( {'[[File:B.png]]','[[File:C.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', '-A.png') )
	self:assertDeepEquals( {'[[File:A.png]]','[[File:C.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', 'A.png, C.png') )
	self:assertDeepEquals( {'[[File:B.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', '-A.png, C.png') )

	self:assertDeepEquals( {'[[File:B.png]]','[[File:C.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', -1 ) )
	self:assertDeepEquals( {'[[File:A.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', '-2-3' ) )
	self:assertDeepEquals( {'[[File:A.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', { [1] = true } ) )
	self:assertDeepEquals( {'[[File:B.png]]','[[File:C.png]]'}, T.getFiles('[[File:A.png]][[File:B.png]][[File:C.png]]', { [1] = false } ) )

	self:assertEquals( '[[File:A.png]]ab', T.get('Module:Transcluder/testpage#Files', { files = 1 } ) )
	self:assertEquals( 'a[[File:C.png]]b', T.get('Module:Transcluder/testpage#Files', { files = 2 } ) )
end

function Suite:testGet()
	self:assertEquals( '[[File:A.png]]\nb\n*c\n*d\n{|\n|e\n|}\n[[File:f.png]]\ng\n#h\n#i\nj\n{|\n|k\n|}\nl', T.get('Module:Transcluder/testpage#Get') )
	self:assertEquals( 'b\n\n[[File:f.png]]\ng\n#h\n#i\nj\n{|\n|k\n|}\nl', T.get('Module:Transcluder/testpage#Get', { files = 2, tables = 2, lists = 2 } ) )
	self:assertEquals( 'test', T.get('Module:Transcluder/testpage2') )
end

function Suite:testInclude()
	self:assertEquals( 'ac', T.get('Module:Transcluder/testpage#Include') )
end

function Suite:testLead()
	self:assertEquals( "This '''test page''' interacts with [[Module:Transcluder/testcases]].", T.get('Module:Transcluder/testpage#') )
	self:assertEquals( 'This test page interacts with [[Module:Transcluder/testcases]].', T.get('Module:Transcluder/testpage#', { noBold = true } ) )
end

function Suite:testLinks()
	self:assertEquals( 'a b c d e', T.get('Module:Transcluder/testpage#Links', { noLinks = true } ) )
end

function Suite:testLists()
	self:assertDeepEquals( {}, T.getLists('') )
	self:assertDeepEquals( {}, T.getLists('a') )
	self:assertDeepEquals( {'*a\n*b'}, T.getLists('*a\n*b') )
	self:assertDeepEquals( {'*b\n*c'}, T.getLists('a\n*b\n*c\nd') )
	self:assertDeepEquals( {'*b\n*c','#e\n#f'}, T.getLists('a\n*b\n*c\nd\n#e\n#f\ng') )
	self:assertDeepEquals( {'#e\n#f'}, T.getLists('a\n*b\n*c\nd\n#e\n#f\ng', 2 ) )
	self:assertDeepEquals( {'#e\n#f','*h\n*i'}, T.getLists('a\n*b\n*c\nd\n#e\n#f\ng\n*h\n*i', '2-3' ) )

	self:assertEquals( '*b\n*c\n\n#e\n#f', T.get('Module:Transcluder/testpage#Lists', { only = 'lists' } ) )
	self:assertEquals( '#e\n#f', T.get('Module:Transcluder/testpage#Lists', { only = 'lists', lists = 2 } ) )
end

function Suite:testOnly()
	self:assertEquals( '{|\n|e\n|}\n\n{|\n|k\n|}', T.get('Module:Transcluder/testpage#Only', { only = 'tables' } ) )
	self:assertEquals( '*c\n*d\n\n#h\n#i', T.get('Module:Transcluder/testpage#Only', { only = 'lists' } ) )
	self:assertEquals( '*c\n*d', T.get('Module:Transcluder/testpage#Only', { only = 'lists', lists = 1 } ) )
end

function Suite:testParagraphs()
	self:assertDeepEquals( {'a'}, T.getParagraphs('a') )
	self:assertDeepEquals( {'a{{b}}'}, T.getParagraphs('a{{b}}') )
	self:assertDeepEquals( {'{{a}}b'}, T.getParagraphs('{{a}}b') )
	self:assertDeepEquals( {}, T.getParagraphs('{{a}}') )
	self:assertDeepEquals( {}, T.getParagraphs('{{a\n|b=c}}') )
	self:assertDeepEquals( {}, T.getParagraphs('{{a}}\n\n{{b}}\n\n{{c}}') )
	self:assertDeepEquals( {'a'}, T.getParagraphs('a\n\n{{b}}') )
	self:assertDeepEquals( {'b'}, T.getParagraphs('{{a}}\n\nb') )
	self:assertDeepEquals( {'{{a}}b{{c}}'}, T.getParagraphs('{{a}}b{{c}}') )
	self:assertDeepEquals( {'a','b','c'}, T.getParagraphs('a\n\nb\n\nc') )
	self:assertDeepEquals( {'a','c'}, T.getParagraphs('a\n\n{{b}}\n\nc') )
	self:assertDeepEquals( {'a','c','d','e'}, T.getParagraphs('a\n\nb\n\nc\n\nd\n\ne', '1,3-5' ) )
	self:assertDeepEquals( {'e'}, T.getParagraphs('{{a}}\n{{b}}\n{{c}}\n{{d}}\ne', 1 ) )

	self:assertEquals( '[[File:Name.jpg|thumb|X1]]\nX1\n{|\n|X2\n|}\n\n{{X5}}', T.get('Module:Transcluder/testpage#Paragraphs', { paragraphs = 1 } ) )
	self:assertEquals( 'X1\n\n{{X2}} X3 {{X4}}', T.get('Module:Transcluder/testpage#Paragraphs', { only = 'paragraphs' } ) )
	self:assertEquals( 'X1', T.get('Module:Transcluder/testpage#Paragraphs', { only = 'paragraphs', paragraphs = 1 } ) )
	self:assertEquals( '{{X2}} X3 {{X4}}', T.get('Module:Transcluder/testpage#Paragraphs', { only = 'paragraphs', paragraphs = 2 } ) )
end

function Suite:testParameters()
	self:assertDeepEquals( {}, T.getParameters('{{a}}', 0 ) )
	self:assertDeepEquals( {}, T.getParameters('{{a}}', 1 ) )
	self:assertDeepEquals( {}, T.getParameters('{{a|b}}', 2 ) )
	self:assertDeepEquals( {}, T.getParameters('{{a|b=c}}', 1 ) )
	self:assertDeepEquals( {}, T.getParameters('{{a|b=c}}', 'd' ) )
	self:assertDeepEquals( {['b']='c'}, T.getParameters('{{a|b=c|d=e}}', 'b' ) )
	self:assertDeepEquals( {['b']='2%'}, T.getParameters('{{a|b=2%}}', 'b' ) )
	self:assertDeepEquals( {['d']='e'}, T.getParameters('{{aa\n|\nb=c\n|d=e\n}}', 'd' ) )
	self:assertDeepEquals( {['f']='g'}, T.getParameters('{{ a | b = c | f = g }}', ' f ' ) )
	self:assertDeepEquals( {['b']='c',['d']='e'}, T.getParameters('{{a|b=c|d=e}}', 'b,d' ) )
	self:assertDeepEquals( {['b']='{{c|d=e}}'}, T.getParameters('{{a|b={{c|d=e}}}}', 'b' ) )
	self:assertDeepEquals( {['b']='{{c|d=2%}}'}, T.getParameters('{{a|b={{c|d=2%}}}}', 'b' ) )
	self:assertDeepEquals( {['b']='<div class="c">d</div>'}, T.getParameters('{{a|b=<div class="c">d</div>}}', 'b' ) )
	self:assertDeepEquals( {['b']='{{c|[[d|e]]}}'}, T.getParameters('{{a|b={{c|[[d|e]]}}}}', 'b' ) )
	self:assertDeepEquals( {['b']='[[c|d]]'}, T.getParameters('{{a|b=[[c|d]]}}', 'b' ) )
	self:assertDeepEquals( {[1]='f'}, T.getParameters('{{a|b=c|d=e|f}}', 1 ) )
	self:assertDeepEquals( {[1]='d',[2]='e',[3]='h'}, T.getParameters('{{a|b=c|d|e|f=g|h}}', '1-3' ) )

	self:assertEquals( 'd', T.get('Module:Transcluder/testpage#Parameters', { only = 'parameters', parameters = 'b' } ) )
	self:assertEquals( 'd', T.get('Module:Transcluder/testpage#Parameters', { only = 'parameters', parameters = 'b', templates = 'aa' } ) )
	self:assertEquals( 'd', T.get('Module:Transcluder/testpage#Parameters', { only = 'parameters', parameters = 'b', templates = 'bb' } ) )
end

function Suite:testReferences()
	self:assertDeepEquals( {}, T.getReferences('a') )
	self:assertDeepEquals( {'<ref>b</ref>'}, T.getReferences('a<ref>b</ref>') )
	self:assertDeepEquals( {}, T.getReferences('a<ref>b</ref>', 0) )
	self:assertDeepEquals( {}, T.getReferences('a<ref name="b" />') )
	self:assertDeepEquals( {'<ref>d</ref>'}, T.getReferences('a<ref>b</ref>c<ref>d</ref>', 2) )
	self:assertDeepEquals( {'<ref name="b">c</ref>','<ref>e</ref>'}, T.getReferences('a<ref name="b">c</ref>d<ref name="b" /><ref>e</ref>') )
	self:assertDeepEquals( {'<ref name="b">c</ref>'}, T.getReferences('a<ref name="b">c</ref>d<ref name="b" /><ref>e</ref>', 'b') )

	self:assertEquals( 'acfgk', T.get('Module:Transcluder/testpage#References', { references = 0 } ) )
	self:assertEquals( '<ref>b</ref>\n\n<ref name="d">e</ref>\n\n<ref name="h" group="i">j</ref>', T.get('Module:Transcluder/testpage#References', { only = 'references' } ) )
	self:assertEquals( '<ref>b</ref>\n\n<ref name="Module:Transcluder/testpage d">e</ref>\n\n<ref name="Module:Transcluder/testpage h">j</ref>', T.get('Module:Transcluder/testpage#References', { only = 'references', fixReferences = true } ) )
end

function Suite:testSection()
	self:assertThrows( function() T.getSection('a', 'a') end, "Section 'a' not found" )
	self:assertThrows( function() T.getSection('==z==', 'z') end, "Section 'z' is empty" )

	self:assertEquals( 'b', T.getSection('==a==\nb', 'a') )
	self:assertEquals( 'b', T.getSection('==a==\nb\n==c==\nd', 'a') )
	self:assertEquals( 'b\n===c===\nd', T.getSection('==a==\nb\n===c===\nd', 'a') )
	self:assertEquals( 'd', T.getSection('==a==\nb\n===c===\nd', 'c') )

	self:assertEquals( 'a\n===Subsection===\nb', T.get('Module:Transcluder/testpage#Section') )
	self:assertEquals( 'b', T.get('Module:Transcluder/testpage#Subsection') )
	self:assertEquals( 'a', T.get('Module:Transcluder/testpage#Section', { sections = 0 } ) )
end

function Suite:testSections()
	self:assertEquals( "This '''test page''' interacts with [[Module:Transcluder/testcases]].", T.get('Module:Transcluder/testpage', { sections = 0 } ) )
	self:assertEquals( 'a\n===Subsection===\nb', T.get('Module:Transcluder/testpage#Section') )
	self:assertEquals( 'a', T.get('Module:Transcluder/testpage#Section', { sections = 0 } ) )
	self:assertEquals( 'a', T.get('Module:Transcluder/testpage#Section', { sections = 2 } ) )
	self:assertEquals( 'a', T.get('Module:Transcluder/testpage#Section', { sections = 'Fake' } ) )
	self:assertEquals( 'a\n===Subsection===\nb', T.get('Module:Transcluder/testpage#Section', { sections = 1 } ) )
	self:assertEquals( 'a\n===Subsection===\nb', T.get('Module:Transcluder/testpage#Section', { sections = 'Subsection' } ) )
	self:assertEquals( 'd', T.get('Module:Transcluder/testpage#Subsection with [[link]]' ) )
	self:assertEquals( 'e\n===Subsection===\nf', T.get('Module:Transcluder/testpage#Section with (parenthesis)' ) )

	-- <section> tags
	self:assertThrows( function() T.get('Module:Transcluder/testpage#a') end, "Section tag 'a' is empty" )
	self:assertEquals( 'b', T.get('Module:Transcluder/testpage#b' ) )
	self:assertEquals( '{|\n!c\n|}', T.get('Module:Transcluder/testpage#c' ) )
end

function Suite:testSelfLink()
	self:assertEquals( "This '''test page''' interacts with [[Module:Transcluder/testcases]].", T.get('Module:Transcluder/testpage', { noSelfLinks = true, sections = 0 } ) )
	self:assertEquals( 'Module talk:Transcluder/testcases module talk:Transcluder/testcases a a', T.get('Module:Transcluder/testpage#Self links', { noSelfLinks = true, sections = 0 } ) )
end

function Suite:testTables()
	self:assertEquals( '{|\n!b\n|}\n\n{|\n|d\n|}\n\n{|id="e"\n|e\n|}', T.get('Module:Transcluder/testpage#Tables', { only = 'tables' } ) )
	self:assertEquals( '{|\n!b\n|}', T.get('Module:Transcluder/testpage#Tables', { only = 'tables', tables = 1 } ) )
	self:assertEquals( '{|\n|d\n|}', T.get('Module:Transcluder/testpage#Tables', { only = 'tables', tables = 2 } ) )
	self:assertEquals( '{|\n!b\n|}\n\n{|id="e"\n|e\n|}', T.get('Module:Transcluder/testpage#Tables', { only = 'tables', tables = '1,3' } ) )
	self:assertEquals( '{|\n|d\n|}\n\n{|id="e"\n|e\n|}', T.get('Module:Transcluder/testpage#Tables', { only = 'tables', tables = '2-3' } ) )
	self:assertEquals( '{|id="e"\n|e\n|}', T.get('Module:Transcluder/testpage#Tables', { only = 'tables', tables = 'e' } ) )
end

function Suite:testTags()
	self:assertDeepEquals( {}, T.getTags( 'a' ) ) -- no tags
	self:assertDeepEquals( {'<div>a'}, T.getTags( '<div>a' ) ) -- unclosed tag
	self:assertDeepEquals( {'<div></div>'}, T.getTags( '<div></div>' ) ) -- empty tag
	self:assertDeepEquals( {'<div></div>'}, T.getTags( 'a<div></div>b' ) )
	self:assertDeepEquals( {'<div>a</div>'}, T.getTags( '<div>a</div>' ) ) -- simple case
	self:assertDeepEquals( {'<div>b</div>'}, T.getTags( 'a<div>b</div>c' ) )
	self:assertDeepEquals( {'< div >a</ div >'}, T.getTags( '< div >a</ div >' ) ) -- weird spacing
	self:assertDeepEquals( {'<div class="a">b</div>'}, T.getTags( '<div class="a">b</div>' ) ) -- attributes

	-- Nested tags
	self:assertDeepEquals( {'<div><div></div></div>','<div></div>'}, T.getTags( '<div><div></div></div>' ) )
	self:assertDeepEquals( {'<div>b<div>c</div>d</div>','<div>c</div>'}, T.getTags( 'a<div>b<div>c</div>d</div>e' ) )
	self:assertDeepEquals( {'<div><div><span>a</span></div></div>','<div><span>a</span></div>','<span>a</span>'}, T.getTags( '<div><div><span>a</span></div></div>' ) )
	self:assertDeepEquals( {'<span>a</span>'}, T.getTags( '<div><div><span>a</span></div></div>', 'span' ) )
	self:assertDeepEquals( {'<div><div><span>a</span></div></div>','<div><span>a</span></div>'}, T.getTags( '<div><div><span>a</span></div></div>', '-span' ) )

	self:assertEquals( '<gallery>\nFile:A.png|g<ref>g</ref>\nFile:B.png\n</gallery>\n\n<ref>g</ref>\n\n<br>\n\n<br />\n\n<hr>', T.get('Module:Transcluder/testpage#Tags', { only = 'tags' } ) )
	self:assertEquals( '<ref name="l">m</ref>', T.get('Module:Transcluder/testpage#References2', { only = 'tags' } ) )
	self:assertEquals( '<ref>b</ref>\n\n<ref name="d">e</ref>\n\n<ref name="d" />\n\n<ref name="h" group="i">j</ref>\n\n<ref name="l" />', T.get('Module:Transcluder/testpage#References', { only = 'tags' } ) )
	self:assertEquals( '<ref>g</ref>\n\n<ref>b</ref>\n\n<ref name="d">e</ref>\n\n<ref name="d" />\n\n<ref name="h" group="i">j</ref>\n\n<ref name="l" />\n\n<ref name="l">m</ref>', T.get('Module:Transcluder/testpage', { only = 'tags', tags = 'ref' } ) )
	self:assertEquals( '<gallery>\nFile:A.png|g<ref>g</ref>\nFile:B.png\n</gallery>', T.get('Module:Transcluder/testpage', { only = 'tags', tags = 'gallery' } ) )
	self:assertEquals( '<gallery>\nFile:A.png|g<ref>g</ref>\nFile:B.png\n</gallery>\n\n<ref>g</ref>\n\n<br>', T.get('Module:Transcluder/testpage', { only = 'tags', tags = '1-3' } ) )
	self:assertEquals( '<div>a<div>b</div></div>\n\n<div>b</div>', T.get('Module:Transcluder/testpage', { only = 'tags', tags = 'div' } ) )
	self:assertEquals( '<span class="a">b<span id="c">d</span></span>\n\n<span id="c">d</span>', T.get('Module:Transcluder/testpage', { only = 'tags', tags = 'span' } ) )
end

function Suite:testTemplates()
	self:assertDeepEquals( {'{{b}}','{{c}}','{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e' ) )
	self:assertDeepEquals( {'{{c}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', 2 ) )
	self:assertDeepEquals( {'{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', 'D' ) )
	self:assertDeepEquals( {'{{ b \n | c = d \n}}'}, T.getTemplates( 'a{{ b \n | c = d \n}}e', 'b' ) )
	self:assertDeepEquals( {'{{a|b={{c|d=e}}}}'}, T.getTemplates( '{{a|b={{c|d=e}}}}', 'a' ) )
	self:assertDeepEquals( {'{{b}}','{{c}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', '-d' ) )
	self:assertDeepEquals( {'{{c}}','{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', 'c,d' ) )
	self:assertDeepEquals( {'{{b}}','{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', '1,d' ) )
	self:assertDeepEquals( {'{{c}}','{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', { ['c'] = true, ['d'] = true } ) )
	self:assertDeepEquals( {'{{b}}','{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', { [1] = true, ['d'] = true } ) )
	self:assertDeepEquals( {'{{c}}','{{d}}'}, T.getTemplates( 'a{{b}}{{c}}{{d}}e', { [1] = false } ) )

	self:assertEquals( '{{X2}}\n\n{{X3}}\n\n{{X4}}', T.get('Module:Transcluder/testpage#Templates', { only = 'templates' } ) )
	self:assertEquals( '{{X3}}', T.get('Module:Transcluder/testpage#Templates', { only = 'templates', templates = 2 } ) )
	self:assertEquals( '{{X4}}', T.get('Module:Transcluder/testpage#Templates', { only = 'templates', templates = 'X4' } ) )
	self:assertEquals( '{{X3}}\n\n{{X4}}', T.get('Module:Transcluder/testpage#Templates', { only = 'templates', templates = 'X3,X4' } ) )
end

return Suite