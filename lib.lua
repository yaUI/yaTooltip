local addon, ns = ...
local E, M = unpack(vCore);
local cfg = ns.cfg
local lib = CreateFrame("Frame")
--------------

local unpack, type = unpack, type
local ICON_LIST = ICON_LIST
local GameTooltip, GameTooltipStatusBar = GameTooltip, GameTooltipStatusBar
local GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8 = GameTooltipTextLeft1, GameTooltipTextLeft2, GameTooltipTextLeft3, GameTooltipTextLeft4, GameTooltipTextLeft5, GameTooltipTextLeft6, GameTooltipTextLeft7, GameTooltipTextLeft8
local classColorHex, factionColorHex = {}, {}

lib.GetHexColor = function(color)
	if color.r then
		return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
	else
		local r,g,b,a = unpack(color)
		return ("%.2x%.2x%.2x"):format(r*255, g*255, b*255)
	end
end

--hex class colors
for class, color in next, RAID_CLASS_COLORS do
	classColorHex[class] = lib.GetHexColor(color)
end
--hex reaction colors
--for idx, color in next, FACTION_BAR_COLORS do
for i = 1, #FACTION_BAR_COLORS do
	factionColorHex[i] = lib.GetHexColor(FACTION_BAR_COLORS[i])
end

lib.SetBackdropStyle = function(self, style)
	if self:IsForbidden() then return end -- don't mess with forbidden frames, which sometimes randomly happens
	if self.TopOverlay then self.TopOverlay:Hide() end
	if self.BottomOverlay then self.BottomOverlay:Hide() end

	E:SkinBackdrop(self, .9)

	local _, itemLink = self:GetItem()
	if itemLink then
		local azerite = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) or C_AzeriteItem.IsAzeriteItemByID(itemLink) or false
		local _, _, itemRarity = GetItemInfo(itemLink)
		local r, g, b = 1,1,1
		if itemRarity then r, g, b = GetItemQualityColor(itemRarity) end
		--use azerite coloring or item rarity
		if azerite and cfg.azeriteBorderColor then
			self:SetBackdropBorderColor(unpack(cfg.azeriteBorderColor))
		else
			self:SetBackdropBorderColor(r, g, b, 1)
		end
	end
end

lib.SetStatusBarColor = function(self, r, g, b)
	if not cfg.barColor then return end
	if r == cfg.barColor.r and g == cfg.barColor.g and b == cfg.barColor.b then return end
	self:SetStatusBarColor(cfg.barColor.r, cfg.barColor.g, cfg.barColor.b)
end

lib.SetDefaultAnchor = function(self, parent)
	if not cfg.pos then return end
	if type(cfg.pos) == "string" then
		self:SetOwner(parent, cfg.pos)
	else
		self:SetOwner(parent, "ANCHOR_NONE")
		self:ClearAllPoints()
		self:SetPoint(unpack(cfg.pos))
	end
end

lib.GetTarget = function(unit)
	if UnitIsUnit(unit, "player") then
		return ("|cffff0000%s|r"):format("<YOU>")
	elseif UnitIsPlayer(unit, "player") then
		local _, class = UnitClass(unit)
		return ("|cff%s%s|r"):format(classColorHex[class], UnitName(unit))
	elseif UnitReaction(unit, "player") then
		return ("|cff%s%s|r"):format(factionColorHex[UnitReaction(unit, "player")], UnitName(unit))
	else
		return ("|cffffffff%s|r"):format(UnitName(unit))
	end
end

lib.OnTooltipSetUnit = function(self)
	local unitName, unit = self:GetUnit()
	if not unit then return end
	--color tooltip textleft2..8
	GameTooltipTextLeft2:SetTextColor(unpack(cfg.textColor))
	GameTooltipTextLeft3:SetTextColor(unpack(cfg.textColor))
	GameTooltipTextLeft4:SetTextColor(unpack(cfg.textColor))
	GameTooltipTextLeft5:SetTextColor(unpack(cfg.textColor))
	GameTooltipTextLeft6:SetTextColor(unpack(cfg.textColor))
	GameTooltipTextLeft7:SetTextColor(unpack(cfg.textColor))
	GameTooltipTextLeft8:SetTextColor(unpack(cfg.textColor))
	--position raidicon
	--local raidIconIndex = GetRaidTargetIndex(unit)
	--if raidIconIndex then
	--  GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[raidIconIndex].."14|t", unitName))
	--end
	if not UnitIsPlayer(unit) then
	--unit is not a player
	--color textleft1 and statusbar by faction color
	local reaction = UnitReaction(unit, "player")
	if reaction then
		local color = FACTION_BAR_COLORS[reaction]
		if color then
		cfg.barColor = color
		GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
		GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
		end
	end
	--color textleft2 by classificationcolor
	local unitClassification = UnitClassification(unit)
	local levelLine
	if string.find(GameTooltipTextLeft2:GetText() or "empty", "%a%s%d") then
		levelLine = GameTooltipTextLeft2
	elseif string.find(GameTooltipTextLeft3:GetText() or "empty", "%a%s%d") then
		GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor)) --seems like the npc has a description, use the guild color for this
		levelLine = GameTooltipTextLeft3
	end
	if levelLine then
		local l = UnitLevel(unit)
		local color = GetCreatureDifficultyColor((l > 0) and l or 999)
		levelLine:SetTextColor(color.r,color.g,color.b)
	end
	if unitClassification == "worldboss" or UnitLevel(unit) == -1 then
		self:AppendText(" |TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t")
		--GameTooltipTextLeft1:SetText(("%s%s"):format("|TInterface\\TargetingFrame\\UI-TargetingFrame-Skull:14:14|t", unitName))
		GameTooltipTextLeft2:SetTextColor(unpack(cfg.bossColor))
	elseif unitClassification == "rare" then
		self:AppendText(" |TInterface\\HelpFrame\\HotIssueIcon:14:14|t")
	elseif unitClassification == "rareelite" then
		self:AppendText(" |TInterface\\HelpFrame\\HotIssueIcon:14:14|t")
	elseif unitClassification == "elite" then
		self:AppendText(" |TInterface\\HelpFrame\\HotIssueIcon:14:14|t")
	end
	else
	--unit is any player
	local _, unitClass = UnitClass(unit)
	--color textleft1 and statusbar by class color
	local color = RAID_CLASS_COLORS[unitClass]
	cfg.barColor = color
	GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
	GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
	--color textleft2 by guildcolor
	local unitGuild = GetGuildInfo(unit)
	if unitGuild then
		GameTooltipTextLeft2:SetText("<"..unitGuild..">")
		GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor))
	end
	local levelLine = unitGuild and GameTooltipTextLeft3 or GameTooltipTextLeft2
	local l = UnitLevel(unit)
	local color = GetCreatureDifficultyColor((l > 0) and l or 999)
	levelLine:SetTextColor(color.r,color.g,color.b)
	--afk?
	if UnitIsAFK(unit) then
		self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
	end
	end

	--dead?
	if UnitIsDeadOrGhost(unit) then
		GameTooltipTextLeft1:SetTextColor(unpack(cfg.deadColor))
	end

  	--target line
	if (UnitExists(unit.."target")) then
		GameTooltip:AddDoubleLine(("|cff%s%s|r"):format(cfg.targetColorHex, "Target"), lib.GetTarget(unit.."target") or "Unknown")
	end
end

--------------
ns.lib = lib
