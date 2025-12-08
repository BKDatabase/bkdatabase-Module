require ('strict')

local p = {}

-- determine whether we're being called from a sandbox
local isSandbox = mw.getCurrentFrame():getTitle():find('sandbox', 1, true)
local sandbox = isSandbox and '/sandbox' or ''

local cfg = mw.loadData ('Module:Citation/CS1/Configuration' .. sandbox)

-- if cs1 config is set, return false, otherwise use supplied mode
-- this prevents putting articles into "overriden mode" tracking category
function p._main(mode)
	return not cfg.global_cs1_config_t['Mode'] and mode
end

function p.main(frame)
    return p._main(frame.args[1]) or ""
end

return p
