-- Creates a slideshow gallery where the order is randomised. Intended for use on portal pages.
local p = {}
local excerptModule =  require('Mô đun:Excerpt/portals')
local randomModule = require('Mô đun:Random')
local redirectModule = require('Mô đun:Redirect')

function cleanupArgs(argsTable)
	local cleanArgs = {}
	for key, val in pairs(argsTable) do
		if type(val) == 'string' then
			val = val:match('^%s*(.-)%s*$')
			if val ~= '' then
				cleanArgs[key] = val
			end
		else
			cleanArgs[key] = val
		end
	end
	return cleanArgs
end

function normaliseCssMeasurement(input)
	local suffix = string.reverse(string.sub(string.reverse(input), 1, 2))
	if ( suffix == 'px' ) or ( suffix == 'em' ) or ( string.sub(suffix, 2, 2) == '%' ) then
		return input
	else
		return input .. 'px'
	end
end

function isDeclined(val)
	if not val then return false end
	local declinedWords = " decline declined exclude excluded false none not no n off omit omitted remove removed "
	return string.find(declinedWords , ' '..val..' ', 1, true ) and true or false
end

function makeOutput(galleryLines, maxWidth, containerClassName, nonRandom)
	local randomiseArgs = {	['t'] = galleryLines }
	local sortedLines = nonRandom and galleryLines or randomModule.main('array', randomiseArgs)
	for i = 1, #sortedLines do
		-- insert a switcher-label span just after the first pipe, which should ideally be the caption
		sortedLines[i] = sortedLines[i]:gsub(
			"|",
			'|<span class="switcher-label" style="display:none"><span class="randomSlideshow-sr-only">Image ' .. tostring(i) .. '</span></span>',
			1)
	end
	local galleryContent = table.concat(sortedLines, '\n')
	local output = '<div class="' .. containerClassName .. '" style="max-width:' .. normaliseCssMeasurement(maxWidth) .. '; margin:-4em auto;"><div class="nomobile"><!--intentionally empty on desktop, and is not present on mobile website (outside template namesapce)--></div>'
		.. mw.getCurrentFrame():extensionTag({name="gallery",content=galleryContent,args={mode="slideshow",class="switcher-container"}}) .. '</div>'
	return output
end

function makeGalleryLine(file, caption, credit)
	local title = mw.title.new(file, "File" )
	if not title
	then
		return "File:Blank.png|{{Error|File [[:File:" .. file .. "]] does not exist.}}"
	end
	local creditLine = ( credit and '<p><span style="font-size:88%">' .. credit .. '</span></p>' or '' )
	return title.prefixedText .. '|' .. ( caption or '' ) .. creditLine
end

function makeGalleryLinesTable(args)
	local galleryLinesTable = {}
	local i = 1
	while args[i] do
		table.insert(galleryLinesTable, makeGalleryLine(args[i], args[i+1], args['credit' .. (i+1)/2]))
		i = i + 2
	end
	return galleryLinesTable 
end

function hasCaption(line)
	local caption = mw.ustring.match(line, ".-|(.*)")
	-- require caption to exist with more than 5 characters (avoids sizes etc being mistaken for captions)
	return caption and #caption>5 and true or false
end

function extractGalleryFiles(wikitext)
	local gallery = mw.ustring.match(wikitext, '<gallery.->%s*(.-)%s*</gallery>')
	if not gallery then
		return false
	end
	return mw.text.split(gallery, '%c')
end

function extractRegularFiles(wikitext)
	local files = {}
	local frame = mw.getCurrentFrame()
	local expand = function(template)
		return frame:preprocess(template)
	end
	for file in mw.ustring.gmatch(wikitext, '%b[]' ) do
		-- remove keywords that don't work in galleries
		file = mw.ustring.gsub(file, '|%s*thumb%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*thumbnail%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*border%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*left%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*right%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*center%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*centre%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*baseline%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*sub%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*super%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*top%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*text%-top%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*bottom%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*text%-bottom%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*framed?%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*frameless%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*upright%s*[0-9%.]*%s*([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*upright%s*=.-([|%]])', '%1')
		file = mw.ustring.gsub(file, '|%s*link%s*=.-([|%]])', '%1')
		-- remove spaces prior to captions (which cause pre-formatted text)
		file = mw.ustring.gsub(file, '|%s*', '|')
		-- remove sizes, which sometimes get mistaken for captions
		file = mw.ustring.gsub(file, '|%s*%d*x?%d+%s*px%s*([|%]])', '%1')
		-- remove linebreaks
		file = mw.ustring.gsub(file, '\n\n', '<br>')
		file = mw.ustring.gsub(file, '\n', '')
		-- remove surrounding square brackets
		file = mw.ustring.gsub(file, '^%[%[', '')
		file = mw.ustring.gsub(file, '%]%]$', '')
		table.insert(files, file)
	end
	return files
