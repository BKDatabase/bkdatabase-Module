local p = require('Module:UnitTests')

function p:test01_rgb()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToRgbTriplet|fefdfc}}',
		'{{#invoke:Color        |hexToRgbTriplet|fefdfc}}'
    )
end

function p:test02_cmyk_black()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|precision=3|000}}',
		'{{#invoke:Color        |hexToCmyk|precision=3|000}}'
    )
end

function p:test03_cmyk_white()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|precision=3|fff}}',
		'{{#invoke:Color        |hexToCmyk|precision=3|fff}}'
    )
end

function p:test04_cmyk_turquoise()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|precision=3|40E0D0}}',
		'{{#invoke:Color        |hexToCmyk|precision=3|40E0D0}}'
    )
end

function p:test05_cmyk_morchid()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|precision=3|BA55D3}}',
		'{{#invoke:Color        |hexToCmyk|precision=3|BA55D3}}'
    )
end

function p:test06_cmyk_gold()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|precision=3|FFD700}}',
		'{{#invoke:Color        |hexToCmyk|precision=3|FFD700}}'
    )
end

function p:test07_cmyk_gray()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|precision=3|808080}}',
		'{{#invoke:Color        |hexToCmyk|precision=3|808080}}'
    )
end

function p:test08_hsl_black()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|precision=3|000}}',
		'{{#invoke:Color        |hexToHsl|precision=3|000}}'
    )
end

function p:test09_hsl_white()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|precision=3|FFF}}',
		'{{#invoke:Color        |hexToHsl|precision=3|FFF}}'
    )
end

function p:test10_hsl_crimson()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|precision=3|DC143C}}',
		'{{#invoke:Color        |hexToHsl|precision=3|DC143C}}'
    )
end

function p:test11_hsl_msgreen()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|precision=3|00FA9A}}',
		'{{#invoke:Color        |hexToHsl|precision=3|00FA9A}}'
    )
end

function p:test12_hsl_rblue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|precision=3|4169E1}}',
		'{{#invoke:Color        |hexToHsl|precision=3|4169E1}}'
    )
end

function p:test13_hsv_black()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|precision=3|000}}',
		'{{#invoke:Color        |hexToHsv|precision=3|000}}'
    )
end

function p:test14_hsv_white()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|precision=3|FFF}}',
		'{{#invoke:Color        |hexToHsv|precision=3|FFF}}'
    )
end

function p:test15_hsv_crimson()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|precision=3|DC143C}}',
		'{{#invoke:Color        |hexToHsv|precision=3|DC143C}}'
    )
end

function p:test16_hsv_msgreen()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|precision=3|00FA9A}}',
		'{{#invoke:Color        |hexToHsv|precision=3|00FA9A}}'
    )
end

function p:test17_hsv_rblue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|precision=3|4169E1}}',
		'{{#invoke:Color        |hexToHsv|precision=3|4169E1}}'
    )
end

function p:test18_cielch_black()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|000}}',
		'{{#invoke:Color        |hexToCielch|precision=3|000}}'
    )
end

function p:test19_cielch_white()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|FFF}}',
		'{{#invoke:Color        |hexToCielch|precision=3|FFF}}'
    )
end

function p:test20_cielch_red()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|F00}}',
		'{{#invoke:Color        |hexToCielch|precision=3|F00}}'
    )
end

function p:test21_cielch_yellow()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|FF0}}',
		'{{#invoke:Color        |hexToCielch|precision=3|FF0}}'
    )
end

function p:test22_cielch_green()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|0F0}}',
		'{{#invoke:Color        |hexToCielch|precision=3|0F0}}'
    )
end

function p:test23_cielch_cyan()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|0FF}}',
		'{{#invoke:Color        |hexToCielch|precision=3|0FF}}'
    )
end

function p:test24_cielch_blue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|00F}}',
		'{{#invoke:Color        |hexToCielch|precision=3|00F}}'
    )
end

function p:test25_cielch_magenta()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|F0F}}',
		'{{#invoke:Color        |hexToCielch|precision=3|F0F}}'
    )
end

function p:test26_cielch_grey()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|808080}}',
		'{{#invoke:Color        |hexToCielch|precision=3|808080}}'
    )
end

function p:test27_cielch_awhite()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|FAEBD7}}',
		'{{#invoke:Color        |hexToCielch|precision=3|FAEBD7}}'
    )
end

function p:test28_cielch_onyx()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|353839}}',
		'{{#invoke:Color        |hexToCielch|precision=3|353839}}'
    )
end

function p:test29_cielch_licorice()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|precision=3|1A1110}}',
		'{{#invoke:Color        |hexToCielch|precision=3|1A1110}}'
    )
