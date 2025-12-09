-- <nowiki>
local Quote = {}
local getArgs = require('Module:Arguments').getArgs
local i18n = require('Module:I18n').loadMessages('Quote')

local function build(quote_contents, quote_source, options)
    local quote_container = mw.html.create('blockquote')
        :addClass('pull-quote')
        :addClass(options.align)
        :addClass(options.extraclasses)
        :css(options.styles)
        :cssText(options.extrastyles)
        
    quote_container:node(quote_contents)
        
    if quote_source then
	    quote_container:tag('div')
	    	:addClass('pull-quote__source')
	        	:tag('cite')
	        	:wikitext(quote_source)
	        	:done()
        	:done()
    end
    
    return quote_container
end

local function options(args)
    local options = {}
    
    options.styles = {}
    options.extraclasses = i18n:parameter('class', args)
    options.extrastyles = i18n:parameter('style', args)
    options.align = ''
    local align = i18n:parameter('align', args)
    if align then
        options.align = 'pull-quote--' .. align
        options.styles['width'] = i18n:parameter('width', args) or
                                  i18n:parameter('quotewidth', args) or
                                  '300px'
    end
    
    return options
end

-- let MediaWiki parser auto-generate <p> tags
local function paragraph(quotetext)
	return '\n' .. quotetext .. '\n'
end

function Quote.quote(frame)
    local args = getArgs(frame)

    local options = options(args)
    
    local quotetext = args[1] or
                      i18n:parameter('quotetext', args) or
                      i18n:parameter('quote', args) or
                      i18n:parameter('text', args) or ''
    local person = args[2] or
                   i18n:parameter('person', args) or
                   i18n:parameter('speaker', args) or
                   i18n:parameter('personquoted', args) or nil
    local source = args[3] or
                   i18n:parameter('source', args) or
                   i18n:parameter('quote_source', args) or nil

    local quote_contents = mw.html.create('div')
        :addClass('pull-quote__text')
        :wikitext(paragraph(quotetext))
    
    local quote_source = person
    
    if person and source then
        quote_source = person .. ', ' .. source
    elseif source then
    	quote_source = source
    end
    
    return build(quote_contents, quote_source, options)
end

function Quote.dialogue(frame)
    local args = getArgs(frame)
    
    local options = options(args)
    
    local quote_contents = mw.html.create('div')
        :addClass('pull-quote__text')
        
    local quote_source

    for i, v in ipairs(args) do
        local next_param = i + 1
        
        if i % 2 ~= 0 then
            quote_contents:tag('div')
                :addClass('pull-quote__line')
                :tag('strong')
                    :addClass('pull-quote__speaker')
                    :wikitext(v .. ':')
                    :done()
                :wikitext(' ' .. paragraph(args[next_param]))
                :done()
        end
    end
    
    local context = i18n:parameter('context', args)
    local source = i18n:parameter('source', args)
    if context and source then
        quote_source = context .. ', ' .. source
    elseif context and not source then
        quote_source = context
    elseif source and not context then
        quote_source = source
    end
    
    return build(quote_contents, quote_source, options)
    
end

return Quote
