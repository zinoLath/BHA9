local M = boss.card.New("Nether Puppet \"European Doll Dance\"", 4, 6, 60, 3000, {60, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "Nether Puppet \"European Doll Dance\"",
    owner = "Haiji Senri",
    comment = "I really like using this spellcard on Hisoutensoku!! Blockstrings\n\
go crazy with this one!",
    id = "game.boss.haiji.spell2"
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


local function holland_doll(self,x,y,omiga)
    local fam = familiar(self,self.x,self.y,1000,Color(255,255,0,0),0.8)
    task.New(fam, function()
        task.MoveTo(x,y,120,MOVE_ACC_DEC)
        fam.radius = 0
        fam.ang = 0
        fam.eang = 0
        fam.eomg = 0
        PlaySound("kira00")
        ex.AsyncSmoothSetValueTo(fam,"radius",32,60,MOVE_DECEL)
        task.New(fam, function()
            fam.ang1 = Angle(0,0,fam.x,fam.y)
            fam.rad1 = Dist(0,0,fam.x,fam.y)
            local initrad = fam.rad1
            fam.omg = 0
            fam.omg1 = 0
            task.NewUpdate(fam,function() 
                fam.eang = fam.eang + fam.eomg
                fam.ang = fam.ang + fam.omg
                fam.ang1 = fam.ang1 + fam.omg1
                local pol = math.rotate2(math.ang2(fam.ang1) * Vector2(1,0.2) * initrad,-fam.eang)
                fam.x, fam.y = pol.x, pol.y
            end)
            task.Wait(300)
            ex.AsyncSmoothSetValueTo(fam,"omg",0.2,300,MOVE_ACC_DEC)
            task.Wait(120)
            ex.AsyncSmoothSetValueTo(fam,"omg1",0.1,600,MOVE_ACC_DEC)
            task.Wait(600)
            ex.AsyncSmoothSetValueTo(fam,"eomg",-0.1,6000,MOVE_ACC_DEC)
        end)
        for iter in afor(3) do
            local ang = iter:circle() + 90 * sign(omiga)
            local fam2 = familiar(fam,fam.x,fam.y,1000,Color(255,255,128,128),0.8)
            fam2.ang = ang
            fam2.angomg = 0
            task.NewUpdate(fam2, function()
                fam2.ang = fam2.ang + fam2.angomg 
                local pol = math.polar(fam.radius,fam2.ang + fam.ang)
                fam2.x = fam.x + pol.x
                fam2.y = fam.y + pol.y
            end)
            ex.AsyncSmoothSetValueTo(fam2,"angomg",omiga,60,MOVE_DECEL)
            task.New(fam2,function()
                task.Wait(120)
                local spread = 7
                while true do
                    for iter1 in afor(1) do
                        local ang = fam2.ang + ran:Float(-spread,spread) + fam.ang
                        local spd = 7 + ran:Float(-1,1)
                        local bul = bullet("ellipse",BulletColor(0),fam2.x,fam2.y,spd,ang,false,true)
                        bul.scale=1
                        ex.AsyncSmoothSetValueTo(bul,"scale",3,15,MOVE_NORMAL)
                        task.New(bul, function()
                            while Dist(bul,player) > 64 do
                                task.Wait(1)
                            end
                            bul.colli = false
                            ex.SmoothSetValueTo("_speed",0.1,5,MOVE_DECEL)
                            ex.AsyncSmoothSetValueTo(bul,"scale",2,60,MOVE_NORMAL)
                            ex.SmoothSetValueTo("_a",20,15,MOVE_ACC_DEC)
                            task.Wait(45)
                            bul.colli = true
                            ex.SmoothSetValueTo("_a",255,3,MOVE_ACC_DEC)
                            ex.SmoothSetValueTo("_speed",10,15,MOVE_ACC_DEC)
                        end)
                    end
                    task.Wait(1)
                end
            end)
        end
    end)
    return fam
end
function M:init()
    local color_familiar = HSVColor(100,0/3.6,100,100)
    task.New(self, function()
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        local omg = 0.5
        task.New(self,function() 
            holland_doll(self,100,0,-omg)
            holland_doll(self,-100,0,omg)
        end)
        task.Wait(300)
        task.New(self,function()
            while true do
                local angbase = ran:Float(0,360)
                for iter in afor(4) do
                    for iter2 in afor(45) do
                        local ang = angbase + iter2:circle()
                        local spd = iter:linear(3,2)
                        bullet("amulet",BulletColor(120),self.x,self.y,spd,ang)
                    end 
                end
                task.Wait(30)
                local time, wait = 300, 15
                for iter in afor(time/wait) do
                    local ang1 = math.lerp(0,120,nsin(self.timer*2))
                    for iter2 in afor(20) do
                        local ang = ang1 + iter2:circle()
                        bullet("amulet",BulletColor(-60),self.x,self.y,2,ang)
                    end
                    PlaySound("tan00")
                    task.Wait(wait)
                end
                task.Wait(120)
            end
        end)
    end)
end

return M