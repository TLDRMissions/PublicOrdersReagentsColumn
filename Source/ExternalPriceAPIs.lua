local addonName, addon = ...

local function getAuctionatorPrice(itemLink)
    if type(itemLink) == "string" then
        return Auctionator.API.v1.GetAuctionPriceByItemLink(addonName, itemLink) or 0
    else
        return Auctionator.API.v1.GetAuctionPriceByItemID(addonName, itemLink) or 0
    end
end

local function getTSMPrice(itemLink)
    if type(itemLink) == "number" then
        itemLink = "i:"..itemLink
    end
    return TSM_API.GetCustomPriceValue(addon.db.global.TSMPriceString, TSM_API.ToItemString(itemLink)) or 0
end

local function getSearchFunc()
    local currentlySelectedExternal = addon.db.global.preferredExternalAuctionAddon
    
    if C_AddOns.IsAddOnLoaded("TradeSkillMaster") and (currentlySelectedExternal == "TSM") then
        return getTSMPrice
    end
    if C_AddOns.IsAddOnLoaded("Auctionator") and (currentlySelectedExternal == "Auctionator") then
        return getAuctionatorPrice
    end
    
    if C_AddOns.IsAddOnLoaded("TradeSkillMaster") then
        return getTSMPrice
    end
    if C_AddOns.IsAddOnLoaded("Auctionator") then
        return getAuctionatorPrice
    end
end

function addon:getExternalAddonAuctionPrice(itemLink)
    local searchFunc = getSearchFunc()
    if not searchFunc then return end
    
    return searchFunc(itemLink)
end

function addon:isExternalAuctionAddonAvailable()
    return (C_AddOns.IsAddOnLoaded("Auctionator") and Auctionator) or (C_AddOns.IsAddOnLoaded("TradeSkillMaster") and TSM_API)
end