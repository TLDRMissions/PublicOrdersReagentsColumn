local addonName, addon = ...

local rewardIconsPrimary, rewardIconsDuplicate = {}, {}
local reagentIconsPrimary, reagentIconsDuplicate = {}, {}
local textFieldsPrimary, textFieldsDuplicate = {}, {}
local errorTexturesPrimary, errorTexturesDuplicate = {}, {}
local priorityTexturesPrimary, priorityTexturesDuplicate = {}, {}
local buttonRegistered = {}

function addon.getOneTimeUniqueID(row)
    local data = row.rowData.option
    return tostring(data.orderID)..data.expirationTime
end

function addon.markRowOneTimeHidden(row)
    local uid = addon.getOneTimeUniqueID(row)
    addon.db.profile.suppressedListingOneTime[uid] = true
end

function addon.unmarkRowOneTimeHidden(row)
    local uid = addon.getOneTimeUniqueID(row)
    addon.db.profile.suppressedListingOneTime[uid] = nil
end

function addon.getPermanentUniqueID(row, withCommission)
    local data = row.rowData.option
    local itemID = data.itemID
    local reagents = ""
    for _, reagentData in ipairs(data.reagents) do
        local reagent = reagentData.reagentInfo.reagent
        if reagent.itemID then
            reagents = reagents..reagent.itemID
        elseif reagent.currencyID then
            reagents = reagents..reagent.currencyID
        else
            -- reagent is something besides a currency or an item?
            print("NoMatsNoMake: getPermanentUniqueID error, notify author!")
            for k, v in pairs(reagent) do
                print(k, v)
            end
        end
    end
    local commission = ""
    if withCommission and data.npcOrderRewards then
        for _, rewardData in ipairs(data.npcOrderRewards) do
            if not rewardData.itemLink then
                zzzz = rewardData
            end
            
            if rewardData.currencyType then
                commission = commission..rewardData.currencyType
            elseif rewardData.itemLink then
                commission = commission..rewardData.itemLink
            end
            
            commission = commission..rewardData.count
        end
    end
    return itemID..reagents..commission
end

function addon.markRowPermanentlyHidden(row, withCommission)
    local uid = addon.getPermanentUniqueID(row, withCommission)
    if withCommission then
        addon.db.profile.suppressedListingPermanentWithCommission[uid] = true
    else
        addon.db.profile.suppressedListingPermanent[uid] = true
    end
end

function addon.unmarkRowPermanentlyHidden(row)
    local uid = addon.getPermanentUniqueID(row, true)
    addon.db.profile.suppressedListingPermanentWithCommission[uid] = nil
    uid = addon.getPermanentUniqueID(row)
    addon.db.profile.suppressedListingPermanent[uid] = nil
end

function addon.isRowMarkedSuppressed(row) 
    return addon.db.profile.suppressedListingOneTime[addon.getOneTimeUniqueID(row)] or addon.db.profile.suppressedListingPermanent[addon.getPermanentUniqueID(row)] or addon.db.profile.suppressedListingPermanentWithCommission[addon.getPermanentUniqueID(row, true)]
end

