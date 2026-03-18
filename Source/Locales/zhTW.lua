local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhTW")
if not L then return end

-- Options
L["ENABLE_MODULE_CHARACTER"] = "啟用 %s 模組 (此角色)"
L["ENABLE_MODULE_ACCOUNT"] = "啟用 %s 模組 (帳號通用)"
L["TOOL_FLYOUT_MODULE_NAME"] = "工具彈出按鈕"
L["INCREASED_PADDING_MODULE_NAME"] = "增加鋪墊"
L["TOOL_FLYOUT_MODULE_DESC"] = "如果未勾選，則覆蓋所有角色特定的設置"
L["INCREASED_PADDING_MODULE_DESC"] = "讓製作訂單行變得更寬"
L["MOVE_CRAFTING_ORDERS_MODULE_NAME"] = "移動製作訂單"
L["MOVE_CRAFTING_ORDERS_MODULE_DESC"] = "填寫製作訂單時，移動各個按鈕以使其始終位於同一位置，例如'建立訂單'和'開始訂單'"
L["SUPPRESS_WEEKLY_QUEST_WARNING_NAME"] = "抑制'無每週任務'的警告"
L["SUPPRESS_WEEKLY_QUEST_WARNING_DESC"] = ""

L["NO_WEEKLY_QUEST_WARNING_TEXT"] = "缺少每週製作訂單任務！"
L["OFFLINE_WARNING_DISPLAY_TEXT"] = "最後已知的製作訂單"

L["ENABLE_RECOLOR_MINIMAP_TREASURES_MODULE"] = "啟用小地圖寶藏重新著色模組"
L["RECOLOR_MINIMAP_TREASURES_MODULE_DESC"] = "此模組將把小地圖上的“垃圾”寶藏重新著色為紅色"
L["RECOLOR_MINIMAP_TREASURE_NAME"] = "寶藏名稱"
L["RECOLOR_MINIMAP_TREASURE_SHADE"] = "色調"
L["RECOLOR_MINIMAP_TREASURE_DESC"] = "從下拉選單中選擇一個寶藏進行編輯，或者在編輯框中輸入寶藏名稱以新增新的寶藏。選擇新的顏色後更改將被儲存"

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
