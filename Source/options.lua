local addonName, addon = ...

local addonTitle = select(2, C_AddOns.GetAddOnInfo(addonName))

function addon.getToolFlyoutEnabled()
    if not addon.db.global.toolFlyout then return false end
    return addon.db.profile.toolFlyout
end

function addon:setupOptions()
    local defaults = {
        profile = {
            toolFlyout = true,
        },
        global = {
            toolFlyout = true,
        },
    }
        
    addon.db = LibStub("AceDB-3.0"):New("PublicOrdersReagentsColumnADB", defaults)
        
    local options = {
        type = "group",
        args = {
            showCompleted = {
                type = "toggle",
                name = "Enable Tool Flyout Module (This Character)",
                set = function(info, v) addon.db.profile.toolFlyout = v end,
                get = function() return addon.db.profile.toolFlyout end,
                width = "full",
            },
            accountWide = {
                type = "toggle",
                name = "Enable Tool Flyout Module (Account Wide)",
                desc = "If unchecked, overrides all character-specific settings",
                set = function(info, v) addon.db.global.toolFlyout = v end,
                get = function() return addon.db.global.toolFlyout end,
                width = "full",
            },
        },
    }

    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonTitle)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonTitle, options, {"publicordersreagentscolumn"})
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonTitle)
end
