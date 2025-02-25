local M = boss.card.New("Hanafuda Mirror \"Spreading Amulet\"", 3, 5, 60, 100, {0, 0, 0}, false)
boss.addspell {
    name = "Hanafuda Mirror \"Spreading Amulet\"",
    owner = "Haiji Senri",
    comment = "Referring to Hakurei as Hanafuda is a really niche inside joke,\n\
but when finding out Hanafuda is some sort of flower card\n\
game, I realized I hit jackpot!",
    id = "game.boss.haiji.spell6"
}
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
        local function bounce(obj,count)
            task.New(obj,function()
                for iter in afor(count) do
                    local dir = 0
                    local axis = 0
                    while true
                    --and   (obj.vy > 0 and obj.y < lstg.world.t)
                    --and   (obj.vy < 0 and obj.y > lstg.world.b)
                        do
                        if (obj.vx > 0 and obj.x > lstg.world.r) then
                            axis = 1
                            dir = 1
                            break
                        end
                        if (obj.vx < 0 and obj.x < lstg.world.l)  then
                            axis = 1
                            dir = -1
                            break
                        end
                        if (obj.vy > 0 and obj.y > lstg.world.t) then
                            axis = -1
                            dir = 1
                            break
                        end
                        if (obj.vy < 0 and obj.y < lstg.world.b)  then
                            axis = -1
                            dir = -1
                            break
                        end
                        task.Wait(1)
                    end
                    obj._color = BulletColor(iter:linear(210,360))
                    if axis == 1 then                    
                        obj.x = lstg.world.r * -dir
                    else
                        obj.y = lstg.world.t * -dir
                    end
                end
            end)
        end
        
        while true do
            local obj = bullet("amulet",BulletColor(180),self.x,self.y, 5, Angle(self,player))
            obj.scale = 5
            task.New(obj,function()
                ex.SmoothSetValueTo("_speed", 0, 60,MOVE_DECEL)
                local bang = Angle(obj,player)
                for iter1 in afor(2) do
                    for iter2 in afor(15) do
                        for iter3 in afor(10) do
                            local ang = iter1:increment(0,180/iter2.max_count)+
                                        iter2:circle()+
                                        iter3:linear(2,-2) + bang 
                            local spd = iter1:linear(1,2)
                            local obj1 = bullet("amulet", BulletColor(150),obj.x,obj.y,spd,ang)  
                            bounce(obj1,2)
                            local finalv = math.polar(spd*1.3,bang)
                            ex.AsyncSmoothSetValueTo(obj1,"vx",obj1.vx+finalv.x,90,MOVE_DECEL)
                            ex.AsyncSmoothSetValueTo(obj1,"vy",obj1.vy+finalv.y,90,MOVE_DECEL)
                            task.New(obj1, function()
                                task.Wait(240)
                                ex.SmoothSetValueTo("_speed",1,300,MOVE_DECEL)
                            end)
                        end
                    end
                end
                Del(obj)

            end)
            bounce(obj,10)
            task.Wait(360)
        end
    end)
end

return M