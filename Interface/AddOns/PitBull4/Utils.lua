local _G = _G
local PitBull4 = _G.PitBull4
local L = PitBull4.L
local DEBUG = PitBull4.DEBUG
local expect = PitBull4.expect

PitBull4.Utils = {}

do
	local target_same_mt = { __index=function(self, key)
		if type(key) ~= "string" then
			return false
		end
		
		if key:sub(-6) == "target" then
			local value = self[key:sub(1, -7)]
			self[key] = value
			return value
		end
		
		self[key] = false
		return false
	end }
	
	local target_same_with_target_mt = { __index=function(self, key)
		if type(key) ~= "string" then
			return false
		end
		
		if key:sub(-6) == "target" then
			local value = self[key:sub(1, -7)]
			value = value and value .. "target"
			self[key] = value
			return value
		end
		
		self[key] = false
		return false
	end }
	
	local better_unit_ids = {
		player = "player",
		pet = "pet",
		vehicle = "pet",
		playerpet = "pet",
		mouseover = "mouseover",
		focus = "focus",
		target = "target",
		playertarget = "target",
		npc = "npc",
	}
	for i = 1, MAX_PARTY_MEMBERS do
		better_unit_ids["party" .. i] = "party" .. i
		better_unit_ids["partypet" .. i] = "partypet" .. i
		better_unit_ids["party" .. i .. "pet"] = "partypet" .. i
	end
	for i = 1, MAX_RAID_MEMBERS do
		better_unit_ids["raid" .. i] = "raid" .. i
		better_unit_ids["raidpet" .. i] = "raidpet" .. i
		better_unit_ids["raid" .. i .. "pet"] = "raidpet" .. i
	end
	for i = 1, 5 do
		better_unit_ids["arena" .. i] = "arena" .. i
		better_unit_ids["arenapet" .. i] = "arenapet" .. i
		better_unit_ids["arena" .. i .. "pet"] = "arenapet" .. i
	end
	for i = 1, MAX_BOSS_FRAMES do
		better_unit_ids["boss" .. i] = "boss" .. i
	end
	setmetatable(better_unit_ids, target_same_with_target_mt)
	
	function PitBull4.Utils.GetBestUnitID(unit)
		return better_unit_ids[unit]
	end
	
	local valid_singleton_unit_ids = {
		player = true,
		pet = true,
		mouseover = true,
		focus = true,
		target = true,
	}
	setmetatable(valid_singleton_unit_ids, target_same_mt)
	for i = 1, MAX_BOSS_FRAMES do
		valid_singleton_unit_ids["boss" .. i] = true
	end
	
	function PitBull4.Utils.IsSingletonUnitID(unit)
		return valid_singleton_unit_ids[unit]
	end
	
	local valid_classifications = {
		player = true,
		pet = true,
		mouseover = true,
		focus = true,
		target = true,
		party = true,
		partypet = true,
		raid = true,
		raidpet = true,
	}
	setmetatable(valid_classifications, target_same_mt)
	
	function PitBull4.Utils.IsValidClassification(unit)
		return valid_classifications[unit]
	end
	
	local non_wacky_unit_ids = {
		player = true,
		pet = true,
		mouseover = true,
		focus = true,
		target = true,
		party = true,
		partypet = true,
		raid = true,
		raidpet = true,
	}
	
	function PitBull4.Utils.IsWackyUnitGroup(classification)
		return not non_wacky_unit_ids[classification]
	end
end

do
	local classifications = {
		player = L["Player"],
		target = L["Target"],
		pet = L["Player's pet"],
		party = L["Party"],
		party_sing = L["Party"],
		partypet = L["Party pets"],
		partypet_sing = L["Party pet"],
		raid = L["Raid"],
		raid_sing = L["Raid"],
		raidpet = L["Raid pets"],
		raidpet_sing = L["Raid pet"],
		mouseover = L["Mouse-over"],
		focus = L["Focus"],
		maintank = L["Main tanks"],
		maintank_sing = L["Main tank"],
		mainassist = L["Main assists"],
		mainassist_sing = L["Main assist"]
	}
	for i = 1, MAX_BOSS_FRAMES do
		classifications["boss" .. i] = L["Boss"] .. " " .. i
	end
	setmetatable(classifications, {__index=function(self, group)
		local nonTarget
		local singular = false
		if group:find("target$") then
			nonTarget = group:sub(1, -7)
		elseif group:find("target_sing$") then
			singular = true
			nonTarget = group:sub(1, -12)
		else
			self[group] = group
			return group
		end
		local good
		if group:find("^player") or group:find("^pet") or group:find("^mouseover") or group:find("^target") or group:find("^focus") then
			good = L["%s's target"]:format(self[nonTarget])
		elseif singular then
			good = L["%s target"]:format(self[nonTarget .. "_sing"])
		else
			good = L["%s targets"]:format(self[nonTarget .. "_sing"])
		end
		self[group] = good
		return good
	end})
	
	function PitBull4.Utils.GetLocalizedClassification(classification)
		if DEBUG then
			expect(classification, 'typeof', 'string')
			expect(classification, 'inset', classifications)
		end
		
		return classifications[classification]
	end
end

function PitBull4.Utils.ConvertMethodToFunction(namespace, func_name)
	if type(func_name) == "function" then
		return func_name
	end
	
	if DEBUG then
		expect(namespace[func_name], 'typeof', 'function')
	end
	
	return function(...)
		return namespace[func_name](namespace, ...)
	end
end

function PitBull4.Utils.GetMobIDFromGuid(guid)
    if DEBUG then
        expect(guid, 'typeof', 'string')
        assert(#guid == 16 or #guid == 18)
    end
    
    local unit_type = guid:sub(-14, -14)
    if unit_type ~= "3" and unit_type ~= "B" and unit_type ~= "b" then
        return nil
    end
   
		return tonumber(guid:sub(-12, -9), 16)
end

function PitBull4.Utils.BetterUnitClassification(unit)
    local classification = UnitClassification(unit)
    local LibBossIDs = PitBull4.LibBossIDs
    
    if not LibBossIDs or classification == "worldboss" or classification == "normal" then
        return classification
    end
    local guid = UnitGUID(unit)
    if not guid then
        return classification
    end
    
    local mob_id = PitBull4.Utils.GetMobIDFromGuid(guid)
    if not mob_id then
        return classification
    end
    
    if LibBossIDs.BossIDs[mob_id] then
        return "worldboss"
    end
    
    return classification
end

local function deep_copy(data)
	local t = {}
	for k, v in pairs(data) do
		if type(v) == "table" then
			t[k] = deep_copy(v)
		else
			t[k] = v
		end
	end
	setmetatable(t,getmetatable(data))
	return t
end
PitBull4.Utils.deep_copy = deep_copy