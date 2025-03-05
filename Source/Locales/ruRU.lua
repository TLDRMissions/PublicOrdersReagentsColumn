local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "ruRU")
if not L then return end

-- Tool Selection Frame
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
