-- This code adapted from Blizzard_Professions\Blizzard_ProfessionsCrafterOrderPage.lua
-- The existing function ProfessionsFrame.OrdersPage:SetupTable() hides the Reagents column for Public Orders
-- This code simply shows it again.

local OrderBrowseType = EnumUtil.MakeEnum("Flat", "Bucketed", "None");

hooksecurefunc(ProfessionsFrame.OrdersPage, "SetupTable", function(self)
	local browseType = self:GetBrowseType();
    local PTC = ProfessionsTableConstants;

	if browseType == OrderBrowseType.Flat then
		if self.orderType == Enum.CraftingOrderType.Public then
			self.tableBuilder:AddFixedWidthColumn(self, PTC.NoPadding, PTC.Reagents.Width, PTC.Reagents.LeftCellPadding,
										  		  PTC.Reagents.RightCellPadding, ProfessionsSortOrder.Reagents, "ProfessionsCrafterTableCellReagentsTemplate");
		end
        self.tableBuilder:Arrange();
    end
end)
