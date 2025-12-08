--- I18n library for message storage in Lua datastores.
--  The module is designed to enable message separation from modules &
--  templates. It has support for handling language fallbacks. This
--  module is a Lua port of [[wikia:w:c:dev:I18n-js|I18n-js]] and i18n modules that can be loaded
--  by it are editable through [[wikia:w:c:dev:I18nEdit|I18nEdit]].
--  
--  @module         i18n
--  @version        1.4.0
--  @require        Module:Entrypoint
--  @require        Module:Fallbacklist
--  @author         [[wikia:w:c:dev:User:KockaAdmiralac|KockaAdmiralac]]
--  @author         [[wikia:w:c:dev:User:Speedit|Speedit]]
--  @attribution    [[wikia:w:c:dev:User:Cqm|Cqm]]
--  @release        stable
--  @see            [[wikia:w:c:dev:I18n|I18n guide]]
--  @see            [[wikia:w:c:dev:I18n-js|I18n-js]]
--  @see            [[wikia:w:c:dev:I18nEdit|I18nEdit]]
--  <nowiki>
local i18n, _i18n = {}, {}

--  Module variables & dependencies.
local title = mw.title.getCurrentTitle()
local fallbacks = require('Module:Fallbacklist')
local entrypoint = require('Module:Entrypoint')
local uselang

--- Argument substitution as $n where n > 0.
--  @function           _i18n.handleArgs
--  @param              {string} msg Message to substitute arguments into.
--  @param              {table} args Arguments table to substitute.
--  @return             {string} Resulting message.
--  @local
function _i18n.handleArgs(msg, args)
    for i, a in ipairs(args) do
        msg = (string.gsub(msg, '%$' .. tostring(i), tostring(a)))
    end
    return msg
end

--- Checks whether a language code is valid.
--  @function           _i18n.isValidCode
--  @param              {string} code Language code to check.
--  @return             {boolean} Whether the language code is valid.
--  @local
function _i18n.isValidCode(code)
    return type(code) == 'string' and #mw.language.fetchLanguageName(code) ~= 0
end

--- Checks whether a message contains unprocessed wikitext.
--  Used to optimise message getter by not preprocessing pure text.
--  @function           _i18n.isWikitext
--  @param              {string} msg Message to check.
--  @return             {boolean} Whether the message contains wikitext.
function _i18n.isWikitext(msg)
    return
        type(msg) == 'string' and
        (
            msg:find('%-%-%-%-') or
            msg:find('%f[^\n%z][;:*#] ') or
            msg:find('%f[^\n%z]==* *[^\n|]+ =*=%f[\n]') or
            msg:find('%b<>') or msg:find('\'\'') or
            msg:find('%[%b[]%]') or msg:find('{%b{}}')
        )
end

--- I18n datastore class.
--  This is used to control language translation and access to individual
--  messages. The datastore instance provides language and message
--  getter-setter methods, which can be used to internationalize Lua modules.
--  The language methods (any ending in `Lang`) are all **chainable**.
--  @type            Data
local Data = {}
Data.__index = Data

--- Datastore message getter utility.
--  This method returns localized messages from the datastore corresponding
--  to a `key`. These messages may have `$n` parameters, which can be
--  replaced by optional argument strings supplied by the `msg` call.
--  
--  This function supports [[mw:Extension:Scribunto/Lua reference manual#named_arguments|named
--  arguments]]. The named argument syntax is more versatile despite its
--  verbosity; it can be used to select message language & source(s).
--  @function           Data:msg

