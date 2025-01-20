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

if GetLocale() == "ruRU" then
    L["TOOLTIP_EMPTY_BUTTON"] = "Перетащите сюда инструмент вашей профессии %s, чтобы заменить его при необходимости."
    L["TOOLTIP_RESOURCEFULNESS_DETAIL"] = "Этот инструмент будет заменен на рабочие заказы и рецепты, не использующие мультикрафт."
    L["TOOLTIP_MULTICRAFT_DETAIL"] = "Этот инструмент будет заменен на рецепты, использующие мультикрафт, если только это не заказ на работу."
    L["TOOLTIP_INGENUITY_DETAIL"] = "Этот инструмент будет заменен, если вы выберете опцию использования концентрации."
    L["TOOLTIP_SPEED_DETAIL"] = "Этот инструмент будет заменен, если рецепт не использует никаких других характеристик."
    L["TOOLTIP_FINAL_DETAIL"] = "Нажмите, чтобы очистить этот инструмент. Затем он будет пропущен для инструментов с более низким приоритетом."
    L["TOOLTIP_ERROR_NOT_FOUND"] = "Ошибка: Не удалось найти инструмент назначенной профессии."
    L["PRIORITY_BUTTON_TOOLTIP"] = "Если выбрано, ваш назначенный инструмент Изобретательности будет использоваться при выборе Концентрации, даже если рецепт использует Мультикрафт"
    L["DISABLE_BUTTON_TEXT"] = "Отключить автоматическое оснащение"
    L["PRIORTY_BUTTON_SELECTED_TEXT"] = "Изобретательность в отношении мультикрафта"
    L["PRIORTY_BUTTON_DESELECTED_TEXT"] = "Мультикрафт важнее изобретательности"
elseif locale == "zhTW" then
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
end
