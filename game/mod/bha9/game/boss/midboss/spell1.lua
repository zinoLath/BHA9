local M = boss.card.New("Jeweled Treasure \"Event Horizon\"", 5, 10, 20, 500, {90, 0, 0}, false)

boss.addspell {
    name = "Jeweled Treasure \"Event Horizon\"",
    owner = "Belle & Misaki",
    comment = "I still don't know what Misaki's powers do lol.",
    id = "game.boss.midboss.spell1"
}
M.boss = "game.boss.midboss"

local bullet = require("zinolib.bullet")
local afor = require("zinolib.advancedfor")
local familiar = require("game.enemy.familiar")
local tween = require("math.tween")
require("zinolib.misc")
require("math.additions")
---general help!!
---familar(master,x,y,hp,color,transfer rate)
---bullet(img,color,x,y,speed,ang,indes,add)


function M:init()
    local color_familiar = HSVColor(100,240/3.6,100,100)
    task.Clear(self.belle)
    task.Clear(self.misaki)
    for index, value in ipairs(self.belle._servants) do
        Del(value)
    end
    for index, value in ipairs(self.misaki._servants) do
        Del(value)
    end
    task.New(self, function()
        task.AsyncMoveTo(self.belle,0,50,60,MOVE_ACC_DEC)
        task.AsyncMoveTo(self.misaki,0,0,60,MOVE_ACC_DEC)
        local belle, misaki = self.belle, self.misaki
        task.Wait(60)
        task.New(belle, function()
            local ang = 0
            local angvel = 15.0
            local angaccel = 0.05*2
            task.Wait(60)
            while true do
                for iter in afor(2) do
                    local _ang = ang + iter:circle()
                    local bul = bullet("star",BulletColor(180),belle.x-25,belle.y+25,0.1,_ang,false,true)
                    bul.var = 0
                    bul.varcount = 0
                    bul.bound = false
                    ex.AsyncSmoothSetValueTo(bul,"_speed",2,60,MOVE_DECEL)
                    task.New(bul, function()
                        ex.AsyncSmoothSetValueTo(bul,"var",1,240,MOVE_ACCEL)
                        task.Wait(120)
                        task.Wait(240)
                        ex.AsyncSmoothSetValueTo(bul,"var",0,60,MOVE_ACCEL)
                        ex.AsyncSmoothSetValueTo(bul,"_speed",4,60,MOVE_DECEL)
                        bul.bound = true 
                    end)
                end
                ang = ang + angvel
                angvel = angvel + angaccel
                task.Wait(2)
            end
        end)
        task.New(misaki, function()
            while true do
                local pullforce = 5
                local wvel = 0.1
                for i, obj in ObjList(GROUP_ENEMY_BULLET) do
                    local v = obj.var or 0
                    obj.var = v
                    obj.varcount = (obj.varcount or 0) + v
                    --local r, t = Dist(misaki,obj), Angle(obj,misaki)
                    local mp = Vector(misaki.x, misaki.y)
                    local bultom = Vector(obj.x, obj.y) - mp
                    local newpos = mp + bultom * math.lerp(1,0.98,v)
                    obj.x,obj.y = newpos.x, newpos.y
                    obj._angle = obj._angle + wvel * v
                    obj._color = BulletColor(180 + obj.varcount)
                end
                task.Wait(1)
            end
        end)
        task.New(misaki, function()
            task.Wait(60)
            while true do
                local overshoot = 0.4
                local mp, pp = Vector(misaki.x, misaki.y), Vector(player.x, player.y)
                local target = (pp-mp) * overshoot + mp
                task.MoveTo(target.x, target.y, 180, MOVE_ACC_DEC)
                task.Wait(60)
            end
        end)
        task.New(misaki, function()
        
        end)
    end)
end

return M