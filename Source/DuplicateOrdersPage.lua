local addonName, addon = ...

local OrderBrowseType = EnumUtil.MakeEnum("Flat", "Bucketed", "None");
local orderTypeTabTitles =
{
	[Enum.CraftingOrderType.Public] = PROFESSIONS_CRAFTER_ORDER_TAB_PUBLIC,
	[Enum.CraftingOrderType.Guild] = PROFESSIONS_CRAFTER_ORDER_TAB_GUILD,
	[Enum.CraftingOrderType.Personal] = PROFESSIONS_CRAFTER_ORDER_TAB_PERSONAL,
	[Enum.CraftingOrderType.Npc] = PROFESSIONS_CRAFTER_ORDER_TAB_NPC,
}

local function getProfessionID()
    return Professions.GetProfessionInfo().parentProfessionID
end

PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin = CreateFromMixins(ProfessionsCraftingOrderPageMixin)

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:InitOrderList()
	local pad = 5;
	local spacing = 1;
	local view = CreateScrollBoxListLinearView(pad, pad, pad, pad, spacing);
    view:SetElementInitializer("PublicOrdersReagentsColumnProfessionsCrafterOrderListElementTemplate", function(button, elementData)
		button:Init(elementData);
	end);
	ScrollUtil.InitScrollBoxListWithScrollBar(self.BrowseFrame.OrderList.ScrollBox, self.BrowseFrame.OrderList.ScrollBar, view);
end

local function SetTabTitleWithCount(tabButton, type, count)
	if tabButton then
		local title = orderTypeTabTitles[type];
		if type == Enum.CraftingOrderType.Public then
			tabButton.Text:SetText(title);
		else
			tabButton.Text:SetText(string.format("%s (%s)", title, count));
		end
	end
end

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:InitOrderTypeTabs()
	for _, typeTab in ipairs(self.BrowseFrame.orderTypeTabs) do
		typeTab:SetScript("OnClick", function()
			PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
			self:SetCraftingOrderType(typeTab.orderType);

			self:ClearCachedRequests();
			self:StartDefaultSearch();

			-- Show NEW feature label on NPC tab until first clicked
			if typeTab.orderType == Enum.CraftingOrderType.Npc then
				SetCVarBitfield("closedInfoFramesAccountWide", LE_FRAME_TUTORIAL_ACCOUNT_NPC_CRAFTING_ORDER_TAB_NEW, true);
				self.BrowseFrame.NpcOrdersNewFeature:SetShown(false);
			end
		end);

		typeTab:HandleRotation();
		local count = 0;
		SetTabTitleWithCount(typeTab, typeTab.orderType, count);
		local minWidth = 150;
		local bufferWidth = 100;
		local stretchWidth = typeTab.Text:GetWidth() + bufferWidth;
		typeTab:SetTabWidth(math.max(minWidth, stretchWidth));
	end
end

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:OnLoad()
	self:InitOrderTypeTabs();
	self:SetBrowseType(OrderBrowseType.None);
	self:InitOrderList();
	self:SetCraftingOrderType(Enum.CraftingOrderType.Npc);
    
    self.OfflineWarningDisplay.Text:SetText("Last known crafting orders")
    
    self.BrowseFrame.OrderList:SetPoint("TOPLEFT", ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList, "TOPRIGHT")
    self.BrowseFrame.OrderList:SetPoint("BOTTOMLEFT", ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList, "BOTTOMRIGHT")
    self.BrowseFrame.OrderList:SetPoint("TOPRIGHT")
    self.BrowseFrame.OrderList:SetPoint("BOTTOMRIGHT")
end

PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin.RequestOrders = nop

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:OnShow()
	self:SetTitle();
    self:ShowCachedData()
    
    if not addon.cache then return end
    if not addon.cache[getProfessionID()] then return end
    self.BrowseFrame.GuildOrdersButton:SetShown(addon.cache[getProfessionID()][Enum.CraftingOrderType.Guild])
    self.BrowseFrame.NpcOrdersButton:SetShown(addon.cache[getProfessionID()][Enum.CraftingOrderType.Npc])
    self.BrowseFrame.PersonalOrdersButton:SetShown(addon.cache[getProfessionID()][Enum.CraftingOrderType.Personal])
end

PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin.OnRecipeSelected = nop
PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin.RequestOrders = nop

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:ShowCachedData()
    local cache = addon.cache
    if not cache then return end
    if (not cache[getProfessionID()]) or (not cache[getProfessionID()][self.orderType]) then
        local dp = self.BrowseFrame.OrderList.ScrollBox:GetDataProvider()
        if dp then dp:Flush() end
        return
    end
    
    self:OrderRequestCallback(nil, self.orderType, false, false, 0, true)
end

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:ShowOrders(offset, isSorted)
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
    if C_CraftingOrders.GetClaimedOrder() then return end
    addon.cache[getProfessionID()][self.orderType] = C_CraftingOrders.GetCrafterOrders()
    ProfessionsFrame.OrdersPageOffline:ShowCachedData()
    ProfessionsFrame.OrdersPageOffline:SetCraftingOrderType(self.orderType)
end)

PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin.StartDefaultSearch = PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin.ShowCachedData

function PublicOrdersReagentsColumnProfessionsCraftingOrderPageMixin:SetupTable()
	local browseType = self:GetBrowseType();

	if not self.tableBuilder then
		self.tableBuilder = CreateTableBuilder(nil, ProfessionsTableBuilderMixin);
		local function ElementDataTranslator(elementData)
			return elementData;
		end;
		ScrollUtil.RegisterTableBuilder(self.BrowseFrame.OrderList.ScrollBox, self.tableBuilder, ElementDataTranslator);
	
		local function ElementDataProvider(elementData)
			return elementData;
		end;
		self.tableBuilder:SetDataProvider(ElementDataProvider);
	end

	self.tableBuilder:Reset();
	self.tableBuilder:SetColumnHeaderOverlap(2);
	self.tableBuilder:SetHeaderContainer(self.BrowseFrame.OrderList.HeaderContainer);
	self.tableBuilder:SetTableMargins(-3, 5);
	self.tableBuilder:SetTableWidth(777);

	local PTC = ProfessionsTableConstants;
	self.tableBuilder:AddFillColumn(self, PTC.NoPadding, 1.0,
		8, PTC.ItemName.RightCellPadding, ProfessionsSortOrder.ItemName, "ProfessionsCrafterTableCellItemNameTemplate");

	if browseType == OrderBrowseType.Flat then
		local customerColumnName = self.orderType == Enum.CraftingOrderType.Npc and CRAFTING_ORDERS_BROWSE_HEADER_NPC_NAME or CRAFTING_ORDERS_BROWSE_HEADER_CUSTOMER_NAME;
		self.tableBuilder:AddUnsortableFixedWidthColumn(self, PTC.NoPadding, PTC.CustomerName.Width, PTC.CustomerName.LeftCellPadding,
										  	  PTC.CustomerName.RightCellPadding, customerColumnName, "ProfessionsCrafterTableCellCustomerNameTemplate");
		self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Tip.Width, PTC.Tip.LeftCellPadding,
										  	  PTC.Tip.RightCellPadding, ProfessionsSortOrder.Tip, "ProfessionsCrafterTableCellActualCommissionTemplate");
		self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Reagents.Width, PTC.Reagents.LeftCellPadding,
										  		  PTC.Reagents.RightCellPadding, ProfessionsSortOrder.Reagents, "ProfessionsCrafterTableCellReagentsTemplate");
		self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Expiration.Width, PTC.Expiration.LeftCellPadding,
										  	  PTC.Expiration.RightCellPadding, ProfessionsSortOrder.Expiration, "PublicOrdersReagentsColumnProfessionsCrafterTableCellExpirationTemplate");
	elseif browseType == OrderBrowseType.Bucketed then
		self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Tip.Width, PTC.Tip.LeftCellPadding,
										  	  PTC.Tip.RightCellPadding, ProfessionsSortOrder.MaxTip, "ProfessionsCrafterTableCellMaxCommissionTemplate");
		self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Tip.Width, PTC.Tip.LeftCellPadding,
										  	  PTC.Tip.RightCellPadding, ProfessionsSortOrder.AverageTip, "ProfessionsCrafterTableCellAvgCommissionTemplate");
		self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.NumAvailable.Width, PTC.NumAvailable.LeftCellPadding,
										  	  PTC.NumAvailable.RightCellPadding, ProfessionsSortOrder.NumAvailable, "ProfessionsCrafterTableCellNumAvailableTemplate");
	end

	self.tableBuilder:Arrange();
end