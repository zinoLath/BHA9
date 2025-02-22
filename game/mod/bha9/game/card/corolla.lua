local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "corolla"
card.img = manager:LoadCardIcon("corolla","corolla")
card.name = "Corolla Eye"
card.description = "Shoots a slow moving projectile that covers a wide area."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SKILL

local afor = require("zinolib.advancedfor")

LoadImageFromFile("corolla_shot","game/card/corolla_eye.png",true,64,32,true)
card.shot = Class()
local shot = card.shot
shot[".render"] = true
function shot:init(x,y,maxalpha,maxscale,time,dmg)
    self.x, self.y = x,y
    self.img = "corolla_shot"
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.dmg = dmg
    self.vx = 0
    self.vy = 1.5
    self.hscale = 0.1
    self.vscale = self.hscale/5
    self._color = Color(0,255,255,255)
    self._blend = "mul+add"
    self.rect = false
    self.colli = true
    self.killflag=true
    task.New(self,function()
        ex.SmoothSetValueTo("_a",maxalpha,15,MOVE_DECEL,nil,0,MODE_SET)
    end)
    task.New(self,function()
        ex.SmoothSetValueTo("hscale",maxscale,time,MOVE_DECEL,nil,0,MODE_MUL)
    end)
    task.New(self,function()
        ex.SmoothSetValueTo("vscale",maxscale,time,MOVE_DECEL,nil,0,MODE_MUL)
    end)
    task.New(self,function()
        task.Wait(300/self.vy)
        ex.SmoothSetValueTo("_a",0,15,MOVE_ACCEL,nil,0,MODE_SET)
        Del(self)
    end)
end
function shot:frame()
    self.a = 512 * self.hscale
    self.b = 512 * self.vscale
    task.Do(self)
end

function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)
    task.NewNamed(player,"shot_" .. is_focus, function()
        while true do
            while player.fire > 0 and player.slow == self.context.is_focus do
                local dmgmul = player.stats.shot_damage
                local x, y = player.x, player.y
                New(card.shot,x,y,255,6,120,1*dmgmul)
                task.Wait(5)
                local count = {
                    2,
                    4,
                    6,
                    8
                }
                for iter in afor(count[self.context.lvl]) do
                    local s = iter:linear(5,4.8)
                    local t = iter:linear(120,180)
                    New(card.shot,x,y,128,s,t,0.1*dmgmul)
                    task.Wait(5)
                end
                if self.context.lvl ~= 4 then          
                    task.Wait(30)
                else               
                    task.Wait(20)
                end
            end
            task.Wait(1)
        end
    end)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M