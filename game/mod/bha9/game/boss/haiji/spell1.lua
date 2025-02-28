local M = boss.card.New("Explosive Bikini \"Sponge Homeland\"", 4, 6, 60, 4000, {60, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "Explosive Bikini \"Sponge Homeland\"",
    owner = "Haiji Senri",
    comment = "This spell is a copy of a copy, so I don't know if Haiji should credit\n\
Housui or Rachel. Maybe both?",
    id = "game.boss.haiji.spell1"
}

local bullet = require("zinolib.bullet")
local afor = require("zinolib.advancedfor")
local familiar = require("game.enemy.familiar")
local tween = require("math.tween")
require("zinolib.misc")
require("math.additions")
---general help!!
---familar(master,x,y,hp,color,transfer rate)
---bullet(img,color,x,y,speed,ang,indes,add)


local function create_explosion(x,y)
    local obj = bullet("circle",BulletColor(0),x,y,0,0,true,true)
    obj.delay = -1
    obj.hscale, obj.vscale = 0,0
    obj._a = 255
    task.New(obj,function()
        ex.AsyncSmoothSetValueTo(obj,"hscale",12,30,MOVE_DECEL)
        ex.AsyncSmoothSetValueTo(obj,"vscale",12,30,MOVE_DECEL)
        task.Wait(15)
        ex.AsyncSmoothSetValueTo(obj,"hscale",0,30,MOVE_DECEL)
        ex.AsyncSmoothSetValueTo(obj,"vscale",0,30,MOVE_DECEL)
        task.Wait(30)
        Del(obj)
    end)
end
function M:init()
    local color_familiar = HSVColor(100,240/3.6,100,100)
    task.New(self, function()
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        --task.Wait(60)
        while true do
            ---[[
            for iter in afor(10) do
                local fam = familiar(self,self.x,self.y,100,color_familiar,0.1)
                fam._angle = iter:circle()+90
                fam._speed = 5
                local wait_time = iter:linear(30,60)
                ex.AsyncSmoothSetValueTo(fam,"_speed",0,60,MOVE_DECEL)
                task.New(fam,function()
                    task.Wait(60)
                    PlaySound("ch00")
                    ex.SmoothSetValueTo("_color",Color(255,255,0,0),90,MOVE_DECEL)
                    task.Wait(wait_time)
                    create_explosion(fam.x,fam.y)
                    task.Wait(15)
                    PlaySound("tan01")
                    for iter2 in afor(6) do
                        local ang = ran:Float(0,360)
                        for iter1 in afor(10) do
                            local last = bullet("scale",BulletColor(-100),fam.x,fam.y,1,ang+iter1:circle())
                            local _spd = iter2:linear(1,2)
                            ex.AsyncSmoothSetValueTo(last,"_speed",ran:Float(_spd,_spd+1),60, MOVE_DECEL,nil,30)
                        end
                    end
                    Del(fam)
                end)
            end
            task.Wait(180)
            for signiter in afor(6) do
                task.NewNamed(self,"move", function()
                    task.MoveToPlayer(55, 
                                        -150, 150, 60, 150, 
                                        32, 64, 16, 32, 
                                        MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER
                    )
                end)
                task.Wait(15)
                for iter in afor(10) do
                    task.Wait(2)
                    local _sign = signiter:sign()
                    local fam = familiar(self,self.x,self.y,100,color_familiar,0.1)
                    fam._angle = 90 + iter:linearA(45, 60) * _sign
                    fam._speed = signiter:linear(5,2)
                    local t = 120
                    local angvar = iter:linearA(45,180)
                    ex.AsyncSmoothSetValueTo(fam,"_speed",0,t,MOVE_DECEL)
                    ex.AsyncSmoothSetValueTo(fam,"_angle",fam._angle+angvar*_sign,t,MOVE_DECEL)
                    task.New(fam, function() 
                        task.Wait(60)
                        PlaySound("ch00")
                        ex.SmoothSetValueTo("_color",Color(255,255,0,0),60,MOVE_DECEL)
                        task.Wait(30)
                        create_explosion(fam.x,fam.y)
                        task.Wait(15)
                        Del(fam)
                        local angbase1 = Angle(fam,player)
                        for biter in afor(3) do
                            local angbase = angbase1 + biter:linear(-45,45)
                            for sinter in afor(2) do
                                local ssign = sinter:sign()
                                for iter1 in afor(3) do
                                    local ang = angbase + iter1:linearA(0,5*ssign)
                                    local spd = iter1:linear(5,2)
                                    PlaySound("tan01")
                                    local obj = bullet("amulet", BulletColor(120),fam.x,fam.y,4,ang)
                                    task.New(obj, function()
                                        ex.SmoothSetValueTo("_speed", 1, 30,MOVE_DECEL)
                                        task.Wait(30)
                                        PlaySound("kira00")
                                        ex.SmoothSetValueTo("_speed", spd, 30,MOVE_DECEL)
                                    end)
                                end
                            end
                        end

                    end)
                end
            end
            --]]
            task.Wait(0)
            for iter in afor(10) do
                local aimx = iter:linear(-192,192)
                local fam = familiar(self,self.x,self.y,100,color_familiar,0.1)
                local ssign = iter:sign()
                local width = (lstg.world.r/iter.max_count)*1.2
                task.New(fam,function()
                    PlaySound("ch00")
                    ex.AsyncSmoothSetValueTo(fam,"_color",Color(255,255,0,0),60,MOVE_DECEL)
                    task.MoveTo(aimx,lstg.world.t,60,MOVE_DECEL)
                    --task.Wait(30)
                    create_explosion(fam.x,fam.y)
                    task.Wait(15)
                    for iiter in afor(10) do
                        for layer in afor(3) do
                            local sign2 = (ssign+1)/2
                            local x = fam.x + iiter:linear(-width,width)
                            local ylevel = -100
                            local y = (layer:linear(ylevel,192) + ((192-ylevel)/(4)) * sign2)
                            local bul = bullet("scale",BulletColor(0),x,fam.y,0.1,-90)
                            local spd = iiter:zigzag(2.5,2.7,2)
                            task.New(bul,function()
                                task.MoveTo(bul.x,y,60,MOVE_DECEL)
                                --task.Wait(30)
                                PlaySound("kira00")
                                ex.SmoothSetValueTo("_speed",spd,120,MOVE_DECEL)
                            end)
                        end
                    end
                    Del(fam)
                end)
                --task.Wait(5)
            end

            task.Wait(90)
        end 
    end)
end

return M