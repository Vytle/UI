-- nCore/skins all credit to neav
-- updated for Vytle UI by v1nk 01:15 26/03/2013
local f = CreateFrame('Frame')
f:RegisterEvent('VARIABLES_LOADED')
f:RegisterEvent('ADDON_LOADED')
f:RegisterEvent('PLAYER_ENTERING_WORLD')

f:SetScript('OnEvent', function(self)
	-- Deadly Boss Mods
    if (IsAddOnLoaded('DBM-Core')) then
        hooksecurefunc(DBT, 'CreateBar', function(self)
            for bar in self:GetBarIterator() do
                local frame = bar.frame
                local tbar = _G[frame:GetName()..'Bar']
                local spark = _G[frame:GetName()..'BarSpark']
                local texture = _G[frame:GetName()..'BarTexture']
                local icon1 = _G[frame:GetName()..'BarIcon1']
                local icon2 = _G[frame:GetName()..'BarIcon2']
                local name = _G[frame:GetName()..'BarName']
                local timer = _G[frame:GetName()..'BarTimer']

                spark:SetTexture(nil)

                timer:ClearAllPoints()
                timer:SetPoint('RIGHT', tbar, 'RIGHT', -4, 0)
                timer:SetFont('Fonts\\ARIALN.ttf', 22)
                timer:SetJustifyH('RIGHT')

                name:ClearAllPoints()
                name:SetPoint('LEFT', tbar, 4, 0)
                name:SetPoint('RIGHT', timer, 'LEFT', -4, 0)
                name:SetFont('Fonts\\ARIALN.ttf', 15)

                tbar:SetHeight(24)
                tbar:CreateBeautyBorder(10)
                tbar:SetBeautyBorderPadding(tbar:GetHeight() + 3, 2, 2, 2, tbar:GetHeight() + 3, 2, 2, 2)
                tbar:SetBackdrop({bgFile = 'Interface\\Buttons\\WHITE8x8'})
                tbar:SetBackdropColor(0, 0, 0, 0.5)

                icon1:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                icon1:SetSize(tbar:GetHeight(), tbar:GetHeight() - 1)

                icon2:SetTexCoord(0.07, 0.93, 0.07, 0.93)
                icon2:SetSize(tbar:GetHeight(), tbar:GetHeight() - 1)
            end
        end)

            -- hide the pesky range check
        DBM.RangeCheck:Show()
        DBM.RangeCheck:Hide()
        DBMRangeCheck:HookScript('OnShow', function(self)
            self:Hide()
            self.Show = function() end
        end)
    end
	-- TinyDPS
    if (IsAddOnLoaded('TinyDPS')) then
        if (not tdpsFrame.beautyBorder) then
            tdpsFrame:CreateBeautyBorder(11)
            tdpsFrame:SetBeautyBorderPadding(2)
            tdpsFrame:SetBackdrop({
                bgFile = 'Interface\\Buttons\\WHITE8x8',
                insets = { left = 0, right = 0, top = 0, bottom = 0 },
            })
            tdpsFrame:SetBackdropColor(0, 0, 0, 0.5)
        end
    end
	-- Quartz
    if (IsAddOnLoaded('Quartz')) then
   	-- Player
	Quartz3CastBarPlayer:CreateBeautyBorder(11)
	Quartz3CastBarPlayer:SetBeautyBorderPadding(1)
	Quartz3CastBarPlayer:SetBackdropColor(0, 0, 0, 1)
   	-- Target
	Quartz3CastBarTarget:CreateBeautyBorder(11)
	Quartz3CastBarTarget:SetBeautyBorderPadding(1)
	Quartz3CastBarTarget:SetBackdropColor(0, 0, 0, 1)
	-- Pet
	Quartz3CastBarPet:CreateBeautyBorder(11)
	Quartz3CastBarPet:SetBeautyBorderPadding(1)
	Quartz3CastBarPet:SetBackdropColor(0, 0, 0, 1)
	-- Focus
	Quartz3CastBarFocus:CreateBeautyBorder(11)
	Quartz3CastBarFocus:SetBeautyBorderPadding(1)
	Quartz3CastBarFocus:SetBackdropColor(0, 0, 0, 1)
    end
	-- Recount
    if (IsAddOnLoaded('Recount')) then
        if (not Recount.MainWindow.beautyBorder) then
            Recount.MainWindow:CreateBeautyBorder(11)
            Recount.MainWindow:SetBeautyBorderPadding(5, -25, 5, -25, 5, -4, 5, -4)
			Recount.MainWindow:SetBackdrop({
                bgFile = 'Interface\\Buttons\\WHITE8x8',
                insets = { left = -5, right = -5, top = 25, bottom = 4 },
            })

			Recount.MainWindow:SetBackdropColor(0, 0, 0, 0.8)
        end
    end
	-- Skada
    if (IsAddOnLoaded('Skada')) then
        local OriginalSkadaFunc = Skada.PLAYER_ENTERING_WORLD
        function Skada:PLAYER_ENTERING_WORLD()
            OriginalSkadaFunc(self)

            if (SkadaBarWindowSkada and not SkadaBarWindowSkada.beautyBorder) then
                SkadaBarWindowSkada:CreateBeautyBorder(11)
                SkadaBarWindowSkada:SetBeautyBorderPadding(3)
                SkadaBarWindowSkada:SetBackdrop({
                    bgFile = 'Interface\\Buttons\\WHITE8x8',
                    insets = { left = 0, right = 0, top = 10, bottom = 0 },
                })
                SkadaBarWindowSkada:SetBackdropColor(0, 0, 0, 0.8)
            end
        end
    end
	-- Skada
    if (IsAddOnLoaded('Skada')) then
        local OriginalSkadaFunc = Skada.PLAYER_ENTERING_WORLD
        function Skada:PLAYER_ENTERING_WORLD()
            OriginalSkadaFunc(self)

            if (SkadaBarWindowSkada and not SkadaBarWindowSkada.beautyBorder) then
                SkadaBarWindowSkada:CreateBeautyBorder(11)
                SkadaBarWindowSkada:SetBeautyBorderPadding(3)
                SkadaBarWindowSkada:SetBackdrop({
                    bgFile = 'Interface\\Buttons\\WHITE8x8',
                    insets = { left = 0, right = 0, top = 10, bottom = 0 },
                })
                SkadaBarWindowSkada:SetBackdropColor(0, 0, 0, 0.8)
            end
        end
    end
end)
-- Hide boss frames
function hideBossFrames()
	for i = 1, 4 do
		local frame = _G["Boss"..i.."TargetFrame"]
		frame:UnregisterAllEvents()
		frame:Hide()
		frame.Show = function () end
	end
end
-- Call the hide function
hideBossFrames()
