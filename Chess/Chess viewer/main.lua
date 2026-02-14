-- Creates a chess diagram with arrows and a play button in order to show an entire game.

-- Based on [[Module:Chessboard]], inspired by [[mw:Extension:Chessbrowser]]

-- This might be cleaner if it worked directly on the PGN notation instead of the converted form.
-- A future todo might be to have some sort of changing caption that shows what the current move is. This might improve accessibility as it would give screen readers something to read.


local p = {}
local yesno = require('Module:Yesno')

local cfg, nrows, ncols
cfg = {}

-- From Module:Chessboard/chess
function cfg.dims()
	return 8, 8
end

function cfg.letters()
	return {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
end

-- color from [[:c:Category:Chessboard480]]
-- emerald, olivine, pearl, ruby, sapphire, steel, tourmaline, wood
function cfg.image_board(size, color)
	local colorstr = (color and color ~='' and '-' .. color) or ''
	return string.format( '[[File:Chessboard480%s.svg|%dx%dpx|link=|class=notpageimage]]', colorstr, 8 * size, 8 * size )
end

function cfg.image_square( pc, row, col, size )
	local colornames = { l = 'white', d = 'black', u = 'unknown color' }
	local piecenames = { 
		p = 'pawn',
		r = 'rook',
		n = 'knight',
		b = 'bishop',
		q = 'queen',
		k = 'king',
		a = 'archbishop',
		c = 'chancellor',
		z = 'champion',
		w = 'wizard',
		t = 'fool',
		M = 'mann',
		h = 'upside-down pawn',
		m = 'upside-down rook',
		B = 'upside-down bishop',
		N = 'upside-down knight',
		f = 'upside-down king',
		g = 'upside-down queen',
		e = 'elephant',
		s = 'boat',
		G = 'giraffe',
		U = 'unicorn',
		Z = 'zebra'
	}
	local symnames = {
		xx = 'black cross',
		ox = 'white cross',
		xo = 'black circle',
		oo = 'white circle',
		ul = 'up-left arrow',
		ua = 'up arrow',
		ur = 'up-right arrow',
		la = 'left arrow',
		ra = 'right arrow',
		dl = 'down-left arrow',
		da = 'down arrow',
		dr = 'down-right arrow',
		lr = 'left-right arrow',
		ud = 'up-down arrow',
		db = 'up-right and down-left arrow',
		dw = 'up-left and down-right arrow',
		x0 = 'zero',
		x1 = 'one',
		x2 = 'two',
		x3 = 'three',
		x4 = 'four',
		x5 = 'five',
		x6 = 'six',
		x7 = 'seven',
		x8 = 'eight',
		x9 = 'nine'
	}
	local colchar = {'a','b','c','d','e','f','g','h'}
	local color = mw.ustring.gsub( pc, '^.*(%w)(%w).*$', '%2' ) or ''
	local piece = mw.ustring.gsub( pc, '^.*(%w)(%w).*$', '%1' ) or ''
	--local alt = colchar[col] .. row .. ' '
	local alt = ''
	
	if colornames[color] and piecenames[piece] then
		alt = alt .. colornames[color] .. ' ' .. piecenames[piece]
	else
		alt = alt .. ( symnames[piece .. color] or piece .. ' ' .. color )
	end

	return string.format( '[[File:Chess %s%st45.svg|%dx%dpx|alt=%s|%s|link=|class=notpageimage|top]]', piece, color, size, size, alt, alt )

end

-- End Module:Chessboard/chess
-- start Module:Chessboard


local function innerboard(definedPieces, pieceInfo, size, color, rev, ply)
	pattern = cfg.pattern or '%w%w'
	local root = mw.html.create('div')
	root:addClass('chess-pieces notheme')
		:css('position', 'relative')
		:wikitext(cfg.image_board(size, color))

	for piece in pairs( definedPieces ) do
		if piece:match( pattern ) then
			local img = cfg.image_square(piece:match(pattern), row, col, size )
			local curPos = pieceInfo[ply][piece] or {-1,-1}
			--local class = piece:match( "^[nN]" ) and 'knight' or 'nonknight'
			-- Consensus seems to be make knights move in a normal way instead of an L-Shape
			local class = 'nonknight'
			root:tag('div')
				:css('top', 'calc(var(--calculator-top_piece' .. piece .. ',' .. curPos[1] .. ')*1px)' )
				:css('left', 'calc(var(--calculator-left_piece' .. piece .. ',' .. curPos[2] .. ')*1px)')
				:css( 'opacity', 'calc(min(var(--calculator-top_piece' .. piece .. ',' .. curPos[1] .. '),0) + 1)' )
				:addClass( class )
				:addClass( 'calculator-field' )
				:addClass( curPos[1] == -1 and "calculator-value-false" or "calculator-value-true" )
				:attr( "data-calculator-type", "passthru" )
				:attr( "data-calculator-formula", "ifgreaterorequal(top_piece" .. piece .. ",0)" )
				:wikitext(img)
		end
	end

	return tostring(root)
end

local function getPositions(args, size, rev)
	pattern = cfg.pattern or '%w%w'
	local pieceInfo = {}
	local definedPieces = {}

	local oldLayout = {}
	local oldPieceNames = {}
	local newPieceNames = {}
	for moveIndex, move in ipairs( args ) do
--mw.log( "Doing move number " .. moveIndex )
		pieceInfo[moveIndex] = {}
		local layout = convertFenToArgs( move )
		local checkPieceLoc = function ( layout, row, trow, tcol, allowOverride, registerPiece, realPieceName ) 
			local col = rev and ( 1 + ncols - tcol ) or tcol
			local piece = layout[ncols * ( nrows - row ) + col + 2] or ''
			local pieceName = piece:match( pattern )
			if pieceName then
				while true do
					if realPieceName then
						pieceName = realPieceName
					end
					-- If there is a promotion you might suddenly have multiple of the same piece.
					if pieceInfo[moveIndex][pieceName] or (not(allowOverride) and pieceInfo[moveIndex][pieceName] == false)  then
						pieceName = pieceName .. '_'
					else
						break
					end
				end
				if registerPiece then
--mw.log( "placing " .. pieceName )
					definedPieces[pieceName] = true
					pieceInfo[moveIndex][pieceName] = { ( trow - 1 ) * size, ( tcol - 1 ) * size }
					newPieceNames[ (( trow - 1 ) * size) .. (( tcol - 1 ) * size)] = pieceName
				else
--mw.log( "Marking " .. pieceName .. " as used but so far skipped" )
					pieceInfo[moveIndex][pieceName] = false
				end
			end
		end
		local availablePieces = {}
		for trow = 1,nrows do
			local row = rev and trow or ( 1 + nrows - trow )
			for tcol = 1,ncols do
				-- Hacky, but first do this for pieces that haven't moved, then for pieces that have.

				local col = rev and ( 1 + ncols - tcol ) or tcol
				local samePiece = (layout[ncols * ( nrows - row ) + col + 2] or '') == (oldLayout[ncols * ( nrows - row ) + col + 2] or '')
				local realPiece = oldPieceNames[ (( trow - 1 ) * size) .. (( tcol - 1 ) * size)]
				local originalPiece = (oldLayout[ncols * ( nrows - row ) + col + 2] or ''):match(pattern)
				if samePiece then
					checkPieceLoc( oldLayout, row, trow, tcol, false, true, realPiece )
					--mw.log( "first round. doing " .. trow .. "x" .. tcol .. " for " .. (layout[ncols * ( nrows - row ) + col + 2] or '') )
				else
					checkPieceLoc( oldLayout, row, trow, tcol, false, false, realPiece )
					if originalPiece and realPiece then
						availablePieces[originalPiece] = realPiece --realPiece
					end
					--mw.log( "first round skip. doing " .. trow .. "x" .. tcol .. " for " .. (layout[ncols * ( nrows - row ) + col + 2] or '') )
				end
			end
		end
		for trow = 1,nrows do
			local row = rev and trow or ( 1 + nrows - trow )
			for tcol = 1,ncols do
				-- Hacky, now do this for moved pieces

				local col = rev and ( 1 + ncols - tcol ) or tcol
				local samePiece = (layout[ncols * ( nrows - row ) + col + 2] or '') == (oldLayout[ncols * ( nrows - row ) + col + 2] or '')
				if not(samePiece) then
					--mw.log( "Second round. doing " .. trow .. "x" .. tcol .. " for " .. (layout[ncols * ( nrows - row ) + col + 2] or '') )

					local originalPiece = (layout[ncols * ( nrows - row ) + col + 2] or ''):match(pattern)
					checkPieceLoc( layout, row, trow, tcol, true, true, availablePieces[originalPiece] )
				end
			end
		end
		oldLayout = layout
		oldPieceNames = newPieceNames
	end

	return definedPieces, pieceInfo
end


function chessboard(definedPieces, pieceInfo, size, color, rev, letters, numbers, header, footer, align, clear, ply)
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
				:addClass( 'boardlabel' )
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
		:addClass( 'calculator-container' )
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
		:addClass( 'calculator-field' )
		:attr( 'data-calculator-type', 'passthru' )
		:attr( 'data-calculator-formula', 'rotate' )

	if ( letters_top ) then
		b:tag('tr')
			:addClass( 'boardlabel' )
			:wikitext(letters_row( rev, numbers_left, numbers_right ))
	end
	local tablerow = b:tag('tr')
	if ( numbers_left ) then 
		tablerow:tag('td')
			:css('width', '18px')
			:css('height', size .. 'px')
			:addClass( 'boardlabel' )
			:wikitext(rev and 1 or nrows) 
	end
	local td = tablerow:tag('td')
		:attr('colspan', ncols)
		:attr('rowspan', nrows)
		:wikitext(innerboard(definedPieces, pieceInfo, size, color, rev, ply))
	
	if ( numbers_right ) then 
		tablerow:tag('td')
			:css('width', '18px')
			:css('height', size .. 'px')
			:addClass( 'boardlabel' )
			:wikitext(rev and 1 or nrows) 
	end
	if ( numbers_left or numbers_right ) then
		for trow = 2, nrows do
			local idx = rev and trow or ( 1 + nrows - trow )
			tablerow = b:tag('tr')
			if ( numbers_left ) then 
				tablerow:tag('td')
					:css('height', size .. 'px')
					:addClass( 'boardlabel' )
					:wikitext(idx)
			end
			if ( numbers_right ) then 
				tablerow:tag('td')
					:css('height', size .. 'px')
					:addClass( 'boardlabel' )
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

-- Based on Module:Pgn analyzePgn()
-- Currently this assumes the full game is recorded and the move numbers are in order
local function getCaptionTable(pgn)
	pgn = string.gsub(pgn, '%[(.*)%]', '')
	local moves = {}
	local steps = mw.text.split(pgn, '%s*%d+%.%s*')
	for _, step in ipairs(steps) do
		if mw.ustring.len(mw.text.trim(step)) then
			ssteps = mw.text.split(step, '%s+')
			for _, sstep in ipairs(ssteps) do 
				if sstep and not mw.ustring.match(sstep, '^%s*$') then table.insert(moves, sstep) end
			end
		end
	end
	return moves
end

local function makeMoveCaption(pgn, ply, initial, frame)
	local moves = getCaptionTable(pgn)
	-- \194\160 = nbsp. Want to make sure height is consistent.
	local mapping = { ['\194\160'] = "default" }
	local default = initial or '\194\160'
	for i, mv in pairs( moves ) do
		local text = ''
		text = text .. math.floor((i+1)/2)
		if (i+1)%2 == 0 then
			text = text .. '. '
		else
			text = text .. '… '
		end
		text = text .. mv
		mapping[text] = i+1
		if i+1 == ply and initial == nil then
			default = text
		end
	end
	local jsonMapping = mw.text.jsonEncode( mapping )
	-- Not sure what is best for screen readers here as these aren't words. This is probably sub-par
	-- Probably best would be to convert to human "Rook to whatever" and put that off-screen
	return frame:preprocess( '<div class="chess-move-caption">{{calculator|style=speak-as: spell-out|type=plain|default=' .. default .. '|mapping=' .. jsonMapping .. '|formula=move}}</div>' )
end



local function getPieceMoves( definedPieces, pieceInfo )
	local ret = ''
	for piece in pairs( definedPieces ) do
		local curTop = -1
		local curLeft = -1
		local switchTop = 'switch(move,'
		local switchLeft = 'switch(move,'
		for moveNumber, move in ipairs( pieceInfo ) do
			if (move[piece] and move[piece][1] or -1) ~= curTop then
				switchTop = switchTop .. (moveNumber-1) .. ',' .. curTop .. ','
				curTop = (move[piece] and move[piece][1] or -1)
			end
			if move[piece] and move[piece][2] or -1 ~= curLeft then
				switchLeft = switchLeft .. (moveNumber-1) .. ',' .. curLeft .. ','
				curLeft = (move[piece] and move[piece][2] or -1)
			end
		end
		switchTop = switchTop .. curTop .. ')'
		switchLeft = switchLeft .. curLeft .. ')'
		ret = ret .. '{{calculator|type=hidden|formula=' .. switchTop .. '|id=top_piece' .. piece  ..'}}'
		ret = ret .. '{{calculator|type=hidden|formula=' .. switchLeft .. '|id=left_piece' .. piece .. '}}'
	end
	return ret
end

function p.board(frame)
	local args = frame.args
	local pargs = frame:getParent().args
	local style = args.style or pargs.style or 'Chess'
	nrows, ncols = cfg.dims()
	
	local size = args.size or pargs.size or '26'
	local color = args.color or pargs.color or nil
	local reverse = ( args.reverse or pargs.reverse or '' ):lower() == "true"
	local letters = ( args.letters or pargs.letters or 'both' ):lower() 
	local numbers = ( args.numbers or pargs.numbers or 'both' ):lower() 
	local header = args[2] or pargs[2] or ''
	local footer = args[nrows*ncols + 3] or pargs[nrows*ncols + 3] or ''
	local align = ( args[1] or pargs[1] or 'tright' ):lower()
	local clear = args.clear or pargs.clear or ( align:match('tright') and 'right' ) or 'none'
	local ply = tonumber(args.ply or pargs.ply or 1)

	local pgn = args.pgn or pargs.pgn
	local moves, metadata
	local definedPieces, pieceInfo

	size = mw.ustring.match( size, '[%d]+' ) or '26' -- remove px from size

	assert( pgn, "pgn argument required" )
	local pgnModule = require('Module:Pgn')
	metadata, moves = pgnModule.main(pgn)
	definedPieces, pieceInfo = getPositions( moves, size, reverse )
	ply = math.max( 1, math.min( ply, #moves ) )

	align = args.align or pargs.align or 'tright'
	clear = args.clear or pargs.clear or ( align:match('tright') and 'right' ) or 'none'
	header = args.header or pargs.header or ''
	footer = ''
	if yesno(args.show_move or pargs.show_move) or false then
		footer = makeMoveCaption(pgn, ply, args.initial_caption or pargs.initial_caption, frame)
	end
	footer = footer .. (args.footer or pargs.footer or '')
	footer = footer .. frame:extensionTag( 'templatestyles', '', { src = 'Module:Chess_viewer/styles.css' } )
	if yesno(args.animate or pargs.animate or true) then
		align = align .. ' animate'
	end
	header = header .. frame:preprocess( '<div style="display:none" class="calculatorgadget-enabled">'
				.. '{{calculator button|disabled=iflessorequal(move,1)|contents=←|title=Go back one move|alt=Go back one move|for=move|type=default|formula=max(1, move-1)}}'
				.. ' {{calculator button|contents=☯|alt=Rotate board|title=Rotate board|for=rotate|type=default|formula=(rotate+1)%2}} '
				.. ' {{calculator button|disabled=ifgreaterorequal(move,'..#moves.. ')|contents={{calculator|type=plain|mapping={"▶": 0, "⏸": 1}|default=▶|formula=and(timer(),ifless(move,'..#moves.. '))}}|alt=Playback game|title=Play|for=move|type=default|formula=min(' .. (#moves) .. ', move+1)|delay=0.7|toggle=true|until=ifgreaterorequal(move,'.. #moves .. ')|max iterations=' .. #moves .. '}} '
				.. '{{calculator button|disabled=ifgreaterorequal(move,'..#moves.. ')|contents=→|title=Go forward one move|alt=Go forward one move|for=move|type=default|formula=min(' .. (#moves) .. ', move+1)}}'
				.. '{{calculator|type=hidden|default=' .. ply .. '|id=move}}'
				.. '{{calculator|type=hidden|default=0|id=rotate}}</div>'
	)
	footer = footer .. frame:preprocess( getPieceMoves( definedPieces, pieceInfo ) )
	return chessboard( definedPieces, pieceInfo, size, color, reverse, letters, numbers, header, footer, align, clear, ply )
end

return p
