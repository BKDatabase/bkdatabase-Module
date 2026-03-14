local p = require('Module:UnitTests')

function p:test01_basic()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[Apple]]', 'Apple'},
		{ '[[Orange]]s are dissimilar to [[Apple]]s', 'Oranges are dissimilar to Apples'},
		{ '[[Apple]]s and [[orange]]s and [[fruit salad|other kinds of fruit]]', 'Apples and oranges and other kinds of fruit'},
		{ 'All [[Gone]] [[wikt:to|]] [[Bed]] [[Now]]', 'All Gone to Bed Now'},
		{ '[[Survey]] of [http://books.google.com Google Books] on [[UK|Britain]]', 'Survey of Google Books on Britain'},
		{ '[[What If...?]]', 'What If...?' },
	}, {nowiki='yes'})
end

function p:test02_cats_files_interwikis()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[Category:Foo]]', ''},
		{ '[[category:Foo]]', ''},
		{ '[[File:Foo]]', ''},
		{ '[[Image:Foo]]', ''},
		{ '[[es:Foo]]', ''},
		{ '[[wikt:Foo]]', 'wikt:Foo'},
		{ '[[es:Wikipedia:Políticas]]', ''},
		{ '[[abcd:efgh:ijkl]]', 'abcd:efgh:ijkl'},
		{ '[[cbk-zam:abcd:efgh]]', ''},
		{ '[[meatball:WikiPedia]]', 'meatball:WikiPedia' },
	}, {nowiki='yes'})
end

function p:test03_colontrick()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[:Category:Foo]]', 'Category:Foo'},
		{ '[[:es:Foo]]', 'es:Foo'},
		{ '[[:wikt:Foo]]', 'wikt:Foo'},
		{ '[[:es:Wikipedia:Políticas]]', 'es:Wikipedia:Políticas'},
		{ '[[:abcd:efgh:ijkl]]', 'abcd:efgh:ijkl'},
		{ '[[:cbk-zam:abcd:efgh]]', 'cbk-zam:abcd:efgh'},
		{ '[[:meatball:WikiPedia]]', 'meatball:WikiPedia'},
	}, {nowiki='yes'})
end

function p:test04_pipetrick()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[Pipe (computing)|]]', 'Pipe'},
		{ '[[Boston, Massachusetts|]]', 'Boston'},
		{ '[[Wikipedia:Verifiability|]]', 'Verifiability'},
		{ '[[User:Example|]]', 'Example'},
		{ '[[Template:Welcome|]]', 'Welcome'},
		{ '[[Yours, Mine and Ours (1968 film)|]]', 'Yours, Mine and Ours'},
		{ '[[:es:Wikipedia:Políticas|]]', 'Wikipedia:Políticas'},
		{ '[[Il Buono, il Brutto, il Cattivo|]]', 'Il Buono'},
		{ '[[Wikipedia:Manual of Style (Persian)|]]', 'Manual of Style'},
		{ '[[Wikipedia:Manual of Style(Persian)|]]', 'Manual of Style'},
		{ '[[foo|bar|]]', 'bar|'},
		{ '[[foo||]]', '|'},
		{ 'xx[[foo bar   (baz)|]]xx', 'xxfoo bar xx'},
	}, {nowiki='yes'})
end

function p:test05_reverse_pipetrick()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[|foo]]', 'foo'},
		{ '[[|multiple|pipes]]', '[[|multiple|pipes]]'},
		{ '[[|foo (bar)]]', 'foo (bar)'},
		{ '[[|foo, bar (baz)]]', 'foo, bar (baz)'},
		{ '[[|simultaneous pipe trick|]]', '[[|simultaneous pipe trick|]]'},
	}, {nowiki='yes'})
end

