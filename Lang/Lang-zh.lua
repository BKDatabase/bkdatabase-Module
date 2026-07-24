require('strict')

local p = {}

-- articles in which traditional Chinese preceeds simplified Chinese
local t1st = {
	["Sự kiện 228"] = true,
	["Lịch Trung Hoa"] = true,
	["Lippo Centre, Hồng Kông"] = true,
	["Trung Hoa Dân Quốc"] = true,
	["Republic of China at the 1924 Summer Olympics"] = true,
	["Đài Loan"] = true,
	["Đài Loan (đảo)"] = true,
	["Tỉnh Đài Loan"] = true,
	["Wei Boyang"] = true,
}

-- the labels for each part 
local labels = {
	["c"] = "tiếng Trung",
	["s"] = "giản thể",
	["t"] = "phồn thể",
	["hv"] = "Hán-Việt",
	["p"] = "bính âm",
	["tp"] = "bính âm thông dụng",
	["w"] = "Wade–Giles",
	["j"] = "Việt bính",
	["cy"] = "Yale Quảng Đông",
	["sl"] = "Lưu Tích Tường",
	["poj"] = "Bạch thoại tự",
	["zhu"] = "chú âm phù hiệu",
	["l"] = "nghĩa đen",
	["tr"] = "tạm dịch",
}

-- article titles for wikilinks for each part
local wlinks = {
	["c"] = "Tiếng Trung Quốc",
	["s"] = "Chữ Hán giản thể",
	["t"] = "Chữ Hán phồn thể",
	["hv"] = "Phiên âm Hán-Việt",
	["p"] = "Bính âm Hán ngữ",
	["tp"] = "Bính âm thông dụng",
	["w"] = "Wade–Giles",
	["j"] = "Việt bính",
	["cy"] = "Latinh hóa tiếng Quảng Đông kiểu Yale",
	["sl"] = "Latinh hóa kiểu Lưu Tích Tường",
	["poj"] = "Phiên âm Bạch thoại",
	["zhu"] = "Chú âm phù hiệu",
	["l"] = "Dịch nghĩa đen",
	["tr"] = "Dịch thuật",
}

-- for those parts which are to be treated as languages their ISO code
local ISOlang = {
	["c"] = "zh",
	["t"] = "zh-Hant",
	["s"] = "zh-Hans",
	["hv"] = "vi",
	["p"] = "zh-Latn",
	["tp"] = "zh-Latn-tongyong",
	["w"] = "zh-Latn-wadegile",
	["j"] = "yue-Latn-jyutping",
	["cy"] = "yue-Latn",
	["sl"] = "yue-Latn",
	["poj"] = "nan-Latn",
	["zhu"] = "zh-Bopo",
}

local italic = {
	["p"] = true,
	["tp"] = true,
	["w"] = true,
	["j"] = true,
	["cy"] = true,
	["sl"] = true,
	["poj"] = true,
}

local superscript = {
	["w"] = true,
	["sl"] = true,
}

-- Categories for different kinds of Chinese text
local cats = {
	["c"] = "[[Thể loại:Bài viết có văn bản tiếng Trung Quốc]]",
	["s"] = "[[Thể loại:Bài viết có chữ Hán giản thể]]",
	["t"] = "[[Thể loại:Bài viết có chữ Hán phồn thể]]",
}

function p.Zh(frame)
	-- load arguments module to simplify handling of args
	local getArgs = require('Mô đun:Arguments').getArgs
	
	local args = getArgs(frame)
	return p._Zh(args)
end
	
