--[[ nExtras is just a few addons that i enjoy to use when I play WoW
the config will alow you to turn off any one of the addons you chose
not to use. All Credit for said addons are listed with them.]]

cfg = {

	-- Chat Options
	['chat'] = {
		['enable'] = true,			-- enables !Beautycase border for chat
	},
	
	-- Crafting Bind On Pickup Options
	['CBOP'] = {
		["enable"] = true,
	},
	
	-- Merchant Options
	['merchant'] = {
		['enable'] = true,			-- enable merchant module.
		['sellMisc'] = true, 		-- allows the user to add spacific items to sell at merchant (please see the local filter in merchant.lua)
		['autoSellGrey'] = true,	-- autosell grey items at merchant.
		['autoRepair'] = true,		-- autorepair at merchant.
		['gpay'] = true,			-- let your guild pay for your repairs if they allow.
	},
	
	-- Quest Options
	['quest'] = {
		['enable'] = true,			-- enable quest module.
		['autocomplete'] = true,	-- enable the autoaccept quest and autocomplete quest if no reward.
	},
	
	-- Self Buff Options
	['selfbuffs'] = {
		['enable'] = true,			-- enable selbuffs module.
		['sound'] = false,			-- Play Sound
		["type"] = "Warning",		-- Type of sound to play
	},

}

--------------
-- Chat Addon
--------------
if cfg.chat.enable then

	local _G = _G

	if (IsAddOnLoaded('!Beautycase')) then
		do	
			for i = 1, NUM_CHAT_WINDOWS do
				local cf = _G['ChatFrame'..i]
				if cf then
					cf:CreateBeautyBorder(12)
					cf:SetBeautyBorderPadding( 5, 5, 5, 5, 5, 8, 5, 8)
				end
			end
			
			local ct = _G['ChatFrame2']
			if ct then
				ct:CreateBeautyBorder(12)
				ct:SetBeautyBorderPadding(5, 29, 5, 29, 5, 8, 5, 8)
			end
		end
	end
end

---------------------------------------
-- Crafting Bind On Pickup Warning Box
---------------------------------------
-- Credit for CBOP goes to oscarucb for his BOP Craft Confirm addon.
-- You can find the original addon at http://www.wowace.com/addons/bopcraftconfirm/files/
-- Edited by Cokedriver

