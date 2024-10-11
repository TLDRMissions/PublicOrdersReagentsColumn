local addonName, addon = ...

addon.ToolSelectionLocales = {}

local L = addon.ToolSelectionLocales

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

if GetLocale() == "esES" then
    -- L["TOOLTOP_EMPTY_BUTTON"] = ""
end