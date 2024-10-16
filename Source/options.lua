local addonName, addon = ...

local addonTitle = select(2, C_AddOns.GetAddOnInfo(addonName))

function addon:setupOptions()
    local defaults = {
        profile = {
            toolFlyout = true,
        },
    }
        
    addon.db = LibStub("AceDB-3.0"):New("PublicOrdersReagentsColumnADB", defaults)
        
    local options = {
        type = "group",
        args = {
            showCompleted = {
                type = "toggle",
                name = "Enable Tool Flyout Module",
                set = function(info, v) addon.db.profile.toolFlyout = v end,
                get = function() return addon.db.profile.toolFlyout end,
                width = "full",
            },
        },
    }

    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonTitle)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonTitle, options, {"publicordersreagentscolumn"})
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonTitle)
end
