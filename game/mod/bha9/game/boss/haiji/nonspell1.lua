local M = boss.card.New("", 3, 5, 60, 100, {0, 0, 0}, false)
boss.addspell {
    name = "Nonspell #1",
    owner = "Haiji Senri",
    comment = "This is the first spell I made for the game! I was testing the bullets\n\
                and familiars here.",
    id = "game.boss.haiji.nonspell1"
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
        local familiars = {}
        self.famangle = Angle(self,player)
        task.NewUpdate(self,function()
            self.famangle = math.lerpangle(self.famangle,Angle(self,player),0.01)
        end)
        for iter in afor(4) do
            local ang = iter:linearA(0,360)
            local last = familiar(self,self.x,self.y,100,HSVColor(100,120,40,100),0.2)
            table.insert(familiars,last)
            last.ang = ang
            last.angomg = 0
            last.rvec = Vector2(0,0)
            task.NewUpdate(last,function()
                last.ang = last.ang + last.angomg
                local vec = math.rotate2(math.ang2(last.ang) * last.rvec,self.famangle) 
                            + Vector2(self.x, self.y)
                last.x,last.y = vec.x, vec.y
            end)
            task.New(last, function()
                task.New(last,function()
                    ex.SmoothSetValueTo("rvec", Vector2(60,128),60,MOVE_DECEL)
                end)
                task.New(last,function()
                    ex.SmoothSetValueTo("angomg", -3,60,MOVE_DECEL)
                end)
                task.Wait(120)
                while true do
                    for iter1 in afor(4) do
                        local maxv = iter1:linearA(2,3)
                        local accel = iter1:linearA(0.1,0.1)
                        local obj = bullet("cursor",BulletColor(30,100),last.x,last.y,2,180+self.famangle - 45 * cos(last.ang-90))
                        SetA(obj,accel,self.famangle+ran:Float(-1,1),maxv,0,0,true)
                        task.Wait(1)
                    end
                    task.Wait(15)
                end
            end)
        end
        task.New(self, function()
            while true do
                local ang = ran:Float(0,360)
                for iter3 in afor(10) do
                    for iter2 in afor(2) do
                        for iter in afor(15) do
                            local ang2 = iter:circle() + ang
                            local s =  iter2:sign()
                            local obj = bullet("amulet",BulletColor(120),self.x,self.y,0.1,ang2)
                            ex.AsyncSmoothSetValueTo(obj,"_speed",3,60,MOVE_DECEL)
                            local spd = iter3:linear(2,4)
                            task.New(obj,function()
                                task.Wait(60)
                                PlaySound("kira00")
                                ex.AsyncSmoothSetValueTo(obj,"_speed",spd,14,MOVE_DECEL)
                                ex.SmoothSetValueTo("_angle",90 *s,15,MOVE_DECEL,nil,nil,MODE_ADD)
                            end)
                        end
                    end
                end
                task.Wait(120)
            end
        end)
    end)
end

return M