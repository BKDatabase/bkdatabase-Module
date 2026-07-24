local yesNo = require("Module:Yesno")
local Text = { serial = "2024-09-21",
               suite  = "Text" }
--[=[
Text utilities
]=]

local function fiatQuote( apply, alien, advance )
    -- Quote text
    -- Parameter:
    --     apply    -- string, with text
    --     alien    -- string, with language code
    --     advance  -- number, with level 1 or 2
    local r = apply and tostring(apply) or ""
    alien = alien or "en"
    advance = tonumber(advance) or 0
    local suite
    local data = mw.loadData('Module:Text/data')
    local QuoteLang = data.QuoteLang
    local QuoteType = data.QuoteType
    local slang = alien:match( "^(%l+)-" )
    suite = QuoteLang[alien] or slang and QuoteLang[slang] or QuoteLang["en"]
    if suite then
        local quotes = QuoteType[ suite ]
        if quotes then
            local space
            if quotes[ 3 ] then
                space = "&#160;"
            else
                space = ""
            end
            quotes = quotes[ advance ]
            if quotes then
                r = mw.ustring.format( "%s%s%s%s%s",
                                       mw.ustring.char( quotes[ 1 ] ),
                                       space,
                                       apply,
                                       space,
                                       mw.ustring.char( quotes[ 2 ] ) )
            end
        else
            mw.log( "fiatQuote() " .. suite )
        end
    end
    return r
end -- fiatQuote()



Text.char = function ( apply, again, accept )
    -- Create string from codepoints
    -- Parameter:
    --     apply   -- table (sequence) with numerical codepoints, or nil
    --     again   -- number of repetitions, or nil
    --     accept  -- true, if no error messages to be appended
    -- Returns: string
    local r = ""
    apply = type(apply) == "table" and apply or {}
    again = math.floor(tonumber(again) or 1)
    if again < 1 then
    	return ""
    end
    local bad   = { }
    local codes = { }
    for _, v in ipairs( apply ) do
    	local n = tonumber(v)
    	if not n or (n < 32 and n ~= 9 and n ~= 10) then
    		table.insert(bad, tostring(v))
    	else
    		table.insert(codes, math.floor(n))
		end
    end 
    if #bad > 0 then
    	if not accept then
    		r = tostring(  mw.html.create( "span" )
                    		:addClass( "error" )
                    		:wikitext( "bad codepoints: " .. table.concat( bad, " " )) )
    	end
    	return r
    end
    if #codes > 0 then
    	r = mw.ustring.char( unpack( codes ) )
    	if again > 1 then
    		r = r:rep(again)
    	end
	end
    return r
end -- Text.char()

local function trimAndFormat(args, fmt)
	local result = {}
	if type(args) ~= 'table' then
		args = {args}
	end
	for _, v in ipairs(args) do
		v = mw.text.trim(tostring(v))
		if v ~= "" then
			table.insert(result,fmt and mw.ustring.format(fmt, v) or v)
		end
	end
	return result
end

Text.concatParams = function ( args, apply, adapt )
    -- Concat list items into one string
    -- Parameter:
    --     args   -- table (sequence) with numKey=string
    --     apply  -- string (optional); separator (default: "|")
    --     adapt  -- string (optional); format including "%s"
    -- Returns: string
    local collect = { }
    return table.concat(trimAndFormat(args,adapt), apply or "|")
end -- Text.concatParams()



Text.containsCJK = function ( s )
    -- Is any CJK code within?
    -- Parameter:
    --     s  -- string
    -- Returns: true, if CJK detected
    s = s and tostring(s) or ""
    local patternCJK = mw.loadData('Module:Text/data').PatternCJK
    return mw.ustring.find( s, patternCJK ) ~= nil
end -- Text.containsCJK()

Text.removeDelimited = function (s, prefix, suffix)
	-- Remove all text in s delimited by prefix and suffix (inclusive)
	-- Arguments:
	--    s = string to process
	--    prefix = initial delimiter
	--    suffix = ending delimiter
	-- Returns: stripped string
	s = s and tostring(s) or ""
	prefix = prefix and tostring(prefix) or ""
	suffix = suffix and tostring(suffix) or ""
	local prefixLen = mw.ustring.len(prefix)
	local suffixLen = mw.ustring.len(suffix)
	if prefixLen == 0 or suffixLen == 0 then
		return s
	end
	local i = s:find(prefix, 1, true)
	local r = s
	local j
	while i do
		j = r:find(suffix, i + prefixLen)
		if j then
			r = r:sub(1, i - 1)..r:sub(j+suffixLen)
		else
			r = r:sub(1, i - 1)
		end
		i = r:find(prefix, 1, true)
	end
	return r
end

