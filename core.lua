local addon, ns = ...
local E, M = unpack(vCore);
local cfg = ns.cfg
local lib = ns.lib
--------------

local unpack, type = unpack, type
local RAID_CLASS_COLORS, FACTION_BAR_COLORS = RAID_CLASS_COLORS, FACTION_BAR_COLORS
local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltipStatusBar

cfg.targetColorHex = lib.GetHexColor(cfg.targetColor)
cfg.afkColorHex = lib.GetHexColor(cfg.afkColor)

GameTooltipHeaderText:SetFont(cfg.fontBold, 14, "NONE")
GameTooltipHeaderText:SetShadowOffset(1,-1)
GameTooltipHeaderText:SetShadowColor(0,0,0,0.9)
GameTooltipText:SetFont(cfg.font, 12, "NONE")
GameTooltipText:SetShadowOffset(1,-1)
GameTooltipText:SetShadowColor(0,0,0,0.9)
Tooltip_Small:SetFont(cfg.font, 11, "NONE")
Tooltip_Small:SetShadowOffset(1,-1)
Tooltip_Small:SetShadowColor(0,0,0,0.9)

--gametooltip statusbar
GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT",5,0)
GameTooltipStatusBar:SetPoint("RIGHT",-5,0)
GameTooltipStatusBar:SetPoint("BOTTOM", 0, -5)
GameTooltipStatusBar:SetHeight(4)
GameTooltipStatusBar:SetStatusBarTexture(cfg.barTexture)

E:CreateBackdrop(GameTooltipStatusBar)

hooksecurefunc(GameTooltipStatusBar,"SetStatusBarColor", lib.SetStatusBarColor)

if cfg.pos then hooksecurefunc("GameTooltip_SetDefaultAnchor", lib.SetDefaultAnchor) end

hooksecurefunc("GameTooltip_SetBackdropStyle", lib.SetBackdropStyle)

GameTooltip:HookScript("OnTooltipSetUnit", lib.OnTooltipSetUnit)

--loop over tooltips
local tooltips = { GameTooltip,ShoppingTooltip1,ShoppingTooltip2,ItemRefTooltip,ItemRefShoppingTooltip1,ItemRefShoppingTooltip2,WorldMapTooltip,
WorldMapCompareTooltip1,WorldMapCompareTooltip2,SmallTextTooltip }
for i, tooltip in next, tooltips do
	tooltip:SetScale(cfg.scale)
	if tooltip:HasScript("OnTooltipCleared") then
		tooltip:HookScript("OnTooltipCleared", lib.SetBackdropStyle)
	end
end

--loop over menues
local menues = {
	DropDownList1MenuBackdrop,
	DropDownList2MenuBackdrop,
}
for i, menu in next, menues do
	menu:SetScale(cfg.scale)
end
