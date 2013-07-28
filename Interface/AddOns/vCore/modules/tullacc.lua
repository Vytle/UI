--[[
	Curation settings for tullaCC
--]]

local AddonName, Addon = ...
local C = {}; Addon.Config = C

--font settings
C.fontFace = STANDARD_TEXT_FONT  --what font to use
C.fontSize = 18  --the base font size to use at a scale of 1

--display settings
C.minScale = 0.6 --the minimum scale we want to show cooldown counts at, anything below this will be hidden
C.minDuration = 3 --the minimum number of seconds a cooldown's duration must be to display text
C.expiringDuration = 5  --the minimum number of seconds a cooldown must be to display in the expiring format

--text format strings
C.expiringFormat = '|cffff0000%d|r' --format for timers that are soon to expire
C.secondsFormat = '|cffffff00%d|r' --format for timers that have seconds remaining
C.minutesFormat = '|cffffffff%dm|r' --format for timers that have minutes remaining
C.hoursFormat = '|cff66ffff%dh|r' --format for timers that have hours remaining
C.daysFormat = '|cff6666ff%dh|r' --format for timers that have days remaining

--[[
	tullaCooldownCount
		A basic cooldown count addon

		The purpose of this addon is mainly for me to test performance optimizations
		and also for people who don't care about the extra features of OmniCC
--]]

local AddonName, Addon = ...
local Timer = {}; Addon.Timer = Timer


--local bindings!
local C = Addon.Config --pull in the addon table
local UIParent = _G['UIParent']
local GetTime = _G['GetTime']
local floor = math.floor
local min = math.min
local round = function(x) return floor(x + 0.5) end

