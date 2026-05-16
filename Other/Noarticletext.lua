-- Các hàm hỗ trợ các thông điệp [[MediaWiki:Noarticletext]] và
-- [[MediaWiki:Noarticletext-nopermission]].
local p = {}
local vietnamese = require "Module:Quốc ngữ"
local lang = mw.getContentLanguage()

function p._variants(title)
    local namespace = title.nsText
    local pageName = title.text
    local caseFuncs = {
        lang.lc,        -- Viết thường toàn văn bản
        lang.uc,        -- Viết hoa toàn văn bản
        lang.uc,        -- Viết hoa toàn văn bản
    }
    local spellingFuncs = {
        vietnamese._toTraditionalTones, -- Đổi thành dấu cũ
        vietnamese._toModernTones,      -- Đổi thành dấu mới
    }
    
    local variants = {}
    if mw.ustring.len(pageName) > 3 then
	    for i, caseFunc in ipairs(caseFuncs) do
	        local caseVariant = caseFunc(lang, pageName)
	        if lang:ucfirst(caseVariant) ~= pageName and
	            mw.title.makeTitle(namespace, caseVariant).exists then
	            table.insert(variants, lang:ucfirst(caseVariant))
	            break
	        end
	    end
    end
    
    for i, spellingFunc in ipairs(spellingFuncs) do
        local spellingVariant = spellingFunc(pageName)
        if lang:ucfirst(spellingVariant) ~= pageName
            and mw.title.makeTitle(namespace, spellingVariant).exists then
            table.insert(variants, lang:ucfirst(spellingVariant))
            break
        end
    end
    
    return variants
end

p["trang tương tự"] = function (frame)
    local title = mw.title.getCurrentTitle()
    local variants = p._variants(title)
    if #variants < 1 then return end
    
    local namespace = mw.ustring.gsub(title.nsText, "_", " ")
    for i, v in ipairs(variants) do
        local variant = variants[i]
        if #namespace > 0 then variant = namespace .. ":" .. variant end
        variants[i] = tostring(mw.message.new("bkdatabase-quotationmarks",
            "[[:" .. variant .. "]]"))
    end
    
    local list = table.concat(variants, ", ")
    return tostring(mw.message.new("bkdatabase-didyoumean", list))
end

return p
