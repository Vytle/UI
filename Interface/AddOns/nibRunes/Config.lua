nibRunes_Cfg = {

-- Hide Blizzard's Rune Display
hideblizzard = true,

-- Position Settings
position = {
	x = 0,					-- Horizontal offset
	y = -132,				-- Vertical offset
	anchor = "CENTER",		-- Position on screen. CENTER, RIGHT, LEFT, BOTTOM, BOTTOMRIGHT, BOTTOMLEFT, TOP, TOPRIGHT, TOPLEFT
	parent = "UIParent",	-- Parent Frame
},

-- Horizontal display
horizontalrunes = false,
horizontalstacked = false,	-- If HorizontalRunes and HorizontalStacked is true, then Runes will be horizontal and stack together in a horizontal line.

-- Frame Level
framelevel = {
	strata = "LOW",			-- BACKGROUND, LOW, MEDIUM, HIGH
	level = 2,				-- 0 to 100
},


-- Appearance
appearance = {
	opacity = 0.7,			-- Transparency (0 to 1)
	borderwidth = 1,		-- Width of the Rune borders
},


-- Runes
runes = {

	-- Size
	size = {
		height = 38,		-- Height of the Rune bars
		width = 10,			-- Width of the Rune bars
		padding = 3,		-- Gap between the Rune bars
	},
	
	-- Order
	-- [Bar Number] = Rune
	-- Ex: [1] = 1 means [Bar1] = Blood 1
	-- 1,2 = Blood   3,4 = Unholy   5,6 = Frost
	order = {		
		[1] = 1,
		[2] = 2,
		[3] = 3,
		[4] = 4,
		[5] = 5,
		[6] = 6,
	},
	
	-- Colors
	colors = {
		-- Standard Rune colors
		bright = {
			[1] = {r = 0.9, g = 0.15, b = 0.15},	-- Blood
			[2] = {r = 0.40, g = 0.9, b = 0.30},	-- Unholy
			[3] = {r = 0, g = 0.7, b = 0.9},		-- Frost
			[4] = {r = 0.50, g = 0.27, b = 0.68},	-- Death
		},
		-- How much darker should the Runes be when in cooldown (0 to 1: 1 being the same color as normal, 0 being black)
		dimfactor = 0.7,
	},
},


-- Combat Fader
combatfader = {
	enabled = true,			-- Enable the Combat Fader
	opacity = {
		incombat = 1,		-- Opacity In-Combat
		harmtarget = 0.8,	-- Opacity with an Enemy target selected
		hurt = 0.5,			-- Opacity when Runes are still changing / cooling down
		outofcombat = 0,	-- Opacity Out-of-combat
	},
},
	
}