local function showGeneric(self, _, browseType)
    local rewardIcons = rewardIconsPrimary
    local reagentIcons = reagentIconsPrimary
    local textFields = textFieldsPrimary
    local errorTextures = errorTexturesPrimary
    local priorityTextures = priorityTexturesPrimary
    
    if self == ProfessionsFrame.OrdersPageOffline then
        rewardIcons = rewardIconsDuplicate
        reagentIcons = reagentIconsDuplicate
        textFields = textFieldsDuplicate
        errorTextures = errorTexturesDuplicate
        priorityTextures = priorityTexturesDuplicate
    end
    
    for _, r in pairs(reagentIcons) do
        for _, s in pairs(r) do
            s:Hide()
        end
    end
    for _, r in pairs(rewardIcons) do
        for _, s in pairs(r) do
            s:Hide()
        end
    end
    
    if self.orderType == Enum.CraftingOrderType.Public then
        for t in pairs(textFields) do
            t:Show()
        end
    end
    
    for t in pairs(errorTextures) do
        t:Hide()
    end
    
    for t in pairs(priorityTextures) do
        t:Hide()
    end
    
    local rows = self.BrowseFrame.OrderList.ScrollBox:GetView().frames

    if browseType ~= 1 then
        -- if rows were previously faded out, and we have switched to category view, then fade the rows back in
        for _, row in ipairs(rows) do
            if math.floor(row:GetAlpha()*10) == 2 then
                row:SetAlpha(1)
            end
        end
        return
    end
    
    for _, row in ipairs(rows) do
        -- highlight red rows with unlearned recipes
        local skillLineAbilityID = row.rowData.option.skillLineAbilityID
        local recipeInfo = C_TradeSkillUI.GetRecipeInfoForSkillLineAbility(skillLineAbilityID)
        local errorTexture = row.ErrorTexture or row:CreateTexture(nil, "OVERLAY")
        row.ErrorTexture = errorTexture
        errorTexture:SetPoint("TOPLEFT", row, "TOPLEFT")
        errorTexture:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT")
        errorTextures[errorTexture] = true
        errorTexture:Hide()
        errorTexture:SetBlendMode("ADD")
        errorTexture:SetColorTexture(1, 0, 0, 0.15)
        if not recipeInfo.learned then
            errorTexture:Show()
        end
    end

    -- Listen for right clicks on the name cell
    for _, row in ipairs(rows) do
        if not buttonRegistered[row] then
            row:HookScript("OnClick", function(self, button)
                if button ~= "RightButton" then return end
                
        		
                -- Customized from Blizzard_ProfessionsCrafterOrderPage.lua, ProfessionsCrafterOrderListElementMixin:OnClick(button)
                MenuUtil.CreateContextMenu(self, function(_, rootDescription)
        			rootDescription:SetTag("MENU_PROFESSIONS_CRAFTER_ORDER");

        			local recipeID = self.option.spellID;
        			local currentlyFavorite = C_TradeSkillUI.IsRecipeFavorite(recipeID);
        			local text = currentlyFavorite and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE;
        			rootDescription:CreateButton(text, function()
        				C_TradeSkillUI.SetRecipeFavorite(recipeID, not currentlyFavorite);
        			end);

        			if self.orderType == Enum.CraftingOrderType.Personal then
        				rootDescription:CreateButton(PROFESSIONS_DECLINE_ORDER, function()
        					local emptyRejectionNote = "";
        					C_CraftingOrders.RejectOrder(self.option.orderID, emptyRejectionNote, self.professionInfo.profession);
        				end);
        			end
                    
                    if addon.isRowMarkedSuppressed(row) then
                        rootDescription:CreateButton("Unfade listings like this", function()
                            addon.unmarkRowOneTimeHidden(row)
                            addon.unmarkRowPermanentlyHidden(row)
                            row:SetAlpha(1)
                        end)
                    else
                        rootDescription:CreateButton("Fade this listing (just this time)", function()
                            addon.markRowOneTimeHidden(row)
                            row:SetAlpha(0.2)
                        end)
                        
                        rootDescription:CreateButton("Always fade listings like this (item + reagent combination)", function()
                            addon.markRowPermanentlyHidden(row)
                            row:SetAlpha(0.2)
                        end)
                        
                        rootDescription:CreateButton("Always fade listings like this (item + reagent + commission combination)", function()
                            addon.markRowPermanentlyHidden(row, true)
                            row:SetAlpha(0.2)
                        end)
                    end
        		end);
            end)
            buttonRegistered[row] = true
        end
    end
    
    for _, row in ipairs(rows) do
        -- fade out rows we have marked hidden
        if addon.isRowMarkedSuppressed(row) then
            row:SetAlpha(0.2)
        elseif math.floor(row:GetAlpha()*10) == 2 then
            row:SetAlpha(1)
        end
    end
    
    -- Public orders already have to provide all materials, so no need to show reagent icons or highlight them
    if self.orderType == Enum.CraftingOrderType.Public then return end

    -- resize the commission and reagents columns
    local columns = self.tableBuilder:GetColumns()
    
    -- This is the old, simple way. Unfortunately, as of 12.0 it spreads taint which eventually reaches GameTooltip and causes secret errors.
    --local commissionColumn, reagentColumn = columns[3], columns[4]
    --commissionColumn.fixedWidth = 100
    --reagentColumn.fixedWidth = 130
    --self.tableBuilder:Arrange()
	
    for columnIndex, column in ipairs(columns) do
		local header = column.headerFrame
        if columnIndex == 3 then
            -- commission column
            header:SetWidth(100)
            
            for _, row in pairs(column.table.rows) do
                self.tableBuilder:ArrangeHorizontally(row.cells[3], row.cells[2], 100, "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", -25)
            end
        elseif columnIndex == 4 then
            -- reagent column
            header:SetWidth(130)
            for _, row in pairs(column.table.rows) do
                self.tableBuilder:ArrangeHorizontally(row.cells[4], row.cells[3], 130, "TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", 25)
            end
        end   
	end
    
    
    local padding = addon.db.global.increasedPadding
    for rowID, row in ipairs(rows) do
        if padding then
            row:SetHeight(row:GetHeight() + padding)
            if rowID > 1 then
                local a,b,c,d,e = row:GetPoint()
                row:SetPoint(a,b,c,d,e - (padding * (rowID-1)))
            end
        end
        
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
        
        cell = row.cells[4]
        rowData = cell.rowData.option
        local textField = cell.Text
        textField:Hide()
        textFields[textField] = true
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
                    button =  CreateFrame("ItemButton", nil, cell, "ProfessionsCrafterOrderRewardTemplate")
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
                
                if idx == 1 then
                    button:SetPoint("TOPLEFT", textField, "TOPLEFT")
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
        else
            -- if recipe has all materials provided, highlight it
            -- don't highlight it as priority if its already highlighted as error
            if (not row.ErrorTexture) or (not row.ErrorTexture:IsShown()) then
                local priorityTexture = row.PriorityTexture or row:CreateTexture(nil, "OVERLAY")
                row.PriorityTexture = priorityTexture
                priorityTexture:SetPoint("TOPLEFT", row, "TOPLEFT")
                priorityTexture:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT")
                priorityTextures[priorityTexture] = true
                priorityTexture:SetBlendMode("ADD")
                priorityTexture:SetColorTexture(0, 1, 0, 0.15)
                priorityTexture:Show()
            end
        end
    end
