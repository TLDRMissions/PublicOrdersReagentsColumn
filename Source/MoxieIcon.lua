local addonName, addon = ...

local function isEnabled()
    if (addon.db.profile.moxieIconTypeCharacterOverride == nil) or (addon.db.profile.moxieIconTypeCharacterOverride == 0) then
        if addon.db.global.moxieIconType == nil then
            return false
        end
        if addon.db.global.moxieIconType == 0 then
            return false
        end
        return true
    end
    return true
end

local function shouldFlash()
    if addon.db.profile.moxieIconTypeCharacterOverride == 2 then
        return true
    end
    if (addon.db.profile.moxieIconTypeCharacterOverride == nil) or (addon.db.profile.moxieIconTypeCharacterOverride == 0) then
        if addon.db.global.moxieIconType == 2 then
            return true
        end
    end
    return false
end

local ProfessionIDToCurrencyID = {
    [Enum.Profession.Blacksmithing] = 3257,
    [Enum.Profession.Leatherworking] = 3263,
    [Enum.Profession.Alchemy] = 3256,
    [Enum.Profession.Herbalism] = 3260,
    [Enum.Profession.Mining] = 3264,
    [Enum.Profession.Tailoring] = 3266,
    [Enum.Profession.Engineering] = 3259,
    [Enum.Profession.Enchanting] = 3258,
    [Enum.Profession.Skinning] = 3265,
    [Enum.Profession.Jewelcrafting] = 3262,
    [Enum.Profession.Inscription] = 3261,
}

NMNMMoxieCurrencyMixin = CreateFromMixins(ProfessionsCurrencyWithLabelMixin)

function NMNMMoxieCurrencyMixin:OnShow()
    if ProfessionsFrame.professionInfo then
        self:SetCurrencyType(ProfessionIDToCurrencyID[ProfessionsFrame.professionInfo.profession])
    end
	self:UpdateQuantity();
end

RunNextFrame(function()
    NMNMCraftingPageMoxieDisplay:SetParent(ProfessionsFrame.CraftingPage)
    NMNMCraftingPageMoxieDisplay:SetPoint("TOPLEFT", ProfessionsFrame.CraftingPage.ConcentrationDisplay.Icon, "BOTTOMLEFT", 0, 5)
    
    NMNMOrdersPageMoxieDisplay:SetParent(ProfessionsFrame.OrdersPage.OrderView)
    NMNMOrdersPageMoxieDisplay:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay.Icon, "BOTTOMLEFT", 0, 5)
    
    if isEnabled() then
        ProfessionsFrame.CraftingPage.ConcentrationDisplay:SetPoint("TOPLEFT", 120, -25)
        ProfessionsFrame.OrdersPage.OrderView.ConcentrationDisplay:SetPoint("TOPLEFT", 120, -25)
        RunNextFrame(function()
            if ProfessionsFrame.professionInfo and ProfessionIDToCurrencyID[ProfessionsFrame.professionInfo.profession] then
                NMNMCraftingPageMoxieDisplay:Show()
                NMNMOrdersPageMoxieDisplay:Show()
            end
        end)
    end
    
    hooksecurefunc(ProfessionsFrame, "Refresh", function()
        NMNMCraftingPageMoxieDisplay:Hide()
        NMNMOrdersPageMoxieDisplay:Hide()
        if not isEnabled() then return end
        RunNextFrame(function()
            if ProfessionsFrame.professionInfo and ProfessionIDToCurrencyID[ProfessionsFrame.professionInfo.profession] then
                NMNMCraftingPageMoxieDisplay:Show()
                NMNMOrdersPageMoxieDisplay:Show()
            end
        end)
    end)
    
    hooksecurefunc(ProfessionsFrame.CraftingPage, "Refresh", function()
        if not isEnabled() then return end
        ProfessionsFrame.CraftingPage.ConcentrationDisplay:SetPoint("TOPLEFT", 120, -25)
    end)
end)

function NMNMMoxieCurrencyMixin:OnQuantityChanged(currencyInfo)
    self.Amount:SetFormattedText("|cnHIGHLIGHT_FONT_COLOR:%d|r", currencyInfo.quantity)
    self.Flash:Hide()
    if shouldFlash() and (currencyInfo.quantity > 599) then
        self.Flash:Show()
        self.Flash.FlashAnim:Play()
    end
end