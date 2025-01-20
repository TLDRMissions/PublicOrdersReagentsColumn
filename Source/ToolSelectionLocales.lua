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
end