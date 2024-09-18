local addonName, addon = ...

local function getProfessionID()
    return Professions.GetProfessionInfo().parentProfessionID
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Professions", function() RunNextFrame(function()
    local craftingOrdersTab = ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.craftingOrdersTabID)
    duplicateTab = CreateFrame("BUTTON", nil, ProfessionsFrame, ProfessionsFrame.TabSystem.tabTemplate)
    duplicateTab:SetPoint("TOPLEFT", craftingOrdersTab, "TOPLEFT")
    duplicateTab:SetPoint("BOTTOMRIGHT", craftingOrdersTab, "BOTTOMRIGHT")
    duplicateTab:SetFrameStrata("DIALOG")
    duplicateTab:Hide()
    duplicateTab:SetText(PROFESSIONS_CRAFTING_ORDERS_TAB_NAME)

    local duplicateFrame = ProfessionsFrame.OrdersPageOffline

    hooksecurefunc(ProfessionsFrame, "UpdateTabs", function()
        if not C_CraftingOrders.ShouldShowCraftingOrderTab() then
            duplicateTab:Hide()
            if duplicateFrame:IsShown() then
                duplicateFrame:Hide()
                ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.recipesTabID):Click()
            end
            if addon.cache and addon.cache[getProfessionID()] then
                duplicateTab:Show()
                duplicateTab:SetTabSelected(false)
                craftingOrdersTab:Hide()
            end
        elseif duplicateTab.isSelected then
            if not addon.cache[getProfessionID()] then
                duplicateTab:Hide()
                ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.recipesTabID):Click()
                return
            end
            if craftingOrdersTab:IsEnabled() then
                duplicateTab:Hide()
                ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.craftingOrdersTabID):Click()
                return
            end
            duplicateFrame:ShowCachedData()
        elseif craftingOrdersTab:IsEnabled() or craftingOrdersTab.isSelected then
            duplicateTab:Hide()
            craftingOrdersTab:Show()
            duplicateFrame:Hide()
            if craftingOrdersTab.isSelected then
                ProfessionsFrame.OrdersPage:Show()
            end
        elseif addon.cache then
            if addon.cache[getProfessionID()] then
                duplicateTab:Show()
                craftingOrdersTab:Hide()
                duplicateTab:SetTabSelected(false)
            end
        end
    end)

    for tabID, tab in ipairs(ProfessionsFrame.TabSystem.tabs) do
        tab:HookScript("OnClick", function()
            duplicateTab:SetTabSelected(false)
            duplicateFrame:Hide()
            for frameIndex, frame in ipairs(ProfessionsFrame.internalTabTracker.tabbedElements) do
                if tabID == frameIndex then
                    frame:Show()
                    ProfessionsFrame:SetWidth(frame:GetDesiredPageWidth())
                end
            end
        end)
    end

    duplicateTab:SetScript("OnClick", function()
        ProfessionsFrame.CraftingPage:Hide()
        ProfessionsFrame.SpecPage:Hide()
        ProfessionsFrame.OrdersPage:Hide()
        duplicateTab:SetTabSelected(true)
        duplicateFrame:Show()
        
        for tabID, tab in ipairs(ProfessionsFrame.TabSystem.tabs) do
            tab:SetTabSelected(false)
        end
        ProfessionsFrame:SetWidth(ProfessionsFrame.OrdersPage:GetDesiredPageWidth())
    end)

    hooksecurefunc(ProfessionsFrame, "Update", function(self)
        if not self.professionInfo.profession then return end
        if duplicateFrame:IsShown() and C_TradeSkillUI.IsNearProfessionSpellFocus(self.professionInfo.profession) then
            duplicateFrame:Hide()
            ProfessionsFrame.OrdersPage:Show()
        elseif ProfessionsFrame.OrdersPage:IsShown() and not C_TradeSkillUI.IsNearProfessionSpellFocus(self.professionInfo.profession) then
            duplicateFrame:Show()
            ProfessionsFrame.OrdersPage:Hide()
        end
    end)

end) end) -- end continue on addon loaded