Text.getPlain = function ( adjust )
    -- Remove wikisyntax from string, except templates
    -- Parameter:
    --     adjust  -- string
    -- Returns: string
    local r = Text.removeDelimited(adjust,"<!--","-->")
    r = r:gsub( "(</?%l[^>]*>)", "" )
         :gsub( "'''", "" )
         :gsub( "''", "" )
         :gsub( "&nbsp;", " " )
    return r
end -- Text.getPlain()

Text.isLatinRange = function (s)
    -- Are characters expected to be latin or symbols within latin texts?
    -- Arguments:
    --  s = string to analyze
    -- Returns: true, if valid for latin only
    s = s and tostring(s) or ""  --- ensure input is always string
    local PatternLatin = mw.loadData('Module:Text/data').PatternLatin
    return mw.ustring.match(s, PatternLatin) ~= nil
end -- Text.isLatinRange()



Text.isQuote = function ( s )
    -- Is this character any quotation mark?
    -- Parameter:
    --     s = single character to analyze
    -- Returns: true, if s is quotation mark
    s = s and tostring(s) or ""
    if s == "" then
    	return false
    end
    local SeekQuote = mw.loadData('Module:Text/data').SeekQuote
    return mw.ustring.find( SeekQuote, s, 1, true ) ~= nil
end -- Text.isQuote()



Text.listToText = function ( args, adapt )
    -- Format list items similar to mw.text.listToText()
    -- Parameter:
    --     args   -- table (sequence) with numKey=string
    --     adapt  -- string (optional); format including "%s"
    -- Returns: string
    return mw.text.listToText(trimAndFormat(args, adapt))
end -- Text.listToText()



Text.quote = function ( apply, alien, advance )
    -- Quote text
    -- Parameter:
    --     apply    -- string, with text
    --     alien    -- string, with language code, or nil
    --     advance  -- number, with level 1 or 2, or nil
    -- Returns: quoted string
    apply = apply and tostring(apply) or ""
    local mode, slang
    if type( alien ) == "string" then
        slang = mw.text.trim( alien ):lower()
    else
        slang = mw.title.getCurrentTitle().pageLanguage
        if not slang then
            -- TODO FIXME: Introduction expected 2017-04
            slang = mw.language.getContentLanguage():getCode()
        end
    end
    if advance == 2 then
        mode = 2
    else
        mode = 1
    end
    return fiatQuote( mw.text.trim( apply ), slang, mode )
end -- Text.quote()



Text.quoteUnquoted = function ( apply, alien, advance )
    -- Quote text, if not yet quoted and not empty
    -- Parameter:
    --     apply    -- string, with text
    --     alien    -- string, with language code, or nil
    --     advance  -- number, with level 1 or 2, or nil
    -- Returns: string; possibly quoted
    local r = mw.text.trim( apply and tostring(apply) or "" )
    local s = mw.ustring.sub( r, 1, 1 )
    if s ~= ""  and  not Text.isQuote( s, advance ) then
        s = mw.ustring.sub( r, -1, 1 )
        if not Text.isQuote( s ) then
            r = Text.quote( r, alien, advance )
        end
    end
    return r
end -- Text.quoteUnquoted()



Text.removeDiacritics = function ( adjust )
    -- Remove all diacritics
    -- Parameter:
    --     adjust  -- string
    -- Returns: string; all latin letters should be ASCII
    --                  or basic greek or cyrillic or symbols etc.
    local cleanup, decomposed
    local PatternCombined = mw.loadData('Module:Text/data').PatternCombined
    decomposed = mw.ustring.toNFD( adjust and tostring(adjust) or "" )
    cleanup    = mw.ustring.gsub( decomposed, PatternCombined, "" )
    return mw.ustring.toNFC( cleanup )
end -- Text.removeDiacritics()



Text.sentenceTerminated = function ( analyse )
    -- Is string terminated by dot, question or exclamation mark?
    --     Quotation, link termination and so on granted
    -- Parameter:
    --     analyse  -- string
    -- Returns: true, if sentence terminated
    local r
    local PatternTerminated = mw.loadData('Module:Text/data').PatternTerminated
    if mw.ustring.find( analyse, PatternTerminated ) then
        r = true
    else
        r = false
    end
    return r
end -- Text.sentenceTerminated()



Text.ucfirstAll = function ( adjust)
    -- Capitalize all words
    -- Arguments:
    --     adjust = string to adjust
    -- Returns: string with all first letters in upper case
    adjust = adjust and tostring(adjust) or ""
    local r = mw.text.decode(adjust,true)
    local i = 1
    local c, j, m
    m = (r ~= adjust)
    r = " "..r
    while i do
        i = mw.ustring.find( r, "%W%l", i )
        if i then
            j = i + 1
            c = mw.ustring.upper( mw.ustring.sub( r, j, j ) )
            r = string.format( "%s%s%s",
                               mw.ustring.sub( r, 1, i ),
                               c,
                               mw.ustring.sub( r, i + 2 ) )
            i = j
        end
    end -- while i
    r = r:sub( 2 )
    if m then
    	r = mw.text.encode(r)
    end
    return r
