local M = boss.card.New("Suddenly Powerful \"ElectroFeedback\"", 4, 6, 60, 5000, {60, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "Suddenly Powerful \"ElectroFeedback\"",
    owner = "Haiji Senri",
    comment = "I really like this game, can't wait for it to release! But I think that\n\
the survival of stage 2 is a bit too difficult.",
    id = "game.boss.haiji.spell4"
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

function M:init()

    task.New(self, function()
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        while true do
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
                PlaySound("tan00")
                task.Wait(2)
            end
            task.MoveToPlayer(60, 
                            -100, 100, 60, 150, 
                            32, 64, 16, 32, 
                            MOVE_ACC_DEC, MOVE_RANDOM
            )

            task.New(self, function()
                local ellang = 60
                for iter in afor(64) do
                    for iter1 in afor(10) do
                        local ellpos = math.rotate2(math.ang2(iter1:circle() + iter:increment(0,5)) *
                                    Vector(1,2),ellang) * iter:linear(0,512)
                        local bulpos = ellpos + math.vecfromobj(self) + Vector(-120,32)
                        if Dist(bulpos.x,bulpos.y,player.x,player.y) > 32 then
                            for iter2 in afor(2) do
                                local angdiff = iter2:linear(-60,60)
                                local bul = bullet("scale", BulletColor(0),bulpos.x,bulpos.y,0.1,angdiff+ellpos:Angle())
                                local waittime = iter:linear(240,0)
                                local spdmul = (ellpos / iter:linear(1,512)):Length()
                                task.New(bul, function()
                                    task.Wait(waittime)
                                    ex.SmoothSetValueTo("_speed", 3, 120, MOVE_ACCEL)
                                end)
                            end
                        end
                    end
                    PlaySound("tan00")
                    task.Wait(2)
                end
            end)
            task.Wait(90)
            task.New(self, function()
                local ellang = -60
                for iter in afor(64) do
                    for iter1 in afor(10) do
                        local ellpos = math.rotate2(math.ang2(iter1:circle() + iter:increment(0,5)) *
                                    Vector(1,2),-ellang) * iter:linear(0,512)
                        local bulpos = ellpos + math.vecfromobj(self) + Vector(120,32)
                        if Dist(bulpos.x, bulpos.y, player.x, player.y) > 32 then
                            local bul = bullet("scale", BulletColor(240),bulpos.x,bulpos.y,0.1,Angle(bulpos.x,bulpos.y,player.x,player.y))
                            local waittime = iter:linear(120,240)
                            task.New(bul, function()
                                task.Wait(waittime)
                                ex.SmoothSetValueTo("_speed", 10, 300, MOVE_ACCEL)
                            end)
                        end
                    end
                    PlaySound("tan01")
                    task.Wait(2)
                end
            end)
            task.Wait(180)
            task.MoveToPlayer(60, 
                            -100, 100, 60, 150, 
                            32, 64, 16, 32, 
                            MOVE_ACC_DEC, MOVE_RANDOM
            )
            for iter in afor(6) do
                local ellang = iter:linear(120,30) * iter:sign()
                for iter1 in afor(30) do
                    local offset = math.rotate2(math.ang2(iter1:circle()* iter:sign()) * Vector(1,2),-ellang)
                    local tgtpos = offset * 64 + math.vecfromobj(self)
                    local bul = bullet("circle", BulletColor(120 + 120 * iter:sign()),
                                        self.x, self.y, 0, iter:circle())
                    bul.id = iter:sign()
                    bul.navi = true
                    task.New(bul, function()
                        task.MoveTo(tgtpos.x,tgtpos.y,60,MOVE_DECEL)
                        local baseang = bul._angle + 15 * bul.id
                        for iter2 in afor(5) do
                            local finalang = baseang +iter2:linear(-10,10)
                            local bul2 = bullet("amulet", BulletColor(120 + 120 * bul.id), bul.x, bul.y, 0, finalang)
                            ex.AsyncSmoothSetValueTo(bul2,"_speed", iter2:zigzag(1.5,4,2), 120, MOVE_DECEL)
                        end
                        Del(bul)
                    end)
                    PlaySound("tan00")
                    task.Wait(1)
                end
                task.MoveToPlayer(15, 
                                -100, 100, 60, 150, 
                                32*0.25, 64*0.25, 16*0.25, 32*0.25, 
                                MOVE_ACC_DEC, MOVE_RANDOM
                )
            end
            task.Wait(60)
        end

    end)
end

return M