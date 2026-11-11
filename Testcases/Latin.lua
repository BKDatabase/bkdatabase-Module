-- Unit tests for [[Module:Latin]]. Click talk page to run tests.

local p = require('Module:UnitTests')

function p:test1()
    self:preprocess_equals_preprocess(
        '{{#invoke:Latin/sandbox|removeaccents| Ä ä Ö ö Ü ü }}',
        '{{#invoke:Latin|removeaccents| Ä ä Ö ö Ü ü }}'
        )
end

function p:test2()
    self:preprocess_equals_preprocess(
        '{{#invoke:Latin/sandbox|removeaccents| Ä ä Ö ö Ü ü |German= }}',
        '{{#invoke:Latin|removeaccents| Ä ä Ö ö Ü ü |German= }}'
        )
end

function p:test3()
    self:preprocess_equals_preprocess(
        '{{#invoke:Latin/sandbox|removeaccents| Ä ä Ö ö Ü ü |German=yes }}',
        '{{#invoke:Latin|removeaccents| Ä ä Ö ö Ü ü |German=yes }}'
        )
end

return p