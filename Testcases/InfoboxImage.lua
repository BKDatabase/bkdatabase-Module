-- Unit tests for [[Module:InfoboxImage]]. Click talk page to run tests.

local p = require('Module:UnitTests')

function p:test1_parameters_output()
    self:preprocess_equals_preprocess_many('{{#invoke:InfoboxImage/sandbox |InfoboxImage |image=', '}}', '{{#invoke:InfoboxImage |InfoboxImage |image=', '}}', {
        {'Small Sailboat Image.jpg |alt=Alt'},
        {'Small Sailboat Image.jpg |border=yes'},
        {'Small Sailboat Image.jpg |center=yes'},
        {'Small Sailboat Image.jpg |link=Link'},
        {'Small Sailboat Image.jpg |thumbtime=Thumbtime'},
        {'Small Sailboat Image.jpg |title=Title'},
        {'Small Sailboat Image.jpg |size=75'},
        {'Small Sailboat Image.jpg |size=200'},
        {'Small Sailboat Image.jpg |size=200|sizedefault=260|maxsize=275'},
        {'Small Sailboat Image.jpg |size=400|sizedefault=260|maxsize=275'},
        {'Small Sailboat Image.jpg |sizedefault=260|maxsize=275'},
        {'Small Sailboat Image.jpg |maxsize=275'},
        {'Small Sailboat Image.jpg |maxsize=275|sizedefault=frameless'},
        {'[[File:Small Sailboat Image.jpg]]'},
        {'Mustela erminea upright.jpg'},
        {'Mustela erminea upright.jpg |upright=1'},
        {'Mustela erminea upright.jpg |upright=yes'},
        {'Mustela erminea upright.jpg |upright=0.75'},
        {'Mustela erminea upright.jpg |upright=1.2'},
        {'Mustela erminea upright.jpg |upright=1|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1|maxsize=275|sizedefault=frameless'},
        {'Mustela erminea upright.jpg |upright=1|sizedefault=260|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1.5|sizedefault=260|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1|size=200|sizedefault=260|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1|size=|sizedefault=|maxsize='},
        {'Replace this image.svg |suppressplaceholder=no'},
        {'Replace this image.svg'},
        {'The Universal Magazine, Vol. XCV (July 1794).djvu |page=8'},
		{'[[File:Abbey Rd Studios.jpg|200px]]'},
		{'[[File:Abbey Rd Studios.jpg|thumb]]'},
		{'[[File:Abbey Rd Studios.jpg|thumb|caption]]'},
		{'Http-fakezarathustra.blogspot.com-2010-10-12 31.html http-fakezarathustra.blogspot.com-2010-10-22 31.html - panoramio.jpg'},
		{'Abbey Rd Studios.jpg|alt=http:test.com'},
		{'Abbey Rd Studios.jpg|alt=[http:test.com]'},
        {'Abbey Rd Studios.jpg|class=notpageimage'},
    })
end

function p:test2_parameters_nowiki()
    self:preprocess_equals_preprocess_many('{{#invoke:InfoboxImage/sandbox |InfoboxImage |image=', '}}', '{{#invoke:InfoboxImage|InfoboxImage |image=', '}}', {
        {'Small Sailboat Image.jpg |alt=Alt'},
        {'Small Sailboat Image.jpg |border=yes'},
        {'Small Sailboat Image.jpg |center=yes'},
        {'Small Sailboat Image.jpg |link=Link'},
        {'Small Sailboat Image.jpg |thumbtime=Thumbtime'},
        {'Small Sailboat Image.jpg |title=Title'},
        {'Small Sailboat Image.jpg |size=75'},
        {'Small Sailboat Image.jpg |size=200'},
        {'Small Sailboat Image.jpg |size=200|sizedefault=260|maxsize=275'},
        {'Small Sailboat Image.jpg |size=400|sizedefault=260|maxsize=275'},
        {'Small Sailboat Image.jpg |sizedefault=260|maxsize=275'},
        {'Small Sailboat Image.jpg |maxsize=275'},
        {'Small Sailboat Image.jpg |maxsize=275|sizedefault=frameless'},
        {'Small Sailboat Image.jpg |size=20%|sizedefault=10em'},
        {'[[File:Small Sailboat Image.jpg]]'},
        {'Mustela erminea upright.jpg'},
        {'Mustela erminea upright.jpg |upright=1'},
        {'Mustela erminea upright.jpg |upright=yes'},
        {'Mustela erminea upright.jpg |upright=0.75'},
        {'Mustela erminea upright.jpg |upright=1.2'},
        {'Mustela erminea upright.jpg |upright=1|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1|maxsize=275|sizedefault=frameless'},
        {'Mustela erminea upright.jpg |upright=1|sizedefault=260|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1.5|sizedefault=260|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1|size=200|sizedefault=260|maxsize=275'},
        {'Mustela erminea upright.jpg |upright=1|size=|sizedefault=|maxsize='},
        {'Replace this image.svg |suppressplaceholder=no'},
        {'Replace this image.svg'},
        {'The Universal Magazine, Vol. XCV (July 1794).djvu |page=8'},
		{'Http-fakezarathustra.blogspot.com-2010-10-12 31.html http-fakezarathustra.blogspot.com-2010-10-22 31.html - panoramio.jpg'},
		{'Abbey Rd Studios.jpg|alt=http:test.com'},
		{'Abbey Rd Studios.jpg|alt=[http:test.com]'},
        {'Abbey Rd Studios.jpg|class=notpageimage'},
		{'[[File:Abbey Rd Studios.jpg|200px]]'},
		{'[[File:Abbey Rd Studios.jpg|thumb]]'},
		{'[[File:Abbey Rd Studios.jpg|thumb|caption]]'},
    },{nowiki=1})
end

function p:test3_errors()
    self:preprocess_equals_preprocess_many('{{#invoke:InfoboxImage/sandbox |InfoboxImage |image=', '}}', '{{#invoke:InfoboxImage|InfoboxImage |image=', '}}', {
        {'Mustela erminea upright.jpg |size=1.2'},
        {'Mustela erminea upright.jpg |size=300x'},
        {'Mustela erminea upright.jpg |sizedefault=300x | maxsize=200'},
        {'Mustela erminea upright.jpg |size=300 | maxsize=200x'},
        {'Mustela erminea upright.jpg |sizedefault=145 | maxsize=300x'},
		{'http:test.com'},
		{'[http:test.com]'},
		{'[[http:test.com]]'},
		{'https:test.com'},
		{'[https:test.com]'},
		{'[[https:test.com]]'},
    },{nowiki=1})
end

function p:test4_stripmarkers()
    self:preprocess_equals_preprocess(
    	'{{#invoke:InfoboxImage/sandbox |InfoboxImage |image={{multiple image | width = 60 | image1 = Yellow card.svg | image2 = Red card.svg}}}}',
    	'{{#invoke:InfoboxImage |InfoboxImage |image={{multiple image | width = 60 | image1 = Yellow card.svg | image2 = Red card.svg}}}}',
    	{stripmarker=1})
end

return p
