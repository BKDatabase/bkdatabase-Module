require('strict');
local utf8 = require("Module:Unicode data")
-- Converts romanji kana to modified hepburn, I recommend subst:ing

-- standard long vowel patterns
local diacritics = {
    ["aa"] = "ā",
    ["uu"] = "ū",
    ["ee"] = "ē",
    ["oo"] = "ō",
    ["ou"] = "ō",
    ["Aa"] = "Ā",
    ["Uu"] = "Ū",
    ["Ee"] = "Ē",
    ["Oo"] = "Ō",
    ["Ou"] = "Ō",
    ["AA"] = "Ā",
    ["UU"] = "Ū",
    ["EE"] = "Ē",
    ["OO"] = "Ō",
    ["OU"] = "Ō"
}
local function romanjiToHepburn(romanji)
	for target, replacement in pairs(diacritics) do
    	romanji = romanji:gsub(target, replacement) 
    end
    return romanji	
end

--map is made local so it wont get cached every single time this is ran
local function kanaToHepburn(kana)
	local romanji = ""
	
	--TODO split map up into consonant groups and create a jump table based off the unicode value
    local kanaMap = {
        ["あ"] = "a", ["い"] = "i", ["う"] = "u", ["え"] = "e", ["お"] = "o",
        ["か"] = "ka", ["き"] = "ki", ["く"] = "ku", ["け"] = "ke", ["こ"] = "ko",
        ["さ"] = "sa", ["し"] = "shi", ["す"] = "su", ["せ"] = "se", ["そ"] = "so",
        ["た"] = "ta", ["ち"] = "chi", ["つ"] = "tsu", ["て"] = "te", ["と"] = "to",
        ["な"] = "na", ["に"] = "ni", ["ぬ"] = "nu", ["ね"] = "ne", ["の"] = "no",
        ["は"] = "ha", ["ひ"] = "hi", ["ふ"] = "fu", ["へ"] = "he", ["ほ"] = "ho",
        ["ま"] = "ma", ["み"] = "mi", ["む"] = "mu", ["め"] = "me", ["も"] = "mo",
        ["や"] = "ya", ["ゆ"] = "yu", ["よ"] = "yo", --["ゃ"] = "ya", ["ゅ"] = "yu", ["ょ"] = "yo",
        ["ら"] = "ra", ["り"] = "ri", ["る"] = "ru", ["れ"] = "re", ["ろ"] = "ro",
        ["わ"] = "wa", ["ゐ"] = "wi", ["ゑ"] = "we", ["を"] = "wo",
        ["ん"] = "n",
        ["が"] = "ga", ["ぎ"] = "gi", ["ぐ"] = "gu", ["げ"] = "ge", ["ご"] = "go",
        ["ざ"] = "za", ["じ"] = "ji", ["ず"] = "zu", ["ぜ"] = "ze", ["ぞ"] = "zo",
        ["だ"] = "da", ["ぢ"] = "ji", ["づ"] = "dzu", ["で"] = "de", ["ど"] = "do",
        ["ば"] = "ba", ["び"] = "bi", ["ぶ"] = "bu", ["べ"] = "be", ["ぼ"] = "bo",
        ["ぱ"] = "pa", ["ぴ"] = "pi", ["ぷ"] = "pu", ["ぺ"] = "pe", ["ぽ"] = "po",
        ["ゔ"] = "vu"
    }
    local smallKanaMap = {
    	["ぁ"] = "a", ["ぃ"] = "i", ["ぅ"] = "u", ["ぇ"] = "e", ["ぉ"] = "o",
    	["ゕ"] = "ka", ["ゖ"] = "ke",
    	["ゃ"] = "ya", ["ゅ"] = "yu", ["ょ"] = "yo"
    }
    

  for character in mw.ustring.gcodepoint(kana) do	-- iterates over each kana to convert it to romanji without diacritics
        local char = mw.ustring.char(character)		-- this is a really bad way of doing a foreach but
        local romanization = kanaMap[char]			-- i'm new to mw lua, and couldn't get it to play nice
        local smallRomanization = smallKanaMap[char]
    	
        if romanization then					-- if kana was found in kanaMap
            romanji = romanji .. romanization
        elseif smallRomanization then			-- if kana was not found in kanaMap, but found in smallKanaMap
        	local lasttwo = romanji:sub(-3,-2)
        	if(lasttwo == "sh" or lasttwo == "ch" or lasttwo == "ts" or lasttwo == "dz") then	-- special case for the 3 letter romanizations
        		romanji = romanji:sub(1, -2) .. smallKanaMap[char]:sub(-1)						-- since しゅ=> shu rather than shyu or syu
        	else
        		romanji = romanji:sub(1, -2) .. smallKanaMap[char] -- remove vowel, append small vowel or other letters
        	end													   -- this will cause issues if someone tries something like あぁぁぁぁぁ => a
        else												       -- special rule for double little vowels maybe? will make this more expensive
            romanji = romanji .. char	-- character was not in either map, append it directly
        end
  end
  

	-- Replace "っ" with the next consonant
	for i = 1, mw.ustring.len(romanji) do
	    local chr = mw.ustring.sub(romanji, i, i)	-- string[i]
	    if chr == "っ" then
	        local nextChar = mw.ustring.sub(romanji, i + 1, i + 1)	-- get the next letter after the small tsu
	        if nextChar and not nextChar:match("[aeiou]") then	    -- if it's a vowel, we don't replicate it.
	            romanji = mw.ustring.sub(romanji, 1, i-1) .. nextChar .. mw.ustring.sub(romanji, i + 1) -- string before the small tsu + next character + string after that one xtsu
	        end																						    -- surely there's a better way?
	    end
	end
	return romanjiToHepburn(romanji)	-- kana is converted to romanji, now change it to hepburn
