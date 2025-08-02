--[[--------------------------< S I N G L E S _ T >-----------------------------------------------------------

list of Latn and Zyyy (common) codepoints that are not included in <ranges_t> taken from Module:Unicode data/scripts
and a local copy of https://www.unicode.org/Public/16.0.0/ucd/ScriptExtensions.txt

]]

local singles_t = {
	[170] = true,																-- 00AA
	[186] = true,																-- 00BA
	[215] = true,																-- 00D7
	[247] = true,																-- 00F7
	[787] = true,																-- 0313
	[800] = true,																-- 0320
	[856] = true,																-- 0358
	[862] = true,																-- 035E
	[884] = true,																-- 0374
	[894] = true,																-- 037E
	[901] = true,																-- 0385
	[903] = true,																-- 0387
	[1541] = true,																-- 0605
	[1548] = true,																-- 060C
	[1563] = true,																-- 061B
	[1567] = true,																-- 061F
	[1600] = true,																-- 0640
	[1757] = true,																-- 06DD
	[2274] = true,																-- 08E2
	[3647] = true,																-- 0E3F
	[4347] = true,																-- 10FB
	[6149] = true,																-- 1805
	[7379] = true,																-- 1CD3
	[7393] = true,																-- 1CE1
	[7418] = true,																-- 1CFA
	[7672] = true,																-- 1DF8
	[8305] = true,																-- 2071
	[8319] = true,																-- 207F
	[8432] = true,																-- 20F0
	[8498] = true,																-- 2132
	[8526] = true,																-- 214E
	[12294] = true,																-- 3006
	[12448] = true,																-- 30A0
	[12783] = true,																-- 31EF
	[13055] = true,																-- 32FF
	[42963] = true,																-- A7D3
	[43310] = true,																-- A92E
	[43471] = true,																-- A9CF
	[43867] = true,																-- AB5B
	[65279] = true,																-- FEFF
	[65392] = true,																-- FF70
	[119970] = true,															-- 1D4A2
	[119995] = true,															-- 1D4BB
	[120134] = true,															-- 1D546
	[129008] = true,															-- 1F7F0
	[917505] = true,															-- E0001
	}


--[[--------------------------< R A N G E S _ T >-------------------------------------------------------------

list of Latn and Zyyy (common) codepoints taken from Module:Unicode data/scripts and a local copy of
https://www.unicode.org/Public/16.0.0/ucd/ScriptExtensions.txt

]]

