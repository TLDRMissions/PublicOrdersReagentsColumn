local addonName = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- datamine from https://www.wowhead.com/search?q=services+requested
-- 1 = Blacksmithing, 2 = Leatherworking, 3 = Alchemy, 7 = Tailoring, 8 = Engineering, 12 = Jewelcrafting, 13 = Inscription
local db = {
    DF = {
        [1] = 70589, [2] = 70594, [7] = 70595, [8] = 70591, [12] = 70593, [13] = 70592,
    },
    TWW = {
        [3] = 84133, [1] = 84127, [7] = 84132, [8] = 84128, [12] = 84130, [2] = 84131, [13] = 84129,
    },
}

local warningFrame = ProfessionsFrame.NoWeeklyQuestWarning
warningFrame:SetParent(ProfessionsFrame.OrdersPage.BrowseFrame)
warningFrame:SetPoint("TOP", ProfessionsFrame.OrdersPage, "TOP", 0, -31)
warningFrame.Text:SetText(L["NO_WEEKLY_QUEST_WARNING_TEXT"])

local function checkVisible()
    warningFrame:Hide()
    local professionID = ProfessionsFrame.professionInfo.profession
    if not professionID then return end
    local questID
    if GetExpansionLevel() == 9 then
        questID = db.DF[professionID]
    elseif GetExpansionLevel() == 10 then
        questID = db.TWW[professionID]
    end
    if not questID then return end
    if C_QuestLog.IsOnQuest(questID) or C_QuestLog.IsQuestFlaggedCompleted(questID) then return end
    warningFrame:Show()
end

ProfessionsFrame.OrdersPage:HookScript("OnShow", checkVisible)
ProfessionsFrame:HookScript("OnShow", function()
    if ProfessionsFrame.tabSystem.selectedTabID == ProfessionsFrame.craftingOrdersTabID then
        RunNextFrame(checkVisible)
    end
end)
