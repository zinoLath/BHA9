local M = boss.card.New("Karmic Prophecy \"Starry Night\"", 5, 10, 60, 2000, {90, 0, 0}, false)

boss.addspell {
    name = "Karmic Prophecy \"Starry Night\"",
    owner = "Belle & Misaki",
    comment = "Stars are my favorite shape!!!!",
    id = "game.boss.midboss.spell2"
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
        task.AsyncMoveTo(self.belle,0,0,60,MOVE_ACC_DEC)
        task.AsyncMoveTo(self.misaki,0,120,60,MOVE_ACC_DEC)
        local belle, misaki = self.belle, self.misaki
        task.New(belle, function()
            local s1 = 0.6
            local radtable = {1,s1,1,s1,1,s1,1,s1,1,s1,1}
            local _sign = 1
            while true do
                for iter1 in afor(2) do
                    for iter2 in afor(2) do
                        for iter in afor(30) do
                            local ang = iter:circle()
                            local bul = bullet("star",BulletColor(iter1:linear(170,190)),belle.x,belle.y,0.1,ang)
                            bul.id = iter:linearA(0,1)
                            bul.center = belle._pos
                            bul.rad = iter2:linear(0,10) + iter1:linear(0,30)
                            bul.sang = 90
                            bul.sign = iter1:sign() * _sign
                            task.NewUpdate(bul,function()
                                bul.rad = bul.rad + 1.3
                                bul.id = bul.id + 0.0003 * bul.sign
                                bul.id = Wrap(bul.id,0,1)
                                bul.scale = 0.7 + 0.2 * nsin(bul.id * 2 + bul.timer*5)
                                
                                local t = bul.id * 10
                                local t1,t2 = int(t), int(t)+1
                                local r1,r2 = radtable[t1+1],radtable[t2+1]
                                local p1,p2 = math.polar(r1,36*t1), math.polar(r2,36*t2)
                                bul._pos = bul.center + math.rotate2(math.lerp(p1,p2,t%1),bul.sang) * bul.rad
                            end)
                        end
                    end
                end
                PlaySound("kira00")
                task.Wait(120)
                _sign = -_sign
            end
        end)
        task.New(misaki, function()
            task.Wait(180)
            misaki.center = misaki._pos
            misaki.rad = 0
            misaki.theta = 0
            misaki.thetavel = 0
            misaki.wait = 60
            ex.AsyncSmoothSetValueTo(misaki,"rad",140,180,MOVE_ACC_DEC)
            local t = 600
            ex.AsyncSmoothSetValueTo(misaki,"_a",128,t,MOVE_ACC_DEC)
            ex.AsyncSmoothSetValueTo(misaki,"_r",32,t,MOVE_ACC_DEC)
            ex.AsyncSmoothSetValueTo(misaki,"_g",0,t,MOVE_ACC_DEC)
            ex.AsyncSmoothSetValueTo(misaki,"_b",128,t,MOVE_ACC_DEC)
            ex.AsyncSmoothSetValueTo(misaki,"thetavel",10,t,MOVE_ACC_DEC)
            ex.AsyncSmoothSetValueTo(misaki,"wait",2,t,MOVE_ACC_DEC)
            --ex.AsyncSmoothSetValueTo(misaki.hpbar,"_a",32,t,MOVE_ACC_DEC)
            task.NewUpdate(misaki,function()
                misaki.theta = misaki.theta + misaki.thetavel
                local p1 = math.polar(misaki.rad,misaki.theta) * Vector(1,0.25)
                misaki._pos = misaki.center + p1 
            end)
            task.New(misaki, function()
                task.Wait(180)
                while true do
                    local baseang = Angle(misaki,player)
                    local spd = ran:Float(3,6)
                    PlaySound("tan00")
                    for iter in afor(4) do
                        for iter1 in afor(4) do
                            local ang = baseang + iter:circle() + iter1:linear(-2,2)
                            local pos = misaki._pos 
                            local bul = bullet("amulet", BulletColor(-40,30), pos.x, pos.y, 0.01,ang)
                            local spd = spd
                            task.New(bul, function()
                                task.Wait(15)
                                ex.SmoothSetValueTo("_speed",spd,300,MOVE_ACC_DEC)
                            end)
                            --task.Wait(1)
                        end
                    end
                    task.Wait(misaki.wait)
                end
            end)
        end)
    end)
end

return M