if cfg.CBOP.enable then

	local addonName, vars = ...
	nExtras = vars
	local addon = nExtras
	local settings

	local L = setmetatable({}, { __index = function(t,k)
		local v = tostring(k)
		rawset(t, k, v)
		return v
	end })

	local defaults = {
	  debug = false,
	  always = {
	  },
	}

	local function chatMsg(msg) 
		 DEFAULT_CHAT_FRAME:AddMessage(addonName..": "..msg)
	end
	local function debug(msg) 
	  if settings and settings.debug then
		 chatMsg(msg)
	  end
	end

	addon.scantt = CreateFrame("GameTooltip", addonName.."_Tooltip", UIParent, "GameTooltipTemplate")

	local function OnEvent(frame, event, name, ...)
	  if event == "ADDON_LOADED" and string.upper(name) == string.upper(addonName) then
		 debug("ADDON_LOADED: "..name)
		 nEDB = nEDB or {}
		 settings = nEDB
		 for k,v in pairs(defaults) do
		   if settings[k] == nil then
			 settings[k] = defaults[k]
		   end
		 end
	  end
	end
	local frame = CreateFrame("Button", addonName.."HiddenFrame", UIParent)
	frame:RegisterEvent("ADDON_LOADED");
	frame:SetScript("OnEvent", OnEvent);

	local blizzard_DoTradeSkill
	local save_idx, save_cnt, save_link
	local function bopcc_DoTradeSkill(idx,cnt)   
	   local link = GetTradeSkillItemLink(idx)
	   debug(link,idx,cnt)   

	   if not link then
		 blizzard_DoTradeSkill(idx,cnt)
		 return
	   end

	   local bop
	   addon.scantt:ClearLines()
	   addon.scantt:SetOwner(UIParent, "ANCHOR_NONE");
	   addon.scantt:SetHyperlink(link)
	   for i=1,addon.scantt:NumLines() do
		 local line = getglobal(addon.scantt:GetName() .. "TextLeft"..i)
		 local text = line and line:GetText()
		 if text and text:find(ITEM_BIND_ON_PICKUP) then
		   bop = ITEM_BIND_ON_PICKUP
		   break
		 elseif text and text:find(ITEM_BIND_TO_ACCOUNT) then
		   bop = ITEM_BIND_TO_ACCOUNT
		   break
		 elseif text and text:find(ITEM_BIND_TO_BNETACCOUNT) then
		   bop = ITEM_BIND_TO_BNETACCOUNT
		   break
		 elseif text and (text:find(ITEM_BIND_ON_USE) or text:find(ITEM_BIND_ON_EQUIP)) then
		   break
		 end
	   end

	   if settings and settings.always and settings.always[link] then
		  debug("Confirm suppressed: "..link)
		  bop = nil
	   end

	   if bop then
		 save_idx = idx
		 save_cnt = cnt
		 save_link = link
		 StaticPopupDialogs["BOPCRAFTCONFIRM_CONFIRM"].text =  
			save_link.."\n"..bop.."\n"..L["Crafting this item will bind it to you."]
		 StaticPopup_Show("BOPCRAFTCONFIRM_CONFIRM")
	   else
		 blizzard_DoTradeSkill(idx,cnt)
	   end
	end

	blizzard_DoTradeSkill = _G["DoTradeSkill"]
	_G["DoTradeSkill"] = bopcc_DoTradeSkill

	local function isValid()
	   if not save_idx or not save_link then return false end
	   local link = GetTradeSkillItemLink(save_idx)
	   return link == save_link
	end

	local function CraftConfirmed()
	   local link = save_link or "<unknown>"
	   if not isValid() then -- trade window changed
		 debug("CraftConfirmed: Aborting "..link)
		 return
	   end
	   debug("CraftConfirmed: "..link)
	   blizzard_DoTradeSkill(save_idx,save_cnt)
	end

	local function AlwaysConfirmed(_,reason)
	  if reason == "override" then 
		 debug("AlwaysConfirmed: override abort")
		 return
	  end
	  local link = save_link or "<unknown>"
	  if not isValid() then -- trade window changed
		 debug("AlwaysConfirmed: Aborting "..link)
		 return
	  end
	  debug("AlwaysConfirmed: "..save_link)
	  settings.always[save_link] = true
	  CraftConfirmed()
	end

	StaticPopupDialogs["BOPCRAFTCONFIRM_CONFIRM"] = {
	  preferredIndex = 3, -- prevent taint
	  text = "dummy",
	  button1 = OKAY,
	  button2 = ALWAYS.." "..OKAY,
	  button3 = CANCEL,
	  OnAccept = CraftConfirmed,
	  OnCancel = AlwaysConfirmed, -- second button
	  timeout = 0,
	  hideOnEscape = false, -- this clicks always
	  -- enterClicksFirstButton = true, -- this doesnt work (needs a hardware mouse click event?)
	  showAlert = true,
	}
end
	
------------
-- Merchant
------------
-- Credit for Merchant goes to Tuks for his Tukui project.
-- You can find his Addon at http://tukui.org/dl.php
-- Editied by Cokedriver

