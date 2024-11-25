local addonName, addon = ...

local frame = PublicOrdersReagentsColumnToolSelectionFrame
local L = addon.ToolSelectionLocales

local db
EventUtil.ContinueOnAddOnLoaded(addonName, function()
    if not PublicOrdersReagentsColumnToolSelectionDB then
        PublicOrdersReagentsColumnToolSelectionDB = {}
    end
    db = PublicOrdersReagentsColumnToolSelectionDB
    local nameRealm = UnitName("player").."-"..GetRealmName()
    if not db[nameRealm] then
        db[nameRealm] = {}
    end
    db = db[nameRealm]
end)

local function getProfessionDB()
    if not db[ProfessionsFrame.professionInfo.profession] then
        db[ProfessionsFrame.professionInfo.profession] = {}
    end
    return db[ProfessionsFrame.professionInfo.profession]
end

local function getActiveToolSlotID()
    if ProfessionsFrame.CraftingPage.Prof0ToolSlot:IsShown() then
        return 20
    elseif ProfessionsFrame.CraftingPage.Prof1ToolSlot:IsShown() then
        return 23
    end
end

local function handleButtonClick(stat)
    local infoType, itemID, itemLink = GetCursorInfo()
    
    if infoType == nil then
        getProfessionDB()[stat] = nil
        return
    end
    
    if infoType ~= "item" then return end
    
    local activeToolSlot = getActiveToolSlotID()
    if not activeToolSlot then return end
    if not C_PaperDollInfo.CanCursorCanGoInSlot(getActiveToolSlotID()) then return end
    
    if itemLink == getProfessionDB()[stat] then
        getProfessionDB()[stat] = nil
    else
        getProfessionDB()[stat] = itemLink
    end
    
    ClearCursor()
end

local function escapeItemLink(itemLink)
    -- example itemstring:
    -- |cff0070dd|Hitem:222576:7373:::::::73:253::13:4:10828:10830:9632:8953:5:28:2734:29:76:38:8:40:2259:45:222634::::Player-1597-0F963060:|h[Patient Alchemist's Mixing Rod |A:Professions-ChatIcon-Quality-Tier5:17:17::1|a]|h|r
    -- the :73: is "level the character was when they saved this item"
    -- lets ignore that as the character can level up
    if not itemLink then return end
    return itemLink:gsub("(item:%d*:%d*:%d*:%d*:%d*:%d*:%d*:%d*)(:%d*:)", "%1::")
end

-- first return param: 1 if equipped, 2 if in bags
local function getItemLocation(itemLink)
    itemLink = escapeItemLink(itemLink)
    if escapeItemLink(GetInventoryItemLink("player", 20)) == itemLink then
        return 1, 20
    elseif escapeItemLink(GetInventoryItemLink("player", 23)) == itemLink then
        return 1, 23
    end

    for containerIndex = 0, 4 do
        for slotIndex = 1, 100 do
            if escapeItemLink(C_Container.GetContainerItemLink(containerIndex, slotIndex)) == itemLink then
                return 2, containerIndex, slotIndex
            end
        end
    end
    
    return nil
end

for _, statButton in pairs(frame.statButtons) do
    statButton:HookScript("OnClick", function(self, button)
        if ( IsModifiedClick() ) then
    		HandleModifiedItemClick(getProfessionID()[self.stat])
    	else
    		handleButtonClick(self.stat)
            self:Hide()
            self:Show()
    	end
    end)
    
    statButton:HookScript("OnShow", function(self)
        PublicOrdersReagentsColumnToolSelectionFrame.DisableButton:SetChecked(db.disabled)
        
        if getProfessionDB()[self.stat] then
            local itemLink = getProfessionDB()[self.stat]
            local locationType = getItemLocation(itemLink)
            if not locationType then
                self.ignoreTexture:Show()
            end
            local itemID = C_Item.GetItemInfoInstant(itemLink)
            self:SetItem(itemID)
        else
            self:Reset()
            self.ignoreTexture:Hide()
        end
    end)

    statButton:HookScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        local itemLink = getProfessionDB()[self.stat]
        if itemLink then
            GameTooltip:SetHyperlink(itemLink)
            GameTooltip:AddLine(" ")
            if not getItemLocation(itemLink) then
                GameTooltip:AddLine(L["TOOLTIP_ERROR_NOT_FOUND"], nil, nil, nil, true)
            elseif self.stat == "Resourcefulness" then
                GameTooltip:AddLine(L["TOOLTIP_RESOURCEFULNESS_DETAIL"], nil, nil, nil, true)
            elseif self.stat == "Multicraft" then
                GameTooltip:AddLine(L["TOOLTIP_MULTICRAFT_DETAIL"], nil, nil, nil, true)
            elseif self.stat == "Ingenuity" then
                GameTooltip:AddLine(L["TOOLTIP_INGENUITY_DETAIL"], nil, nil, nil, true)
            elseif self.stat == "Speed" then
                GameTooltip:AddLine(L["TOOLTIP_SPEED_DETAIL"], nil, nil, nil, true)
            end
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(L["TOOLTIP_FINAL_DETAIL"])
        else
            GameTooltip:AddLine(string.format(L["TOOLTIP_EMPTY_BUTTON"], self.Text:GetText()), nil, nil, nil, true)
        end
        GameTooltip:Show()
    end)
    statButton:HookScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    statButton:SetScript("OnReceiveDrag", function(self)
        handleButtonClick(self.stat)
        self:Hide()
        self:Show()
    end)
