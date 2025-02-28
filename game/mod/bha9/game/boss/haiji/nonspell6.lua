local M = boss.card.New("", 4, 6, 60, 2000, {30, 0, 0}, false)
boss.addspell {
    name = "Nonspell #6",
    owner = "Haiji Senri",
    --comment = "You can tell Haiji lowkey wanted Sanae's Nachos",
    comment = "Miriam Hanafuda is the queen of Youkai Extermination\n\
",
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
            local angoff = self.timer * 0.25
            local spdofftime = self.timer*4 + 45
            local spd1, spd2 = 3,5
            local count = 15
            for iter in afor(count) do
                local ang = iter:circle() + angoff
                local spd = math.lerp(spd1, spd2, nsin(spdofftime))
                local bul = bullet("amulet", BulletColor(-120),self._pos.x,self._pos.y,-0,ang)
                ex.AsyncSmoothSetValueTo(bul, "_speed", spd, 120, MOVE_DECEL)
            end
            for iter in afor(count) do
                local ang = iter:circle() - angoff
                local spd = math.lerp(spd2, spd1, nsin(spdofftime))
                local bul = bullet("amulet", BulletColor(-0),self._pos.x,self._pos.y,0,ang)
                ex.AsyncSmoothSetValueTo(bul, "_speed", spd, 120, MOVE_DECEL)
            end
            task.Wait(5)
        end
        
    end)
end

return M