function p:test06_badlinks()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[<]]', '[[<]]'},
		{ '[[Category:<]]', '[[Category:<]]'},
		{ '[[:Category:<]]', '[[:Category:<]]'},
		{ '[[:Category:<|Foo]]', '[[:Category:<|Foo]]'},
		{ '[[:Category:<|]]', '[[:Category:<|]]'},
		{ '[[:Category:Foo|<]]', '<'},
		{ '[[Category:Foo|<]]', ''},
		{ '[[Foo:Bar|<]]', '<'},
		{ '[[Foo:Bar:>]]', '[[Foo:Bar:>]]'},
		{ '[[es:Wikipedia:<]]', '[[es:Wikipedia:<]]'},
		{ '[[es:Wikipedia:Foo|<]]', ''},
		{ '[[:es:Wikipedia:<]]', '[[:es:Wikipedia:<]]'},
		{ '[[:es:Wikipedia:Foo|<]]', '<'},
		{ '[[Foo:Bar:Foo#>]]', 'Foo:Bar:Foo#>'},
		{ '[[Foo:Bar:Foo>#Baz]]', '[[Foo:Bar:Foo>#Baz]]'},
		{ '[[Foo#Bar>#Baz]]', 'Foo#Bar>#Baz'},
		{ '[[Foo>#Bar#Baz]]', '[[Foo>#Bar#Baz]]'},
		{ '[[wikt:es:asdf:&#x0000;Template:title#Fragment]]', '[[wikt:es:asdf:&#x0000;Template:title#Fragment]]'},
		{ '[[foo]]', '[[foo]]'}, -- ASCII delete character
	}, {nowiki='yes'})
end

function p:test07_URI_slashes()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[/foo]', '[/foo]'},
		{ '[/foo bar]', '[/foo bar]'},
		{ '[//foo]', ''},
		{ '[//foo bar]', 'bar'},
		{ '[///foo]', ''},
		{ '[///foo bar]', 'bar'},
		{ '[////foo]', ''},
		{ '[////foo bar]', 'bar'},
		{ '[///////////////////////////////////foo]', ''},
		{ '[///////////////////////////////////foo bar]', 'bar'},
	}, {nowiki='yes'})
end

function p:test08_URI_prefixes()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[://foo]', '[://foo]'},
		{ '[:://foo]', '[:://foo]'},
		{ '[abcd://]', '[abcd://]'},
		{ '[abcd://foo]', '[abcd://foo]'},
		{ '[http://]', '[http://]'},
		{ '[http://foo]', ''},
		{ '[https://]', '[https://]'},
		{ '[https://foo]', ''},
		{ '[ftp://]', '[ftp://]'},
		{ '[ftp://foo]', ''},
		{ '[gopher://]', '[gopher://]'},
		{ '[gopher://foo]', ''},
		{ '[mailto:]', '[mailto:]'},
		{ '[mailto:foo]', ''},
		{ '[news]', '[news]'},
		{ '[news at ten]', '[news at ten]'},
		{ '[news:]', '[news:]'},
		{ '[news: at ten]', '[news: at ten]'},
		{ '[news:/]', ''},
		{ '[news:/ at ten]', 'at ten'},
		{ '[news://]', ''},
		{ '[news://foo]', ''},
		{ '[news://foo at ten]', 'at ten'},
		{ '[irc://]', '[irc://]'},
		{ '[irc://foo]', ''},
	}, {nowiki='yes'})
end

function p:test09_URI_special_characters()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[:http://foo]', '[:http://foo]'},
		{ '[http://<foo]', '<foo'},
		{ '[http://foo"bar]', '"bar'},
		{ '[http://"foo]', '[http://"foo]'},
		{ '[http://>foo]', '>foo'},
		{ '[http://foo<bar]', '<bar'},
		{ '[http://foo>bar]', '>bar'},
		{ '[http:// foo]', '[http:// foo]'},
	}, {nowiki='yes'})
end

