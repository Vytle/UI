local nibMicroMenu = LibStub("AceAddon-3.0"):NewAddon("nibMicroMenu", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("nibMicroMenu")
local LSM = LibStub("LibSharedMedia-3.0")

local db
local FramesCreated
local NeedRefreshed

local UClass, UClassColors

local defaults = {
	profile = {
		texts = {
			[1] = "C",
			[2] = "S",
			[3] = "T",
			[4] = "A",
			[5] = "Q",
			[6] = "O",
			[7] = "G",
			[8] = "P",
			[9] = "D",
			[10] = "M",
			[11] = "J",
			[12] = "?",
		},
		font = {
			size = 12,
			name = "Friz Quadrata TT",
		},
		position = {
			anchorto = "TOPRIGHT",
			anchorfrom = "CENTER",
			parent = "UIParent",
			x = -105,
			y = -205,
			orientation = "Horizontal",
			reversed = false,
		},
		framelevel = {
			automatic = true,
			strata = "MEDIUM",
			level = 2,
		},
		microadjustments = {
			x = 0,
			y = 0,
			width = 0,
			height = 0,
			individual = {
				["**"] = {x = 0, y = 0, width = 0},
			},
		},
		tooltip = {
			enabled = true,
		},
		normal = {
			outline = "NONE",
			shadow = {
				useshadow = true,
				color = {r = 0, g = 0, b = 0, a = 1},
				position = {x = 1, y = -1},
			},
			colors = {
				class = {
					enabled = false,
					shade = 0.70,
				},
				r = 0.70,
				g = 0.70,
				b = 0.70,
			},
			opacity = 1,
		},
		highlight = {
			outline = "NONE",
			shadow = {
				useshadow = true,
				color = {r = 0, g = 0, b = 0, a = 1},
				position = {x = 1, y = -1},
			},
			colors = {
				class = {
					enabled = true,
					shade = 1,
				},
				r = 1,
				g = 1,
				b = 1,
			},
			opacity = 1,
		},
		disabled = {
			outline = "NONE",
			shadow = {
				useshadow = true,
				color = {r = 0, g = 0, b = 0, a = 1},
				position = {x = 1, y = -1},
			},
			colors = {
				class = {
					enabled = false,
					shade = .4,
				},
				r = .4,
				g = .4,
				b = .4,
			},
			opacity = 1,
		},
	},
}

local NumButtons = 12

local MMF
local ButtonTable = {
	[1] = "character",
	[2] = "spellbook",
	[3] = "talents",
	[4] = "achievements",
	[5] = "questlog",
	[6] = "social",
	[7] = "guild",
	[8] = "pvp",
	[9] = "dungeonfinder",
	[10] = "companions",
	[11] = "dungeonjournal",
	[12] = "helprequest",
}

local CharID = 1
local SpellBookID = 2
local TalentsID = 3
local AchievementsID = 4
local QuestLogID = 5
local SocialID = 6
local GuildID = 7
local PvPID = 8
local LFDID = 9
local CompanionsID = 10
local DJID = 11
local HelpID = 12

-- Update Disabled/Pushed state of MM Buttons
local function UpdateButtonState()
	if not FramesCreated then return end

	local playerLevel = UnitLevel("player")
	
	-- Character
	if CharacterFrame:IsShown() then
		MMF.Buttons[CharID].windowopen = true
	else
		MMF.Buttons[CharID].windowopen = false
	end
	
	-- SpellBook
	if SpellBookFrame:IsShown() then
		MMF.Buttons[SpellBookID].windowopen = true
	else
		MMF.Buttons[SpellBookID].windowopen = false
	end

	-- Talents
	if ( PlayerTalentFrame and PlayerTalentFrame:IsShown() ) then
		MMF.Buttons[TalentsID].windowopen = true
	else
		if ( playerLevel < SHOW_SPEC_LEVEL ) then
			MMF.Buttons[TalentsID].disabled = true
		else
			MMF.Buttons[TalentsID].disabled = false
			MMF.Buttons[TalentsID].windowopen = false
		end
	end
	
	-- Achievements
	if AchievementFrame and AchievementFrame:IsShown() then
		MMF.Buttons[AchievementsID].windowopen = true
	else
		if (HasCompletedAnyAchievement() or IsInGuild()) and CanShowAchievementUI() then
			MMF.Buttons[AchievementsID].disabled = false
			MMF.Buttons[AchievementsID].windowopen = false			
		else
			MMF.Buttons[AchievementsID].disabled = true
		end
	end

	-- QuestLog
	if QuestLogFrame:IsShown() then
		MMF.Buttons[QuestLogID].windowopen = true
	else
		MMF.Buttons[QuestLogID].windowopen = false
	end
	
	-- Social
	if FriendsFrame:IsShown() then
		MMF.Buttons[SocialID].windowopen = true
	else
		MMF.Buttons[SocialID].windowopen = false
	end
	
	-- Guild
	if IsInGuild() then
		if (GuildFrame and GuildFrame:IsShown()) then
			MMF.Buttons[GuildID].windowopen = true
		else
			MMF.Buttons[GuildID].disabled = false
			MMF.Buttons[GuildID].windowopen = false
		end
	else
		MMF.Buttons[GuildID].disabled = true
	end
	
	-- PvP
	if ( PVPUIFrame and PVPUIFrame:IsShown() ) then -- renamed PVPFrame to PVPUIFrame in Patch 5.2, fixed by Screamlord (Screamie)
		MMF.Buttons[PvPID].windowopen = true
	else
		if playerLevel < PVPMicroButton.minLevel then
			MMF.Buttons[PvPID].disabled = true
		else
			MMF.Buttons[PvPID].disabled = false
			MMF.Buttons[PvPID].windowopen = false
		end
	end	


	-- LFD
	if PVEFrame:IsShown() then -- with the old LFDParentFrame:IsShown(), the LFD/LFG button highlight all the time
		MMF.Buttons[LFDID].windowopen = true
	else
		if playerLevel < LFDMicroButton.minLevel then
			MMF.Buttons[LFDID].disabled = true
		else
			MMF.Buttons[LFDID].disabled = false
			MMF.Buttons[LFDID].windowopen = false
		end
	end
	
	-- CompanionsID
	if ( PetJournalParent and PetJournalParent:IsShown() ) then
		MMF.Buttons[CompanionsID].windowopen = true
	else
		MMF.Buttons[CompanionsID].windowopen = false
	end
	
	
	-- DJ
	if ( EncounterJournal and EncounterJournal:IsShown() ) then
		MMF.Buttons[DJID].windowopen = true
	else
		MMF.Buttons[DJID].windowopen = false
	end

	-- Help Request
	if HelpFrame:IsShown() then
		MMF.Buttons[HelpID].windowopen = true
	else
		MMF.Buttons[HelpID].windowopen = false
	end
	
	-- Update Buttons with new information
	nibMicroMenu:UpdateButtons()
end

-- OnLeave
local function ButtonOnLeave(button)
	if button == CharID then
		MMF.Buttons[CharID].highlight = false
	elseif button == SpellBookID then
		MMF.Buttons[SpellBookID].highlight = false
	elseif button == TalentsID then
		MMF.Buttons[TalentsID].highlight = false
	elseif button == AchievementsID then
		MMF.Buttons[AchievementsID].highlight = false
	elseif button == QuestLogID then
		MMF.Buttons[QuestLogID].highlight = false
	elseif button == SocialID then
		MMF.Buttons[SocialID].highlight = false
	elseif button == GuildID then
		MMF.Buttons[GuildID].highlight = false
	elseif button == PvPID then
		MMF.Buttons[PvPID].highlight = false
	elseif button == LFDID then
		MMF.Buttons[LFDID].highlight = false
	elseif button == CompanionsID then
		MMF.Buttons[CompanionsID].highlight = false
	elseif button == DJID then
		MMF.Buttons[DJID].highlight = false
	elseif button == HelpID then
		MMF.Buttons[HelpID].highlight = false
	end

	if db.tooltip.enabled then
		if GameTooltip:IsShown() then GameTooltip:Hide() end
	end
	
	nibMicroMenu:UpdateButtons()
end

-- OnEnter
local function ButtonOnEnter(button)
	local tt, tto = "", nil
	
	MMF.Buttons[button].highlight = true
	tto = MMF.Buttons[button]
	if button == CharID then
		tt = MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0")
	elseif button == SpellBookID then
		tt = MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK")
	elseif button == TalentsID then
		tt = MicroButtonTooltipText(TALENTS_BUTTON, "TOGGLETALENTS")
	elseif button == AchievementsID then
		tt = MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT")
	elseif button == QuestLogID then
		tt = MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG")
	elseif button == SocialID then
		tt = MicroButtonTooltipText(SOCIAL_BUTTON, "TOGGLESOCIAL")
	elseif button == GuildID then
		tt = MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB")
	elseif button == PvPID then
		tt = MicroButtonTooltipText(PLAYER_V_PLAYER, "TOGGLECHARACTER4")
	elseif button == LFDID then
		tt = MicroButtonTooltipText(DUNGEONS_BUTTON, "TOGGLELFGPARENT")
	elseif button == CompanionsID then
		tt = CompanionsMicroButton.tooltipText
	elseif button == DJID then
		tt = MicroButtonTooltipText(ENCOUNTER_JOURNAL, "TOGGLEENCOUNTERJOURNAL")
	elseif button == HelpID then
		tt = HELP_BUTTON
	end	
	
	if db.tooltip.enabled then
		GameTooltip:SetOwner(tto)
		GameTooltip_AddNewbieTip(tto, tt, 1.0, 1.0, 1.0, "")
		GameTooltip:Show()
	end
	
	nibMicroMenu:UpdateButtons()
end

local function RetrieveFont(font)
	font = LSM:Fetch("font", font)
	if font == nil then font = GameFontNormalSmall:GetFont() end
	return font
end

-- Update Buttons - Font/Colors(Normal, Highlight, Disabled)
local StyleColors = {}
local StyleShadow = {}
local Styles = {normal = 1, highlight = 2, disabled = 3}
function nibMicroMenu:UpdateButtons()
	StyleColors = {
		normal = {r = 0, g = 0, b = 0,},
		highlight = {r = 0, g = 0, b = 0,},
		disabled = {r = 0, g = 0, b = 0,},
	}
	StyleShadow = {
		colors = {
			normal = {r = 0, g = 0, b = 0, a = 1,},
			highlight = {r = 0, g = 0, b = 0, a = 1,},
			disabled = {r = 0, g = 0, b = 0, a = 1,},
		},
		position = {
			normal = {x = 0, y = 0,},
			highlight = {x = 0, y = 0,},
			disabled = {x = 0, y = 0,},
		},
	}
	
	for k,v in pairs(Styles) do
		-- Text Color
		if db[k].colors.class.enabled then
			local shade = db[k].colors.class.shade
			StyleColors[k].r = UClassColors.r * shade
			StyleColors[k].g = UClassColors.g * shade
			StyleColors[k].b = UClassColors.b * shade
		else
			StyleColors[k].r = db[k].colors.r
			StyleColors[k].g = db[k].colors.g
			StyleColors[k].b = db[k].colors.b
		end
		
		-- Shadow Color
		if db[k].shadow.useshadow then
			StyleShadow.colors[k].r, StyleShadow.colors[k].g, StyleShadow.colors[k].b, StyleShadow.colors[k].a = db[k].shadow.color.r, db[k].shadow.color.g, db[k].shadow.color.b, db[k].shadow.color.a 
			StyleShadow.position[k].x, StyleShadow.position[k].y = db[k].shadow.position.x, db[k].shadow.position.y
		else
			StyleShadow.colors[k].r, StyleShadow.colors[k].g, StyleShadow.colors[k].b, StyleShadow.colors[k].a = 0, 0, 0, 0
			StyleShadow.position[k].x, StyleShadow.position[k].y = 0, 0
		end
	end

	local font = RetrieveFont(db.font.name)	
	for i = 1, NumButtons do
		local newstyle, newcolors, newshadowcolors, newshadowposition
		if not MMF.Buttons[i].disabled then
			if MMF.Buttons[i].highlight or MMF.Buttons[i].windowopen then
				-- Highlight
				newstyle = db.highlight
				newcolors = StyleColors.highlight
				newshadowcolors = StyleShadow.colors.highlight
				newshadowposition = StyleShadow.position.highlight
			else
				-- Normal
				newstyle = db.normal
				newcolors = StyleColors.normal
				newshadowcolors = StyleShadow.colors.normal
				newshadowposition = StyleShadow.position.normal
			end
		else	-- Disable
			newstyle = db.disabled
			newcolors = StyleColors.disabled
			newshadowcolors = StyleShadow.colors.disabled
			newshadowposition = StyleShadow.position.disabled
		end
		if MMF.Buttons[i] ~= nil then
			MMF.Buttons[i].text:SetFont(font, db.font.size, newstyle.outline)
			MMF.Buttons[i].text:SetTextColor(newcolors.r, newcolors.g, newcolors.b, newstyle.opacity)
			MMF.Buttons[i].text:SetShadowColor(newshadowcolors.r, newshadowcolors.g, newshadowcolors.b, newshadowcolors.a)
			MMF.Buttons[i].text:SetShadowOffset(newshadowposition.x, newshadowposition.y)
		end
	end
end

-- Lockdown Timer
-- Fired when Exiting / Entering Combat
local LockdownTimer = CreateFrame("Frame")
LockdownTimer.e = 0
LockdownTimer:Hide()
LockdownTimer:SetScript("OnUpdate", function(s, e)
	s.e = s.e + e
	if s.e >= 1 then
		if not InCombatLockdown() then
			if NeedRefreshed then
				nibMicroMenu:Refresh()
			end
			s.e = 0
			s:Hide()
		else
			s.e = 0
		end
	end
end)

function nibMicroMenu:UpdateLockdown(...)
	LockdownTimer:Show()
end

-- Set Size
function nibMicroMenu:UpdateSize()
	if InCombatLockdown() or not FramesCreated then
		nibMicroMenu:Refresh()
		return
	end
	
	local TWidth, THeight
	local IsVert, IsRev
	local Positions = {}
	local ButtonWidth = {}
	local ButtonHeight = {}
		
	if db.position.orientation == "Horizontal" then IsVert = false else IsVert = true end
	IsRev = db.position.reversed
	
	-- Calculate Total height/width and set Button height/width and Text position
	TWidth = 0
	THeight = 0
	for i = 1, NumButtons do
		local NewWidth, NewHeight, NewXOfs, NewYOfs
		NewWidth = MMF.Buttons[i].text:GetWidth() + db.microadjustments.width + db.microadjustments.individual[i].width + 2.75
		NewHeight = MMF.Buttons[i].text:GetHeight() + db.microadjustments.height + 1
		NewXOfs = db.microadjustments.x + db.microadjustments.individual[i].x
		NewYOfs = db.microadjustments.y + db.microadjustments.individual[i].y
		
		ButtonWidth[i] = NewWidth
		TWidth = TWidth + NewWidth
		
		ButtonHeight[i] = NewHeight
		THeight = THeight + NewHeight
		
		MMF.Buttons[i]:SetWidth(NewWidth)
		MMF.Buttons[i]:SetHeight(NewHeight)
		MMF.Buttons[i].text:SetPoint("CENTER", MMF.Buttons[i], "CENTER", NewXOfs, NewYOfs)
	end
	
	-- Get max width and height of buttons
	local MaxButtonWidth, MaxButtonHeight = 0, 0
	for i = 1, NumButtons do
		MaxButtonWidth = max(MaxButtonWidth, ButtonWidth[i])
		MaxButtonHeight = max(MaxButtonHeight, ButtonHeight[i])
	end
	
	-- Get total orientation value, and set height/width
	local TVal
	local CSize = {}
	if IsVert then
		TVal = THeight	
		CSize = ButtonHeight
		
		MMF:SetWidth(MaxButtonWidth)
		MMF:SetHeight(THeight)
	else
		TVal = TWidth
		CSize = ButtonWidth
		
		MMF:SetWidth(TWidth)
		MMF:SetHeight(MaxButtonHeight)		
	end
	
	-- Calculate position of each Button	
	for i = 1, NumButtons do
		local CurPos = 0

		-- Add up position of each Button in sequence
		if i == 1 then
			CurPos = (CSize[i] / 2) - (TVal / 2)
		else
			for j = 1, i-1 do
				CurPos = CurPos + CSize[j]
			end
			CurPos = CurPos + (CSize[i] / 2) - (TVal / 2)
		end					
		
		-- Found Position of Button
		Positions[i] = CurPos
	end
	
	-- Reverse or not
	local RevMult = 1
	if IsRev then RevMult = -1 end
	
	-- Position each Button
	for i = 1, NumButtons do
		if IsVert then
			XPos = 0
			YPos = (Positions[i] * RevMult)
		else
			XPos = (Positions[i] * RevMult)
			YPos = 0
		end
		
		MMF.Buttons[i]:ClearAllPoints()
		MMF.Buttons[i]:SetPoint("CENTER", MMF, "CENTER", XPos, YPos)
	end
end

-- Set Position
function nibMicroMenu:UpdatePosition()
	if InCombatLockdown() or not FramesCreated then
		nibMicroMenu:Refresh()
		return
	end

	local Parent = _G[db.position.parent] or UIParent
	
	MMF:SetParent(Parent)
	MMF:ClearAllPoints()
	MMF:SetPoint(db.position.anchorfrom, Parent, db.position.anchorto, db.position.x, db.position.y)
	
	local FS, FL
	if db.framelevel.automatic then
		FS = Parent:GetFrameStrata()
		FL = Parent:GetFrameLevel() + 1
	else
		FS = db.framelevel.strata
		FL = db.framelevel.level
	end	
	MMF:SetFrameStrata(FS)
	MMF:SetFrameLevel(FL)
	
	MMF:Show()
end

-- Set Texts
function nibMicroMenu:UpdateTexts()
	if InCombatLockdown() or not FramesCreated then
		nibMicroMenu:Refresh()
		return
	end
	
	for i = 1, NumButtons do
		MMF.Buttons[i].text:SetText(db.texts[i])
	end
	nibMicroMenu:UpdateButtons()
	nibMicroMenu:UpdateSize()	
end

-- Update button state by hooking into MicroMenu update function
local function HookMMUpdate()
	hooksecurefunc("UpdateMicroButtons", UpdateButtonState)
end

-- Frame Creation
local function CreateButton(Parent, Name)
	local NewButton

	NewButton = CreateFrame("Button", Name, Parent, "SecureActionButtonTemplate")
	NewButton:SetAttribute("type", "click")
	NewButton.highlight = false
	NewButton.windowopen = false
	NewButton.disabled = false
	
	NewButton.text = NewButton:CreateFontString()
	NewButton.text:SetPoint("CENTER", NewButton, "CENTER")
	
	return NewButton
end

local function CreateFrames()
	if InCombatLockdown() or FramesCreated then return end
	
	-- Parent Frame
	MMF = CreateFrame("Frame", "nibMicroMenu", UIParent)
	-- Create Border
	MMF:CreateBeautyBorder(11)
	MMF:SetBeautyBorderPadding(6)
	MMF:SetBackdrop({
                bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background',
                insets = { left = -5, right = -5, top = -5, bottom = -5 },
            })
    MMF:SetBackdropColor(0, 0, 0, 0.9)
	MMF:Hide()
	MMF.Buttons = {}
	
	-- Buttons
	for i, v in ipairs(ButtonTable) do
		MMF.Buttons[i] = CreateButton(MMF, "nibMicroMenu_"..ButtonTable[i])

		MMF.Buttons[i]:SetScript("OnEnter", function(self) ButtonOnEnter(i) end)
		MMF.Buttons[i]:SetScript("OnLeave", function(self) ButtonOnLeave(i) end)	
	end
		
	-- Set Macro texts
	MMF.Buttons[1]:SetAttribute("type", "macro")
	MMF.Buttons[1]:SetAttribute("macrotext", "/run ToggleCharacter('PaperDollFrame')")
	MMF.Buttons[2]:SetAttribute("clickbutton", SpellbookMicroButton)
	MMF.Buttons[3]:SetAttribute("clickbutton", TalentMicroButton)
	MMF.Buttons[4]:SetAttribute("clickbutton", AchievementMicroButton)
	MMF.Buttons[5]:SetAttribute("clickbutton", QuestLogMicroButton)
	MMF.Buttons[6]:SetAttribute("clickbutton", FriendsMicroButton)
	MMF.Buttons[7]:SetAttribute("clickbutton", GuildMicroButton)
	
	-- fix for the Patch 5.2 PVPMicroButton, call 'TogglePVPUI()' function directly doesn't work correct (right panel is blank)
	MMF.Buttons[8]:SetScript("OnClick", function(self)
		if PVPUIFrame then
			if ( UnitLevel("player") >= SHOW_PVP_LEVEL and not IsPlayerNeutral()) then
				if PVPUIFrame:IsShown() then
					HideUIPanel(PVPUIFrame)
				else
					ShowUIPanel(PVPUIFrame)
				end
			end
		else
			LoadAddOn("Blizzard_PVPUI")
			ShowUIPanel(PVPUIFrame)
		end
	end)
		
	-- MMF.Buttons[8]:SetAttribute("type", "macro")
	-- MMF.Buttons[8]:SetAttribute("macrotext", "/run TogglePVPUI()") -- TogglePVPUI() is new in Patch 5.2 (TogglePVPFrame() was removed) fixed by Screamlord (Screamie)
	MMF.Buttons[9]:SetAttribute("clickbutton", LFDMicroButton)
	MMF.Buttons[10]:SetAttribute("clickbutton", CompanionsMicroButton)
	MMF.Buttons[11]:SetAttribute("clickbutton", EJMicroButton)
	MMF.Buttons[12]:SetAttribute("clickbutton", HelpMicroButton)
	FramesCreated = true
end

----
function nibMicroMenu:ProfChange()
	db = self.db.profile
	nibMicroMenu:ConfigRefresh()
	nibMicroMenu:Refresh()
end

function nibMicroMenu:Refresh(...)
	-- Create Frames if it has been delayed
	if not InCombatLockdown() and not FramesCreated then
		CreateFrames()
	end
	
	-- Refresh Mod
	if InCombatLockdown() or not FramesCreated then
		-- In combat or have no frames, set flag so we can refresh once combat ends
		NeedRefreshed = true
	else
		-- Ready to refresh
		NeedRefreshed = false
		
		UpdateButtonState()
		nibMicroMenu:UpdatePosition()
		nibMicroMenu:UpdateTexts()
	end
end

function nibMicroMenu:EventCheck()
	UpdateButtonState()
end

function nibMicroMenu:PLAYER_ENTERING_WORLD()
	nibMicroMenu:Refresh()
end

local function ClassColorsUpdate()
	UClassColors = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[UClass] or RAID_CLASS_COLORS[UClass]
	nibMicroMenu:UpdateButtons()
end

function nibMicroMenu:PLAYER_LOGIN()
	UClass = select(2, UnitClass("player"))
	UClassColors = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[UClass] or RAID_CLASS_COLORS[UClass]
	
	HookMMUpdate()
	
	if CUSTOM_CLASS_COLORS then
		CUSTOM_CLASS_COLORS:RegisterCallback(ClassColorsUpdate)
	end
end

function nibMicroMenu:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("nibMicroMenuDB", defaults, "Default")
		
	self.db.RegisterCallback(self, "OnProfileChanged", "ProfChange")
	self.db.RegisterCallback(self, "OnProfileCopied", "ProfChange")
	self.db.RegisterCallback(self, "OnProfileReset", "ProfChange")
	
	nibMicroMenu:SetUpInitialOptions()
	
	db = self.db.profile
	
	-- self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEVEL_UP", "EventCheck")
	self:RegisterEvent("UNIT_LEVEL", "EventCheck")
	self:RegisterEvent("RECEIVED_ACHIEVEMENT_LIST", "EventCheck")
	self:RegisterEvent("ACHIEVEMENT_EARNED", "EventCheck")
	self:RegisterEvent("PLAYER_TALENT_UPDATE", "EventCheck")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateLockdown")
	
	-- PVP_LoadUI()
	-- if not IsAddOnLoaded("Blizzard_PVPUI") then LoadAddOn("Blizzard_PVPUI") end -- added by Screamlord (Screamie) for Patch 5.2
	
end
