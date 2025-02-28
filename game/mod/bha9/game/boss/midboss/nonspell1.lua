local M = boss.card.New("", 5, 5, 20, 500, {80, 0, 0}, false)

boss.addspell {
    name = "Midboss Nonspell #1",
    owner = "Belle & Misaki",
    comment = "Belle's wave-y attack is a reference to a common practice in Brazil\n\
of jumping 7 waves on New Year's Eve for good luck.",
    id = "game.boss.midboss.nonspell1"
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
    local belle = self.belle
    local misaki = self.misaki
    task.New(self, function()
        local sign_pattern = 1
        task.AsyncMoveTo(self.misaki,-100*sign_pattern,120,60,MOVE_ACC_DEC)
        task.AsyncMoveTo(self.belle,100*sign_pattern,120,60,MOVE_ACC_DEC)
        task.Wait(120)
        while true do
            local _ang = Angle(belle,player)
            for iter1 in afor(20) do
                local colort = iter1:linear(0,1)
                local color = InterpolateColor(ColorS("FF00CCFF"),ColorS("FF42F57E"),colort)
                local fam = familiar(belle,belle.x, belle.y, 300,color,  0.2)
                fam._speed = 10
                fam._angle = 90 - 45 *sign_pattern
                task.New(fam, function()
                    ex.SmoothSetValueTo("_speed",0.1, 30, MOVE_DECEL)
                    fam._angle = _ang
                    local offset_base = math.ang2(fam._angle+90)
                    local offset_circle = math.ang2(fam._angle+180)
                    local l = 550
                    local fpos = math.vecfromobj(fam)
                    for iter in afor(30) do
                        local t = iter:linear(-1,1)
                        local ta = iter:linear(-90,90)*10
                        local ang = fam._angle + 90
                        local colorb = math.lerp(180,120,colort)
                        local pos = fpos + offset_base * l * t + offset_circle * 128 * sin(ta)
                        local bul = bullet("star",BulletColor(colorb),pos.x,pos.y,0,0,false,true)
                        bul.bound = false
                        bul.ta = ta
                        bul.t = t
                        task.NewUpdate(bul,function()
                            if not IsValid(fam) then
                                bul.vx = bul.dx
                                bul.vy = bul.dy
                                return
                            end
                            local tpos = math.vecfromobj(fam) + offset_base * l * t + offset_circle * bul.t * 128*cos(bul.timer*2) * sin(bul.ta+bul.timer*3)
                            bul.x, bul.y = tpos.x, tpos.y
                        end)
                        task.New(bul,function()
                            task.Wait(400)
                            bul.bound = true
                        end)
                    end
                    ex.SmoothSetValueTo("_speed",5, 120, MOVE_ACCEL)

                end)
                PlaySound("kira00")
                task.Wait(2)
            end
            task.Wait(30)
            task.AsyncMoveTo(self.belle,-100*sign_pattern,120,60,MOVE_ACC_DEC)
            local time = 180
            task.AsyncMoveTo(misaki,100*sign_pattern,70,time,MOVE_DECEL)
            for iter in afor(5) do
                local ang = iter:circle()
                local fam = familiar(misaki,misaki.x,misaki.y,100, ColorS("FF4400FF"),0.7)
                task.NewPolar(fam)
                fam.center = misaki
                fam.rad = 0
                fam.theta = ang
                fam.wvel = 0
                ex.AsyncSmoothSetValueTo(fam,"rad",128,time,tween.circOut)
                ex.AsyncSmoothSetValueTo(fam,"wvel",3,time,tween.circOut)
                ex.AsyncSmoothSetValueTo(fam,"_a",0,time,tween.circOut)
                ex.AsyncSmoothSetValueTo(fam,"hscale",1.4,time,tween.circOut)
                ex.AsyncSmoothSetValueTo(fam,"vscale",1.4,time,tween.circOut)
                task.New(fam, function()
                    for iter2 in afor(15) do
                        PlaySound("tan00")
                        for iter3 in afor(5) do
                            local __ang = fam.theta*2 + iter3:circle()
                            local bul = bullet("amulet", BulletColor(270),fam.x, fam.y, 1,__ang)
                            ex.AsyncSmoothSetValueTo(bul,"_speed",3,120, MOVE_DECEL)
                        end
                        task.Wait((time)/iter2.max_count)
                    end
                    Del(fam)
                end)
            end
            task.Wait(time)
            task.AsyncMoveTo(self.misaki,100*sign_pattern,120,60,MOVE_ACC_DEC)
            sign_pattern = -sign_pattern
        end
    end)
end

return M