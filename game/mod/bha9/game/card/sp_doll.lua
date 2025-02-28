local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "sp_doll"
card.img = manager:LoadCardIcon("sp_doll","spdoll")
card.name = "SP Doll"
card.description = "Charges up dolls to shoot lasers"
card.cost = 1
card.discard = false
card.type = manager.TYPE_SKILL

local afor = require("zinolib.advancedfor")

LoadImageFromFile("sp_doll_laser","game/card/sp_doll_laser.png",true,64,32,true)
SetTextureSamplerState("sp_doll_laser","point+wrap")
LoadImageFromFile("sp_doll_laser_glow","game/card/sp_doll_laser_glow.png",true,64,32,true)
card.shot = Class()
local shot = card.shot
shot.damage_delay = 16
shot.damage_factor = 0.8
shot.dmgtype = "shot"
function shot:init(x,y,time,dmg,width,ang,omiga,rx,ry)
    self.x, self.y = x,y
    self._x, self._y = x,y
    self.bound = false 
    --self.img = "sp_doll_laser"
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.dmg = dmg
    self.hscale = 0.1
    self.vscale = self.hscale/5
    self.rect = false
    self.colli = true
    self.killflag=true
    self.w = 0
    self._alpha = 0
    self.ang = ang
    self.omg = omiga
    self.rx, self.ry = 0, 0
    self.time = time
    task.New(self,function()
        ex.SmoothSetValueTo("_alpha",200,15,MOVE_DECEL,nil,0,MODE_SET)
    end)
    task.New(self,function()
        ex.SmoothSetValueTo("w",width,5,MOVE_DECEL,nil,0,MODE_SET)
    end)
    task.New(self,function()
        ex.SmoothSetValueTo("rx",rx,self.time,MOVE_DECEL,nil,0,MODE_SET)
    end)
    task.New(self,function()
        ex.SmoothSetValueTo("ry",ry,self.time,MOVE_DECEL,nil,0,MODE_SET)
    end)
    task.New(self,function()
        task.Wait(self.time)
        ex.SmoothSetValueTo("_alpha",0,15,MOVE_ACCEL,nil,0,MODE_SET)
        Del(self)
    end)
end
function shot:frame()
    task.Do(self)
    for i, o in ObjList(GROUP_ENEMY) do
        if o.y > self.y and o.x > self.x - self.w - o.a and o.x < self.x + self.w + o.a then
            o.class.colli(o,self)
        end
    end
    for i, o in ObjList(GROUP_NONTJT) do
        if o.y > self.y and o.x > self.x - self.w and o.x < self.x + self.w then
            o.class.colli(o,self)
        end
    end
    self.ang = self.ang + self.omg
    self.x = self._x + self.rx * cos(self.ang)
    self.y = self._y + self.ry * sin(self.ang)
end

function shot:render()
    local scroll = self.timer * 10
    local len = 1000
    local x,y = self.x, self.y
    local l,r = self.x + self.w, self.x - self.w
    local w1 = self.w * 1.2
    local l1,r1 = self.x + w1, self.x - w1
    local b,t = self.y, self.y + len
    local ul, ur = 0, 64
    local vb, vt = scroll, scroll + l*0.1
    local cw = Color(self._alpha,255,255,255)
    SetImageState("sp_doll_laser_glow","mul+screen",cw)
    RenderRect("sp_doll_laser_glow",l1,r1,b,t)
    RenderTexture("sp_doll_laser","mul+screen",
                    {l, t, 0, ul, vt, cw},
                    {r, t, 0, ur, vt, cw},
                    {r, b, 0, ur, vb, cw},
                    {l, b, 0, ul, vb, cw})
    SetImageState("white","mul+screen",cw)
    Render("white",self.x,self.y)
end

function card:init(is_focus)
    --is_focus = 1
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)
    task.NewNamed(player,"shot_" .. is_focus, function()
        local prev_slow = player.slow
        while true do
            local charge = 0
            if player.slow ~= prev_slow then
                player.charge_value = 0
            end
            prev_slow = player.slow
            local min_charge = ({120,110,100,90})[self.context.lvl]
            local max_charge = min_charge*1.25
            local time = 90
            local omiga = 7.5
            while player.fire > 0 and player.slow == self.context.is_focus and charge < max_charge do
                if charge == 0 then
                    PlaySound("ch00",0.2,player.x/1024)
                end
                if charge == min_charge then
                    PlaySound("ch01",0.2,player.x/1024)
                end
                player.charge_value = min(charge,min_charge)/min_charge
                charge = charge + 1 / player.stats.shot_rate
                task.Wait(1)
            end
            if charge > min_charge then
                player.charge_value = 0
                local lvl = self.context.lvl
                local count = {2 ,3 ,4 ,6}
                local dmg =   {2.2 ,2.6,3,3.4}
                local width = {12,14,16,18}
                local rx =    {32,48,64,72}
                local mul = 1
                for iter in afor(count[lvl]) do
                    local ang = iter:linearA(0,360)
                    New(card.shot,player.x,player.y+32,time,dmg[lvl]*mul,width[lvl],ang,omiga,rx[lvl],8)
                end
                task.Wait(60)
            end
            task.Wait(1)
        end
    end)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M