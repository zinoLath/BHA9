local M = Class(boss)
local haiji = M

boss.record.haiji = haiji
haiji.cards = {}
haiji.name = "Haiji Senri"
haiji.difficulty = "All"
haiji.pos = lstg.Vector2(240,384)

local hpbar = require("game.ui.hpbar")

haiji.cards = {
    require("game.boss.haiji.dialog"),
    require("game.boss.haiji.nonspell1"),
    require("game.boss.haiji.spell1"),
    require("game.boss.haiji.nonspell2"),
    require("game.boss.haiji.spell2"),
    require("game.boss.haiji.nonspell3"),
    require("game.boss.haiji.spell3"),
    require("game.boss.haiji.nonspell4"),
    require("game.boss.haiji.spell4"),
    require("game.boss.haiji.nonspell5"),
    require("game.boss.haiji.spell5"),
    require("game.boss.haiji.nonspell6"),
    require("game.boss.haiji.spell6"),
    require("game.boss.haiji.nonspell7"),
    require("game.boss.haiji.spell7"),
    require("game.boss.haiji.nonspell8"),
    require("game.boss.haiji.spell8"),
    require("game.boss.haiji.nonspell9"),
    require("game.boss.haiji.spell9"),
}
LoadImageFromFile("haijibg", "assets/boss/haijibg.png", true, 0, 0, false)
LoadTexture("haijitex", "assets/boss/haijitex.png",true)
SetTextureSamplerState("haijitex","linear+wrap")
haiji_bg = Class(_spellcard_background)
local afor = require("zinolib.advancedfor")
local tw, th = GetTextureSize("haijitex")
function RenderJunkoBg(layer)
    
    local r1 = 0
    local r2 = Dist(0,0,lstg.world.r,lstg.world.t)*2

    local iimg = "haijitex"
    local n = 128
    local x, y = 0,120

    local cw = Color(128,255,255,255)
    local uvoff = Vector(0,layer.timer)
    for i=1,n do
        local da = 360/n
        local a = math.lerp(0,360,i/n)
        local v1 = Vector(r1 * cos(a + da) + x, r1 * sin(a + da) + y)
        local v2 = Vector(r2 * cos(a + da) + x, r2 * sin(a + da) + y)
        local v3 = Vector(r2 * cos(a) + x, r2 * sin(a) + y)
        local v4 = Vector(r1 * cos(a) + x, r1 * sin(a) + y)
        local w = tw*2
        local u1, u2 = math.lerp(0,w,(i+1)/n)+uvoff.x, math.lerp(0,w,(i)/n)+uvoff.x
        local vv1, vv2 = r1+uvoff.y, r2*2+uvoff.y
        print(u1)
        RenderTexture(iimg,"mul+mul",
            {v1.x, v1.y,0, u1, vv2,cw},
            {v2.x, v2.y,0, u1, vv1,cw},
            {v3.x, v3.y,0, u2, vv1,cw},
            {v4.x, v4.y,0, u2, vv2,cw}
        )
        prevu = u2
    end
end
haiji_bg.init = function(self)
    _spellcard_background.init(self)
    --_spellcard_background.AddLayer(self, "bellesakibgmask", true, 0, 0, 0, 0, 3, 0, "", 1/2.25, 1/2.25, nil, nil)
    _spellcard_background.AddLayer(self, "haijibg", false, 0, 0, 0, 0, 0, 0, "", 1/2.25, 1/2.25, nil, nil,RenderJunkoBg)
end
function haiji:init(cards)
    local _cards = cards or self.class.cards
    boss.init(self, self.class.pos.x, self.class.pos.y, self.class.name, _cards, New(haiji_bg), "All")
    
    self._wisys = BossWalkImageSystem(self)
    self._wisys:SetImage("assets/boss/haijisprite.png", 4,6, {6,4,4,4}, {2,2,2}, 6, 16,16)
    self._wisys:SetFloat(0, 14 * sin(self.timer*4))
    self.hscale, self.vscale = 0.75/2.25, 0.75/2.25

    self.ui.drawhp = false 
    hpbar(self)
end

return M