--  @usage
--  
--      ds:msg{
--          key = 'message-name',
--          lang = '',
--          args = {...},
--          sources = {}
--      }
--  
--  @usage
--  
--      ds:msg('message-name', ...)
--  
--  @param              {string|table} opts Message configuration or key.
--  @param[opt]         {string} opts.key Message key to return from the
--                      datastore.
--  @param[opt]         {table} opts.args Arguments to substitute into the
--                      message (`$n`).
--  @param[opt]         {table} opts.sources Source names to limit to (see
--                      `Data:fromSources`).
--  @param[opt]         {table} opts.lang Temporary language to use (see
--                      `Data:inLang`).
--  @param[opt]         {string} ... Arguments to substitute into the message
--                      (`$n`).
--  @error[115]         {string} 'missing arguments in Data:msg'
--  @return             {string} Localised datastore message or `'<key>'`.
function Data:msg(opts, ...)
    local frame = mw.getCurrentFrame()
    -- Argument normalization.
    if not self or not opts then
        error('missing arguments in Data:msg')
    end
    local key = type(opts) == 'table' and opts.key or opts
    local args = opts.args or {...}
    -- Configuration parameters.
    if opts.sources then
        self:fromSources(unpack(opts.sources))
    end
    if opts.lang then
        self:inLang(opts.lang)
    end
    -- Source handling.
    local source_n = self.tempSources or self._sources
    local source_i = {}
    for n, i in pairs(source_n) do
        source_i[i] = n
    end
    self.tempSources = nil
    -- Language handling.
    local lang = self.tempLang or self.defaultLang
    self.tempLang = nil
    -- Language converter handling
    -- Types: 'languageConverterMarkup', 'pageSourceCodeLanguage',
    --   'siteLanguage', 'userLanguage'
    -- Note: Currently cannot handle page view language without using
    --   'languageConverterMarkup', should use 'userLanguage' in most cases if
    --   not able to use 'languageConverterMarkup'.
    local languageConversionType = self.tempLanguageConversionType or
    	'languageConverterMarkup'
    self.tempLangConversionType = 'languageConverterMarkup'
    -- Message fetching.
    local msg
    for i, messages in ipairs(self._messages) do
        -- Message data.
        local msg = nil
        -- Language converter support
        if lang == 'zh' and
        	languageConversionType ~= 'pageSourceCodeLanguage' and
        	languageConversionType ~= 'siteLanguage' and
        	(
        		mw.title.getCurrentTitle().pageLang:toBcp47Code() == 'zh' or
        		(
        			-- Module namespace
        			mw.title.getCurrentTitle():inNamespace( 828 ) and
        			mw.language.getContentLanguage():toBcp47Code() == 'zh'
    			)
        	)
        then
        	local userLang = ( i18n.getLang() or self.defaultLang )
        	local zh_hani = (messages['zh'] or {})[key]
        	local zh_hans = (messages['zh-hans'] or {})[key]
        	local zh_hant = (messages['zh-hant'] or {})[key]
        	local zh_hant_hk = (messages['zh-hk'] or {})[key]

			if
				languageConversionType == 'userLanguage'
			then
				if userLang == 'zh' then
        			msg = zh_hani or zh_hans or zh_hant or zh_hant_hk
				elseif
					userLang == 'zh-hans' or
					userLang == 'zh-cn' or
					userLang == 'zh-my' or
					userLang == 'zh-sg'
				then
        			msg = zh_hans or zh_hani or zh_hant or zh_hant_hk
				elseif
					userLang == 'zh-hant' or
					userLang == 'zh-tw'
				then
        			msg = zh_hant or zh_hant_hk or zh_hani or zh_hans
				elseif
					userLang == 'zh-hk' or
					userLang == 'zh-mo'
				then
        			msg = zh_hant_hk or zh_hant or zh_hani or zh_hans
        		end
        	elseif zh_hans ~= nil then
        		if zh_hant ~= nil then
    				msg = '-{' ..
    					'zh-hans:' .. zh_hans .. ';' ..
    					' zh-hant:' .. zh_hant .. ';'

    				if zh_hant_hk ~= nil then
    					msg = msg ..
    						' zh-hk:' .. zh_hant_hk .. ';'
    				end

    				msg = msg .. '}-'
        		elseif zh_hant_hk ~= nil then
        			msg = '-{' ..
        				'zh-hans:' .. zh_hans .. ';' ..
        				' zh-hk:' .. zh_hant_hk .. ';' ..
        				'}-'
        		else
        			msg = zh_hans
        		end
        	elseif zh_hant ~= nil then
        		if zh_hant_hk ~= nil then
        			msg = '-{' ..
        				'zh-hant:' .. zh_hant .. ';' ..
        				' zh-hk:' .. zh_hant_hk .. ';' ..
        				'}-'
        		else
        			msg = zh_hant
        		end
        	elseif zh_hant_hk ~= nil then
        		msg = zh_hant_hk
        	end
        end

        if msg == nil then
        	msg = (messages[lang] or {})[key]
        end
        -- Fallback support (experimental).
        for _, l in ipairs((fallbacks[lang] or {})) do
            if msg == nil then
                msg = (messages[l] or {})[key]
            end
        end
        -- Internal fallback to 'en'.
        msg = msg ~= nil and msg or messages.en[key]
        -- Handling argument substitution from Lua.
        if msg and source_i[i] and #args > 0 then
            msg = _i18n.handleArgs(msg, args)
        end
        if msg and source_i[i] and lang ~= 'qqx' then
            return frame and _i18n.isWikitext(msg)
                and frame:preprocess(mw.text.trim(msg))
                or  mw.text.trim(msg)
        end
    end
    return mw.text.nowiki('<' .. key .. '>')
