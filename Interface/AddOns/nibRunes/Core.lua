local Opts = nibRunes_Cfg

local nRD = CreateFrame("Frame")
local EventsRegistered

-- Rune Data
local RUNETYPE_BLOOD = 1
local RUNETYPE_UNHOLY = 2
local RUNETYPE_FROST = 3
local RUNETYPE_DEATH = 4

local gcdNextDuration = 1
local gcdEnd = 0

local HR, HS = false, false

-- Combat Fader
local CombatFader = CreateFrame("Frame")
CombatFader.Status = ""

local FadeTime = 0.25

local RuneFull = {
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
	[6] = true,
}

local RunesAreReady = true

---- COMBAT FADER
-- Fade frame
function CombatFader.FadeIt(Frame, NewOpacity)
	local CurrentOpacity = Frame:GetAlpha();
	if NewOpacity > CurrentOpacity then
		UIFrameFadeIn(Frame, FadeTime, CurrentOpacity, NewOpacity);
	elseif NewOpacity < CurrentOpacity then
		UIFrameFadeOut(Frame, FadeTime, CurrentOpacity, NewOpacity);
	end
end

-- Determine new opacity values for frames
function CombatFader.FadeFrames()
	local NewOpacity

	-- Retrieve Element's opacity/visibility for current status
	NewOpacity = 1
	if CombatFader.Status == "INCOMBAT" then
		NewOpacity = Opts.combatfader.opacity.incombat
	elseif CombatFader.Status == "HARMTARGET" then
		NewOpacity = Opts.combatfader.opacity.harmtarget
	elseif CombatFader.Status == "HURT" then
		NewOpacity = Opts.combatfader.opacity.hurt
	elseif CombatFader.Status == "OUTOFCOMBAT" then
		NewOpacity = Opts.combatfader.opacity.outofcombat
	end
	CombatFader.FadeIt(nRD.Frames.Parent, NewOpacity)
end

-- Update current status
function CombatFader.UpdateStatus()
	local OldStatus = CombatFader.Status
	if UnitAffectingCombat("player") then
		CombatFader.Status = "INCOMBAT";				-- InCombat - Priority 1
	elseif UnitExists("target") and UnitCanAttack("player", "target") then
		CombatFader.Status = "HARMTARGET";			-- HarmTarget - Priority 2
	elseif not RunesAreReady then
		CombatFader.Status = "HURT";					-- Not Full - Priority 4
	else
		CombatFader.Status = "OUTOFCOMBAT";			-- OutOfCombat - Priority 5
	end
	if CombatFader.Status ~= OldStatus then CombatFader.FadeFrames() end		
end

function CombatFader.PLAYER_ENTERING_WORLD()
	CombatFader.Status = nil
	CombatFader.UpdateStatus()
	CombatFader.FadeFrames()
end

function CombatFader.UpdateRuneStatus()
	if Opts.combatfader.enabled then
		if ( RuneFull[1] and RuneFull[2] and RuneFull[3] and RuneFull[4] and RuneFull[5] and RuneFull[6] ) then
			RunesAreReady = true
		else
			RunesAreReady = false
		end
		CombatFader.UpdateStatus()
		CombatFader.FadeFrames()
	end
end

function CombatFader.OptionsRefresh()
	CombatFader.Status = nil
	CombatFader.UpdateStatus()
end

function CombatFader.UpdateEnabled()
	if Opts.combatfader.enabled then
		CombatFader:RegisterEvent("PLAYER_ENTERING_WORLD")
		CombatFader:RegisterEvent("PLAYER_TARGET_CHANGED")
		CombatFader:RegisterEvent("PLAYER_REGEN_ENABLED")
		CombatFader:RegisterEvent("PLAYER_REGEN_DISABLED")
		CombatFader:SetScript("OnEvent", CombatFader.UpdateStatus)
		
		CombatFader.Status = nil
		CombatFader.UpdateRuneStatus()
	else
		CombatFader:UnregisterEvent("PLAYER_ENTERING_WORLD")
		CombatFader:UnregisterEvent("PLAYER_TARGET_CHANGED")
		CombatFader:UnregisterEvent("PLAYER_REGEN_ENABLED")
		CombatFader:UnregisterEvent("PLAYER_REGEN_DISABLED")
		
		nRD.Frames.Parent:SetAlpha(1)
	end
end