end -- Text.ucfirstAll()


Text.uprightNonlatin = function ( adjust )
    -- Ensure non-italics for non-latin text parts
    --     One single greek letter might be granted
    -- Precondition:
    --     adjust  -- string
    -- Returns: string with non-latin parts enclosed in <span>
    local r
    local data = mw.loadData('Module:Text/data')
    local PatternLatin = data.PatternLatin
    local RangesLatin = data.RangesLatin
    local NumLatinRanges = data.NumLatinRanges
    if mw.ustring.match( adjust, PatternLatin ) then
        -- latin only, horizontal dashes, quotes
        r = adjust
    else
        local c
        local j    = false
        local k    = 1
        local m    = false
        local n    = mw.ustring.len( adjust )
        local span = "%s%s<span dir='auto' style='font-style:normal'>%s</span>"
        local flat = function ( a )
                  -- isLatin
                  local range
                  -- NumLatinRanges has to be precomputed because # does not work from loadData
                  for i = 1, NumLatinRanges do
                      range = RangesLatin[ i ]
                      if a >= range[ 1 ]  and  a <= range[ 2 ] then
                          return true
                      end
                  end    -- for i
              end -- flat()
        local focus = function ( a )
                  -- char is not ambivalent
                  local r = ( a > 64 )
                  if r then
                      r = ( a < 8192  or  a > 8212 )
                  else
                      r = ( a == 38  or  a == 60 )    -- '&' '<'
                  end
                  return r
              end -- focus()
        local form = function ( a )
                return string.format( span,
                                      r,
                                      mw.ustring.sub( adjust, k, j - 1 ),
                                      mw.ustring.sub( adjust, j, a ) )
              end -- form()
        r = ""
        for i = 1, n do
            c = mw.ustring.codepoint( adjust, i, i )
            if focus( c ) then
                if flat( c ) then
                    if j then
                        if m then
                            if i == m then
                                -- single greek letter.
                                j = false
                            end
                            m = false
                        end
                        if j then
                            local nx = i - 1
                            local s  = ""
                            for ix = nx, 1, -1 do
                                c = mw.ustring.sub( adjust, ix, ix )
                                if c == " "  or  c == "(" then
                                    nx = nx - 1
                                    s  = c .. s
                                else
                                    break -- for ix
                                end
                            end -- for ix
                            r = form( nx ) .. s
                            j = false
                            k = i
                        end
                    end
                elseif not j then
                    j = i
                    if c >= 880  and  c <= 1023 then
                        -- single greek letter?
                        m = i + 1
                    else
                        m = false
                    end
                end
            elseif m then
                m = m + 1
            end
        end    -- for i
        if j  and  ( not m  or  m < n ) then
            r = form( n )
        else
            r = r .. mw.ustring.sub( adjust, k )
        end
    end
    return r
end -- Text.uprightNonlatin()


Text.test = function ( about )
    local r
    if about == "quote" then
        data = mw.loadData('Module:Text/data')
        r = { }
        r.QuoteLang = data.QuoteLang
        r.QuoteType = data.QuoteType
    end
    return r
end -- Text.test()

