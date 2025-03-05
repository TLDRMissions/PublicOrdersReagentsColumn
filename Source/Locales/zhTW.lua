local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhTW")
if not L then return end

-- Tool Selection Frame
L["TOOLTIP_EMPTY_BUTTON"] = "在此處拖動%s的職業工具以使該工具在相關時交換。"
L["TOOLTIP_RESOURCEFULNESS_DETAIL"] = "該工具將換成工作訂單，以及不使用複數製作的配方。"
L["TOOLTIP_MULTICRAFT_DETAIL"] = "除非是工作訂單，否則該工具將交換為使用複數製作的配方。"
L["TOOLTIP_INGENUITY_DETAIL"] = "如果選擇使用濃度的選項，則將交換此工具。"
L["TOOLTIP_SPEED_DETAIL"] = "如果配方不使用任何其他統計數據，則將交換此工具。"
L["TOOLTIP_FINAL_DETAIL"] = "單擊以清除此工具。然後將跳過較低的優先級工具。"
L["TOOLTIP_ERROR_NOT_FOUND"] = "錯誤：找不到指定的專業工具。"
L["PRIORITY_BUTTON_TOOLTIP"] = "如果選擇了，即使配方使用複數製作，也會選擇分配的獨創性工具"
L["DISABLE_BUTTON_TEXT"] = "禁用自動裝備"
L["PRIORTY_BUTTON_SELECTED_TEXT"] = "精明優先複數製作"
L["PRIORTY_BUTTON_DESELECTED_TEXT"] = "複數製作優先精明"
