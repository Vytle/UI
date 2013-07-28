-- all credit goes to Blooblahguy
-- bBag v1.1
local config = {
	enable = true,
	spacing = 5,
	bpr = 9,
	scale = 0.9,
}

if not config.enable then return end

function CreateBackdrop(frame)
    frame:CreateBeautyBorder(12)
	frame:SetBeautyBorderPadding(3)
	frame:SetBackdrop({
                bgFile = 'Interface\\Tooltips\\UI-Tooltip-Background',
                insets = { left = -3, right = -3, top = -3, bottom = -3 },
            })
    frame:SetBackdropColor(0, 0, 0, 1)
end

function MakeMovable(frame)
    frame:SetClampedToScreen(true)
    frame:SetMovable(true)
    frame:SetUserPlaced(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton","RightButton")
end

local togglemain, togglebank = 0,0
local togglebag


-- Skin Everything
local function skin(index, frame)
    for i = 1, index do
        local bag = _G[frame..i]
		local f = _G[bag:GetName().."IconTexture"]
        bag:SetNormalTexture("")
        bag:SetPushedTexture("")
		CreateBackdrop(bag)
        f:SetPoint("TOPLEFT", bag, 2, -2)
		f:SetPoint("BOTTOMRIGHT", bag, -2, 2)
        f:SetTexCoord(.1, .9, .1, .9)
    end
end

-- Loop for the 12 ContainerFrames
for i = 1, 12 do
	local closeButton = _G["ContainerFrame"..i.."CloseButton"]
	closeButton:Hide()
	for k = 1, 7 do
		local container = _G["ContainerFrame"..i]
		select(k, container:GetRegions()):SetAlpha(0)
	end
end
	
-- Hide the background for the BackpackTokenFrame
_G["BackpackTokenFrame"]:GetRegions():SetAlpha(0)
_G["BankFrameMoneyFrameInset"]:Hide()
_G["BankFrameMoneyFrameBorder"]:Hide()
_G["BankFrameCloseButton"]:Hide()
for i = 1, 80 do -- Hide the regions.  There are 80, but there is an included fail-safe.
	local region = select(i, _G["BankFrame"]:GetRegions())
	if not region then break else region:SetAlpha(0) end
end
for i = 1, 7 do -- Hide the 7 BankFrameBags
	_G["BankFrameBag"..i]:Hide()
end

local bags = {
	bag = {
		CharacterBag0Slot,
		CharacterBag1Slot,
		CharacterBag2Slot,
		CharacterBag3Slot
	},
	bank = {
		BankFrameBag1,
		BankFrameBag2,
		BankFrameBag3,
		BankFrameBag4,
		BankFrameBag5,
		BankFrameBag6,
		BankFrameBag7
	}
}

function SetUp(framen, ...)
	local frame = CreateFrame("Frame", "betterBag_"..framen, UIParent)
	frame:SetScale(config.scale)
	frame:SetWidth(((36+config.spacing)*config.bpr)+20-config.spacing)
	frame:SetPoint(...)
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(1)
	frame:RegisterForDrag("LeftButton","RightButton")
	frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	frame:Hide()
	CreateBackdrop(frame)
	MakeMovable(frame)
	
	local frame_bags = CreateFrame('Frame', "betterBag_"..framen.."_bags")
	frame_bags:SetParent("betterBag_"..framen)
	frame_bags:SetWidth(10)
	frame_bags:SetHeight(10)
	frame_bags:SetPoint("BOTTOMRIGHT", "betterBag_"..framen, "TOPRIGHT", 0, -2)
	frame_bags:Hide()
	CreateBackdrop(frame_bags)
	
	local frame_bags_toggle = CreateFrame('Frame', "betterBag_"..framen.."_bags_toggle")
	frame_bags_toggle:SetHeight(20)
	frame_bags_toggle:SetWidth(20)
	frame_bags_toggle:SetPoint("TOPRIGHT", "betterBag_"..framen, "TOPRIGHT", -6, -6)
	frame_bags_toggle:SetParent("betterBag_"..framen)
	frame_bags_toggle:EnableMouse(true)
	
	local frame_bags_toggle_text = frame_bags_toggle:CreateFontString("button")
	frame_bags_toggle_text:SetPoint("CENTER", frame_bags_toggle, "CENTER")
	frame_bags_toggle_text:SetFont('Fonts\\ARIALN.ttf', 12, "OUTLINE")
	frame_bags_toggle_text:SetText("B")
	frame_bags_toggle_text:SetTextColor(.4,.4,.4)
	frame_bags_toggle:SetScript('OnMouseUp', function()
		if (togglebag ~= 1) then
			togglebag = 1
		else
			togglebag= 0
		end
		if togglebag == 1 then
			frame_bags:Show()
			frame_bags_toggle_text:SetTextColor(1,1,1)
		else
			frame_bags:Hide()
			frame_bags_toggle_text:SetTextColor(.4,.4,.4)
		end
	end)
	
	if (framen == "bag") then
		for _, f in pairs(bags.bag) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["betterBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbag then
				f:SetPoint("LEFT", lastbuttonbag, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["betterBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()
			icon:SetTexCoord(.1, .9, .1, .9)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetCheckedTexture("")
			CreateBackdrop(f)
			lastbuttonbag = f
			_G["betterBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bag))+14)
			_G["betterBag_"..framen.."_bags"]:SetHeight(40)
		end
	else
		for _, f in pairs(bags.bank) do
			local count = _G[f:GetName().."Count"]
			local icon = _G[f:GetName().."IconTexture"]
			f:SetParent(_G["betterBag_"..framen.."_bags"])
			f:ClearAllPoints()
			f:SetWidth(24)
			f:SetHeight(24)
			if lastbuttonbank then
				f:SetPoint("LEFT", lastbuttonbank, "RIGHT", config.spacing, 0)
			else
				f:SetPoint("TOPLEFT", _G["betterBag_"..framen.."_bags"], "TOPLEFT", 8, -8)
			end
			count.Show = function() end
			count:Hide()
			icon:SetTexCoord(.06, .94, .06, .94)
			f:SetNormalTexture("")
			f:SetPushedTexture("")
			f:SetHighlightTexture("")
			CreateBackdrop(f)
			lastbuttonbank = f
			_G["betterBag_"..framen.."_bags"]:SetWidth((24+config.spacing)*(getn(bags.bank))+14)
			_G["betterBag_"..framen.."_bags"]:SetHeight(40)
		end
	end
end

ContainerFrame1:SetScript("OnHide", function()
	_G['betterBag_bag']:Hide()
end)
GameMenuFrame:SetScript("OnShow", function() 
	togglemain = 1
	ToggleAllBags()
end)

BankFrameItem1:SetScript("OnHide", function() 
	_G["betterBag_bank"]:Hide()
	togglebank = 0
end)
BankFrameItem1:SetScript("OnShow", function() 
	_G["betterBag_bank"]:Show()
end)
BankPortraitTexture:Hide()
BankFrame:EnableMouse(0)
BankFrameCloseButton:Hide()

SetUp("bag", "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 100)
SetUp("bank", "TOPLEFT", UIParent, "TOPLEFT", 10, -134)
skin(28, "BankFrameItem")
skin(7, "BankFrameBag")


BagItemSearchBox:SetScript("OnUpdate", function()
	BagItemSearchBox:ClearAllPoints()
	BagItemSearchBox:SetPoint("TOPRIGHT", _G["betterBag_bag"], "TOPRIGHT", -28, -6)
end)

BankItemSearchBox:SetScript("OnUpdate", function()
	BankItemSearchBox:ClearAllPoints()
	BankItemSearchBox:SetPoint("TOPRIGHT", _G["betterBag_bank"], "TOPRIGHT", -28, -6)
end)


function SkinEditBox(frame)
	_G[frame:GetName().."Left"]:Hide()
	if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Hide() end
	if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Hide() end
	_G[frame:GetName().."Right"]:Hide()
	
	frame:SetFrameStrata("HIGH")
	frame:SetFrameLevel(2)
	frame:SetWidth(200)
	frame:SetScale(config.scale)
	
	local framebg = CreateFrame('frame', frame, frame)
	framebg:SetPoint("TOPLEFT", frame, "TOPLEFT", -4, 0)
	framebg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
    framebg:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 2, 
        insets = {top = 2, left = 2, bottom = 2, right = 2}})
    framebg:SetBackdropColor(1,1,1,.4)
    framebg:SetBackdropBorderColor(0,0,0,1)
	framebg:SetFrameLevel(0)
end

SkinEditBox(BagItemSearchBox)
SkinEditBox(BankItemSearchBox)
 
BackpackTokenFrameToken1:ClearAllPoints()
BackpackTokenFrameToken1:SetPoint("BOTTOMLEFT", _G["betterBag_bag"], "BOTTOMLEFT", 0, 8)
for i = 1, 3 do
	_G["BackpackTokenFrameToken"..i]:SetFrameStrata("HIGH")
    _G["BackpackTokenFrameToken"..i]:SetFrameLevel(5)
    _G["BackpackTokenFrameToken"..i]:SetScale(config.scale)
	_G["BackpackTokenFrameToken"..i.."Icon"]:SetSize(12,12) 
	_G["BackpackTokenFrameToken"..i.."Icon"]:SetTexCoord(.1,.9,.1,.9) 
	_G["BackpackTokenFrameToken"..i.."Icon"]:SetPoint("LEFT", _G["BackpackTokenFrameToken"..i], "RIGHT", -8, 2) 
    _G["BackpackTokenFrameToken"..i.."Count"]:SetFont('Fonts\\ARIALN.ttf', 13)
	if (i ~= 1) then
		_G["BackpackTokenFrameToken"..i]:SetPoint("LEFT", _G["BackpackTokenFrameToken"..(i-1)], "RIGHT", 10, 0)
	end
end

-- Centralize and rewrite bag rendering function
function ContainerFrame_GenerateFrame(frame, size, id)
	frame.size = size;
	for i=1, size, 1 do
		local index = size - i + 1;
		local itemButton = _G[frame:GetName().."Item"..i];
		itemButton:SetID(index);
		itemButton:Show();
	end
	frame:SetID(id);
	frame:Show()
	
	if ( id < 5 ) then
		local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
		for bag = 1, 5 do
			local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(36)
				itemframes:SetHeight(36)
				itemframes:SetScale(config.scale)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				ContainerFrame1MoneyFrame:ClearAllPoints()
				ContainerFrame1MoneyFrame:Show()
				ContainerFrame1MoneyFrame:SetPoint("TOPLEFT", _G["betterBag_bag"], "TOPLEFT", 6, -10)
				ContainerFrame1MoneyFrame:SetFrameStrata("HIGH")
				ContainerFrame1MoneyFrame:SetFrameLevel(2)
				ContainerFrame1MoneyFrame:SetScale(config.scale)
				if bag==1 and item==16 then
					itemframes:SetPoint("TOPLEFT", _G["betterBag_bag"], "TOPLEFT", 10, -30)
					lastrowbutton = itemframes
					lastbutton = itemframes
				elseif numbuttons==config.bpr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+36))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+36))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+36), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+36), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		if (BackpackTokenFrameToken1:IsShown()) then
			_G["betterBag_bag"]:SetHeight(((36+config.spacing)*(numrows+1)+60)-config.spacing)
		else
			_G["betterBag_bag"]:SetHeight(((36+config.spacing)*(numrows+1)+40)-config.spacing)
		end
	else
		local numrows, lastrowbutton, numbuttons, lastbutton = 0, ContainerFrame1Item1, 1, ContainerFrame1Item1
		for bank = 1, 28 do
			local bankitems = _G["BankFrameItem"..bank]
			bankitems:ClearAllPoints()
			bankitems:SetWidth(36)
			bankitems:SetHeight(36)
			bankitems:SetFrameStrata("HIGH")
			bankitems:SetFrameLevel(2)
			bankitems:SetScale(config.scale)
			ContainerFrame2MoneyFrame:Show()
			ContainerFrame2MoneyFrame:ClearAllPoints()
			ContainerFrame2MoneyFrame:SetPoint("TOPLEFT", _G["betterBag_bank"], "TOPLEFT", 6, -10)
			ContainerFrame2MoneyFrame:SetFrameStrata("HIGH")
			ContainerFrame2MoneyFrame:SetFrameLevel(2)
			ContainerFrame2MoneyFrame:SetParent(_G["betterBag_bank"])
			BankFrameMoneyFrame:Hide()
			if bank==1 then
				bankitems:SetPoint("TOPLEFT", _G["betterBag_bank"], "TOPLEFT", 10, -30)
				lastrowbutton = bankitems
				lastbutton = bankitems
			elseif numbuttons==config.bpr then
				bankitems:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+36))
				bankitems:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+36))
				lastrowbutton = bankitems
				numrows = numrows + 1
				numbuttons = 1
			else
				bankitems:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+36), 0)
				bankitems:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+36), 0)
				numbuttons = numbuttons + 1
			end
			lastbutton = bankitems
		end
		
		for bag = 6, 12 do
			local slots = GetContainerNumSlots(bag-1)
			for item = slots, 1, -1 do
				local itemframes = _G["ContainerFrame"..bag.."Item"..item]
				itemframes:ClearAllPoints()
				itemframes:SetWidth(36)
				itemframes:SetHeight(36)
				itemframes:SetFrameStrata("HIGH")
				itemframes:SetFrameLevel(2)
				itemframes:SetScale(config.scale)
				if numbuttons==config.bpr then
					itemframes:SetPoint("TOPRIGHT", lastrowbutton, "TOPRIGHT", 0, -(config.spacing+36))
					itemframes:SetPoint("BOTTOMLEFT", lastrowbutton, "BOTTOMLEFT", 0, -(config.spacing+36))
					lastrowbutton = itemframes
					numrows = numrows + 1
					numbuttons = 1
				else
					itemframes:SetPoint("TOPRIGHT", lastbutton, "TOPRIGHT", (config.spacing+36), 0)
					itemframes:SetPoint("BOTTOMLEFT", lastbutton, "BOTTOMLEFT", (config.spacing+36), 0)
					numbuttons = numbuttons + 1
				end
				lastbutton = itemframes
			end
		end
		_G["betterBag_bank"]:SetHeight(((36+config.spacing)*(numrows+1)+40)-config.spacing)
	end