function p:test10_nesting()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ 'text[[<s name=]]>stricken</s>more text]]', 'text[[<s name=]]>stricken</s>more text]]'},
		{ 'text[[<s>stricken</s>more text]]', 'text[[<s>stricken</s>more text]]'},
		{ '[[outer[[inner]]outer]]', '[[outerinnerouter]]'},
		{ '[http://outer outer [[inner]] outer]', 'outer inner outer'},
		{ '[[outer[http://inner inner]outer]]', '[[outerinnerouter]]'},
		{ '[[outer[http://inner]outer]]]', '[[outerouter]]]'},
	}, {nowiki='yes'})
end

function p:test11_multiple_pipes()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[foo|bar|baz]]', 'bar|baz'},
		{ '[[foo|bar|baz|]]', 'bar|baz|'},
		{ '[[|foo|bar|baz]]', '[[|foo|bar|baz]]'},
		{ '[[|foo|bar|baz|]]', '[[|foo|bar|baz|]]'},
		{ '[[foo|bar|baz||]]', 'bar|baz||'},
		{ '[[||foobarbaz]]', '[[||foobarbaz]]'},
		{ '[[foobarbaz||]]', '|'},
	}, {nowiki='yes'})
end

function p:test12_http_links()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[http]', '[http]'},
		{ '[http:foo]', '[http:foo]'},
		{ '[http:]', '[http:]'},
		{ '[http:foo]', '[http:foo]'},
		{ '[http:/]', '[http:/]'},
		{ '[http:/foo]', '[http:/foo]'},
		{ '[http://]', '[http://]'},
		{ '[http://foo]', ''},
	}, {nowiki='yes'})
end

function p:test13_whitespace()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ 'xx[[   fruit salad   |   many kinds of fruit   ]]xx', 'xx many kinds of fruit xx'},
		{ '[http://www.example.com        example]', 'example'},
		{ [=[[[link with
		a line break in]]]=], '[[link with a line break in]]'},
		{ [=[[[link with

		two line breaks in]]]=], [=[[[link with

 two line breaks in]]]=] },
		{ [=[an [http://www.example.com 
		example].]=], 'an [http://www.example.com example].'},
		{ [=[an [http://www.example.com

		example].]=], [=[an [http://www.example.com

 example].]=] },
		{ '[http://www.example.com HTML line breaks] between<br>two [http://www.example.com links]', 'HTML line breaks between two links'},
		{ '[http://www.example.com HTML line break<br />within<br/>a link]', 'HTML line break within a link'},
		{ '[http://www.example.com Double HTML line break<br /><br  />within a link]', [=[Double HTML line break

within a link]=]},
		{ '[http://www.example.com non-breaking spaces]', 'non-breaking spaces'},
		{ '[http://www.example.com tab characters]', 'tab characters'},
		{ '[http://www.example.com     multiple    non-breaking      spaces]', 'multiple non-breaking spaces'},
		{ '[http://www.example.com     multiple    tab      characters]', 'multiple tab characters'},
	}, {nowiki='yes'})
end

