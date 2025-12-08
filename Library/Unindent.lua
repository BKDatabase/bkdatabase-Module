--[[
    Copyright (c) 2013 Enrique García Cota
    
    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]
-- <nowiki>
--- Unindent resets the indentation level of mulitline strings.
--  It is useful for multiline strings inside functions and large tables.
--  This module serves as a utility function for string parsing.
--  
--  Lua supports multiline strings in the format `[[\n...\n]]`. In general,
--  Lua does not outdent indented multiline strings out of the box. Though
--  Lua supports variable indentation in multiline strings, custom logic is
--  necessary to reset the string's indentation. This module adopts a
--  flexible approach based on string scanning.
--  
--  Unlike Penlight's `pl.text.dedent` behaviour where every line has the
--  indentation of the first line removed, the line prefixed with the least
--  non-tab whitespace is reset to zero indentation. Thus, the opening line
--  of the string may retain some indentation *if* there are lines of less
--  indentation terminating the string.
--  
--  @script             unindent
--  @license            MIT
--  @release            stable
--  @author             [[wikia:c:User:8nml|8nml]]
--  @attribution        [https://github.com/kikito @kikito] ([https://github.com/kikito/inspect.lua/blob/master/spec/unindent.lua GitHub])
--  @param              {string} str Multiline string indented consistently.
--  @returns            {string} Unindented string.
return function(str)
    str = str:gsub(' +$', ''):gsub('^ +', '') -- remove spaces at start and end
    local level = math.huge
    local minPrefix = ''
    local len
    for prefix in str:gmatch('\n( +)') do
        len = #prefix
        if len < level then
            level = len
            minPrefix = prefix
        end
    end
    return (str:gsub('\n' .. minPrefix, '\n'):gsub('\n$', ''))
end
