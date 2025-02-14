local M = boss.card.New("Suddenly Powerful \"ElectroFeedback\"", 3, 5, 60, 100, {0, 0, 0}, false)
M.boss = "game.boss.haiji"
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

    task.New(self, function()
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        task.Wait(60)
        for elliter in afor(6) do
            local eang = elliter:circle() - 90
            for iter1 in afor(30) do
                local ang = iter1:circle() * iter1:sign()
                local obj = bullet("circle", BulletColor(300),self.x,self.y,0.01,ang)
                local v1 = math.ellipse(0.1,0.1,90,ang)
                local v2 = math.ellipse(3,1,eang,ang)
                obj.vx, obj.vy = v1.x, v1.y
                ex.AsyncSmoothSetValueTo(obj,"vx",v2.x,15,MOVE_DECEL)
                ex.AsyncSmoothSetValueTo(obj,"vy",v2.y,15,MOVE_DECEL)
                local waittime = iter1:linear(40,70) + 15 * iter1:sign()
                local _spd = iter1:linear(0.5,3)
                local _sign = iter1:sign()
                task.New(obj,function()
                    task.Wait(waittime)
                    local ang = obj._angle +90 * _sign
                    local spd = _spd
                    local obj1 = bullet("scale",BulletColor(330),obj.x,obj.y,3,ang)
                    ex.AsyncSmoothSetValueTo(obj1,"_speed",spd,30,MOVE_DECEL)
                    task.New(obj1,function()
                        task.Wait(180)
                        ex.SmoothSetValueTo("_speed",5,60,MOVE_ACCEL)
                    end)
                    Del(obj)
                end)
            end
            task.Wait(2)
        end
        task.Wait(180)
        

    end)
end

return M