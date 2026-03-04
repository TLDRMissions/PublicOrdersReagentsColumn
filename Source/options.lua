local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local addonTitle = select(2, C_AddOns.GetAddOnInfo(addonName))

function addon.getToolFlyoutEnabled()
    if not addon.db.global.toolFlyout then return false end
    return addon.db.profile.toolFlyout
end

local inputEditText = ""

function addon:setupOptions()
    local defaults = {
        profile = {
            toolFlyout = true,
            suppressedListingOneTime = {},
            suppressedListingPermanent = {},
        },
        global = {
            toolFlyout = true,
            increasedPadding = 0,
            moveCreateButton = false,
            suppressNoWeeklyQuestWarning = false,
            MinimapRecolouredNodes = {},
            enableMinimapRecolouredNodes = false,
        },
    }
        
    addon.db = LibStub("AceDB-3.0"):New("PublicOrdersReagentsColumnADB", defaults)
        
    local options = {
        type = "group",
        args = {
            showCompleted = {
                type = "toggle",
                name = L["ENABLE_MODULE_CHARACTER"]:format(L["TOOL_FLYOUT_MODULE_NAME"]),
                set = function(_, v) addon.db.profile.toolFlyout = v end,
                get = function() return addon.db.profile.toolFlyout end,
                width = "full",
            },
            accountWide = {
                type = "toggle",
                name = L["ENABLE_MODULE_ACCOUNT"]:format(L["TOOL_FLYOUT_MODULE_NAME"]),
                desc = L["TOOL_FLYOUT_MODULE_DESC"],
                set = function(_, v) addon.db.global.toolFlyout = v end,
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
                set = function(_, v) addon.db.global.increasedPadding = v end,
                get = function()
                    return addon.db.global.increasedPadding
                end,
                width = "full",
            },
            moveCreateButton = {
                type = "toggle",
                name = L["MOVE_CRAFTING_ORDERS_MODULE_NAME"],
                desc = L["MOVE_CRAFTING_ORDERS_MODULE_DESC"],
                set = function(_, v) addon.db.global.moveCreateButton = v end,
                get = function() return addon.db.global.moveCreateButton end,
                width = "full",
            },
            suppressNoWeeklyQuestWarning = {
                type = "toggle",
                name = L["SUPPRESS_WEEKLY_QUEST_WARNING_NAME"],
                desc = L["SUPPRESS_WEEKLY_QUEST_WARNING_DESC"],
                set = function(_, v) addon.db.global.suppressNoWeeklyQuestWarning = v end,
                get = function() return addon.db.global.suppressNoWeeklyQuestWarning end,
                width = "full",
            },
            enableMinimapRecolouredNodes = {
                name = "Enable Recolour Minimap Treasures Module",
                desc = "This Module will recolour 'Junk' Treasures on your Minimap to red",
                set = function(_, v) addon.db.global.enableMinimapRecolouredNodes = v end,
                get = function() return addon.db.global.enableMinimapRecolouredNodes end,
                width = "full",
                type = "toggle",
                order = 1,
            },
            dropdown = {
                name = "Treasure Name",
                type = "select",
                values = function()
                    local output = {}
                    for name in pairs(addon.db.global.MinimapRecolouredNodes) do
                        output[name] = name
                    end
                    return output
                end,
                set = function(_, v)
                    inputEditText = v
                end,
                get = nop,
                order = 2,
            },
            input = {
                type = "input",
                name = "Treasure Name",
                get = function()
                    return inputEditText
                end,
                set = function(_, v)
                    inputEditText = v
                end,
                order = 3,
            },
            color = {
                type = "color",
                order = 4,
                name = "Shade",
                get = function()
                    if addon.db.global.MinimapRecolouredNodes[inputEditText] then
                        local data = addon.db.global.MinimapRecolouredNodes[inputEditText]
                        return data.r, data.g, data.b
                    end
                    return 1, 0, 0
                end,
                set = function(_, r, g, b)
                    if inputEditText == "" then return end
                    addon.db.global.MinimapRecolouredNodes[inputEditText] = {
                        r = r,
                        g = g,
                        b = b,
                    }
                end,
            },
            instructions = {
                type = "description",
                order = 5,
                width = "full",
                name = "Select a treasure from the dropdown to edit it, or type a treasure name into the edit box to add a new one. Changes are saved on selecting a new color",
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