--sexy constants!
local ICON_SIZE = 36 --the normal size for an icon (don't change this)
local DAY, HOUR, MINUTE = 86400, 3600, 60 --used for formatting text
local DAYISH, HOURISH, MINUTEISH = 3600 * 23.5, 60 * 59.5, 59.5 --used for formatting text at transition points
local HALFDAYISH, HALFHOURISH, HALFMINUTEISH = DAY/2 + 0.5, HOUR/2 + 0.5, MINUTE/2 + 0.5 --used for calculating next update times

--configuration settings
local FONT_FACE = C.fontFace --what font to use
local FONT_SIZE = C.fontSize --the base font size to use at a scale of 1
local MIN_SCALE = C.minScale--the minimum scale we want to show cooldown counts at, anything below this will be hidden
local MIN_DURATION = C.minDuration --the minimum duration to show cooldown text for
local EXPIRING_DURATION = C.expiringDuration --the minimum number of seconds a cooldown must be to use to display in the expiring format
local EXPIRING_FORMAT = C.expiringFormat --format for timers that are soon to expire
local SECONDS_FORMAT = C.secondsFormat --format for timers that have seconds remaining
local MINUTES_FORMAT = C.minutesFormat --format for timers that have minutes remaining
local HOURS_FORMAT = C.hoursFormat --format for timers that have hours remaining
local DAYS_FORMAT = C.daysFormat --format for timers that have days remaining

--returns both what text to display, and how long until the next update
local function getTimeText(s)
	--format text as seconds when at 90 seconds or below
	if s < MINUTEISH then
		local seconds = round(s)
		local formatString = seconds > EXPIRING_DURATION and SECONDS_FORMAT or EXPIRING_FORMAT
		return formatString, seconds, s - (seconds - 0.51)
	--format text as minutes when below an hour
	elseif s < HOURISH then
		local minutes = round(s/MINUTE)
		return MINUTES_FORMAT, minutes, minutes > 1 and (s - (minutes*MINUTE - HALFMINUTEISH)) or (s - MINUTEISH)
	--format text as hours when below a day
	elseif s < DAYISH then
		local hours = round(s/HOUR)
		return HOURS_FORMAT, hours, hours > 1 and (s - (hours*HOUR - HALFHOURISH)) or (s - HOURISH)
	--format text as days
	else
		local days = round(s/DAY)
		return DAYS_FORMAT, days,  days > 1 and (s - (days*DAY - HALFDAYISH)) or (s - DAYISH)
	end
end

function Timer.SetNextUpdate(self, nextUpdate)
	self.updater:GetAnimations():SetDuration(nextUpdate)
	if self.updater:IsPlaying() then
		self.updater:Stop()
	end
	self.updater:Play()
end

--stops the timer
function Timer.Stop(self)
	self.enabled = nil
	if self.updater:IsPlaying() then
		self.updater:Stop()
	end
	self:Hide()
end

function Timer.UpdateText(self)
	local remain = self.duration - (GetTime() - self.start)
	if round(remain) > 0 then
		if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < MIN_SCALE then
			self.text:SetText('')
			Timer.SetNextUpdate(self, 1)
		else
			local formatStr, time, nextUpdate = getTimeText(remain)
			self.text:SetFormattedText(formatStr, time)
			Timer.SetNextUpdate(self, nextUpdate)
		end
	else
		Timer.Stop(self)
	end
end

--forces the given timer to update on the next frame
function Timer.ForceUpdate(self)
	Timer.UpdateText(self)
	self:Show()
end

--adjust font size whenever the timer's parent size changes
--hide if it gets too tiny
function Timer.OnSizeChanged(self, width, height)
	local fontScale = round(width) / ICON_SIZE
	if fontScale == self.fontScale then
		return
	end

	self.fontScale = fontScale
	if fontScale < MIN_SCALE then
		self:Hide()
	else
		self.text:SetFont(FONT_FACE, fontScale * FONT_SIZE, 'OUTLINE')
		self.text:SetShadowColor(0, 0, 0, 0.8)
		self.text:SetShadowOffset(1, -1)
		if self.enabled then
			Timer.ForceUpdate(self)
		end
	end
end

--returns a new timer object
function Timer.Create(cd)
	--a frame to watch for OnSizeChanged events
	--needed since OnSizeChanged has funny triggering if the frame with the handler is not shown
	local scaler = CreateFrame('Frame', nil, cd)
	scaler:SetAllPoints(cd)

	local timer = CreateFrame('Frame', nil, scaler); timer:Hide()
	timer:SetAllPoints(scaler)
	
	local updater = timer:CreateAnimationGroup()
	updater:SetLooping('NONE')
	updater:SetScript('OnFinished', function(self) Timer.UpdateText(timer) end)
	
	local a = updater:CreateAnimation('Animation'); a:SetOrder(1)
	timer.updater = updater	

	local text = timer:CreateFontString(nil, 'OVERLAY')
	text:SetPoint('CENTER', 0, 0)
	text:SetFont(FONT_FACE, FONT_SIZE, 'OUTLINE')
	timer.text = text

	Timer.OnSizeChanged(timer, scaler:GetSize())
	scaler:SetScript('OnSizeChanged', function(self, ...) Timer.OnSizeChanged(timer, ...) end)

	cd.timer = timer
	return timer
end

function Timer.Start(cd, start, duration, charges, maxCharges)
	local remainingCharges = charges or 0
	
	--start timer
	if start > 0 and duration > MIN_DURATION and remainingCharges == 0 and (not cd.noCooldownCount) then
		local timer = cd.timer or Timer.Create(cd)
		timer.start = start
		timer.duration = duration
		timer.enabled = true
		Timer.UpdateText(timer)
		if timer.fontScale >= MIN_SCALE then timer:Show() end
	--stop timer
	else
		local timer = cd.timer
		if timer then
			Timer.Stop(timer)
		end
	end
end

--hook the SetCooldown method of all cooldown frames
--ActionButton1Cooldown is used here since its likely to always exist
--and I'd rather not create my own cooldown frame to preserve a tiny bit of memory
hooksecurefunc(getmetatable(_G['ActionButton1Cooldown']).__index, 'SetCooldown', Timer.Start)

--[[
	In WoW 4.3 and later, action buttons can completely bypass lua for updating cooldown timers
	This set of code is there to check and force tullaCC to update timers on standard action buttons (henceforth defined as anything that reuses's blizzard's ActionButton.lua code
--]]

local ActionBarButtonEventsFrame = _G['ActionBarButtonEventsFrame']
if not ActionBarButtonEventsFrame then return end

local AddonName, Addon = ...
local Timer = Addon.Timer


--[[ cooldown timer updating ]]--

local active = {}

local function cooldown_OnShow(self)
	active[self] = true
end

local function cooldown_OnHide(self)
	active[self] = nil
end

--returns true if the cooldown timer should be updated and false otherwise
local function cooldown_ShouldUpdateTimer(self, start, duration, charges, maxCharges)
	local timer = self.timer
	if not timer then
		return true
	end
	return not(timer.start == start or timer.charges == charges or timer.maxCharges == maxCharges)
end

local function cooldown_Update(self)
	local button = self:GetParent()
	local action = button.action
	
	local start, duration, enable = GetActionCooldown(action)
	local charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(action)
	
	if cooldown_ShouldUpdateTimer(self, start, duration, charges, maxCharges) then
		Timer.Start(self, start, duration, charges, maxCharges)
	end
end

local abEventWatcher = CreateFrame('Frame'); abEventWatcher:Hide()
abEventWatcher:SetScript('OnEvent', function(self, event)
	for cooldown in pairs(active) do
		cooldown_Update(cooldown)
	end
end)
abEventWatcher:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')


--[[ hook action button registration ]]--

local hooked = {}

local function actionButton_Register(frame)
	local cooldown = frame.cooldown
	if not hooked[cooldown] then
		cooldown:HookScript('OnShow', cooldown_OnShow)
		cooldown:HookScript('OnHide', cooldown_OnHide)
		hooked[cooldown] = true
	end
end

if ActionBarButtonEventsFrame.frames then
	for i, frame in pairs(ActionBarButtonEventsFrame.frames) do
		actionButton_Register(frame)
	end
end
hooksecurefunc('ActionBarButtonEventsFrame_RegisterFrame', actionButton_Register)