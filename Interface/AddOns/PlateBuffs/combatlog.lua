local folder, core = ...
local nametoGUIDs = core.nametoGUIDs
local P
local playerGUID
local Debug = core.Debug
local guidBuffs = core.guidBuffs
local LibAI = LibStub("LibAuraInfo-1.0", true)
if not LibAI then	error(folder .. " requires LibAuraInfo-1.0.") return end

do
	local UnitGUID = UnitGUID
	local prev_OnEnable = core.OnEnable
	function core:OnEnable()
		prev_OnEnable(self)
		P = self.db.profile
		playerGUID = UnitGUID("player")
		core:RegisterLibAuraInfo()
	end
end

do
	local CombatLogClearEntries = CombatLogClearEntries
	function core:RegisterLibAuraInfo()
		LibAI.UnregisterAllCallbacks(self) 
		if P.watchCombatlog == true then
			LibAI.RegisterCallback(self, "LibAuraInfo_AURA_APPLIED")
			LibAI.RegisterCallback(self, "LibAuraInfo_AURA_REMOVED")
			LibAI.RegisterCallback(self, "LibAuraInfo_AURA_REFRESH")
			LibAI.RegisterCallback(self, "LibAuraInfo_AURA_APPLIED_DOSE")
			LibAI.RegisterCallback(self, "LibAuraInfo_AURA_CLEAR")
			
			CombatLogClearEntries()
		end
	end
end

local prev_OnDisable = core.OnDisable
function core:OnDisable(...)
	if prev_OnDisable then prev_OnDisable(self, ...) end
	
	LibAI.UnregisterAllCallbacks(self) 
end

do
	local bit_band = bit.band
	local COMBATLOG_OBJECT_TYPE_PLAYER = COMBATLOG_OBJECT_TYPE_PLAYER
	function core:FlagIsPlayer(flags)
		if bit_band(flags, COMBATLOG_OBJECT_TYPE_PLAYER) == COMBATLOG_OBJECT_TYPE_PLAYER then
			return true
		end
		return nil
	end
end


do
	local dstName, dstFlags, shortName
	function core:ForceNameplateUpdate(dstGUID)
		if not self:UpdatePlateByGUID(dstGUID) then	
			dstName, dstFlags = LibAI:GetGUIDInfo(dstGUID)
			if dstFlags and self:FlagIsPlayer(dstFlags) then
				shortName = self:RemoveServerName(dstName) --Nameplates don't have server names.
				nametoGUIDs[shortName] = dstGUID
				self:UpdatePlateByName(shortName)
			end
		end
	end
end

do
	local GetTime = GetTime
	local dstName, dstFlags, getTime, count, i
	local table_insert = table.insert
	
	function core:AddSpellToGUID(dstGUID, spellID, srcName, spellName, spellTexture, duration, srcGUID, isDebuff, debuffType, expires, stackCount)
		guidBuffs[dstGUID] = guidBuffs[dstGUID] or {}
		if #guidBuffs[dstGUID] > 0 then
			self:RemoveOldSpells(dstGUID)
		end
		dstName, dstFlags = LibAI:GetGUIDInfo(dstGUID)	
		getTime = GetTime()
		count = #guidBuffs[dstGUID]
		if count == 0 then
			i = 0
			table_insert(guidBuffs[dstGUID], i+1, {
				name		= spellName,
				icon		= spellTexture,
				duration	= (duration or 0),
				playerCast	= srcGUID == playerGUID and 1,
				stackCount	= stackCount or 0,
				startTime	= getTime,
				expirationTime = expires or 0 - 0.1,
				sID = spellID,
				caster = srcName,
			})
			
			if isDebuff then
				guidBuffs[dstGUID][i+1].isDebuff = true
				guidBuffs[dstGUID][i+1].debuffType = debuffType or "none"
			end

			return true
		
		else
			for i=1, count do 
				if guidBuffs[dstGUID][i].sID == spellID and (not guidBuffs[dstGUID][i].caster or guidBuffs[dstGUID][i].caster == srcName) then
					
					guidBuffs[dstGUID][i].expirationTime = expires or 0 - 0.1
					guidBuffs[dstGUID][i].startTime = getTime

					return true
				elseif i == count then
					table_insert(guidBuffs[dstGUID], i+1, {
						name		= spellName,
						icon		= spellTexture,
						duration	= (duration or 0),
						playerCast	= srcGUID == playerGUID and 1,
						stackCount	= stackCount or 0,
						startTime	= getTime,
						expirationTime = expires or 0 - 0.1,
						sID = spellID,
						caster = srcName,
					})
					
					if isDebuff then
						guidBuffs[dstGUID][i+1].isDebuff = true
						guidBuffs[dstGUID][i+1].debuffType = debuffType or "none"
					end
					
					return true
				end
			end
		end
		return false
	end
end
	
