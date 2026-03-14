p = {}

function p.test_string()
 return 'test, \\test, \\{,test\\\\ \\\\ \\\\\\\\'
end

function p.test_string2()
 return 'test { test {\\{ test, \\test, \\{,test\\ \\ \\ {\\'
end

function p.test_string_module(frame)
 return (p['test_string' .. (frame.args[1] or '')]():gsub('\\', '\\\\'))
end

function p.test_kill500(frame)
 local esc = require('Module:Escape')
 for k = 1, 500 do
  local v = esc:kill(p.test_string2(), 'test')
 end
 return os.clock(esc)
end

return p
