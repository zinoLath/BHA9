local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "sheart"
card.img = manager:LoadCardIcon("sheart","sheart")
card.name = "Seeking Heart"
card.description = "Fires hearts that shoot bullets aimed at you"
card.cost = 1
card.discard = false
card.type = manager.TYPE_SKILL

LoadImage("sheart","cvfx1",768,256,256,256)
LoadImage("sbullet","cvfx1",768,512,256,256)
--SetImageCenter("sheart",12,128)
SetImageScale("sheart",1/2.25)
SetImageScale("sbullet",1/2.25)

local afor = require("zinolib.advancedfor")
local colli = require("zinolib.misc.collision")

local heartbullet = Class()
heartbullet[".render"] = true 
heartbullet.damage_delay = 4
heartbullet.damage_factor = 0.4
heartbullet.dmgtype = "shot"
function heartbullet:init(x,y,rot)
    self.x, self.y = x,y
    self._speed = ran:Float(13,16)
    self._angle = rot
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET+1.99
    self.img = "sbullet"
    self.navi = true
    self._a = 128
    self.dmg = 4
end

local seekingheart = Class()
seekingheart[".render"] = true
function seekingheart:init(master,card,rot,id)
    self.master = master
    self.x, self.y = master.x, master.y
    self.card = card
    self._speed = 2
    self._angle = rot
    self.navi = true
    self.img = "sheart"
    self.hue = 0
    self.layer = LAYER_PLAYER_BULLET+2
    self.group = GROUP_PLAYER_BULLET
    self._a = 32
    self.scale = 1
    self.bound = false
    self.id = id
end
function seekingheart:frame()
    local _card = self.card
    if (self.x > lstg.world.r and self.vx > 0) or (self.x < lstg.world.l and self.vx < 0) then
        self.vx = -self.vx
    end
    if (self.y > lstg.world.t and self.vy > 0) or (self.y < lstg.world.b and self.vy < 0) then
        self.vy = -self.vy
    end
    local tb_xang = {1,1,-1,-1}
    local tb_yang= {-1,1,1,-1}
    self._angle = self._angle + player.dx * 0.5 * tb_xang[self.id] + player.dy * 0.5 * tb_yang[self.id]
    self._a = math.lerp(32, 192, _card.fire)
    if _card.shoot and self.timer % 4 == 0 then
        local count = ({2,2,3,3})[_card.context.lvl]
        local spread = ({0,2,5,10})[_card.context.lvl]
        local var = ({2,3,5,10})[_card.context.lvl]
        for iter in afor(count) do
            local ang = Angle(self,player) + iter:linear(-spread,spread) + ran:Float(-var,var)
            New(heartbullet,self.x,self.y,ang)
        end
    end
end



function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)
    self.fire = 0 
    self.shoot = false
    task.NewNamed(player,"shot_" .. is_focus, function()
        New(seekingheart, player, self,90, 1)
        while true do
            while player.fire > 0 and player.slow == self.context.is_focus do
                self.fire = math.lerp(self.fire,1,0.3)
                self.shoot = true
                task.Wait(1)
            end
            self.shoot = false
            self.fire = math.lerp(self.fire,0,0.2)
            task.Wait(1)
        end
    end)
end
function card:lvlup()
    local obj = player.cards[card.id]
    New(seekingheart, player, obj,90, obj.context.lvl)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M