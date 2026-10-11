local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "ruRU")
if not L then return end
-- Translator ZamestoTV
-- Options
L["ENABLE_MODULE_CHARACTER"] = "Включить модуль %s (для этого персонажа)"
L["ENABLE_MODULE_ACCOUNT"] = "Включить модуль %s (для всей учетной записи)"
L["TOOL_FLYOUT_MODULE_NAME"] = "Всплывающее меню инструментов"
L["INCREASED_PADDING_MODULE_NAME"] = "Увеличенные отступы"
L["TOOL_FLYOUT_MODULE_DESC"] = "Если флажок снят, это переопределит все индивидуальные настройки персонажей"
L["INCREASED_PADDING_MODULE_DESC"] = "Делает строки заказов на изготовление очень широкими"
L["MOVE_CRAFTING_ORDERS_MODULE_NAME"] = "Перемещение элементов заказов"
L["MOVE_CRAFTING_ORDERS_MODULE_DESC"] = "При выполнении заказов на изготовление перемещает различные кнопки (например, Создать заказ и Принять заказ) так, чтобы они всегда находились в одном и том же месте"

L["SUPPRESS_WEEKLY_QUEST_WARNING_NAME"] = "Скрыть предупреждение 'Нет еженедельного задания'"
L["SUPPRESS_WEEKLY_QUEST_WARNING_DESC"] = ""
L["NO_WEEKLY_QUEST_HEADER"] = "Предупреждение 'Нет еженедельного задания'"
L["NO_WEEKLY_QUEST_WARNING_TEXT"] = "Отсутствует еженедельное задание на заказы!"
L["WEEKLY_QUEST_WARNING_ANNOYING_NAME"] = "Сделать предупреждение 'Нет еженедельного задания' очень-очень раздражающим"
L["WEEKLY_QUEST_WARNING_ANNOYING_DESC"] = "Предупреждение будет блокировать кнопки заказа, пока вы не возьмете задание"

L["OFFLINE_WARNING_DISPLAY_TEXT"] = "Последние известные заказы на изготовление"

L["ENABLE_RECOLOR_MINIMAP_TREASURES_MODULE"] = "Включить модуль перекраски сокровищ на миникарте"
L["RECOLOR_MINIMAP_TREASURES_MODULE_DESC"] = "Этот модуль перекрашивает 'Хлам' из сокровищ на вашей миникарте в красный цвет"
L["RECOLOR_MINIMAP_TREASURE_NAME"] = "Название сокровища"
L["RECOLOR_MINIMAP_TREASURE_SHADE"] = "Оттенок"
L["RECOLOR_MINIMAP_TREASURE_DESC"] = "Выберите сокровище из выпадающего списка для редактирования или введите название сокровища в поле ввода, чтобы добавить новое. Изменения сохраняются при выборе нового цвета"

L["PROFILE"] = "Профиль"
L["TREASURES_GROUP_NAME"] = "Сокровища"
L["MOXIE_GROUP_NAME"] = "Пыл"
L["TOOL_FLYOUT_GROUP_NAME"] = "Всплывающее меню инструментов"

L["PREFERRED_AUCTION_ADDON"] = "Предпочитаемый аддон базы данных аукциона"
L["TSM_PRICE_STRING"] = "TSM: Своя строка цены"

L["CUSTOM_EXPIRY_TIME_NAME"] = "Окрашивать время действия в красный, если до истечения заказа осталось меньше указанного количества часов"

-- Reagents Column
L["REAGENT_ERROR_SHADE"] = "Цвет фона при отсутствии реагентов 1-го ранга для заказов"
L["HIGH_RANK_REAGENTS_NAME"] = "Разрешить реагенты более высокого ранга"
L["HIGH_RANK_REAGENTS_DESC"] = "Ячейка реагента не будет подсвечиваться цветом фона, если у вас есть только реагенты выше 1-го ранга"

