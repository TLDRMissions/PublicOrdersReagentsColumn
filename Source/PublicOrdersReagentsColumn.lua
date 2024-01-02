local addonName = ...

-- the max commission for mats provided column during bucket view
ProfessionsCrafterTableCellMaxMatsProvidedCommissionMixin = CreateFromMixins(TableBuilderCellMixin)

-- Delay entire file until after Blizzard_Professions is loaded
-- Will not make it a dependency or load it myself due to lua errors that are thrown since 10.2 if it is not loaded completely
EventUtil.ContinueOnAddOnLoaded("Blizzard_Professions", function()

-- This might get initialized before saved variables are loaded, if it does, it'll get re-initialized during ADDON_LOADED.
if not PublicOrdersReagentsDB then PublicOrdersReagentsDB = {} end
if not PublicOrdersReagentsDB.minimumCommission then PublicOrdersReagentsDB.minimumCommission = 0 end

-- This code adapted from Blizzard_Professions\Blizzard_ProfessionsCrafterOrderPage.lua
-- The existing function ProfessionsFrame.OrdersPage:SetupTable() hides the Reagents column for Public Orders
-- This code simply shows it again.
hooksecurefunc(ProfessionsFrame.OrdersPage, "SetupTable", function(self)
    local browseType = self:GetBrowseType();
    local PTC = ProfessionsTableConstants;

    if browseType == 2 then
        local column = self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, 80, PTC.Tip.LeftCellPadding,
            PTC.Tip.RightCellPadding, nil, "ProfessionsCrafterTableCellMaxMatsProvidedCommissionTemplate")
        column:ConstructHeader("BUTTON", "ProfessionsCrafterTableHeaderStringTemplate", self, "Mats?")
        self.tableBuilder:Arrange()
    end
end)

local pendingCallback
local busy
local orderToCell = {}
local cellToDetails = {}

-- Attempts to check Auction database addons for the price of reagents
-- Currently supports: Auctionator and TSM
local function auctionatorGetPrice(itemID)
    return Auctionator.API.v1.GetAuctionPriceByItemID("Public Orders Reagents Column", itemID)
end

local function tsmGetPrice(itemID)
    return TSM_API.GetCustomPriceValue("dbminbuyout", "i:"..itemID)
end

local function hasAuctionAddon()
    return TSM_API or IsAddOnLoaded("Auctionator")
end

local function getReagentsCostFromOtherAddons(option)
    local priceLookup
    
    if TSM_API then
        priceLookup = tsmGetPrice
    elseif IsAddOnLoaded("Auctionator") then
        priceLookup = auctionatorGetPrice
    else
        return
    end
    
    local cost
        
    local recipeID = option.spellID
    
    local schematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, option.isRecraft)
    schematic = schematic.reagentSlotSchematics
    for _, schematicData in ipairs(schematic) do
        if schematicData.required and (schematicData.reagentType == 1) then
            local quantity = schematicData.quantityRequired
            local lowestPrice = priceLookup(schematicData.reagents[1].itemID)
            if lowestPrice and (select(14, GetItemInfo(schematicData.reagents[1].itemID)) ~= 1) then -- if item is BOP, don't look up price
                for i = 2, #schematicData.reagents do 
                    local price = priceLookup(schematicData.reagents[i].itemID)
                    if price and (price < lowestPrice) then
                        lowestPrice = price
                    end
                end
                lowestPrice = lowestPrice * quantity
                cost = cost and (cost + lowestPrice) or lowestPrice
            end
        end
    end
    
    if not cost then return end
    return cost/10000
end

