local p = {}

local cfg, nrows, ncols

local function innerboard(args, size, rev)
	pattern = cfg.pattern or '%w%w'
	local root = mw.html.create('div')
	root:addClass('chess-pieces notheme')
		:css('position', 'relative')
		:wikitext(cfg.image_board(size))
	
	for trow = 1,nrows do
		local row = rev and trow or ( 1 + nrows - trow )
		for tcol = 1,ncols do
			local col = rev and ( 1 + ncols - tcol ) or tcol
			local piece = args[ncols * ( nrows - row ) + col + 2] or ''
			if piece:match( pattern ) then
				local img = cfg.image_square(piece:match(pattern), row, col, size )
				root:tag('div')
					:css('top', tostring(( trow - 1 ) * size) .. 'px')
					:css('left', tostring(( tcol - 1 ) * size) .. 'px')
					:wikitext(img)
			end
		end
	end

	return tostring(root)
end

function chessboard(args, size, rev, letters, numbers, header, footer, align, clear)
	function letters_row( rev, num_lt, num_rt )
		local letters = cfg.letters()
		local root = mw.html.create('')
		if num_lt then
			root:tag('td')
		end
		for k = 1,ncols do
			root:tag('td')
				:css('height', '18px')
				:css('width', size .. 'px')
				:wikitext(rev and letters[1+ncols-k] or letters[k])
		end
		if num_rt then
			root:tag('td')
		end
		return tostring(root)
	end
	
	local letters_top = letters:match( 'both' ) or letters:match( 'top' )
	local letters_bottom = letters:match( 'both' ) or letters:match( 'bottom' )
	local numbers_left = numbers:match( 'both' ) or numbers:match( 'left' )
	local numbers_right = numbers:match( 'both' ) or numbers:match( 'right' )
	local width = ncols * size + 2
	if ( numbers_left ) then width = width + 18 end
	if ( numbers_right ) then width = width + 18 end

	local root = mw.html.create('div')
		:addClass('chessboard')
		:addClass('thumb')
		:addClass('noviewer')
		:addClass(align)
	if( header and header ~= '' ) then
		root:tag('div')
		:addClass('center')
		:css('line-height', '130%')
		:css('margin', '0 auto')
		:css('max-width', (width + ncols) .. 'px')
		:wikitext(header)
	end
	local div = root:tag('div')
		:addClass('thumbinner')
		:css('width', width .. 'px')
	local b = div:tag('table')
		:attr('cellpadding', '0')
		:attr('cellspacing', '0')

	if ( letters_top ) then
		b:tag('tr')
			:wikitext(letters_row( rev, numbers_left, numbers_right ))
	end
	local tablerow = b:tag('tr')
	if ( numbers_left ) then 
		tablerow:tag('td')
			:css('width', '18px')
			:css('height', size .. 'px')
			:wikitext(rev and 1 or nrows) 
	end
	local td = tablerow:tag('td')
		:attr('colspan', ncols)
		:attr('rowspan', nrows)
		:wikitext(innerboard(args, size, rev))
	
	if ( numbers_right ) then 
		tablerow:tag('td')
			:css('width', '18px')
			:css('height', size .. 'px')
			:wikitext(rev and 1 or nrows) 
	end
	if ( numbers_left or numbers_right ) then
		for trow = 2, nrows do
			local idx = rev and trow or ( 1 + nrows - trow )
			tablerow = b:tag('tr')
			if ( numbers_left ) then 
				tablerow:tag('td')
					:css('height', size .. 'px')
					:wikitext(idx)
			end
			if ( numbers_right ) then 
				tablerow:tag('td')
					:css('height', size .. 'px')
					:wikitext(idx)
			end
		end
	end
	if ( letters_bottom ) then
		b:tag('tr')
			:wikitext(letters_row( rev, numbers_left, numbers_right ))
	end

	if footer and mw.text.trim(footer)~='' then
		div:tag('div')
			:addClass('thumbcaption')
			:wikitext(footer)
	end

	return tostring(root) ..
		mw.getCurrentFrame():extensionTag( 'templatestyles', '', { src = 'Module:Chessboard/styles.css' } )
end

function convertFenToArgs( fen )
	-- converts FEN notation to 64 entry array of positions, offset by 2
	local res = { ' ', ' ' }
	-- Loop over rows, which are delimited by /
	for srow in string.gmatch( "/" .. fen, "/%w+" ) do
		-- Loop over all letters and numbers in the row
		for piece in srow:gmatch( "%w" ) do
			if piece:match( "%d" ) then -- if a digit
				for k=1,piece do
					table.insert(res,' ')
				end
			else -- not a digit
				local color = piece:match( '%u' ) and 'l' or 'd'
				piece = piece:lower()
				table.insert( res, piece .. color )
			end
		end
	end

	return res
end

function convertArgsToFen( args, offset )
	function nullOrWhitespace( s ) return not s or s:match( '^%s*(.-)%s*$' ) == '' end
	function piece( s ) 
		return nullOrWhitespace( s ) and 1
		or s:gsub( '%s*(%a)(%a)%s*', function( a, b ) return b == 'l' and a:upper() or a end )
	end
	
	local res = ''
	offset = offset or 0
	for row = 1, 8 do
		for file = 1, 8 do
			res = res .. piece( args[8*(row - 1) + file + offset] )
		end
		if row < 8 then res = res .. '/' end
	end
	return mw.ustring.gsub(res, '1+', function( s ) return #s end )
end

function p.board(frame)
	local args = frame.args
	local pargs = frame:getParent().args
	local style = args.style or pargs.style or 'Chess'
	cfg = require('Module:Chessboard/' .. style)
	nrows, ncols = cfg.dims()
	
	local size = args.size or pargs.size or '26'
	local reverse = ( args.reverse or pargs.reverse or '' ):lower() == "true"
	local letters = ( args.letters or pargs.letters or 'both' ):lower() 
	local numbers = ( args.numbers or pargs.numbers or 'both' ):lower() 
	local header = args[2] or pargs[2] or ''
	local footer = args[nrows*ncols + 3] or pargs[nrows*ncols + 3] or ''
	local align = ( args[1] or pargs[1] or 'tright' ):lower()
	local clear = args.clear or pargs.clear or ( align:match('tright') and 'right' ) or 'none'
	local fen = args.fen or pargs.fen
	local pgn = args.pgn or pargs.pgn

	size = mw.ustring.match( size, '[%d]+' ) or '26' -- remove px from size
	if (pgn) then
		local pgnModule = require('Module:Pgn')
		metadata, moves = pgnModule.main(pgn)
		fen = moves[#moves]
	end
	if (fen) then
		align = args.align or pargs.align or 'tright'
		clear = args.clear or pargs.clear or ( align:match('tright') and 'right' ) or 'none'
		header = args.header or pargs.header or ''
		footer = args.footer or pargs.footer or ''
		return chessboard( convertFenToArgs( fen ), size, reverse, letters, numbers, header, footer, align, clear )
	end
	if args[3] then
		return chessboard(args, size, reverse, letters, numbers, header, footer, align, clear)
	else
		return chessboard(pargs, size, reverse, letters, numbers, header, footer, align, clear)
	end
end

return p