-- Tool Selection Frame
L["TOOLTIP_EMPTY_BUTTON"] = "Перетащите сюда инструмент для профессии %s, чтобы он автоматически экипировался при необходимости."
L["TOOLTIP_RESOURCEFULNESS_DETAIL"] = "Этот инструмент будет экипироваться для заказов, а также для рецептов, которые не используют мультикрафт."
L["TOOLTIP_MULTICRAFT_DETAIL"] = "Этот инструмент будет экипироваться для рецептов, использующих мультикрафт, кроме заказов."
L["TOOLTIP_INGENUITY_DETAIL"] = "Этот инструмент будет экипироваться при выборе опции использования концентрации."
L["TOOLTIP_SPEED_DETAIL"] = "Этот инструмент будет экипироваться, если рецепт не использует никакие другие характеристики."
L["TOOLTIP_FINAL_DETAIL"] = "Нажмите, чтобы убрать этот инструмент. В таком случае вместо него будут использоваться инструменты с более низким приоритетом."
L["TOOLTIP_ERROR_NOT_FOUND"] = "Ошибка: не удалось найти назначенный инструмент для профессии."
L["PRIORITY_BUTTON_TOOLTIP"] = "Если выбрано, назначенный инструмент на изобретательность будет использоваться при включенной концентрации, даже если рецепт использует мультикрафт."
L["DISABLE_BUTTON_TEXT"] = "Отключить автоэкипировку"
L["PRIORTY_BUTTON_SELECTED_TEXT"] = "Изобретательность важнее Мультикрафта"
L["PRIORTY_BUTTON_DESELECTED_TEXT"] = "Мультикрафт важнее Изобретательности"

-- Moxie Icon
L["MOXIE_ICON_ACCOUNT_NAME"] = "Для всей учетной записи: включить модуль иконки Пыла"
L["MOXIE_ICON_ACCOUNT_DESC"] = "Добавляет под иконкой Концентрации еще одну иконку, которая показывает, сколько Пыла у вашей профессии"
L["MOXIE_ICON_CHARACTER_NAME"] = "Для текущего персонажа: включить модуль иконки Пыла"
L["MOXIE_ICON_CHARACTER_DESC"] = "То же самое, что и опция для всей учетной записи, но переопределяет этот выбор для данного персонажа"
L["MOXIE_ICON_OPTION_SHOW_AND_FLASH"] = "Показывать и мигать при 600 и более"
L["MOXIE_ICON_OPTION_USE_INHERITED"] = "Использовать настройку для всей учетной записи"

-- Profit / loss module
L["PROFIT_LOSS_HEADER"] = "Прибыль / Убыток"
L["PROFIT_LOSS_OPTION"] = "Включить колонку Прибыль / Убыток."
L["PROFIT_LOSS_OPTION_DESC"] = "Заменит колонку Имя, перенеся его имя во всплывающую подсказку при наведении мыши."
L["Item ID"] = true
L["Currency ID"] = true
L["Numbers Only!"] = true
L["Custom Price"] = true
L["PROFIT_LOSS_DROPDOWN_DESC"] = "Задайте здесь свои цены для персональных предметов"
L["PROFIT_LOSS_CURRENCY_DROPDOWN_DESC"] = "Задайте здесь свои цены для валют"

-- Patron order patrial automation module
L["START_CRAFT_SPEEDUP_GROUP_NAME"] = "Пропуск кнопок заказов"
L["SKIP_COMPLETE_ORDER_NAME"] = "Пропуск кнопки Выполнить заказ"
L["SKIP_COMPLETE_ORDER_DESC"] = "Автоматически нажимает кнопку Выполнить заказ, когда она появляется в заказах"
L["SKIP_OWN_REAGENT_NAME"] = "Пропуск предупреждения о своих реагентах"
L["SKIP_OWN_REAGENT_DESC"] = "Пропускает встроенное предупреждение об использовании собственных реагентов для заказов"
L["SKIP_START_ORDER_NAME"] = "Пропуск кнопки Принять заказ"
L["SKIP_START_ORDER_DESC"] = "Автоматически нажимает кнопку Принять заказ, когда она появляется в заказах"
L["MOVE_CREATE_TO_CURSOR_NAME"] = "Кнопка Создать следует за курсором"
L["MOVE_CREATE_TO_CURSOR_DESC"] = "Кнопка Создать будет следовать за курсором мыши в течение нескольких секунд после открытия заказа"
L["BLOCK_MOVE_CREATE_TO_CURSOR_NAME"] = "(Кроме случаев выбора наилучшего качества)"
L["BLOCK_MOVE_CREATE_TO_CURSOR_DESC"] = "Исключение: не перемещать кнопку Создать, если выбрана опция Реагенты наилучшего качества"
L["START_CRAFT_BUTTON_NAME"] = "Применить эти настройки ко всем известным персонажам на этой учетной записи"
