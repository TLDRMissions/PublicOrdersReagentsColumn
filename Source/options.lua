local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
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
            increasedPadding = 0,
            moveCreateButton = false,
        },
    }
        
    addon.db = LibStub("AceDB-3.0"):New("PublicOrdersReagentsColumnADB", defaults)
        
    local options = {
        type = "group",
        args = {
            showCompleted = {
                type = "toggle",
                name = L["ENABLE_MODULE_CHARACTER"]:format(L["TOOL_FLYOUT_MODULE_NAME"]),
                set = function(info, v) addon.db.profile.toolFlyout = v end,
                get = function() return addon.db.profile.toolFlyout end,
                width = "full",
            },
            accountWide = {
                type = "toggle",
                name = L["ENABLE_MODULE_ACCOUNT"]:format(L["TOOL_FLYOUT_MODULE_NAME"]),
                desc = L["TOOL_FLYOUT_MODULE_DESC"],
                set = function(info, v) addon.db.global.toolFlyout = v end,
                get = function() return addon.db.global.toolFlyout end,
                width = "full",
            },
            increasedPadding = {
                type = "range",
                name = L["ENABLE_MODULE_ACCOUNT"]:format(L["INCREASED_PADDING_MODULE_NAME"]),
                desc = L["INCREASED_PADDING_MODULE_DESC"],
                min = 0,
                max = 20,
                step = 1,
                set = function(info, v) addon.db.global.increasedPadding = v end,
                get = function()
                    return addon.db.global.increasedPadding
                end,
                width = "full",
            },
            moveCreateButton = {
                type = "toggle",
                name = L["MOVE_CRAFTING_ORDERS_MODULE_NAME"],
                desc = L["MOVE_CRAFTING_ORDERS_MODULE_DESC"],
                set = function(info, v) addon.db.global.moveCreateButton = v end,
                get = function() return addon.db.global.moveCreateButton end,
                width = "full",
            },
        },
    }

    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(options, addonTitle)
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonTitle, options, {"publicordersreagentscolumn"})
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonTitle)
    
    -- backward compatibility
    if addon.db.global.increasedPadding == true then
        addon.db.global.increasedPadding = 10
    elseif addon.db.global.increasedPadding == false then
        addon.db.global.increasedPadding = 0
    end
end
