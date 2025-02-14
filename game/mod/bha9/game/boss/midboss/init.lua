local M = Class(boss)
local midboss = M

boss.record.midboss = midboss
midboss.cards = {}
midboss.name = "Belle and Misaki"
midboss.difficulty = "All"
midboss.pos = Vector(0,500)

LoadImageFromFile("misaki_spr", "assets/boss/misaki.png", true, 32,32,false)
SetImageScale("misaki_spr", 0.05)
LoadImageFromFile("belle_spr", "assets/boss/belle.png", true, 32,32,false)
SetImageScale("belle_spr", 0.05)

local hpbar = require("game.ui.hpbar")
local fakeboss = require("game.boss.fakeboss")

function midboss:init(cards)
    local _cards = cards or self.class.cards
    boss.init(self, self.class.pos.x, self.class.pos.y, self.class.name, _cards, New(spellcard_background), "All")
  
    self.belle = fakeboss(self)
    self.belle.x = 240
    self.belle.y = 400
    self.belle.img = "belle_spr"
    local bhp = hpbar(self.belle)

    bhp.cjuice = ColorS("FFC5FFE9")
    bhp.cjuiceflash = ColorS("FFFFD0A3")
    bhp.cback = ColorS("FF070333")
    bhp.cbleed = ColorS("FF025C69")

    self.misaki = fakeboss(self)
    self.misaki.x = -240
    self.misaki.y = 400
    self.misaki.img = "misaki_spr"
    local mhp = hpbar(self.misaki)

    mhp.cjuice = ColorS("FFD897FD")
    mhp.cjuiceflash = ColorS("FFFFD0A3")
    mhp.cback = ColorS("FF16003F")
    mhp.cbleed = ColorS("FF430269")
end

return M