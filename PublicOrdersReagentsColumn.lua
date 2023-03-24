-- This code adapted from Blizzard_Professions\Blizzard_ProfessionsCrafterOrderPage.lua
-- The existing function ProfessionsFrame.OrdersPage:SetupTable() hides the Reagents column for Public Orders
-- This code simply shows it again.
local OrderBrowseType = EnumUtil.MakeEnum("Flat", "Bucketed", "None");

hooksecurefunc(ProfessionsFrame.OrdersPage, "SetupTable", function(self)
    local browseType = self:GetBrowseType();
    local PTC = ProfessionsTableConstants;

    if browseType == OrderBrowseType.Flat then
        if self.orderType == Enum.CraftingOrderType.Public then
            self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Reagents.Width, PTC.Reagents.LeftCellPadding,
                PTC.Reagents.RightCellPadding, ProfessionsSortOrder.Reagents, "ProfessionsCrafterTableCellReagentsTemplate");
        end
        self.tableBuilder:Arrange();
    end
end)

-- The existing function ProfessionsFrame.OrdersPage:ShotGeneric is called on the results from clicking the Search button
-- This will hide results without reagents if the option is selected
hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", function(self, orders, browseType, offset, isSorted)
    if browseType ~= 1 then return end
    if not PublicOrdersReagentsDB.hideOrdersWithoutMaterials then return end
    
    local dataProvider = self.BrowseFrame.OrderList.ScrollBox:GetDataProvider()

    function recursion()
        local collection = dataProvider:GetCollection()
        for i = 1, #collection do
            if collection[i].option.reagentState ~= 0 then
                if (PublicOrdersReagentsDB.minimumCommission == 0) or ((collection[i].option.tipAmount/10000) < PublicOrdersReagentsDB.minimumCommission) then
                    dataProvider:Remove(collection[i])
                    recursion()
                    return
                end
            end
        end
    end
    recursion()
end)

-- adds a checkbox to the crafting orders frame
local checkBox = CreateFrame("CheckButton", "PublicOrdersReagentsColumnHideOrdersWithoutMaterialsCheckButton", ProfessionsFrame.OrdersPage, "UICheckButtonTemplate")
checkBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 28, 0)
checkBox:RegisterEvent("PLAYER_ENTERING_WORLD")
checkBox:HookScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        checkBox:UnregisterEvent("PLAYER_ENTERING_WORLD")
        if not PublicOrdersReagentsDB then PublicOrdersReagentsDB = {} end
        checkBox:SetChecked(PublicOrdersReagentsDB.hideOrdersWithoutMaterials)
        
        -- addon RECraft moves the arrow to the same spot I have the checkbox, compensate
        if IsAddOnLoaded("RECraft") then
            checkBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 28, 22)
        end
        
        PublicOrdersReagentsColumnMinimumCommissionSlider:SetValue(PublicOrdersReagentsDB.minimumCommission or 0)
    end
end)
checkBox:SetScript("OnClick", function()
    PublicOrdersReagentsDB.hideOrdersWithoutMaterials = checkBox:GetChecked()
end)
checkBox:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    GameTooltip:SetText("Hide listings that do not provide all the materials")
    PublicOrdersReagentsColumnMinimumCommissionFrame:Show()
end)
checkBox:SetScript("OnLeave", function()
    GameTooltip:Hide()
    
    if not PublicOrdersReagentsColumnMinimumCommissionFrame:IsMouseOver() then
        PublicOrdersReagentsColumnMinimumCommissionFrame:Hide()
    end
end)

-- minimum commission frame with slider
local commissionFrame = CreateFrame("Frame", "PublicOrdersReagentsColumnMinimumCommissionFrame", PublicOrdersReagentsColumnHideOrdersWithoutMaterialsCheckButton)
commissionFrame:Hide()
commissionFrame:SetSize(330, 100)
commissionFrame:SetPoint("TOP", checkBox, "BOTTOM")
commissionFrame:SetFrameStrata("TOOLTIP")
commissionFrame.Border = CreateFrame("Frame", nil, PublicOrdersReagentsColumnMinimumCommissionFrame, "DialogBorderDarkTemplate")
commissionFrame.Backdrop = CreateFrame("Frame", nil, PublicOrdersReagentsColumnMinimumCommissionFrame, "TooltipBackdropTemplate")

commissionFrame.Slider = CreateFrame("Slider", "PublicOrdersReagentsColumnMinimumCommissionSlider", PublicOrdersReagentsColumnMinimumCommissionFrame, "OptionsSliderTemplate")
commissionFrame.Slider:SetPoint("TOP", commissionFrame, "TOP", 0, -20)
commissionFrame.Slider:SetSize(280, 20)
PublicOrdersReagentsColumnMinimumCommissionSliderLow:SetText("Never")
PublicOrdersReagentsColumnMinimumCommissionSliderHigh:SetText("25,000")
PublicOrdersReagentsColumnMinimumCommissionSliderText:SetText("Never")
PublicOrdersReagentsColumnMinimumCommissionSliderText:SetFontObject("GameFontHighlightSmall")
PublicOrdersReagentsColumnMinimumCommissionSliderText:SetTextColor(0, 1, 0)
commissionFrame.Slider:SetOrientation('HORIZONTAL')
commissionFrame.Slider:SetValueStep(100)
commissionFrame.Slider:SetObeyStepOnDrag(true)
commissionFrame.Slider:SetMinMaxValues(0, 25000)
commissionFrame.Slider:SetValue(0)

commissionFrame.Slider:SetScript("OnValueChanged", function(self, value, userInput)
    PublicOrdersReagentsColumnMinimumCommissionSliderText:SetText(value)
    PublicOrdersReagentsDB.minimumCommission = value
    if value == 0 then
        PublicOrdersReagentsColumnMinimumCommissionSliderText:SetText("Never")
    end
end)

commissionFrame.Label = commissionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
commissionFrame.Label:SetPoint("TOP", commissionFrame.Slider, "BOTTOM", 0, -20)
commissionFrame.Label:SetText("...or show the order anyway if it offers this much commission")
commissionFrame.Label:SetWordWrap(true)
commissionFrame.Label:SetWidth(280)

commissionFrame:SetScript("OnLeave", function()
    if (not checkBox:IsMouseOver()) and (not PublicOrdersReagentsColumnMinimumCommissionFrame:IsMouseOver()) then
        commissionFrame:Hide()
    end
end)     
