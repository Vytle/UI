local _, ns = ...
local oGlow = ns.oGlow

local argcheck = oGlow.argcheck

local colorTable = setmetatable(
	{},

	{__index = function(self, val)
		argcheck(val, 2, 'number')
		local r, g, b = GetItemQualityColor(val)
		rawset(self, val, {r, g, b})

		return self[val]
	end}
)

function oGlow:RegisterColor(name, r, g, b)
	argcheck(name, 2, 'string', 'number')
	argcheck(r, 3, 'number')
	argcheck(g, 4, 'number')
	argcheck(b, 5, 'number')

	local color = rawget(colorTable, name)
	if(color) then
		color[1], color[2], color[3] = r, g, b
	else
		color = {r, g, b}
		rawset(colorTable, name, color)
	end

	oGlowDB.Colors[name] = color

	return true
end

function oGlow:ResetColor(name)
	argcheck(name, 2, 'string', 'number')

	oGlowDB.Colors[name] = nil
	colorTable[name] = nil

	return unpack(colorTable[name])
end

ns.colorTable = colorTable