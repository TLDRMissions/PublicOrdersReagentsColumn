local addonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "zhCN")
if not L then return end

-- Options
L["ENABLE_MODULE_CHARACTER"] = "启用%s模块（本角色）"
L["ENABLE_MODULE_ACCOUNT"] = "启用%s模块（账号通用）"
L["TOOL_FLYOUT_MODULE_NAME"] = "工具弹出按钮"
L["INCREASED_PADDING_MODULE_NAME"] = "增加行高填充"
L["TOOL_FLYOUT_MODULE_DESC"] = "如果未选中，则覆盖所有特定于角色的设置"
L["INCREASED_PADDING_MODULE_DESC"] = "使制作订单的行高增加"
L["MOVE_CRAFTING_ORDERS_MODULE_NAME"] = "移动订单按钮"
L["MOVE_CRAFTING_ORDERS_MODULE_DESC"] = "处理订单时，将各种按钮移动到始终位于同一位置，例如创建订单和开始订单"
L["SUPPRESS_WEEKLY_QUEST_WARNING_NAME"] = "屏蔽“每周专业任务未接”警告"
L["SUPPRESS_WEEKLY_QUEST_WARNING_DESC"] = ""

L["NO_WEEKLY_QUEST_WARNING_TEXT"] = "每周专业任务没接！"
L["OFFLINE_WARNING_DISPLAY_TEXT"] = "最后已知的订单"

L["ENABLE_RECOLOR_MINIMAP_TREASURES_MODULE"] = "启用小地图宝藏重新着色模块"
L["RECOLOR_MINIMAP_TREASURES_MODULE_DESC"] = "此模块将把小地图上的“垃圾”宝藏重新着色为红色"
L["RECOLOR_MINIMAP_TREASURE_NAME"] = "宝藏名称"
L["RECOLOR_MINIMAP_TREASURE_SHADE"] = "色调"
L["RECOLOR_MINIMAP_TREASURE_DESC"] = "从下拉菜单中选择一个宝藏进行编辑，或者在编辑框中输入宝藏名称以添加新的宝藏。选择新的颜色后更改将被保存"

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