end

function OpenBag(id, fromb)
    if ( not CanOpenPanels() ) then
        if ( UnitIsDead("player") ) then
            NotWhileDeadError();
        end
        return;
    end
	if (fromb) then
		local size = GetContainerNumSlots(id);
		if ( size > 0 ) then
			local containerShowing;
			for i=1, NUM_CONTAINER_FRAMES, 1 do
				local frame = _G["ContainerFrame"..i];
				if ( frame:IsShown() and frame:GetID() == id ) then
					containerShowing = i;
				end
			end
			if ( not containerShowing ) then
				ContainerFrame_GenerateFrame(ContainerFrame_GetOpenFrame(), size, id);
			end
		end
	else
		ToggleAllBags()
	end
end

-- Centralize and rewrite bag opening functions
function UpdateContainerFrameAnchors() end
function ToggleBag() ToggleAllBags() end
function ToggleBackpack() ToggleAllBags() end
function OpenAllBags() ToggleAllBags() end
function OpenBackpack()  ToggleAllBags() end
function CloseBackpack() ToggleAllBags() end
function CloseAllBags() ToggleAllBags() end
function ToggleAllBags()
	if (togglemain == 1) then
		if(not BankFrame:IsShown()) then 
			togglemain = 0
			CloseBag(0,1)
			_G["betterBag_bag"]:Hide()
			for i=1, NUM_BAG_FRAMES, 1 do CloseBag(i) end
		end
	else
		togglemain = 1
		_G["betterBag_bag"]:Show()
		OpenBag(0,1)
		for i=1, NUM_BAG_FRAMES, 1 do OpenBag(i,1) end
	end
	if( BankFrame:IsShown() ) then
		if (togglebank == 1) then
			togglebank = 0
			_G["betterBag_bank"]:Hide()
			BankFrame:Hide()
			for i=NUM_BAG_FRAMES+1, NUM_CONTAINER_FRAMES, 1 do
				if ( IsBagOpen(i) ) then CloseBag(i) end
			end
		else
			togglebank = 1
			_G["betterBag_bank"]:Show()
			BankFrame:Show()
			for i=1, NUM_CONTAINER_FRAMES, 1 do
				if (not IsBagOpen(i)) then OpenBag(i,1) end
			end
		end
	end
end
