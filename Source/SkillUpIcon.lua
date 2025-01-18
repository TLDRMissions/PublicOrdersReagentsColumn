local addonName, addon = ...

local DifficultyColors = {
	[Enum.TradeskillRelativeDifficulty.Optimal] = DIFFICULT_DIFFICULTY_COLOR,
	[Enum.TradeskillRelativeDifficulty.Medium]	= FAIR_DIFFICULTY_COLOR,
	[Enum.TradeskillRelativeDifficulty.Easy] = EASY_DIFFICULTY_COLOR,
};

local function createSkillUpButton(cell)
    local button = CreateFrame("Button")
    button:SetSize(26, 15)
    button.Icon = button:CreateTexture(nil, "OVERLAY")
    button.Icon:SetPoint("RIGHT", 0, -1)
    button.Text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight_NoShadow")
    button.Text:SetSize(0, 13)
    button.Text:SetPoint("RIGHT", button.Icon, "LEFT", 0, 1)
    cell.SkillUps = button
    return button
end

function addon.skillUpIconHandler(self, orders, browseType, offset, isSorted)
    local rows = self.BrowseFrame.OrderList.ScrollBox:GetView().frames
    
    for rowID, row in ipairs(rows) do
        local skillLineAbilityID = row.rowData.option.skillLineAbilityID
        local recipeInfo = C_TradeSkillUI.GetRecipeInfoForSkillLineAbility(skillLineAbilityID)
        
        local cell = row.cells[1]
        cell.Icon:SetPoint("LEFT", cell, "LEFT", 0, 0)
        
        local skillUpButton = cell.SkillUps or createSkillUpButton(cell)
        skillUpButton:Hide()
    
    	-- Adapted from Blizzard_ProfessionsRecipeList.lua - ProfessionsRecipeListRecipeMixin:Init
        if recipeInfo.canSkillUp and not C_TradeSkillUI.IsTradeSkillGuild() and not C_TradeSkillUI.IsNPCCrafting() and not C_TradeSkillUI.IsRuneforging() then
    		local skillUpAtlas;
    		local xOfs = -9;
    		local yOfs = 0;

    		local isDifficultyOptimal = recipeInfo.relativeDifficulty == Enum.TradeskillRelativeDifficulty.Optimal;
    		local tooltipSkillUpString = nil;
    		if recipeInfo.relativeDifficulty == Enum.TradeskillRelativeDifficulty.Easy then
    			skillUpAtlas = "Professions-Icon-Skill-Low";
    			tooltipSkillUpString = PROFESSIONS_SKILL_UP_EASY;
    		elseif recipeInfo.relativeDifficulty == Enum.TradeskillRelativeDifficulty.Medium then
    			skillUpAtlas = "Professions-Icon-Skill-Medium";
    			tooltipSkillUpString = PROFESSIONS_SKILL_UP_MEDIUM;
    		elseif isDifficultyOptimal then
    			skillUpAtlas = "Professions-Icon-Skill-High";
    			tooltipSkillUpString = PROFESSIONS_SKILL_UP_OPTIMAL;
    			yOfs = 1;
    		end
            
    		if skillUpAtlas then
    			skillUpButton:ClearAllPoints();
    			skillUpButton:SetPoint("LEFT", cell, "LEFT", xOfs, yOfs);

    			skillUpButton.Icon:SetAtlas(skillUpAtlas, TextureKitConstants.UseAtlasSize);
    			local numSkillUps = recipeInfo.numSkillUps;
    			local hasMultipleSkillUps = numSkillUps > 1;
    			local hasSkillUps = numSkillUps > 0;
    			local showText = hasMultipleSkillUps and isDifficultyOptimal;
    			skillUpButton.Text:SetShown(showText);
    			if hasSkillUps then
    				if showText then
    					skillUpButton.Text:SetText(numSkillUps);
    					skillUpButton.Text:SetVertexColor(DifficultyColors[recipeInfo.relativeDifficulty]:GetRGB());
    				end
    			end
                
                cell.Icon:SetPoint("LEFT", cell, "LEFT", 20, 0)
                skillUpButton:SetParent(cell)
                skillUpButton:SetPoint("LEFT", cell, "LEFT", 0, 0)
    			skillUpButton:Show();
    		end
    	end
    end
end