-- The existing function ProfessionsFrame.OrdersPage:ShotGeneric is called on the results from clicking the Search button
-- This will hide results without reagents if the option is selected
hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", function(self, orders, browseType, offset, isSorted)
    if not C_CraftingOrders.ShouldShowCraftingOrderTab() then
        return
    end
    if ProfessionsFrame:GetTab() ~= ProfessionsFrame.craftingOrdersTabID then
        return
    end
    
    if browseType == 1 then -- OrderBrowseType.Flat, small number of items, or player clicked into an item
        if (self.orderType == 0) and (not PublicOrdersReagentsDB.hideOrdersWithoutMaterials) then return end
        if (self.orderType == 1) and (not PublicOrdersReagentsDB.hideGuildOrdersWithoutMaterials) then return end
        if (self.orderType == 2) and (not PublicOrdersReagentsDB.hidePersonalOrdersWithoutMaterials) then return end
        
        local dataProvider = self.BrowseFrame.OrderList.ScrollBox:GetDataProvider()
    
        local function recursion()
            local collection = dataProvider:GetCollection()
            for i = 1, #collection do
                if collection[i].option.reagentState ~= 0 then
                    if PublicOrdersReagentsDB.checkAuctionsDB and hasAuctionAddon() then
                        local reagentsCost = getReagentsCostFromOtherAddons(collection[i].option)
                        if (reagentsCost and ((reagentsCost + PublicOrdersReagentsDB.minimumCommission) > (collection[i].option.tipAmount/10000)))
                            or ((not reagentsCost) and (PublicOrdersReagentsDB.minimumCommission > (collection[i].option.tipAmount/10000)))
                                then
                            dataProvider:Remove(collection[i])
                            recursion()
                            return
                        end
                    elseif (PublicOrdersReagentsDB.minimumCommission == 0) or ((collection[i].option.tipAmount/10000) < PublicOrdersReagentsDB.minimumCommission) then
                        dataProvider:Remove(collection[i])
                        recursion()
                        return
                    end
                end
            end
        end
        recursion()
    elseif browseType == 2 then -- OrderBrowseType.Bucketed, a list of items showing number of orders for that item
        local dataProvider = self.BrowseFrame.OrderList.ScrollBox:GetDataProvider()
        local i = 1
        local collection = dataProvider:GetCollection()
        
        local function recursion()
            if i > #collection then return end
            
            local option = collection[i].option
            
            local request =
            {
                orderType = Enum.CraftingOrderType.Public,
                selectedSkillLineAbility = option.skillLineAbilityID,
                searchFavorites = false,
                initialNonPublicSearch = false,
                offset = 0,
                forCrafter = true,
                profession = self.professionInfo.profession,
                primarySort = {
                    sortType = Enum.CraftingOrderSortType.Reagents,
                    reversed = true,
                },
                secondarySort = {
                    sortType = Enum.CraftingOrderSortType.MaxTip,
                    reversed = false,
                },
                callback = C_FunctionContainers.CreateCallback( 
                    function(result, orderType, displayBuckets, expectMoreRows, offset, isSorted)
                        if not C_CraftingOrders.ShouldShowCraftingOrderTab() then return end
                        if ProfessionsFrame:GetTab() ~= ProfessionsFrame.craftingOrdersTabID then return end
                        
                        if orderType ~= Enum.CraftingOrderType.Public then return end
                        if displayBuckets then return end
                    
                        local orders = C_CraftingOrders.GetCrafterOrders()
                        local acceptableFound = false
                        local maxTip = 0
                        local numMatsProvidedAndExpiringSoon = 0
                        
                        for j = 1, #orders do
                            if orders[j].reagentState == 0 then
                                acceptableFound = true
                                if orders[j].tipAmount > maxTip then
                                    maxTip = orders[j].tipAmount
                                end
                                local remainingTime = Professions.GetCraftingOrderRemainingTime(orders[j].expirationTime)
                                if remainingTime <= Constants.ProfessionConsts.PUBLIC_CRAFTING_ORDER_STALE_THRESHOLD then
                                    numMatsProvidedAndExpiringSoon = numMatsProvidedAndExpiringSoon + 1
                                end
                            elseif (not (PublicOrdersReagentsDB.checkAuctionsDB and hasAuctionAddon())) and ((PublicOrdersReagentsDB.minimumCommission == 0) or ((orders[j].tipAmount/10000) < PublicOrdersReagentsDB.minimumCommission))then
                                -- order meets all the exclusion requirements
                            elseif PublicOrdersReagentsDB.checkAuctionsDB and hasAuctionAddon() then
                                local reagentsCost = getReagentsCostFromOtherAddons(orders[j])
                                if reagentsCost and ((reagentsCost + PublicOrdersReagentsDB.minimumCommission) <= (orders[j].tipAmount/10000)) then
                                    acceptableFound = true
                                    local profit = orders[j].tipAmount - (reagentsCost*10000)
                                    if profit > maxTip then
                                        maxTip = profit
                                    end
                                elseif (not reagentsCost) and (PublicOrdersReagentsDB.minimumCommission <= (orders[j].tipAmount/10000)) then
                                    acceptableFound = true
                                    if orders[j].tipAmount > maxTip then
                                        maxTip = orders[j].tipAmount
                                    end
                                end
                            else
                                acceptableFound = true
                                if orders[j].tipAmount > maxTip then
                                    maxTip = orders[j].tipAmount
                                end
                            end
                        end
                        
                        if acceptableFound then
                            local o = orderToCell[option]
                            if o then -- cells off the bottom of the screen wont yet be initialised
                                if numMatsProvidedAndExpiringSoon > 0 then
                                    ProfessionsTableCellTextMixin.SetText(o, "\124cffFF0000"..math.floor(maxTip/10000)..GOLD_AMOUNT_SYMBOL.."\124r")
                                else
                                    ProfessionsTableCellTextMixin.SetText(o, math.floor(maxTip/10000)..GOLD_AMOUNT_SYMBOL)
                                end
                                cellToDetails[o] = {
                                    ["maxTip"] = maxTip,
                                    ["numMatsProvidedAndExpiringSoon"] = numMatsProvidedAndExpiringSoon,
                                }
                            end
                            i = i + 1
                        else
                            if  ((self.orderType == 0) and PublicOrdersReagentsDB.hideOrdersWithoutMaterials) or
                                ((self.orderType == 1) and PublicOrdersReagentsDB.hideGuildOrdersWithoutMaterials) or
                                ((self.orderType == 2) and PublicOrdersReagentsDB.hidePersonalOrdersWithoutMaterials) then
                                    dataProvider:Remove(collection[i])
                            else
                                local o = orderToCell[option]
                                if o then
                                    ProfessionsTableCellTextMixin.SetText(o, "None")
                                    cellToDetails[o] = nil
                                end
                                i = i + 1
                            end
                        end
                        
                        pendingCallback = nil
                        
                        recursion()
                    end),
            }
            pendingCallback = request.callback
            busy = true
            C_CraftingOrders.RequestCrafterOrders(request)
            busy = false
        end
        recursion()
    end
