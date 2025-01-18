local addonName, addon = ...

EventUtil.ContinueOnAddOnLoaded(addonName, function()
    addon:setupOptions()
end)

EventUtil.ContinueOnAddOnLoaded("Blizzard_Professions", function()
    hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", addon.skillUpIconHandler)
    hooksecurefunc(ProfessionsFrame.OrdersPage, "ShowGeneric", addon.firstCraftIconHandler)
end)