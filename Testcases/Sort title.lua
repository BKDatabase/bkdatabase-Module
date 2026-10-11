-- Unit tests for [[Module:Sort title]]. Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_1_1_titles_live()
	self:preprocess_equals_many('{{#invoke:Sort title|testcases|', '}}', {
		{'Lost', "Lost"},
		{'Lost (TV series)', "Lost (TV series)"},
		{'Lost (2004 TV series)', "Lost (2004 TV series)"},
		{'Lost (American TV series)', "Lost (American TV series)"},
		{'The Flash', "Flash, The"},
		{'The Flash (TV series)', "Flash, The (TV series)"},
		{'Pilot (The Flash)', "Pilot (Flash, The)"},
		{'The Trap (The Flash)', "Trap, The (Flash, The)"},
		{'4,722 Hours', "4722 Hours"},
		{'4,722 Hours (Agents of S.H.I.E.L.D.)', "4722 Hours (Agents of S.H.I.E.L.D.)"},
	})
end

function p:test_1_2_titles_sandbox()
	self:preprocess_equals_many('{{#invoke:Sort title/sandbox|testcases|', '}}', {
		{'Lost', "Lost"},
		{'Lost (TV series)', "Lost (TV series)"},
		{'Lost (2004 TV series)', "Lost (2004 TV series)"},
		{'Lost (American TV series)', "Lost (American TV series)"},
		{'The Flash', "Flash, The"},
		{'The Flash (TV series)', "Flash, The (TV series)"},
		{'Pilot (The Flash)', "Pilot (Flash, The)"},
		{'The Trap (The Flash)', "Trap, The (Flash, The)"},
		{'4,722 Hours', "4722 Hours"},
		{'4,722 Hours (Agents of S.H.I.E.L.D.)', "4722 Hours (Agents of S.H.I.E.L.D.)"},
	})
end

function p:test_2_1_special_characters_live()
	self:preprocess_equals_many('{{#invoke:Sort title|testcases|', '}}', {
		{'A', "A"},
		{'An', "An"},
		{'The', "The"},
		{'A (Dab)', "A (Dab)"},
		{'A (A)', "A (A)"},
		{'A Title', "Title, A"},
		{'A Title (Dab)', "Title, A (Dab)"},
		{'A Title (A Dab)', "Title, A (Dab, A)"},
		{'Title (Dab)', "Title (Dab)"},
		{'Title (A Dab)', "Title (Dab, A)"},
		{'The Title', "Title, The"},		
		{'An Egg', "Egg, An"},		
		{'A. B. and C.', "A. B. and C."},
		{'\'A\' Title', "\'A\' Title"},
		{'A, My Name', "A, My Name"},
		{'...Title', "...Title"},
		{'...A Title', "...A Title"},
		{'4,722 Hours', "4722 Hours"}
	})
end

function p:test_2_2_special_characters_sandbox()
	self:preprocess_equals_many('{{#invoke:Sort title/sandbox|testcases|', '}}', {
		{'A', "A"},
		{'An', "An"},
		{'The', "The"},
		{'A (Dab)', "A (Dab)"},
		{'A (A)', "A (A)"},
		{'A Title', "Title, A"},
		{'A Title (Dab)', "Title, A (Dab)"},
		{'A Title (A Dab)', "Title, A (Dab, A)"},
		{'Title (Dab)', "Title (Dab)"},
		{'Title (A Dab)', "Title (Dab, A)"},
		{'The Title', "Title, The"},		
		{'An Egg', "Egg, An"},		
		{'A. B. and C.', "A. B. and C."},
		{'\'A\' Title', "\'A\' Title"},
		{'A, My Name', "A, My Name"},
		{'...Title', "...Title"},
		{'...A Title', "...A Title"},
		{'4,722 Hours', "4722 Hours"}
	})
end