end

local function equipTool(slotName)
    local itemLink = getProfessionDB()[slotName]
    if not itemLink then return end
    
    local locationType, containerIndex, slotIndex = getItemLocation(itemLink)
    
    if not locationType then
        -- can't find it
        return
    end
    
    if locationType == 1 then
        -- its already equipped
        return true
    end
    
    C_Container.PickupContainerItem(containerIndex, slotIndex)
    PickupInventoryItem(getActiveToolSlotID())
    C_Timer.After(0.2, function() ClearCursor() end)
    return true
end

local function equipResourcefulnessTool()
    return equipTool("Resourcefulness")
end

local function equipIngenuityTool()
    return equipTool("Ingenuity")
end

local function equipMulticraftTool()
    return equipTool("Multicraft")
end

local function equipCraftingSpeedTool()
    return equipTool("Speed")
end

-- This is the Recipes tab - can ignore work orders here
hooksecurefunc(ProfessionsFrame.CraftingPage.SchematicForm, "UpdateDetailsStats", function(self, operationInfo)
    if not addon.getToolFlyoutEnabled() then return end
    if not operationInfo then return end
    if db.disabled then return end

    local usesResourcefulness, usesMulticraft, usesSpeed
    
    for _, statDetails in pairs(operationInfo.bonusStats) do
        local statName = statDetails.bonusStatName
        if statName == ITEM_MOD_RESOURCEFULNESS_SHORT then
            usesResourcefulness = true
        elseif statName == ITEM_MOD_MULTICRAFT_SHORT then
            usesMulticraft = true
        elseif statName == ITEM_MOD_CRAFTING_SPEED_SHORT then
            usesSpeed = true
        end
    end
    
    if db.ingenuityPriority then
        if ProfessionsFrame.CraftingPage.SchematicForm.Details.CraftingChoicesContainer.ConcentrateContainer.ConcentrateToggleButton:GetChecked() then
            if equipIngenuityTool() then
                return
            end
        end
    end
    
    if usesMulticraft then
        if equipMulticraftTool() then
            return
        end
    end
    
    if not db.ingenuityPriority then
        if ProfessionsFrame.CraftingPage.SchematicForm.Details.CraftingChoicesContainer.ConcentrateContainer.ConcentrateToggleButton:GetChecked() then
            if equipIngenuityTool() then
                return
            end
        end
    end
    
    if usesResourcefulness then
        if equipResourcefulnessTool() then
            return
        end
    end
    
    if usesSpeed then
        equipCraftingSpeedTool()
    end
end)

-- This is the work orders tab
hooksecurefunc(ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm, "UpdateDetailsStats", function(self, operationInfo)
    if not addon.getToolFlyoutEnabled() then return end
    if db.disabled then return end
    if not ProfessionsFrame.professionInfo.profession then return end
    
    if ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.Details.CraftingChoicesContainer.ConcentrateContainer.ConcentrateToggleButton:GetChecked() then
        if equipIngenuityTool() then
            return
        end
    end
    
    equipResourcefulnessTool()
end)

PublicOrdersReagentsColumnToolSelectionFrame.DisableButton.Text:SetText(L["DISABLE_BUTTON_TEXT"])
PublicOrdersReagentsColumnToolSelectionFrame.DisableButton:HookScript("OnClick", function(self, button, ...)
    db.disabled = self:GetChecked()
end)
PublicOrdersReagentsColumnToolSelectionFrame.DisableButton:HookScript("OnShow", function(self)
    self:SetChecked(db.disabled)
end)

local function setPriorityButtonText()
    local button = PublicOrdersReagentsColumnToolSelectionFrame.PriorityButton
    if button:GetChecked() then
        button.Text:SetText(L["PRIORTY_BUTTON_SELECTED_TEXT"])
    else
        button.Text:SetText(L["PRIORTY_BUTTON_DESELECTED_TEXT"])
    end
end

PublicOrdersReagentsColumnToolSelectionFrame.PriorityButton:HookScript("OnShow", function(self)
    self:SetChecked(db.ingenuityPriority)
    setPriorityButtonText()
end)
PublicOrdersReagentsColumnToolSelectionFrame.PriorityButton:HookScript("OnClick", function(self)
    db.ingenuityPriority = self:GetChecked()
    setPriorityButtonText()
end)
PublicOrdersReagentsColumnToolSelectionFrame.PriorityButton:HookScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine(L["PRIORITY_BUTTON_TOOLTIP"], nil, nil, nil, true)
    GameTooltip:Show()
end)
PublicOrdersReagentsColumnToolSelectionFrame.PriorityButton:HookScript("OnLeave", function(self)
    GameTooltip:Hide()
end)