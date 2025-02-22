local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "earrow"
card.img = manager:LoadCardIcon("earrow","earrow")
card.name = "Entropy Arrow"
card.description = "Charges up and shoots omnidirectional arrows"
card.cost = 1
card.discard = false
card.type = manager.TYPE_SKILL

local afor = require("zinolib.advancedfor")

LoadImageFromFile("earrow", "assets/card/earrow.png")
SetTextureSamplerState("earrow","point+clamp")
LoadImageFromFile("earrowbase", "assets/card/earrowbase.png")
SetImageCenter("earrowbase",10,32)

card.shot = Class()
local shot = card.shot
function shot:init(x,y,rot,_card)
    self.x, self.y = x,y
    self._x, self._y = x,y
    self.bound = false 
    --self.img = "sp_doll_laser"
    self.group = GROUP_PLAYER_BULLET
    self.layer = LAYER_PLAYER_BULLET
    self.hscale = 0.1
    self.vscale = self.hscale/5
    self.rect = false
    self.colli = true
    self.killflag=true
    self.w = 0
    self.h = 0
    self.rot = rot
    self._alpha = 255
    local t = 120
    task.New(self, function()  
        ex.SmoothSetValueTo("w", 32, 30,MOVE_DECEL)
        task.Wait(15)
        ex.SmoothSetValueTo("w", 40, t-45,MOVE_DECEL)
    end)
    task.New(self, function()  
        ex.SmoothSetValueTo("h", 128, 5,MOVE_DECEL)
        task.Wait(15)
        ex.SmoothSetValueTo("h", 1024, 60,MOVE_ACCEL)
    end)
    task.New(self,function()
        task.Wait(t)
        --ex.AsyncSmoothSetValueTo(self,"_alpha",0,15,MOVE_DECEL)
        ex.AsyncSmoothSetValueTo(self,"w",0,15,MOVE_DECEL)
        --ex.AsyncSmoothSetValueTo(self,"h",0,15,MOVE_DECEL)
        task.Wait(15)
        Kill(self)
    end)
end
function shot:frame()
    task.Do(self)
end

function shot:render()
    local rot = self.rot
    local w = self.w
    local h = self.h
    local vecbase = {
        Vector(0,w/2), Vector(0,-w/2),
        Vector(h,-w/2), Vector(h,w/2)
    }
    local u1, u2 = 256-h*2,256
    local v1, v2 = 0, 64
    local alpha = self._alpha
    local cw = Color(alpha,255,255,255)
    local cw2 = Color(alpha,255,0,0)
    local vec = {}
    for k,v in ipairs(vecbase) do
        vec[k] = math.rotate2(v,-rot) + math.vecfromobj(self)
    end

    RenderTexture("earrow", "mul+add",
        {vec[1].x, vec[1].y, 0, u1,v1,cw2},
        {vec[2].x, vec[2].y, 0, u1,v2,cw2},
        {vec[3].x, vec[3].y, 0, u2,v2,cw},
        {vec[4].x, vec[4].y, 0, u2,v1,cw}
    )
    SetImageState("earrowbase","mul+add",cw)
    Render("earrowbase",self.x,self.y,self.rot+180,1,self.w/32)
end

function card:init(is_focus)
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
            local max_charge = 180
            local min_charge = 120
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
                local count = {1 ,2 ,4 ,16}
                local dmg =   {1 ,2 ,3 ,3}
                local width = {12,14,16,18}
                local rx =    {32,48,64,72}
                for iter in afor(count[lvl]) do
                    local ang = iter:linearA(0,360)
                    New(card.shot,player.x,player.y,ang-90,self)
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