end										-- TODO: add a flag to disable this, and return the normal romanji without the diacritics 

-- checking for kana will need to check these bounds regardless
-- might as well convert at the same time
-- would it be better to have the kana conversion in the above function?
local function checkForKanaPresentAndConvert(data)
    local kanaFound = false
    local convertedString = ""
	local hiraganaLowerBound = mw.ustring.codepoint("ぁ") -- I know magic numbers are bad but it almost seems more worth 
	local hiraganaUpperBound = mw.ustring.codepoint("ゖ") -- it to use them in this context
	local katakanaLowerBound = mw.ustring.codepoint("ァ") -- this is really expensive
	local katakanaUpperBound = mw.ustring.codepoint("ヶ")
	local kanaDelta = (katakanaLowerBound - hiraganaLowerBound)  -- difference in the unicode table
    for c in mw.ustring.gcodepoint(data) do
        if c<=127 then	-- short circuit for ascii, which is the intended use.
						-- kana support was intended to be a minor feature 
        elseif (hiraganaLowerBound <= c and c <= hiraganaUpperBound) then
            kanaFound = true
        elseif (katakanaLowerBound <= c and c <= katakanaUpperBound) then
            kanaFound = true
            c = c - kanaDelta -- convert to hiragana codepointwise so i dont have to remake the lookup table for katakana 
        end
        convertedString = convertedString .. mw.ustring.char(c) -- append the processed character to the current running string
    end															-- this is bad, we're rebuilding the entire string just for katakana 
																-- maybe there's some string sub magic we can do?
    return {kanaFound, convertedString}
end

local function toHepburnKana(data)
	local processedData

	if not data then -- short circuit
		return
	end
	
	processedData = checkForKanaPresentAndConvert(data)
	
	if  processedData[1] then					-- processedData[1] = kanaFound
		return kanaToHepburn(processedData[2])	-- processedData[2] = convertedString 
	else
		return romanjiToHepburn(data)			-- kana not found, that should mean we were probably given romanji
	end											-- and if its other unicode, they just get that string back
end

local p = {}

--TODO add a performant way to detect if there is kana in a string
--this could be expanded to use bopomofo too
function p.toHepburn(frame)
		local data = frame.args[1]
		return toHepburnKana(data)
end

-- testing function for the lua console on the module itself
function p.toHepburnTEST(data)
		return toHepburnKana(data)

end

return p