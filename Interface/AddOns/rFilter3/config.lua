-- // rFilter3
-- // zork - 2012 <3
-- // v1nk - 2013

-- // Aura Posistions (Pitbull4_Frames_player)
-- // 1 x -266
-- // 2 x -223.6
-- // 3 x -181.2
-- // 4 x -138.8
-- // 5 x -96.4
-- // 6 x -54
-- // Focus
-- // 7 = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -100, y = 138 },
-- // Pet
-- // 8 

--get the addon namespace
local addon, ns = ...
local cfg = CreateFrame("Frame")
ns.cfg = cfg

cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}

local _, player_class = UnitClass("player")

cfg.highlightPlayerSpells 	= false  --player spells will have a blue border
cfg.updatetime           	= 0.3   --how fast should the timer update itself
cfg.timeFontSize          	= 14
cfg.countFontSize         	= 18
cfg.buffFontSize			= 14

-- Death Knight defaults
if player_class == "DEATHKNIGHT" then
--default deathknight buffs
cfg.rf3_BuffList = {
  -- Blood Presence
  [1] = {
	spellid = 48263,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Frost Presence 
  [2] = {
	spellid = 48266,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Unholy Presence
  [3] = {
	spellid = 48265,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Freezing Fog
  [4] = {
	spellid = 59052,
	spec = 2,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Killing Machine
  [5] = {
	spellid = 51128,
	spec = 2,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Horn of Winter
  [6] = {
	spellid = 57330,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Shadow Infusion
	[7] = {
	spellid = 91342,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Sudden Doom
	[8] = {
	spellid = 49530,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default Deathknight debuffs
cfg.rf3_DebuffList = {}
end

-- Druid defaults
if player_class == "DRUID" then
--default druid buffs
cfg.rf3_BuffList = {
  -- Cat form
  [1] = {
	spellid = 768,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Aquatic Form
  [2] = {
	spellid = 1066,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Travel Form
  [3] = {
	spellid = 783,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Bear Form
  [4] = {
	spellid = 5487,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Flight Form
  [5] = {
	spellid = 40120,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Moonkin Form
  [6] = {
	spellid = 24858,
	spec = 1,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Treant Form
  [7] = {
	spellid = 125047,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Shooting stars
  [8] = {
	spellid = 93400,
	spec = 1,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Clearcasting
  [9] = {
	spellid = 16870,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Harmony
  [10] = {
	spellid = 100977,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Lifebloom (Focus)
  [11] = {
	spellid = 33763,
	size = 26,
	-- aura 7
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -100, y = 138 },
	unit = "focus",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Savage Defense
  [12] = {
	spellid = 132402,
	spec = 3,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default Druid debuffs
cfg.rf3_DebuffList = {
  -- Moonfire
  [1] = {
	spellid = 8921,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Sunfire
  [2] = {
	spellid = 93402,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Thrash
  [3] = {
	spellid = 106830,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Lacerate
  [4] = {
	spellid = 33745,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end  

-- Hunter defaults
if player_class == "HUNTER" then
--default hunter buffs
cfg.rf3_BuffList = {
-----------------------------
-- ASPECTS
-----------------------------
-- Aspect of the Hawk
	[1] = {
	spellid = 13165,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
	},
-- Aspect of the Cheetah
	[2] = {
	spellid = 5118,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
	},
-- Aspect of the Iron Hawk
	[3] = {
	spellid = 109260,
	-- aura 1
	size = 26,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
	},
-- Aspect of the Pack
	[4] = {
	spellid = 13159,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
	},
-----------------------------
-- BUFFS
-----------------------------
  -- Thrill of the Hunt
  [5] = {
	spellid = 109306,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Trap Launcher
  [6] = {
	spellid = 77769,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Frenzy (BM)
  [7] = {
	spellid = 19615,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "pet",
	validate_unit   = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Focus Fire
  [8] = {
	spellid = 82692,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Mend Pet
  [8] = {
	spellid = 136,
	size = 26,
	-- aura 9
	pos = { a1 = "LEFT", a2 = "LEFT", af = "UIParent", x = 544, y = -314 },
	unit = "pet",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-----------------------------
-- DEBUFFS
-----------------------------
cfg.rf3_DebuffList = {
  -- Serpent String
  [1] = {
	spellid = 1978,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Black Arrow
  [2] = {
	spellid = 3674,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Explosive Shot
  [3] = {
	spellid = 53301,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end

-- Mage defaults
if player_class == "MAGE" then
--default mage buffs
cfg.rf3_BuffList = {
-- Mage Armor
	[1] = {
	spellid = 6117,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Molten Armor
	[2] = {
	spellid = 30482,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Frost Armor
	[3] = {
	spellid = 7302,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Fingers of Frost
	[4] = {
	spellid = 112965,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Brain Freeze
	[5] = {
	spellid = 44549,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Invoker's Energy
	[6] = {
	spellid = 116257,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Heating Up
	[7] = {
	spellid = 48107,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Pyroblast!
	[8] = {
	spellid = 48108,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Arcane Missiles!
	[9] = {
	spellid = 79683,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default mage debuffs
cfg.rf3_DebuffList = {
-- Nether Tempest
	[1] = {
	spellid = 114923,
	size = 26,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Living Bomb
	[2] = {
	spellid = 44457,
	size = 26,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Frost Bomb
	[3] = {
	spellid = 112948,
	size = 26,
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Arcane Charge
	[4] = {
	spellid = 36032,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end  

-- Monk defaults
if player_class == "MONK" then
--default monk buffs
cfg.rf3_BuffList = {
-- Combo Breaker: Blackout Kick
	[1] = {
	spellid = 116768,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	match_spellid   = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
	},
  -- Tiger Eye Brew
  [2] = {
	spellid = 125195,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Combo Breaker: Tiger Palm
  [3] = {
	spellid = 118864,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default monk debuffs
cfg.rf3_DebuffList = {}
end

-- Paladin defaults
if player_class == "PALADIN" then
--default paladin buffs
cfg.rf3_BuffList = {
  -- Infusion of Light (Holy)
  [1] = {
	spellid = 54149,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Inquisition
  [2] = {
	spellid = 84963,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Alacrity (Darkmist Vortex)
  [3] = {
	spellid = 126657,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -100, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Unwavering Might (Lei Shen's Final Orders)
  [4] = {
	spellid = 126582,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -50, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default paladin debuffs
cfg.rf3_DebuffList = {}
end


-- Priest defaults
if player_class == "PRIEST" then
--default priest buffs
cfg.rf3_BuffList = {
  -- Inner Focus
  [1] = {
	spellid = 588,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Inner Will
  [2] = {
	spellid = 73413,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Surge of Darkness
  [3] = {
	spellid = 87160,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Divine Insight
  [4] = {
	spellid = 124430,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default priest debuffs
cfg.rf3_DebuffList = {
  -- Shadow Word: Pain
  [1] = {
	spellid = 589,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Vampiric Touch
  [2] = {
	spellid = 34914,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Devouring Plague
  [3] = {
	spellid = 2944,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end

-- Rogue defaults
if player_class == "ROGUE" then
--default rogue buffs
cfg.rf3_BuffList = {
  -- Recuperate
  [1] = {
	spellid = 73651,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Slice and Dice
  [2] = {
	spellid = 5171,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Anticipation (Talent)
  [3] = {
	spellid = 115819,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Blindside (Proc)
  [4] = {
	spellid = 121152,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default rogue debuffs
cfg.rf3_DebuffList = {
  -- Rupture
  [1] = {
	spellid = 1943,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Hemorrhage (Subtlety)
  [2] = {
	spellid = 16511,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Find Weakness (Subtlety)
  [3] = {
	spellid = 91023,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end

-- Shaman defaults
if player_class == "SHAMAN" then
--default shaman buffs
cfg.rf3_BuffList = {
  -- Water Shield
  [1] = {
	spellid = 52127,
	spec = 3,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Lightning Shield 
  [2] = {
	spellid = 324,
	spec = 1,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Lava Surge 77756
  [3] = {
	spellid = 77756,
	spec = 1,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Elemental Focus
  [4] = {
	spellid = 16246,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Tidal Waves
  [5] = {
	spellid = 53390,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Earth Shield (Focus)
  [6] = {
	spellid = 974,
	size = 26,
	-- aura 7
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -100, y = 138 },
	unit = "focus",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default shaman debuffs
cfg.rf3_DebuffList = {
  --Flame Shock
  [1] = {
	spellid = 8050,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end

-- Warlock defaults
if player_class == "WARLOCK" then
--default warlock buffs
cfg.rf3_BuffList = {
-- Fel Armor
	[1] = {
	spellid = 104938,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	match_spellid   = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Destruction  
  -- Rain of Fire
  [2] = {
	spellid = 104232,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Backdraft
  [3] = {
	spellid = 117828,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Fire and Brimstone
  [4] = {
	spellid = 108683,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Shadow Trance
  [5] = {
	spellid = 17941,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Blessing of the Celestials (Relic of Yu'lon)
  [6] = {
	spellid = 128985,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -100, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Inner Brilliance (Light of the Cosmos)
  [7] = {
	spellid = 126577,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -50, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Mastermind 139133 (Cha-Ye's Essence of Brilliance)
  [8] = {
	spellid = 139133,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -50, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Acceleration (Volatile Talisman of the Shado-Pan Assault)
  [9] = {
	spellid = 138703,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -50, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
   -- Molten Core
  [10] = {
	spellid = 122351,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
   -- Sacrificial Pact
  [11] = {
	spellid = 108416,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 50, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
   -- Dark Bargain
  [12] = {
	spellid = 110913,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = 100, y = 0 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default warlock debuffs
cfg.rf3_DebuffList = {
  --Immolate
  [1] = {
	spellid = 348,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
-- Affliction
  -- Seed of Corruption
  [2] = {
	spellid = 27243,
	size = 26,
	-- aura 2
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -223.6, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Agony
  [3] = {
	spellid = 980,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Corruption
  [4] = {
	spellid = 172,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Unstable Affliction
  [5] = {
	spellid = 30108,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Haunt
  [6] = {
	spellid = 48181,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -182.2, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Curse of the Elements
  [7] = {
	spellid = 1490,
	size = 26,
	-- aura 1
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -266, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = false,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
   -- Metamorphosis: Doom
  [8] = {
	spellid = 603,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
   -- Hand of Gul'dan
  [9] = {
	spellid = 47960,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "target",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
end

-- Warrior defaults
if player_class == "WARRIOR" then
--default warrior buffs
cfg.rf3_BuffList = {
-- Battle Shout
 [1] = {
	spellid = 6673,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	match_spellid   = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Commanding Shout 
  [2] = {
	spellid = 469,
	size = 26,
	-- aura 6
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -54, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Sweeping Strikes
  [3] = {
	spellid = 12328,
	size = 26,
	-- aura 3
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -181.2, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = true,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Taste for Blood
  [4] = {
	spellid = 56636,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Bloodsurge (Fury)
  [5] = {
	spellid = 46915,
	size = 26,
	-- aura 4
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -138.8, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
  -- Raging Blow (Fury)
  [6] = {
	spellid = 13116,
	size = 26,
	-- aura 5
	pos = { a1 = "CENTER", a2 = "CENTER", af = "UIParent", x = -96.4, y = -264 },
	unit = "player",
	validate_unit   = true,
	ismine          = true,
	desaturate      = false,
	move_ingame     = true,
	hide_ooc        = false,
	alpha = {
	  found = {
		frame = 1,
		icon = 1,
	  },
	  not_found = {
		frame = 0,
		icon = 0,
	  },
	},
  },
}
-- default warrior debuffs
cfg.rf3_DebuffList = {}
end
