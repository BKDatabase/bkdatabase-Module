-- Ví dụ các trường hợp kiểm thử đơn vị cho [[Mô đun:Infobox]]. Nhấn vào trang thảo luận để
-- chạy các trường hợp kiểm thử.
local p = require('Mô đun:UnitTests')

function p:test_hello()
    self:preprocess_equals_preprocess_many('{{infobox/sandbox', '}}', '{{Infobox', '}}', {
        {[=[
            |label1  = Nhãn 1
            |data1   = Dữ liệu 1
        ]=]},
    }, {nowiki = 'yes'})
end

function p:test_ids()
    self:preprocess_equals_preprocess_many('{{infobox/sandbox', '}}', '{{Infobox', '}}', {
        {[=[
            |label2    = Nhãn 2
            |labelid2  = lable
            |data2     = Dữ liệu 2
            |dataid2   = data
            |rowid1    = row
            |header1   = Đầu đề 1
            |headerid1 = header
        ]=]},
    }, {nowiki = 'yes'})
end

function p:test_ids_name()
    self:preprocess_equals_preprocess_many('{{infobox/sandbox', '}}', '{{Infobox', '}}', {
        {[=[
            |name      = qw er tz
            |label2    = Nhãn 2
            |labelid2  = lable
            |data2     = Dữ liệu 2
            |dataid2   = data
            |rowid1    = row
            |header1   = Đầu đề 1
            |headerid1 = header
        ]=]},
    }, {nowiki = 'yes'})
end

return p
