-- This module generates documentation for [[Module:Protection banner]].

--------------------------------------------------------------------------------
-- Documentation class
--------------------------------------------------------------------------------

local Documentation = {}
Documentation.__index = Documentation

function Documentation:new(mainCfg, docCfg)
	return setmetatable({
		_mainCfg = mainCfg,
		_docCfg = docCfg
	}, self)
end

function Documentation:makeReasonTable()
	-- Get the data from the cfg.banners table.
	local rowData = {}
	for action, reasonTables in pairs(self._mainCfg.banners) do
		for reason, t in pairs(reasonTables) do
			rowData[#rowData + 1] = {
				reason = reason,
				action = action,
				description = t.description
			}
		end
	end

	-- Sort the table into alphabetical order, first by action and then by
	-- reason.
	table.sort(rowData, function (t1, t2)
		if t1.action == t2.action then
			return t1.reason < t2.reason
		else
			return t1.action < t2.action
		end
	end)
	
	-- Assemble a wikitable of the data.
	local ret = {}
	ret[#ret + 1] = '{| class="wikitable"'
	if #rowData < 1 then
		ret[#ret + 1] = '|-'
		ret[#ret + 1] = string.format(
			'| colspan="3" | %s',
			self._docCfg['documentation-blurb-noreasons']
		)
	else
		-- Header
		ret[#ret + 1] = '|-'
		ret[#ret + 1] = string.format(
			'! %s\n! %s\n! %s',
			self._docCfg['documentation-heading-reason'],
			self._docCfg['documentation-heading-action'],
			self._docCfg['documentation-heading-description']
		)
		-- Rows
		for _, t in ipairs(rowData) do
			ret[#ret + 1] = '|-'
			ret[#ret + 1] = string.format(
				'| %s\n| %s\n| %s',
				t.reason,
				t.action,
				t.description or ''
			)
		end
	end
	ret[#ret + 1] = '|}'
	
	return table.concat(ret, '\n')
end

--------------------------------------------------------------------------------
-- Exports
--------------------------------------------------------------------------------

local p = {}

function p.reasonTable()
	local mainCfg = require('Mô đun:Protection banner/config')
	local docCfg = require('Mô đun:Protection banner/documentation/config')
	local documentationObj = Documentation:new(mainCfg, docCfg)
	return documentationObj:makeReasonTable()
end

return p
