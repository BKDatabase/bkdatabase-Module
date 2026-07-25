--------------------------------------------------------------------------------
-- This module implements the {{Uses TNT}} template.
--
-- @module usesTNT
-- @alias  p
-- @author [[c:User:ExE Boss]]
-- @require [[Module:Uses TNT/config]]
-- @require [[Module:Arguments]]
-- @require [[Module:Func]]
-- @require [[Module:List]]
-- @require [[Module:Message box]]
-- @require [[Module:TNT]]
-- @require [[Module:TNTTools]]
-- @require [[Module:TableTools]]
-- @require [[Module:Yesno]]
--------------------------------------------------------------------------------

require("strict");
local checkType = require("libraryUtil").checkType;
local getArgs = require("Module:Arguments").getArgs;
local yesno = require("Module:Yesno");
local lists = require("Module:List");
local tableTools = require("Module:TableTools");
local messageBox = require("Module:Message box");
local TNTTabFull = require("Module:TNTTools").TNTTabFull;

local format = require("Module:Func")
	.bind(require("Module:TNT").format, "I18n/Uses TNT.tab");

local p = {};

local function getConfig()
	return mw.loadData("Module:Uses TNT/config");
end

function p.main(frame)
	local args = getArgs(frame, {
		wrappers = {
			"Template:Uses TNT",
		},
	});
	return p._main(args);
end

function p._main(args, cfg)
	checkType("_main", 1, args, "table");
	checkType("_main", 2, cfg, "table", true);
	cfg = cfg or getConfig();

	local tabFiles = tableTools.compressSparseArray(args);
	local box = p.renderBox(tabFiles, cfg, args);
	local trackingCategories = p.renderTrackingCategories(args, tabFiles, nil, cfg);
	return box .. trackingCategories;
end

function p.renderBox(tabFiles, cfg, args)
	checkType("renderBox", 1, tabFiles, "table");
	checkType("renderBox", 2, cfg, "table", true);
	checkType("renderBox", 3, args, "table", true);
	cfg = cfg or getConfig();

	local nsType = mw.title.getCurrentTitle():inNamespaces(828, 829) and 'module' or 'template';
	local boxArgs = {};

	if #tabFiles < 1 then
		if cfg["allow_wishes"] or yesno(args and args.wish) then
			boxArgs.text = format("wishtext-" .. nsType);
		else
			boxArgs.text = string.format('<strong class="error">%s</strong>', format("error-emptylist"));
		end
	else
		local tabFileLinks = {};
		for i, tabFile in ipairs(tabFiles) do
			local tabFileFull = TNTTabFull(tabFile);
			tabFileLinks[i] = string.format("[[:Data:%s|%s]]", tabFileFull, tabFileFull);
		end
		local tabFilesList = lists.makeList("bulleted", tabFileLinks);
		boxArgs.text = format("header-" .. nsType) .. "\n" .. tabFilesList;
	end

	boxArgs.type = "notice";
	boxArgs.small = true;
	boxArgs.image = cfg["logo_link"]
		and string.format("[[File:JSON_vector_logo.svg|35px|link=%s]]", cfg["logo_link"], format("logo-alt"))
		or format("logo-alt");

	return messageBox.main("mbox", boxArgs);
end

function p.renderTrackingCategories(args, tabFiles, titleObj, cfg)
	checkType("renderTrackingCategories", 1, args, "table");
	checkType("renderTrackingCategories", 2, tabFiles, "table");
	checkType("renderTrackingCategories", 3, titleObj, "table", true);
	checkType("renderTrackingCategories", 4, cfg, "table", true);

	if yesno(args.nocat) then
		return '';
	end

	cfg = cfg or getConfig();

	local cats = {};

	-- Error category
	if #tabFiles < 1 and not (cfg["allow_wishes"] or yesno(args.wish)) and cfg["error_category"] then
		cats[#cats + 1] = cfg["error_category"];
	end

	-- [[Module:TNT]] category
	titleObj = titleObj or mw.title.getCurrentTitle();
	if (
		(titleObj.namespace == 10 or titleObj.namespace == 828)
		and not cfg["subpage_blacklist"][titleObj.subpageText]
	) then
		local category = args.category;
		if not category then
			if (cfg["allow_wishes"] or yesno(args.wish)) and #tabFiles < 1 then
				category = cfg["wish_category"];
			else
				category = cfg["default_category"];
			end
		end
		if category then
			cats[#cats + 1] = category;
		end
	end

	for i, cat in ipairs(cats) do
		cats[i] = string.format("[[Category:%s]]", cat);
	end
	return table.concat(cats);
end

return p;