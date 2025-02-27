local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
require("game.card.earrow")
card.id = "archerd"
card.img = manager:LoadCardIcon("archerd","archerd")
card.name = "Archer Doll"
card.description = "Shoots arrows vertically independently of your shot type."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SYSTEM
CopyImage("aarrow","earrow")
local afor = require("zinolib.advancedfor")
local bullet = Class()
bullet[".render"] = true 
bullet.damage_delay = 4
bullet.damage_factor = 1
bullet.dmgtype = "item"
function bullet:init(x,y,rot,dmg)
    self.x, self.y = x,y
    self._speed = 15
    self._angle = rot
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET+1.99
    self.img = "aarrow"
    self._blend = "hue+alpha"
    self._color = BulletColor(60,nil,90)
    self.navi = true
    self.dmg = dmg
    self.rot = rot
    self.hscale, self.vscale = 0.2,0.2
end

function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)
    task.NewNamed(player,"archerd", function()
        while true do
            while player.fire > 0 do
                for siter in afor(2) do
                    for iter in afor(self.context.lvl) do
                        local offset = Vector(5,0) * siter:sign() * iter:increment(0,1)
                        local ang = 90 + (0 + iter:increment(-2,2) )* -siter:sign()
                        local dmglist = {0.2,0.4,0.6,0.8}
                        bullet(player.x+offset.x,player.y+offset.y,ang,dmglist[self.context.lvl])
                    end
                end
                task.Wait(4)
            end
            task.Wait(1)
        end
    end)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M