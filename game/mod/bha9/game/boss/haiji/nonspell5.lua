local M = boss.card.New("", 4, 6, 60, 2000, {30, 0, 0}, false)
boss.addspell {
    name = "Nonspell #5",
    owner = "Haiji Senri",
    comment = "For this game, I used some code from Forlorn Souls of Wicked Past\n\
to have really colorful bullets!",
    id = "game.boss.haiji.nonspell5"
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
        for siter in afor(2) do
            for fiter in afor(5) do
                local fam = familiar(self, self.x, self.y, 1000, ColorS("FFFFD23E"), 1)
                fam.center = self
                fam.wvel = siter:sign() * 2
                fam.theta = fiter:circle()
                task.NewPolar(fam)
                ex.AsyncSmoothSetValueTo(fam, "rad", siter:linear(64,96), 60, MOVE_DECEL)
                task.New(fam, function()
                    task.Wait(60)
                    while true do
                        local ang = fam.theta + self.timer*2+120
                        PlaySound("tan01")
                        local bul = bullet("amulet", BulletColor(self.timer),fam.x,fam.y,0,ang)
                        ex.AsyncSmoothSetValueTo(bul, "_speed", 3, 60, MOVE_DECEL)
                        task.Wait(3)
                    end
                end)
            end
        end
        task.Wait(60)
        while true do
            for iter1 in afor(10) do
                PlaySound("tan00")
                for iter in afor(5) do
                    local ang = Angle(self,player) + iter:linear(-90,90)
                    local spd = iter1:linear(1,5)
                    local bul = bullet("star", BulletColor(iter1:circle()),self.x,self.y,0,ang)
                    ex.AsyncSmoothSetValueTo(bul, "_speed", spd, 60, MOVE_DECEL)
                end
            end
            task.Wait(120)
        end
    end)
end

return M