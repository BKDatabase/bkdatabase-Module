local p = {}
local TwitterSnowflake = require('Mô đun:TwitterSnowflake')
local CiteWeb = require('Mô đun:Chú thích web')['']

local err_msgs_t = {															-- a sequence of snowflake date error messages; all must be terminated with a semicolon (;)
	' <kbd>&#124;date=</kbd> / <kbd>&#124;number=</kbd> không khớp;',				-- [1]
	' Cần <kbd>&#124;date=</kbd>;',										-- [2]
	' <kbd>&#124;number=</kbd> không hợp lệ;',										-- [3]
	' <kbd>&#124;number=</kbd> thiếu hoặc bị trống;',								-- [4]
	' <kbd>&#124;user=</kbd> thiếu hoặc bị trống;'									-- [5]
	}


--[[--------------------------< M A I N >----------------------------------------------------------------------
]]

p.main = function(frame)
	return p[''](frame)
end

--[[--------------------------< S U P P R E S S _ U R L _ I N _ T I T L E >------------------------------------

This function searches for and suppresses urls in |title=, |script-title=, and |trans-title= parameters so that
{{cite web}} won't emit 'External link in |title=' error messages when rendered In the redering, urls are correctly
formed as they were in the original tweet.  The function looks for valid schemes and then wraps them in
<nowiki>..</nowiki> tags.

]]

local function suppress_url_in_title (frame, title)
	local schemes = {															-- schemes commonly found in tweets
		'https://',
		'http://',
		'ftp://',
		}

	if title then																-- when there is a title, suppress any urls with known schemes; abandon else
		for _, scheme in ipairs (schemes) do									-- spin through the list of schemes looking for a match
			title = title:gsub (scheme, frame:callParserFunction ('#tag', {'nowiki', scheme}));	-- replace the scheme with its nowiki'd form (a strip marker)
		end
	end

	return title;																-- done; return <title> modified or not
end


--[[--------------------------< D A T E _ N U M B E R _ U R L _ G E T >----------------------------------------

extract |date= and |number= parameter values if present.  Extract date from |number= and compare to |date=.

contruct |url= for {{cite web}} from the base url and |number= and |user=

returns nothing; adds date, number, url to <cite_args_t>; adds error message(s) to <errors_t>.

]]

local function replace_vietnamese_date(date_str)
	local replacements = {
		["[Nn]gày "] = "",
		["[Tt]háng 1"] = "January",
		["[Tt]háng 2"] = "February",
		["[Tt]háng 3"] = "March",
		["[Tt]háng 4"] = "April",
		["[Tt]háng 5"] = "May",
		["[Tt]háng 6"] = "June",
		["[Tt]háng 7"] = "July",
		["[Tt]háng 8"] = "August",
		["[Tt]háng 9"] = "September",
		["[Tt]háng 10"] = "October",
		["[Tt]háng 11"] = "November",
		["[Tt]háng 12"] = "December",
		["[Nn]ăm "] = "",
	}
	
	for k, v in pairs(replacements) do
		date_str = mw.ustring.gsub(date_str, k, v)
	end
	
	return date_str
end

