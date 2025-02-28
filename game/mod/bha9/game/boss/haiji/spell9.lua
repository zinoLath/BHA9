local M = boss.card.New("Curse \"Cursed Nachos\"", 4, 6, 60, 4000, {0, 0, 0}, false)
boss.addspell {
    name = "Curse \"Cursed Nachos\"",
    owner = "Haiji Senri",
    comment = "You can tell Haiji lowkey wanted Sanae's Nachos",
    id = "game.boss.haiji.spell9"
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
function M:init()

    task.New(self, function()
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        local scale = 1.3
        local size = housama.viewbox.dimension
        local list = housama:getAllPath()
        for index, value in ipairs(list) do
            value.transform = value.transform
            * MatrixScale(Vector(1,-1)*scale)
            * MatrixTranslate(Vector(-1,1)*0.5*size*scale)
        end
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        local bulcount = {
            30,
            10,
            10,
            10,
            10,
            10,
            10,
            1,
            10,
            0,0,0,0,0
        }
        while true do
            local _ang = ran:Float(0,360)
            for iterball in afor(4) do
                local ang = _ang + iterball:circle()
                local bulmaster = bullet("ellipse", BulletColor(0),self.x,self.y,0,ang)
                local tgt = self._pos + math.polar(128,ang)
                task.New(bulmaster,function()
                    task.MoveTo(tgt.x,tgt.y,60,MOVE_DECEL)
                    for itercount in afor(5) do
                        for index, value in ipairs(list) do
                            for iter in afor(bulcount[index]) do
                                local pos = value:sample(iter:linear(0,1))
                                local p = bulmaster._pos + pos * itercount:linear(1,0.3)
                                --print(tostring(p) .. " | " .. tostring(index))
                                local bul = bullet("cursor", BulletColor(0),p.x,p.y,0.01,pos:Angle())
                                local time = itercount:linear(15,0)
                                local spd = itercount:linear(2,2.5)
                                task.New(bul, function ()
                                    task.Wait(time)
                                    ex.SmoothSetValueTo("_speed",spd,60,MOVE_DECEL)
                                end)
                                --task.Wait(1)
                            end
                        end
                        PlaySound("tan00")
                        task.Wait(5)
                    end
                    Del(bulmaster)
                end)
                PlaySound("kira01")
                task.Wait(1)
            end
            task.Wait(180)
            PlaySound("kira00")

            for index, value in ipairs(list) do
                for iter in afor(bulcount[index]*2) do
                    local pos = value:sample(iter:linear(0,1))
                    local p = self._pos + pos*0
                    --print(tostring(p) .. " | " .. tostring(index))
                    local bul = bullet("star", BulletColor(120),p.x,p.y,0.01,pos:Angle())
                    local vel = pos *0.02 
                    task.New(bul, function ()
                        ex.SmoothSetValueTo("_vel",vel,60,MOVE_DECEL)
                        task.Wait(180)
                        ex.SmoothSetValueTo("_vel",math.polar(5,Angle(bul,player))*-1,180, MOVE_DECEL)
                    end)
                    --task.Wait(1)
                end
            end
            task.Wait(60)
        end
        
    end)
end

return M