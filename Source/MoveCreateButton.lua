local addonName, addon = ...

local wasEnabled
ProfessionsFrame.OrdersPage.OrderView:HookScript("OnShow", function(self)
    if addon.db.global.moveCreateButton then
        self.CreateButton:ClearAllPoints()
        self.CreateButton:SetPoint("TOP", self.OrderInfo.StartOrderButton, "TOP")
        self.CreateButton:SetFrameStrata("HIGH")
        
        self.CompleteOrderButton:ClearAllPoints()
        self.CompleteOrderButton:SetPoint("TOP", self.OrderInfo.StartOrderButton, "TOP")
        self.CompleteOrderButton:SetFrameStrata("HIGH")
        
        self.OrderInfo.DeclineOrderButton:ClearAllPoints()
        self.OrderInfo.DeclineOrderButton:SetPoint("TOP", self.OrderInfo.ReleaseOrderButton, "TOP")
        
        self.OrderInfo.StartOrderButton:ClearAllPoints()
        self.OrderInfo.StartOrderButton:SetPoint("BOTTOM", self.OrderInfo, "BOTTOM", 0, 55)
        
        self.OrderInfo.OrderReagentsWarning:ClearAllPoints();
	    self.OrderInfo.OrderReagentsWarning:SetPoint("BOTTOMLEFT", self.OrderInfo, "BOTTOMLEFT", 20, 90)
        
        self.StartRecraftButton:ClearAllPoints()
        self.StartRecraftButton:SetPoint("TOP", self.OrderInfo.ReleaseOrderButton, "TOP")
        self.StartRecraftButton:SetFrameStrata("HIGH")
        
        wasEnabled = true
    elseif wasEnabled then
        self.CreateButton:ClearAllPoints()
        self.CreateButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -20, 7)
        
        self.CompleteOrderButton:ClearAllPoints()
        self.CompleteOrderButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -20, 7)
        
        self.OrderInfo.DeclineOrderButton:ClearAllPoints()
        self.OrderInfo.DeclineOrderButton:SetPoint("BOTTOM", self.OrderInfo, "BOTTOM", 70, 8)
        
        -- StartOrderButton and OrderReagentsWarning are anchored dynamically in ProfessionsCrafterOrderViewMixin:SetOrderState
        
        self.StartRecraftButton:ClearAllPoints()
        self.StartRecraftButton:SetPoint("RIGHT", self.CompleteOrderButton, "LEFT", -5, 0)

        wasEnabled = false
    end
end)