local function date_number_url_get (args_t, cite_args_t, errors_t)
	local err_msg_index;

	cite_args_t.url = 'https://x.com/';									        -- initialize with minimal base url because {{cite web}} requires |url=
	if not args_t.user then
		table.insert (errors_t, err_msgs_t[5]);									-- error: missing or empty |user=
	end

	if not args_t.date and not args_t.number then
		err_msg_index = 4;														-- error: missing or empty |number=
	elseif tonumber (args_t.number) then										-- |number= without |date=? use number
		if tonumber(args_t.number) then
			cite_args_t.date = args_t.date or (args_t.number and TwitterSnowflake.snowflakeToDate{ args = {id_str = args_t.number} });
		else
			cite_args_t.date = args_t.date;
		end
			cite_args_t.number = args_t.number;

			if args_t.user then													-- |number= appears to have a valid value; if |user= has a value
				cite_args_t.url = cite_args_t.url .. args_t.user .. '/status/' .. args_t.number;	-- construct |url= for {{cite web}}
			end
	elseif args_t.number then													-- |number= with a value that can't be converted to a number; invalid
		err_msg_index = 3;														-- error: invalid number (couldn't convert to number)
	elseif not args_t.number then												-- |date= without |number= use date
		cite_args_t.date = args_t.date;											-- |date= has a value, use it
		err_msg_index = 4;														-- error: missing or empty |number=
	end

	if err_msg_index then
		table.insert (errors_t, err_msgs_t[err_msg_index]);						-- invalid number or missing necessary parameters so abandon
		return;
	end
	
	if args_t.date then
		replace_vietnamese_date(args_t.date);
		return;
    end

	err_msg_index = TwitterSnowflake.datecheck ({ args = {						-- returns error message index number on error; nil else
		id_str	= args_t.number or '',
		date	= args_t.date or '',
		error1	= 1,															-- these numbers are indexes into <err_msgs_t> to override snowflake default error messages
		error2  = 2,															-- done this way to avoid long string comparison looking for
		error3	= 3																-- the undated-pre-twitter-epoch-post message
		}});

	if	2 == err_msg_index then													-- when no date and posted before twitter epoch
		cite_args_t.date = nil;													-- suppress default date because {{cite tweet}} should not claim in its own voice that the undated post was posted 2010-11-04
	end
	
	table.insert (errors_t, err_msgs_t[err_msg_index]);							-- add error message
end


--[[--------------------------< p[''] >------------------------------------------------------------------------

construct parameter set for {{cite web}} from {{cite tweet}} parameters;  do some error checking

]]

p[''] = function(frame)
	local args_t = require ('Module:Arguments').getArgs (frame);

	local cite_args_t = {
		title = suppress_url_in_title (frame, args_t.title),
		['script-title'] = suppress_url_in_title (frame, args_t['script-title']),
		['trans-title'] = suppress_url_in_title (frame, args_t['trans-title']),
		language = args_t.language,
		last1 = args_t.last1 or args_t.last,
		first1 = args_t.first1 or args_t.first,
		author1 = args_t.author1 or args_t.author,
		['author-link'] = args_t['author-link'] or args_t.authorlink,
		others = args_t.retweet and ('Retweeted by ' .. args_t.retweet),
		via = args_t.link == 'no' and 'Twitter' or '[[w:Twitter|Twitter]]',
		type = args_t.link == 'no' and 'Tweet' or '[[w:vi:Tweet (mạng xã hội)|Tweet]]',
		location = args_t.location,												-- why |location=?  tweets are online; there is no publication place
		['access-date'] = args_t['access-date'] or args_t.accessdate,
		['archive-date'] = args_t['archive-date'] or args_t.archivedate,
		['archive-url'] = args_t['archive-url'] or args_t.archiveurl,
		['url-status'] = args_t['url-status'],
		['url-access'] = args_t['url-access'],
		quote = args_t.quote,
		ref = args_t.ref,
		df = args_t.df,
		mode = args_t.mode
		}

	local errors_t = {'<span class="cs1-visible-error citation-comment"> <kbd>{{[[Template:Cite tweet|Cite tweet]]}}</kbd>:'};		-- initialize sequence of error messages with style tag
	date_number_url_get (args_t, cite_args_t, errors_t);						-- add |date=, |number=, |url= to <cite_args_t>

	local author = ((cite_args_t.last1 and cite_args_t.first1) and cite_args_t.last1 .. ', ' .. cite_args_t.first1) or	-- concatenate |last= with |first= for |author-mask=
		(cite_args_t.last1 and cite_args_t.last1) or							-- only |last= for |author-mask=
		(cite_args_t.author1 and cite_args_t.author1:gsub('^%(%((.+)%)%)$', '%1'));	-- |author= or |author1= stripped of accept-as-written markup for |author-mask=

	if author and args_t.user then
		cite_args_t['author-mask'] = author .. ' [@' .. (args_t.user or '') .. ']'	-- concatenate <author> and |user= into |author-mask=
	elseif args_t.user then
		cite_args_t.author1 = '((' .. args_t.user .. '))';						-- just the user name for cs1|2 metadata
		cite_args_t['author-mask'] = '@' .. args_t.user;						-- make a mask for display
	else																		-- here when neither <author> nor |user=
		cite_args_t.author1 = nil;												-- so unset
	end

	frame.args = cite_args_t;													-- overwrite frame arguments
	local rendering = CiteWeb (frame);											-- render the template

---------- error messaging ----------
	if errors_t[2] then															-- errors_t[2] nil when no errors
		if rendering:find ('cs1-visible-error', 1, true) then					-- rendered {{cite web}} with errors will have this string
			errors_t[1] = errors_t[1]:gsub ('> <', '>; <');						-- insert semicolon to terminate cs1|2 error message string
		end

		errors_t[#errors_t] = errors_t[#errors_t]:gsub (';$',' ([[Template:Cite_tweet#Error_detection|help]])');	-- replace trailing semicolon with help link
		table.insert (errors_t, '</span>');										-- close style span tag
		if mw.title.getCurrentTitle():inNamespace (0) then						-- mainspace only
			table.insert (errors_t, '');	-- add error category
		end

		rendering = rendering .. table.concat (errors_t);						-- append error messaging, help links and catagories
	end
	return rendering;
end

return p