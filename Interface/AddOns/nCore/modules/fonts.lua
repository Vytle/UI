for _, font in pairs({
    GameFontHighlight,

    GameFontDisable,

    GameFontHighlightExtraSmall,
    GameFontHighlightMedium,

    GameFontNormal,
    GameFontNormalSmall,

    TextStatusBarText,

    GameFontDisableSmall,
    GameFontHighlightSmall,
}) do
    font:SetFont('Fonts\\ARIALN.ttf', 13)
    font:SetShadowOffset(1, -1)
end
   
for _, font in pairs({
    AchievementPointsFont,
    AchievementPointsFontSmall,
    AchievementDescriptionFont,
    AchievementCriteriaFont,
    AchievementDateFont,
}) do
    font:SetFont('Fonts\\ARIALN.ttf', 12)
end

GameFontNormalHuge:SetFont('Fonts\\ARIALN.ttf', 20, 'OUTLINE')
GameFontNormalHuge:SetShadowOffset(0, 0)