local addonName, addon = ...

local OrderBrowseType = EnumUtil.MakeEnum("Flat", "Bucketed", "None");

local craftingOrdersTab = ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.craftingOrdersTabID)
local duplicateTab = CreateFrame("BUTTON", nil, ProfessionsFrame, ProfessionsFrame.TabSystem.tabTemplate)
duplicateTab:SetPoint("TOPLEFT", craftingOrdersTab, "TOPLEFT")
duplicateTab:SetPoint("BOTTOMRIGHT", craftingOrdersTab, "BOTTOMRIGHT")
duplicateTab:SetFrameStrata("DIALOG")
duplicateTab:Hide()
duplicateTab:SetText(craftingOrdersTab:GetText())

local duplicateFrame = ProfessionsFrame.OrdersPageOffline

local function getProfessionID()
    return Professions.GetProfessionInfo().parentProfessionID
end

hooksecurefunc(ProfessionsFrame, "UpdateTabs", function()
    if not C_CraftingOrders.ShouldShowCraftingOrderTab() then
        duplicateTab:Hide()
        --craftingOrdersTab:Show()
        if duplicateFrame:IsShown() then
            duplicateFrame:Hide()
            ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.recipesTabID):Click()
        end
    elseif duplicateTab.isSelected then
        if not addon.cache[getProfessionID()] then
            duplicateTab:Hide()
            ProfessionsFrame.TabSystem:GetTabButton(ProfessionsFrame.recipesTabID):Click()
            return
        end
        duplicateFrame:ShowCachedData()
        return
    elseif craftingOrdersTab:IsEnabled() or craftingOrdersTab.isSelected then
        duplicateTab:Hide()
        craftingOrdersTab:Show()
        duplicateFrame:Hide()
    elseif addon.cache then
        if addon.cache[getProfessionID()] then
            duplicateTab:Show()
            craftingOrdersTab:Hide()
            duplicateTab:SetTabSelected(false)
        end
    end
end)

for tabID, tab in ipairs(ProfessionsFrame.TabSystem.tabs) do
    tab:HookScript("OnClick", function()
        duplicateTab:SetTabSelected(false)
        duplicateFrame:Hide()
        for frameIndex, frame in ipairs(ProfessionsFrame.internalTabTracker.tabbedElements) do
            if tabID == frameIndex then
                frame:Show()
                ProfessionsFrame:SetWidth(frame:GetDesiredPageWidth())
            end
        end
    end)
end

duplicateTab:SetScript("OnClick", function()
    ProfessionsFrame.CraftingPage:Hide()
    ProfessionsFrame.SpecPage:Hide()
    ProfessionsFrame.OrdersPage:Hide()
    duplicateTab:SetTabSelected(true)
    duplicateFrame:Show()
    
    for tabID, tab in ipairs(ProfessionsFrame.TabSystem.tabs) do
        tab:SetTabSelected(false)
    end
    ProfessionsFrame:SetWidth(ProfessionsFrame.OrdersPage:GetDesiredPageWidth())
end)

hooksecurefunc(ProfessionsFrame, "Update", function(self)
    if duplicateFrame:IsShown() and C_TradeSkillUI.IsNearProfessionSpellFocus(self.professionInfo.profession) then
        duplicateFrame:Hide()
        ProfessionsFrame.OrdersPage:Show()
    elseif ProfessionsFrame.OrdersPage:IsShown() and not C_TradeSkillUI.IsNearProfessionSpellFocus(self.professionInfo.profession) then
        duplicateFrame:Show()
        ProfessionsFrame.OrdersPage:Hide()
    end
end)

