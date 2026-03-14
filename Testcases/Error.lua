-- Unit tests for [[Module:Error]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_error()
	self:preprocess_equals_sandbox_many('{{#invoke:Error', 'error', {
    -- Minimal parameter input
		{'', '<strong class="error"></strong>'},
		{'', '<strong class="error"></strong>', {nowiki = 'yes'}},
		{' ', '<strong class="error"> </strong>'},
		{'&#x20', '<strong class="error">&#x20</strong>'},
		{'{{!}}', '<strong class="error">|</strong>'},
		{'|tag=p', '<p class="error"></p>', {nowiki = 'yes'}},
		{'|message=', '<strong class="error"></strong>'},
		{'|message=', '<strong class="error"></strong>', {nowiki = 'yes'}},
		{'|message=|tag=p', '<p class="error"></p>', {nowiki = 'yes'}},
		{'|1', '<strong class="error"></strong>'},
		{'1=', '<strong class="error"></strong>', {nowiki = 'yes'}},
		{'1=|tag=p', '<p class="error"></p>'},

    -- Plain message
		{'|Example error message', '<strong class="error"></strong>'},
		{'|  Example error message  ', '<strong class="error"></strong>'},
		{'|message=Example error message', '<strong class="error">Example error message</strong>'},
		{'|message =  Example error message  ', '<strong class="error">Example error message</strong>'},

    -- tag
		{'|Example error message|tag=p', '<p class="error"></p>'},
		{'|tag=p', '<p class="error"></p>'}, -- no message
		{'|Example error message| tag = p', '<p class="error"></p>', {nowiki = 'yes'}},
		{'|Example error message|tag=div', '<div class="error"></div>'},
		{'|Example error message|tag=div', '<div class="error"></div>'},
		{'|Example error message|tag=span', '<span class="error"></span>'},
		{'|Example error message|tag=adsf', '<strong class="error"></strong>'},
		{'|Example error message|tag=strong', '<strong class="error"></strong>'},
		{'|Example error message|tag=&#x0000;', '<strong class="error"></strong>'}, -- ASCII nul
		{'|Example error message|tag= ', '<strong class="error"></strong>'}, -- nbsp
		{'|Example error message|tag={{!}}', '<strong class="error"></strong>'},

    -- Use numbered parameter
		{'1=Example error message', '<strong class="error">Example error message</strong>'},
		{'1=  Example error message  ', '<strong class="error">Example error message</strong>'},
		{'|Example = message', '<strong class="error"></strong>'},
		{'1=  Example = message  ', '<strong class="error">Example = message</strong>'},

    -- More extreme input options
		{'| ', '<strong class="error"></strong>'}, -- nbsp
		{'|<br/>', '<strong class="error"></strong>'},
		{'|\n', '<strong class="error"></strong>', {nowiki = 'yes'}},
		{'|&#x0000;', '<strong class="error"></strong>'}, -- ASCII nul

    -- Tricky input options
		{'|0', '<strong class="error"></strong>'}, -- nbsp
		{'|false', '<strong class="error"></strong>'},
		{'|tag=tag', '<strong class="error"></strong>'},
		{'|1', '<strong class="error"></strong>'},
		{'|true', '<strong class="error"></strong>'},
	}, {nowiki=1})
end

return p
