local addonName, addon = ...

function addon.handleRewardIcons(self, browseType)
    local rewardIcons = self.NMNMRewardIcons or {}
    self.NMNMRewardIcons = rewardIcons
    
    for _, r in pairs(rewardIcons) do
        for _, s in pairs(r) do
            s:Hide()
        end
    end
    
    local rows = self.BrowseFrame.OrderList.ScrollBox:GetView().frames
    local padding = addon.db.global.increasedPadding
    
    for rowID, row in ipairs(rows) do
        if not rewardIcons[rowID] then
            rewardIcons[rowID] = {}
        end
        
        local cell = row.cells[3]
        if not cell.RewardIcon then return end
        local rowData = cell.rowData.option.npcOrderRewards
        for idx, reward in ipairs(rowData) do
            local itemLink = reward.itemLink
            
            local button = rewardIcons[rowID][idx] 
            if not button then
                button = CreateFrame("ItemButton", nil, cell, "ProfessionsCrafterOrderRewardTemplate")
                rewardIcons[rowID][idx] = button
                button:ClearNormalTexture()
                button:ClearPushedTexture()
                button:ClearHighlightTexture()
            end
            
            button:SetSize(19+padding, 19+padding)
            button:SetParent(cell)
            
            if idx == 1 then
                button:SetPoint("TOPRIGHT", cell, "TOPRIGHT", -35, 0)
                cell.RewardIcon:Hide()
            else
                button:SetPoint("TOPRIGHT", rewardIcons[rowID][idx-1], "TOPLEFT")
            end
            button:SetReward(reward)
            button:SetScript("OnClick", function()
                if IsModifiedClick("CHATLINK") then
                    if itemLink then
                        -- the itemlink in the reward table doesn't always have the item name loaded - have to refetch the item link from the item ID
                        local item = Item:CreateFromItemLink(itemLink)
                        item:ContinueOnItemLoad(function()
                            item = Item:CreateFromItemID(item:GetItemID())
                            item:ContinueOnItemLoad(function()
                                ChatEdit_InsertLink(item:GetItemLink())
                            end)
                        end)
                    end
                end
            end)
        end
    end
end