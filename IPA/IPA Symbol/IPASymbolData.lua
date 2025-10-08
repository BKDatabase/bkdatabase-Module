local data = {
	sounds = {},
	diacritics = {},
	univPatterns = {
		{
			pat = "g", -- Latin Small Letter G
			rep = "ɡ" -- Latin Small Letter Script G
		},
		{
			pat = "ᵍ", -- Modifier Letter Small G
			rep = "ᶢ" -- Modifier Letter Small Script G
		},
		{
			pat = "l̴", -- 'l' + Combining Tilde Overlay
			rep = "ɫ" -- Latin Small Letter L with Middle Tilde
		},
		{
			pat = "ˁ", -- Modifier Letter Reversed Glottal Stop
			rep = "ˤ" -- Modifier Letter Small Reversed Glottal Stop
		},
		{
			pat = "’", -- Right Single Quotation Mark
			rep = "ʼ" -- Modifier Letter Apostrophe
		},
		{
			pat = "ȷ", -- Latin Small Letter Dotless J
			rep = "j" -- Latin Small Letter J
		},
		{
			pat = "ʇ", -- Latin Small Letter Turned T
			rep = "ǀ" -- Latin Letter Dental Click
		},
		{
			pat = "[!ʗ]", -- Exclamation Mark / Latin Letter Stretched C
			rep = "ǃ" -- Latin Letter Retroflex Click
		},
		{
			pat = "ǃǃ", -- Latin Letter Retroflex Click x 2
			rep = "‼" -- Double Exclamation Mark
		},
		{
			pat = "ʖ", -- Latin Letter Inverted Glottal Stop
			rep = "ǁ" -- Latin Letter Lateral Click
		},
		{
			pat = "ꞵ", -- Latin Small Letter Beta
			rep = "β" -- Greek Small Letter Beta
		},
		{
			pat = "γ", -- Greek Small Letter Gamma
			rep = "ɣ" -- Latin Small Letter Gamma
		},
		{
			pat = "φ", -- Greek Small Letter Phi
			rep = "ɸ" -- Latin Small Letter Phi
		},
		{
			pat = "ꭓ", -- Latin Small Letter Chi
			rep = "χ" -- Greek Small Letter Chi
		},
		
	},
	keyPatterns = {
		-- These do not affect the revese look for diacritics
		{
			pat = "[͜͡ːˑ◌]", -- Tie bars, length marks, dotted circle
			rep = ""
			
		},
		{
			pat = "ᵏ", -- Modifier Letter Small K
			rep = "k" -- Latin Small Letter K
		},
		{
			pat = "ᶢ", -- Modifier Letter Small Script G
			rep = "ɡ" -- Latin Small Letter Script G
		},
		{
			pat = "ᵑ", -- Modifier Letter Small Eng
			rep = "ŋ" -- Latin Small Letter Eng
		},
	}
}

