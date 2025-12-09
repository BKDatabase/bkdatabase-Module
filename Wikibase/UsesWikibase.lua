local p = {}

function p.usesProperty(frame)
	local args = frame.getParent(frame).args or nil
	if mw.text.trim(args[1] or '') == '' then
		args = frame.args
	end
	local result = ''
	local ii = 1
	while true do
		local p_num = mw.text.trim(args[ii] or '')
		if p_num ~= '' then
			local label = mw.wikibase.label(p_num) or "KHÔNG CÓ NHÃN"
			result = result .. "<ul><li>[[Tập tin:Disc Plain blue dark.svg|middle|4px|link=]] <b><i>[[Property:" .. p_num .. "|" .. label .. " <small>(" .. string.upper(p_num) .. ")</small>]]</i></b> (xem <span class='plainlinks'>[https://query.wikidata.org/embed.html#SELECT%20%3FWikiData_item_%20%3FWikiData_item_Label%20%3Fvalue%20%3FvalueLabel%20%3FEnglish_WikiPedia_article%20%23Show%20data%20in%20this%20order%0A%7B%0A%09%3FWikiData_item_%20wdt%3A" .. p_num .. "%20%3Fvalue%20.%20%23Collecting%20all%20items%20which%20have%20" .. p_num .. "%20data%2C%20from%20whole%20WikiData%20item%20pages%0A%09OPTIONAL%20%7B%3FEnglish_WikiPedia_article%20schema%3Aabout%20%3FWikiData_item_%3B%20schema%3AisPartOf%20%3Chttps%3A%2F%2Fvi.wikipedia.org%2F%3E%20.%7D%20%23If%20collected%20item%20has%20link%20to%20English%20WikiPedia%2C%20show%20that%0A%09SERVICE%20wikibase%3Alabel%20%7B%20bd%3AserviceParam%20wikibase%3Alanguage%20%22en%22%20%20%7D%20%23Show%20label%20in%20this%20language.%20%22en%22%20is%20English.%20%20%20%0A%7D%0ALIMIT%201000 sử dụng]</span>)</li></ul>"
			ii = ii + 1
		else break
		end
	end
	return result
end
 
return p
