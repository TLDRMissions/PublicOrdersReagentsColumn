local addonName, addon = ...

function addon.handleReagentIcons(self, browseType)
    local reagentIcons = self.NMNMReagentIcons or {}
    self.NMNMReagentIcons = reagentIcons
    
    local missingReagentTextures = self.NMNMMissingReagentTextures or {}
    self.NMNMMissingReagentTextures = missingReagentTextures
    
    for _, r in pairs(reagentIcons) do
        for _, s in pairs(r) do
            s:Hide()
        end
    end
    
    for t in pairs(missingReagentTextures) do
        t:Hide()
    end
    wipe(missingReagentTextures)
    
    if browseType ~= 1 then return end
    
    local rows = self.BrowseFrame.OrderList.ScrollBox:GetView().frames
    local padding = addon.db.global.increasedPadding
    
    for rowID, row in ipairs(rows) do
        if not reagentIcons[rowID] then
            reagentIcons[rowID] = {}
        end
        
        local cell = row.cells[4]
        local rowData = cell.rowData.option
        if rowData.reagentState ~= Enum.CraftingOrderReagentsType.All then
            local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(rowData.spellID, rowData.isRecraft)
            local reagents = recipeSchematic.reagentSlotSchematics
            for i = #reagents, 1, -1 do
                local reagentData = reagents[i]
                if not reagentData.required then
                    table.remove(reagents, i)
                else
                    local found = false
                    for _, reagentChoice in pairs(reagentData.reagents) do
                        for _, providedReagentData in ipairs(rowData.reagents) do
                            if providedReagentData.reagentInfo.reagent.itemID == reagentChoice.itemID then
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
                local button = reagentIcons[rowID][idx]
                if not button then
                    button = CreateFrame("ItemButton", nil, cell, "ProfessionsCrafterOrderRewardTemplate")
                    reagentIcons[rowID][idx] = button
                    button:ClearNormalTexture()
                    button:ClearPushedTexture()
                    button:ClearHighlightTexture()
                    button.noProfessionQualityOverlay = true
                end
                
                button:SetSize(19+padding, 19+padding)
                button:SetParent(cell)
                reagentIcons[rowID][idx] = button
                
                button.Count:SetScale(1)
                if reagentData.quantityRequired > 99 then
                    button.Count:SetScale(0.8)
                end
                
                local numPossessed = 0
                for itemIndex, itemID in pairs(reagentData.reagents) do
                    if (itemIndex == 1) or addon.db.global.highRankReagentsEnabled then
                        numPossessed = numPossessed + ProfessionsUtil.GetReagentQuantityInPossession(itemID, false)
                    end
                end
                
                if numPossessed >= reagentData.quantityRequired then
                    button.Icon:SetDesaturated(false)
                    button.Icon:SetAlpha(1)
                    button.IconBorder:Show()
                else
                    if addon.db.global.desaturateMissingReagents then
                        button.Icon:SetDesaturated(true)
                        button.Icon:SetAlpha(0.5)
                        button.IconBorder:Hide()
                        RunNextFrame(function()
                            button.IconBorder:Hide()
                        end)
                    end
                    
                    if not (row.ErrorTexture and row.ErrorTexture:IsShown()) then
                        -- highlight the cell if player doesn't have all materials
                        local missingReagentTexture = cell.missingReagentTexture or cell:CreateTexture(nil, "OVERLAY")
                        cell.missingReagentTexture = missingReagentTexture
                        missingReagentTexture:SetPoint("TOPLEFT", cell, "TOPLEFT", -5, 0)
                        missingReagentTexture:SetPoint("BOTTOMRIGHT", cell, "BOTTOMRIGHT", -5, 0)
                        missingReagentTextures[missingReagentTexture] = true
                        missingReagentTexture:SetBlendMode("ADD")
                        missingReagentTexture:SetColorTexture(addon.db.global.reagentErrorColor.r, addon.db.global.reagentErrorColor.g, addon.db.global.reagentErrorColor.b, addon.db.global.reagentErrorColor.a)
                        missingReagentTexture:Show()
                    end
                end
                
                if idx == 1 then
                    button:SetPoint("TOPLEFT", cell.Text, "TOPLEFT")
                else
                    button:SetPoint("TOPLEFT", reagentIcons[rowID][idx-1], "TOPRIGHT")
                end
                button:SetReward({count = reagentData.quantityRequired, itemLink = "|cff0070dd|Hitem:"..reagentData.reagents[1].itemID.."|h[]|h|r"})
                button:SetScript("OnClick", function()
                    if IsModifiedClick("CHATLINK") then
                        item = Item:CreateFromItemID(reagentData.reagents[1].itemID)
                        item:ContinueOnItemLoad(function()
                            ChatEdit_InsertLink(item:GetItemLink())
                        end)
                    end
                end)
            end
        end
    end
end