end)

-- workaround for if a player clicks into an item during Bucket View before filtering has finished
hooksecurefunc(C_CraftingOrders, "RequestCrafterOrders", function()
    if not C_CraftingOrders.ShouldShowCraftingOrderTab() then
        return
    end
    if ProfessionsFrame:GetTab() ~= ProfessionsFrame.craftingOrdersTabID then
        return
    end
        
    if pendingCallback and (not busy) then
        pendingCallback:Cancel()
    end
end)

-- adds a checkbox to the crafting orders frame
local function createCheckBox(variableName)
    local checkBox = CreateFrame("CheckButton", nil, ProfessionsFrame.OrdersPage, "PublicOrdersReagentsColumnCheckButtonTemplate")
    checkBox:SetPoint("TOPLEFT", ProfessionsFrame, "TOPRIGHT", 4, -36)
    checkBox:SetScript("OnClick", function()
        PublicOrdersReagentsDB[variableName] = checkBox:GetChecked()
    end)
    checkBox:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
        GameTooltip:SetText("Hide orders that do not provide all the materials")
        PublicOrdersReagentsColumnMinimumCommissionFrame:Show()
    end)
    checkBox:SetScript("OnLeave", function()
        GameTooltip:Hide()
        if not PublicOrdersReagentsColumnMinimumCommissionFrame:IsMouseOver() then
            PublicOrdersReagentsColumnMinimumCommissionFrame:Hide()
        end
    end)
    checkBox:SetNormalTexture(3566850)
    return checkBox
end

local publicCheckBox = createCheckBox("hideOrdersWithoutMaterials")
local guildCheckBox = createCheckBox("hideGuildOrdersWithoutMaterials")
local privateCheckBox = createCheckBox("hidePersonalOrdersWithoutMaterials")
local activeCheckBox = publicCheckBox
guildCheckBox:Hide()
privateCheckBox:Hide()

EventUtil.ContinueOnAddOnLoaded(addonName, function()
    if not PublicOrdersReagentsDB then PublicOrdersReagentsDB = {} end
    if not PublicOrdersReagentsDB.minimumCommission then PublicOrdersReagentsDB.minimumCommission = 0 end
    publicCheckBox:SetChecked(PublicOrdersReagentsDB.hideOrdersWithoutMaterials)
    guildCheckBox:SetChecked(PublicOrdersReagentsDB.hideGuildOrdersWithoutMaterials)
    privateCheckBox:SetChecked(PublicOrdersReagentsDB.hidePersonalOrdersWithoutMaterials)
    
    PublicOrdersReagentsColumnMinimumCommissionFrame.CheckButton1:SetChecked(not PublicOrdersReagentsDB.checkAuctionsDB)
    PublicOrdersReagentsColumnMinimumCommissionFrame.CheckButton2:SetChecked(PublicOrdersReagentsDB.checkAuctionsDB)
    
    PublicOrdersReagentsColumnMinimumCommissionSlider:SetValue(PublicOrdersReagentsDB.minimumCommission or 0)
end)

-- minimum commission frame with slider
local commissionFrame = CreateFrame("Frame", "PublicOrdersReagentsColumnMinimumCommissionFrame", activeCheckBox)
commissionFrame:Hide()
commissionFrame:SetSize(330, 200)
commissionFrame:SetPoint("TOP", activeCheckBox, "BOTTOM")
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

commissionFrame.CheckButton1 = CreateFrame("CheckButton", nil, PublicOrdersReagentsColumnMinimumCommissionFrame, "UICheckButtonTemplate")
commissionFrame.CheckButton1:SetSize(40, 40)
commissionFrame.CheckButton1:SetPoint("TOPLEFT", commissionFrame.Slider, "BOTTOMLEFT", -10, -10)
commissionFrame.CheckButton1:SetChecked(true)
commissionFrame.CheckButton1:HookScript("OnClick", function(self)
    PublicOrdersReagentsDB.checkAuctionsDB = not self:GetChecked()
    commissionFrame.CheckButton2:SetChecked(not self:GetChecked())
end)

