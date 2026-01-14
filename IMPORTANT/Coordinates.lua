--[=[
Mô đun này hỗ trợ [[Bản mẫu:Coord]] và các bản mẫu liên quan. Nó cung cấp vài
phương thức, nhất là:

{{#gọi:Coordinates | coord }} : Hàm tổng quát để định dạng và hiển thị các giá
trị tọa độ.

{{#gọi:Coordinates | dec2dms }} : Hàm đơn giản để chuyển đổi các giá trị thập
phân ra định dạng độ-phút-giây.

{{#gọi:Coordinates | dms2dec }} : Hàm đơn giản để chuyển đổi định dạng
độ-phút-giây ra định dạng độ thập phân.

{{#gọi:Coordinates | link }} : Xuất địa chỉ của các công cụ.

]=]

require('strict')

local math_mod = require("Module:Math")
local coordinates = {};

local current_page = mw.title.getCurrentTitle()
local page_name = mw.uri.encode( current_page.prefixedText, 'WIKI' );
local coord_link = '//tools.wmflabs.org/geohack/geohack.php?language=en&pagename=' .. page_name .. '&params='

-- Định dạng các số theo quy tắc tiếng Việt (thí dụ 1.234,56).
local lang = mw.getContentLanguage()

-- Chuyển đổi đối số thành các giá trị tiếng Anh.
local function delocalizeArguments(args)
	-- Chuyển vị bảng đối số
	local transposedArgs = {}
	for i, arg in ipairs(args) do
		transposedArgs[mw.ustring.upper(arg)] = i
	end
	
	if transposedArgs["B"] ~= nil then
		args[transposedArgs["B"]] = "N"
	end
	-- “N” có thể có nghĩa hướng nam trong tiếng Việt hoặc hướng bắc trong tiếng Anh.
	if transposedArgs["N"] ~= nil and (transposedArgs["Đ"] ~= nil or transposedArgs["T"] ~= nil) then
		args[transposedArgs["N"]] = "S"
	end
	if transposedArgs["Đ"] ~= nil then
		args[transposedArgs["Đ"]] = "E"
	end
	if transposedArgs["T"] ~= nil then
		args[transposedArgs["T"]] = "W"
	end
end

--[[ Hàm hỗ trợ thay thế {{coord/display/title}} ]]
local function displaytitle(s, notes)
	local htmlTitle = '<span style="margin-right: 0.25rem;">' .. s .. notes .. '</span>';
	return mw.getCurrentFrame():extensionTag('indicator', tostring(htmlTitle), { name = '#coordinates' })
end

--[[ Hàm hỗ trợ thay thế {{coord/display/inline}} ]]
local function displayinline(s, notes)
	return s .. notes	
end

--[[ Hàm hỗ trợ được sử dụng để nhận ra định dạng độ-phút-giây. ]]
local function dmsTest(first, second)
	if type(first) ~= 'string' or type(second) ~= 'string' then
		return nil
	end
	local s = mw.ustring.upper(first .. second)
	if s == "NE" or s == "NW" or s == "SE" or s == "SW" or
		s == "EN" or s == "WN" or s == "ES" or s == "WS" or
		s == "BĐ" or s == "BT" or s == "NĐ" or s == "TN" or
		s == "ĐB" or s == "TB" or s == "ĐN" or s == "NT" then
		return true
	end
	return false
end


--[[ Hàm bọc để lấy các tham số; xem tài liệu của hàm này tại Mô đun:Arguments. ]]
local function makeInvokeFunc(funcName)
	return function (frame)
		local args = require('Mô đun:Arguments').getArgs(frame, {
			wrappers = 'Bản mẫu:Tọa độ'
		})
		return coordinates[funcName](args, frame)
	end
end

--[[ Hàm hỗ trợ để xử lý các đối số tùy chọn. ]]
local function optionalArg(arg, suplement)
	if arg ~= nil and arg ~= "" then
		return arg .. suplement
	end
end

--[[ Helper function, handle optional args. ]]
local function optionalArg(arg, supplement)
	return arg and arg .. supplement or ''
end

--[[
Định dạng những thông báo lỗi cần hiển thị.
]]
local function errorPrinter(errors)
	local result = ""
	for i,v in ipairs(errors) do
		local errorHTML = '<strong class="error">Tọa độ: ' .. v[2] .. '</strong>'
		result = result .. errorHTML .. "<br />"
	end
	return result
end

--[=[
Tính lớp CSS cần để hiển thị tọa độ.

Bảng kiểu CSS thường ẩn geo-nondefault, trừ khi một nguời dùng đã ghi đè thiết lập này.
default là chế độ do nguời dùng định rõ khi nhúng [[Bản mẫu:coord]].
mode là chế độ hiển thị (dec hoặc dms) dùng để tính lớp CSS.
]=]
local function displayDefault(default, mode)
	if default == "" then
		default = "dec"
	end
	
	if default == mode then
		return "geo-default"
	else
		return "geo-nondefault"
	end
end

--[[
specPrinter

Hàm định dạng giá trị cho ra. Lấy cấu trúc do parseDec hoặc parseDMS tạo ra và
định dạng nó để nhúng vào BKDatabase.
]]
local function specPrinter(args, coordinateSpec)
	local uriComponents = coordinateSpec["param"]
	if uriComponents == "" then
		-- RETURN error, should never be empty or nil
		return "LỖI tham số trống"
	end
	if args["name"] then
		uriComponents = uriComponents .. "&title=" .. mw.uri.encode(coordinateSpec["name"])
	end
	
	local geodmshtml = '<span class="geo-dms" title="Bản đồ, không ảnh, cùng các dữ liệu khác cho vị trí này">'
			 .. '<span class="latitude">' .. coordinateSpec["dms-lat"] .. '</span> '
			 .. '<span class="longitude">' ..coordinateSpec["dms-long"] .. '</span>'
			 .. '</span>'

	local lat = tonumber( coordinateSpec["dec-lat"] ) or 0
	local geodeclat
	if lat < 0 then
		-- FIXME this breaks the pre-existing precision
		geodeclat = lang:formatNum(tonumber(coordinateSpec["dec-lat"]:sub(2))) .. "°N"
	else
		geodeclat = lang:formatNum(tonumber(coordinateSpec["dec-lat"] or 0)) .. "°B"
	end

	local long = tonumber( coordinateSpec["dec-long"] ) or 0
	local geodeclong
	if long < 0 then
		-- FIXME does not handle unicode minus
		geodeclong = lang:formatNum(tonumber(coordinateSpec["dec-long"]:sub(2))) .. "°T"
	else
		geodeclong = lang:formatNum(tonumber(coordinateSpec["dec-long"] or 0)) .. "°Đ"
	end
	
	local geodechtml = '<span class="geo-dec" title="Bản đồ, không ảnh, cùng các dữ liệu khác cho vị trí này">'
			 .. geodeclat .. ' '
			 .. geodeclong
			 .. '</span>'

	local geonumhtml = '<span class="geo">'
			 .. coordinateSpec["dec-lat"] .. '; '
			 .. coordinateSpec["dec-long"]
			 .. '</span>'

	local inner = '<span class="' .. displayDefault(coordinateSpec["default"], "dms" ) .. '">' .. geodmshtml .. '</span>'
				.. '<span class="geo-multi-punct">&#xfeff; / &#xfeff;</span>'
				.. '<span class="' .. displayDefault(coordinateSpec["default"], "dec" ) .. '">';

	if not args["name"] then
		inner = inner .. geodechtml 
				.. '<span style="display:none">&#xfeff; / ' .. geonumhtml .. '</span></span>'
	else
		inner = inner .. '<span class="vcard">' .. geodechtml 
				.. '<span style="display:none">&#xfeff; / ' .. geonumhtml .. '</span>'
				.. '<span style="display:none">&#xfeff; (<span class="fn org">'
				.. args["name"] .. '</span>)</span></span></span>'
	end

    local stylesheetLink = 'Module:Coordinates/styles.css'
	return mw.getCurrentFrame():extensionTag{
		name = 'templatestyles', args = { src = stylesheetLink }
	} .. '<span class="plainlinks nourlexpansion">[' .. coord_link .. uriComponents ..
	' ' .. inner .. ']</span>'
end

--[[ Hàm hỗ trợ chuyển đổi số thập phân thành độ. ]]
local function convert_dec2dms_d(coordinate)
	local d = math_mod._round( coordinate, 0 ) .. "°"
	return d .. ""
end

--[[ Hàm hỗ trợ chuyển đổi số thập phân thành độ và phút. ]]
local function convert_dec2dms_dm(coordinate)	
	coordinate = math_mod._round( coordinate * 60, 0 );
	local m = coordinate % 60;
	coordinate = math.floor( (coordinate - m) / 60 );
	local d = coordinate % 360 .."°"
	
	return d .. string.format( "%02d′", m )
end

--[[ Hàm hỗ trợ chuyển đổi số thập phân thành độ, phút, và giây. ]]
local function convert_dec2dms_dms(coordinate)
	coordinate = math_mod._round( coordinate * 60 * 60, 0 );
	local s = coordinate % 60
	coordinate = math.floor( (coordinate - s) / 60 );
	local m = coordinate % 60
	coordinate = math.floor( (coordinate - m) / 60 );
	local d = coordinate % 360 .."°"

	return d .. string.format( "%02d′", m ) .. string.format( "%02d″", s )
end

--[[ 
Hàm hỗ trợ chuyển đổi vĩ độ hoặc kinh độ thập phân thành định dạng độ-phút-giây
theo độ chính xác được định rõ.
]]
local function convert_dec2dms(coordinate, firstPostfix, secondPostfix, precision)
	local coord = tonumber(coordinate)
	local postfix
	if coord >= 0 then
		postfix = firstPostfix
	else
		postfix = secondPostfix
	end

	precision = precision:lower();
	if precision == "dms" then
		return convert_dec2dms_dms( math.abs( coord ) ) .. postfix;
	elseif precision == "dm" then
		return convert_dec2dms_dm( math.abs( coord ) ) .. postfix;
	elseif precision == "d" then
		return convert_dec2dms_d( math.abs( coord ) ) .. postfix;
	end
end

--[[
Chuyển đổi định dạng độ-phút-giây thành tọa độ thập phân B hay Đ.
]]
local function convert_dms2dec(direction, degrees_str, minutes_str, seconds_str)
	local degrees = tonumber(degrees_str)
	local minutes = tonumber(minutes_str) or 0
	local seconds = tonumber(seconds_str) or 0
	
	local factor = 1
	direction = mw.ustring.gsub(direction, '^ *(.-) *$', '%1');
	if direction == "S" or direction == "W" then
		factor = -1
	end
	
	local precision = 0
	if seconds_str then
		precision = 5 + math.max( math_mod._precision(seconds_str), 0 );
	elseif minutes_str and minutes_str ~= '' then
		precision = 3 + math.max( math_mod._precision(minutes_str), 0 );
	else
		precision = math.max( math_mod._precision(degrees_str), 0 );
	end
	
	local decimal = factor * (degrees+(minutes+seconds/60)/60) 
	return string.format( "%." .. precision .. "f", decimal ) -- not tonumber since this whole thing is string based.
end

--[[
Kiểm tra các giá trị cho vào để nhận ra lỗi không đúng phạm vi.
]]
local function validate( lat_d, lat_m, lat_s, long_d, long_m, long_s, source, strong )
	local errors = {};
	lat_d = tonumber( lat_d ) or 0;
	lat_m = tonumber( lat_m ) or 0;
	lat_s = tonumber( lat_s ) or 0;
	long_d = tonumber( long_d ) or 0;
	long_m = tonumber( long_m ) or 0;
	long_s = tonumber( long_s ) or 0;

	if strong then
		if lat_d < 0 then
			table.insert(errors, {source, "vĩ độ < 0 có chữ bán cầu"})
		end
		if long_d < 0 then
			table.insert(errors, {source, "vĩ độ < 0 có chữ bán cầu"})
		end
		--[[ 
		#coordinates is inconsistent about whether this is an error.  If globe: is
		specified, it won't error on this condition, but otherwise it will.
		
		For not simply disable this check.
		
		if long_d > 180 then
			table.insert(errors, {source, "longitude degrees > 180 with hemisphere flag"})
		end
		]]
	end	
		
	if lat_d > 90 then
		table.insert(errors, {source, "vĩ độ > 90"})
	end
	if lat_d < -90 then
		table.insert(errors, {source, "vĩ độ < -90"})
	end
	if lat_m >= 60 then
		table.insert(errors, {source, "vĩ phút >= 60"})
	end
	if lat_m < 0 then
		table.insert(errors, {source, "vĩ phút < 0"})
	end
	if lat_s >= 60 then
		table.insert(errors, {source, "vĩ giây >= 60"})
	end
	if lat_s < 0 then
		table.insert(errors, {source, "vĩ giây < 0"})
	end
	if long_d >= 360 then
		table.insert(errors, {source, "kinh độ >= 360"})
	end
	if long_d <= -360 then
		table.insert(errors, {source, "kinh độ <= -360"})
	end
	if long_m >= 60 then
		table.insert(errors, {source, "kinh phút >= 60"})
	end
	if long_m < 0 then
		table.insert(errors, {source, "kinh phút < 0"})
	end
	if long_s >= 60 then
		table.insert(errors, {source, "kinh giây >= 60"})
	end
	if long_s < 0 then
		table.insert(errors, {source, "kinh giây < 0"})
	end
	
	return errors;
end

--[[
parseDec

Biến đổi vĩ độ và kinh độ thập phân thành một cấu trúc để hiển thị tọa độ.
]]
local function parseDec( lat, long, format )
	local coordinateSpec = {}
	local errors = {}
	
	if not long then
		return nil, {{"parseDec", "Thiếu kinh độ"}}
	end
	
	long = long:gsub(",", ".", 1)
	if not tonumber(long) then
		return nil, {{"parseDec", "Không thể phân tích số từ kinh độ: " .. long}}
	end
	
	errors = validate( lat, nil, nil, long, nil, nil, 'parseDec', false );	
	coordinateSpec["dec-lat"]  = lat;
	coordinateSpec["dec-long"] = long;

	local mode = coordinates.determineMode( lat, long );
	coordinateSpec["dms-lat"]  = convert_dec2dms( lat, "B", "N", mode)  -- {{coord/dec2dms|{{{1}}}|B|N|{{coord/prec dec|{{{1}}}|{{{2}}}}}}}
	coordinateSpec["dms-long"] = convert_dec2dms( long, "Đ", "T", mode)  -- {{coord/dec2dms|{{{2}}}|Đ|T|{{coord/prec dec|{{{1}}}|{{{2}}}}}}}	
	
	if format then
		coordinateSpec.default = format
	else
		coordinateSpec.default = "dec"
	end

	return coordinateSpec, errors
end

--[[
parseDMS

Biến đổi vĩ độ và kinh độ dưới dạng độ-phút-giây thành cấu trúc để hiển thị các
tọa độ.
]]
local function parseDMS( lat_d, lat_m, lat_s, lat_f, long_d, long_m, long_s, long_f, format )
	local coordinateSpec, errors, backward = {}, {}
	
	lat_f = mw.ustring.upper(lat_f);
	long_f = mw.ustring.upper(long_f);
	
	-- Nhận các chữ bán cầu tiếng Việt.
	if long_f == "B" or lat_f == "Đ" or lat_f == "T" then
		local englishFlags = {B = "N", N = "S", T = "W", ["Đ"] = "E"}
		local lat_f = englishFlags[lat_f] or lat_f
		local long_f = englishFlags[long_f] or long_f
	end
	
	-- Check if specified backward
	if lat_f == 'E' or lat_f == 'W' then
		lat_d, long_d, lat_m, long_m, lat_s, long_s, lat_f, long_f, backward = long_d, lat_d, long_m, lat_m, long_s, lat_s, long_f, lat_f, true;
	end	
	
	errors = validate( lat_d, lat_m, lat_s, long_d, long_m, long_s, 'parseDMS', true );
	if not long_d then
		return nil, {{"parseDMS", "Thiếu kinh độ" }}
	end
	
	long_d = long_d:gsub(",", ".", 1)
	if not tonumber(long_d) then
		return nil, {{"parseDMS", "Không thể phân tích số từ kinh độ:" .. long_d }}
	end
	
	if not lat_m and not lat_s and not long_m and not long_s and #errors == 0 then 
		if math_mod._precision( lat_d ) > 0 or math_mod._precision( long_d ) > 0 then
			if lat_f:upper() == 'S' then 
				lat_d = '-' .. lat_d;
			end
			if long_f:upper() == 'W' then 
				long_d = '-' .. long_d;
			end
			
			return parseDec( lat_d, long_d, format );
		end		
	end   
	
	-- Việt hóa các chữ bán cầu.
	local vietFlags = {N = "B", S = "N", W = "T", E = "Đ"}
	local viet_lat_f = vietFlags[lat_f:upper()] or lat_f
	local viet_long_f = vietFlags[long_f:upper()] or long_f
	
	-- Định dạng các số thập phân.
	if tonumber(lat_s) then lat_s = lang:formatNum(tonumber(lat_s)) end
	if tonumber(long_s) then long_s = lang:formatNum(tonumber(long_s)) end
	
	coordinateSpec["dms-lat"]  = lat_d.."°"..optionalArg(lat_m,"′") .. optionalArg(lat_s,"″") .. viet_lat_f
	coordinateSpec["dms-long"] = long_d.."°"..optionalArg(long_m,"′") .. optionalArg(long_s,"″") .. viet_long_f
	coordinateSpec["dec-lat"]  = convert_dms2dec(lat_f, lat_d, lat_m, lat_s) -- {{coord/dms2dec|{{{4}}}|{{{1}}}|0{{{2}}}|0{{{3}}}}}
	coordinateSpec["dec-long"] = convert_dms2dec(long_f, long_d, long_m, long_s) -- {{coord/dms2dec|{{{8}}}|{{{5}}}|0{{{6}}}|0{{{7}}}}}

	if format then
		coordinateSpec.default = format
	else
		coordinateSpec.default = "dms"
	end   

	return coordinateSpec, errors, backward
end

--[[
Kiểm tra các đối số cho vào để nhận ra kiểu dữ liệu được cung cấp và xử lý đúng
cách.
]]
local function formatTest(args)
	local result, errors
	local backward, primary = false, false

	local function getParam(args, lim)
		local ret = {}
		for i = 1, lim do
			if args[i] == nil then
				ret[i] = ''
			else
				ret[i] = mw.ustring.match(args[i], '^%s*(.-)%s*$' );  --remove whitespace
				
				-- Biến đổi thành định dạng số tiếng Anh.
				-- CHO RẰNG: Các giá trị số không bao giờ tới 1.000.
				ret[i] = ret[i]:gsub(",", ".", 1)
			end
		end
		return table.concat(ret, '_')
	end
	
	if not args[1] then
		-- no lat logic
		return errorPrinter( {{"formatTest", "Thiếu vĩ độ"}} )
	end
	
	args[1] = args[1]:gsub(",", ".", 1)
	if not tonumber(args[1]) then
		-- bad lat logic
		return errorPrinter( {{"formatTest", "Không thể phân tích số từ vĩ độ:" .. args[1]}} )
	elseif not args[4] and not args[5] and not args[6] then
		-- dec logic
		result, errors = parseDec(args[1], args[2], args.format)
		if not result then
			return errorPrinter(errors);
		end
		result.param = table.concat({args[1]:gsub(",", ".", 1), 'N', args[2]:gsub(",", ".", 1) or '', 'E', args[3] or ''}, '_')
	elseif dmsTest(args[4], args[8]) then
		-- dms logic
		result, errors, backward = parseDMS(args[1], args[2], args[3], args[4], 
			args[5], args[6], args[7], args[8], args.format)
		if args[10] then
			table.insert(errors, {'formatTest', 'Tham số dư'})
		end
		if not result then
			return errorPrinter(errors)
		end
		result.param = getParam(args, 9)
	elseif dmsTest(args[3], args[6]) then
		-- dm logic
		result, errors, backward = parseDMS(args[1], args[2], nil, args[3], 
			args[4], args[5], nil, args[6], args['format'])
		if args[8] then
			table.insert(errors, {'formatTest', 'Tham số dư'})
		end
		if not result then
			return errorPrinter(errors)
		end
		result.param = getParam(args, 7)
	elseif dmsTest(args[2], args[4]) then
		-- d logic
		result, errors, backward = parseDMS(args[1], nil, nil, args[2], 
			args[3], nil, nil, args[4], args.format)
		if args[6] then
			table.insert(errors, {'formatTest', 'Tham số dư'})
		end	
		if not result then
			return errorPrinter(errors)
		end
		result.param = getParam(args, 5)
	else
		-- Error
		return errorPrinter({{"formatTest", "Định dạng đối số không rõ"}})
	end
	result.name = args.name
	
	local extra_param = {'dim', 'globe', 'scale', 'region', 'source', 'type'}
	for _, v in ipairs(extra_param) do
		if args[v] then 
			table.insert(errors, {'formatTest', 'Tham số: “' .. v .. '=” cần phải là “' .. v .. ':”' })
		end
	end
	
	local ret = specPrinter(args, result)
	if #errors > 0 then
		ret = ret .. ' ' .. errorPrinter(errors) .. '[[Thể loại:Trang có thẻ tọa độ hỏng]]'
	end
	return ret, backward
end

--[[
Xếp vào các thể loại theo dõi Wikibase.
]]
local function makeWikibaseCategories()
	local ret
	if mw.wikibase and current_page.namespace == 0 then
		local entity = mw.wikibase.getEntityObject()
		if entity and entity.claims and entity.claims.P31 and entity.claims.P31[1] then
			local snaktype = entity.claims.P31[1].mainsnak.snaktype
			if snaktype == 'value' then
				-- coordinates exist both here and on Wikidata, and can be compared.
				ret = 'Tọa độ trên Wikibase'
			elseif snaktype == 'somevalue' then
				ret = 'Tọa độ trên Wikibase có giá trị không rõ'
			elseif snaktype == 'novalue' then
				ret = 'Tọa độ trên Wikibase không có giá trị'
			end
		else
			-- We have to either import the coordinates to Wikidata or remove them here.
			ret = 'Tọa độ không có sẵn trên Wikibase'
		end
	end
	if ret then
		return mw.ustring.format('[[Thể loại:%s]]', ret)
	else
		return ''
	end
end

--[[
link

Hàm đơn giản xuất địa chỉ tọa độ cho những mục đích khác.

Cách sử dụng:
	{{ #gọi:Coordinates | link }}
	
]]
function coordinates.link(frame)
	return coord_link;
end

--[[
dec2dms

Hàm bọc cho phép các bản mẫu gọi dec2dms trực tiếp.

Cách sử dụng:
	{{ #gọi:Coordinates | dec2dms | tọa độ thập phân | hậu tố cho số dương | 
		hậu tố cho số âm | độ chính xác }}

decimal_coordinate được chuyển đổi thành định dạng độ-phút-giây. Nếu là số
dương, hậu tố cho số dương được bổ sung (thường là N hay E); nếu là số dương,
hậu tố cho số dương được bổ sung. Độ chính xác định rõ mức chi tiết là một trong
“D”, “DM”, hay “DMS”.
]]
coordinates.dec2dms = makeInvokeFunc('_dec2dms')
function coordinates._dec2dms(args)
	local coordinate = args[1]
	local firstPostfix = args[2] or ''
	local secondPostfix = args[3] or ''
	local precision = args[4] or ''

	return convert_dec2dms(coordinate, firstPostfix, secondPostfix, precision)
end

--[[
Hàm hỗ trợ quyết định sử dụng định dạng độ, độ-phút, hay độ-phút-giây, tùy độ
chính xác của giá trị thập phân cho vào.
]]
function coordinates.determineMode( value1, value2 )
	local precision = math.max( math_mod._precision( value1 ), math_mod._precision( value2 ) );
	if precision <= 0 then
		return 'd'
	elseif precision <= 2 then
		return 'dm';
	else
		return 'dms';
	end
end		

--[[
dms2dec

Hàm bọc cho phép các bản mẫu gọi dms2dec trực tiếp.

Cách sử dụng:
	{{ #gọi:Coordinates | dms2dec | chữ bán cầu | độ | 
		phút | giây }}

Chuyển đổi các giá trị độ-phút-giây thành định dạng thập phân.
direction_flag là một trong N, S, E, và W và định rõ giá trị cho ra là số dương
(N và E) hoặc số âm (S và W).
]]
coordinates.dms2dec = makeInvokeFunc('_dms2dec')
function coordinates._dms2dec(args)
	local direction = args[1]
	local degrees = args[2]
	local minutes = args[3]
	local seconds = args[4]

	return convert_dms2dec(direction, degrees, minutes, seconds)
end

--[=[
coord

Chỗ vào chính của hàm Lua thay thế [[Bản mẫu:Coord]].

Cách sử dụng:
	{{ #gọi:Coordinates | coord }}
	{{ #gọi:Coordinates | coord | vĩ độ | kinh độ }}
	{{ #gọi:Coordinates | coord | vĩ độ | chữ vĩ độ | kinh độ | chữ kinh độ }}
	…
	
	Tra cứu trang tài liệu của [[Bản mẫu:Coord]] để biết đến nhiều tham số và
	tùy chọn khác.

Lưu ý: Hàm này cung cấp các phần tử hiển thị thị giác của [[Bản mẫu:Coord]]. Để
cho có thể tải các tọa độ lên cơ sở dữ liệu, hàm cú pháp {{#tọađộ:}} cũng cần
được gọi. Hàm này được gọi tự động trong phiên bản Lua của [[Bản mẫu:Coord]].
]=]
coordinates.coord = makeInvokeFunc('_coord')
function coordinates._coord(args)
	if (not args[1] or not tonumber(args[1])) and not args[2] and mw.wikibase.getEntityObject() then
		args[3] = args[1]; args[1] = nil
		local entity = mw.wikibase.getEntityObject()
		if entity 
			and entity.claims
			and entity.claims.P31
			and entity.claims.P31[1].mainsnak.snaktype == 'value'
		then
			local precision = entity.claims.P31[1].mainsnak.datavalue.value.precision
			args[1]=entity.claims.P31[1].mainsnak.datavalue.value.latitude
			args[2]=entity.claims.P31[1].mainsnak.datavalue.value.longitude
			if precision then
				precision=-math_mod._round(math.log(precision)/math.log(10),0)
				args[1]=math_mod._round(args[1],precision)
				args[2]=math_mod._round(args[2],precision)
			end
		end
	end
	
	local Display = args.display and args.display:lower() or 'inline'
	args.wviTitle = (string.find( Display, 'title' ) ~= nil or Display == 't' or 
		Display == 'it' or Display == 'ti')
	delocalizeArguments(args)
	local contents, backward = formatTest(args)
	local Notes = args.notes or ''

	local function isInline(s)
		-- Finds whether coordinates are displayed inline.
		return s:find('inline') ~= nil or s == 'i' or s == 'it' or s == 'ti'
	end
	local function isInTitle(s)
		-- Finds whether coordinates are displayed in the title.
		return s:find('title') ~= nil or s == 't' or s == 'it' or s == 'ti'
	end
	
	local function coord_wrapper(in_args)
		-- Calls the parser function {{#coordinates:}}.
		return mw.getCurrentFrame():callParserFunction('#coordinates', in_args) or ''
	end
	
	local text = ''
	if isInline(Display) then
		text = text .. displayinline(contents, Notes)
	end
	if isInTitle(Display) then
		text = text
			.. displaytitle(contents, Notes)
			.. makeWikibaseCategories()
	end
	if not args.nosave then
		local page_title, count = mw.title.getCurrentTitle(), 1
		if backward then
			local tmp = {}
			while not mw.ustring.find((args[count-1] or ''), '[EWĐT]') do tmp[count] = (args[count] or ''); count = count+1 end
			tmp.count = count; count = 2*(count-1)
			while count >= tmp.count do table.insert(tmp, 1, (args[count] or '')); count = count-1 end
			for i, v in ipairs(tmp) do args[i] = v end
		else
			while count <= 9 do args[count] = (args[count] or ''); count = count+1 end
		end
		if isInTitle(Display) and not page_title.isTalkPage and page_title.subpageText ~= 'doc' and page_title.subpageText ~= 'tài liệu' and page_title.subpageText ~= 'testcases' and page_title.subpageText ~='kiểm thử' then args[10] = 'primary' end
		args.notes, args.format, args.display = nil
		text = text .. coord_wrapper(args)
	end
	return text
end

--[=[
coord2text

Phân tích ra một giá trị từ lần nhúng [[Bản mẫu:Tọa độ]].
NẾU CÚ PHÁP LIÊN KẾT CỦA GEOHACK THAY ĐỔI, HÀM NÀY CẦN ĐƯỢC THAY ĐỔI LUÔN.

Cách sử dụng:

    {{#gọi:Coordinates | coord2text | {{Tọa độ}} | parameter }}

Giá trị hợp lệ cho tham số thứ hai là: lat (số nguyên có dấu), long (số nguyên có dấu), type, scale, dim, region, globe, source

]=]
function coordinates.coord2text(frame)
	if frame.args[1] == '' or frame.args[2] == '' or not frame.args[2] then return nil end
	frame.args[2] = mw.text.trim(frame.args[2])
	if frame.args[2] == 'lat' or frame.args[2] == 'long' then
		local result, negative = mw.text.split((mw.ustring.match(frame.args[1],'[,%d]+°[BN] [,%d]+°[ĐT]') or ''), ' ')
		if frame.args[2] == 'lat' then
			result, negative = result[1], 'N'
		else
			result, negative = result[2], 'T'
		end
		result = mw.text.split(result, '°')
		if result[2] == negative then result[1] = '-'..result[1] end
		return lang:parseFormattedNumber(result[1])
	else
		return mw.ustring.match(frame.args[1], 'params=.-_'..frame.args[2]..':(.-)[ _]')
	end
end

--[=[
coordinsert

Xen văn bản vào liên kết GeoHack của một lần nhúng [[Bản mẫu:Tọa độ]] (nếu văn bản này không phải đã xuất hiện trong mã nhúng). Trả về mã nhúng [[Bản mẫu:Tọa độ]] đã sửa đổi.
NẾU CÚ PHÁP LIÊN KẾT CỦA GEOHACK THAY ĐỔI, HÀM NÀY CẦN ĐƯỢC THAY ĐỔI LUÔN.

Cách sử dụng:

    {{#invoke:Coordinates | coordinsert | {{Coord}} | parameter:value | parameter:value | … }}

Đừng làm GeoHack gây lỗi bằng cách đưa vào gì không được nói đến trong tài liệu [[Bản mẫu:Tọa độ]].

]=]
function coordinates.coordinsert(frame)
	for i, v in ipairs(frame.args) do
		if i ~= 1 then
			if not mw.ustring.find(frame.args[1], (mw.ustring.match(frame.args[i], '^(.-:)') or '')) then 
				frame.args[1] = mw.ustring.gsub(frame.args[1], '(params=.-)_? ', '%1_'..frame.args[i]..' ')
			end
		end
	end
	if frame.args.name then
		if not mw.ustring.find(frame.args[1], '<span class="vcard">') then
			local namestr = frame.args.name
			frame.args[1] = mw.ustring.gsub(frame.args[1], 
				'(<span class="geo%-default">)(<span[^<>]*>[^<>]*</span><span[^<>]*>[^<>]*<span[^<>]*>[^<>]*</span></span>)(</span>)', 
				'%1<span class="vcard">%2<span style="display:none">&#xfeff; (<span class="fn org">' .. namestr .. '</span>)</span></span>%3')
			frame.args[1] = mw.ustring.gsub(frame.args[1], '(&params=[^&"<>%[%] ]*) ', '%1&title=' .. mw.uri.encode(namestr) .. ' ')
		end
	end
	return frame.args[1]
end

return coordinates
