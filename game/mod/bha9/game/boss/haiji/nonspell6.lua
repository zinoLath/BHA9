local M = boss.card.New("", 3, 5, 9999, 100, {0, 0, 0}, false)

boss.addspell {
    name = "Nonspell #6",
    owner = "Haiji Senri",
    --comment = "You can tell Haiji lowkey wanted Sanae's Nachos",
    comment = "Fun fact! This nonspell made me write a whole SVG interpreter.\n\
                I guess memes are a really good motivator.",
    id = "game.boss.haiji.nonspell6"
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
local svg = require("utils.svg")
local housama = svg("game/housama/housama.xml")
local signal = "samasanae"
function M:init()

    task.New(self, function()
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        task.Wait(60)
        ex.SetSignal(signal,0)
        
        local bulcount = {
            60,
            5,
            5,
            5,
            5,
            5,
            5,
            2,
            20,
            0,0,0,0,0
        }
        local scale = 1
        local size = housama.viewbox.dimension
        local list = housama:getAllPath()
        for index, value in ipairs(list) do
            value.transform = value.transform
            * MatrixScale(Vector(1,-1)*scale)
            * MatrixTranslate(Vector(-1,1)*0.5*size*scale)
        end
        while true do
            local cur_signal = ex.GetSignal(signal)
            for index, value in ipairs(list) do
                for iter in afor(bulcount[index]) do
                    local p = self._pos + value:sample(iter:linear(0,1))
                    --print(tostring(p) .. " | " .. tostring(index))
                    local bul = bullet("star", BulletColor(120),p.x,p.y,0,0,0,0)
                    bul.offset = value:sample(iter:linear(0,1))/(scale * size * 0.5)
                    bul.scale = 0.8
                    task.New(bul, function()
                        ex.WaitForSignal(signal,cur_signal+1)
                        for iter1 in afor(3) do
                            local ang = iter1:circle() - 90
                            local bul2 = bullet("amulet", BulletColor(240),bul.x,bul.y,0,ang)
                            bul2.offset = bul.offset - Vector(0,0.2)
                            bul2.scale = 0.8
                            task.New(bul2,function()
                                local tgt = math.polar(64,bul2._angle)
                                task.MoveToEx(tgt.x,tgt.y,60,MOVE_DECEL)
                                task.Wait(15)
                                --ex.SmoothSetValueTo("_vel",bul2.offset*3,120,MOVE_DECEL)
                                bul2._angle = bul2.offset:Angle()
                                ex.SmoothSetValueTo("_speed",2,120,MOVE_DECEL)
                            end)
                        end
                        Del(bul)
                    end)
                    task.Wait(1)
                end
            end
            ex.SetSignal(signal,cur_signal+1)
            task.Wait(120)
            task.MoveToPlayer(60, 
                            -150, 150, 60, 150, 
                            16, 32, 8, 16, 
                            MOVE_DECEL, MOVE_X_TOWARDS_PLAYER
            )
            task.Wait(60)
            local time = 360
            task.New(self, function()
                for iter in afor(6) do
                    task.MoveToPlayer(time/iter.max_count, 
                                    -150, 150, 60, 150, 
                                    16, 32, 8, 16, 
                                    MOVE_DECEL, MOVE_X_TOWARDS_PLAYER
                    )
                end
            end)
            for iter in afor(time/16) do
                local _ang = iter:increment(0, 10)
                local pos = self._pos + Vector(30,0)
                for iter1 in afor(8) do
                    for iter2 in afor(7) do
                        local ang = iter2:circle() + _ang + iter1:linear(0,10)
                        local bul = bullet("scale", BulletColor(30), pos.x, pos.y, 0, ang)
                        local spd = iter1:linear(3,4)
                        task.New(bul, function()
                            ex.SmoothSetValueTo("_speed", spd, 15, MOVE_DECEL)
                        end)
                    end
                    task.Wait(1)
                end
                local pos = self._pos + Vector(-30,0)
                for iter1 in afor(6) do
                    for iter2 in afor(7) do
                        local ang = iter2:circle() - _ang + iter1:linear(0,-10)
                        local bul = bullet("scale", BulletColor(-30), pos.x, pos.y, 0, ang)
                        local spd = iter1:linear(3,4)
                        task.New(bul, function()
                            ex.SmoothSetValueTo("_speed", spd, 15, MOVE_DECEL)
                        end)
                    end
                    task.Wait(1)
                end
            end
            task.Wait(30)
        end
    end)
end

return M