local ranges_t = {
	{0, 169},																	-- 0000..00A9
	{171, 185},																	-- 00AB..00B9
	{187, 214},																	-- 00BB..00D6
	{216, 246},																	-- 00D8..00F6
	{248, 745},																	-- 00F8..02E9
	{748, 782},																	-- 02EC..030E
	{784, 785},																	-- 0310..0311
	{803, 805},																	-- 0323..0325
	{813, 814},																	-- 032D..032E
	{816, 817},																	-- 0330..0331
	{867, 879},																	-- 0363..036F
	{1157, 1158},																-- 0485..0486
	{2385, 2386},																-- 0951..0952
	{2404, 2405},																-- 0964..0965
	{4053, 4056},																-- 0FD5..0FD8
	{5867, 5869},																-- 16EB..16ED
	{5941, 5942},																-- 1735..1736
	{6146, 6147},																-- 1802..1803
	{7401, 7404},																-- 1CE9..1CEC
	{7406, 7411},																-- 1CEE..1CF3
	{7413, 7415},																-- 1CF5..1CF7
	{7424, 7461},																-- 1D00..1D25
	{7468, 7516},																-- 1D2C..1D5C
	{7522, 7525},																-- 1D62..1D65
	{7531, 7543},																-- 1D6B..1D77
	{7545, 7614},																-- 1D79..1DBE
	{7680, 7935},																-- 1E00..1EFF
	{8192, 8203},																-- 2000..200B
	{8206, 8292},																-- 200E..2064
	{8294, 8304},																-- 2066..2070
	{8308, 8318},																-- 2074..207E
	{8320, 8334},																-- 2080..208E
	{8336, 8348},																-- 2090..209C
	{8352, 8384},																-- 20A0..20C0
	{8448, 8485},																-- 2100..2125
	{8487, 8497},																-- 2127..2131
	{8499, 8525},																-- 2133..214D
	{8527, 8587},																-- 214F..218B
	{8592, 9257},																-- 2190..2429
	{9280, 9290},																-- 2440..244A
	{9312, 10239},																-- 2460..27FF
	{10496, 11123},																-- 2900..2B73
	{11126, 11157},																-- 2B76..2B95
	{11159, 11263},																-- 2B97..2BFF
	{11360, 11391},																-- 2C60..2C7F
	{11776, 11869},																-- 2E00..2E5D
	{12272, 12292},																-- 2FF0..3004
	{12296, 12320},																-- 3008..3020
	{12336, 12343},																-- 3030..3037
	{12348, 12351},																-- 303C..303F
	{12443, 12444},																-- 309B..309C
	{12539, 12540},																-- 30FB..30FC
	{12688, 12703},																-- 3190..319F
	{12736, 12773},																-- 31C0..31E5
	{12832, 12895},																-- 3220..325F
	{12927, 13007},																-- 327F..32CF
	{13144, 13311},																-- 3358..33FF
	{19904, 19967},																-- 4DC0..4DFF
	{42752, 42957},																-- A700..A7CD
	{42960, 42961},																-- A7D0..A7D1
	{42965, 42972},																-- A7D5..A7DC
	{42994, 43007},																-- A7F2..A7FF
	{43056, 43065},																-- A830..A839
	{43824, 43866},																-- AB30..AB5A
	{43868, 43876},																-- AB5C..AB64
	{43878, 43883},																-- AB66..AB6B
	{64256, 64262},																-- FB00..FB06
	{64830, 64831},																-- FD3E..FD3F
	{65040, 65049},																-- FE10..FE19
	{65072, 65106},																-- FE30..FE52
	{65108, 65126},																-- FE54..FE66
	{65128, 65131},																-- FE68..FE6B
	{65281, 65381},																-- FF01..FF65
	{65438, 65439},																-- FF9E..FF9F
	{65504, 65510},																-- FFE0..FFE6
	{65512, 65518},																-- FFE8..FFEE
	{65529, 65533},																-- FFF9..FFFD
	{65792, 65794},																-- 10100..10102
	{65799, 65843},																-- 10107..10133
	{65847, 65855},																-- 10137..1013F
	{65936, 65948},																-- 10190..1019C
	{66000, 66044},																-- 101D0..101FC
	{66273, 66299},																-- 102E1..102FB
	{67456, 67461},																-- 10780..10785
	{67463, 67504},																-- 10787..107B0
	{67506, 67514},																-- 107B2..107BA
	{113824, 113827},															-- 1BCA0..1BCA3
	{117760, 118009},															-- 1CC00..1CCF9
	{118016, 118451},															-- 1CD00..1CEB3
	{118608, 118723},															-- 1CF50..1CFC3
	{118784, 119029},															-- 1D000..1D0F5
	{119040, 119078},															-- 1D100..1D126
	{119081, 119142},															-- 1D129..1D166
	{119146, 119162},															-- 1D16A..1D17A
	{119171, 119172},															-- 1D183..1D184
	{119180, 119209},															-- 1D18C..1D1A9
	{119214, 119274},															-- 1D1AE..1D1EA
	{119488, 119507},															-- 1D2C0..1D2D3
	{119520, 119539},															-- 1D2E0..1D2F3
	{119552, 119638},															-- 1D300..1D356
	{119648, 119672},															-- 1D360..1D378
	{119808, 119892},															-- 1D400..1D454
	{119894, 119964},															-- 1D456..1D49C
	{119966, 119967},															-- 1D49E..1D49F
	{119973, 119974},															-- 1D4A5..1D4A6
	{119977, 119980},															-- 1D4A9..1D4AC
	{119982, 119993},															-- 1D4AE..1D4B9
	{119997, 120003},															-- 1D4BD..1D4C3
	{120005, 120069},															-- 1D4C5..1D505
	{120071, 120074},															-- 1D507..1D50A
	{120077, 120084},															-- 1D50D..1D514
	{120086, 120092},															-- 1D516..1D51C
	{120094, 120121},															-- 1D51E..1D539
	{120123, 120126},															-- 1D53B..1D53E
	{120128, 120132},															-- 1D540..1D544
	{120138, 120144},															-- 1D54A..1D550
	{120146, 120485},															-- 1D552..1D6A5
	{120488, 120779},															-- 1D6A8..1D7CB
	{120782, 120831},															-- 1D7CE..1D7FF
	{122624, 122654},															-- 1DF00..1DF1E
	{122661, 122666},															-- 1DF25..1DF2A
	{126065, 126132},															-- 1EC71..1ECB4
	{126209, 126269},															-- 1ED01..1ED3D
	{126976, 127019},															-- 1F000..1F02B
	{127024, 127123},															-- 1F030..1F093
	{127136, 127150},															-- 1F0A0..1F0AE
	{127153, 127167},															-- 1F0B1..1F0BF
	{127169, 127183},															-- 1F0C1..1F0CF
	{127185, 127221},															-- 1F0D1..1F0F5
	{127232, 127405},															-- 1F100..1F1AD
	{127462, 127487},															-- 1F1E6..1F1FF
	{127489, 127490},															-- 1F201..1F202
	{127504, 127547},															-- 1F210..1F23B
	{127552, 127560},															-- 1F240..1F248
	{127568, 127569},															-- 1F250..1F251
	{127584, 127589},															-- 1F260..1F265
	{127744, 128727},															-- 1F300..1F6D7
	{128732, 128748},															-- 1F6DC..1F6EC
	{128752, 128764},															-- 1F6F0..1F6FC
	{128768, 128886},															-- 1F700..1F776
	{128891, 128985},															-- 1F77B..1F7D9
	{128992, 129003},															-- 1F7E0..1F7EB
	{129024, 129035},															-- 1F800..1F80B
	{129040, 129095},															-- 1F810..1F847
	{129104, 129113},															-- 1F850..1F859
	{129120, 129159},															-- 1F860..1F887
	{129168, 129197},															-- 1F890..1F8AD
	{129200, 129211},															-- 1F8B0..1F8BB
	{129216, 129217},															-- 1F8C0..1F8C1
	{129280, 129619},															-- 1F900..1FA53
	{129632, 129645},															-- 1FA60..1FA6D
	{129648, 129660},															-- 1FA70..1FA7C
	{129664, 129673},															-- 1FA80..1FA89
	{129679, 129734},															-- 1FA8F..1FAC6
	{129742, 129756},															-- 1FACE..1FADC
	{129759, 129769},															-- 1FADF..1FAE9
	{129776, 129784},															-- 1FAF0..1FAF8
	{129792, 129938},															-- 1FB00..1FB92
	{129940, 130041},															-- 1FB94..1FBF9
	{917536, 917631},															-- E0020..E007F
	}


