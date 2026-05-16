---Các công cụ để xử lý văn bản quốc ngữ tiếng Việt.
local p = {}

---Biến đổi văn bản theo kiểu dấu truyền thống.
p["đổi dấu cũ"] = function (frame)
    return (p._toTraditionalTones(frame.args[1]))
end
function p._toTraditionalTones(text)
    return mw.ustring.gsub(text, "%a+", function (word)
        if mw.ustring.match(word, "^qu[yýỳỷỹỵ]$") then return word end
        return mw.ustring.gsub(word, "%a%a$", {
            ["oá"] = "óa", ["oà"] = "òa", ["oả"] = "ỏa", ["oã"] = "õa", ["oạ"] = "ọa",
            ["oé"] = "óe", ["oè"] = "òe", ["oẻ"] = "ỏe", ["oẽ"] = "õe", ["oẹ"] = "ọe",
            ["uý"] = "úy", ["uỳ"] = "ùy", ["uỷ"] = "ủy", ["uỹ"] = "ũy", ["uỵ"] = "ụy"
        })
    end)
end

---Biến đổi văn bản theo kiểu dấu hiện đại.
p["đổi dấu mới"] = function (frame)
    return (p._toModernTones(frame.args[1]))
end
function p._toModernTones(text)
    return mw.ustring.gsub(text, "%a+", function (word)
        return mw.ustring.gsub(word, "%a%a$", {
            ["óa"] = "oá", ["òa"] = "oà", ["ỏa"] = "oả", ["õa"] = "oã", ["ọa"] = "oạ",
            ["óe"] = "oé", ["òe"] = "oè", ["ỏe"] = "oẻ", ["õe"] = "oẽ", ["ọe"] = "oẹ",
            ["úy"] = "uý", ["ùy"] = "uỳ", ["ủy"] = "uỷ", ["ũy"] = "uỹ", ["ụy"] = "uỵ"
        })
    end)
end

---Các dấu thanh kết hợp tiếng Việt trong Unicode.
p.combiningToneMarks = mw.ustring.char(
    0x300,  -- à
    0x301,  -- á
    0x303,  -- ã
    0x309,  -- ả
    0x323   -- ạ
)

---Các dấu phụ kết hợp tiếng Việt trong Unicode.
p.combiningAccentMarks = mw.ustring.char(
    0x302,  -- â
    0x306,  -- ă
    0x308,  -- ü (trung cổ, dành cho [[Bản mẫu:R:VBL]])
    0x31b   -- ơ
)

---Lọc bỏ dấu khỏi văn bản.
p["lọc bỏ dấu"] = function (frame)
    return (p._removeDiacritics(frame.args[1],
        not frame.args.thanh or tonumber(frame.args.thanh) == 1,
        not frame.args["phụ"] or tonumber(frame.args["phụ"]) == 1,
        not frame.args["đ"] or tonumber(frame.args["đ"]) == 1))
end
function p._removeDiacritics(text, toneMarks, accentMarks, stroke)
    text = mw.ustring.toNFD(text)
    if toneMarks then
        text = mw.ustring.gsub(text, "[" .. p.combiningToneMarks .. "]", "")
    end
    if accentMarks then
        text = mw.ustring.gsub(text, "[" .. p.combiningAccentMarks .. "]", "")
    end
    if stroke then
        text = mw.ustring.gsub(text, "[Đđ]", {["Đ"] = "D", ["đ"] = "d"})
    end
    return mw.ustring.toNFC(text)
end

---Các chữ tiếng Việt dùng trong comp().
p.letters = "aAàÀảẢãÃáÁạẠăĂằẰẳẲẵẴắẮặẶâÂầẦẩẨẫẪấẤậẬbBcCdDđĐeEèÈẻẺẽẼéÉẹẸêÊềỀểỂễỄếẾệỆfFgGhHiIìÌỉỈĩĨíÍịỊjJkKlLmMnNoOòÒỏỎõÕóÓọỌôÔồỒổỔỗỖốỐộỘơƠờỜởỞỡỠớỚợỢpPqQrRsStTuUùÙủỦũŨúÚụỤưƯừỪửỬữỮứỨựỰvVwWxXyYỳỲỷỶỹỸýÝỵỴzZ"

---So sánh hai đơn tiết theo thứ tự sắp xếp từ điển tiếng Việt.
function p.compWord(word1, word2)
    if mw.ustring.find(word1, word2, 1, true) == 0 then return false end
    if mw.ustring.find(word2, word1, 1, true) == 0 then return true end
    
    do
        local func1, static1, var1 = mw.ustring.gmatch(word1, "[" .. p.letters .. "]")
        local func2, static2, var2 = mw.ustring.gmatch(word2, "[" .. p.letters .. "]")
        while true do
            local c1 = func1(static1, var1)
            local c2 = func2(static2, var2)
            if c1 == nil or c2 == nil then break end
            
            local idx1 = mw.ustring.find(p.letters, c1, 1, true)
            local idx2 = mw.ustring.find(p.letters, c2, 1, true)
            if idx1 and idx2 then
                if idx1 < idx2 then return true end
                if idx1 > idx2 then return false end
            end
        end
    end
    
    return word1 < word2
end

---So sánh hai chuỗi theo thứ tự sắp xếp từ điển tiếng Việt.
function p.comp(text1, text2)
    if text1 == text2 then return false end
    
    do
        local func1, static1, var1 = mw.ustring.gmatch(text1, "%a+")
        local func2, static2, var2 = mw.ustring.gmatch(text2, "%a+")
        while true do
            local word1 = func1(static1, var1)
            local word2 = func2(static2, var2)
            if word1 == nil or word2 == nil then break end
            
            if word1 ~= word2 then
                local lower1 = mw.ustring.lower(word1)
                local lower2 = mw.ustring.lower(word2)
                local noTones1 = p._removeDiacritics(lower1, true, false, false)
                local noTones2 = p._removeDiacritics(lower2, true, false, false)
                
                -- So con chữ.
                local oneLess = p.compWord(noTones1, noTones2)
                if oneLess ~= 0 then return oneLess end
                
                -- So con chữ bất kể hoa/thường.
                oneLess = p.compWord(lower1, lower2)
                if oneLess ~= 0 then return oneLess end
                
                -- So thanh điệu.
                oneLess = p.compWord(word1, word2)
                assert(oneLess ~= 0)
                return oneLess
            end
        end
    end
    
    return text1 < text2
end

return p
