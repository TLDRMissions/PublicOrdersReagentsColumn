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
    flyout:Hide()
    if ProfessionsFrame.professionType == 1 then
        if addon.db.profile.toolFlyout then
            flyout:Show()
        end
    end
end)