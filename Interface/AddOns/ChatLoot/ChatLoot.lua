--create the main frame
local ChatLoot = CreateFrame("FRAME", "ChatLoot", UIParent)
ChatLoot:RegisterEvent("ADDON_LOADED")
ChatLoot:SetFrameStrata("MEDIUM")
ChatLoot:SetScript("OnEvent", function(self, event, ...) self:OnEvent(event, ...) end)
ChatLoot:Show()

--hooked functions
ChatLootHooked_LootHistoryFrame_FullUpdate = LootHistoryFrame_FullUpdate
ChatLootHooked_FCF_SetWindowName = FCF_SetWindowName

--starts here
function ChatLoot:OnEvent(event, ...)
	if event == "ADDON_LOADED" then
		local info = ...
		if info == "ChatLoot" then
			self:UnregisterEvent("ADDON_LOADED")
			
			self.defaultChatTabName = "Loot History"
			
			if CHATLOOT then
				self.settings = CHATLOOT
			else
				self.settings = {}
				CHATLOOT = self.settings
			end
			
			if not self.settings.tabName then
				self.settings.tabName = self.defaultChatTabName
			end
			
			if self.settings.alert == nil then
				self.settings.alert = true
			end
			
			self:SetScript("OnUpdate", function(self, elapsed) self:LoadFrame(elapsed) end)
		end
	elseif event == "START_LOOT_ROLL" then
		self:FlashOnLoot()
	elseif event == "LOOT_HISTORY_AUTO_SHOW" then
		self:FlashOnLoot()
	end
end

--Setup slash commands for chatbox
SLASH_CHATLOOT1 = "/loot"
SLASH_CHATLOOT2 = "/chatloot"
function SlashCmdList.CHATLOOT(msg, editbox)
	if msg == "reset" then
		ChatLoot:ResetFrameSize()
		
	elseif msg == "alert" then
		if ChatLoot.settings.alert then
			ChatLoot.settings.alert = false
			ChatLoot:UnregisterEvent("START_LOOT_ROLL")
			ChatLoot:UnregisterEvent("LOOT_HISTORY_AUTO_SHOW")
			print("Alert Disabled.")
		else
			ChatLoot.settings.alert = true
			ChatLoot:RegisterEvent("START_LOOT_ROLL")
			ChatLoot:RegisterEvent("LOOT_HISTORY_AUTO_SHOW")
			print("Alert Enabled.")
		end
		
	elseif msg == "help" then
		print("|cFFFF0000Chat Loot Help|r" )
		print("|cFF00FF00/loot|r to show the loot tab." )
		print("|cFF00FF00/loot alert|r to toggle tab flash." )
		print("|cFF00FF00/loot reset|r to reset the frame to its original size for uninstall." )
		
	else
		if not ChatLoot:IsVisible() then
			FCF_SelectDockFrame(ChatLoot.chatFrameName)
		end
	end
end

--wait till chat is loaded then create a tab and prep it for loot info
function ChatLoot:LoadFrame(elapsed)
	if ChatFrame1 then
		--stop looking for loaded chat window
		self:SetScript("OnUpdate", function() end)
		
		if not ChatLoot:ChatWindowCheck() then
			self.settings.tabName = self.defaultChatTabName
			FCF_OpenNewWindow(self.settings.tabName)
		end
		self.chatFrameName = _G["ChatFrame"..self:ChatWindowCheck()]
		
		ChatFrame_RemoveAllMessageGroups(self.chatFrameName)
			
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", self.chatFrameName, "TOPLEFT", 0, 18)
		self:SetPoint("BOTTOMRIGHT", self.chatFrameName, "BOTTOMRIGHT", 0, 0)
		self:SetParent(self.chatFrameName)
		self:SetScript("OnShow", function() self:LootWindowSize() end)
		self:SetScript("OnSizeChanged", function() self:LootWindowSize() end)
		
		LootHistoryFrame:SetParent("ChatLoot")
		self:LootWindowSize()
		
		LootHistoryFrame.CloseButton:Hide()
		LootHistoryFrame.DragButton:Hide()
		LootHistoryFrame.ResizeButton:Hide()
		LootHistoryFrame.Divider:Hide()
		LootHistoryFrame.LootIcon:Hide()
		LootHistoryFrame.Label:Hide()
		
		--there has to be a less retarded way to do this...
		LootHistoryFrame.Background:Hide()
		LootHistoryFrame.BorderTopLeft:Hide()
		LootHistoryFrame.BorderTopRight:Hide()
		LootHistoryFrame.BorderBottomRight:Hide()
		LootHistoryFrame.BorderBottomLeft:Hide()
		LootHistoryFrame.BorderTop:Hide()
		LootHistoryFrame.BorderRight:Hide()
		LootHistoryFrame.BorderBottom:Hide()
		LootHistoryFrame.BorderLeft:Hide()
		LootHistoryFrameScrollFrame.ScrollBarBackground:Hide()
		
		LootHistoryFrame:Show()
		
		if self.settings.alert then
			self:RegisterEvent("START_LOOT_ROLL")
			self:RegisterEvent("LOOT_HISTORY_AUTO_SHOW")
		end
	end
end

--the check for if a chat frame already exists
function ChatLoot:ChatWindowCheck()
	for id = 1, FCF_GetNumActiveChatFrames() do
		if _G["ChatFrame"..id].name == self.settings.tabName then
			return id
		end
	end
	return false
end

--anchor history frame to chat tab
function ChatLoot:LootWindowSize()
	LootHistoryFrame:Show()
	
	LootHistoryFrame:ClearAllPoints()
	LootHistoryFrame:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	LootHistoryFrame:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	
	self:FixFrameSize(LootHistoryFrame)
end

--adjust item frame player list to proper width
function ChatLoot:FixFrameSize(frame)
	local frameWidth = frame:GetWidth()
	
	local childCount = C_LootHistory.GetNumItems()
	for id = 1, childCount do
		frame.itemFrames[id]:SetWidth(frameWidth - 40)
		frame.itemFrames[id].ActiveHighlight:SetWidth(frameWidth - 92)
		frame.itemFrames[id].Divider:Hide()
	end
	
	local playerFrameCount = #frame.usedPlayerFrames
	for id = 1, playerFrameCount do
		frame.usedPlayerFrames[id]:SetWidth(frameWidth - 40)
	end
end

--make the tab flash if loot is acquired
function ChatLoot:FlashOnLoot()
	if not self:IsVisible() and self.settings.alert then
		FCF_StartAlertFlash(self.chatFrameName)
	end
end

--set the history frame back to its original size.  log and disable addon to complete uninstall 
function ChatLoot:ResetFrameSize()
	LootHistoryFrame:SetUserPlaced(true)
	LootHistoryFrame:ClearAllPoints()
	LootHistoryFrame:SetParent("UIParent")
	LootHistoryFrame:SetPoint("BOTTOM", nil, "CENTER")
	LootHistoryFrame:SetWidth(210)
	LootHistoryFrame:SetHeight(175)
end

--hooked to adjust history frames children on update
function LootHistoryFrame_FullUpdate(self)
	ChatLootHooked_LootHistoryFrame_FullUpdate(self)
	
	--fix frame width
	ChatLoot:FixFrameSize(self)
end

--hooked to save name of the tab when you rename it
function FCF_SetWindowName(frame, name, doNotSave)
	ChatLootHooked_FCF_SetWindowName(frame, name, doNotSave)
	
	if ChatLoot.chatFrameName == frame then
		ChatLoot.settings.tabName = frame.name
	end
end