---- RUNES
-- Events
function nRD.OnUpdate()
	local time = GetTime()
	
	if time > nRD.LastTime + 0.04 then	-- Update 25 times a second
		-- Update Rune Bars
		local RuneBar
		local start, duration, runeReady
		for rune = 1, 6 do
			RuneBar = nRD.Frames.RuneBars[rune]
			start, duration, runeReady = GetRuneCooldown(rune)

			if RuneBar ~= nil then
				if runeReady or UnitIsDead("player") or UnitIsGhost("player") then
					if ( Opts.combatfader.enabled and (not RuneFull[rune]) and (not RunesAreReady) ) then
						RuneFull[rune] = runeReady
						CombatFader.UpdateRuneStatus()
					end
					
					local BGSize = Opts.runes.size.height + Opts.appearance.borderwidth * 2
					if HR then RuneBar.StatusBarBG:SetWidth(BGSize) else RuneBar.StatusBarBG:SetHeight(BGSize) end
					RuneBar.BottomStatusBar:SetValue(1)
					RuneBar.TopStatusBar:SetValue(1)
				else
					if ( Opts.combatfader.enabled and (RuneFull[rune] or RunesAreReady) ) then
						RuneFull[rune] = runeReady
						CombatFader.UpdateRuneStatus()
					end
					
					local BGSize = ((Opts.runes.size.height) * ((time - start) / duration)) + (Opts.appearance.borderwidth * 2)
					if HR then RuneBar.StatusBarBG:SetWidth(BGSize) else RuneBar.StatusBarBG:SetHeight(BGSize) end
					RuneBar.BottomStatusBar:SetValue((time - start) / duration)
					RuneBar.TopStatusBar:SetValue(math.max((time - (start + duration - gcdNextDuration)) / gcdNextDuration, 0.0))
				end
			end
		end

		nRD.LastTime = time
	end
end

function nRD.RuneTextureUpdate(rune)
	RuneBar = nRD.Frames.RuneBars[rune]
	if not RuneBar then return end
	
	local RuneType = GetRuneType(rune)
	if RuneType then
		RuneBar.BottomStatusBar.bg:SetTexture(Opts.runes.colors.bright[RuneType].r * Opts.runes.colors.dimfactor, Opts.runes.colors.bright[RuneType].g * Opts.runes.colors.dimfactor, Opts.runes.colors.bright[RuneType].b * Opts.runes.colors.dimfactor)
		RuneBar.TopStatusBar.bg:SetTexture(Opts.runes.colors.bright[RuneType].r, Opts.runes.colors.bright[RuneType].g, Opts.runes.colors.bright[RuneType].b)
	end
end

function nRD.UpdateRuneTextures()
	for rune = 1, 6 do
		nRD.RuneTextureUpdate(rune)
	end
end

local function Rune_TypeUpdate(event, rune)
	if not rune or tonumber(rune) ~= rune or rune < 1 or rune > 6 then
		return
	end

	-- Update Rune colors
	nRD.RuneTextureUpdate(rune, select(3, GetRuneCooldown(rune)))
end

local function Rune_PlayerEnteringWorld()
	-- Update rune colors
	nRD.UpdateRuneTextures()
end