if cfg.merchant.enable then

	local filter = {
		[6289]  = true, -- Raw Longjaw Mud Snapper
		[6291]  = true, -- Raw Brilliant Smallfish
		[6308]  = true, -- Raw Bristle Whisker Catfish
		[6309]  = true, -- 17 Pound Catfish
		[6310]  = true, -- 19 Pound Catfish
		[41808] = true, -- Bonescale Snapper
		[42336] = true, -- Bloodstone Band
		[42337] = true, -- Sun Rock Ring
		[43244] = true, -- Crystal Citrine Necklace
		[43571] = true, -- Sewer Carp
		[43572] = true, -- Magic Eater		
	}

	local f = CreateFrame("Frame")
	f:SetScript("OnEvent", function()
		if cfg.merchant.autoSellGrey or cfg.merchant.sellMisc then
			local c = 0
			for b=0,4 do
				for s=1,GetContainerNumSlots(b) do
					local l,lid = GetContainerItemLink(b, s), GetContainerItemID(b, s)
					if l and lid then
						local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
						if cfg.merchant.autoSellGrey and select(3, GetItemInfo(l))==0 then
							UseContainerItem(b, s)
							PickupMerchantItem()
							c = c+p
						end
						if cfg.merchant.sellMisc and filter[ lid ] then
							UseContainerItem(b, s)
							PickupMerchantItem()
							c = c+p
						end
					end
				end
			end
			if c>0 then
				local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
				DEFAULT_CHAT_FRAME:AddMessage("Your grey item's have been sold for".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
			end
		end
		if not IsShiftKeyDown() then
			if CanMerchantRepair() and cfg.merchant.autoRepair then	
				guildRepairFlag = 0
				local cost, possible = GetRepairAllCost()
				-- additional checks for guild repairs
				if (IsInGuild()) and (CanGuildBankRepair()) then
					 if cost <= GetGuildBankWithdrawMoney() then
						guildRepairFlag = 1
					 end
				end
				if cost>0 then
					if (possible or guildRepairFlag) then
						RepairAllItems(guildRepairFlag)
						local c = cost%100
						local s = math.floor((cost%10000)/100)
						local g = math.floor(cost/10000)
						if cfg.merchant.gpay == "true" and guildRepairFlag == 1 then
							DEFAULT_CHAT_FRAME:AddMessage("Your guild payed ".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r".." to repair your items.",255,255,0)
						else
							DEFAULT_CHAT_FRAME:AddMessage("You payed ".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r".." to repair your items.",255,255,0)
						end	
					else
						DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!",255,0,0)
					end
				end		
			end
		end
	end)
	f:RegisterEvent("MERCHANT_SHOW")
end

---------
-- Quest 
---------
-- Credit for Quest goes to nightcracker for his ncQuest addon.
-- You can find his addon at http://www.wowinterface.com/downloads/info14972-ncQuest.html
-- Editied by Cokedriver


if cfg.quest.enable then

	local f = CreateFrame("Frame")

	local function MostValueable()
		local bestp, besti = 0
		for i=1,GetNumQuestChoices() do
			local link, name, _, qty = GetQuestItemLink("choice", i), GetQuestItemInfo("choice", i)
			local price = link and select(11, GetItemInfo(link))
			if not price then
				return
			elseif (price * (qty or 1)) > bestp then
				bestp, besti = (price * (qty or 1)), i
			end
		end
		if besti then
			local btn = _G["QuestInfoItem"..besti]
			if (btn.type == "choice") then
				btn:GetScript("OnClick")(btn)
			end
		end
	end

	f:SetScript("OnEvent", function(self, event, ...)
		if cfg.quest.autocomplete == true then
			if (event == "QUEST_DETAIL") then
				AcceptQuest()
				CompleteQuest()
			elseif (event == "QUEST_COMPLETE") then
				if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
					GetQuestReward()
				else
					MostValueable()
				end
			elseif (event == "QUEST_ACCEPT_CONFIRM") then
				ConfirmAcceptQuest()
			end
		elseif cfg.quest.autocomplete == false then
			if (event == "QUEST_COMPLETE") then
				if (GetNumQuestChoices() and GetNumQuestChoices() < 1) then
					GetQuestReward()
				else
					MostValueable()
				end
			end
		end
	end)
	f:RegisterEvent("QUEST_ACCEPT_CONFIRM")    
	f:RegisterEvent("QUEST_DETAIL")
	f:RegisterEvent("QUEST_COMPLETE")
end

------------
-- Selfbuff
------------
-- Credit for Selfbuff goes to Tuks for his Tukui project.
-- You can find his addon at http://tukui.org/dl.php
-- Editied by Cokedriver


if cfg.selfbuffs.enable then 

	--------------------------------
	-- source TukUI - www.tukui.org
	--------------------------------

	--------------------------------------------------------------------------------------------
	-- Spells that should be shown with an icon in the middle of the screen when not buffed.
	--------------------------------------------------------------------------------------------
		 
	remindbuffs = {

		ROGUE = {
			108211,		-- Leeching Poison
		},
		DRUID = {
			1126,  		-- Mark of the Wild (Druid)
			115921, 	-- Legacy of the Emperor (Monk)
			20217, 		-- Blessing of Kings (Paladin)
			90363, 		-- Embrace of the Shale Spider (Hunter Pet)
			24907,		-- Moonkin Aura (Druid)
			15473,		-- Shadowform (Priest)
			51470,		-- Elemental Oath (Shaman)
			49868,		-- Mind Quickening (Hunter Pet)
			17007,		-- Leader of the Pack (Druid)
			116781, 	-- Legacy of the White Tiger (Monk)
			97229, 		-- Bellowing Roar (Hunter Pet)
			24604,		-- Furious Howl (Hunter Pet)
			90309,		-- Terrifying Roar (Hunter Pet)
			126373,		-- Fearless Roar (Hunter Pet)
			126309, 	-- Still Water (Hunter Pet)
		},
		PRIEST = {
			588, 		-- Inner Fire
			73413, 		-- Inner Will
			21562, 		-- Power Word: Fortitude (Priest)
			103127,		-- Imp: Blood Pact (Warlock Pet)
			469, 		-- Commanding Shout (Warrior)
			90364,		-- Qiraji Fortitude (Hunter Pet)
			24907,		-- Moonkin Aura (Druid)
			15473,		-- Shadowform (Priest)
			51470,		-- Elemental Oath (Shaman)
			49868,		-- Mind Quickening (Hunter Pet)
		},
		PALADIN ={
			20217, 		-- Blessing of Kings (Paladin)
			19740, 		-- Blessing of Might (Paladin)
			116956, 	-- Grace of Air (Shaman)
			93435, 		-- Roar of Courage (Hunter Pet)
			128997, 	-- Spirit Beast Blessing (Hunter Pet)
			90363, 		-- Embrace of the Shale Spider (Hunter Pet)
			1126,  		-- Mark of the Wild (Druid)
			115921, 	-- Legacy of the Emperor (Monk)
		},
		HUNTER = {
			13165, 		-- Aspect of the Hawk
			5118, 		-- Aspect of the Beast
			13159, 		-- Aspect of the Hawk
			61648, 		-- Aspect of the Beast
			82661, 		-- Aspect of the Fox
			109260, 	-- Aspect of the Iron Hawk
			93435, 		-- Roar of Courage (Hunter Pet)
			116956, 	-- Grace of Air (Shaman)
			128997, 	-- Spirit Beast Blessing (Hunter Pet))
			90363, 		-- Embrace of the Shale Spider (Hunter Pet)
			90364,		-- Qiraji Fortitude (Hunter Pet)
			57330, 		-- Horn of Winter (Deathknight)
			19506, 		-- Trueshot Aura (Hunter)
			6673, 		-- Battle Shout (Warrior)
			1459, 		-- Arcane Brilliance (Mage)
			61316,		-- Dalaran Brilliance (Mage)
			77747, 		-- Burning Wrath (Shaman)
			109773, 	-- Dark Intent (Warlock)
			126309, 	-- Still Water (Hunter Pet)
			55610, 		-- Unholy Aura (Deathknight)
			113742,		-- Swiftblade's Cunning (Rogue)
			30809,		-- Unleashed Rage (Shaman)
			128432,		-- Cackling Howl (Hunter Pet)
			128433,		-- Serpent's Swiftness (Hunter Pet)
			24907,		-- Moonkin Aura (Druid)
			15473,		-- Shadowform (Priest)
			51470,		-- Elemental Oath (Shaman)
			49868,		-- Mind Quickening (Hunter Pet)
			17007,		-- Leader of the Pack (Druid)
			116781, 	-- Legacy of the White Tiger (Monk)
			97229, 		-- Bellowing Roar (Hunter Pet)
			24604,		-- Furious Howl (Hunter Pet)
			90309,		-- Terrifying Roar (Hunter Pet)
			126373,		-- Fearless Roar (Hunter Pet)
			19740, 		-- Blessing of Might (Paladin)
			1126,  		-- Mark of the Wild (Druid)
			115921, 	-- Legacy of the Emperor (Monk)
		},
		
		MAGE = {
			7302, 		-- Frost Armor
			6117, 		-- Mage Armor
			30482, 		-- Molten Armor
			1459, 		-- Arcane Brilliance (Mage)
			77747, 		-- Burning Wrath (Shaman)
			109773, 	-- Dark Intent (Warlock)
			126309, 	-- Still Water (Hunter Pet)
			17007,		-- Leader of the Pack (Druid)
			116781, 	-- Legacy of the White Tiger (Monk)
			97229, 		-- Bellowing Roar (Hunter Pet)
			24604,		-- Furious Howl (Hunter Pet)
			90309,		-- Terrifying Roar (Hunter Pet)
			126373,		-- Fearless Roar (Hunter Pet)
			61316,		-- Dalaran Brilliance (Mage)
		},
		
		MONK = {
			115921, 	-- Legacy of the Emperor (Monk)
			116781, 	-- Legacy of the White Tiger (Monk)
			1126,  		-- Mark of the Wild (Druid)
			20217, 		-- Blessing of Kings (Paladin)
			90363, 		-- Embrace of the Shale Spider (Hunter Pet)
			17007,		-- Leader of the Pack (Druid)
			97229, 		-- Bellowing Roar (Hunter Pet)
			24604,		-- Furious Howl (Hunter Pet)
			90309,		-- Terrifying Roar (Hunter Pet)
			126373,		-- Fearless Roar (Hunter Pet)
			126309, 	-- Still Water (Hunter Pet)
		},
		
		WARLOCK = {
			21562, 		-- Power Word: Fortitude (Priest)
			103127, 	-- Imp: Blood Pact (Warlock Pet)
			469, 		-- Commanding Shout (Warrior)
			90364,		-- Qiraji Fortitude (Hunter Pet)
			1459, 		-- Arcane Brilliance (Mage)
			61316,		-- Dalaran Brilliance (Mage)
			77747, 		-- Burning Wrath (Shaman)
			109773, 	-- Dark Intent (Warlock)
			126309, 	-- Still Water (Hunter Pet)
		},
		SHAMAN = {
			52127, 		-- Water Shield
			324, 		-- Lightning Shield
			974, 		-- Earth Shield
			116956, 	-- Grace of Air (Shaman)
			93435, 		-- Roar of Courage (Hunter Pet)
			19740, 		-- Blessing of Might (Paladin)
			128997, 	-- Spirit Beast Blessing (Hunter Pet)
			1459, 		-- Arcane Brilliance (Mage)
			61316,		-- Dalaran Brilliance (Mage)
			77747, 		-- Burning Wrath (Shaman)
			109773, 	-- Dark Intent (Warlock)
			126309, 	-- Still Water (Hunter Pet)
			55610, 		-- Unholy Aura (Deathknight)
			113742,		-- Swiftblade's Cunning (Rogue)
			30809,		-- Unleashed Rage (Shaman)
			128432,		-- Cackling Howl (Hunter Pet)
			128433,		-- Serpent's Swiftness (Hunter Pet)
			24907,		-- Moonkin Aura (Druid)
			15473,		-- Shadowform (Priest)
			51470,		-- Elemental Oath (Shaman)
			49868,		-- Mind Quickening (Hunter Pet)
		},
		WARRIOR = {
			469, 		-- Commanding Shout (Warrior)
			6673, 		-- Battle Shout (Warrior)
			21562, 		-- Power Word: Fortitude (Priest)
			103127, 	-- Imp: Blood Pact (Warlock Pet)
			90364,		-- Qiraji Fortitude (Hunter Pet)
			57330, 		-- Horn of Winter (Deathknight)
			19506, 		-- Trueshot Aura (Hunter)
		},
		DEATHKNIGHT = {
			57330, 		-- Horn of Winter (Deathknight)
			19506, 		-- Trueshot Aura (Hunter)
			6673, 		-- Battle Shout (Warrior)
			31634, 		-- Strength of Earth Totem
			6673, 		-- Battle Shout
			93435, 		-- roar of courage (hunter pet)	
			55610, 		-- Unholy Aura (Deathknight)
			113742,		-- Swiftblade's Cunning (Rogue)
			30809,		-- Unleashed Rage (Shaman)
			128432,		-- Cackling Howl (Hunter Pet)
			128433,		-- Serpent's Swiftness (Hunter Pet)
		},
		
	}

	remindenchants = {

		SHAMAN = {
			8024, -- flametongue
			8232, -- windfury
			51730, -- earthliving
		},
	}

	-- Nasty stuff below. Don't touch.
	local class = select(2, UnitClass('Player'))
	local buffs = remindbuffs[class]
	local enchants = remindenchants[class]
	local sound 


	if (buffs and buffs[1] and UnitLevel("player") > 10) then
		local function OnEvent(self, event)	
			if (event == 'PLAYER_LOGIN' or event == 'LEARNED_SPELL_IN_TAB') then
				for i, buff in pairs(buffs) do
					local name = GetSpellInfo(buff)
					local usable, nomana = IsUsableSpell(name)
					if (usable or nomana) then
						self.icon:SetTexture(select(3, GetSpellInfo(buff)))
						break
					end
				end
				if (not self.icon:GetTexture() and event == 'PLAYER_LOGIN') then
					self:UnregisterAllEvents()
					self:RegisterEvent('LEARNED_SPELL_IN_TAB')
					return
				elseif (self.icon:GetTexture() and event == 'LEARNED_SPELL_IN_TAB') then
					self:UnregisterAllEvents()
					self:RegisterEvent('UNIT_AURA')
					self:RegisterEvent('PLAYER_LOGIN')
					self:RegisterEvent('PLAYER_REGEN_ENABLED')
					self:RegisterEvent('PLAYER_REGEN_DISABLED')
				end
			end
						
			if (UnitAffectingCombat('player') and not UnitInVehicle('player')) then
				for i, buff in pairs(buffs) do
					local name = GetSpellInfo(buff)
					if (name and UnitBuff('player', name)) then
						self:Hide()
						sound = true
						return
					end
				end
				self:Show()
				if cfg.selfbuffs.sound == true and sound == true then
					PlaySoundFile(cfg.selfbuffs.type)
					sound = false
				end
			else
				self:Hide()
				sound = true
			end
		end
		
		local frame = CreateFrame('Frame', nil, UIParent)
		frame:SetPoint('CENTER', UIParent, 0, 150)
		frame:SetSize(50, 50)
		frame:CreateBeautyBorder(12)
		frame:SetBeautyBorderPadding( 1, 1, 1, 1, 1, 1, 1, 1)
		frame:Hide()
		
		frame.icon = frame:CreateTexture(nil, 'BACKGROUND')
		frame.icon:SetPoint('CENTER', frame)
		frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		frame.icon:SetSize(45, 45)
		frame.icon:SetParent(frame)
			
		 
		frame:RegisterEvent('UNIT_AURA')
		frame:RegisterEvent('PLAYER_LOGIN')
		frame:RegisterEvent('PLAYER_REGEN_ENABLED')
		frame:RegisterEvent('PLAYER_REGEN_DISABLED')
		frame:RegisterEvent('UNIT_ENTERING_VEHICLE')
		frame:RegisterEvent('UNIT_ENTERED_VEHICLE')
		frame:RegisterEvent('UNIT_EXITING_VEHICLE')
		frame:RegisterEvent('UNIT_EXITED_VEHICLE')
		
		frame:SetScript('OnEvent', OnEvent)
			

	end

	if (enchants and enchants[1] and UnitLevel("player") > 10) then
		local sound
		local currentlevel = UnitLevel("player")

		local function EnchantsOnEvent(self, event)
			if (event == "PLAYER_LOGIN") or (event == "ACTIVE_TALENT_GROUP_CHANGED") or (event == "PLAYER_LEVEL_UP") then
				if class == "ROGUE" then
					self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
					self:UnregisterEvent("PLAYER_LEVEL_UP")
					self.icon:SetTexture(select(3, GetSpellInfo(enchants[1])))
					return
				elseif class == "SHAMAN" then
					local ptt = GetSpecialization ()
					if ptt and ptt == 3 and currentlevel > 53 then
						self.icon:SetTexture(select(3, GetSpellInfo(enchants[3])))
					elseif ptt and ptt == 2 and currentlevel > 31 then
						self.icon:SetTexture(select(3, GetSpellInfo(enchants[2])))
					else
						self.icon:SetTexture(select(3, GetSpellInfo(enchants[1])))
					end
					return
				end
			end

			if (class == "ROGUE" or class =="SHAMAN") and currentlevel < 10 then return end

			if (UnitAffectingCombat("player") and not UnitInVehicle("player")) then
				local mainhand, _, _, offhand, _, _, thrown = GetWeaponEnchantInfo()
				if class == "ROGUE" then
					local itemid = GetInventoryItemID("player", GetInventorySlotInfo("RangedSlot"))
					if itemid and select(7, GetItemInfo(itemid)) == INVTYPE_THROWN and currentlevel > 61 then
						if mainhand and offhand and thrown then
							self:Hide()
							sound = true
							return
						end
					else
						if mainhand and offhand then
							self:Hide()
							sound = true
							return
						end
					end
				elseif class == "SHAMAN" then
					local itemid = GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot"))
					if itemid and select(6, GetItemInfo(itemid)) == ENCHSLOT_WEAPON then
						if mainhand and offhand then
							self:Hide()
							sound = true
							return
						end
					elseif mainhand then
						self:Hide()
						sound = true
						return
					end
				end
				self:Show()
				if cfg.selfbuffs.sound == true and sound == true then
					PlaySoundFile(cfg.selfbuffs.type)
					sound = false
				end
			else
				self:Hide()
				sound = true
			end
		end

		local frame = CreateFrame('Frame', nil, UIParent)
		frame:SetPoint('CENTER', UIParent, 0, 150)
		frame:SetSize(50, 50)
		frame:CreateBeautyBorder(12)
		frame:SetBeautyBorderPadding(1, 1, 1, 1, 1, 1, 1, 1)
		frame:Hide()
		
		frame.icon = frame:CreateTexture(nil, 'BACKGROUND')
		frame.icon:SetPoint('CENTER', frame)
		frame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		frame.icon:SetSize(45, 45)
		frame.icon:SetParent(frame)
			
		frame:RegisterEvent("PLAYER_LOGIN")
		frame:RegisterEvent("PLAYER_LEVEL_UP")
		frame:RegisterEvent("PLAYER_REGEN_ENABLED")
		frame:RegisterEvent("PLAYER_REGEN_DISABLED")
		frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
		frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		frame:RegisterEvent("UNIT_ENTERING_VEHICLE")
		frame:RegisterEvent("UNIT_ENTERED_VEHICLE")
		frame:RegisterEvent("UNIT_EXITING_VEHICLE")
		frame:RegisterEvent("UNIT_EXITED_VEHICLE")

		frame:SetScript("OnEvent", EnchantsOnEvent)
	end
end