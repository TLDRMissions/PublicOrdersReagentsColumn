local addonName, addon = ...

local wasEnabled
ProfessionsFrame.OrdersPage.OrderView:HookScript("OnShow", function()
    if addon.db.global.moveCreateButton then
        ProfessionsFrame.OrdersPage.OrderView.CreateButton:ClearAllPoints()
        ProfessionsFrame.OrdersPage.OrderView.CreateButton:SetPoint("TOP", ProfessionsFrame.OrdersPage.OrderView.OrderInfo.StartOrderButton, "TOP")
        ProfessionsFrame.OrdersPage.OrderView.CreateButton:SetFrameStrata("HIGH")
        wasEnabled = true
    elseif wasEnabled then
        ProfessionsFrame.OrdersPage.OrderView.CreateButton:ClearAllPoints()
        ProfessionsFrame.OrdersPage.OrderView.CreateButton:SetPoint("BOTTOMRIGHT", ProfessionsFrame.OrdersPage.OrderView, "BOTTOMRIGHT", -20, 7)
        ProfessionsFrame.OrdersPage.OrderView.CreateButton:SetFrameStrata("MEDIUM")
    end
end)