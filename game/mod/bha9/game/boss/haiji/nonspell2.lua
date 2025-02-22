local M = boss.card.New("", 3, 5, 60, 900, {0,0,0}, false)

boss.addspell {
    name = "Nonspell #2",
    owner = "Haiji Senri",
    comment = "I'm a really, really big fan of patterns that force you to dodge big\n\
               chunks of bullets, as you can see.",
    id = "game.boss.haiji.nonspell2"
}
M.boss = "game.boss.haiji"

local bullet = require("zinolib.bullet")
local afor = require("zinolib.advancedfor")
local familiar = require("game.enemy.familiar")
local tween = require("math.tween")
require("zinolib.misc")
require("math.additions")

function M:init()
    task.New(self, function()
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        for count in afor(_infinite) do
            local baseang = ran:Float(0,360)
            for iter in afor(20) do
                local ang = iter:circle() + baseang
                local fam = familiar(self,self.x,self.y,100,HSVColor(100,240/3.6,100,100),0.3)
                fam._angle = ang 
                local max_rad = 130
                local time = 180
                task.NewPolar(fam)
                fam.theta = ang
                task.New(fam, function()
                    ex.AsyncSmoothSetValueTo(fam,"rad",max_rad,time,MOVE_DECEL)
                    ex.AsyncSmoothSetValueTo(fam,"theta",fam.theta+180 * count:sign(),time,MOVE_DECEL)
                    for iter1 in afor(10) do
                        local fx, fy = fam.x, fam.y
                        local fang = AngDelta(fam)
                        for iter2 in afor(5) do
                            local pos = Vector2(fx,fy) + math.polar(iter2:linear(-16,16),fam.theta+90)
                            local bul = bullet("amulet",BulletColor(240),pos.x,pos.y,0.01,fam.theta+180)
                            ex.AsyncSmoothSetValueTo(bul,"_speed",iter2:zigzag(3.5,3.7,2),120,MOVE_DECEL)
                        end
                        task.Wait(time/iter1.max_count)
                    end
                    task.Wait(60)
                    local ang_to_player = Angle(fam,player)
                    for iter1 in afor(8) do
                        for iter2 in afor(3) do
                            local _ang = iter2:linear(-45,45) + ang_to_player +ran:Float(-4,4)
                            local spd = iter1:linear(4,2)
                            bullet("amulet",BulletColor(0),fam.x,fam.y,spd,_ang)
                        end
                        task.Wait(2)
                    end
                    Del(fam)
                end)
            end 
            task.Wait(240)
        end
    end)
end

return M