end

function p:test30_cmyk_darkestred()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|010000}}',
		'{{#invoke:Color        |hexToCmyk|010000}}'
    )
end

function p:test31_cmyk_darkestgreen()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|000100}}',
		'{{#invoke:Color        |hexToCmyk|000100}}'
    )
end

function p:test32_cmyk_darkestblue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCmyk|000001}}',
		'{{#invoke:Color        |hexToCmyk|000001}}'
    )
end

function p:test33_hsl_neargrey1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|808081}}',
		'{{#invoke:Color        |hexToHsl|808081}}'
    )
end

function p:test34_hsl_neargrey2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|808180}}',
		'{{#invoke:Color        |hexToHsl|808180}}'
    )
end

function p:test35_hsl_darkestred()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|010000}}',
		'{{#invoke:Color        |hexToHsl|010000}}'
    )
end

function p:test36_hsl_darkestgreen()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|000100}}',
		'{{#invoke:Color        |hexToHsl|000100}}'
    )
end

function p:test37_hsl_darkestblue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|000001}}',
		'{{#invoke:Color        |hexToHsl|000001}}'
    )
end

function p:test38_hsl_lightestcyan()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|FEFFFF}}',
		'{{#invoke:Color        |hexToHsl|FEFFFF}}'
    )
end

function p:test39_hsl_lightestmagenta()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|FFFEFF}}',
		'{{#invoke:Color        |hexToHsl|FFFEFF}}'
    )
end

function p:test40_hsl_lightestyellow()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsl|FFFFFE}}',
		'{{#invoke:Color        |hexToHsl|FFFFFE}}'
    )
end

function p:test41_hsv_neargrey1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|EEEEEF}}',
		'{{#invoke:Color        |hexToHsv|EEEEEF}}'
    )
end

function p:test42_hsv_neargrey2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|EEEFEE}}',
		'{{#invoke:Color        |hexToHsv|EEEFEE}}'
    )
end

function p:test43_hsv_darkestred()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|010000}}',
		'{{#invoke:Color        |hexToHsv|010000}}'
    )
end

function p:test44_hsv_darkestgreen()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|000100}}',
		'{{#invoke:Color        |hexToHsv|000100}}'
    )
end

function p:test45_hsv_darkestblue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToHsv|000001}}',
		'{{#invoke:Color        |hexToHsv|000001}}'
    )
end

function p:test46_cielch_neargrey()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|111011}}',
		'{{#invoke:Color        |hexToCielch|111011}}'
    )
end

function p:test47_cielch_darkestred()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|010000}}',
		'{{#invoke:Color        |hexToCielch|010000}}'
    )
end

function p:test48_cielch_darkestgreen()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|000100}}',
		'{{#invoke:Color        |hexToCielch|000100}}'
    )
end

function p:test49_cielch_darkestblue()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|000003}}',
		'{{#invoke:Color        |hexToCielch|000003}}'
    )
end

function p:test50_cielch_lightestcyan()	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|FEFFFF}}',
		'{{#invoke:Color        |hexToCielch|FEFFFF}}'
    )
end

function p:test51_cielch_lightestmagenta()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|FFFEFF}}',
		'{{#invoke:Color        |hexToCielch|FFFEFF}}'
    )
end

function p:test52_cielch_lightestyellow()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexToCielch|FFFFFC}}',
		'{{#invoke:Color        |hexToCielch|FFFFFC}}'
    )
end

function p:test53_mix1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|FF0}}',
		'{{#invoke:Color        |hexMix|00F|FF0}}'
    )
end

function p:test54_mix2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|0F0|25}}',
		'{{#invoke:Color        |hexMix|00F|0F0|25}}'
    )
end

function p:test55_mix_limit1()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|0F0|0}}',
		'{{#invoke:Color        |hexMix|00F|0F0|0}}'
    )
end

function p:test56_mix_limit2()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|0F0|100}}',
		'{{#invoke:Color        |hexMix|00F|0F0|100}}'
    )
end

function p:test57_mix_clamp()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|0F0|200}}',
		'{{#invoke:Color        |hexMix|00F|0F0|200}}'
    )
end

function p:test58_mix_negative()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|0F0|-50}}',
		'{{#invoke:Color        |hexMix|00F|0F0|-50}}'
    )
end

function p:test59_mix_proportion_range()
	self:preprocess_equals_preprocess(
		'{{#invoke:Color/sandbox|hexMix|00F|0F0|30|min=20|max=90}}',
		'{{#invoke:Color        |hexMix|00F|0F0|30|min=20|max=90}}'
    )
end

return p
