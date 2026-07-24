local p = require('Module:UnitTests')

function p:test_talk()
    self:preprocess_equals('{{#invoke:UserLinks|single|t|user=Ví dụ }}', '[[Thảo luận Thành viên:Ví dụ|thảo luận]]')
    self:preprocess_equals('{{#invoke:UserLinks/sandbox|single|u|user=Ví dụ}}', '[[:Thành viên:Ví dụ|Ví dụ]]')
    self:preprocess_equals('{{#invoke:UserLinks/sandbox|single|sul2|user=Ví dụ}}', '[https://tools.wmflabs.org/guc/index.php?lang=vi&user=V%C3%AD+d%E1%BB%A5 đóng góp toàn cục]')
    self:preprocess_equals('{{#invoke:UserLinks/sandbox|single|c|user=Ví dụ}}', '[[:Đặc biệt:Đóng góp/Ví dụ|đóng góp]]')
end

return p