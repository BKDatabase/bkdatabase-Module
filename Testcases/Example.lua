-- Unit tests for [[Module:Example]]. Click talk page to run tests.
local p = require('Module:UnitTests')
function p:test_hello()
    self:preprocess_equals('{{#invoke:Example | hello}}', 'Hello World!')
end

function p:test_hello_to()
    self:preprocess_equals('{{#invoke:Example|hello_to|Fred}}', 'Hello, Fred!')
end

function p:test_count_fruit()
    self:preprocess_equals('{{#invoke:Example|count_fruit|bananas=5|apples=3}}', 'I have 5 bananas and 3 apples')
    self:preprocess_equals('{{#invoke:Example|count_fruit|bananas=1|apples=1}}', 'I have 1 banana and 1 apple')
    self:preprocess_equals('{{#invoke:Example|count_fruit|bananas=Not a number|apples=Not a number}}', 'I have 0 bananas and 0 apples')
    self:preprocess_equals('{{#invoke:Example|count_fruit}}', 'I have 0 bananas and 0 apples')

end

function p:test_Name2()
    self:preprocess_equals('{{#invoke:Example|Name2}}', 'Lonely')
    self:preprocess_equals('{{#invoke:Example|Name2|1}}', 'Lonely')
    self:preprocess_equals('{{#invoke:Example|Name2|1|2}}', 'Be positive!')
    self:preprocess_equals('{{#invoke:Example|Name2|2|1}}', '1')
end

return p
