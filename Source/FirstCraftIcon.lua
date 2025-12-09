local addonName, addon = ...

local function createFirstCraftButton(cell)
    local button = CreateFrame("Button")
    button:SetSize(16, 15)
    button.Icon = button:CreateTexture(nil, "OVERLAY")
    button.Icon:SetAtlas("professions_icon_firsttimecraft", true)
    button.Icon:SetPoint("CENTER")
    cell.FirstCraft = button
    return button
end

function addon.firstCraftIconHandler(self)
    local rows = self.BrowseFrame.OrderList.ScrollBox:GetView().frames
    
    for _, row in ipairs(rows) do
        local skillLineAbilityID = row.rowData.option.skillLineAbilityID
        local recipeInfo = C_TradeSkillUI.GetRecipeInfoForSkillLineAbility(skillLineAbilityID)
        
        local cell = row.cells[1]
        local cellOfx = 0
        if cell.SkillUps and cell.SkillUps:IsShown() then
            cellOfx = 20
        end
        
        local firstCraftButton = cell.FirstCraft or createFirstCraftButton(cell)
        firstCraftButton:Hide()
    
    	if C_TradeSkillUI.IsRecipeFirstCraft(recipeInfo.recipeID) then
            cell.Icon:SetPoint("LEFT", cell, "LEFT", cellOfx + 16, 0)
            firstCraftButton:SetParent(cell)
            firstCraftButton:SetPoint("LEFT", cell, "LEFT", 0, 0)
            if cell.SkillUps and cell.SkillUps:IsShown() then
                cell.SkillUps:SetPoint("LEFT", cell, "LEFT", 10, 0)
            end
            firstCraftButton:Show()
    	end
    end
end