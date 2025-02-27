local afor = require("zinolib.advancedfor")
local bullet = require("zinolib.bullet")
local function stage_main(self)
    LoadMusicRecord("stage")
    _play_music("stage")

    --[[
    task.Wait(180)
    for siter in afor(5) do
        local _sign = siter:sign()
        for iter in afor(10) do
            local obj = New(enemy,1, 10, false, false, false)
            obj.drop = {1,0,0}
            local p1 = Vector(-230*_sign,siter:linear(100,150))
            local p2 = Vector(200*_sign,siter:linear(150,100))
            obj._pos = p1
            task.New(obj,function()
                task.MoveTo(p2.x,p2.y,150,MOVE_ACCEL)
                Del(obj)
            end)
            task.New(obj, function()
                task.Wait(ran:Float(0,60))
                while obj.timer < 75 do
                    task.New(obj, function()
                        
                        local pos = obj._pos
                        local ang = Angle(obj,player)
                        for iter1 in afor(3) do
                            bullet("scale", BulletColor(0), pos.x, pos.y, ran:Float(3,6), ang + ran:Float(1,-1))
                            task.Wait(12)
                        end
                    end)
                    task.Wait(5)
                end
            end)
            task.Wait(5)
        end
        task.Wait(120)
    end
    task.Wait(120)
    for iter2 in afor(5) do
        local x = iter2:linear(-100,100)
        local obj = New(enemy,20,200,false,false,false)
        obj.drop = {5,0,0}
        obj._pos = Vector(x,400)
        task.New(obj, function()
            task.MoveTo(x,50,120,MOVE_DECEL)
            for iter1 in afor(4) do
                local baseang = ran:Float(0,360)
                for iter in afor(20) do
                    local ang = baseang + iter:circle()
                    local pos = obj._pos + math.polar(32,ang)
                    local bul = bullet("star", BulletColor(0), pos.x, pos.y, 0.01,ang)
                    local spd = 3
                    task.New(bul, function()
                        task.Wait(15)
                        ex.SmoothSetValueTo("_speed",spd,60,MOVE_ACC_DEC)
                    end)
                    --task.Wait(1)
                end
                task.Wait(60)
            end
            task.MoveTo(x,400,120,MOVE_ACC_DEC)
            Del(obj)
        end)
        task.Wait(30)
    end
    task.Wait(300)
    for siter in afor(2) do
        local _sign = siter:sign()
        local obj = New(enemy,1, 600, false, true, false)
        obj.drop = {20,0,0}
        local x = 120 * _sign
        obj._pos = Vector(x,400)
        task.AsyncMoveTo(obj,x,50,120,MOVE_DECEL)
        task.New(obj, function()
            task.Wait(120)
            task.Wait(300)
            task.AsyncMoveTo(obj,400* -_sign,400,900,MOVE_DECEL)
        end)
        task.New(obj, function()
            task.Wait(120)
            while obj.timer < 540 do
                local baseang = Angle(obj,player)
                for iter in afor(3) do
                    for eliter in afor(30) do
                        local ang = baseang + eliter:circle() + iter:linear(-10,10)
                        local pos = obj._pos + math.ellipse(32,128,baseang,ang)
                        local bul = bullet("scale", BulletColor(0), pos.x, pos.y, 0.01,ang)
                        bul.theta = ang
                        bul.spd = math.polar(1,baseang)
                        bul.center = obj._pos 
                        bul.ellang = baseang
                        bul.wvel = 0.5 * _sign
                        bul.bound = false
                        task.NewUpdate(bul, function()
                            bul.theta = bul.theta + bul.wvel
                            bul.center = bul.center + bul.spd
                            bul._pos = bul.center + math.ellipse(32,128,bul.ellang,bul.theta)
                        end)
                        task.New(bul, function()
                            task.Wait(500)
                            Del(bul)
                        end)
                    end
                    task.Wait(30)
                end
                task.Wait(180)
            end
        end)
        task.Wait(90)
    end
    task.Wait(360)
    local obj = New(enemy,1, 600, false, true, false)
    obj.drop = {30,0,0}
    obj._pos = Vector(0,400)
    task.AsyncMoveTo(obj,0,50,120,MOVE_DECEL)
    task.New(obj, function()
        task.Wait(120)
        while true do
            local forcount = 0 + obj.timer/300
            for iter1 in afor(2) do
                local baseang = obj.timer * 4.83475743*2 + iter1:circle()
                for iter in afor(15) do
                    local _ran = ran:Float(-forcount,forcount)
                    local pos = obj._pos + math.polar(32 * _ran, baseang+90)
                    local ang = baseang + _ran * 5
                    local bul = bullet("fire", BulletColor(30),pos.x,pos.y,2,ang)
                    local spd = 5-ran:Float(math.abs(_ran)*2,1)
                    ex.AsyncSmoothSetValueTo(bul,"_speed",spd,60,MOVE_DECEL)
                end
            end
            task.Wait(10)
        end
    end)
    task.New(obj, function()
        task.Wait(600)
        task.MoveTo(0,400,120,MOVE_DECEL)
        Del(obj)
    end)
    task.Wait(300)
    --]]

    local midboss = lstg.DoFile("game/boss/midboss/init.lua")
    InitAllClass()
    local ref = New(midboss)
    while IsValid(ref) do
        task.Wait(1)
    end
    --task.Wait(_infinite)
end
return stage_main