function p:test14_full_paragraphs()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{
			[==[He then studied at [[Saint Patrick Seminary, Menlo Park|St. Patrick's Seminary]] in [[Menlo Park, California|Menlo Park]]. He was [[Holy Orders|ordained]] to the [[Priesthood (Catholic Church)|priesthood]] on June 10, 1933.<ref name=hierarchy>{{cite news|work=Catholic-Hierarchy.org|title=Bishop Merlin Joseph Guilfoyle|url=http://www.catholic-hierarchy.org/bishop/bguimj.html}}</ref> In 1937, he earned a [[Doctor of Canon Law]] from the [[The Catholic University of America|Catholic University of America]] in [[Washington, D.C.]]<ref name=curtis/> He became a [[Monsignor|Domestic Prelate]] in 1949, and was co-founder and [[chaplain]] of [http://www.stthomasmore-sf.org/ St. Thomas More Society].]==],
			[==[He then studied at St. Patrick's Seminary in Menlo Park. He was ordained to the priesthood on June 10, 1933. In 1937, he earned a Doctor of Canon Law from the Catholic University of America in Washington, D.C. He became a Domestic Prelate in 1949, and was co-founder and chaplain of St. Thomas More Society.]==],
		},
	})
end

function p:test15_full_paragraphs_removing_ref_strip_markers()
	self:preprocess_equals_many('{{delink/sandbox|refs=yes|', '}}', {
		{
			[==[He then studied at [[Saint Patrick Seminary, Menlo Park|St. Patrick's Seminary]] in [[Menlo Park, California|Menlo Park]]. He was [[Holy Orders|ordained]] to the [[Priesthood (Catholic Church)|priesthood]] on June 10, 1933.<ref name=hierarchy>{{cite news|work=Catholic-Hierarchy.org|title=Bishop Merlin Joseph Guilfoyle|url=http://www.catholic-hierarchy.org/bishop/bguimj.html}}</ref> In 1937, he earned a [[Doctor of Canon Law]] from the [[The Catholic University of America|Catholic University of America]] in [[Washington, D.C.]]<ref name=curtis/> He became a [[Monsignor|Domestic Prelate]] in 1949, and was co-founder and [[chaplain]] of [http://www.stthomasmore-sf.org/ St. Thomas More Society].]==],
			[==[He then studied at St. Patrick's Seminary in Menlo Park. He was ordained to the priesthood on June 10, 1933. In 1937, he earned a Doctor of Canon Law from the Catholic University of America in Washington, D.C. He became a Domestic Prelate in 1949, and was co-founder and chaplain of St. Thomas More Society.]==],
		},
	})
end

function p:test16_html_comments()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[foo<!--bar]]-->baz]]', 'foobaz'},
		{ 'foo<!--bar-->baz', 'foobaz'},
		{ 'foo<!--bar<!--baz-->bat-->bam', 'foobat-->bam'},
		{ 'foo[http://abcd<!--bar-->efgh]baz', 'foobaz'},
		{ 'foo[http://abcd<!--barefgh]baz-->bat', 'foo[http://abcdbat'},
		{ 'foo[http://ab[[cd]]<!--barefgh]baz-->bat', 'foo[http://abcdbat'},
		{ 'foo[http://ab{{!((}}cd<!--bar]]efgh]baz-->bat', 'foo[http://ab[[cdbat'},
		{ 'foo[[bar<!--baz-->]]bam', 'foobarbam'},
	}, {nowiki='yes'})
end

function p:test17_nowiki()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '<nowiki>[[foo]]</nowiki>', '[[foo]]'},
		{ '[[foo]]<nowiki>[[bar]]</nowiki>[[baz]]', 'foo[[bar]]baz'},
		{ '<nowiki>[http://www.example.com foo]</nowiki>', '[http://www.example.com foo]'},
		{ '{{!((}}foo<nowiki>bar]]</nowiki>', '[[foobar]]'},
		{ '<nowiki>[[foo</nowiki>bar]]', '[[foobar]]'},
		{ '[http://www.exa<nowiki>mple.com foo]</nowiki>', '[http://www.example.com foo]'},
	}, {nowiki='yes'})
end

function p:test18_decoding()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[[foo%25 bar]]', 'foo% bar'},
		{ '[[foo%25bar]]', '[[foo%25bar]]'},
		{ '[[foo%24bar]]', 'foo$bar'},
		{ '[[foo%88bar]]', '[[foo%88bar]]'},
		{ '[[foo%6Abar]]', 'foojbar'},
		{ '[[foo%11bar]]', '[[foo%11bar]]'},
		{ '[[foo&amp;bar]]', 'foo&bar'},
		{ '[[foo%25bar]]', '[[foo%25bar]]'},
		{ '[[foo&a%6Amp;bar]]', '[[foo&a%6Amp;bar]]'},
		{ '[[foo&%61mp;bar]]', 'foo&bar'},
		{ '[[foo&%62mp;bar]]', '[[foo&%62mp;bar]]'},
		{ '[[foo&#x25;bar]]', '[[foo&#x25;bar]]'},
		{ '[[foo&#x25;62bar]]', '[[foo&#x25;62bar]]'},
		{ '[[foo&#x0000;bar]]', '[[foo&#x0000;bar]]'},
		{ '[[foo&#x00000;bar]]', '[[foo&#x00000;bar]]'},
		{ '[[foo&#x22;bar]]', 'foo"bar'},
		{ '[[foo&#x0000022;bar]]', 'foo"bar'},
		{ '[[foo&amp;amp;bar]]', '[[foo&amp;amp;bar]]'},
	}, {nowiki='yes'})