end

--- Datastore template parameter getter utility.
--  This method, given a table of arguments, tries to find a parameter's
--  localized name in the datastore and returns its value, or nil if
--  not present.
--
--  This method always uses the wiki's content language.
--  @function           Data:parameter
--  @param              {string} parameter Parameter's key in the datastore
--  @param              {table} args Arguments to find the parameter in
--  @error[176]         {string} 'missing arguments in Data:parameter'
--  @return             {string|nil} Parameter's value or nil if not present
function Data:parameter(key, args)
    -- Argument normalization.
    if not self or not key or not args then
        error('missing arguments in Data:parameter')
    end
    local contentLang = mw.language.getContentLanguage():getCode()
    -- Message fetching.
    for i, messages in ipairs(self._messages) do
        local msg = (messages[contentLang] or {})[key]
        if msg ~= nil and args[msg] ~= nil then
            return args[msg]
        end
        for _, l in ipairs((fallbacks[contentLang] or {})) do
            if msg == nil or args[msg] == nil then
                -- Check next fallback.
                msg = (messages[l] or {})[key]
            else
                -- A localized message was found.
                return args[msg]
            end
        end
        -- Fallback to English.
        msg = messages.en[key]
        if msg ~= nil and args[msg] ~= nil then
            return args[msg]
        end
    end
end

--- Datastore temporary source setter to a specificed subset of datastores.
--  By default, messages are fetched from the datastore in the same
--  order of priority as `i18n.loadMessages`.
--  @function           Data:fromSource
--  @param              {string} ... Source name(s) to use.
--  @return             {Data} Datastore instance.
function Data:fromSource(...)
    local c = select('#', ...)
    if c ~= 0 then
        self.tempSources = {}
        for i = 1, c do
            local n = select(i, ...)
            if type(n) == 'string' and type(self._sources[n]) == 'number' then
                self.tempSources[n] = self._sources[n]
            end
        end
    end
    return self
end

--- Datastore default language getter.
--  @function           Data:getLang
--  @return             {string} Default language to serve datastore messages in.
function Data:getLang()
    return self.defaultLang
end

--- Datastore language setter to `wgUserLanguage`.
--  @function           Data:useUserLang
--  @return             {Data} Datastore instance.
--  @note               Scribunto only registers `wgUserLanguage` when an
--                      invocation is at the top of the call stack.
function Data:useUserLang()
    self.defaultLang = i18n.getLang() or self.defaultLang
    return self
end

--- Datastore language setter to `wgContentLanguage`.
--  @function           Data:useContentLang
--  @return             {Data} Datastore instance.
function Data:useContentLang()
    self.defaultLang = mw.language.getContentLanguage():getCode()
    return self
end

--- Datastore language setter to specificed language.
--  @function           Data:useLang
--  @param              {string} code Language code to use.
--  @return             {Data} Datastore instance.
function Data:useLang(code)
    self.defaultLang = _i18n.isValidCode(code)
        and code
        or  self.defaultLang
    return self
end

--- Temporary datastore language setter to `wgUserLanguage`.
--  The datastore language reverts to the default language in the next
--  @{Data:msg} call.
--  @function           Data:inUserLang
--  @return             {Data} Datastore instance.
function Data:inUserLang()
    self.tempLang = i18n.getLang() or self.tempLang
    return self
end

--- Temporary datastore language setter to `wgContentLanguage`.
--  Only affects the next @{Data:msg} call.
--  @function           Data:inContentLang
--  @return             {Data} Datastore instance.
function Data:inContentLang()
    self.tempLang = mw.language.getContentLanguage():getCode()
    return self
end

--- Temporary datastore language setter to a specificed language.
--  Only affects the next @{Data:msg} call.
--  @function           Data:inLang
--  @param              {string} code Language code to use.
--  @return             {Data} Datastore instance.
function Data:inLang(code)
    self.tempLang = _i18n.isValidCode(code)
        and code
        or  self.tempLang
    return self
end

