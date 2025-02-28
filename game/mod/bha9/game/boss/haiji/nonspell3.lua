local M = boss.card.New("", 4, 6, 60, 2000, {30, 0, 0}, false)
boss.addspell {
    name = "Nonspell #3",
    owner = "Haiji Senri",
    comment = "I am a sucker for Nue Houjuu's nonspells, so I made one for Haiji too!",
    id = "game.boss.haiji.nonspell3"
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
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        task.New(self, function ()
            while true do
                
                task.MoveToPlayer(120, 
                            -100, 100, 60, 150, 
                            32, 32, 8, 16, 
                            MOVE_ACC_DEC, MOVE_RANDOM
                )
                task.Wait(30)
            end
        end)
        while true do
            for iter1 in afor(25) do
                for iter in afor(40) do
                    local offset =15 * cos(self.timer)*1.5
                    local ang = iter:circle()+offset
                    local bul = bullet("amulet", BulletColor(120),self._pos.x,self._pos.y,0,ang)
                    bul._vel = math.polar(8,ang)  
                    bul._vel = bul._vel * (nsin((iter:circle()+offset)*2+90)*0.5 + 0.5)
                end
                task.Wait(2)
            end
            task.Wait(7)
        end
        
    end)
end

return M