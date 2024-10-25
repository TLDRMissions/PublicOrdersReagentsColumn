-- Fixes a UI bug introduced in 11.0.5
-- See: https://github.com/Stanzilla/WoWUIBugs/issues/677

function ProfessionsCrafterTableCellItemNameMixin:Populate(rowData, dataIndex)
	local order = rowData.option;

	local item;

	if order.reagents and #order.reagents > 0 then
		-- Customer provided finishing reagents can alter the quality of the output item.
		-- Calculate the exact item output based on these reagents so that quality is correct.
		local transaction = ProfessionsUtil.CreateProfessionsRecipeTransactionFromCraftingOrder(order);
		local outputItemInfo = C_TradeSkillUI.GetRecipeOutputItemData(transaction:GetRecipeID(), transaction:CreateCraftingReagentInfoTbl());
		item = Item:CreateFromItemLink(outputItemInfo.hyperlink);
        self.rowData.option.itemID = outputItemInfo.itemID
	else
		item = Item:CreateFromItemID(order.itemID);
	end

	item:ContinueOnItemLoad(function()
		if item:GetItemID() ~= self.rowData.option.itemID then
			-- Callback from a previous async request
			return;
		end
		local icon = item:GetItemIcon();
		self.Icon:SetTexture(icon);

		local qualityColor = item:GetItemQualityColor().color;
		local itemName = qualityColor:WrapTextInColorCode(item:GetItemName());
		if order.isRecraft then
			itemName = PROFESSIONS_RECRAFT_ORDER_NAME_FMT:format(itemName);
		end
		if order.minQuality and order.minQuality > 1 then
			local smallIcon = true;
			local qualityAtlas = Professions.GetChatIconMarkupForQuality(order.minQuality, smallIcon);
			itemName = itemName.." "..qualityAtlas;
		end

		self.Text:SetText(itemName);
	end);
end