function p._Zh(args)
	if args["link"] then args["links"] = args["link"]; end
	if args["label"] then args["labels"] = args["label"]; end
		
	local uselinks = args["links"] ~= "no" -- whether to add links
	local uselabels = args["labels"] ~= "no" -- whether to have labels
	local capfirst = args["scase"] ~= nil
	local out = nil -- which term to put before the brackets
	local usebrackets = 0 -- whether to have bracketed terms
	local numargs = 0
	
	if args["out"] then
		out = args["out"]
		usebrackets = 1
	end

	local t1 = false -- whether traditional Chinese characters go first
	local j1 = false -- whether Cantonese Romanisations go first
	local poj1 = false -- whether Hokkien Romanisations go first
	local testChar
	if (args["first"]) then
	 	 for testChar in mw.ustring.gmatch(args["first"], "%a+") do
			if (testChar == "t") then
				t1 = true
			end
			if (testChar == "j") then
				j1 = true
			end
			if (testChar == "poj") then
				poj1 = true
			end
		end
	end
	if (t1 == false) then
		local title = mw.title.getCurrentTitle()
		t1 = t1st[title.text] == true
	end

	-- based on setting/preference specify order
	local orderlist = {"c", "s", "t", "hv", "p", "tp", "w", "j", "cy", "sl", "poj", "zhu", "l", "tr"}
	if (t1) then
		orderlist[2] = "t"
		orderlist[3] = "s"
	end
	if (j1) then
		orderlist[4] = "j"
		orderlist[5] = "cy"
		orderlist[6] = "sl"
		orderlist[7] = "p"
		orderlist[8] = "tp"
		orderlist[9] = "w"
	end
	if (poj1) then
		orderlist[4] = "poj"
		orderlist[5] = "p"
		orderlist[6] = "tp"
		orderlist[7] = "w"
		orderlist[8] = "j"
		orderlist[9] = "cy"
		orderlist[10] = "sl"
	end

	-- rename rules. Rules to change parameters and labels based on other parameters
	if args["v"] then
		-- v an alias for hv (Hán-Việt)
		args["hv"] = args["v"]
	end
	if args["hp"] then
		-- hp an alias for p ([hanyu] pinyin)
		args["p"] = args["hp"]
	end
	if args["tp"] then
		-- if also Tongyu pinyin use full name for Hanyu pinyin
		labels["p"] = "bính âm Hán ngữ"
	end
	
	if (args["s"] and args["s"] == args["t"]) then
		-- Treat simplified + traditional as Chinese if they're the same
		args["c"] = args["s"]
		args["s"] = nil
		args["t"] = nil
		if out == "s" or out == "t" then
			out = "c"
		end
	elseif (not (args["s"] and args["t"])) then
		-- use short label if only one of simplified and traditional
		labels["s"] = labels["c"]
		labels["t"] = labels["c"]
	end
	if out then
		for i, v in ipairs (orderlist) do -- shift `out` to the beginning of the order list
			if v == out then
				table.remove(orderlist, i)
				table.insert(orderlist, 1, v)
				break
			end
		end
	end

	if (out == "c" and args["s"]) then usebrackets = 2; end

	local body = "" -- the output string
	local params -- for creating HTML spans
	local label -- the label, i.e. the bit preceeding the supplied text
	local val -- the supplied text
	
	-- go through all possible fields in loop, adding them to the output
	for i, part in ipairs(orderlist) do
		if (args[part]) then
			numargs = numargs + 1
			-- build label
			label = ""
			if (uselabels) then
				label = labels[part]
				if (capfirst) then
					label = mw.language.getContentLanguage():ucfirst(label)
					capfirst = false
				end
				if (uselinks and part ~= "l" and part ~= "tr") then
					label = "[[w:vi:" .. wlinks[part] .. "|" .. label .. "]]"
				end
				if (part == "l" or part == "tr") then
					label = "<abbr title=\"" .. wlinks[part] .. "\"><small>" .. label .. "</small></abbr>"
				else
					label = label .. "&colon;"
				end
				label = label .. " "
			end
			-- build value
			val = args[part]
			if (cats[part]) and mw.title.getCurrentTitle().namespace == 0 then
				-- if has associated category AND current page in article namespace, add category
				val = cats[part] .. val
			end
			if (ISOlang[part]) then
				-- add span for language if needed
				params = {["lang"] = ISOlang[part]}
				val = mw.text.tag({name="span",attrs=params, content=val})
			elseif (part == "l") then
				local terms = ""
				-- put individual, potentially comma-separated glosses in single-quotes
				for term in val:gmatch("[^;,]+") do
					term = string.gsub(term, "^([ \"']*)(.*)([ \"']*)$", "%2")
					terms = terms .. "&apos;" .. term .. "&apos;, "
				end
				val = string.sub(terms, 1, -3)
			elseif (part == "tr") then
				-- put translations in double quotes
				val = "&quot;" .. val .. "&quot;"
			end
			if (italic[part]) then
				-- italicise
				val = "<i>" .. val .. "</i>"
			end
			if string.match(val, "</?sup>") then val = val.."[[Thể loại:Trang cho thẻ sup vào bản mẫu Zh]]" end
			if (superscript[part]) then
				-- superscript
				val = val:gsub("(%d)", "<sup>%1</sup>"):gsub("(%d)</sup>%*<sup>(%d)", "%1*%2"):gsub("<sup><sup>([%d%*]+)</sup></sup>", "<sup>%1</sup>")
			end
			-- add both to body
			if numargs == usebrackets then
				-- opening bracket after the `out` term
				body = body .. label .. val .. " ("
			else
				body = body .. label .. val .. "; "
			end
		end
	end
	
	if (body > "") then -- check for empty string
		body = string.sub(body, 1, -3) -- chop off final semicolon and space
		if out and numargs > usebrackets then
			-- closing bracket after the rest of the terms
			body = body .. "&rpar;"
		end
		return body
	else --no named parameters; see if there's a first parameter, ignoring its name
		if (args[1]) then
			-- if there is treat it as Chinese
			label = ""
			if (uselabels) then
				label = labels["c"]
				if (uselinks) then
					label = "[[w:vi:" .. wlinks["c"] .. "|" .. label .. "]]"
				end
				label = label .. "&colon; "
			end
			-- default to show links and labels as no options given
			if mw.title.getCurrentTitle().namespace == 0 then
				-- if current page in article namespace
				val = cats["c"] .. args[1]
			else
				val = args[1]
			end
			params = {["lang"] = ISOlang["c"]}
			val = mw.text.tag({name="span",attrs=params, content=val})
			return label .. val
		end
		return ""
	end
end

return p