local rawData = {
	sounds = {
		-- Phụ âm có luồng hơi từ phổi
		-- Âm mũi
		{
			name = "Âm mũi môi-môi vô thanh",
			symbols = { "m̥" },
		},
		{
			name = "Âm mũi môi-môi hữu thanh",
			symbols = { "m" },
			audio = "Bilabial nasal.ogg"
		},
		{
			name = "Âm mũi môi-răng hữu thanh",
			symbols = { "ɱ" },
			audio = "Labiodental nasal.ogg"
		},
		{
			name = "Âm mũi lưỡi-môi hữu thanh",
			symbols = { "n̼" },
			audio = "Linguolabial nasal.ogg"
		},
		{
			name = "Âm mũi răng hữu thanh",
			symbols = { "n̪" },
		},
		{
			name = "Âm mũi lợi vô thanh",
			symbols = { "n̥" },
		},
		{
			name = "Âm mũi lợi hữu thanh",
			symbols = { "n" },
			audio = "Alveolar nasal.ogg"
		},
		{
			name = "Âm mũi sau lợi hữu thanh",
			symbols = { "n̠" },
		},
		{
			name = "Âm mũi quặt lưỡi vô thanh",
			symbols = { "ɳ̊", "ɳ̥" },
		},
		{
			name = "Âm mũi quặt lưỡi hữu thanh",
			symbols = { "ɳ" },
			audio = "Retroflex nasal.ogg"
		},
		{
			name = "Âm mũi lợi-ngạc-cứng vô thanh",
			symbols = { "n̠̊ʲ", "ɲ̊˖", "ɲ̟̊", "ȵ̊" },
		},
		{
			name = "Âm mũi lợi-ngạc-cứng hữu thanh",
			symbols = { "n̠ʲ", "ɲ˖", "ɲ̟", "ȵ" },
		},
		{
			name = "Âm mũi ngạc cứng vô thanh",
			symbols = { "ɲ̊", "ɲ̥" },
		},
		{
			name = "Âm mũi ngạc cứng hữu thanh",
			symbols = { "ɲ" },
			audio = "Palatal nasal.ogg"
		},
		{
			name = "Âm mũi sau lợi hữu thanh",
			symbols = { "ɲ˗", "ɲ̠", "ŋ˖", "ŋ̟" },
		},
		{
			name = "Âm mũi ngạc mềm vô thanh",
			symbols = { "ŋ̊", "ŋ̥" },
		},
		{
			name = "Âm mũi ngạc mềm hữu thanh",
			symbols = { "ŋ" },
			audio = "Velar nasal.ogg"
		},
		{
			name = "Âm mũi trước tiểu thiệt hữu thanh",
			symbols = { "ɴ̟", "ŋ˗", "ŋ̠" },
		},
		{
			name = "Âm mũi tiểu thiệt hữu thanh",
			symbols = { "ɴ" },
			audio = "Uvular nasal.ogg"
		},
		-- Âm tắc
		{
			name = "Âm tắc môi-môi vô thanh",
			symbols = { "p" },
			audio = "Voiceless bilabial plosive.ogg"
		},
		{
			name = "Âm tắc môi-môi hữu thanh",
			symbols = { "b" },
			audio = "Voiced bilabial plosive.ogg"
		},
		{
			name = "Âm tắc môi-răng vô thanh",
			symbols = { "p̪", "p͆" },
		},
		{
			name = "Âm tắc môi-răng hữu thanh",
			symbols = { "b̪" },
		},
		{
			name = "Âm tắc lưỡi-môi vô thanh",
			symbols = { "t̼" },
			audio = "Voiceless linguolabial stop.ogg"
		},
		{
			name = "Âm tắc lưỡi-môi hữu thanh",
			symbols = { "d̼" },
			audio = "Voiced linguolabial stop.ogg"
		},
		{
			name = "Âm tắc răng vô thanh",
			symbols = { "t̪" },
			audio = "Voiceless dental stop.ogg"
		},
		{
			name = "Âm tắc răng hữu thanh",
			symbols = { "d̪" },
			audio = "Voiced dental stop.ogg"
		},
		{
			name = "Âm tắc lợi vô thanh",
			symbols = { "t" },
			audio = "Voiceless alveolar plosive.ogg"
		},
		{
			name = "Âm tắc lợi hữu thanh",
			symbols = { "d" },
			audio = "Voiced alveolar plosive.ogg"
		},
		{
			name = "Âm tắc sau lợi vô thanh",
			symbols = { "t̠" },
		},
		{
			name = "Âm tắc sau lợi hữu thanh",
			symbols = { "d̠" },
		},
		{
			name = "Âm tắc quặt lưỡi vô thanh",
			symbols = { "ʈ" },
			audio = "Voiceless retroflex stop.oga"
		},
		{
			name = "Âm tắc quặt lưỡi hữu thanh",
			symbols = { "ɖ" },
			audio = "Voiced retroflex stop.oga"
		},
		{
			name = "Âm tắc lợi-ngạc-cứng vô thanh",
			symbols = { "t̠ʲ", "c̟", "ȶ" },
		},
		{
			name = "Âm tắc lợi-ngạc-cứng hữu thanh",
			symbols = { "d̠ʲ", "ɟ˖", "ɟ̟", "ȡ" },
		},
		{
			name = "Âm tắc ngạc cứng vô thanh",
			symbols = { "c" },
			audio = "Voiceless palatal plosive.ogg"
		},
		{
			name = "Âm tắc ngạc cứng hữu thanh",
			symbols = { "ɟ" },
			audio = "Voiced palatal plosive.ogg"
		},
		{
			name = "Âm tắc sau ngạc cứng vô thanh",
			symbols = { "c̠", "k̟" },
		},
		{
			name = "Âm tắc sau ngạc cứng hữu thanh",
			symbols = { "ɟ˗", "ɟ̠", "ɡ˖", "ɡ̟" },
		},
		{
			name = "Âm tắc ngạc mềm vô thanh",
			symbols = { "k" },
			audio = "Voiceless velar plosive.ogg"
		},
		{
			name = "Âm tắc ngạc mềm hữu thanh",
			symbols = { "ɡ" },
			audio = "Voiced velar plosive 02.ogg"
		},
		{
			name = "Âm tắc trước tiểu thiệt vô thanh",
			symbols = { "q˖", "q̟", "k̠" },
		},
		{
			name = "Âm tắc trước tiểu thiệt hữu thanh",
			symbols = { "ɢ̟", "ɡ˗", "ɡ̠" },
		},
		{
			name = "Âm tắc tiểu thiệt vô thanh",
			symbols = { "q" },
			audio = "Voiceless uvular plosive.ogg"
		},
		{
			name = "Âm tắc tiểu thiệt hữu thanh",
			symbols = { "ɢ" },
			audio = "Voiced uvular stop.oga"
		},
		{
			name = "Âm tắc nắp họng",
			symbols = { "ʡ" },
			audio = "Epiglottal stop.ogg"
		},
		{
			name = "Âm tắc thanh hầu",
			symbols = { "ʔ" },
			audio = "Glottal stop.ogg"
		},
		-- Âm tắc-xát
		{
			name = "Âm tắc-xát môi-môi vô thanh",
			symbols = { "pɸ" },
			audio = "Voiceless bilabial affricate.ogg"
		},
		{
			name = "Âm tắc-xát môi-môi hữu thanh",
			symbols = { "bβ" },
		},
		{
			name = "Âm tắc-xát lưỡi-răng vô thanh",
			symbols = { "p̪f", "p͆f", "pf" },
			audio = "Voiceless labiodental affricate.ogg"
		},
		{
			name = "Âm tắc-xát lưỡi-răng hữu thanh",
			symbols = { "b̪v", "bv" },
			audio = "Voiced labiodental affricate.ogg"
		},
		{
			name = "Âm tắc-xát răng vô thanh",
			symbols = { "t̪s̪", "ts̪", "t̟s̟", "ts̟" },
			audio = "Voiceless dental sibilant affricate.oga"
		},
		{
			name = "Âm tắc-xát răng hữu thanh",
			symbols = { "d̪z̪", "dz̪", "d̟z̟", "dz̟" },
			audio = "Voiced dental sibilant affricate.oga"
		},
		{
			name = "Âm tắc-xát không xuýt răng vô thanh",
			symbols = { "t̪θ", "t̟θ", "tθ" },
			audio = "Voiceless dental non-sibilant affricate.oga"
		},
		{
			name = "Âm tắc-xát không xuýt răng hữu thanh",
			symbols = { "d̪ð", "d̟ð", "dð" },
			audio = "Voiced dental non-sibilant affricate.oga"
		},
		{
			name = "Âm tắc-xát lợi vô thanh",
			symbols = { "ts", "ʦ" },
			audio = "Voiceless alveolar sibilant affricate.oga"
		},
		{
			name = "Âm tắc-xát lợi hữu thanh",
			symbols = { "dz", "ʣ" },
			audio = "Voiced alveolar sibilant affricate.oga"
		},
		{
			name = "Âm tắc-xát chóp-lưỡi-lợi vô thanh",
			symbols = { "t̺s̺", "ts̺", "t̠s̠", "ts̠" },
		},
		{
			name = "Âm tắc-xát chóp-lưỡi-lợi hữu thanh",
			symbols = { "d̺z̺", "dz̺", "d̠z̠", "dz̠" },
		},
		{
			name = "Âm tắc-xát không xuýt lợi vô thanh",
			symbols = { "tɹ̝̊", "tɹ̥", "tθ̠", "tθ͇" },
		},
		{
			name = "Âm tắc-xát không xuýt lợi hữu thanh",
			symbols = { "dɹ̝", "dɹ", "dð̠", "dð͇" },
		},
		{
			name = "Âm tắc-xát sau lợi vô thanh",
			symbols = { "t̠ʃ", "tʃ", "ʧ" },
			audio = "Voiceless palato-alveolar affricate.ogg"
		},
		{
			name = "Âm tắc-xát sau lợi hữu thanh",
			symbols = { "d̠ʒ", "dʒ", "ʤ" },
			audio = "Voiced palato-alveolar affricate.ogg"
		},
		{
			name = "Âm tắc-xát không xuýt sau lợi vô thanh",
			symbols = { "t̠ɹ̠̊˔", "tɹ̠̊˔", "tɹ̝̊˗", "t̠ɹ̝̊˗", "t̠ɹ̠̊", "tɹ̠̊" },
			audio = "Voiceless postalveolar non-sibilant affricate.ogg"
		},
		{
			name = "Âm tắc-xát không xuýt sau lợi hữu thanh",
			symbols = { "d̠ɹ̠˔", "dɹ̠˔", "dɹ̝˗", "d̠ɹ̝˗", "d̠ɹ̠", "dɹ̠" },
			audio = "Voiced postalveolar non-sibilant affricate.ogg"
		},
		{
			name = "Âm tắc-xát quặt lưỡi vô thanh",
			symbols = { "ʈʂ", "tʂ" },
			audio = "Voiceless retroflex affricate.ogg"
		},
		{
			name = "Âm tắc-xát quặt lưỡi hữu thanh",
			symbols = { "ɖʐ", "dʐ" },
			audio = "Voiced retroflex affricate.ogg"
		},
		{
			name = "Âm tắc-xát lợi-ngạc-cứng vô thanh",
			symbols = { "tɕ", "cɕ", "ʨ" },
			audio = "Voiceless alveolo-palatal affricate.ogg"
		},
		{
			name = "Âm tắc-xát lợi-ngạc-cứng hữu thanh",
			symbols = { "dʑ", "ɟʑ", "ʥ" },
			audio = "Voiced alveolo-palatal affricate.ogg"
		},
		{
			name = "Âm tắc-xát ngạc cứng vô thanh",
			symbols = { "cç" },
			audio = "Voiceless palatal affricate.ogg"
		},
		{
			name = "Âm tắc-xát ngạc cứng hữu thanh",
			symbols = { "ɟʝ" },
			audio = "Voiced palatal affricate.ogg"
		},
		{
			name = "Âm tắc-xát sau ngạc cứng vô thanh",
			symbols = { "c̠ç˗", "cç˗", "c̠ç̠", "cç̠", "k̟x̟", "kx̟" },
		},
		{
			name = "Âm tắc-xát sau ngạc cứng hữu thanh",
			symbols = { "ɟ˗ʝ˗", "ɟʝ˗", "ɟ̠ʝ̠", "ɟʝ̠", "ɡ˖ɣ˖", "ɡɣ˖", "ɡ̟ɣ̟", "ɡɣ̟" },
		},
		{
			name = "Âm tắc-xát ngạc mềm vô thanh",
			symbols = { "kx" },
			audio = "Voiceless velar affricate.ogg"
		},
		{
			name = "Âm tắc-xát ngạc mềm hữu thanh",
			symbols = { "ɡɣ" },
			audio = "Voiced velar affricate.ogg"
		},
		{
			name = "Âm tắc-xát trước tiểu thiệt vô thanh",
			symbols = { "q˖χ˖", "qχ˖", "q̟χ̟", "qχ̟", "k̠x̠", "kx̠" },
		},
		{
			name = "Âm tắc-xát tiểu thiệt vô thanh",
			symbols = { "qχ" },
			audio = "Voiceless uvular affricate.ogg"
		},
		{
			name = "Âm tắc-xát tiểu thiệt hữu thanh",
			symbols = { "ɢʁ" },
			audio = "Voiced uvular affricate.ogg"
		},
		{
			name = "Âm tắc-xát yết hầu vô thanh",
			symbols = { "ʡħ" },
		},
		{
			name = "Âm tắc-xát nắp họng vô thanh",
			symbols = { "ʡʜ" },
			audio = "Voiceless epiglottal affricate.ogg"
		},
		{
			name = "Âm tắc-xát nắp họng hữu thanh",
			symbols = { "ʡʢ" },
			audio = "Voiced epiglottal affricate.ogg"
		},
		{
			name = "Âm tắc-xát thanh hầu vô thanh",
			symbols = { "ʔh" },
			audio = "Voiceless glottal affricate.ogg"
		},
		-- Âm xát
		{
			name = "Âm xát môi-môi vô thanh",
			symbols = { "ɸ", "β̞̊", "β̥˕" },
			audio = "Voiceless bilabial fricative.ogg"
		},
		{
			name = "Âm xát môi-môi hữu thanh",
			symbols = { "β" },
			audio = "Voiced bilabial fricative.ogg"
		},
		{
			name = "Âm xát lưỡi-răng vô thanh",
			symbols = { "f", "ʋ̥", "f̞" },
			audio = "Voiceless labio-dental fricative.ogg"
		},
		{
			name = "Âm xát lưỡi-răng hữu thanh",
			symbols = { "v" },
			audio = "Voiced labio-dental fricative.ogg"
		},
		{
			name = "Âm xát lưỡi-môi vô thanh",
			symbols = { "θ̼" },
			audio = "Voiceless linguolabial fricative.ogg"
		},
		{
			name = "Âm xát lưỡi-môi hữu thanh",
			symbols = { "ð̼" },
		},
		{
			name = "Âm xát răng vô thanh",
			symbols = { "θ", "θ̞" },
			audio = "Voiceless dental fricative.ogg"
		},
		{
			name = "Âm xát răng hữu thanh",
			symbols = { "ð" },
			audio = "Voiced dental fricative.ogg"
		},
		{
			name = "Âm xát xuýt răng vô thanh",
			symbols = { "s̪" },
		},
		{
			name = "Âm xát xuýt răng hữu thanh",
			symbols = { "z̪" },
		},
		{
			name = "Âm xát răng-lợi vô thanh",
			symbols = { "s̻̪", "s̪̻", "s̻͆", "s̟" },
		},
		{
			name = "Âm xát lợi vô thanh",
			symbols = { "s" },
			audio = "Voiceless alveolar sibilant.ogg"
		},
		{
			name = "Âm xát lợi hữu thanh",
			symbols = { "z" },
			audio = "Voiced alveolar sibilant.ogg"
		},
		{
			name = "Âm xát chóp-lưỡi-lợi vô thanh",
			symbols = { "s̺" },
		},
		{
			name = "Âm xát chóp-lưỡi-lợi hữu thanh",
			symbols = { "z̺" },
		},
		{
			name = "Âm xát rút vào lợi vô thanh",
			symbols = { "s̠" },
			audio = "Voiceless alveolar retracted sibilant.ogg"
		},
		{
			name = "Âm xát rút vào lợi hữu thanh",
			symbols = { "z̠" },
		},
		{
			name = "Âm xát không xuýt lợi vô thanh",
			symbols = { "θ̠", "θ͇", "ɹ̝̊", "ɹ̥" },
			audio = "Voiceless alveolar non-sibilant fricative.ogg"
		},
		{
			name = "Âm xát không xuýt lợi hữu thanh",
			symbols = { "ð̠", "ð͇", "ɹ̝" },
			audio = "Voiced alveolar non-sibilant fricative.ogg"
		},
		{
			name = "Âm xát vỗ lợi vô thanh",
			symbols = { "ɾ̞̊" },
		},
		{
			name = "Âm xát vỗ lợi hữu thanh",
			symbols = { "ɾ̞" },
			audio = "Voiced alveolar tapped fricative.ogg"
		},
		{
			name = "Âm xát sau lợi vô thanh",
			symbols = { "ʃ" },
			audio = "Voiceless palato-alveolar sibilant.ogg"
		},
		{
			name = "Âm xát sau lợi hữu thanh",
			symbols = { "ʒ" },
			audio = "Voiced palato-alveolar sibilant.ogg"
		},
		{
			name = "Âm xát không xuýt sau lợi vô thanh",
			symbols = { "ɹ̠̊˔", "ɹ̝̊˗" },
			audio = "Voiceless postalveolar non-sibilant fricative.ogg"
		},
		{
			name = "Âm xát không xuýt sau lợi hữu thanh",
			symbols = { "ɹ̠˔", "ɹ̝˗" },
			audio = "Voiced postalveolar non-sibilant fricative.ogg"
		},
		{
			name = "Âm xát quặt lưỡi vô thanh",
			symbols = { "ʂ" },
			audio = "Voiceless retroflex sibilant.ogg"
		},
		{
			name = "Âm xát quặt lưỡi hữu thanh",
			symbols = { "ʐ" },
			audio = "Voiced retroflex sibilant.ogg"
		},
		{
			name = "Âm xát không xuýt quặt lưỡi vô thanh",
			symbols = { "ɻ̝̊", "ɻ̊˔" },
		},
		{
			name = "Âm xát không xuýt quặt lưỡi hữu thanh",
			symbols = { "ɻ̝", "ɻ˔", "ɻ̊" },
		},
		{
			name = "Âm xát lợi-ngạc-cứng vô thanh",
			symbols = { "ɕ" },
			audio = "Voiceless alveolo-palatal sibilant.ogg"
		},
		{
			name = "Âm xát lợi-ngạc-cứng hữu thanh",
			symbols = { "ʑ" },
			audio = "Voiced alveolo-palatal sibilant.ogg"
		},
		{
			name = "Âm xát ngạc cứng vô thanh",
			symbols = { "ç" },
			audio = "Voiceless palatal fricative.ogg"
		},
		{
			name = "Âm xát ngạc cứng hữu thanh",
			symbols = { "ʝ" },
			audio = "Voiced palatal fricative.ogg"
		},
		{
			name = "Âm xát sau ngạc cứng vô thanh",
			symbols = { "ç˗", "ç̠", "x̟" },
		},
		{
			name = "Âm xát sau ngạc cứng hữu thanh",
			symbols = { "ʝ˗", "ʝ̠", "ɣ˖", "ɣ̟" },
		},
		{
			name = "Âm xát ngạc mềm vô thanh",
			symbols = { "x", "ɰ̊", "x̞", "ɣ̊˕", "ɣ̞̊" },
			audio = "Voiceless velar fricative.ogg"
		},
		{
			name = "Âm xát ngạc mềm hữu thanh",
			symbols = { "ɣ" },
			audio = "Voiced velar fricative.ogg"
		},
		{
			name = "Âm xát trước tiểu thiệt vô thanh",
			symbols = { "χ˖", "χ̟", "x̠" },
		},
		{
			name = "Âm xát trước tiểu thiệt hữu thanh",
			symbols = { "ʁ̟", "ɣ˗", "ɣ̠" },
		},
		{
			name = "Âm xát tiểu thiệt vô thanh",
			symbols = { "χ" },
			audio = "Voiceless uvular fricative.ogg"
		},
		{
			name = "Âm xát tiểu thiệt hữu thanh",
			symbols = { "ʁ" },
			audio = "Voiced uvular fricative.ogg"
		},
		{
			name = "Âm xát yết hầu vô thanh",
			symbols = { "ħ" },
			audio = "Voiceless pharyngeal fricative.ogg"
		},
		{
			name = "Âm xát yết hầu hữu thanh",
			symbols = { "ʕ" },
			audio = "Voiced pharyngeal fricative.ogg"
		},
		{
			name = "Âm xát thanh hầu vô thanh",
			symbols = { "h" },
			audio = "Voiceless glottal fricative.ogg"
		},
		{
			name = "Âm xát thanh hầu hữu thanh",
			symbols = { "ɦ" },
			audio = "Voiced glottal fricative.ogg"
		},
		{
			name = "Âm xát răng-răng vô thanh",
			symbols = { "h̪͆" },
		},
		-- Âm tiếp cận
		{
			name = "Âm tiếp cận môi-môi vô thanh",
			symbols = { "β̞" },
			audio = "Bilabial approximant.ogg"
		},
		{
			name = "Âm tiếp cận môi-môi hữu thanh",
			symbols = { "ʋ" },
			audio = "Labiodental approximant.ogg"
		},
		{
			name = "Âm tiếp cận răng hữu thanh",
			symbols = { "ð̞" },
			audio = "Voiced dental approximant.ogg"
		},
		{
			name = "Âm tiếp cận lợi hữu thanh",
			symbols = { "ɹ" },
			audio = "Alveolar approximant.ogg"
		},
		{
			name = "Âm tiếp cận sau lợi hữu thanh",
			symbols = { "ɹ̠" },
			audio = "Postalveolar approximant.ogg"
		},
		{
			name = "Âm tiếp cận quặt lưỡi hữu thanh",
			symbols = { "ɻ" },
			audio = "Retroflex Approximant2.oga"
		},
		{
			name = "Âm tiếp cận ngạc cứng vô thanh",
			symbols = { "j̊" },
		},
		{
			name = "Âm tiếp cận ngạc cứng hữu thanh",
			symbols = { "j", "ʝ˕", "ʝ̞" },
			audio = "Palatal approximant.ogg"
		},
		{
			name = "Âm tiếp cận sau ngạc cứng hữu thanh",
			symbols = { "j˗", "j̠", "ɰ̟", "ɰ˖", "ʝ˕˗", "ʝ˗˕", "ʝ̞˗", "ɣ˕˖", "ɣ˖˕", "ɣ̞˖" },
			audio = "Post-palatal approximant.ogg"
		},
		{
			name = "Âm tiếp cận ngạc mềm hữu thanh",
			symbols = { "ɰ", "ɣ˕", "ɣ̞" },
			audio = "Voiced velar approximant.ogg"
		},
			{
			name = "Âm tiếp cận cụm ngạc mềm hữu thanh",
			symbols = { "ɹ̈ "},
		},
		{
			name = "Âm tiếp cận tiểu thiệt hữu thanh",
			symbols = { "ʁ̞" },
			audio = "Voiced Uvular Approximant.ogg"
		},
		{
			name = "Âm tiếp cận yết hầu hữu thanh",
			symbols = { "ʕ̞" },
		},
		{
			name = "Âm tiếp cận nắp họng hữu thanh",
			symbols = { "ʢ̞" },
		},
		{
			name = "Âm tiếp cận thanh hầu kẹt giọng",
			symbols = { "ʔ̞", "ʔ̰" },
		},
		-- Âm vỗ
		{
			name = "Âm vỗ môi-môi hữu thanh",
			symbols = { "ⱱ̟", "b̆" },
		},
		{
			name = "Âm vỗ môi-răng hữu thanh",
			symbols = { "ⱱ" },
			audio = "Labiodental flap.ogg"
		},
		{
			name = "Âm vỗ lưỡi-môi hữu thanh",
			symbols = { "ɾ̼" },
		},
		{
			name = "Âm vỗ răng hữu thanh",
			symbols = { "ɾ̪" },
			article = "Dental tap",
		},
		{
			name = "Âm vỗ lợi vô thanh",
			symbols = { "ɾ̥" },
			article = "Voiceless alveolar tap",
		},
		{
			name = "Âm vỗ lợi hữu thanh",
			symbols = { "ɾ" },
			article = "Voiced dental and alveolar taps and flaps",
			audio = "Alveolar tap.ogg"
		},
		{
			name = "Âm vỗ sau lợi hữu thanh",
			symbols = { "ɾ̠" },
		},
		{
			name = "Âm vỗ mũi lợi hữu thanh",
			symbols = { "ɾ̃", "n̆" },
			article = "Alveolar nasal tap",
		},
		{
			name = "Âm vỗ quặt lưỡi vô thanh",
			symbols = { "ɽ̊" },
		},
		{
			name = "Âm vỗ quặt lưỡi hữu thanh",
			symbols = { "ɽ" },
			audio = "Retroflex flap.ogg"
		},
		{
			name = "Âm vỗ ngạc mềm hữu thanh",
			symbols = { "ɡ̆" },
		},
		{
			name = "Âm vỗ tiểu thiệt hữu thanh",
			symbols = { "ɢ̆", "ʀ̆" },
			article = "Voiced uvular tap and flap",
		},
		{
			name = "Âm vỗ nắp họng hữu thanh",
			symbols = { "ʡ̆", "ʢ̆" },
			audio = "Epiglottal flap.oga"
		},
		-- Âm rung
		{
			name = "Âm rung môi-môi vô thanh",
			symbols = { "ʙ̥" },
			audio = "Voiceless bilabial trill with aspiration.ogg"
		},
		{
			name = "Âm rung môi-môi hữu thanh",
			symbols = { "ʙ" },
			audio = "Bilabial trill.ogg"
		},
		{
			name = "Âm rung lưỡi-môi hữu thanh",
			symbols = { "r̼" },
			audio = "Linguolabial trill.ogg"
		},
		{
			name = "Âm rung răng hữu thanh",
			symbols = { "r̪" },
		},
		{
			name = "Âm rung lợi vô thanh",
			symbols = { "r̥" },
			audio = "Voiceless alveolar trill.ogg"
		},
		{
			name = "Âm rung lợi hữu thanh",
			symbols = { "r" },
			audio = "Alveolar trill.ogg"
		},
		{
			name = "Âm rung xát lợi vô thanh",
			symbols = { "r̝̊" },
		},
		{
			name = "Âm rung xát lợi hữu thanh",
			symbols = { "r̝" },
			audio = "Raised alveolar non-sonorant trill.ogg"
		},
		{
			name = "Âm rung sau lợi hữu thanh",
			symbols = { "r̠" },
			audio = "Voiced postalveolar trill.ogg"
		},
		{
			name = "Âm rung quặt lưỡi vô thanh",
			symbols = { "ɽ̊r̥", "ɽr̥" },
		},
		{
			name = "Âm rung quặt lưỡi hữu thanh",
			symbols = { "ɽr" },
			audio = "Voiced retroflex trill.ogg"
		},
		{
			name = "Âm rung xát trước tiểu thiệt vô thanh",
			symbols = { "ʀ̝̊˖", "ʀ̟̊˔" },
		},
		{
			name = "Âm rung xát trước tiểu thiệt hữu thanh",
			symbols = { "ʀ̝˖", "ʀ̟˔" },
		},
		{
			name = "Âm rung tiểu thiệt vô thanh",
			symbols = { "ʀ̥" },
			audio = "Voiceless uvular trill.ogg"
		},
		{
			name = "Âm rung tiểu thiệt hữu thanh",
			symbols = { "ʀ" },
			audio = "Uvular trill.ogg"
		},
		{
			name = "Âm rung xát tiểu thiệt vô thanh",
			symbols = { "ʀ̝̊" },
		},
		{
			name = "Âm rung xát tiểu thiệt hữu thanh",
			symbols = { "ʀ̝" },
		},
		{
			name = "Âm rung nắp họng vô thanh",
			symbols = { "ʜ" },
			audio = "Voiceless epiglottal trill.ogg"
		},
		{
			name = "Âm rung nắp họng hữu thanh",
			symbols = { "ʢ" },
			audio = "Voiced epiglottal trill 2.ogg"
		},
		-- Âm tắc-xát bên
		{
			name = "Âm tắc-xát bên lợi vô thanh",
			symbols = { "tɬ", "ƛ" },
			audio = "Voiceless alveolar lateral affricate.ogg"
		},
		{
			name = "Âm tắc-xát bên lợi hữu thanh",
			symbols = { "dɮ" },
			audio = "Voiced alveolar lateral affricate.ogg"
		},
		{
			name = "Âm tắc-xát bên quặt lưỡi vô thanh",
			symbols = { "ʈɭ̊˔", "tɭ̊˔", "ʈɭ̊", "tɭ̊", "ʈꞎ", "tꞎ" },
		},
		{
			name = "Âm tắc-xát bên quặt lưỡi hữu thanh",
			symbols = { "ɖɭ˔", "dɭ˔", "ɖɭ", "dɭ", "ɖ𝼅", "d𝼅" },
		},
		{
			name = "Âm tắc-xát bên ngạc cứng vô thanh",
			symbols = { "cʎ̝̊", "cʎ̥", "c𝼆", "t𝼆" },
			audio = "Voiceless palatal lateral affricate.ogg"
		},
		{
			name = "Âm tắc-xát bên ngạc cứng hữu thanh",
			symbols = { "ɟʎ̝", "ɟʎ", "ɟ𝼆̬", "d𝼆̬" },
		},
		{
			name = "Âm tắc-xát bên ngạc mềm vô thanh",
			symbols = { "kʟ̝̊", "kʟ̥", "k𝼄" },
			audio = "Voiceless velar lateral affricate.ogg"
		},
		{
			name = "Âm tắc-xát bên ngạc mềm hữu thanh",
			symbols = { "ɡʟ̝", "ɡʟ", "ɡ𝼄̬" },
			audio = "Voiced velar lateral affricate.ogg"
		},
		-- Âm xát bên
		{
			name = "Âm xát bên răng vô thanh",
			symbols = { "ɬ̪" },
		},
		{
			name = "Âm xát bên răng hữu thanh",
			symbols = { "ɮ̪", "ɮ͆" },
		},
		{
			name = "Âm xát bên lợi vô thanh",
			symbols = { "ɬ" },
			audio = "Voiceless alveolar lateral fricative.ogg"
		},
		{
			name = "Âm xát bên lợi hữu thanh",
			symbols = { "ɮ" },
			audio = "Voiced alveolar lateral fricative.ogg"
		},
		{
			name = "Âm xát bên quặt lưỡi vô thanh",
			symbols = { "ɭ̊˔", "ꞎ", "ɭ̊" },
			audio = "Voiceless retroflex lateral fricative.ogg"
		},
		{
			name = "Âm xát bên quặt lưỡi hữu thanh",
			symbols = { "ɭ˔", "𝼅" },
		},
		{
			name = "Âm xát bên lợi-ngạc-cứng vô thanh",
			symbols = { "ɬ̠ʲ", "ʎ̝̊˖", "ȴ̊˔", "l̠̊ʲ", "ʎ̟̊", "ȴ̊" },
		},
		{
			name = "Âm xát bên ngạc cứng vô thanh",
			symbols = { "ʎ̝̊", "ʎ̥", "𝼆" },
			audio = "Voiceless palatal lateral fricative.ogg"
		},
		{
			name = "Âm xát bên ngạc cứng hữu thanh",
			symbols = { "ʎ̝", "𝼆̬" },
		},
		{
			name = "Âm xát bên ngạc mềm vô thanh",
			symbols = { "ʟ̝̊", "ʟ̥", "𝼄" },
			audio = "Voiceless velar lateral fricative.ogg"
		},
		{
			name = "Âm xát bên ngạc mềm hữu thanh",
			symbols = { "ʟ̝", "𝼄̬" },
			audio = "Voiced velar lateral fricative.ogg"
		},
		-- Âm tiếp cận bên
		{
			name = "Âm tiếp cận bên răng hữu thanh",
			symbols = { "l̪" },
			audio = "Voiced dental lateral approximant.ogg"
		},
		{
			name = "Âm tiếp cận bên lợi vô thanh",
			symbols = { "l̥" },
		},
		{
			name = "Âm tiếp cận bên lợi hữu thanh",
			symbols = { "l" },
			audio = "Alveolar lateral approximant.ogg"
		},
		{
			name = "Âm tiếp cận bên sau lợi hữu thanh",
			symbols = { "l̠" },
			audio = "Voiced postalveolar lateral approximant.ogg"
		},
		{
			name = "Âm tiếp cận bên quặt lưỡi hữu thanh",
			symbols = { "ɭ" },
			audio = "Retroflex lateral approximant.ogg"
		},
		{
			name = "Âm tiếp cận bên lợi-ngạc-cứng hữu thanh",
			symbols = { "l̠ʲ", "ʎ̟", "ȴ" },
		},
		{
			name = "Âm tiếp cận bên ngạc cứng hữu thanh",
			symbols = { "ʎ" },
			audio = "Palatal lateral approximant.ogg"
		},
		{
			name = "Âm tiếp cận bên ngạc mềm hữu thanh",
			symbols = { "ʟ" },
			audio = "Velar lateral approximant.ogg"
		},
		{
			name = "Âm tiếp cận bên tiểu thiệt hữu thanh",
			symbols = { "ʟ̠" },
			audio = "Uvular lateral approximant.ogg"
		},
		-- Âm vỗ bên
		{
			name = "Âm vỗ bên lợi vô thanh",
			symbols = { "ɺ̥" },
		},
		{
			name = "Âm vỗ bên lợi hữu thanh",
			symbols = { "ɺ" },
		},
		{
			name = "Âm vỗ bên quặt lưỡi vô thanh",
			symbols = { "ɭ̥̆", "𝼈̥" },
		},
		{
			name = "Âm vỗ bên quặt lưỡi hữu thanh",
			symbols = { "ɭ̆", "𝼈" },
		},
		{
			name = "Âm vỗ bên ngạc cứng hữu thanh",
			symbols = { "ʎ̆" },
		},
		{
			name = "Âm vỗ bên ngạc mềm hữu thanh",
			symbols = { "ʟ̆" },
		},
		-- PHỤ ÂM KHÔNG CÓ LUỒNG HƠI TỪ PHỔI
		-- Âm tắc phụt
		{
			name = "Âm tắc phụt môi-môi",
			symbols = { "pʼ" },
			audio = "Bilabial ejective plosive.ogg"
		},
		{
			name = "Âm tắc phụt răng",
			symbols = { "t̪ʼ" },
		},
		{
			name = "Âm tắc phụt lợi",
			symbols = { "tʼ" },
			audio = "Alveolar ejective plosive.ogg"
		},
		{
			name = "Âm tắc phụt quặt lưỡi",
			symbols = { "ʈʼ" },
			audio = "Retroflex ejective.ogg"
		},
		{
			name = "Âm tắc phụt ngạc cứng",
			symbols = { "cʼ" },
			audio = "Palatal ejective.ogg"
		},
		{
			name = "Âm tắc phụt ngạc mềm",
			symbols = { "kʼ" },
			audio = "Velar ejective plosive.ogg"
		},
		{
			name = "Âm tắc phụt tiểu thiệt",
			symbols = { "qʼ" },
			audio = "Uvular ejective plosive.ogg"
		},
		{
			name = "Âm phụt nắp họng",
			symbols = { "ʡʼ" },
			audio = "Epiglottal ejective.ogg"
		},
		-- Âm tắc-xát phụt
		{
			name = "Âm tắc-xát phụt răng",
			symbols = { "t̪θʼ", "t̟θʼ", "tθʼ" },
			audio = "Dental ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt lợi",
			symbols = { "tsʼ" },
			audio = "Alveolar ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt ngạc-cứng-lợi",
			symbols = { "t̠ʃʼ", "tʃʼ" },
			audio = "Palato-alveolar ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt quặt lưỡi",
			symbols = { "ʈʂʼ", "tʂʼ" },
			audio = "Retroflex ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt lợi-ngạc-cứng",
			symbols = { "t̠ɕʼ", "tɕʼ", "cɕʼ" },
		},
		{
			name = "Âm tắc-xát phụt ngạc cứng",
			symbols = { "cçʼ" },
			audio = "Palatal ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt ngạc mềm",
			symbols = { "kxʼ" },
			audio = "Velar ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt tiểu thiệt",
			symbols = { "qχʼ" },
			audio = "Uvular ejective affricate.ogg"
		},
		-- Âm xát phụt
		{
			name = "Âm xát hụt môi-môi",
			symbols = { "ɸʼ" },
		},
		{
			name = "Âm xát phụt môi-răng",
			symbols = { "fʼ" },
			audio = "Labiodental ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt răng",
			symbols = { "θʼ" },
			audio = "Dental ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt lợi",
			symbols = { "sʼ" },
			audio = "Alveolar ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt ngạc-cứng-lợi",
			symbols = { "ʃʼ" },
			audio = "Palato-alveolar ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt quặt lưỡi",
			symbols = { "ʂʼ" },
			audio = "Retroflex ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt lợi-ngạc-cứng",
			symbols = { "ɕʼ" },
			audio = "Alveolo-palatal ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt ngạc cứng",
			symbols = { "çʼ" },
			audio = "Palatal ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt ngạc mềm",
			symbols = { "xʼ" },
			audio = "Velar ejective fricative.ogg"
		},
		{
			name = "Âm xát phụt tiểu thiệt",
			symbols = { "χʼ" },
			audio = "Uvular ejective fricative.ogg"
		},
		-- Âm tắc-xát phụt bên
		{
			name = "Âm tắc-xát phụt bên lợi",
			symbols = { "tɬʼ", "ƛʼ" },
			audio = "Alveolar lateral ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt bên ngạc cứng",
			symbols = { "cʎ̝̊ʼ", "cʎ̥ʼ" },
			audio = "Palatal lateral ejective affricate.ogg"
		},
		{
			name = "Âm tắc-xát phụt bên ngạc mềm",
			symbols = { "kʟ̝̊ʼ", "kʟ̥ʼ" },
			audio = "Velar lateral ejective affricate.ogg"
		},
		-- Âm xát phụt bên
		{
			name = "Âm xát phụt bên lợi",
			symbols = { "ɬʼ" },
			audio = "Alveolar lateral ejective fricative.ogg"
		},
		-- Âm chắt mảnh
		{
			name = "Âm chắt môi-môi mảnh",
			symbols = { "ʘ", "kʘ" },
			audio = "Clic bilabial sourd.ogg"
		},
		{
			name = "Âm chắt răng mảnh",
			symbols = { "ǀ", "kǀ" },
			audio = "Dental click.ogg"
		},
		{
			name = "Âm chắt lợi mảnh",
			symbols = { "ǃ", "kǃ" },
			audio = "Postalveolar click.ogg"
		},
		{
			name = "Âm chắt ngạc cứng mảnh",
			symbols = { "ǂ", "kǂ" },
			audio = "Palatoalveolar click.ogg"
		},
		{
			name = "Âm chắt ngạc mềm thả sau",
			symbols = { "ʞ" },
		},
		-- Âm chắt hữu thanh
		{
			name = "Âm chắt môi-môi hữu thanh thả sau",
			symbols = { "ʘ̬", "ɡʘ" },
		},
		{
			name = "Âm chắt răng hữu thanh",
			symbols = { "ǀ̬", "ɡǀ" },
		},
		{
			name = "Âm chắt lợi hữu thanh",
			symbols = { "ǃ̬", "ɡǃ" },
		},
		{
			name = "Âm chắt quặt lưỡi mảnh",
			symbols = { "‼", "𝼊" },
		},
		{
			name = "Âm chắt ngạc cứng hữu thanh",
			symbols = { "ǂ̬", "ɡǂ" },
		},
		{
			name = "Âm chắt quặt lưỡi hữu thanh",
			symbols = { "‼̬", "ɡ‼", "ɡ𝼊" },
		},
		-- Âm chắt mũi
		{
			name = "Âm chắt mũi môi-môi",
			symbols = { "ʘ̃", "ŋʘ" },
			audio = "Bilabial nasal click.ogg"
		},
		{
			name = "Âm chắt mũi răng",
			symbols = { "ǀ̃", "ŋǀ" },
		},
		{
			name = "Âm chắt mũi lợi",
			symbols = { "ǃ̃", "ŋǃ" },
			audio = "Intervocalic nasal alveolar clicks.ogg"
		},
		{
			name = "Âm chắt mũi ngạc cứng",
			symbols = { "ǂ̃", "ŋǂ" },
		},
		{
			name = "Âm chắt mũi quặt lưỡi",
			symbols = { "‼̃", "ŋ‼", "ŋ𝼊" },
		},
		-- Âm chắt bên
		{
			name = "Âm chắt bên lợi mảnh",
			symbols = { "ǁ", "kǁ" },
			audio = "Alveolar lateral click.ogg"
		},
		{
			name = "Âm chắt bên lợi hữu thanh",
			symbols = { "ǁ̬", "ɡǁ" },
		},
		-- Âm chắt mũi bên
		{
			name = "Âm chắt mũi bên lợi",
			symbols = { "ǁ̃", "ŋǁ" },
		},
		-- Âm chắt thanh hầu hóa
		{
			name = "Âm chắt mũi môi-môi thanh-hầu-hóa",
			symbols = { "ʘ̃ˀ", "ʘˀ", "ŋ̊ʘˀ", "ŋʘˀ" },
		},
		{
			name = "Âm chắt mũi răng thanh-hầu-hóa",
			symbols = { "ǀ̃ˀ", "ǀˀ", "ŋ̊ǀˀ", "ŋǀˀ" },
		},
		{
			name = "Âm chắt mũi lợi thanh-hầu-hóa",
			symbols = { "ǃ̃ˀ", "ǃˀ", "ŋ̊ǃˀ", "ŋǃˀ" },
		},
		{
			name = "Âm chắt mũi quặt lưỡi thanh-hầu-hóa",
			symbols = { "‼̃ˀ", "‼ˀ", "ŋ‼ˀ", "ŋ̊‼ˀ" },
		},
		{
			name = "Âm chắt mũi ngạc cứng thanh-hầu-hóa",
			symbols = { "ǂ̃ˀ", "ǂˀ", "ŋ̊ǂˀ", "ŋǂˀ" },
		},
		{
			name = "Âm chắt mũi bên lợi thanh-hầu-hóa",
			symbols = { "ǁ̃ˀ", "ǁˀ", "ŋ̊ǁˀ", "ŋǁˀ" },
		},
		-- Âm hút vào
		{
			name = "Âm hút vào môi-môi vô thanh",
			symbols = { "ɓ̥", "ƥ" },
		},
		{
			name = "Âm hút vào môi-môi hữu thanh",
			symbols = { "ɓ" },
			audio = "Voiced bilabial implosive.ogg"
		},
		{
			name = "Âm hút vào lợi vô thanh",
			symbols = { "ɗ̥", "ƭ" },
		},
		{
			name = "Âm hút vào lợi hữu thanh",
			symbols = { "ɗ" },
			audio = "Voiced alveolar implosive.ogg"
		},
		{
			name = "Âm hút vào quặt lưỡi vô thanh",
			symbols = { "ᶑ̊", "ᶑ̥", "𝼉" },
		},
		{
			name = "Âm hút vào quặt lưỡi hữu thanh",
			symbols = { "ᶑ" },
		},
		{
			name = "Âm hút vào ngạc cứng vô thanh",
			symbols = { "ʄ̊", "ʄ̥", "ƈ" },
		},
		{
			name = "Âm hút vào ngạc cứng hữu thanh",
			symbols = { "ʄ" },
			audio = "Voiced palatal implosive.ogg"
		},
		{
			name = "Âm hút vào ngạc mềm vô thanh",
			symbols = { "ɠ̊", "ƙ" },
		},
		{
			name = "Âm hút vào ngạc mềm hữu thanh",
			symbols = { "ɠ" },
			audio = "Voiced velar implosive.ogg"
		},
		{
			name = "Âm hút vào tiểu thiệt vô thanh",
			symbols = { "ʛ̥", "ʠ" },
		},
		{
			name = "Âm hút vào tiểu thiệt hữu thanh",
			symbols = { "ʛ" },
			audio = "Voiced uvular implosive.ogg"
		},
		-- PHỤ ÂM ĐỒNG CẤU ÂM
		-- Âm mũi đồng cấu âm
		{
			name = "Âm mũi môi-lợi hữu thanh",
			symbols = { "nm" },
			article = "Phụ âm môi-vành lưỡi",
		},
		{
			name = "Âm mũi môi-ngạc-mềm hữu thanh",
			symbols = { "ŋm" },
			audio = "Labial-velar nasal stop.ogg"
		},
		-- Âm tắc đồng cấu âm
		{
			name = "Âm tắc môi-lợi vô thanh",
			symbols = { "tp" },
			article = "Labial–coronal consonant",
		},
		{
			name = "Âm tắc môi-lợi hữu thanh",
			symbols = { "db" },
			article = "Labial–coronal consonant",
		},
		{
			name = "Âm tắc môi-ngạc-mềm vô thanh",
			symbols = { "kp" },
			audio = "Voiceless labial-velar plosive.ogg"
		},
		{
			name = "Âm tắc môi-ngạc-mềm hữu thanh",
			symbols = { "ɡb" },
			audio = "Voiced labial-velar plosive.ogg"
		},
		{
			name = "Âm tắc tiểu-thiệt-nắp-họng vô thanh",
			symbols = { "qʡ" },
		},
		-- Âm liên tục đồng cấu âm
		{
			name = "Âm xát môi-ngạc-cứng vô thanh",
			symbols = { "ɥ̊" },
		},
		{
			name = "Âm tiếp cận môi-ngạc-cứng hữu thanh",
			symbols = { "ɥ" },
			audio = "LL-Q150 (fra)-WikiLucas00-IPA ɥ.wav"
		},
		{
			name = "Âm xát môi-ngạc-mềm vô thanh",
			symbols = { "ʍ", "w̥", "hw" },
			audio = "Voiceless labio-velar fricative.ogg"
		},
		{
			name = "Âm xát môi-ngạc–mềm hữu thanh",
			symbols = { "w" },
			audio = "Voiced labio-velar approximant.ogg"
		},
		{
			name = "Âm tiếp cận môi-ngạc-mềm hữu thanh nén",
			symbols = { "wᵝ", "ɰᵝ" },
			article = "Voiced labial–velar approximant",
		},
		{
			name = "Âm sj",
			symbols = { "ɧ" },
			audio = "Voiceless dorso-palatal velar fricative.ogg"
		},
		-- Co-articulated lateral approximants
		{
			name = "Âm tiếp cận bên răng ngạc–mềm–hóa",
			symbols = { "ɫ̪", "l̪ˠ" },
		},
		{
			name = "Âm tiếp cận bên lợi ngạc–mềm–hóa",
			symbols = { "ɫ", "lˠ" },
			audio = "Velarized alveolar lateral approximant.ogg"
		},
		-- Âm tiếp cận mũi
		{
			name = "Âm tiếp cận ngạc cứng mũi",
			symbols = { "j̃" },
		},
		{
			name = "Âm tiếp cận môi-ngạc-mềm mũi",
			symbols = { "w̃" },
		},
		{
			name = "Âm tiếp cận thanh hầu mũi vô thanh",
			symbols = { "h̃" },
		},
		-- NGUYÊN ÂM
		-- Đóng
		{
			name = "Nguyên âm không tròn môi trước đóng",
			symbols = { "i" },
			audio = "Close front unrounded vowel.ogg"
		},
		{
			name = "Nguyên âm tròn môi trước đóng",
			symbols = { "y" },
			audio = "Close front rounded vowel.ogg"
		},
		{
			name = "Nguyên âm mím môi trước đóng",
			symbols = { "y͍", "iᵝ" },
			audio = "Close front rounded vowel.ogg"
		},
		{
			name = "Nguyên âm chu môi trước đóng",
			symbols = { "y̫", "yʷ", "iʷ" },
		},
		{
			name = "Nguyên âm tròn môi giữa đóng",
			symbols = { "ɨ", "ï" },
			audio = "Close central unrounded vowel.ogg"
		},
		{
			name = "Nguyên âm tròn môi giữa đóng",
			symbols = { "ʉ", "ü" },
			audio = "Close central rounded vowel.ogg"
		},
		{
			name = "Nguyên âm chu môi giữa đóng",
			symbols = { "ʉ̫", "ʉʷ", "ɨʷ" },
			audio = "Close central rounded vowel.ogg"
		},
		{
			name = "Nguyên âm mím môi giữa đóng",
			symbols = { "ÿ", "ɨᵝ" },
		},
		{
			name = "Nguyên âm không tròn môi sau đóng",
			symbols = { "ɯ" },
			audio = "Close back unrounded vowel.ogg"
		},
		{
			name = "Nguyên âm tròn môi sau đóng",
			symbols = { "u" },
			audio = "Close back rounded vowel.ogg"
		},
		{
			name = "Nguyên âm chu môi sau đóng",
			symbols = { "u̫", "uʷ", "ɯʷ" },
			audio = "Close back rounded vowel.ogg"
		},
		{
			name = "Nguyên âm mím môi sau đóng",
			symbols = { "u͍", "ɯᵝ" },
			audio = "Ja-U.oga"
		},
		-- Nguyên âm gần đóng
		{
			name = "Nguyên âm không tròn môi gần trước gần đóng",
			symbols = { "ɪ", "ɪ̟", "i̞", "e̝" },
			audio = "Near-close near-front unrounded vowel.ogg"
		},
		{
			name = "Nguyên âm tròn môi gần trước gần đóng",
			symbols = { "ʏ", "y̞", "y˕", "ø̝" },
			audio = "Near-close near-front rounded vowel.ogg"
		},
		{
			name = "Nguyên âm mím môi gần trước gần đóng",
			symbols = { "ʏ͍", "ɪᵝ" },
			audio = "Near-close near-front rounded vowel.ogg"
		},
		{
			name = "Nguyên âm chu môi gần trước gần đóng",
			symbols = { "ʏ̫", "ʏʷ", "ɪʷ" },
		},
		{
			name = "Nguyên âm không tròn môi giữa gần đóng",
			symbols = { "ɪ̈", "ɨ̞", "ɘ̝" },
			audio = "Near-close central unrounded vowel.ogg"
		},
		{
			name = "Nguyên âm tròn môi giữa gần đóng",
			symbols = { "ʊ̈", "ʊ̟", "ʉ̞", "ɵ̝" },
		},
		{
			name = "Nguyên âm chu môi giữa gần đóng",
			symbols = { "ʊ̫̈", "ʉ̫˕", "ʊ̈ʷ", "ʉ̞ʷ", "ɪ̈ʷ", "ɨ̞ʷ" },
		},
		{
			name = "Nguyên âm mím môi giữa gần đóng",
			symbols = { "ʏ̈", "ɨ̞ᵝ" },
		},
		{
			name = "Nguyên âm không tròn môi gần sau gần đóng",
			symbols = { "ɯ̞", "ɯ̽" },
			audio = "Near-close near-back unrounded vowel.ogg"
		},
		{
			name = "Near-close near-back rounded vowel",
			symbols = { "ʊ", "u̞", "o̝" },
			audio = "Near-close near-back rounded vowel.ogg"
		},
		{
			name = "Near-close near-back protruded vowel",
			symbols = { "ʊ̫", "ʊʷ", "ɯ̽ʷ", "ɤ̝̈ʷ", "u̫˕", "u̞ʷ", "ɯ̞ʷ", "ɤ̝ʷ" },
			audio = "Near-close near-back rounded vowel.ogg"
		},
		{
			name = "Near-close near-back compressed vowel",
			symbols = { "ʊ͍", "ɯ̽ᵝ", "ɯ̞̈ᵝ", "ɯ̞ᵝ" },
		},
		-- Close-mid vowels
		{
			name = "Close-mid front unrounded vowel",
			symbols = { "e" },
			audio = "Close-mid front unrounded vowel.ogg"
		},
		{
			name = "Close-mid front rounded vowel",
			symbols = { "ø" },
			audio = "Close-mid front rounded vowel.ogg"
		},
		{
			name = "Close-mid front compressed vowel",
			symbols = { "ø͍", "eᵝ" },
			audio = "Close-mid front rounded vowel.ogg"
		},
		{
			name = "Close-mid front protruded vowel",
			symbols = { "ø̫", "øʷ", "eʷ" },
		},
		{
			name = "Close-mid central unrounded vowel",
			symbols = { "ɘ", "ë", "ɤ̈" },
			audio = "Close-mid central unrounded vowel.ogg"
		},
		{
			name = "Close-mid central rounded vowel",
			symbols = { "ɵ", "ö" },
			audio = "Close-mid central rounded vowel.ogg"
		},
		{
			name = "Close-mid central protruded vowel",
			symbols = { "ɵ̫", "ɵʷ", "ɘʷ" },
			audio = "Close-mid central rounded vowel.ogg"
		},
		{
			name = "Close-mid central compressed vowel",
			symbols = { "ø̈", "ɘᵝ" },
		},
		{
			name = "Close-mid back unrounded vowel",
			symbols = { "ɤ" },
			audio = "Close-mid back unrounded vowel.ogg"
		},
		{
			name = "Close-mid back rounded vowel",
			symbols = { "o" },
			audio = "Close-mid back rounded vowel.ogg"
		},
		{
			name = "Close-mid back protruded vowel",
			symbols = { "o̫", "oʷ", "ɤʷ" },
			audio = "Close-mid back rounded vowel.ogg"
		},
		{
			name = "Close-mid back compressed vowel",
			symbols = { "o͍", "ɤᵝ" },
		},
		-- Mid vowels
		{
			name = "Mid front unrounded vowel",
			symbols = { "e̞", "ɛ̝" },
			audio = "Mid front unrounded vowel.ogg"
		},
		{
			name = "Mid front rounded vowel",
			symbols = { "ø̞", "œ̝" },
			audio = "Mid front rounded vowel.ogg"
		},
		{
			name = "Mid front compressed vowel",
			symbols = { "ø͍˕", "œ͍˔", "e̞ᵝ", "ɛ̝ᵝ" },
		},
		{
			name = "Mid front protruded vowel",
			symbols = { "ø̫˕", "œ̫˔", "ø̞ʷ", "œ̝ʷ", "e̞ʷ", "ɛ̝ʷ" },
		},
		{
			name = "Mid central vowel",
			symbols = { "ə" },
			audio = "Mid-central vowel.ogg"
		},
		{
			name = "Mid central unrounded vowel",
			symbols = { "ə̜", "ɘ̞", "ɜ̝" },
			audio = "Mid-central vowel.ogg"
		},
		{
			name = "Mid central rounded vowel",
			symbols = { "ə̹", "ɵ̞", "ɞ̝" },
			audio = "Mid central rounded vowel.ogg"
		},
		{
			name = "Mid back unrounded vowel",
			symbols = { "ɤ̞", "ʌ̝" },
			audio = "ɤ̞ IPA sound.opus"
		},
		{
			name = "Mid back rounded vowel",
			symbols = { "o̞", "ɔ̝" },
			audio = "Mid back rounded vowel.ogg"
		},
		-- Open-mid vowels
		{
			name = "Open-mid front unrounded vowel",
			symbols = { "ɛ" },
			audio = "Open-mid front unrounded vowel.ogg"
		},
		{
			name = "Open-mid front rounded vowel",
			symbols = { "œ" },
			audio = "Open-mid front rounded vowel.ogg"
		},
		{
			name = "Open-mid front compressed vowel",
			symbols = { "œ͍", "ɛᵝ" },
			audio = "Open-mid front rounded vowel.ogg"
		},
		{
			name = "Open-mid front protruded vowel",
			symbols = { "œ̫", "œʷ", "ɛʷ" },
		},
		{
			name = "Open-mid central unrounded vowel",
			symbols = { "ɜ", "ɛ̈", "ʌ̈" },
			audio = "Open-mid central unrounded vowel.ogg"
		},
		{
			name = "Open-mid central rounded vowel",
			symbols = { "ɞ" },
			audio = "Open-mid central rounded vowel.ogg"
		},
		{
			name = "Open-mid back unrounded vowel",
			symbols = { "ʌ" },
			audio = "PR-open-mid back unrounded vowel2.ogg"
		},
		{
			name = "Open-mid back rounded vowel",
			symbols = { "ɔ" },
			audio = "PR-open-mid back rounded vowel.ogg"
		},
		-- Near-open vowels
		{
			name = "Near-open front unrounded vowel",
			symbols = { "æ" },
			audio = "Near-open front unrounded vowel.ogg"
		},
		{
			name = "Near-open central vowel",
			symbols = { "ɐ" },
			audio = "Near-open central unrounded vowel.ogg"
		},
		{
			name = "Near-open central unrounded vowel",
			symbols = { "ɐ̜", "ɜ̞" },
			audio = "PR-near-open central unrounded vowel.ogg"
		},
		{
			name = "Near-open central rounded vowel",
			symbols = { "ɐ̹", "ɞ̞" },
		},
		-- Open vowels
		{
			name = "Open front unrounded vowel",
			symbols = { "a", "æ̞" },
			audio = "PR-open front unrounded vowel.ogg"
		},
		{
			name = "Open front rounded vowel",
			symbols = { "ɶ" },
			audio = "Open front rounded vowel.ogg"
		},
		{
			name = "Open central unrounded vowel",
			symbols = { "ä", "a̠", "ɑ̈", "ɐ̞" },
			audio = "Open central unrounded vowel.ogg"
		},
		{
			name = "Open central rounded vowel",
			symbols = { "ɒ̈", "ɶ̈" },
			audio = "Open central rounded vowel.ogg"
		},
		{
			name = "Open back unrounded vowel",
			symbols = { "ɑ" },
			audio = "Open back unrounded vowel.ogg"
		},
		{
			name = "Open back rounded vowel",
			symbols = { "ɒ" },
			audio = "PR-open back rounded vowel.ogg"
		},
		{
			name = "R-colored vowel",
			symbols = { "ɚ", "ɝ", "ɹ̩", "ɻ̍" },
			audio = "En-us-er.ogg"
		},
		-- SIÊU PHÂN ĐOẠN
		{
			name = "Trọng âm chính",
			symbols = { "ˈ" },
			article = "Trọng âm",
		},
		{
			name = "Trọng âm phụ",
			symbols = { "ˌ" },
		},
		{
			name = "Minor (foot) group",
			symbols = { "|" },
			article = "Prosodic unit",
		},
		{
			name = "Major (intonation) group",
			symbols = { "‖" },
			article = "Prosodic unit",
		},
		{
			name = "Ranh giới âm tiết",
			symbols = { "." },
			article = "Âm tiết",
		},
		{
			name = "Liền (không đứt đoạn)",
			symbols = { "‿" },
			article = "Ngữ lưu liền",
		},
		-- THANH ĐIỆU VÀ WORD ACCENTS
		{
			name = "Downstep",
			symbols = { "ꜜ" },
		},
		{
			name = "Upstep",
			symbols = { "ꜛ" },
		},
		{
			name = "Global rise",
			symbols = { "↗" },
			article = "Intonation (linguistics)",
		},
		{
			name = "Global fall",
			symbols = { "↘" },
			article = "Intonation (linguistics)",
		},
		-- IPA MỞ RỘNG (extIPA)
		{
			name = "Bilabial percussive",
			symbols = { "ʬ" },
		},
		{
			name = "Bidental percussive",
			symbols = { "ʭ" },
		},
		{
			name = "Velopharyngeal fricative",
			symbols = { "ʩ" },
		},
		{
			name = "Voiceless alveolar lateral–median fricative",
			symbols = { "ʪ" },
			article = "Lateral release (phonetics)",
		},
		{
			name = "Voiced alveolar lateral–median fricative",
			symbols = { "ʫ" },
			article = "Lateral release (phonetics)",
		},
		{
			name = "Luồng khí nhập",
			symbols = { "↓" },
			article = "Âm tố nhập",
		},
		{
			name = "Luồng khí xuất",
			symbols = { "↑" },
			article = "Âm tố xuất",
		},
		{
			name = "R chóp lưỡi",
			symbols = { "ɹ̺" },
			article = "Cách phát âm /r/ tiếng Anh",
		},
		{
			name = "Bunched r",
			symbols = { "ɹ̈" },
			article = "Cách phát âm /r/ tiếng Anh",
		},
		{
			name = "Carnauba Wax",
			symbols = { "carnauba" },
			audio = "Sap carnauba.ogg",
		},
		{
			name = "Silver Moon Studio",
			symbols = { "ˈsɪl.vər muːn ˈstjuː.di.əʊ" },
			audio = "Silver moon studio.ogg",
		},
		{
			name = "Sublaminal lower alveolar percussive",
			symbols = { "¡" },
			article = "Percussive consonant",
		},
		{
			name = "Percussive alveolar click",
			symbols = { "ǃ¡" },
		},
		{
			name = "Buccal interdental trill",
			symbols = { "ↀr̪͆" },
			article = "Âm rung liên-răng miệng",
		},
		-- PHI-IPA
		{
			name = "Ranh giới hình thái học",
			symbols = { "#" },
			article = "Căn tố của từ",
		},
		{
			name = "Zero",
			symbols = { "∅" },
			article = "Zero (ngôn ngữ học)",
		},
	},
	diacritics = {
		-- DẤU PHỤ
		{
			name = "Vô thanh",
			symbols = { "̥", "̊", "ḁ", "å", "ů", "ẘ", "ẙ" },
		},
		{
			name = "Hữu thanh",
			symbols = { "̬" },
			article = "Voice (phonetics)",
		},
		{
			name = "Bật hơi",
			symbols = { "ʰ" },
			article = "Phụ âm bật hơi",
		},
		{
			name = "Tăng tròn môi",
			symbols = { "̹", "͗", "˒" },
			article = "Độ tròn môi",
		},
		{
			name = "Giảm tròn môi",
			symbols = { "̜", "͑", "˓", "͍" },
			article = "Độ tròn môi",
		},
		{
			name = "Đẩy ra",
			symbols = { "̟", "˖" },
			article = "Cấu âm tương đối#Đẩy ra và rút về",
		},
		{
			name = "Rút về",
			symbols = { "̠", "˗" },
			article = "Cấu âm tương đối#Đẩy ra và rút về",
		},
		{
			name = "Trung tâm hóa",
			symbols = { "̈" },
			article = "Cấu âm tương đối#Centralized vowels",
		},
		{
			name = "Bán trung tâm hóa",
			symbols = { "̽" },
			article = "Cấu âm tương đối#Mid-centralized vowel",
		},
		{
			name = "Âm tiết tính",
			symbols = { "̩", "̍" },
			article = "Phụ âm âm tiết tính",
		},
		{
			name = "Phi âm tiết tính",
			symbols = { "̯", "̑" },
			article = "Bán nguyên âm",
		},
		{
			name = "Âm sắc R",
			symbols = { "˞" },
			article = "Nguyên âm r-tính",
			audio = "En-us-er.ogg"
		},
		{
			name = "Giọng thều thào",
			symbols = { "̤", "ṳ", "ʱ" },
			article = "Giọng thều thào",
		},
		{
			name = "Giọng kẹt",
			symbols = { "̰", "ḛ", "ḭ", "ṵ" },
			article = "Giọng kẹt",
		},
		{
			name = "Lưỡi-môi",
			symbols = { "̼" },
			article = "Phụ âm lưỡi-môi",
		},
		{
			name = "Môi hóa",
			symbols = { "ʷ", "̫" },
			article = "Môi hóa",
		},
		{
			name = "Ngạc cứng hóa",
			symbols = { "ʲ" },
			article = "Ngạc cứng hóa (ngữ âm)",
		},
		{
			name = "Ngạc mềm hóa",
			symbols = { "ˠ" },
			article = "Ngạc mềm hóa",
		},
		{
			name = "Yết hầu hóa",
			symbols = { "ˤ" },
			article = "Yết hầu hóa",
		},
		{
			name = "Ngạc mềm hóa hoặc yết hầu hóa",
			symbols = { "̴", "ᵯ", "ᵰ", "ᵱ", "ᵬ", "ᵮ", "ᵵ", "ᵭ", "ᵴ", "ᵶ", "ᵳ", "ᵲ" },
			article = "Yết hầu hóa",
		},
		{
			name = "Nâng cao",
			symbols = { "̝", "˔" },
			article = "Cấu âm tương đối#Nâng cao và hạ thấp",
		},
		{
			name = "Hạ thấp",
			symbols = { "̞", "˕" },
			article = "Cấu âm tương đối#Nâng cao và hạ thấp",
		},
		{
			name = "Gốc lưỡi tiến",
			symbols = { "̘" },
		},
		{
			name = "Gốc lưỡi lui",
			symbols = { "̙" },
		},
		{
			name = "Âm răng",
			symbols = { "̪", "͆" },
			article = "Âm răng",
		},
		{
			name = "Âm chóp lưỡi",
			symbols = { "̺" },
			article = "Âm chóp lưỡi",
		},
		{
			name = "Âm đầu lưỡi",
			symbols = { "̻" },
			article = "Âm đầu lưỡi",
		},
		{
			name = "Mũi hóa",
			symbols = { "̃", "ṽ" },
			article = "Mũi hóa",
		},
		{
			name = "Nguyên âm mũi",
			symbols = { "ĩ", "ỹ", "ɨ̃", "ʉ̃", "ɯ̃", "ũ", "ɪ̃", "ʏ̃", "ʊ̃", "ẽ", "ø̃", "ɘ̃", "ɵ̃", "ɤ̃", "õ", "ə̃", "ɛ̃", "œ̃", "ɜ̃", "ɞ̃", "ʌ̃", "ɔ̃", "æ̃", "ɐ̃", "ã", "ɶ̃", "ä̃", "ɑ̃", "ɒ̃" },
		},
		{
			name = "Thoát hơi vào âm mũi",
			symbols = { "ⁿ" },
		},
		{
			name = "Thoát hơi vào âm bên",
			symbols = { "ˡ" },
			article = "Thoát hơi vào âm bên",
		},
		{
			name = "Âm tắc câm",
			symbols = { "̚" },
		},
		{
			name = "Âm phụt",
			symbols = { "ʼ" },
			article = "Âm phụt",
		},
		{
			name = "Thanh hầu hóa",
			symbols = { "ˀ" },
			article = "Thanh hầu hóa",
		},
		{
			name = "Môi-ngạc cứng hóa",
			symbols = { "ᶣ" },
			article = "Môi-ngạc cứng hóa",
		},
		-- SIÊU PHÂN ĐOẠN
		{
			name = "Dài",
			symbols = { "ː" },
			article = "Length (phonetics)",
		},
		{
			name = "Nửa dài",
			symbols = { "ˑ" },
			article = "Length (phonetics)",
		},
		{
			name = "Ngắn",
			symbols = { "̆" },
			article = "Extra-shortness",
		},
		-- THANH ĐIỆU VÀ ÂM ĐIỆU
		{
			name = "Âm điệu",
			symbols = { "̋", "ű", "ӳ", "ő", "́", "í", "ý", "ú", "é", "ó", "á", "̄", "ī", "ȳ", "ū", "ē", "ō", "ǣ", "ā", "̀", "ì", "ỳ", "ù", "è", "ò", "à", "̏", "ȉ", "ȕ", "ȅ", "ȍ", "ȁ" },
			article = "Pitch-accent language",
		},
		{
			name = "Thanh điệu",
			symbols = { "̌", "̂", "᷄", "᷅", "᷇", "᷆", "᷈", "᷉", "˥", "˦", "˧", "˨", "˩" },
			article = "Tone (linguistics)",
		},
		-- IPA MỞ RỘNG (extIPA)
		{
			name = "Alveolar",
			symbols = { "͇" },
			article = "Alveolar consonant",
		},
		{
			name = "Strong articulation",
			symbols = { "͈", "̎" },
			article = "Fortis and lenis",
		},
		{
			name = "Weak articulation",
			symbols = { "͉", "᷂" },
			article = "Fortis and lenis",
		},
		{
			name = "Denasalized",
			symbols = { "͊" },
			article = "Denasalization",
		},
		{
			name = "Velopharyngeal friction",
			symbols = { "͌" },
			article = "Velopharyngeal consonant",
		},
		{
			name = "Whistled articulation",
			symbols = { "͎" },
			article = "Whistled sibilant",
		},
		{
			name = "Unaspirated",
			symbols = { "˭" },
			article = "Tenuis consonant",
		},
		{
			name = "Pre-aspiration",
			symbols = { "ʰp", "ʰt", "ʰʈ", "ʰc", "ʰk", "ʰq", "ʰn" },
			article = "Preaspiration",
		},
		-- NON-IPA
		{
			name = "Retroflex",
			symbols = { "̣", "̢" },
			article = "Retroflex consonant",
		},
		{
			name = "Prenasalized consonant",
			symbols = { "ᵐ", "ᶬ", "ⁿt", "ⁿd", "ⁿθ", "ⁿð", "ⁿs", "ⁿz", "ⁿʃ", "ⁿʒ", "ⁿɕ", "ⁿʑ", "ⁿr", "ⁿɬ", "ⁿɮ", "ⁿl", "ᶯ", "ᶮ", "ᵑ", "ᶰ" },
		},
		{
			name = "Pre-stopped consonant",
			symbols = { "ᵖ", "ᵇ", "ᵗ", "ᵈ", "ᶜ", "ᶡ", "ᵏ", "ᶢ", "ᴳ" },
		},
		{
			name = "Post-stopped nasal",
			symbols = { "mᵇ", "nᵈ", "ɲᶡ", "ŋᶢ", "ɴᴳ" },
		},
	}
}

for k, group in pairs(rawData) do
	for _, v in ipairs(group) do
		local t = {
			name = v.name,
			symbol = v.symbols[1],
			article = v.article or v.name,
			audio = v.audio or ""
		}
		for _, s in ipairs(v.symbols) do
			data[k][s] = t
		end
	end
end
	
return { data = data, rawData = rawData }
