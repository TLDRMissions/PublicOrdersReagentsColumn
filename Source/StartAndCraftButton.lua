local addonName, addon = ...

ProfessionsFrame.OrdersPage.OrderView.CompleteOrderButton:HookScript("OnShow", function(self)
    if not addon.db.profile.skipCompleteOrderButton then return end
    if ProfessionsFrame.OrdersPage.orderType ~= Enum.CraftingOrderType.Npc then return end
    
    self:Click()
end)

hooksecurefunc("StaticPopup_ShowCustomGenericConfirmation", function(data)
    if not addon.db.profile.skipOwnReagentConfiration then return end
    if issecrettable(data) then return end
    if issecretvalue(data.text) then return end
    if data.text ~= CRAFTING_ORDERS_OWN_REAGENTS_CONFIRMATION then return end
    if ProfessionsFrame.OrdersPage.orderType ~= Enum.CraftingOrderType.Npc then return end
    
    if data.callback then
        data.callback()
        StaticPopup1:Hide()
    end
end)

ProfessionsFrame.OrdersPage.OrderView.OrderInfo.StartOrderButton:HookScript("OnShow", function(self)
    if not addon.db.profile.skipStartOrderButton then return end
    if ProfessionsFrame.OrdersPage.orderType ~= Enum.CraftingOrderType.Npc then return end
    
    self:Click()
end)

local ticker
ProfessionsFrame.OrdersPage.OrderView.CreateButton:HookScript("OnShow", function(self)
    if not addon.db.profile.moveCreateButtonToCursor then return end
    if ProfessionsFrame.OrdersPage.orderType ~= Enum.CraftingOrderType.Npc then return end
    if not self:IsEnabled() then return end
    
    if ticker then ticker:Cancel() end
    
    local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()

    ticker = C_Timer.NewTicker(0.01, function()
        x, y = GetCursorPosition()
        self:ClearAllPoints()
        self:SetPoint("BOTTOMRIGHT", nil, "BOTTOMLEFT", (x / uiScale) + 40, (y / uiScale) - 10)
    end, 300)
    
    self:ClearAllPoints()
    self:SetPoint("BOTTOMRIGHT", nil, "BOTTOMLEFT", (x / uiScale) + 40, (y / uiScale) - 10)
end)

ProfessionsFrame.OrdersPage.OrderView.CreateButton:HookScript("OnClick", function()
    if ticker then
        ticker:Cancel()
    end
end)

-- the parent button isn't registered for Right Button
-- rather than registering that, which will cause unexpected behaviour, create another invisible button overtop that intercepts right clicks
-- this gives player a way to cancel the button movement by rightclicking
local createButtonCover = CreateFrame("Button", nil, ProfessionsFrame.OrdersPage.OrderView.CreateButton)
createButtonCover:SetAllPoints()
createButtonCover:RegisterForClicks("RightButtonUp")
createButtonCover:SetScript("OnClick", function()
    if ticker then
        ticker:Cancel()
    end
end)
createButtonCover:SetPropagateMouseClicks(true)