-- Non Unicode-aware version of mw.text.split and mw.text.gsplit
-- based on [[phab:diffusion/ELUA/browse/master/includes/Engines/LuaCommon/lualib/mw.text.lua]]
-- These run up to 60 times faster than the Unicode-aware versions
Text.split = function ( text, pattern, plain )
	local ret = {}
	for m in Text.gsplit( text, pattern, plain ) do
		ret[#ret+1] = m
	end
	return ret
end

Text.gsplit = function ( text, pattern, plain )
	local s, l = 1, string.len( text )
	return function ()
		if s then
			local e, n = string.find( text, pattern, s, plain )
			local ret
			if not e then
				ret = string.sub( text, s )
				s = nil
			elseif n < e then
				-- Empty separator!
				ret = string.sub( text, s, e )
				if e < l then
					s = e + 1
				else
					s = nil
				end
			else
				ret = e > s and string.sub( text, s, e - 1 ) or ''
				s = n + 1
			end
			return ret
		end
	end, nil, nil
end

-- Export
local p = { }

for _, func in ipairs({'containsCJK','isLatinRange','isQuote','sentenceTerminated'}) do
	p[func] = function (frame) 
		return Text[func]( frame.args[ 1 ] or "" ) and "1" or ""
	end
end

for _, func in ipairs({'getPlain','removeDiacritics','ucfirstAll','uprightNonlatin'}) do
	p[func] = function (frame) 
		return Text[func]( frame.args[ 1 ] or "" )
	end
end

function p.char( frame )
    local params = frame:getParent().args
    local story = params[ 1 ]
    local codes, lenient, multiple
    if not story then
        params = frame.args
        story  = params[ 1 ]
    end
    if story then
        local items = mw.text.split( mw.text.trim(story), "%s+" )
        if #items > 0 then
            local j
            lenient  = (yesNo(params.errors) == false)
            codes    = { }
            multiple = tonumber( params[ "*" ] )
            for _, v in ipairs( items ) do
            	j = tonumber((v:sub( 1, 1 ) == "x" and "0" or "") .. v)
                table.insert( codes,  j or v )
            end 
        end
    end
    return Text.char( codes, multiple, lenient )
end

function p.concatParams( frame )
    local args
    local template = frame.args.template
    if type( template ) == "string" then
        template = mw.text.trim( template )
        template = ( template == "1" )
    end
    if template then
        args = frame:getParent().args
    else
        args = frame.args
    end
    return Text.concatParams( args,
                              frame.args.separator,
                              frame.args.format )
end


function p.listToFormat(frame)
    local lists = {}
    local pformat = frame.args["format"]
    local sep = frame.args["sep"] or ";"

    -- Parameter parsen: Listen
    for k, v in pairs(frame.args) do
        local knum = tonumber(k)
        if knum then lists[knum] = v end
    end

    -- Listen splitten
    local maxListLen = 0
    for i = 1, #lists do
        lists[i] = mw.text.split(lists[i], sep)
        if #lists[i] > maxListLen then maxListLen = #lists[i] end
    end

    -- Ergebnisstring generieren
    local result = ""
    local result_line = ""
    for i = 1, maxListLen do
        result_line = pformat
        for j = 1, #lists do
            result_line = mw.ustring.gsub(result_line, "%%s", lists[j][i], 1)
        end
        result = result .. result_line
    end

    return result
end



function p.listToText( frame )
    local args
    local template = frame.args.template
    if type( template ) == "string" then
        template = mw.text.trim( template )
        template = ( template == "1" )
    end
    if template then
        args = frame:getParent().args
    else
        args = frame.args
    end
    return Text.listToText( args, frame.args.format )
end



function p.quote( frame )
    local slang = frame.args[2]
    if type( slang ) == "string" then
        slang = mw.text.trim( slang )
        if slang == "" then
            slang = false
        end
    end
    return Text.quote( frame.args[ 1 ] or "",
                       slang,
                       tonumber( frame.args[3] ) )
end



function p.quoteUnquoted( frame )
    local slang = frame.args[2]
    if type( slang ) == "string" then
        slang = mw.text.trim( slang )
        if slang == "" then
            slang = false
        end
    end
    return Text.quoteUnquoted( frame.args[ 1 ] or "",
                               slang,
                               tonumber( frame.args[3] ) )
end


function p.zip(frame)
    local lists = {}
    local seps = {}
    local defaultsep = frame.args["sep"] or ""
    local innersep = frame.args["isep"] or ""
    local outersep = frame.args["osep"] or ""

    -- Parameter parsen
    for k, v in pairs(frame.args) do
        local knum = tonumber(k)
        if knum then lists[knum] = v else
            if string.sub(k, 1, 3) == "sep" then
                local sepnum = tonumber(string.sub(k, 4))
                if sepnum then seps[sepnum] = v end
            end
        end
    end
    -- sofern keine expliziten Separatoren angegeben sind, den Standardseparator verwenden
    for i = 1, math.max(#seps, #lists) do
        if not seps[i] then seps[i] = defaultsep end
    end

    -- Listen splitten
    local maxListLen = 0
    for i = 1, #lists do
        lists[i] = mw.text.split(lists[i], seps[i])
        if #lists[i] > maxListLen then maxListLen = #lists[i] end
    end

    local result = ""
    for i = 1, maxListLen do
        if i ~= 1 then result = result .. outersep end
        for j = 1, #lists do
            if j ~= 1 then result = result .. innersep end
            result = result .. (lists[j][i] or "")
        end
    end
    return result
end


function p.split(frame)
	local text = frame.args.text or frame.args[1] or ''
	local pattern = frame.args.pattern or frame.args[2] or ''
	local plain = yesNo(frame.args.plain or frame.args[3])
	local index = tonumber(frame.args.index) or tonumber(frame.args[4]) or 1
	local a = Text.split(text, pattern, plain)
	if index < 0 then index = #a + index + 1 end
	return a[index]
end


function p.failsafe()
    return Text.serial
end


p.Text = function ()
    return Text
end -- p.Text

return p