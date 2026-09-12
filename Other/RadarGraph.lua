local a = require('Module:ACandy').a
local getArgs = require('Module:Arguments').getArgs

local p = {}

local function deg2rad(d) return d * math.pi / 180 end

local function makeRings(max)
	local step = 50 / max
	local parts = {}
	for i = 1, max do
		local pct = i * step
		local style = "radial-gradient(circle at center, rgba(127,127,127,0.1) %.2f%%, rgba(0,0,0,0) %.2f%%)"
		table.insert(parts, string.format(style, pct-0.3, pct+0.3))
	end
	return table.concat(parts, ",")
end

function p.main(frame)
	local args = getArgs(frame, {removeBlanks = true})
	local maxValue = tonumber(args.max) or 5
	local width = args.width or "500px"

	local names, values = {}, {}
	for _, arg in ipairs(args) do
		local i, _ = string.find(arg, "::");
		local key, value;
		if i then
		    key = string.sub(arg, 1, i - 1);
		    value = string.sub(arg, i + 2);
			local num = tonumber(value)
			if num then
				table.insert(names, key)
				table.insert(values, num)
			end
		end
	end

	local n = #names
	if n < 3 then
		return 'Error: Need at least 3 axes.'
	end

	local maxR, center = 35, 50 -- percentages
	local points, markers, labels, spokes = {}, {}, {}, {}

	for i=1,n do
		-- Ensure there is always one angled to point to the top
		local angle = - 90 - (i-1) * (360/n)
		local r = (values[i] / maxValue) * maxR
		local x = center + r * math.cos(deg2rad(angle))
		local y = center + r * math.sin(deg2rad(angle))
		table.insert(points, string.format('%.3f%% %.3f%%', x, y))

		-- marker
		table.insert(markers, a.div {
			style = string.format(
				'position:absolute;left:%.3f%%;top:%.3f%%;' ..
				'width:2%%;height:2%%;margin:-1%% 0 0 -1%%;' ..
				'border-radius:50%%;background:#377dff;border:0.6%% solid #fff',
				x, y
			)
		})

		-- label (slightly beyond maxR)
		-- X-axis needs to be further away since text spans horizontally
		local lx = center + maxR * 1.3 * math.cos(deg2rad(angle))
		local ly = center + maxR * 1.2 * math.sin(deg2rad(angle))
		table.insert(labels, a.div {
			style = string.format(
				'position:absolute;left:%.3f%%;top:%.3f%%;' ..
				'transform:translate(-50%%,-50%%);' ..
				'font-size: larger',
				lx, ly
			),
			names[i]
		})

		-- spoke
		table.insert(spokes, a.div {
			style = string.format(
				'position:absolute;left:50%%;top:50%%;' ..
				'width:0.6%%;height:%d%%;background:#cfcfcf;' ..
				'transform-origin:50%% 0%%;transform:translateX(-50%%) rotate(%.1fdeg);',
				maxR, - angle + 90
			)
		})
	end

	-- polygon fill
	local poly = a.div {
		style = string.format(
			'position:absolute;left:0;top:0;width:100%%;height:100%%;' ..
			'clip-path:polygon(%s);' ..
			'background:linear-gradient(135deg,rgba(55,125,255,0.28),rgba(55,125,255,0.18));' ..
			'border:0.6%% solid rgba(55,125,255,0.5);border-radius:2%%;',
			table.concat(points, ',')
		)
	}
	
	local rings = makeRings(maxValue);

	return a.div {
		style = string.format(
			'width:%s;max-width:100%%;position:relative;' ..
			'aspect-ratio : 1 / 1;' ..
			'background: %s; ' ..
			'border-radius:2%%;box-shadow:0 0.3%% 0.6%% rgba(0,0,0,0.06);',
			width, rings
		),
		-- center dot
		a.div { style = 'position:absolute;left:50%;top:50%;width:1.8%;height:1.8%;margin:-0.9% 0 0 -0.9%;border-radius:50%;background:#666;opacity:0.8' },
		-- spokes, labels, polygon, markers
		spokes,
		labels,
		poly,
		markers
	};
end

return p
