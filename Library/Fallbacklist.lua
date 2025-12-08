-- Language fallback rules for other Lua modules.
-- @see       https://commons.wikimedia.org/wiki/Module:Fallbacklist
-- @release   g
-- @submodule
return {

    -- crh (Crimean Tatar) cluster: crh-cyrl , crh-latn -> crh (Crimean Tatar)
    ['crh']          = {'crh-latn'},
    ['crh-cyrl']     = {'crh', 'ru'}, 
    ['crh-latn']     = {'crh'},

    -- de (German) cluster:
    ['als']          = {'gsw', 'de'},                       -- Alemannisch
    ['bar']          = {'de'},                              -- Bavarian
    ['de-at']        = {'de'},                              -- Austrian German
    ['de-ch']        = {'de'},                              -- Swiss High German
    ['de-formal']    = {'de'},                              -- German (formal address)
    ['dsb']          = {'de'},                              -- Lower Sorbian
    ['frr']          = {'de'},                              -- Northern Frisian
    ['hsb']          = {'de'},                              -- Upper Sorbian
    ['ksh']          = {'de'},                              -- Colognian
    ['lb']           = {'de'},                              -- Luxembourgish
    ['nds']          = {'nds-nl', 'de'},                    -- Low German
    ['nds-nl']       = {'nds', 'nl'},                       -- Low Saxon (Netherlands)
    ['pdc']          = {'de'},                              -- Deitsch
    ['pdt']          = {'nds', 'de'},                       -- Plautdietsch
    ['pfl']          = {'de'},                              -- Pälzisch
    ['sli']          = {'de'},                              -- Lower Silesian
    ['stq']          = {'de'},                              -- Seeltersk
    ['vmf']          = {'de'},                              -- Upper Franconian

    -- es (Spanish) cluster
    ['an']           = {'es'},                              -- Aragonese
    ['arn']          = {'es'},                              -- Mapuche
    ['ay']           = {'es'},                              -- Aymara
    ['cbk-zam']      = {'es'},                              -- Chavacano de Zamboanga
    ['gn']           = {'es'},                              -- Guarani
    ['lad']          = {'es'},                              -- Ladino
    ['nah']          = {'es'},                              -- Nahuatl
    ['qu']           = {'es'},                              -- Quechua
    ['qug']          = {'qu', 'es'},                        -- Runa shimi

    -- et (Estonian) cluster
    ['liv']          = {'et'},                              -- Līvõ kēļ
    ['vep']          = {'et'},                              -- Veps
    ['vro']          = {'et'},                              -- Võro
    ['fiu-vro']      = {'vro', 'et'},                       -- Võro

    -- fa (Persian) cluster
    ['bcc']          = {'fa'},                              -- Southern Balochi
    ['bqi']          = {'fa'},                              -- Bakhtiari
    ['glk']          = {'fa'},                              -- Gilaki
    ['mzn']          = {'fa'},                              -- Mazandarani

    -- fi (Finnish) cluster:
    ['fit']          = {'fi'},                              -- meänkieli
    ['vot']          = {'fi'},                              -- Votic

    -- fr (French) cluster:
    ['bm']           = {'fr'},                              -- Bambara
    ['br']           = {'fr'},                              -- Breton
    ['co']           = {'fr'},                              -- Corsican
    ['ff']           = {'fr'},                              -- Fulah
    ['frc']          = {'fr'},                              -- Cajun French
    ['frp']          = {'fr'},                              -- Franco-Provençal
    ['ht']           = {'fr'},                              -- Haitian
    ['ln']           = {'fr'},                              -- Lingala
    ['mg']           = {'fr'},                              -- Malagasy
    ['pcd']          = {'fr'},                              -- Picard
    ['sg']           = {'fr'},                              -- Sango
    ['ty']           = {'fr'},                              -- Tahitian
    ['wa']           = {'fr'},                              -- Walloon
    ['wo']           = {'fr'},                              -- Wolof

    -- hi (Hindi) cluster
    ['anp']          = {'hi'},                              -- Angika
    ['mai']          = {'hi'},                              -- Maithili
    ['sa']           = {'hi'},                              -- Sanskrit

    -- hif (Fiji Hindi) cluster: hif-deva , hif-latn -> hif (Fiji Hindi)
    ['hif']          = {'hif-latn'},
    ['hif-deva']     = {'hif'}, 
    ['hif-latn']     = {'hif'},

    -- id (Indonesian) cluster
    ['min']          = {'id'},                              -- Minangkabau
    ['ace']          = {'id'},                              -- Achinese
    ['bug']          = {'id'},                              -- Buginese
    ['bjn']          = {'id'},                              -- Banjar
    ['jv']           = {'id'},                              -- Javanese
    ['su']           = {'id'},                              -- Sundanese
    ['map-bms']      = {'jv', 'id'},                        -- Basa Banyumasan

    -- ike (Eastern Canadian Inuktitut) cluster: ike-cans , ike-latn -> ike (Eastern Canadian Inuktitut)
    ['ike-cans']     = {'ik'}, 
    ['ike-latn']     = {'ik'}, 

    -- it (Italian) cluster
    ['egl']          = {'it'},                              -- Emiliàn
    ['eml']          = {'it'},                              -- Emiliano-Romagnolo
    ['fur']          = {'it'},                              -- Friulian
    ['lij']          = {'it'},                              -- Ligure
    ['lmo']          = {'it'},                              -- lumbaart
    ['nap']          = {'it'},                              -- Neapolitan
    ['pms']          = {'it'},                              -- Piedmontese
    ['rgn']          = {'it'},                              -- Romagnol
    ['scn']          = {'it'},                              -- Sicilian
    ['vec']          = {'it'},                              -- vèneto

    -- kk (Kazakh) cluster:
    -- kk-arab , kk-cyrl , kk-latn , kk-cn , kk-kz , kk-tr -> kk (Kazakh)
    ['kk']           = {'kk-cyrl'},                         -- Kazakh
    ['kk-arab']      = {'kk-cyrl', 'kk'},                   -- Kazakh (Arabic script)
    ['kk-cn']        = {'kk-arab', 'kk-cyrl', 'kk'},        -- Kazakh (China)
    ['kk-cyrl']      = {'kk'},                              -- Kazakh (Cyrillic script)
    ['kk-kz']        = {'kk', 'kk-cyrl'},                   -- Kazakh (Kazakhstan)
    ['kk-latn']      = {'kk-cyrl', 'kk'},                   -- Kazakh (Latin script)
    ['kk-tr']        = {'kk-latn', 'kk-cyrl', 'kk'},        -- Kazakh (Turkey)
    ['kaa']          = {'kk-latn', 'kk-cyrl'},              -- Kara-Kalpak

    -- ku (Kurdish) cluster: ku-latn , ku-arab -> ku (Kurdish)
    ['ku']           = {'ku-latn'},
    ['ku-arab']      = {'ckb', 'ckb-arab', 'ku'},           -- كوردي (عەرەبی)
    ['ku-latn']      = {'ku'},
    ['ckb']          = {'ckb-arab', 'ku'},

    -- nl (Dutch) cluster
    ['af']           = {'nl'},                              -- Afrikaans
    ['fy']           = {'nl'},                              -- Western Frisian
    ['li']           = {'nl'},                              -- Liechtenstein
    ['nl-informal']  = {'nl'},                              -- Nederlands (informeel)
    ['vls']          = {'nl'},                              -- Vlaams
    ['zea']          = {'nl'},                              -- Zeeuws

    --pl (Polish) cluster
    ['csb']          = {'pl'},                              -- Kashubian
    ['szl']          = {'pl'},                              -- Silesian

    -- pt (Portuguese) cluster
    ['gl']           = {'pt'},                              -- Galician
    ['mwl']          = {'pt'},                              -- Mirandese
    ['pt']           = {'pt-br'},                           -- Brazilian Portuguese

    -- ro (Romanian) cluster
    ['mo']           = {'ro'},                              -- Moldavian
    ['rmy']          = {'ro'},                              -- Romani

    -- ru (Russian) cluster
    ['ab']           = {'ru'},                              -- Abkhazian
    ['av']           = {'ru'},                              -- Avaric
    ['ba']           = {'ru'},                              -- Bashkir
    ['be-tarask']    = {'ru'},                              -- Belorussian
    ['ce']           = {'ru'},                              -- Chechen
    ['crh-cyrl']     = {'ru'},                              -- Crimean Tatar (Cyrillic script)
    ['cv']           = {'ru'},                              -- Chuvash
    ['inh']          = {'ru'},                              -- Ingush
    ['koi']          = {'ru'},                              -- Komi-Permyak
    ['krc']          = {'ru'},                              -- Karachay-Balkar
    ['kv']           = {'ru'},                              -- Komi
    ['lbe']          = {'ru'},                              -- лакку
    ['lez']          = {'ru'},                              -- Lezghian
    ['mhr']          = {'ru'},                              -- Eastern Mari
    ['mrj']          = {'ru'},                              -- Hill Mari
    ['myv']          = {'ru'},                              -- Erzya
    ['os']           = {'ru'},                              -- Ossetic
    ['rue']          = {'uk', 'ru'},                        -- Rusyn
    ['sah']          = {'ru'},                              -- Sakha
    ['tt']           = {'tt-cyrl', 'ru'},                   -- Tatar
    ['tt-cyrl']      = {'ru'},                              -- Tatar (Cyrillic script)
    ['udm']          = {'ru'},                              -- Udmurt
    ['uk']           = {'ru'},                              -- Ukranian
    ['xal']          = {'ru'},                              -- Kalmyk
    ['tt']           = {'tt-cyrl', 'ru'},                   -- Tatar

    -- ruq (Megleno Romanian) cluster: ruq-cyrl , ruq-grek , ruq-latn -> ruq (Megleno Romanian)
    ['ruq']          = {'ruq-latn', 'ro'},                  -- Megleno-Romanian
    ['ruq-cyrl']     = {'ruq', 'mk'},                       -- Megleno-Romanian (Cyrillic script)
    ['ruq-grek']     = {'ruq'},                             -- Megleno-Romanian (Greek script)
    ['ruq-latn']     = {'ro', 'ruq'},                       -- Megleno-Romanian (Latin script)

    -- sr (Serbian) cluster: sr-ec , sr-el -> sr (Serbian)
    ['sr']           = {'sr-ec'},
    ['sr-ec']        = {'sr'}, 
    ['sr-el']        = {'sr'}, 

    -- tg (Tajik) cluster: tg-cyrl , tg-latn -> tg (Tajik)
    ['tg']           = {'tg-cyrl'},
    ['tg-cyrl']      = {'tg'}, 
    ['tg-latn']      = {'tg'}, 

    -- tr (Turkish) cluster
    ['gag']          = {'tr'},                              -- Gagauz
    ['kiu']          = {'tr'},                              -- Kirmanjki
    ['lzz']          = {'tr'},                              -- Lazuri

    -- tt (Tatar) cluster: tt-cyrl , tt-latn -> tt (Tatar)
    ['tt-cyrl']      = {'tt'},
    ['tt-latn']      = {'tt'},

    -- zh (Chinese) cluster
    -- /includes/language/converters/ZhConverter.php
    -- https://gerrit.wikimedia.org/r/703560
    ['cdo']          = {'nan', 'zh-hant', 'zh', 'zh-hans'}, -- Min Dong Chinese
    ['gan']          = {'gan-hant', 'gan-hans', 'zh-hant', 'zh-hans', 'zh'}, -- Gan 
    ['gan-hans']     = {'gan', 'gan-hant', 'zh-hans', 'zh', 'zh-hant'},      -- Simplified Gan script
    ['gan-hant']     = {'gan', 'gan-hans', 'zh-hant', 'zh', 'zh-hans'},      -- Traditional Gan script
    ['hak']          = {'zh-hant', 'zh', 'zh-hans'},        -- Hakka
    ['ii']           = {'zh-cn', 'zh-hans', 'zh', 'zh-hant'}, -- Sichuan Yi
    ['lzh']          = {'zh-hant', 'zh', 'zh-hans'},        -- Literary Chinese
    ['nan']          = {'cdo', 'zh-hant', 'zh', 'zh-hans'}, -- Min Nan Chinese
    ['szy']          = {'zh-tw', 'zh-hant', 'zh', 'zh-hans'}, -- Sakizaya
    ['tay']          = {'zh-tw', 'zh-hant', 'zh', 'zh-hans'}, -- Atayal
    ['trv']          = {'zh-tw', 'zh-hant', 'zh', 'zh-hans'}, -- Seediq
    ['wuu']          = {'zh-hans', 'zh-hant', 'zh'},        -- Wu
    -- https://phabricator.wikimedia.org/T59138
    -- ['wuu']          = {'wuu-hans, 'wuu-hant', 'zh-hans', 'zh-hant', 'zh'}, -- Wu
    -- ['wuu-hans']     = {'wuu', 'wuu-hant', 'zh-hans', 'zh', 'zh-hant'},     -- Simplified Wu
    -- ['wuu-hant']     = {'wuu', 'wuu-hans', 'zh-hant', 'zh', 'zh-hans'},     -- Traditional Wu
    ['yue']          = {'zh-hk', 'zh-hant', 'zh-hans', 'zh'}, -- Cantonese
    -- https://phabricator.wikimedia.org/T59106
    -- ['yue']          = {'yue-hant', 'yue-hans, 'zh-hk', 'zh-hant', 'zh-hans', 'zh'}, -- Cantonese
    -- ['yue-hans']     = {'yue', 'yue-hant', 'zh-hans', 'zh', 'zh-hk', 'zh-hant'},     -- Simplified Cantonese
    -- ['yue-hant']     = {'yue', 'yue-hans', 'zh-hk', 'zh-hant', 'zh', 'zh-hans'},     -- Traditional Cantonese
    ['za']           = {'zh-hans', 'zh-hant', 'zh'},        -- Zhuang
    -- The time allocated for running scripts has expired.
    -- ['zh']           = {'zh-hans', 'zh-hant', 'zh-cn', 'zh-tw', 'zh-hk'}, -- Chinese
    -- ['zh-hans']      = {'zh-cn', 'zh', 'zh-hant'},   -- Simplified Chinese
    -- ['zh-hant']      = {'zh-tw', 'zh-hk', 'zh', 'zh-hans'},   -- Traditional Chinese
    -- ['zh-tw']        = {'zh-hant', 'zh-hk', 'zh', 'zh-hans'}, -- Chinese (Taiwan)
    -- ['zh-hk']        = {'zh-hant', 'zh-tw', 'zh', 'zh-hans'}, -- Chinese (Hong Kong)
    ['zh']           = {'zh-hans', 'zh-hant', 'zh-hk'}, -- Chinese
    ['zh-hans']      = {'zh-hant', 'zh-hk'},   -- Simplified Chinese
    ['zh-hant']      = {'zh-hk', 'zh-hans'},   -- Traditional Chinese
    ['zh-cn']        = {'zh-hans', 'zh', 'zh-hant'}, -- Chinese (Mainland China)
    ['zh-sg']        = {'zh-hans', 'zh-cn', 'zh', 'zh-hant'}, -- Chinese (Singapore)
    ['zh-my']        = {'zh-hans', 'zh-sg', 'zh-cn', 'zh', 'zh-hant'}, -- Chinese (Malaysia)
    ['zh-tw']        = {'zh-hant', 'zh-hk', 'zh-hans'}, -- Chinese (Taiwan)
    ['zh-hk']        = {'zh-hant', 'zh-hans'}, -- Chinese (Hong Kong)
    ['zh-mo']        = {'zh-hant', 'zh-hk', 'zh-tw', 'zh', 'zh-hans'}, -- Chinese (Macau)
    ['zh-classical'] = {'lzh', 'zh-hant', 'zh', 'zh-hans'}, -- Classical Chinese -> Literary Chinese
    ['zh-min-nan']   = {'nan', 'cdo', 'zh-hant', 'zh', 'zh-hans'},   -- Chinese (Min Nan) -> Min Nan Chinese
    ['zh-yue']       = {'yue', 'zh-hk', 'zh-hant', 'zh-hans', 'zh'}, -- Yue Chinese -> Cantonese

    ------------------------
    --------- misc ---------
    ------------------------
    ['arz']          = {'ar'},                              -- Egyptian Arabic -> Arabic
    ['azb']          = {'az'},                              -- Southern Azerbaijani -> Azerbaijani 
    ['be-x-old']     = {'be-tarask'},                       -- be-x-old -> be-tarask (wrong to correct Taraškievica form of Belarusian orthography)
    ['bh']           = {'bho'},                             -- Bihari -> Bhojpuri
    ['bpy']          = {'bn'},                              -- Bishnupria Manipuri -> Bengali

    -- da
    ['jut']          = {'da'},                              -- Jutish -> Danish
    ['kl']           = {'da'},                              -- Kalaallisut -> Danish

    ['en-gb']        = {'en'},                              -- Brexit -> English
    ['yi']           = {'he'},                              -- Yiddish -> Hebrew
    ['iu']           = {'ike-cans'},                        -- Inuktitut -> Eastern Canadian (Aboriginal syllabics)
    ['xmf']          = {'ka'},                              -- Mingrelian -> Georgian
    ['kbd']          = {'kbd-cyrl', 'ru'},                  -- Kabardian -> Адыгэбзэ
    ['tcy']          = {'kn'},                              -- Tulu -> Kannada
    ['ko-kp']        = {'ko'},                              -- 한국어 (조선) -> Korean
    ['ks']           = {'ks-arab'},                         -- Kashmiri -> Kashmiri (Arabic script)

    -- lt
    ['bat-smg']      = {'sgs', 'lt'},                       -- Samogitian -> Lithuanian
    ['sgs']          = {'lt'},                              -- Samogitian -> Lithuanian

    ['ltg']          = {'lv'},                              -- Latvian -> Latgalian
    ['dtp']          = {'ms'},                              -- Central Dusun -> Malay
    ['no']           = {'nb'},                              -- Norwegian (bokmål) -> Norwegian Bokmål
    ['roa-rup']      = {'rup'},                             -- Aromanian (other Romance) -> Aromanian
    ['aln']          = {'sq'},                              -- Gheg Albanian -> Albanian
    ['ug']           = {'ug-arab'},                         -- Uyghur -> Uyghur (Arabic script)
    ['khw']          = {'ur'},                              -- Khowar -> Urdu
}
