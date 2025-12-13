local ToolbarBuilder = require('Mô đun:Toolbar')

local p = {} -- Page object
local trackingCategories = {} -- Table for storing the tracking categories.
local demo

-- Define a custom error message for this module.
local function err(msg, section)
	local help
	if section then
		help = ' ([[Bản mẫu:Page-multi#' .. section .. '|help]])'
	else
		help = ''
	end
	local cat
	if demo == 'yes' then
		cat = ''
	else
		cat = '[[Thể loại:Trang liên kết nhúng có các lỗi]]'
	end
	return '<span class="error">Lỗi [[Bản mẫu:Page-multi|Page-multi]]: ' .. msg 
        .. help .. '.</span>' .. cat
end

----------------------------------------------------------------------------------------------
--      To add more link types, write a function that produces an individual link, and put  --
--      it at the bottom of the list below. Then, add a link code for your function to the  --
--      "linktypes" table. Try and make the code three letters or less. 
--
--      If you want more helper strings, you can define them in the generatePageDataStrings --
--      function below.                                                                     --
----------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
--                                LINK FUNCTIONS START                                      --
----------------------------------------------------------------------------------------------

local function makePageLink()
	return p.fullText and '[[:' .. p.fullText .. '|' .. p.fullText .. ']]' or ''
end

local function makeTalkLink()
	return '[[' .. tostring(p.talkPageTitle) .. '|thảo luận]]'
end

local function makeTalkOrSubjectLink()
	if p.isTalkPage then
		return '[[:' .. tostring(p.subjectPageTitle) .. '|trang chính]]'
	else
		return '[[' .. tostring(p.talkPageTitle) .. '|thảo luận]]'
	end
end

local function makeWhatLinksHereLink()
	return '[[Đặc_biệt:Liên_kết_đến_đây/' .. p.fullText .. '|liên kết]]'
end

local function makeRelatedChangesLink()
	return '[[Đặc_biệt:Thay_đổi_liên_quan/' .. p.fullText .. '|liên quan]]'
end

local function makeEditLink()
	local url = p:fullUrl( 'action=edit' );
	return '[' .. url .. ' sửa]'
end

local function makeHistoryLink()
	local url = p:fullUrl( 'action=history' );
	return '[' .. url .. ' lịch sử]'
end

local function makeWatchLink()
	local url = p:fullUrl( 'action=watch' );
	return '[' .. url .. ' theo dõi]'
end

local function makeTargetLogsLink()
	local url = mw.uri.fullUrl( 'Đặc_biệt:Nhật_trình', 'page=' .. mw.uri.encode(p.fullText) )
	return '[' .. tostring(url) .. ' nhật trình]'
end

local function makeEditFilterLogLink()
	local url = mw.uri.fullUrl( 'Đặc_biệt:Nhật_trình_sai_phạm', 'wpSearchTitle=' .. mw.uri.encode(p.fullText) )
	return '[' .. tostring(url) .. ' nhật&nbsp;trình&nbsp;bộ&nbsp;lọc&nbsp;sai&nbsp;phạm]'
end

local function StatsGrokSeURL(lang)
	local url = 'http://stats.grok.se/' .. lang .. '/latest60/' .. mw.uri.encode( p.fullText, "PATH" )
	return url
end

local function makeViewsLastMonthStatsGrokSeLink()
	return '[' .. StatsGrokSeURL('vi') .. ' số&nbsp;lần&nbsp;xem]'
end

local function pageViewsURL(project, startDate, endDate)
	local url = tostring(mw.uri.fullUrl('Toollabs:pageviews')) .. '?start=' .. startDate .. '&end=' .. endDate .. '&project=' .. project .. '&pages=' .. mw.uri.encode((string.gsub(p.fullText, " ", "_")))
	return url
end

local function makePageViews(args)
	local endDate, startDate = "", ""
	
	if args.date then
		local date = string.gsub(args.date,"-","")
		date = os.time{year=string.sub(date,1,4), month=string.sub(date,5,6), day=string.sub(date,7,8)}
		endDate = os.date("%Y-%m-%d", date - (1*86400))
		startDate = os.date("%Y-%m-%d", date - (30*86400))
	else
		endDate = os.date("%Y-%m-%d")
		startDate = os.date("%Y-%m-%d", os.time() - (60*86400))
	end
	
	return '[' .. pageViewsURL('vi.wikipedia.org', startDate, endDate) .. ' stats]'
end

----------------------------------------------------------------------------------------------
--                                   LINK FUNCTIONS END                                     --
--      To enable new link functions, add the code to the "linktypes" table directly below. --
----------------------------------------------------------------------------------------------

local linktypes = {
    {'t'   , makeTalkLink},
    {'ts'  , makeTalkOrSubjectLink},
    {'wlh' , makeWhatLinksHereLink},
    {'rc'  , makeRelatedChangesLink},
    {'edit', makeEditLink},
    {'h'   , makeHistoryLink},
    {'w'   , makeWatchLink},
    {'tl'  , makeTargetLogsLink},
    {'efl' , makeEditFilterLogLink},
    {'vlm-sgs' , makePageViews},
    {'pv' , makePageViews},
}