end

--Central function for fixing issues that could occur in both gallery-fetched and file-fetched files
local function doubleCheck(file)
	-- disable pipes in wikilinks
	file = file:gsub(
		"%[%[(.-)|(.-)]]",
		"[[%1__PIPE__%2]]")
	-- move any alt parameter to the end to avoid putting the switcher in too early and causing a linter error
	file = file:gsub(
		"^(.+)(|alt=[^|]*)(.*)$",
		"%1%3%2")
	-- bring back pipes in wikilinks
	file = file:gsub(
		"%[%[(.-)__PIPE__(.-)]]",
		"[[%1|%2]]")
	return file
end

function makeTranscludedGalleryLinesTables(args)
	local namespaceNumber = function(pagetitle)
		local titleObject = mw.title.new(pagetitle)
		return titleObject and titleObject.namespace
	end
	local lines = {}
	local i = 1
	while args[i] do
		if namespaceNumber(args[i]) == 6 then -- file namespace
			-- args[i] is either just the filename, or uses syntax File:Name.jpg##Caption##Credit
			local parts = mw.text.split(args[i], '##%s*')
			local filename = parts[1]
			local caption = args['caption'..i] or parts[2] or false
			local credit = args['credit'..i] or parts[3] or false
			local line = makeGalleryLine(filename, caption, credit)
			table.insert(lines, line)
		else
			local content, pagename = excerptModule.getContent(args[i])
			if not pagename then
				return error('Không thể đọc trang hợp lệ cho "' .. args[i] .. '"', 0)
			elseif not content then
				return error('Không tìm thấy nội dung trên trang "' .. args[i] .. '"', 0)
			end
			if args['section'..i] then
				content = excerptModule.getSection(content, args['section'..i]) or ''
			end
			content = excerptModule.cleanupText(content, {keepSubsections=true}) -- true means keep subsections
	
			local galleryFiles = extractGalleryFiles(content)
			if galleryFiles then
				for _, f in pairs(galleryFiles) do
					if hasCaption(f) then
						local filename = string.gsub(f, '|.*', '')
						local isOkay = excerptModule.checkImage(filename)
						if isOkay then
							table.insert(lines, doubleCheck(f.." (from '''[["..pagename.."]]''')"))
						end
					end
				end
			end
	
			local otherFiles = excerptModule.parse(content, {fileflags="1-100", filesOnly=true})
			if otherFiles then
				for _, f in pairs(extractRegularFiles(otherFiles)) do
					if f and f ~= '' and mw.ustring.sub(f, 1, 5) == 'File:' and hasCaption(f) then
						table.insert(lines, doubleCheck(f.." (from '''[["..pagename.."]]''')"))
					end
				end
			end
		
		end
		i = i + 1
	end
	return ( #lines > 0 ) and lines or error('Không tìm thấy hình ảnh')
end

p._main = function(args, transclude, extraClassName)
	if not args[1] then
		return error(linked and 'Không có trang nào được chỉ định' or 'Không có trang nào được chỉ định', 0)
	end
	local lines = transclude and makeTranscludedGalleryLinesTables(args) or makeGalleryLinesTable(args)
	local classNames = 'randomSlideshow-container'
	if extraClassName then classNames = classNames .. ' ' .. extraClassName end
	return makeOutput(lines, args.width or '100%', classNames, isDeclined(args.random))
end

p.main = function(frame)
	local parent = frame.getParent(frame)
	local parentArgs = parent.args
	local args = cleanupArgs(parentArgs)
	local output = p._main(args, false)
	return frame:extensionTag{ name='templatestyles', args = { src='Mô đun:Random slideshow/styles.css'} } 
		.. frame:preprocess(output)
end

p.transclude = function(frame)
	local parent = frame.getParent(frame)
	local parentArgs = parent.args
	local args = cleanupArgs(parentArgs)
	local output = p._main(args, true)
	return frame:extensionTag{ name='templatestyles', args = { src='Mô đun:Random slideshow/styles.css'} } 
		.. frame:preprocess(output)
end

return p