end

function p:test19_URL_decoding()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '[http://www.example.com foo%25 bar]', 'foo%25 bar'},
		{ '[http://www.example.com foo%25bar]', 'foo%25bar'},
		{ '[http://www.example.com foo%24bar]', 'foo%24bar'},
		{ '[http://www.example.com foo%88bar]', 'foo%88bar'},
		{ '[http://www.example.com foo%6Abar]', 'foo%6Abar'},
		{ '[http://www.example.com foo%11bar]', 'foo%11bar'},
		{ '[http://www.example.com foo&amp;bar]', 'foo&bar'},
		{ '[http://www.example.com foo%25bar]', 'foo%25bar'},
		{ '[http://www.example.com foo&a%6Amp;bar]', 'foo&a%6Amp;bar'},
		{ '[http://www.example.com foo&%61mp;bar]', 'foo&%61mp;bar'},
		{ '[http://www.example.com foo&%62mp;bar]', 'foo&%62mp;bar'},
		{ '[http://www.example.com foo&#x25;bar]', 'foo%bar'},
		{ '[http://www.example.com foo&#x25;62bar]', 'foo%62bar'},
		{ '[http://www.example.com foo&#x0000;bar]', 'foo&#x0000;bar'},
		{ '[http://www.example.com foo&#x00000;bar]', 'foo&#x00000;bar'},
		{ '[http://www.example.com foo&#x22;bar]', 'foo"bar'},
		{ '[http://www.example.com foo&#x0000022;bar]', 'foo"bar'},
	}, {nowiki='yes'})
end

function p:test20_no_link()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ '#Foo', '#Foo' },
		{ 'Foo#Bar', 'Foo#Bar' },
	}, {nowiki='yes'})
end

function p:test21_exotic()
	self:preprocess_equals_many('{{delink/sandbox|', '}}', {
		{ 'some text [[Apple| apples and [[Pear|pears]]]]', 'some text apples and pears' },
		{ 'some text [[Apple|[[Pear|pears]]]]', 'some text pears' },
		{ 'some text [[Apple| [[Pear|pears]]]]', 'some text pears' },
		{ 'some text [[Apple| apples and [[:Pear|pears]]]]', 'some text apples and pears' },
		{ 'some text [[Category:fred]][[Apple| apples]][[:Pear|pears]]', 'some text applespears' },
		{ 'some text [[Category:fred]] [[Apple| apples]][[:Pear|pears]]', 'some text applespears' },
		{
			[==[He then studied at St. Patrick's Seminary in Menlo Park. He was ordained to the priesthood on June 10, 1933. In 1937, he earned a Doctor of Canon Law from the Catholic University of America in Washington, D.C. He became a Domestic Prelate in 1949, and was co-founder and chaplain of St. Thomas More Society.]==],
			[==[He then studied at St. Patrick's Seminary in Menlo Park. He was ordained to the priesthood on June 10, 1933. In 1937, he earned a Doctor of Canon Law from the Catholic University of America in Washington, D.C. He became a Domestic Prelate in 1949, and was co-founder and chaplain of St. Thomas More Society.]==],
		},
	}, {nowiki='yes'})
end

return p
