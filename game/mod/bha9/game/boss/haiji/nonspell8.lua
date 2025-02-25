local M = boss.card.New("", 3, 5, 60, 100, {0, 0, 0}, false)

boss.addspell {
    name = "Nonspell #8",
    owner = "Haiji Senri",
    comment = "This could very much be a nonspell of a certain Amaryllis Reaper,\n\
but I like it on Haiji too!",
    id = "game.boss.haiji.nonspell5"
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
        --task.Wait(60)
        task.New(self, function()
            task.Wait(300)
            while true do
                
                task.MoveToPlayer(60, 
                                    -100, 100, 60, 150, 
                                    32, 64, 16, 32, 
                                    MOVE_ACC_DEC, MOVE_RANDOM
                )
                task.Wait(120)
            end
        end)
        for sinter in afor(2) do
            for iter in afor(3) do
                local fam = familiar(self,0,0,100,({Color(255,255,0,0),Color(255,0,0,255)})[sinter.current],0.1)
                fam.theta = iter:circle()
                fam.thomg = 2
                fam.rad = Vector(0,0)
                fam.ellang = 0
                fam.ellomg = 0
                ex.AsyncSmoothSetValueTo(fam,"rad",Vector(100,60),60,MOVE_DECEL)
                fam._sign = sinter:sign()
                fam._id = sinter.current
                task.New(fam,function()
                    task.Wait(120)
                    ex.AsyncSmoothSetValueTo(fam,"ellomg",1 * fam._sign,240,MOVE_DECEL,nil)
                end)
                task.New(fam, function()
                    fam.center = self._pos
                    while true do
                        fam.ellang = fam.ellang + fam.ellomg
                        fam.theta = fam.theta + fam.thomg
                        fam._pos = fam.center + math.rotate2(math.ang2(fam.theta) * fam.rad, -fam.ellang)
                        fam.center = math.lerp(fam.center,self._pos,0.1)
                        task.Wait(1)
                    end
                end)
                task.New(fam, function ()
                    task.Wait(60)
                    while true do
                        local ang = (fam.timer-60) * 0.5
                        for iter1 in afor(30) do
                            for iter2 in afor(5) do
                                local _ang = iter1:circle() + ang + iter2:linear(5,0) * fam._sign
                                local bul = bullet("amulet",BulletColor(({0,240})[fam._id]),fam.x,fam.y,0,_ang)
                                local vel = math.rotate2(
                                                            math.ang2(_ang) * (Vector(1,0.3)),
                                                            Angle(fam,player)+90
                                                        )
                                ex.AsyncSmoothSetValueTo(bul,"_vel",vel*iter2:linear(6,10),30,MOVE_DECEL)
                            end
                        end
                        task.Wait(90)
                        local ang = Angle(fam,player)
                        local _pos = fam._pos
                        for iter1 in afor(15) do
                            local pos = _pos + math.polar(ran:Float(-16,16),ang+90)
                            bullet("amulet",BulletColor(60),pos.x,pos.y,iter1:linear(5,3),ang)
                            task.Wait(2)
                        end
                    end
                end)
            end
        end
    end)
end

return M