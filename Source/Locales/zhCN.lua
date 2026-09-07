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
L["NO_WEEKLY_QUEST_HEADER"] = "“每周专业任务未接”警告"
L["NO_WEEKLY_QUEST_WARNING_TEXT"] = "每周专业任务没接！"
L["WEEKLY_QUEST_WARNING_ANNOYING_NAME"] = "让“每周专业任务未接”警告变得非常非常烦人"
L["WEEKLY_QUEST_WARNING_ANNOYING_DESC"] = "警告会锁定你的制作按钮，直到你接到任务为止。"

L["OFFLINE_WARNING_DISPLAY_TEXT"] = "最后已知的订单"

L["ENABLE_RECOLOR_MINIMAP_TREASURES_MODULE"] = "启用小地图宝藏重新着色模块"
L["RECOLOR_MINIMAP_TREASURES_MODULE_DESC"] = "此模块将把小地图上的“垃圾”宝藏重新着色为红色"
L["RECOLOR_MINIMAP_TREASURE_NAME"] = "宝藏名称"
L["RECOLOR_MINIMAP_TREASURE_SHADE"] = "色调"
L["RECOLOR_MINIMAP_TREASURE_DESC"] = "从下拉菜单中选择一个宝藏进行编辑，或者在编辑框中输入宝藏名称以添加新的宝藏。选择新的颜色后更改将被保存"

L["PROFILE"] = "配置文件"
L["TREASURES_GROUP_NAME"] = "宝藏"
L["MOXIE_GROUP_NAME"] = "匠人之魄"
L["TOOL_FLYOUT_GROUP_NAME"] = "工具弹出"

L["PREFERRED_AUCTION_ADDON"] = "首选拍卖数据库插件"
L["TSM_PRICE_STRING"] = "TSM: 自定义价格字符串"

L["CUSTOM_EXPIRY_TIME_NAME"] = "如果订单到期时间早于这个小时数，将过期时间显示为红色"

-- Reagents Column
L["REAGENT_ERROR_SHADE"] = "缺少1级材料的客户订单背景颜色"
L["HIGH_RANK_REAGENTS_NAME"] = "接受更高等级的材料"
L["HIGH_RANK_REAGENTS_DESC"] = "如果你只有1级以上的材料，材料格子将不会显示背景颜色"

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

-- Moxie Icon
L["MOXIE_ICON_ACCOUNT_NAME"] = "账号通用：启用匠人之魄图标模块"
L["MOXIE_ICON_ACCOUNT_DESC"] = "在专注图标下方添加一个图标，显示你的专业有多少匠人之魄"
L["MOXIE_ICON_CHARACTER_NAME"] = "角色特定：启用匠人之魄图标模块"
L["MOXIE_ICON_CHARACTER_DESC"] = "与账号通用选项相同，但会为此角色覆盖该选项"
L["MOXIE_ICON_OPTION_SHOW_AND_FLASH"] = "当600及以上时显示并闪烁"
L["MOXIE_ICON_OPTION_USE_INHERITED"] = "使用选定的账号通用选项"

-- Profit / loss module
L["PROFIT_LOSS_HEADER"] = "利润/亏损"
L["PROFIT_LOSS_OPTION"] = "启用利润/亏损列。"
L["PROFIT_LOSS_OPTION_DESC"] = "将替换“客人名称”列，并将该名称移动到鼠标提示中。"
L["Item ID"] = "物品ID"
L["Currency ID"] = "货币ID"
L["Numbers Only!"] = "仅限数字！"
L["Custom Price"] = "自定义价格"
L["PROFIT_LOSS_DROPDOWN_DESC"] = "在此处为灵魂绑定物品设置自定义价格"
L["PROFIT_LOSS_CURRENCY_DROPDOWN_DESC"] = "在此处为货币设置自定义价格"

-- Patron order patrial automation module
L["START_CRAFT_SPEEDUP_GROUP_NAME"] = "跳过客人订单按钮"
L["SKIP_COMPLETE_ORDER_NAME"] = "跳过完成订单按钮"
L["SKIP_COMPLETE_ORDER_DESC"] = "当客人订单出现时完成订单按钮时，自动点击"
L["SKIP_OWN_REAGENT_DESC"] = "跳过内置的关于为客人订单使用你自己的材料的警告"
L["SKIP_START_ORDER_NAME"] = "跳过开始订单按钮"
L["SKIP_START_ORDER_DESC"] = "当客人订单出现时开始订单按钮时，自动点击"
L["MOVE_CREATE_TO_CURSOR_NAME"] = "让创建按钮跟随你的鼠标"
L["MOVE_CREATE_TO_CURSOR_DESC"] = "打开客人订单后，“创建”按钮会跟随鼠标光标移动几秒钟"
L["BLOCK_MOVE_CREATE_TO_CURSOR_NAME"] = "(除非选择了最高品质)"
L["BLOCK_MOVE_CREATE_TO_CURSOR_DESC"] = "例外：如果选择了“最高材料品质”，则不要移动“创建”按钮。"
L["START_CRAFT_BUTTON_NAME"] = "将上述设置应用到此账号的所有已知角色"