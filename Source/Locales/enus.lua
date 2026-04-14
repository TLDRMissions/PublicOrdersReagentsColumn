local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)
if not L then return end

-- Options
L["ENABLE_MODULE_CHARACTER"] = "Enable %s Module (This Character)"
L["ENABLE_MODULE_ACCOUNT"] = "Enable %s Module (Account Wide)"
L["TOOL_FLYOUT_MODULE_NAME"] = "Tool Flyout"
L["INCREASED_PADDING_MODULE_NAME"] = "Increased Padding"
L["TOOL_FLYOUT_MODULE_DESC"] = "If unchecked, overrides all character-specific settings"
L["INCREASED_PADDING_MODULE_DESC"] = "Makes crafting order rows extra-wide"
L["MOVE_CRAFTING_ORDERS_MODULE_NAME"] = "Move Crafting Orders"
L["MOVE_CRAFTING_ORDERS_MODULE_DESC"] = "When filling Crafting Orders, moves various buttons around to be consistently in the same place, such as Create Order and Start Order"
L["SUPPRESS_WEEKLY_QUEST_WARNING_NAME"] = "Suppress the No Weekly Quest warning"
L["SUPPRESS_WEEKLY_QUEST_WARNING_DESC"] = ""

L["NO_WEEKLY_QUEST_WARNING_TEXT"] = "Weekly Crafting Orders quest missing!"
L["OFFLINE_WARNING_DISPLAY_TEXT"] = "Last known crafting orders"

L["ENABLE_RECOLOR_MINIMAP_TREASURES_MODULE"] = "Enable Recolour Minimap Treasures Module"
L["RECOLOR_MINIMAP_TREASURES_MODULE_DESC"] = "This Module will recolour 'Junk' Treasures on your Minimap to red"
L["RECOLOR_MINIMAP_TREASURE_NAME"] = "Treasure Name"
L["RECOLOR_MINIMAP_TREASURE_SHADE"] = "Shade"
L["RECOLOR_MINIMAP_TREASURE_DESC"] = "Select a treasure from the dropdown to edit it, or type a treasure name into the edit box to add a new one. Changes are saved on selecting a new color"

L["PROFILE"] = "Profile"

L["REAGENT_ERROR_SHADE"] = "Missing reagents background colour"

-- Tool Selection Frame
L["TOOLTIP_EMPTY_BUTTON"] = "Drag your %s profession tool here to have that tool swapped in when relevant."
L["TOOLTIP_RESOURCEFULNESS_DETAIL"] = "This tool will be swapped in for Work Orders, and recipes that don't use Multicraft."
L["TOOLTIP_MULTICRAFT_DETAIL"] = "This tool will be swapped in for recipes that use Multicraft, unless it is a Work Order."
L["TOOLTIP_INGENUITY_DETAIL"] = "This tool will be swapped in if you select the option to use Concentration."
L["TOOLTIP_SPEED_DETAIL"] = "This tool will be swapped in if the recipe does not use any other stats."
L["TOOLTIP_FINAL_DETAIL"] = "Click to clear this tool. It will then be skipped for lower priority tools."
L["TOOLTIP_ERROR_NOT_FOUND"] = "Error: Could not find the assigned profession tool."
L["PRIORITY_BUTTON_TOOLTIP"] = "If selected, your assigned Ingenuity tool will be used when Concentration is selected, even if the recipe uses Multicraft"
L["DISABLE_BUTTON_TEXT"] = "Disable auto-equipping"
L["PRIORTY_BUTTON_SELECTED_TEXT"] = "Ingenuity over Multicraft"
L["PRIORTY_BUTTON_DESELECTED_TEXT"] = "Multicraft over Ingenuity"

-- Moxie Icon
L["MOXIE_ICON_ACCOUNT_NAME"] = "Account-wide: enable moxie icon module"
L["MOXIE_ICON_ACCOUNT_DESC"] = "Underneath the Concentration Icon, adds another icon that shows how much Moxie your profession has"
L["MOXIE_ICON_CHARACTER_NAME"] = "Character-specific: enable moxie icon module"
L["MOXIE_ICON_CHARACTER_DESC"] = "Same as the account-wide option, except overrides that choice for this character"
L["MOXIE_ICON_OPTION_SHOW_AND_FLASH"] = "Show and flash while 600 or more"
L["MOXIE_ICON_OPTION_USE_INHERITED"] = "Use selected account-wide option"

-- Profit / loss module
L["PROFIT_LOSS_HEADER"] = "Profit / Loss"
L["PROFIT_LOSS_OPTION"] = "Enable the Profit / Loss column."
L["PROFIT_LOSS_OPTION_DESC"] = "Will replace the Patron Name column, moving that name into a mouseover tooltip."

-- Patron order patrial automation module
L["START_CRAFT_SPEEDUP_GROUP_NAME"] = "Patron Order button skipping"
L["SKIP_COMPLETE_ORDER_NAME"] = "Skip Complete Order button"
L["SKIP_COMPLETE_ORDER_DESC"] = "Automatically clicks the Complete Order button when it appears for Patron Orders"
L["SKIP_OWN_REAGENT_NAME"] = "Skip own reagent warning"
L["SKIP_OWN_REAGENT_DESC"] = "Skip built-in warning about using your own reagents for patron orders"
L["SKIP_START_ORDER_NAME"] = "Skip Start Order button"
L["SKIP_START_ORDER_DESC"] = "Automatically clicks the Start Order button when it appears for Patron Orders"
L["MOVE_CREATE_TO_CURSOR_NAME"] = "Make Create button follow your Cursor"
L["MOVE_CREATE_TO_CURSOR_DESC"] = "The Create button will follow your mouse cursor around for a few seconds after opening a Patron Order"