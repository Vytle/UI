local _, ns = ...
local oGlow = ns.oGlow
local argcheck = oGlow.argcheck
local displaysTable = {}


function oGlow:RegisterDisplay(name, display)
	argcheck(name, 2, 'string')
	argcheck(display, 3, 'function')

	displaysTable[name] = display
end

ns.displaysTable = displaysTable