--[[--------------------------< S P E C I A L S _ T >---------------------------------------------------------

list of individual language-specific non-Latn and non-Zyyy codepoints; these codepoints commonly used in
transliterations.  This list is manually currated so is most likely incomplete.

keys to <specials_t> are decimal codepoints; other keys are language tags (always lowercase) of language
transliterations that use these non-Latn codepoints.

]]

local specials_t = {
	[788] = {																	-- U+0314: COMBINING REVERSED COMMA ABOVE
			["hy"] = true,														-- Armenian
			},
	[794] = {																	-- U+031A: COMBINING LEFT ANGLE ABOVE
			["ltc"] = true,														-- Middle Chinese; is this really IPA?
			},
	[795] = {																	-- U+031B: COMBINING HORN
			["th"] = true,														-- Thai
			},
	[806] = {																	-- U+0326: COMBINING COMMA BELOW
			["ab"] = true,														-- Abkhaz
			["kca"] = true,														-- Khanty
			["xal"] = true,														-- Kalmyk or Oirat
			},
	[807] = {																	-- U+0327: COMBINING CEDILLA
			["fa"] = true,														-- Persian
			},
	[809] = {																	-- U+0329: COMBINING VERTICAL LINE BELOW
			["ab"] = true,														-- Abkhaz
			["sa"] = true,														-- Sanskrit
			},
	[815] = {																	-- U+032F: COMBINING INVERTED BREVE BELOW
			["mong"] = true,													-- Mongolian
			["xsc"] = true,														-- Scythian
			},
	[818] = {																	-- U+0332: COMBINING LOW LINE
			["ar"] = true,														-- Arabic
			["hbo"] = true,														-- Ancient Hebrew
			["he"] = true,														-- Hebrew
			["jpa"] = true,														-- Jewish Palestinian Aramaic
			["mdh"] = true,														-- Maguindanaon
			["otk"] = true,														-- Old Turkish
			},
	[831] = {																	-- U+033F: COMBINING DOUBLE OVERLINE
			["mnp"] = true,														-- Northern Min Chinese, Jian'ou dialect
			},
	[855] = {																	-- U+0357: COMBINING RIGHT HALF RING ABOVE
			["egy"] = true,														-- Ancient Egyptian
			},
	[863] = {																	-- U+035F: COMBINING DOUBLE MACRON BELOW
			["am"] = true,														-- Amharic
			["ar"] = true,														-- Arabic
			["dv"] = true,														-- Dhivehi, Divehi, or Maldivian
			["fa"] = true,														-- Persian
			["hi"] = true,														-- Hindi
			["inc"] = true,														-- Indic languages
			["ur"] = true,														-- Urdu
			},
	[864] = {																	-- U+0360: COMBINING DOUBLE TILDE
			["hi"] = true,														-- Hindi
			},
	[865] = {																	-- U+0361: COMBINING DOUBLE INVERTED BREVE
			["be"] = true,														-- Belarusian
			["ltc"] = true,														-- Middle Chinese; is this really IPA?
			["ru"] = true,														-- Russian
			["rue"] = true, 													-- Rusyn
			["sem"] = true,														-- Semitic languages
			["sit"] = true,														-- Sino-Tibetan languages
			["tt"] = true,														-- Tatar
			},
	[916] = {																	-- U+0394: GREEK CAPITAL LETTER DELTA
			["xsc"] = true,														-- Scythian
			},
	[920] = {																	-- U+0398: GREEK CAPITAL LETTER THETA
			["ae"] = true,														-- Avestan
			},
	[934] = {																	-- U+03A6: GREEK CAPITAL LETTER PHI
			["xle"] = true,														-- Lemnian
			},
	[945] = {																	-- U+03B1: GREEK SMALL LETTER ALPHA
			["apc"] = true,														-- Levantine Arabic
			},
	[946] = {																	-- U+03B2: GREEK SMALL LETTER BETA
			["ae"] = true,														-- Avestan
			["gha"] = true,														-- Ghadamès
			["ougr"] = true,													-- Old Uyghur
			["sem"] = true,														-- Semitic languages
			["syc"] = true,														-- Classical Syriac
			["wuu"] = true,														-- Shanghainese variety of Wu Chinese
			},
	[947] = {																	-- U+03B3: GREEK SMALL LETTER GAMMA
			["ae"] = true,														-- Avestan
			["ltc"] = true,														-- Late Middle Chinese
			["mn"] = true,														-- Mongolian
			["och"] = true,														-- Old Chinese
			["ougr"] = true,													-- Old Uyghur
			["pal"] = true,														-- Middle Persian
			["syc"] = true,														-- Classical Syriac
			["syr"] = true,														-- Syriac
			["xal"] = true,														-- Kalmyk or Oirat
			["xng"] = true,														-- Middle Mongolian
			["xsc"] = true,														-- Scythian
			["mong"] = true,													-- Mongolian
			},
	[948] = {																	-- U+03B4: GREEK SMALL LETTER DELTA
			["ae"] = true,														-- Avestan
			["ougr"] = true,													-- Old Uyghur
			["sog"] = true,														-- Sogdian
			["sogd"] = true,													-- Sogdian
			["syc"] = true,														-- Classical Syriac
			["xpr"] = true,														-- Parthian
			["xsc"] = true,														-- Scythian
			["xsc-x-pontic"] = true,											-- Pontic Scythian
			},
	[952] = {																	-- U+03B8: GREEK SMALL LETTER THETA
			["ae"] = true,														-- Avestan
			["ba"] = true,														-- Bashkir
			["cms"] = true,														-- Messapic
			["ett"] = true,														-- Etruscan
			["hur"] = true,														-- Halkomelem
			["ira"] = true,														-- Iranian languages
			["my"] = true,														-- Burmese
			["pal"] = true,														-- Middle Persian (Pahlavi)
			["peo"] = true,														-- Old Persian
			["sa"] = true,														-- Sanskrit
			["sem"] = true,														-- Semitic languages
			["syc"] = true,														-- Classical Syriac
			["syr"] = true,														-- Syriac
			["xpg"] = true,														-- Phrygian
			["xpr"] = true,														-- Parthian
			["xsc"] = true,														-- Scythian
			},
	[955] = {																	-- U+03BB: GREEK SMALL LETTER LAMDA
			["xcr"] = true,														-- Carian
			["xld"] = true,														-- Lydian
			},
	[963] = {																	-- U+03C3: GREEK SMALL LETTER SIGMA
			["ett"] = true,														-- Etruscan
			},
	[964] = {																	-- U+03C4: GREEK SMALL LETTER TAU
			["xld"] = true,														-- Lydian
			},
	[966] = {																	-- U+03C6: GREEK SMALL LETTER PHI
			["ett"] = true,														-- Etruscan
			},
	[967] = {																	-- U+03C7: GREEK SMALL LETTER CHI
			["ett"] = true,														-- Etruscan
			["gem"] = true,														-- Germanic languages
			["kbd"] = true,														-- Kabardian
			["ltc"] = true,														-- Late Middle Chinese
			["och"] = true,														-- Old Chinese
			["xlc"] = true,														-- Lycian
			["xle"] = true,														-- Lemnian
			},
	[968] = {																	-- U+03C8: GREEK SMALL LETTER PSI
			["ett"] = true,														-- Etruscan
			},
	[977] = {																	-- U+03D1: GREEK THETA SYMBOL
			["ae"] = true,														-- Avestan
			["xme"] = true,														-- Median
			["xsc"] = true,														-- Scythian
			["xsc-x-pontic"] = true,											-- Pontic Scythian
			},
	[1098] = {																	-- U+044A: CYRILLIC SMALL LETTER HARD SIGN
			["ady"] = true,														-- Adyghe
			["cu"] = true,														-- Church Slavic
			["zls"] = true,														-- South Slavic languages
			},
	[1100] = {																	-- U+044C: CYRILLIC SMALL LETTER SOFT SIGN
			["az"] = true,														-- Azerbaijani
			["cu"] = true,														-- Church Slavonic
			["dng"] = true,														-- Dungan
			["ru"] = true,														-- Russian
			["tt"] = true,														-- Tatar
			["tyv"] = true,														-- Tuvinian
			},
	[1278] = {																	-- U+04FE: CYRILLIC CAPITAL LETTER HA WITH STROKE
			["av"] = true,														-- Avar
			},
	[1279] = {																	-- U+04FF: CYRILLIC SMALL LETTER HA WITH STROKE
			["av"] = true,														-- Avar
			},
	[8113] = {																	-- U+1FB1: GREEK SMALL LETTER ALPHA WITH MACRON
			["apc"] = true,														-- Levantine Arabic
			},
	[8190] = {																	-- U+1FFE: GREEK DASIA
			["ar"] = true,														-- Arabic (Ayin)
			["xcl"] = true,														-- Classical Armenian
			},
	[19978] = {																	-- U+4E0A: [CJK Unified Ideographs]
			["wuu"] = true,														-- Wu Chinese tone marker
			},
	[20837] = {																	-- U+5165: [CJK Unified Ideographs]
			["wuu"] = true,														-- Wu Chinese tone marker
			},
	[21435] = {																	-- U+53BB: [CJK Unified Ideographs]
			["wuu"] = true,														-- Wu Chinese tone marker
			},
	[24179] = {																	-- U+5E73: [CJK Unified Ideographs]
			["wuu"] = true,														-- Wu Chinese tone marker
			},
	[38451] = {																	-- U+9633: [CJK Unified Ideographs] (Yang)
			["wuu"] = true,														-- Suzhou dialect of Wu Chinese tone marker --[[Suzhou dialect#Tones]]
			},
	[38452] = {																	-- U+9634: [CJK Unified Ideographs] (Yin)
			["wuu"] = true,														-- Suzhou dialect of Wu Chinese tone marker --[[Suzhou dialect#Tones]]
			},
	[65056] = {																	-- U+FE20: COMBINING LIGATURE LEFT HALF
			["ru"] = true,														-- Russian
			},
	[65057] = {																	-- U+FE21: COMBINING LIGATURE RIGHT HALF
			["ru"] = true,														-- Russian
			},
	}


--[[--------------------------< E X P O R T S >---------------------------------------------------------------
]]

return {
	ranges_t = ranges_t,
	singles_t = singles_t,
	specials_t = specials_t,
	
	sizeof_ranges_t = #ranges_t,
	}