--- Temporary datastore language setter to a specificed language conversion resolution.
--  Only affects the next @{Data:msg} call.
--  @function           Data:useLanguageConversionType
--  @param              {string} convType Language conversion type to use.
--  @return             {Data} Datastore instance.
function Data:useLanguageConversionType(convType)
    self.tempLanguageConversionType = convType
    return self
end

--  Package functions.

--- Localized message getter by key.
--  Can be used to fetch messages in a specific language code through `uselang`
--  parameter. Extra numbered parameters can be supplied for substitution into
--  the datastore message.
--  @function           i18n.getMsg
--  @param              {table} frame Frame table from invocation.
--  @param              {table} frame.args Metatable containing arguments.
--  @param              {string} frame.args[1] ROOTPAGENAME of i18n submodule.
--  @param              {string} frame.args[2] Key of i18n message.
--  @param[opt]         {string} frame.args.lang Default language of message.
--  @error[271]         'missing arguments in i18n.getMsg'
--  @return             {string} I18n message in localised language.
--  @usage              {{i18n|getMsg|source|key|arg1|arg2|uselang {{=}} code}}
function i18n.getMsg(frame)
    if
        not frame or
        not frame.args or
        not frame.args[1] or
        not frame.args[2]
    then
        error('missing arguments in i18n.getMsg')
    end
    local source = frame.args[1]
    local key = frame.args[2]
    -- Pass through extra arguments.
    local repl = {}
    for i, a in ipairs(frame.args) do
        if i >= 3 then
            repl[i-2] = a
        end
    end
    -- Load message data.
    local ds = i18n.loadMessages(source)
    -- Pass through language argument.
    ds:inLang(frame.args.uselang)
    -- Return message.
    return ds:msg { key = key, args = repl }
end
 
--- I18n message datastore loader.
--  @function           i18n.loadMessages
--  @param              {string} ... ROOTPAGENAME/path for target i18n
--                      submodules.
--  @error[322]         {string} 'no source supplied to i18n.loadMessages'
--  @return             {table} I18n datastore instance.
--  @usage              require('Module:I18n').loadMessages('1', '2')
function i18n.loadMessages(...)
    local ds
    local i = 0
    local s = {}
    for j = 1, select('#', ...) do
        local source = select(j, ...)
        if type(source) == 'string' and source ~= '' then
            i = i + 1
            s[source] = i
            if not ds then
                -- Instantiate datastore.
                ds = {}
                ds._messages = {}
                -- Set default language.
                setmetatable(ds, Data)
                ds:useUserLang()
            end
            source = string.gsub(source, '^.', mw.ustring.upper)
            source = mw.ustring.find(source, ':')
                and source
                or  'Module:' .. source .. '/i18n'
            ds._messages[i] = mw.loadData(source)
        end
    end
    if not ds then
        error('no source supplied to i18n.loadMessages')
    else
        -- Attach source index map.
        ds._sources = s
        -- Return datastore instance.
        return ds
    end
end

--- Language code getter.
--  Can validate a template's language code through `uselang` parameter.
--  @function           i18n.getLang
--  @usage              {{i18n|getLang|uselang {{=}} code}}
--  @return             {string} Language code.
function i18n.getLang()
    local frame = mw.getCurrentFrame() or {}
    local parentFrame = frame.getParent and frame:getParent() or {}

    local code = mw.language.getContentLanguage():getCode()
    local subPage = title.subpageText

    -- Language argument test.
    local langOverride =
        (frame.args or {}).uselang or
        (parentFrame.args or {}).uselang
    if _i18n.isValidCode(langOverride) then
        code = langOverride

    -- Subpage language test.
    elseif title.isSubpage and _i18n.isValidCode(subPage) then
        code = _i18n.isValidCode(subPage) and subPage or code

    -- User language test.
    elseif parentFrame.preprocess or frame.preprocess then
        uselang = uselang
            or  parentFrame.preprocess
                and parentFrame:preprocess('{{int:lang}}')
                or  frame:preprocess('{{int:lang}}')
        local decodedLang = mw.text.decode(uselang) 
        if decodedLang ~= '<lang>' and decodedLang ~= '⧼lang⧽' then
            code = decodedLang == '(lang)'
                and 'qqx'
                or  uselang
        end
    end

    return code
end

--- Template wrapper for [[Template:I18n]].
--  @function           i18n.main
--  @param              {table} frame Frame invocation object.
--  @return             {string} Module output in template context.
--  @usage              {{#invoke:i18n|main}}
i18n.main = entrypoint(i18n)

return i18n
-- </nowiki>
