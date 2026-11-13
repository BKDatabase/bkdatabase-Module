local p = {}
local plaintext = require("Module:Plain text")._main
local language = mw.language.getContentLanguage()

--Cleanup/format location for use in short descriptions
function p.prepareLoc (frame)
	return p._prepareLoc (frame.args[1])
end

function p._prepareLoc (text)
	text = plaintext(text)
	text = text..',' --comma at the end makes things convenient
	text = mw.ustring.gsub(text,'%b()', ', ') --remove things in brackets as extraneous information
	text = mw.ustring.gsub(text,'[^%s,]*%d[^%s,]*', '') --remove things with digits as generally being unnecessary postal codes/road numbers etc
	text = mw.ustring.gsub(text,'(,%s-),', '%1') --fix possible blank separated commas from previous cleanup
	text = mw.ustring.gsub(text,'%s%s', ' ') --fix possible extra spaces from previous cleanup
	text = mw.ustring.gsub(text,'^[%s,]*', '') --trim commas and spaces from beginning
	text = mw.ustring.gsub(text,'[%s,]*$', '') --trim commas and spaces from end
	return text
end

--Gets general location from more specific one for short descriptions
--i.e if a location is specified to be "P. Sherman 42 Wallaby Way Sydney, Australia", return "Sydney, Australia"
--splits by commas and returns last two entries

function p.generalLoc (frame)
	return p._generalLoc (frame.args[1])
end

function p._generalLoc (loc)
	loc = p._prepareLoc(loc)
	local split = {}
	local num = 0
	loc = loc..',' --comma at the end for convenient splitting with gmatch
	for k in mw.ustring.gmatch(loc,'([^,]*),') do --split by commas
		table.insert(split, k)
		num = num + 1
	end
	if num == 1 then --if only comma was the one at the end return the whole thing
		return split[1]
	else
		return split[num-1]..','..split[num] --return last two entries separated by commas
	end
end

--validate type parameter
function p.validateTyp (typ, args)
	args = args or {}
	local checkpatterns = args['check-patterns']
	local invalidadd = args.invalidadd
	if checkpatterns then
		for k in mw.ustring.gmatch(checkpatterns..';','([^;]*);') do --split checkpatterns by ;, check if one of the patterns is in type
			if mw.ustring.match(mw.ustring.lower(typ),k) then 
				return typ
			end
		end
		if invalidadd then --if invalid, add to make it valid
			return typ..' '..invalidadd
		end
	else
		return typ
	end
end

function p._generateDesc (args)
	local cleanupLoc = require('Module:Settlement short description').cleanupLoc
	local typ = args[1] or ""
	typ = plaintext(args[1]) or ""
	if #typ == 0 then return end  -- bail out if type is empty
	local sep = ((args.sep == 'no') and '') or args.sep or ' in ' --if args.sep set to no, nothing between typ and loc, if it has other value put that
	local loc = args[2] or ""
	local func
	if args['full-loc'] then func = '_prepareLoc' else func =  '_generalLoc' end
	loc = p[func](loc) or ""
	loc = cleanupLoc(loc) or ""
	loc = mw.text.trim(loc)
	loc = loc and #loc > 0 and sep..loc or ""
	typ = p.validateTyp (typ, args)
	return typ and language:ucfirst(typ..loc)
end

function p.generateDesc(frame)
	local args = require('Module:Arguments').getArgs(frame)
	return p._generateDesc(args) or ""
end

--Display short description using {{short description}}
function p.shortdesc(text, frame)
	frame = frame or mw.getCurrentFrame()
	return frame:expandTemplate{title = 'Short description', args = {text, 'noreplace'}}
end

function p._main(args, frame)
	frame = frame or mw.getCurrentFrame()
	local desc = p._generateDesc(args)
	return desc and p.shortdesc(desc, frame)
end

--generates type in location
function p.main(frame)
	local args = require('Module:Arguments').getArgs (frame, {frameOnly = true})
	return p._main(args, frame) or ""
end

return p