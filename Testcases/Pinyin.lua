-- Click talk page to run tests.
local p = require('Module:UnitTests')

function p:test_pinyin()
    self:preprocess_equals('{{#invoke:Pinyin|pinyin}}', '')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|Wan4li2 Chang2cheng2}}', 'Wànlí Chángchéng')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|She4 Diao1 yingxiongzhuan4}}', 'Shè Diāo yingxiongzhuàn')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|Ai4 Dao3 Mo2 Shi4}}', 'Ài Dǎo Mó Shì')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|Lü3 Bu4wei}}', 'Lǚ Bùwei')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|Gong1lve4}}', 'Gōnglüè')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|Xiu1ru3}}', 'Xiūrǔ')
    self:preprocess_equals('{{#invoke:Pinyin|pinyin|M4 m2 ng2 N3 Ê2 ê3}}', 'M&#x300; ḿ ńg Ň Ế e&#770;&#780;')
end

return p