local function getLink(linktype, args)
    local linkNumber
    for i, value in ipairs(linktypes) do
        if value[1] == linktype then
            linkNumber = i
            break
        end
    end
    if not linkNumber then
        return err('"' .. linktype .. '" is not a valid link code', 'Not a valid link code')
    end
    local result = linktypes[linkNumber][2](args)
    if type(result) ~= 'string' then
        return err(
            'the function for code "' .. linktype .. '" did not return a string value',
            'Function did not return a string value'
        )
    end
    return result
end

local function makeToolbar(args)
    local targs = {}
    local numArgsExist = false
    for k, v in pairs(args) do
        if type(k) == 'number' and p then
            numArgsExist = true
            targs[k] = getLink(v, args)
        end
    end
    targs.style = args.small and 'font-size: 90%;'
    targs.separator = args.separator or 'dot'
    targs.class = 'lx'
    
    if numArgsExist == false then
        return nil -- Don't return a toolbar if no numeric arguments exist. -- this bit looks odd
    else
        return ToolbarBuilder.main(targs)
    end
end

local function generatePageDataStrings(args)
    -- If the page name is absent or blank, return an error and a tracking category.
    if args.page == '' or not args.page then
        return err('không có trang phát hiện')
    end
    local noError
    noError, p = pcall(mw.title.new, args.page)
    if not noError then
    	return err('pcall mw.title thất bại')
	end
	if args.exists and (not p or p['id'] == 0) then
    	return err('không tìm thấy trang')
    end
end

local function generateTrackingCategories()
    if demo == 'yes' then
        return ''
    else
        return table.concat(trackingCategories)
    end
end

-- This function generates a table of all available link types, with their previews.
-- It is used in the module documentation.
local function getLinkTable(args)
    demo = args.demo -- Set the demo variable.
    -- Generate the page data strings and return any errors.
    local dataStringError = generatePageDataStrings(args)
    if dataStringError then
        return dataStringError
    end
    
    -- Build a table of all of the links.
    local result = '<table class="wikitable plainlinks sortable">'
        .. '\n<tr><th>Mã</th><th>Xem trước</th></tr>'
    for i, value in ipairs(linktypes) do
        local code = value[1]
        result = result .. "\n<tr><td>'''" .. code .. "'''</td><td>" .. getLink(code, args) .. '</td></tr>'
    end
    result = result .. '\n</table>'
    
    return result
end

local function getSingleLink(args)
    demo = args.demo -- Set the demo variable.
    -- Generate the page data strings and return any errors.
    local dataStringError = generatePageDataStrings(args)
    if dataStringError then
        return dataStringError
    end
    
    local linktype = args[1]
    if not linktype then 
        return err('không có kiểu liên kết được chỉ định')
    end
    local result = getLink(linktype, args)
    result = result .. generateTrackingCategories()
    return result
end

local function getLinksToolbar(args)
    demo = args.demo -- Set the demo variable.
    -- Generate the page data strings and return any errors.
    local dataStringError = generatePageDataStrings(args)
    if dataStringError then
        return dataStringError
    end    
    
    -- Build the template output.
    local result = makeToolbar(args) -- Get the toolbar contents.
    result = (result or '') .. generateTrackingCategories()
    return result
end

local function getLinks(args)
	local result = getLinksToolbar(args)

	if result then
		if args.sup then
			result = '<sup>' .. result .. '</sup>'
		end
		result = '&nbsp;' .. result
	else
		result = '' -- If there are no links specified, don't return the toolbar at all.
	end
	if args.nopage then
		result = '<span>' .. result .. '</span>'
	else
		if p then
			result = '<span>' .. makePageLink() .. result .. '</span>'
		else
			result = '<span>[[' .. args.page .. ']]' .. result .. '</span>'
		end
	end

	return result
end

local function getExampleLinks(args)
    -- This function enables example output without having to specify any
    -- parameters to #invoke.
    args.demo = 'yes'
    args.page = 'Ví dụ'
    return getLinks(args)
end

local function makeWrapper(func)
    return function (frame)
        -- If called via #invoke, use the args passed into the invoking template.
        -- Otherwise, for testing purposes, assume args are being passed directly in.
        local origArgs
        if frame == mw.getCurrentFrame() then
            origArgs = frame:getParent().args
            for k, v in pairs(frame.args) do
                origArgs = frame.args
                break
            end
        else
            origArgs = frame
        end
 
        -- Strip whitespace, and treat blank arguments as nil.
        -- 'page', and 'separator' have different behaviour depending on
        -- whether they are blank or nil, so keep them as they are.
        local args = {}
        for k, v in pairs(origArgs) do
            v = mw.text.trim(v)
            if v ~= '' or k == 'page' or k == 'separator' then
                args[k] = v
            end
        end
    
        return func(args)
    end
end

return {
    main = makeWrapper(getLinks),
    single = makeWrapper(getSingleLink),
    toolbar = makeWrapper(getLinksToolbar),
    linktable = makeWrapper(getLinkTable),
    example = makeWrapper(getExampleLinks)
}
