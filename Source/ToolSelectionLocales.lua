local addonName, addon = ...

addon.ToolSelectionLocales = {}

local L = addon.ToolSelectionLocales

L["TOOLTIP_EMPTY_BUTTON"] = "Drag your %s profession tool here to have that tool swapped in when relevant."
L["TOOLTIP_RESOURCEFULNESS_DETAIL"] = "This tool will be swapped in for Work Orders, and recipes that don't use Multicraft."
L["TOOLTIP_MULTICRAFT_DETAIL"] = "This tool will be swapped in for recipes that use Multicraft, unless it is a Work Order, or Concentration is being used and an Ingenuity tool is assigned."
L["TOOLTIP_INGENUITY_DETAIL"] = "This tool will be swapped in if you select the option to use Concentration, taking priority over Multicraft."
L["TOOLTIP_SPEED_DETAIL"] = "This tool will be swapped in if the recipe does not use any other stats."
L["TOOLTIP_FINAL_DETAIL"] = "Click to clear this tool. It will then be skipped for lower priority tools."
L["TOOLTIP_ERROR_NOT_FOUND"] = "Error: Could not find the assigned profession tool."

if GetLocale() == "esES" then
    -- L["TOOLTOP_EMPTY_BUTTON"] = ""
end