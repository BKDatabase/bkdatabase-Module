-- Data required by [[Module:Text]]. 
-- Either Lua string patterns (defined by codepoint) or information about quotes

local data = {}

local LEFT_SQUARE_BRACKET = 91
local RIGHT_SQUARE_BRACKET = 93
local HYPHEN = 45

data.PatternCJK = mw.ustring.char( LEFT_SQUARE_BRACKET,
        	                       4352,   HYPHEN,   4607,
        	                       11904,  HYPHEN,  42191,
        	                       43072,  HYPHEN,  43135,
        	                       44032,  HYPHEN,  55215,
        	                       63744,  HYPHEN,  64255,
        	                       65072,  HYPHEN,  65103,
        	                       65381,  HYPHEN,  65500,
                                   131072, HYPHEN, 196607,
                                   RIGHT_SQUARE_BRACKET )

data.PatternCombined = mw.ustring.char( LEFT_SQUARE_BRACKET,
                                        0x0300, HYPHEN, 0x036F,
                                        0x1AB0, HYPHEN, 0x1AFF,
                                        0x1DC0, HYPHEN, 0x1DFF,
                                        0xFE20, HYPHEN, 0xFE2F,
                                        RIGHT_SQUARE_BRACKET )

local RangesLatin = { { 7,  687 },
                    { 7531, 7578 },
                    { 7680, 7935 },
                    { 8194, 8250 } }
local PatternLatin = "^["
for i = 1, #RangesLatin do
    local range = RangesLatin[ i ]
    PatternLatin = PatternLatin .. mw.ustring.char( range[ 1 ], HYPHEN, range[ 2 ] )
end  
PatternLatin = PatternLatin .. "]*$"
data.RangesLatin = RangesLatin
data.NumLatinRanges = #RangesLatin
data.PatternLatin = PatternLatin

data.PatternTerminated = mw.ustring.char( LEFT_SQUARE_BRACKET,
                                          12290,
                                          65281,
                                          65294,
                                          65311 )
                            .. "!%.%?…][\"'%]‹›«»‘’“”]*$"

data.QuoteLang = { af        = "bd",
                   ar        = "la",
                   be        = "labd",
                   bg        = "bd",
                   ca        = "la",
                   cs        = "bd",
                   da        = "bd",
                   de        = "bd",
                   dsb       = "bd",
                   et        = "bd",
                   el        = "lald",
                   en        = "ld",
                   es        = "la",
                   eu        = "la",
            --     fa        = "la",
                   fi        = "rd",
                   fr        = "laSPC",
                   ga        = "ld",
                   he        = "ldla",
                   hr        = "bd",
                   hsb       = "bd",
                   hu        = "bd",
                   hy        = "labd",
                   id        = "rd",
                   is        = "bd",
                   it        = "ld",
                   ja        = "x300C",
                   ka        = "bd",
                   ko        = "ld",
                   lt        = "bd",
                   lv        = "bd",
                   nl        = "ld",
                   nn        = "la",
                   no        = "la",
                   pl        = "bdla",
                   pt        = "lald",
                   ro        = "bdla",
                   ru        = "labd",
                   sk        = "bd",
                   sl        = "bd",
                   sq        = "la",
                   sr        = "bx",
                   sv        = "rd",
                   th        = "ld",
                   tr        = "ld",
                   uk        = "la",
                   zh        = "ld",
                   ["de-ch"] = "la",
                   ["en-gb"] = "lsld",
                   ["en-us"] = "ld",
                   ["fr-ch"] = "la",
                   ["it-ch"] = "la",
                   ["pt-br"] = "ldla",
                   ["zh-tw"] = "x300C",
                   ["zh-cn"] = "ld" }

data.QuoteType = { bd    = { { 8222, 8220 },  { 8218, 8217 } },
                   bdla  = { { 8222, 8220 },  {  171,  187 } },
                   bx    = { { 8222, 8221 },  { 8218, 8217 } },
                   la    = { {  171,  187 },  { 8249, 8250 } },
                   laSPC = { {  171,  187 },  { 8249, 8250 },  true },
                   labd  = { {  171,  187 },  { 8222, 8220 } },
                   lald  = { {  171,  187 },  { 8220, 8221 } },
                   ld    = { { 8220, 8221 },  { 8216, 8217 } },
                   ldla  = { { 8220, 8221 },  {  171,  187 } },
                   lsld  = { { 8216, 8217 },  { 8220, 8221 } },
                   rd    = { { 8221, 8221 },  { 8217, 8217 } },
                   x300C = { { 0x300C, 0x300D },
                             { 0x300E, 0x300F } } }

data.SeekQuote = mw.ustring.char(   34,       -- "
                                    39,       -- '
                                   171,       -- laquo
                                   187,       -- raquo
                                  8216,       -- lsquo
                                  8217,       -- rsquo
                                  8218,       -- sbquo
                                  8220,       -- ldquo
                                  8221,       -- rdquo
                                  8222,       -- bdquo
                                  8249,       -- lsaquo
                                  8250,       -- rsaquo
                                  0x300C,     -- CJK
                                  0x300D,     -- CJK
                                  0x300E,     -- CJK
                                  0x300F )    -- CJK

return data