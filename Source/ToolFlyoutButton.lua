local addonName, addon = ...

local flyout = PublicOrdersReagentsColumnToolFlyoutButton

flyout:SetParent(ProfessionsFrame.CraftingPage)
flyout:SetFrameStrata("HIGH")
flyout:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.Prof1ToolSlot, "BOTTOMLEFT")
flyout:SetPoint("TOPRIGHT", ProfessionsFrame.CraftingPage.Prof1ToolSlot, "BOTTOMRIGHT")

flyout:HookScript("OnClick", function(self, button, isUserInput)
    PublicOrdersReagentsColumnToolSelectionFrame:SetShown(self:GetChecked())
end)

hooksecurefunc(ProfessionsFrame, "Refresh", function()
    if ProfessionsFrame.professionType == 1 then
        flyout:Show()
    else
        flyout:Hide()
    end
end)