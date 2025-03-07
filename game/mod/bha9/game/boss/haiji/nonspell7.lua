local M = boss.card.New("", 4, 6, 60, 2000, {30, 0, 0}, false)

boss.addspell {
    name = "Nonspell #7",
    owner = "Haiji Senri",
    comment = "A really big inspiration for this non came from a Yukari script,\n\
and since this is Haiji, I had the opportunity to reheat some\n\
nachos.",
    id = "game.boss.haiji.nonspell7"
}
M.boss = "game.boss.haiji"
local bullet = require("zinolib.bullet")
local afor = require("zinolib.advancedfor")
local familiar = require("game.enemy.familiar")
local tween = require("math.tween")
local logicobj = require("game.misc.logicobj")
require("zinolib.misc")
require("math.additions")
---general help!!
---familar(master,x,y,hp,color,transfer rate)
---bullet(img,color,x,y,speed,ang,indes,add)

function M:init()

    task.New(self, function()
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        local _sign = 1
        while true do
            
            local t = 240
            local lo = New(logicobj, self.x, self.y,self)
            task.New(lo, function()
                for iter in afor(5) do
                    local fam = familiar(self, lo.x, lo.y, 9000, ColorS("FF4979FF"),0)
                    fam.center = lo
                    fam.theta = iter:circle()
                    fam.wvel = 6*_sign
                    task.NewPolar(fam)
                    task.New(fam, function()
                        ex.AsyncSmoothSetValueTo(fam,"rad", 128, t, MOVE_DECEL)
                        for iter1 in afor(60) do
                            PlaySound("tan00")
                            local bul = bullet("kunai", BulletColor(0), fam.x, fam.y, 0, fam.theta)
                            task.New(bul, function()
                                task.Wait(30)
                                ex.SmoothSetValueTo("_speed", 3, 120, MOVE_DECEL)
                            end)
                            task.Wait(t/iter1.max_count)
                        end

                        local sqang = fam.theta
                        PlaySound("tan01")
                        for itersq in afor(18) do
                            local vec = math.rotate2(math.polygon(6,itersq:circle()/360),-sqang)
                            local pos = math.vecfromobj(fam) + vec * 32
                            local obj = bullet("scale", BulletColor(210),pos.x, pos.y, 0, itersq:circle())
                            local spd = vec * 2
                            ex.AsyncSmoothSetValueTo(obj,"vx",spd.x,120,MOVE_DECEL)
                            ex.AsyncSmoothSetValueTo(obj,"vy",spd.y,120,MOVE_DECEL)
                        end
                        Del(fam)
                    end)
                end
                task.MoveTo(lo.x + 100*_sign, lo.y - 100, t, MOVE_ACCEL)
            end)
            task.Wait(t/2)
            _sign = -_sign
        end
    end)
end

return M