local p = {}

function p.dims()
	return 8, 8
end

function p.letters()
	return {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}
end

function p.image_board(size)
	return string.format( '[[File:Chessboard480.svg|%dx%dpx|link=|class=notpageimage]]', 8 * size, 8 * size )
end

function p.image_square( pc, row, col, size )
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
	local alt = colchar[col] .. row .. ' '
	
	if colornames[color] and piecenames[piece] then
		alt = alt .. colornames[color] .. ' ' .. piecenames[piece]
	else
		alt = alt .. ( symnames[piece .. color] or piece .. ' ' .. color )
	end

	return string.format( '[[File:Chess %s%st45.svg|%dx%dpx|alt=%s|%s|link=|class=notpageimage|top]]', piece, color, size, size, alt, alt )

end

return p
