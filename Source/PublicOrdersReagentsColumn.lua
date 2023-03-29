-- This code adapted from Blizzard_Professions\Blizzard_ProfessionsCrafterOrderPage.lua
-- The existing function ProfessionsFrame.OrdersPage:SetupTable() hides the Reagents column for Public Orders
-- This code simply shows it again.
hooksecurefunc(ProfessionsFrame.OrdersPage, "SetupTable", function(self)
    local browseType = self:GetBrowseType();
    local PTC = ProfessionsTableConstants;

    if browseType == 1 then
        if self.orderType == Enum.CraftingOrderType.Public then
            self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Reagents.Width, PTC.Reagents.LeftCellPadding,
                PTC.Reagents.RightCellPadding, ProfessionsSortOrder.Reagents, "ProfessionsCrafterTableCellReagentsTemplate")
        end
        self.tableBuilder:Arrange()
    elseif browseType == 2 then
        local column = self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, 50, PTC.Tip.LeftCellPadding,
            PTC.Tip.RightCellPadding, nil, "ProfessionsCrafterTableCellMaxMatsProvidedCommissionTemplate")
        column:ConstructHeader("BUTTON", "ProfessionsCrafterTableHeaderStringTemplate", self, "Mats?")
        self.tableBuilder:Arrange()
    end
end)

local pendingCallback
local busy
local orderToCell = {}

-- The existing function ProfessionsFrame.OrdersPage:ShotGeneric is called on the results from clicking the Search button
-- This will hide results without reagents if the option is selected
hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", function(self, orders, browseType, offset, isSorted)
    if browseType == 1 then -- OrderBrowseType.Flat, small number of items, or player clicked into an item
        if (self.orderType == 0) and (not PublicOrdersReagentsDB.hideOrdersWithoutMaterials) then return end
        if (self.orderType == 1) and (not PublicOrdersReagentsDB.hideGuildOrdersWithoutMaterials) then return end
        if (self.orderType == 2) and (not PublicOrdersReagentsDB.hidePrivateOrdersWithoutMaterials) then return end
        
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
                        if orderType ~= Enum.CraftingOrderType.Public then return end
                        if displayBuckets then return end
                    
                        local orders = C_CraftingOrders.GetCrafterOrders()
                        local acceptableFound = false
                        local maxTip = 0
                        
                        -- with sorting by reagents availability, probably only need to check the first result
                        for j = 1, #orders do
                            if orders[j].reagentState == 0 then
                                acceptableFound = true
                                if orders[j].tipAmount > maxTip then
                                    maxTip = orders[j].tipAmount
                                end
                            end
                            if (PublicOrdersReagentsDB.minimumCommission == 0) or ((orders[j].tipAmount/10000) < PublicOrdersReagentsDB.minimumCommission) then
                                -- order meets all the exclusion requirements
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
                                ProfessionsTableCellTextMixin.SetText(o, math.floor(maxTip/10000)..GOLD_AMOUNT_SYMBOL)
                            end
                            i = i + 1
                        else
                            if  ((self.orderType == 0) and PublicOrdersReagentsDB.hideOrdersWithoutMaterials) or
                                ((self.orderType == 1) and PublicOrdersReagentsDB.hideGuildOrdersWithoutMaterials) or
                                ((self.orderType == 2) and PublicOrdersReagentsDB.hidePrivateOrdersWithoutMaterials) then
                                    dataProvider:Remove(collection[i])
                            else
                                local o = orderToCell[option]
                                if o then
                                    ProfessionsTableCellTextMixin.SetText(o, "None")
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
    if pendingCallback and (not busy) then
        pendingCallback:Cancel()
    end
end)

-- adds a checkbox to the crafting orders frame
local function createCheckBox(variableName)
    local checkBox = CreateFrame("CheckButton", nil, ProfessionsFrame.OrdersPage, "UICheckButtonTemplate")
    checkBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 28, 0)
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
    return checkBox
end

local publicCheckBox = createCheckBox("hideOrdersWithoutMaterials")
local guildCheckBox = createCheckBox("hideGuildOrdersWithoutMaterials")
local privateCheckBox = createCheckBox("hidePersonalOrdersWithoutMaterials")
local activeCheckBox = publicCheckBox
guildCheckBox:Hide()
privateCheckBox:Hide()

publicCheckBox:RegisterEvent("PLAYER_ENTERING_WORLD")
publicCheckBox:HookScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        publicCheckBox:UnregisterEvent("PLAYER_ENTERING_WORLD")
        if not PublicOrdersReagentsDB then PublicOrdersReagentsDB = {} end
        if not PublicOrdersReagentsDB.minimumCommission then PublicOrdersReagentsDB.minimumCommission = 0 end
        publicCheckBox:SetChecked(PublicOrdersReagentsDB.hideOrdersWithoutMaterials)
        guildCheckBox:SetChecked(PublicOrdersReagentsDB.hideGuildOrdersWithoutMaterials)
        privateCheckBox:SetChecked(PublicOrdersReagentsDB.hidePrivateOrdersWithoutMaterials)
        
        -- addon RECraft moves the arrow to the same spot I have the checkbox, compensate
        if IsAddOnLoaded("RECraft") then
            publicCheckBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 28, 22)
            guildCheckBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 28, 22)
            privateCheckBox:SetPoint("LEFT", ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton, "RIGHT", 28, 22)
        end
        
        PublicOrdersReagentsColumnMinimumCommissionSlider:SetValue(PublicOrdersReagentsDB.minimumCommission or 0)
    end
end)

-- minimum commission frame with slider
local commissionFrame = CreateFrame("Frame", "PublicOrdersReagentsColumnMinimumCommissionFrame", activeCheckBox)
commissionFrame:Hide()
commissionFrame:SetSize(330, 100)
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

commissionFrame.Label = commissionFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
commissionFrame.Label:SetPoint("TOP", commissionFrame.Slider, "BOTTOM", 0, -20)
commissionFrame.Label:SetText("...or show the order anyway if it offers this much commission")
commissionFrame.Label:SetWordWrap(true)
commissionFrame.Label:SetWidth(280)

commissionFrame:SetScript("OnLeave", function()
    if (not activeCheckBox:IsMouseOver()) and (not PublicOrdersReagentsColumnMinimumCommissionFrame:IsMouseOver()) then
        commissionFrame:Hide()
    end
end)

-- the max commission for mats provided column during bucket view
ProfessionsCrafterTableCellMaxMatsProvidedCommissionMixin = CreateFromMixins(TableBuilderCellMixin);

function ProfessionsCrafterTableCellMaxMatsProvidedCommissionMixin:Populate(rowData, dataIndex)
    local order = rowData.option
    orderToCell[order] = self
    ProfessionsTableCellTextMixin.SetText(self, "?")
end

-- handle user changing tab public/guild/private
hooksecurefunc(ProfessionsFrame.OrdersPage, "InitOrderTypeTabs", function()
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
end)