commissionFrame.Label1 = commissionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
commissionFrame.Label1:SetPoint("LEFT", commissionFrame.CheckButton1, "RIGHT", 0, 0)
commissionFrame.Label1:SetText("show the order if this much commission")
commissionFrame.Label1:SetWordWrap(true)
commissionFrame.Label1:SetWidth(260)

commissionFrame.CheckButton2 = CreateFrame("CheckButton", nil, PublicOrdersReagentsColumnMinimumCommissionFrame, "UICheckButtonTemplate")
commissionFrame.CheckButton2:SetSize(40, 40)
commissionFrame.CheckButton2:SetPoint("TOP", commissionFrame.CheckButton1, "BOTTOM", 0, 0)
commissionFrame.CheckButton2:HookScript("OnClick", function(self)
    PublicOrdersReagentsDB.checkAuctionsDB = self:GetChecked()
    commissionFrame.CheckButton1:SetChecked(not self:GetChecked())
end)

commissionFrame.Label2 = commissionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
commissionFrame.Label2:SetPoint("LEFT", commissionFrame.CheckButton2, "RIGHT", 0, 0)
commissionFrame.Label2:SetText("this much profit based on Auctionator or TSM data")
commissionFrame.Label2:SetWordWrap(true)
commissionFrame.Label2:SetWidth(260)

commissionFrame:SetScript("OnLeave", function()
    if (not activeCheckBox:IsMouseOver()) and (not PublicOrdersReagentsColumnMinimumCommissionFrame:IsMouseOver()) then
        commissionFrame:Hide()
    end
    C_Timer.After(0.1, function()
        if (not activeCheckBox:IsMouseOver()) and (not PublicOrdersReagentsColumnMinimumCommissionFrame:IsMouseOver()) then
            commissionFrame:Hide()
        end
    end)
end)

function ProfessionsCrafterTableCellMaxMatsProvidedCommissionMixin:Populate(rowData, dataIndex)
    local order = rowData.option
    orderToCell[order] = self
    ProfessionsTableCellTextMixin.SetText(self, "?")
    
    self:SetScript("OnEnter", function()
        self:GetParent():OnEnter()
        local details = cellToDetails[self]
        if details and details.numMatsProvidedAndExpiringSoon and details.maxTip then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine("Has mats")
            GameTooltip:AddLine("Highest commission with mats: "..math.floor(details.maxTip/10000)..GOLD_AMOUNT_SYMBOL)
            if (details.numMatsProvidedAndExpiringSoon > 0) then
                GameTooltip:AddLine(details.numMatsProvidedAndExpiringSoon.." expiring soon!")
            end
            GameTooltip:Show()
        end
    end)
    
    self:SetScript("OnLeave", function()
        self:GetParent():OnLeave()
        GameTooltip:Hide()
    end)
    
    self:SetScript("OnMouseDown", function()
        self:GetParent():Click()
    end)
end

-- handle user changing tab public/guild/private
-- Blizzard calls this function: during the frame's OnLoad, and for events PLAYER_GUILD_UPDATE and PLAYER_ENTERING_WORLD
-- They reset the Script handler every time, so I have to re-hook the script handler all over again
local function setupOrdersButtonHooks()
    ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton:HookScript("OnClick", function()
        activeCheckBox = publicCheckBox
        publicCheckBox:Show()
        guildCheckBox:Hide()
        privateCheckBox:Hide()
        commissionFrame:SetParent(activeCheckBox)
        commissionFrame:SetFrameStrata("TOOLTIP")
    end)
    
    ProfessionsFrame.OrdersPage.BrowseFrame.GuildOrdersButton:HookScript("OnClick", function()
        activeCheckBox = guildCheckBox
        publicCheckBox:Hide()
        guildCheckBox:Show()
        privateCheckBox:Hide()
        commissionFrame:SetParent(activeCheckBox)
        commissionFrame:SetFrameStrata("TOOLTIP")
    end)
    
    ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton:HookScript("OnClick", function()
        activeCheckBox = privateCheckBox
        publicCheckBox:Hide()
        guildCheckBox:Hide()
        privateCheckBox:Show()
        commissionFrame:SetParent(activeCheckBox)
        commissionFrame:SetFrameStrata("TOOLTIP")
    end)
end
hooksecurefunc(ProfessionsFrame.OrdersPage, "InitOrderTypeTabs", setupOrdersButtonHooks)
setupOrdersButtonHooks()

end) -- end of EventUtil.ContinueOnAddOnLoaded
