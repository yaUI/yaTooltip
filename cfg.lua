local addon, ns = ...
local E, M = unpack(vCore);
local cfg = CreateFrame("Frame")
--------------

cfg.mouseOverTooltip = false

cfg.textColor = {0.8,0.8,0.8}
cfg.bossColor = {1,0,0}
cfg.eliteColor = {1,0,0.5}
cfg.rareeliteColor = {1,0.5,0}
cfg.rareColor = {1,0.5,0}
cfg.levelColor = {0.8,0.8,0.5}
cfg.deadColor = {0.5,0.5,0.5}
cfg.targetColor = {1,0.5,0.5}
cfg.guildColor = {1,0,1}
cfg.afkColor = {0,1,1}
cfg.scale = 1.05
cfg.azeriteBorderColor = {1,0.3,0,1}

--pos can be either a point table or a anchor string
--cfg.pos = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -10, 180 }
cfg.pos = "ANCHOR_NONE" --"ANCHOR_CURSOR"

cfg.whiteSquare = M:Fetch("vui", "backdrop")
cfg.barTexture = M:Fetch("vui", "statusbar")
cfg.fontBold = M:Fetch("font", "RobotoBold")
cfg.font = M:Fetch("font", "Roboto")

---------------
ns.cfg = cfg
