EventUtil.ContinueOnAddOnLoaded("Blizzard_Professions", function()
    hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", function(self, orders, browseType, offset, isSorted)
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
            local cell = row.cells[3]
            if not cell.RewardIcon then return end
            local rowData = cell.rowData.option.npcOrderRewards
            for idx, reward in ipairs(rowData) do
                local quantity = reward.count
                local itemLink = reward.itemLink
                
                if not cell["RewardIcon"..(idx+1)] then
                    cell["RewardIcon"..(idx+1)] = CreateFrame("ItemButton", nil, cell, "ProfessionsCrafterOrderRewardTemplate")
                end
                
                local button = cell["RewardIcon"..(idx+1)]
                button:SetScale(0.5)
                if idx == 1 then
                    button:SetPoint("TOPRIGHT", cell.RewardIcon, "TOPLEFT")
                else
                    button:SetPoint("TOPRIGHT", cell["RewardIcon"..idx], "TOPLEFT")
                end
                button:SetReward(reward)
            end
        end
    end)
end)
