local addonName, addon = ...
local libHBDPins = LibStub("HereBeDragons-Pins-2.0")

local DEFAULTS = {
    ["Twilight Ordinance"] = {
        r = 1,
        g = 0,
        b = 0,
    },
    ["Glowing Moth"] = {
        r = 1,
        g = 0,
        b = 0,
    },
}

local initDBIfEmpty
initDBIfEmpty = function()
    -- luacheck: ignore
    for _ in pairs(addon.db.global.MinimapRecolouredNodes) do
        return
    end
    
    for key, data in pairs(DEFAULTS) do
        addon.db.global.MinimapRecolouredNodes[key] = data
    end
    
    initDBIfEmpty = nop
end

local iconDB = {}

local f = CreateFrame("Frame")
f:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
f:RegisterEvent("VIGNETTES_UPDATED")
f:SetScript("OnEvent", function()
    if not addon.db.global.enableMinimapRecolouredNodes then return end
    if IsInInstance() then return end
    
    initDBIfEmpty()

    libHBDPins:RemoveAllMinimapIcons(iconDB)
    
    local mapID = C_Map.GetBestMapForUnit("player")
    
    for vignetteID, vignette in pairs(C_VignetteInfo.GetVignettes()) do
        local vignetteInfo = C_VignetteInfo.GetVignetteInfo(vignette)
        
        if mapID and vignetteInfo and vignetteInfo.onMinimap and vignetteInfo.name and addon.db.global.MinimapRecolouredNodes[vignetteInfo.name] then
            local vignettePosition = C_VignetteInfo.GetVignettePosition(vignette, mapID)
            if vignettePosition then
                local icon = _G["NMNMMinimapIconMask"..vignetteID]
                if not icon then
                    icon = CreateFrame("Frame", "NMNMMinimapIconMask"..vignetteID, Minimap)
                    icon:SetFrameStrata("TOOLTIP")
                    icon:SetFrameLevel(999)
                    icon:SetSize(16, 16)
                    icon:SetPoint("CENTER", Minimap, "CENTER")
                    local texture = icon:CreateTexture(nil, "OVERLAY")
                    icon.texture = texture
                    texture:SetAllPoints()
                    texture:SetTexelSnappingBias(0)
                    texture:SetSnapToPixelGrid(false)
                    icon:Hide()
                end
                
                local data = addon.db.global.MinimapRecolouredNodes[vignetteInfo.name]
                icon.texture:SetVertexColor(data.r, data.g, data.b)
                icon.texture:SetAtlas(vignetteInfo.atlasName)                    
                
                libHBDPins:AddMinimapIconMap(iconDB, icon, mapID, vignettePosition.x, vignettePosition.y, true, true)  
            end
        end
    end
end)

