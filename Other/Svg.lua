require[[strict]]


local iface = {}


iface.create = function (frame)
	local opts = frame.args
	local src
	local target
	if opts.content ~= nil then src = opts.content:match'^%s*(.*%S)' end
	if opts.link ~= nil then target = opts.link:match'^%s*(.*%S)' end
	if src == nil then return '' end
	local img = mw.svg.new()
	for key, val in pairs(opts) do
		if key ~= 'content' and key ~= 'link' and type(key) == 'string' then
			if key:sub(1, 1) == '#' then
				img:setAttribute(key:sub(2), val)
			elseif val ~= '' then img:setImgAttribute(key, val) end
		end
	end
	if target == nil then return img:setContent(src):toImage() end
	return '[[:' .. target .. '|' .. img:setContent(src):toImage() .. ']]'
end


iface.create_from_caller = function (frame)
	return iface.create(frame:getParent())
end


return iface