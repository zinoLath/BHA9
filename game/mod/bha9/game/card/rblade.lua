local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "rblade"
card.img = "img_void"
card.name = "Radiant Blade"
card.description = "Fires a short-range, consistent laser"
card.cost = 1
card.discard = false
card.type = manager.TYPE_SKILL

LoadImage("rblade","cvfx1",768,0,256,256)
SetImageCenter("rblade",12,128)
SetImageScale("rblade",1/2.25)

local afor = require("zinolib.advancedfor")
local colli = require("zinolib.misc.collision")

local rbladebul = Class()
function rbladebul:init(master,card)
    self.fire = 0
    self.master = master
    self.card = card
    self.x, self.y = master.x,master.y
    self.rot = 90
    self.img = "rblade"
    self.blend = "hue+add"
    self.hue = 0
    self.layer = LAYER_PLAYER_BULLET+1
    self.group = GROUP_PLAYER_BULLET
    self._a = 64
    self.scale = 1
    self.bound = false
end
function rbladebul:frame()
    local master = self.master
    if not IsValid(self.card) then
        Kill(self)
        return
    end
    local lvl = self.card.context.lvl
    self.x, self.y = master.x,master.y + 16
    self.vscale = self.fire * self.scale
    self.hscale = self.scale*1.1

    local scale_table = {
        1,1.2,1.4,2
    }
    self.scale = scale_table[lvl]
    local alpha_table = {
        128,96,64,64
    }
    self._a = alpha_table[lvl]
    local hue_table = {
        0,-15,-30,-60
    }
    self.hue = hue_table[lvl]
    
    task.Do(self)
    
end

function rbladebul:render()
    --SetImageState("rblade","hue+add",BulletColor(self.hue,nil,self._a))
    --Render(self.img,self.x,self.y,self.rot,self.hscale,self.vscale)
    self.class.render_fire(self,self.x,self.y,self.rot,self.hscale,self.vscale)
    if self.card.context.lvl == 4 then
        local scl, scr = 0.6,0.8
        self.class.render_fire(self,self.x-32,self.y-32,self.rot+30,self.hscale*scl,self.vscale*scr)
        self.class.render_fire(self,self.x+32,self.y-32,self.rot-30,self.hscale*scl,self.vscale*scr)
    end
end
function rbladebul:render_fire(x,y,rot,hscale,vscale)

    local count_table = {
        3,4,5,4
    }
    for iter in afor(count_table[self.card.context.lvl]) do
        local a = self.timer*20 + iter:linear(0,120)
        local scale_var = 1 + 0.6 * nsin(a*10)
        SetImageState("rblade","hue+add",BulletColor(self.hue-30*nsin(a*10),nil,self._a))
        Render(self.img,x,y,rot,hscale*scale_var,vscale*scale_var)
    end
end


function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)
    task.NewNamed(player,"shot_" .. is_focus, function()
        local rblade = New(rbladebul, player, self)
        while true do
            while player.fire > 0 and player.slow == self.context.is_focus do
                rblade.fire = math.lerp(rblade.fire,1,0.3)
                task.Wait(1)
            end
            rblade.fire = math.lerp(rblade.fire,0,0.2)
            task.Wait(1)
        end
    end)
end
manager.cardlist[card.id] = M 
return M