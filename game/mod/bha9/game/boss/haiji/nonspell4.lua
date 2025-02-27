local M = boss.card.New("", 3, 5, 60, 2000, {0, 0, 0}, false)
boss.addspell {
    name = "Nonspell #4",
    owner = "Haiji Senri",
    comment = "I guess this is the Haiji-est pattern of this game, haha! I really\n\
enjoy this one.",
    id = "game.boss.haiji.nonspell4"
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
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        task.Wait(60)
        while true do
            task.MoveToPlayer(60, 
                              -100, 100, 60, 150, 
                              32, 64, 16, 32, 
                              MOVE_ACC_DEC, MOVE_RANDOM
            )
            local bangle = ran:Float(0,360)
            local sqang = 45
            for sinter in afor(8) do
                for iter in afor(5) do
                    for iter1 in afor(32) do
                        local bul = bullet("amulet", BulletColor(240),self.x,self.y,0,iter1:circle())
                        bul.center = Vector(self.x,self.y)
                        bul.rad = iter:linear(64,0)
                        bul.theta = iter1:circle()+bangle
                        bul.wvel = sinter:sign()*0.3
                        bul.bound = false
                        task.New(bul, function ()
                            while true do
                                bul.rad = bul.rad + 2
                                bul.theta = bul.theta + bul.wvel
                                local vec = bul.center + 
                                            math.rotate2(math.polygon(4,bul.theta/360),sqang) * bul.rad
                                bul.x, bul.y = vec.x, vec.y
                                if bul.timer > 180 then
                                    bul.bound = true
                                end
                                task.Wait(1)
                            end
                        end)
                    end
                end
                task.Wait(45)
            end
            task.Wait(0)
        end
        
    end)
end

return M