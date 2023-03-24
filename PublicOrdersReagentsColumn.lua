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
hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", function(self)
    if not PublicOrdersReagentsDB.hideOrdersWithoutMaterials then return end
    
    local dataProvider = self.BrowseFrame.OrderList.ScrollBox:GetDataProvider()

    function recursion()
        local collection = dataProvider:GetCollection()
        for i = 1, #collection do
            if collection[i].option.reagentState ~= 0 then
                dataProvider:Remove(collection[i])
                recursion()
                return
            end
        end
    end
    recursion()
end)

-- adds a checkbox to the crafting orders frame
local checkBox = CreateFrame("CheckButton", PublicOrdersReagentsColumnHideOrdersWithoutMaterialsCheckButton, ProfessionsFrame.OrdersPage, "UICheckButtonTemplate")
checkBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 10, 0)
checkBox:RegisterEvent("PLAYER_ENTERING_WORLD")
checkBox:HookScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        checkBox:UnregisterEvent("PLAYER_ENTERING_WORLD")
        if not PublicOrdersReagentsDB then PublicOrdersReagentsDB = {} end
        checkBox:SetChecked(PublicOrdersReagentsDB.hideOrdersWithoutMaterials)
    end
end)
checkBox:SetScript("OnClick", function()
    PublicOrdersReagentsDB.hideOrdersWithoutMaterials = checkBox:GetChecked()
end)
checkBox:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    GameTooltip:SetText("Hide listings that do not provide all the materials")
end)
checkBox:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)