local function RuneEvents(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		Rune_PlayerEnteringWorld()
	elseif event == "RUNE_TYPE_UPDATE" then
		Rune_TypeUpdate(event, ...)
	end
end

function nRD.SetupEvents()
	if EventsRegistered then return end

	nRD.Frames.Parent:RegisterEvent("RUNE_TYPE_UPDATE")
	nRD.Frames.Parent:RegisterEvent("PLAYER_ENTERING_WORLD")
	nRD.Frames.Parent:SetScript("OnEvent", RuneEvents)
	
	-- Enable OnUpdate handler
	nRD.LastTime = 0
	nRD.Frames.Main:SetScript("OnUpdate", nRD.OnUpdate)
	
	EventsRegistered = true
end

-- Settings Update
function nRD.UpdateSettings()
	local PF = _G[Opts.position.parent] or UIParent
	nRD.Frames.Parent:SetParent(PF)
	nRD.Frames.Parent:SetPoint(Opts.position.anchor, PF, Opts.position.anchor, Opts.position.x, Opts.position.y)
	nRD.Frames.Parent:SetFrameStrata(Opts.framelevel.strata)
	nRD.Frames.Parent:SetFrameLevel(Opts.framelevel.level)
	
	if HR and HS then
		nRD.Frames.Parent:SetWidth(Opts.runes.size.height * 6 + Opts.runes.size.padding * 7)
		nRD.Frames.Parent:SetHeight(Opts.runes.size.width + Opts.runes.size.padding * 2)
	elseif HR and not HS then
		nRD.Frames.Parent:SetWidth(Opts.runes.size.height + Opts.runes.size.padding * 2)
		nRD.Frames.Parent:SetHeight(Opts.runes.size.width * 6 + Opts.runes.size.padding * 7)
	else
		nRD.Frames.Parent:SetHeight(Opts.runes.size.height + Opts.runes.size.padding * 2)
		nRD.Frames.Parent:SetWidth(Opts.runes.size.width * 6 + Opts.runes.size.padding * 7)
	end
	
	nRD.Frames.Main:SetAllPoints(nRD.Frames.Parent)
	nRD.Frames.Main:SetAlpha(Opts.appearance.opacity)
	
	local RuneBar
	for i = 1, 6 do
		local CurRune = Opts.runes.order[i]
		RuneBar = nRD.Frames.RuneBars[i]

		-- Create Rune Bar
		RuneBar.frame:SetFrameStrata(Opts.framelevel.strata)
		RuneBar.frame:SetFrameLevel(Opts.framelevel.level + 1)
		if HR and HS then
			RuneBar.frame:SetWidth(Opts.runes.size.height)
			RuneBar.frame:SetHeight(Opts.runes.size.width)
			RuneBar.frame:SetPoint("TOPLEFT", nRD.Frames.Main, "TOPLEFT", Opts.runes.size.padding + (CurRune - 1) * (Opts.runes.size.height + Opts.runes.size.padding), -Opts.runes.size.padding)
		elseif HR and not HS then
			RuneBar.frame:SetWidth(Opts.runes.size.height)
			RuneBar.frame:SetHeight(Opts.runes.size.width)
			RuneBar.frame:SetPoint("TOPLEFT", nRD.Frames.Main, "TOPLEFT", -Opts.runes.size.padding, Opts.runes.size.padding + (CurRune - 1) * (Opts.runes.size.width + Opts.runes.size.padding))
		else
			RuneBar.frame:SetHeight(Opts.runes.size.height)
			RuneBar.frame:SetWidth(Opts.runes.size.width)
			RuneBar.frame:SetPoint("TOPLEFT", nRD.Frames.Main, "TOPLEFT", Opts.runes.size.padding + (CurRune - 1) * (Opts.runes.size.width + Opts.runes.size.padding), -Opts.runes.size.padding)
		end
		
		-- Status Bar BG (Border)
		if HR then
			RuneBar.StatusBarBG:SetPoint("LEFT", RuneBar.frame, "LEFT", -Opts.appearance.borderwidth, 0)
		else
			RuneBar.StatusBarBG:SetPoint("BOTTOM", RuneBar.frame, "BOTTOM", 0, -Opts.appearance.borderwidth)
		end
		RuneBar.StatusBarBG:SetHeight(RuneBar.frame:GetHeight() + Opts.appearance.borderwidth * 2)
		RuneBar.StatusBarBG:SetWidth(RuneBar.frame:GetWidth() + Opts.appearance.borderwidth * 2)
		RuneBar.StatusBarBG:SetTexture(0, 0, 0, 1)

		-- Bottom Status Bar
		RuneBar.BottomStatusBar:SetFrameStrata(Opts.framelevel.strata)
		RuneBar.BottomStatusBar:SetFrameLevel(RuneBar.frame:GetFrameLevel() + 1)
		RuneBar.BottomStatusBar.bg:SetTexture(Opts.runes.colors.bright[RUNETYPE_BLOOD].r * Opts.runes.colors.dimfactor, Opts.runes.colors.bright[RUNETYPE_BLOOD].g * Opts.runes.colors.dimfactor, Opts.runes.colors.bright[RUNETYPE_BLOOD].b * Opts.runes.colors.dimfactor)

		-- Top Status Bar
		RuneBar.TopStatusBar:SetFrameStrata(Opts.framelevel.strata)
		RuneBar.TopStatusBar:SetFrameLevel(RuneBar.BottomStatusBar:GetFrameLevel() + 1)
		RuneBar.TopStatusBar.bg:SetTexture(Opts.runes.colors.bright[RUNETYPE_BLOOD].r, Opts.runes.colors.bright[RUNETYPE_BLOOD].g, Opts.runes.colors.bright[RUNETYPE_BLOOD].b)
	end
	
	nRD.UpdateRuneTextures()
end

-- Frame Creation
function nRD.CreateFrames()
	if nRD.Frames then return end
	
	nRD.Frames = {}
	
	-- Parent frame
	nRD.Frames.Parent = CreateFrame("Frame", "nibRunes_RuneDisplay", UIParent)
	
	-- Create main frame
	nRD.Frames.Main = CreateFrame("Frame", nil, nRD.Frames.Parent)
	nRD.Frames.Main:SetParent(nRD.Frames.Parent)
	
	-- Rune Bars
	nRD.Frames.RuneBars = {}
	local RuneBar
	local SBO
	if HR then SBO = "HORIZONTAL" else SBO = "VERTICAL" end
	for i = 1, 6 do
		nRD.Frames.RuneBars[i] = {}
		RuneBar = nRD.Frames.RuneBars[i]

		-- Create Rune Bar
		RuneBar.frame = CreateFrame("Frame", nil, nRD.Frames.Main)
		
		-- Status Bar BG (Border)
		RuneBar.StatusBarBG = RuneBar.frame:CreateTexture()

		-- Bottom Status Bar
		RuneBar.BottomStatusBar = CreateFrame("StatusBar", nil, RuneBar.frame)
		RuneBar.BottomStatusBar:SetOrientation(SBO)
		RuneBar.BottomStatusBar:SetMinMaxValues(0, 1)
		RuneBar.BottomStatusBar:SetValue(1)
		RuneBar.BottomStatusBar:SetAllPoints(RuneBar.frame)

		RuneBar.BottomStatusBar.bg = RuneBar.BottomStatusBar:CreateTexture()
		RuneBar.BottomStatusBar.bg:SetAllPoints()
		RuneBar.BottomStatusBar.bg:SetTexture(Opts.runes.colors.bright[RUNETYPE_BLOOD].r * Opts.runes.colors.dimfactor, Opts.runes.colors.bright[RUNETYPE_BLOOD].g * Opts.runes.colors.dimfactor, Opts.runes.colors.bright[RUNETYPE_BLOOD].b * Opts.runes.colors.dimfactor)
		RuneBar.BottomStatusBar:SetStatusBarTexture(RuneBar.BottomStatusBar.bg)

		-- Top Status Bar
		RuneBar.TopStatusBar = CreateFrame("StatusBar", nil, RuneBar.frame)
		RuneBar.TopStatusBar:SetOrientation(SBO)
		RuneBar.TopStatusBar:SetMinMaxValues(0, 1)
		RuneBar.TopStatusBar:SetValue(1)
		RuneBar.TopStatusBar:SetAllPoints(RuneBar.frame)

		RuneBar.TopStatusBar.bg = RuneBar.TopStatusBar:CreateTexture()
		RuneBar.TopStatusBar.bg:SetAllPoints()
		RuneBar.TopStatusBar.bg:SetTexture(Opts.runes.colors.bright[RUNETYPE_BLOOD].r, Opts.runes.colors.bright[RUNETYPE_BLOOD].g, Opts.runes.colors.bright[RUNETYPE_BLOOD].b)
		RuneBar.TopStatusBar:SetStatusBarTexture(RuneBar.TopStatusBar.bg)
	end
end

---- CORE
function nRD.RefreshMod()
	nRD.UpdateSettings()
	CombatFader.UpdateEnabled()
end

----
function nRD.Enable()
	-- Refresh
	nRD.RefreshMod()
	
	-- Setup Events
	nRD.SetupEvents()
	
	-- Disable default rune frame
	if Opts.hideblizzard then
		RuneFrame:UnregisterAllEvents()
		RuneFrame:Hide()
		RuneFrame.Show = function() end
	end
	
	-- Show RuneDisplay
	nRD.Frames.Parent:Show()
end

function nRD.PLAYER_LOGIN()
	if not (select(2, UnitClass("player")) == "DEATHKNIGHT") then return end
	
	if Opts.horizontalrunes then HR = true end
	if Opts.horizontalstacked then HS = true end
	
	nRD.CreateFrames()
	nRD.Enable()
end

local function EventHandler(self, event, ...)
	if event == "PLAYER_LOGIN" then
		nRD.PLAYER_LOGIN()
	end
end
nRD:RegisterEvent("PLAYER_LOGIN")
nRD:RegisterEvent("UNIT_HEALTH")
nRD:SetScript("OnEvent", EventHandler)