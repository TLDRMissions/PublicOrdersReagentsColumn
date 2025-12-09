local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhCN")
if not L then return end

-- Options
L["ENABLE_MODULE_CHARACTER"] = "Enable %s Module (This Character)"
L["ENABLE_MODULE_ACCOUNT"] = "Enable %s Module (Account Wide)"
L["TOOL_FLYOUT_MODULE_NAME"] = "Tool Flyout"
L["INCREASED_PADDING_MODULE_NAME"] = "Increased Padding"
L["MOVE_CRAFTING_ORDERS_MODULE_NAME"] = "Move Crafting Orders"
L["TOOL_FLYOUT_MODULE_DESC"] = "如果未选中，则覆盖所有特定于角色的设置"
L["INCREASED_PADDING_MODULE_DESC"] = "使订单每一行加高"
L["MOVE_CRAFTING_ORDERS_MODULE_DESC"] = "处理订单时，将各种按钮移动到始终位于同一位置，例如创建订单和开始订单"

L["NO_WEEKLY_QUEST_WARNING_TEXT"] = "每周专业任务没接!"
L["OFFLINE_WARNING_DISPLAY_TEXT"] = "最近查看的订单"

-- Tool Selection Frame
L["TOOLTIP_EMPTY_BUTTON"] = "将您的%s专业工具拖动到此处，以方便交自动使用该工具"
L["TOOLTIP_RESOURCEFULNESS_DETAIL"] = "这个工具将在做订单，并且不期望产生产能的情况下替换进去"
L["TOOLTIP_MULTICRAFT_DETAIL"] = "这个工具将在产能相关制造，并且不是用于做订单的情况下替换进去"
L["TOOLTIP_INGENUITY_DETAIL"] = "这个工具将在使用奇思的情况下被替换进去"
L["TOOLTIP_SPEED_DETAIL"] = "这个工具将在不关注产能充裕奇思的情况下被替换进去"
L["TOOLTIP_FINAL_DETAIL"] = "单击以清除此工具。对于优先级较低的工具，它将被跳过"
L["TOOLTIP_ERROR_NOT_FOUND"] = "错误：找不到指定的专业工具"
L["PRIORITY_BUTTON_TOOLTIP"] = "如果选中，即使配方期望产生产能，当使用专注时，也会使用您设置的奇思工具"
L["DISABLE_BUTTON_TEXT"] = "禁用自动装备"
L["PRIORTY_BUTTON_SELECTED_TEXT"] = "奇思优先于产能"
L["PRIORTY_BUTTON_DESELECTED_TEXT"] = "产能优先于奇思"
