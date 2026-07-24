--[[
SDcat
Module to check whether local short description matches that on wikibase
--]]

local p = {}

-------------------------------------------------------------------------------
--[[
setCat has the qid of a wikibase entity passed as |qid=
(it defaults to the associated qid of the current article if omitted)
and the local short description passed as |sd=
It returns a category if there is an associated wikibase entity.
It returns one of the following tracking categories, as appropriate:
* Category:Short description matches wikibase (case-insensitive)
* Category:Short description is different from wikibase
* Category:Short description with empty wikibase description
For testing purposes, a link prefix |lp= may be set to ":" to make the categories visible.
--]]

-- function exported for use in other modules
-- (local short description, wikibase entity-ID, link prefix)
p._setCat = function(sdesc, itemID, lp)
	if not mw.wikibase then return nil end
	if itemID == "" then itemID = nil end
	-- wikibase description field
	local wdesc = (mw.wikibase.getDescription(itemID) or ""):lower()
	if wdesc == "" then
		return "[[" .. lp .. "Thể loại:Mô tả ngắn không có trên Wikibase]]"
	elseif wdesc == sdesc then
		return "[[" .. lp .. "Thể loại:Mô tả ngắn giống như Wikibase]]"
	else
		return "[[" .. lp .. "Thể loại:Mô tả ngắn khác với Wikibase]]"
	end
end

-- function exported for call from #invoke
p.setCat = function(frame)
	local args
	if frame.args.sd then
		args = frame.args
	else
		args = frame:getParent().args
	end
	-- local short description
	local sdesc = mw.text.trim(args.sd or ""):lower()
	-- wikibase entity-ID
	local itemID = mw.text.trim(args.qid or "")
	-- link prefix, strip quotes
	local lp = mw.text.trim(args.lp or ""):gsub('"', '')
	return p._setCat(sdesc, itemID, lp)
end

return p