do
	local found, stackCount, debuffType, duration, expires, isDebuff, casterGUID, spellName, _, spellTexture, dstName, dstFlags, updateBars, srcName, srcFlags
	local GetSpellInfo = GetSpellInfo
	function core:LibAuraInfo_AURA_APPLIED(event, dstGUID, spellID, srcGUID, spellSchool, auraType)
		found, stackCount, debuffType, duration, expires, isDebuff, casterGUID = LibAI:GUIDAuraID(dstGUID, spellID)
		
		spellName, _, spellTexture = GetSpellInfo(spellID)
		dstName, dstFlags = LibAI:GetGUIDInfo(dstGUID)	
		
		if found then
			spellTexture = spellTexture:upper():gsub("INTERFACE\\ICONS\\", "")
			
			if spellTexture:find("\\") then
				Debug("spellTexture", spellTexture)
			end
			
			updateBars = false
			if P.spellOpts[spellName] and P.spellOpts[spellName].show then
				if P.spellOpts[spellName].show == 1 or (P.spellOpts[spellName].show == 2 and srcGUID == playerGUID) then --fix this
					srcName, srcFlags = LibAI:GetGUIDInfo(srcGUID)
					updateBars = self:AddSpellToGUID(dstGUID, spellID, srcName, spellName, spellTexture, duration, srcGUID, isDebuff, debuffType, expires, stackCount)
				end
			else
				if auraType == "BUFF" and P.defaultBuffShow == 1 or (P.defaultBuffShow == 2 and srcGUID == playerGUID) 
				or auraType == "DEBUFF" and P.defaultDebuffShow == 1 or (P.defaultDebuffShow == 2 and srcGUID == playerGUID) then
					srcName, srcFlags = LibAI:GetGUIDInfo(srcGUID)
					updateBars = self:AddSpellToGUID(dstGUID, spellID, srcName, spellName, spellTexture, duration, srcGUID, isDebuff, debuffType, expires, stackCount)
				end
			end
	
			if updateBars then
				core:ForceNameplateUpdate(dstGUID)
			end
	
		end
		
	end
end

do
	local table_remove = table.remove
	local srcName, srcFlags
	function core:LibAuraInfo_AURA_REMOVED(event, dstGUID, spellID, srcGUID, spellSchool, auraType)
		if guidBuffs[dstGUID] then
			srcName, srcFlags = LibAI:GetGUIDInfo(srcGUID)
			for i = #guidBuffs[dstGUID], 1, -1 do 
				if guidBuffs[dstGUID][i].sID == spellID and (not guidBuffs[dstGUID][i].caster or guidBuffs[dstGUID][i].caster == srcName) then
					table_remove(guidBuffs[dstGUID], i)
					
					self:ForceNameplateUpdate(dstGUID)
					
					return
				end
			end
		end
		
	end
end
	
do
	local spellName, srcName, srcFlags, getTime, dstName
	local GetTime = GetTime
	local GetSpellInfo = GetSpellInfo
	function core:LibAuraInfo_AURA_REFRESH(event, dstGUID, spellID, srcGUID, spellSchool, auraType, expirationTime)
		spellName = GetSpellInfo(spellID)		
		
		if guidBuffs[dstGUID] then
			srcName, srcFlags = LibAI:GetGUIDInfo(srcGUID)
			for i = #guidBuffs[dstGUID], 1, -1 do 
				if guidBuffs[dstGUID][i].sID == spellID and (not guidBuffs[dstGUID][i].caster or guidBuffs[dstGUID][i].caster == srcName) then
					getTime = GetTime()
					guidBuffs[dstGUID][i].startTime = getTime
					guidBuffs[dstGUID][i].expirationTime = expirationTime
					
					self:ForceNameplateUpdate(dstGUID)
					return
				end
			end
		end
	
		
		dstName = LibAI:GetGUIDInfo(dstGUID)
		if not LibAI:GUIDAuraID(dstGUID, spellID) then
			Debug("SPELL_AURA_REFRESH",LibAI:GUIDAuraID(dstGUID, spellID), dstName, spellName, "passing to SPELL_AURA_APPLIED")
		end
		self:LibAuraInfo_AURA_APPLIED(event, dstGUID, spellID, srcGUID, spellSchool, auraType)
	end
end

do
	local spellName, srcName, srcFlags, dstName
	local GetSpellInfo = GetSpellInfo
	local GetTime = GetTime
	function core:LibAuraInfo_AURA_APPLIED_DOSE(event, dstGUID, spellID, srcGUID, spellSchool, auraType, stackCount, expirationTime)
		spellName = GetSpellInfo(spellID)
		
		if guidBuffs[dstGUID] then
			srcName, srcFlags = LibAI:GetGUIDInfo(srcGUID)
			for i = #guidBuffs[dstGUID], 1, -1 do 
				if guidBuffs[dstGUID][i].sID == spellID and (not guidBuffs[dstGUID][i].caster or guidBuffs[dstGUID][i].caster == srcName) then
					guidBuffs[dstGUID][i].stackCount = stackCount
				
					guidBuffs[dstGUID][i].startTime = GetTime()
					guidBuffs[dstGUID][i].expirationTime = expirationTime
				
					self:ForceNameplateUpdate(dstGUID)
					return
				end
			end
		end
		
		
		dstName = LibAI:GetGUIDInfo(dstGUID)
		if not LibAI:GUIDAuraID(dstGUID, spellID) then
			Debug("LAURA_APPLIED_DOSE", dstName, spellName, "passing to SPELL_AURA_APPLIED")
		end
		self:LibAuraInfo_AURA_APPLIED(event, dstGUID, spellID, srcGUID, spellSchool, auraType)
	end
end
	
do
	local table_getn = table.getn
	local table_remove = table.remove
	function core:LibAuraInfo_AURA_CLEAR(event, dstGUID)
		if guidBuffs[dstGUID] then
			for i=table_getn(guidBuffs[dstGUID]), 1, -1 do 
				table_remove(guidBuffs[dstGUID], i)
			end
			self:ForceNameplateUpdate(dstGUID)
		end
	end
end