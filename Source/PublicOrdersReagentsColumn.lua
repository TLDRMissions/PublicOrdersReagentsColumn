local rewardIcons = {}
local reagentIcons = {}
local textFields = {}
EventUtil.ContinueOnAddOnLoaded("Blizzard_Professions", function()
    hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", function(self, orders, browseType, offset, isSorted)
        for i, r in pairs(reagentIcons) do
            for j, s in pairs(r) do
                s:Hide()
            end
        end
        for i, r in pairs(rewardIcons) do
            for j, s in pairs(r) do
                s:Hide()
            end
        end
        for t in pairs(textFields) do
            t:Show()
        end
        
        if not C_CraftingOrders.ShouldShowCraftingOrderTab() then
            return
        end
        if ProfessionsFrame:GetTab() ~= ProfessionsFrame.craftingOrdersTabID then
            return
        end
        
        if browseType ~= 1 then return end
        if self.orderType ~= 3 then return end
        
        local rows = self.BrowseFrame.OrderList.ScrollBox:GetView().frames
        
        for rowID, row in ipairs(rows) do
            if not rewardIcons[rowID] then
                rewardIcons[rowID] = {}
            end
            if not reagentIcons[rowID] then
                reagentIcons[rowID] = {}
            end
            local cell = row.cells[3]
            if not cell.RewardIcon then return end
            local rowData = cell.rowData.option.npcOrderRewards
            for idx, reward in ipairs(rowData) do
                local quantity = reward.count
                local itemLink = reward.itemLink
                
                local button = rewardIcons[rowID][idx] or CreateFrame("ItemButton", nil, cell, "ProfessionsCrafterOrderRewardTemplate")
                button:SetParent(cell)
                rewardIcons[rowID][idx] = button
                button:SetScale(0.5)
                button.Count:SetScale(2)
                if idx == 1 then
                    button:SetPoint("TOPRIGHT", cell.RewardIcon, "TOPRIGHT")
                    cell.RewardIcon:Hide()
                else
                    button:SetPoint("TOPRIGHT", rewardIcons[rowID][idx-1], "TOPLEFT")
                end
                button:SetReward(reward)
            end
            
            cell = row.cells[4]
            rowData = cell.rowData.option
            local textField = cell.Text
            textField:Hide()
            textFields[textField] = true
            if rowData.reagentState ~= Enum.CraftingOrderReagentsType.All then
                local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(rowData.spellID, false)
                local reagents = recipeSchematic.reagentSlotSchematics
                for i = #reagents, 1, -1 do
                    local reagentData = reagents[i]
                    if not reagentData.required then
                        table.remove(reagents, i)
                    else
                        local found = false
                        for _, reagentChoice in pairs(reagentData.reagents) do
                            for _, providedReagentData in ipairs(rowData.reagents) do
                                if providedReagentData.reagent.itemID == reagentChoice.itemID then
                                    found = true
                                    break
                                end
                            end
                            if found then break end
                        end
                        if found then
                            table.remove(reagents, i)
                        end
                    end
                end
                for idx, reagentData in ipairs(reagents) do
                    local button = reagentIcons[rowID][idx] or CreateFrame("ItemButton", nil, cell, "ProfessionsCrafterOrderRewardTemplate")
                    button:SetParent(cell)
                    reagentIcons[rowID][idx] = button
                    button:SetScale(0.5)
                    button.Count:SetScale(2)
                    button:Show()
                    if idx == 1 then
                        button:SetPoint("TOPLEFT", textField, "TOPLEFT")
                    else
                        button:SetPoint("TOPLEFT", reagentIcons[rowID][idx-1], "TOPRIGHT")
                    end
                    button:SetReward({count = reagentData.quantityRequired, itemLink = "|cff0070dd|Hitem:"..reagentData.reagents[1].itemID.."|h[]|h|r"})
                end
            end
        end
    end)
end)
