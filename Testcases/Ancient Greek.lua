--[=[
	Modified from [[wikt:Module:grc-translit/testcases]].
]=]

local tests = require('Module:UnitTests')
local translit = require('Module:Ancient Greek')
local decompose = mw.ustring.toNFC

local function tag(text)
	return '<span lang="grc">' .. text .. '</span>'
end

function tests:check_output(term, Wiktionary, ALA_LC)
	tests:equals(
		tag(term),
		decompose(translit.transliterate(term, "Wiktionary")),
		decompose(Wiktionary)
	)
	
	tests:equals(
		tag(term),
		decompose(translit.transliterate(term, "ALA-LC")),
		decompose(ALA_LC)
	)
end

function tests:test_translit()
	local examples = {
		{ 'λόγος', 'lógos', 'logos' },
		{ 'σφίγξ', 'sphínx', 'sphinx' },
		{ 'ϝάναξ', 'wánax', 'wanax' },
		{ 'οἷαι', 'hoîai', 'hoiai' },
		
		-- test u/y
		{ 'ταῦρος', 'taûros', 'tauros' },
		{ 'νηῦς', 'nēûs', 'nēus' },
		{ 'σῦς', 'sûs', 'sys' },
		{ 'ὗς', 'hûs', 'hys' },
		{ 'γυῖον', 'guîon', 'guion' },
		{ 'ἀναῡ̈τέω', 'anaṻtéō', 'anayteō' },
		{ 'δαΐφρων', 'daḯphrōn', 'daiphrōn' },
		
		-- test length
		{ 'τῶν', 'tôn', 'tōn' },
		{ 'τοὶ', 'toì', 'toi' },
		{ 'τῷ', 'tôi', 'tō' },
		{ 'τούτῳ', 'toútōi', 'toutō' },
		{ 'σοφίᾳ', 'sophíāi', 'sophia' },
		{ 'μᾱ̆νός', 'mānós', 'manos' }, -- should perhaps be mā̆nos
		
		-- test h
		{ 'ὁ', 'ho', 'ho' },
		{ 'οἱ', 'hoi', 'hoi' },
		{ 'εὕρισκε', 'heúriske', 'heuriske' },
		{ 'ὑϊκός', 'huïkós', 'hyikos' },
		{ 'πυρρός', 'purrhós', 'pyrrhos' },
		{ 'ῥέω', 'rhéō', 'rheō' },
		{ 'σάἁμον', 'sáhamon', 'sahamon' },
	
		-- test capitals
		{ 'Ὀδυσσεύς', 'Odusseús', 'Odysseus' },
		{ 'Εἵλως', 'Heílōs', 'Heilōs' },
		{ 'ᾍδης', 'Hā́idēs', 'Hadēs' },
		{ 'ἡ Ἑλήνη', 'hē Helḗnē', 'hē Helēnē' },
		
		-- punctuation
		{ 'ἔχεις μοι εἰπεῖν, ὦ Σώκρατες, ἆρα διδακτὸν ἡ ἀρετή;', 'ékheis moi eipeîn, ô Sṓkrates, âra didaktòn hē aretḗ?', 'echeis moi eipein, ō Sōkrates, ara didakton hē aretē?'},
		{ 'τί τηνικάδε ἀφῖξαι, ὦ Κρίτων; ἢ οὐ πρῲ ἔτι ἐστίν;', 'tí tēnikáde aphîxai, ô Krítōn? ḕ ou prṑi éti estín?', 'ti tēnikade aphixai, ō Kritōn? ē ou prō eti estin?' },
		-- This ought to be colon, but sadly that cannot be.
		{ 'τούτων φωνήεντα μέν ἐστιν ἑπτά· α ε η ι ο υ ω.', 'toútōn phōnḗenta mén estin heptá; a e ē i o u ō.', 'toutōn phōnēenta men estin hepta; a e ē i o y ō.' },
	}
	
	self:iterate(examples, 'check_output')
end

return tests