--[[
function p:test_3_1_roman_live()
	self:preprocess_equals_many('{{#invoke:Sort title|testcases|', '}}', {
		{'Treehouse of Horror', "Treehouse of Horror"},
		{'Treehouse of Horror 6', "Treehouse of Horror 6"},
		{'The Treehouse of Horror VI', "Treehouse of Horror 6, The"},
		{'Words with abbreviation I.V.Not.roman.', "Words with abbreviation I.V.Not.roman."},
		{'Words with abbreviation S.H.I.E.L', "Words with abbreviation S.H.I.E.L"},
		{'Treehouse of Horror I', "Treehouse of Horror 1"},
		{'Treehouse of Horror II', "Treehouse of Horror 2"},
		{'Treehouse of Horror III', "Treehouse of Horror 3"},
		{'Treehouse of Horror IV', "Treehouse of Horror 4"},
		{'Treehouse of Horror V', "Treehouse of Horror 5"},
		{'Treehouse of Horror VI', "Treehouse of Horror 6"},
		{'Treehouse of Horror VII', "Treehouse of Horror 7"},
		{'Treehouse of Horror VIII', "Treehouse of Horror 8"},
		{'Treehouse of Horror IX', "Treehouse of Horror 9"},
		{'Treehouse of Horror X', "Treehouse of Horror 10"},
		{'Treehouse of Horror XI', "Treehouse of Horror 11"},
		{'Treehouse of Horror XII', "Treehouse of Horror 12"},
		{'Treehouse of Horror XIII', "Treehouse of Horror 13"},
		{'Treehouse of Horror XIV', "Treehouse of Horror 14"},
		{'Treehouse of Horror XV', "Treehouse of Horror 15"},
		{'Treehouse of Horror XVI', "Treehouse of Horror 16"},
		{'Treehouse of Horror XVII', "Treehouse of Horror 17"},
		{'Treehouse of Horror XVIII', "Treehouse of Horror 18"},
		{'Treehouse of Horror XIX', "Treehouse of Horror 19"},
		{'Treehouse of Horror XX', "Treehouse of Horror 20"}
	})
end--]]

function p:test_3_2_roman_sandbox()
	self:preprocess_equals_many('{{#invoke:Sort title/sandbox|testcases|', '}}', {
		{'Treehouse of Horror', "Treehouse of Horror"},
		{'Treehouse of Horror 6', "Treehouse of Horror 6"},
		{'The Treehouse of Horror VI', "Treehouse of Horror 6, The"},
		{'Words with abbreviation I.V.Not.roman.', "Words with abbreviation I.V.Not.roman."},
		{'Words with abbreviation S.H.I.E.L', "Words with abbreviation S.H.I.E.L"},
		{'Treehouse of Horror I', "Treehouse of Horror 1"},
		{'Treehouse of Horror II', "Treehouse of Horror 2"},
		{'Treehouse of Horror III', "Treehouse of Horror 3"},
		{'Treehouse of Horror IV', "Treehouse of Horror 4"},
		{'Treehouse of Horror V', "Treehouse of Horror 5"},
		{'Treehouse of Horror VI', "Treehouse of Horror 6"},
		{'Treehouse of Horror VII', "Treehouse of Horror 7"},
		{'Treehouse of Horror VIII', "Treehouse of Horror 8"},
		{'Treehouse of Horror IX', "Treehouse of Horror 9"},
		{'Treehouse of Horror X', "Treehouse of Horror 10"},
		{'Treehouse of Horror XI', "Treehouse of Horror 11"},
		{'Treehouse of Horror XII', "Treehouse of Horror 12"},
		{'Treehouse of Horror XIII', "Treehouse of Horror 13"},
		{'Treehouse of Horror XIV', "Treehouse of Horror 14"},
		{'Treehouse of Horror XV', "Treehouse of Horror 15"},
		{'Treehouse of Horror XVI', "Treehouse of Horror 16"},
		{'Treehouse of Horror XVII', "Treehouse of Horror 17"},
		{'Treehouse of Horror XVIII', "Treehouse of Horror 18"},
		{'Treehouse of Horror XIX', "Treehouse of Horror 19"},
		{'Treehouse of Horror XX', "Treehouse of Horror 20"},
		{'7:15 A.M.', "7:15 A.M."},
		{'The House of L', "House of L, The"},
	})
end

return p