function duplicateFrame:OnLoad()
	self:InitButtons();
	self:InitOrderTypeTabs();
	self:InitRecipeList();
	self:SetBrowseType(OrderBrowseType.None);
	self:InitOrderList();
	self:SetCraftingOrderType(Enum.CraftingOrderType.Npc);

	--FrameUtil.RegisterFrameForEvents(self, ProfessionsCraftingOrderPageAlwaysListenEvents);
	--EventRegistry:RegisterCallback("ProfessionsFrame.Hide", function() self:ClearCachedRequests(); end, self);
    
    self.BrowseFrame.RecipeList:Hide()
    self.BrowseFrame.FavoritesSearchButton:Hide()
    self.BrowseFrame.SearchButton:Hide()
    self.BrowseFrame.PublicOrdersButton:Hide()
    self.BrowseFrame.BackButton:Hide()
    self.BrowseFrame.OrdersRemainingDisplay:Hide()
    self.OfflineWarningDisplay.Text:SetText("Last known crafting orders")
end
duplicateFrame:OnLoad()

duplicateFrame.RequestOrders = nop

duplicateFrame:SetScript("OnShow", function(self)
	--FrameUtil.RegisterFrameForEvents(self, ProfessionsCraftingOrderPageEvents);
	--EventRegistry:RegisterCallback("ProfessionsRecipeListMixin.Event.OnRecipeSelected", self.OnRecipeSelected, self);

	--C_TradeSkillUI.SetOnlyShowAvailableForOrders(true);

	self:SetTitle();

	--self.BrowseFrame.RecipeList.SearchBox:SetText(C_TradeSkillUI.GetRecipeItemNameFilter());

	--local profession = self.professionInfo and self.professionInfo.profession;
	--if profession and C_CraftingOrders.ShouldShowCraftingOrderTab() and C_TradeSkillUI.IsNearProfessionSpellFocus(profession) then
		--C_CraftingOrders.OpenCrafterCraftingOrders();
		-- Delay a frame so that the recipe list does not get thrashed because of the delayed event from flag changes
		--RunNextFrame(function() self:StartDefaultSearch(); end);
	--end
	--self:CheckForClaimedOrder();
    
    self:ShowCachedData()
    
    if not addon.cache[getProfessionID()] then return end
    self.BrowseFrame.GuildOrdersButton:SetShown(addon.cache[getProfessionID()][Enum.CraftingOrderType.Guild])
    self.BrowseFrame.NpcOrdersButton:SetShown(addon.cache[getProfessionID()][Enum.CraftingOrderType.Npc])
    self.BrowseFrame.PersonalOrdersButton:SetShown(addon.cache[getProfessionID()][Enum.CraftingOrderType.Personal])
end)

duplicateFrame.OnRecipeSelected = nop
duplicateFrame.RequestOrders = nop

function duplicateFrame:ShowCachedData()
    local cache = addon.cache
    if not cache then return end
    if (not cache[getProfessionID()]) or (not cache[getProfessionID()][self.orderType]) then
        local dp = duplicateFrame.BrowseFrame.OrderList.ScrollBox:GetDataProvider()
        if dp then dp:Flush() end
        return
    end
    
    self:OrderRequestCallback(nil, self.orderType, false, false, 0, true)
end

function duplicateFrame:ShowOrders(offset, isSorted)
	if self.lastRequest == self.lastBucketRequest then
		-- We requested bucketed orders and were handed a flat list
		self.lastBucketRequest = nil;
	end
	--self.BrowseFrame.BackButton:SetShown(self.lastBucketRequest ~= nil);
	self:ShowGeneric(addon.cache[getProfessionID()][self.orderType], OrderBrowseType.Flat, offset, isSorted);
end

hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowOrders", function(self, offset, isSorted)
    if self.orderType == Enum.CraftingOrderType.Public then return end
    if not addon.cache then addon.cache = {} end
    if not addon.cache[getProfessionID()] then addon.cache[getProfessionID()] = {} end
    addon.cache[getProfessionID()][self.orderType] = C_CraftingOrders.GetCrafterOrders()
    duplicateFrame:ShowCachedData()
    duplicateFrame:SetCraftingOrderType(self.orderType)
end)

duplicateFrame:SetScript("OnHide", nop)
duplicateFrame.StartDefaultSearch = duplicateFrame.ShowCachedData
