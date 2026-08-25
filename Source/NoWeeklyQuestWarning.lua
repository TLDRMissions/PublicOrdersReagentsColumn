local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- datamine from https://www.wowhead.com/search?q=services+requested
-- 1 = Blacksmithing, 2 = Leatherworking, 3 = Alchemy, 7 = Tailoring, 8 = Engineering, 12 = Jewelcrafting, 13 = Inscription
local db = {
    [9] = {
        [1] = 70589, [2] = 70594, [7] = 70595, [8] = 70591, [12] = 70593, [13] = 70592,
    },
    [10] = {
        [3] = 84133, [1] = 84127, [7] = 84132, [8] = 84128, [12] = 84130, [2] = 84131, [13] = 84129,
    },
    [11] = {
        [1] = 93691, [2] = 93695, [3] = 93690, [7] = 93696, [8] = 93692, [12] = 93694, [13] = 93693,
    },
}

local warningFrame = ProfessionsFrame.NoWeeklyQuestWarning
warningFrame:SetParent(ProfessionsFrame.OrdersPage.BrowseFrame)
warningFrame:SetPoint("TOP", ProfessionsFrame.OrdersPage, "TOP", 0, -31)
warningFrame.Text:SetText(L["NO_WEEKLY_QUEST_WARNING_TEXT"])

local annoyingFrame1 = ProfessionsFrame.NoWeeklyQuestAnnoyingBottomLeft
annoyingFrame1:SetParent(ProfessionsFrame.OrdersPage.OrderView)
annoyingFrame1:SetFrameStrata("TOOLTIP")
annoyingFrame1:SetPoint("BOTTOMLEFT", ProfessionsFrame.OrdersPage.OrderView, "BOTTOMLEFT", 40, 80)
annoyingFrame1.Text:SetText(L["NO_WEEKLY_QUEST_WARNING_TEXT"])
annoyingFrame1:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
annoyingFrame1:SetBackdropColor(0, 0, 0, 1)

local annoyingFrame2 = ProfessionsFrame.NoWeeklyQuestAnnoyingBottomRight
annoyingFrame2:SetParent(ProfessionsFrame.OrdersPage.OrderView)
annoyingFrame2:SetFrameStrata("TOOLTIP")
annoyingFrame2:SetPoint("BOTTOMRIGHT", ProfessionsFrame.OrdersPage.OrderView, "BOTTOMRIGHT", -10, 3)
annoyingFrame2.Text:SetText(L["NO_WEEKLY_QUEST_WARNING_TEXT"])
annoyingFrame2:SetBackdrop({
	bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
annoyingFrame2:SetBackdropColor(0, 0, 0, 1)

local function checkVisible()
    warningFrame:Hide()
    local professionID = ProfessionsFrame.professionInfo.profession
    if not professionID then return end
    local questID = db[GetExpansionLevel()]
    if questID then
        questID = questID[professionID]
    end
    if not questID then return end
    if C_QuestLog.IsOnQuest(questID) or C_QuestLog.IsQuestFlaggedCompleted(questID) then return end
    warningFrame:Show()
    
    if addon.db.global.makeNoWeeklyQuestWarningReallyAnnoying then
        annoyingFrame1:Show()
        annoyingFrame2:Show()
    end
end

ProfessionsFrame.OrdersPage:HookScript("OnShow", checkVisible)
ProfessionsFrame:HookScript("OnShow", function()
    annoyingFrame1:Hide()
    annoyingFrame2:Hide()
    if addon.db.global.suppressNoWeeklyQuestWarning then return end
    if ProfessionsFrame.tabSystem.selectedTabID == ProfessionsFrame.craftingOrdersTabID then
        RunNextFrame(checkVisible)
    end
end)
