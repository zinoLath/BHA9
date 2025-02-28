local M = Class(boss)
local midboss = M

boss.record.midboss = midboss
midboss.cards = {
    require("game.boss.midboss.dialog"),
    require("game.boss.midboss.nonspell1"),
    require("game.boss.midboss.spell1"),
    require("game.boss.midboss.spell2"),
}
midboss.name = "Belle and Misaki"
midboss.difficulty = "All"
midboss.pos = Vector(0,300)

LoadImageFromFile("misaki_spr", "assets/boss/misaki.png", true, 32,32,false)
SetImageScale("misaki_spr", 0.05)
LoadImageFromFile("belle_spr", "assets/boss/belle.png", true, 32,32,false)
SetImageScale("belle_spr", 0.05)

LoadImageFromFile("bellesakibg", "assets/boss/bellesakibg.png", true, 0, 0, false)
LoadImageFromFile("bellesakibgmask", "assets/boss/bellesakibgmask.png", true, 0, 0, false)
bellesaki_bg = Class(_spellcard_background)
bellesaki_bg.init = function(self)
    _spellcard_background.init(self)
    _spellcard_background.AddLayer(self, "bellesakibgmask", true, 0, 0, 0, 0, 3, 0, "", 1/2.25, 1/2.25, nil, nil)
    _spellcard_background.AddLayer(self, "bellesakibg", false, 0, 0, 0, 0, 0, 0, "", 1/2.25, 1/2.25, nil, nil)
end
local hpbar = require("game.ui.hpbar")
local fakeboss = require("game.boss.fakeboss")

function midboss:init(cards)
    self.bound = false
    print("midboss:init")
    local _cards = cards or self.class.cards
    print(self.class.cards)
    boss.init(self, self.class.pos.x, self.class.pos.y, self.class.name, _cards, New(bellesaki_bg), "All")
    --error("hrlp")
    self.belle = fakeboss(self)
    self.belle.x = 240
    self.belle.y = 400
    self.belle.bound = false
    self.belle.img = "belle_spr"
    local bhp = hpbar(self.belle)
    self.belle._wisys = BossWalkImageSystem(self.belle)
    self.belle._wisys:SetImage("assets/boss/bellesprite.png", 4,6, {6,4,4,4}, {2,2,2}, 6, 16,16)
    self.belle.hscale, self.belle.vscale = 0.75/2.25, 0.75/2.25

    bhp.cjuice = ColorS("FFC5FFE9")
    bhp.cjuiceflash = ColorS("FFFFD0A3")
    bhp.cback = ColorS("FF070333")
    bhp.cbleed = ColorS("FF025C69")

    self.misaki = fakeboss(self)
    self.misaki.x = -240
    self.misaki.y = 400
    self.misaki.bound = false
    self.misaki.img = "misaki_spr"
    local mhp = hpbar(self.misaki)
    self.misaki._wisys = BossWalkImageSystem(self.misaki)
    self.misaki._wisys:SetImage("assets/boss/misakisprite.png", 4,6, {6,4,4,4}, {2,2,2}, 6, 16,16)
    self.misaki.hscale, self.misaki.vscale = 0.75/2.25, 0.75/2.25

    mhp.cjuice = ColorS("FFD897FD")
    mhp.cjuiceflash = ColorS("FFFFD0A3")
    mhp.cback = ColorS("FF16003F")
    mhp.cbleed = ColorS("FF430269")
end

return midboss