end

EventUtil.ContinueOnAddOnLoaded("Blizzard_Professions", function()
    hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", showGeneric)
    RunNextFrame(function() hooksecurefunc(ProfessionsFrame.OrdersPageOffline, "ShowGeneric", showGeneric) end)
    
    hooksecurefunc(ProfessionsCrafterTableCellCommissionMixin, "Populate", function(self)
        if ProfessionsFrame.OrdersPage.browseType ~= 1 then return end
        local goldButton = self.TipMoneyDisplayFrame.GoldDisplay
        local silverButton = self.TipMoneyDisplayFrame.SilverDisplay
        local copperButton = self.TipMoneyDisplayFrame.CopperDisplay
        if ProfessionsFrame.OrdersPage.orderType ~= 3 then
            goldButton:SetPoint("RIGHT", silverButton, "RIGHT", -36, 0)
            return
        end
        silverButton:Hide()
		goldButton:SetPoint("RIGHT", copperButton, "RIGHT", 0, 0)
    end)
end)

PublicOrdersReagentsColumnProfessionsCrafterTableCellExpirationMixin = CreateFromMixins(TableBuilderCellMixin);

function PublicOrdersReagentsColumnProfessionsCrafterTableCellExpirationMixin:Populate(rowData)
	local order = rowData.option;
	local remainingTime = Professions.GetCraftingOrderRemainingTime(order.expirationTime);
	local seconds = remainingTime >= 60 and remainingTime or 60; -- Never show < 1min
	self.remainingTime = seconds;
	local timeText = Professions.OrderTimeLeftFormatter:Format(seconds);
	if seconds <= Constants.ProfessionConsts.PUBLIC_CRAFTING_ORDER_STALE_THRESHOLD then
		timeText = ERROR_COLOR:WrapTextInColorCode(timeText);
	end
	ProfessionsTableCellTextMixin.SetText(self, timeText);
end

function PublicOrdersReagentsColumnProfessionsCrafterTableCellExpirationMixin:OnEnter()
	self:GetParent().HighlightTexture:Show();

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	local noSeconds = true;
	GameTooltip_AddNormalLine(GameTooltip, AUCTION_HOUSE_TOOLTIP_DURATION_FORMAT:format(SecondsToTime(self.remainingTime, noSeconds)));
	if self.remainingTime <= Constants.ProfessionConsts.PUBLIC_CRAFTING_ORDER_STALE_THRESHOLD and self.rowData.option.orderType == Enum.CraftingOrderType.Public then
		GameTooltip_AddBlankLineToTooltip(GameTooltip);
		GameTooltip_AddNormalLine(GameTooltip, PROFESSIONS_ORDER_ABOUT_TO_EXPIRE);
	end
	GameTooltip:Show();
end

function PublicOrdersReagentsColumnProfessionsCrafterTableCellExpirationMixin:OnLeave()
	self:GetParent().HighlightTexture:Hide();

	GameTooltip:Hide();
end