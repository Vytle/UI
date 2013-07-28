local f = CreateFrame('Frame')
f:RegisterEvent('PLAYER_LOGIN')
f:SetScript('OnEvent', function(_, event, ...)
    if (event == 'PLAYER_LOGIN') then
		SetCVar('consolidateBuffs', 0) -- Disable grouping of buffs, since we don't have it in the buff mode.
		SetCVar('chatStyle', 'classic') -- No IM Style
		SetCVar('chatBubbles', 1) -- Enables chat bubbles 
		SetCVar('chatBubblesParty', 1) -- Enables party chat bubbles 
		SetCVar('ScreenshotQuality', 10) -- Increase screenshot quality
		SetCVar('cameraDistanceMax', 50) -- Increase maximum camera distance
		SetCVar('cameraDistanceMaxFactor', 3.4) -- Increasing max camera distance further
		SetCVar('UberTooltips', 1) -- Über Tooltips! Wunderbar!
		SetCVar('showTutorials', 0) -- Not a n00b. Don't show tutorials
		SetCVar("gameTip", 0) -- Disable tips
		SetCVar("showGameTips", 0) -- Disable more tips
		SetCVar('M2Faster', 3) -- Increase number of threads available to WoW for rendering
		SetCVar('buffDurations', 1) -- Show buff durations
		SetCVar('scriptErrors', 0) -- Disable Lua errors
		SetCVar('autoLootDefault', 1) -- Enable auto loot by default
		-- enable classcolor automatically on login and on each character without doing /configure each time.
		ToggleChatColorNamesByClassGroup(true, "SAY")
		ToggleChatColorNamesByClassGroup(true, "EMOTE")
		ToggleChatColorNamesByClassGroup(true, "YELL")
		ToggleChatColorNamesByClassGroup(true, "GUILD")
		ToggleChatColorNamesByClassGroup(true, "OFFICER")
		ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
		ToggleChatColorNamesByClassGroup(true, "WHISPER")
		ToggleChatColorNamesByClassGroup(true, "PARTY")
		ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID")
		ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
		ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
		ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
		ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
		ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
		ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
		ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
    end
end)

-- Slash commands by v1nk

-- /clc to clear combat log
SlashCmdList["CLCE"] = function() CombatLogClearEntries() end
SLASH_CLCE1 = "/clc"

-- /gm to open a GM ticket
SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/gm"

-- /rc for readycheck
SlashCmdList["READYCHECK"] = function() DoReadyCheck() end
SLASH_READYCHECK1 = '/rc'

-- /cr for check role 
SlashCmdList["CHECKROLE"] = function() InitiateRolePoll() end
SLASH_CHECKROLE1 = '/cr'

-- /rl /reload to reload ui
SlashCmdList['RELOADUI'] = function()
    ReloadUI()
end
SLASH_RELOADUI1 = '/rl'
SLASH_RELOADUI2 = '/reload'

-- UI COMMANDS
SlashCmdList['UICMDS'] = function()
	print('|cFFFF0000Vytle UI Slash commands|r')
	print('Commands:')
	print('  |cFF20E020/rl|r - to reload ui')
	print('  |cFF20E020/cr|r - for role check')
	print('  |cFF20E020/rc|r - for ready check')
	print('  |cFF20E020/gm|r - for GM ticket')
	print('  |cFF20E020/clc|r - to clear combat log')
end
SLASH_UICMDS1 = '/uicmds'