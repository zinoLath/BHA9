local M = boss.card.New("Argentina Lace \"Wig the Stealer\"", 3, 5, 60, 100, {0, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "Argentina Lace \"Wig the Stealer\"",
    owner = "Haiji Senri",
    comment = "Fun Fact: Argentina Lace is the sister of Chile Wig. This is also\n\
one of my favorite Touhou scripts!",
    id = "game.boss.haiji.spell5"
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


local function wigstealer(x,y,baseang,c1,c2,w1,w2,a1,a2,r,__sign)
    for iter in afor(c1) do
        for iter1 in afor(c2) do
            local ang = iter:circle() + iter1:linearA(0,360/iter.max_count) * __sign+baseang
            local obj = bullet("amulet",BulletColor(0,0),x,y,0.1,ang)
            local waittime = iter1:linear(w1,w2)
            local ang_add = iter1:linear(a1,a2)
            task.New(obj,function()
                task.MoveTo(obj.x + r * cos(obj._angle), obj.y + r * sin(obj._angle),60,MOVE_DECEL)
                task.Wait(waittime)
                obj._color = BulletColor(obj.timer * 10)
                ex.AsyncSmoothSetValueTo(obj,"_angle",obj._angle+ang_add,60,MOVE_DECEL)
                ex.AsyncSmoothSetValueTo(obj,"_speed",5,120,MOVE_DECEL)
            end)
        end
    end

end
function M:init()

    task.New(self, function()
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        task.Wait(60)
        local time_sign = 1
        while true do
            wigstealer(self.x,self.y,ran:Float(0,360),30,15,30,120,0,0,96,15)
            task.Wait(90)
            for iter in afor(2) do
                local _sign = iter:sign()
                local fam = familiar(self,self.x,self.y,9000,ColorS("FFFBFF0B"), 0)
                task.New(fam, function()
                    task.MoveTo(100 * _sign, 0, 120, MOVE_ACC_DEC)
                    print(Angle(fam,player))
                    wigstealer(fam.x,fam.y,-90+30*_sign,10,15,30,120,0,0,96,-_sign)
                    wigstealer(fam.x,fam.y,-90-30*_sign,10,15,120,180,0,0,64,_sign)
                    Del(fam)
                end)
            end
            task.Wait(180)
            for iter in afor(10) do
                local fam = familiar(self,self.x,self.y,9000,ColorS("FF0BFF85"),0)
                local _x = iter:linear(-140,140)*time_sign
                local t = iter:linear(120,180)
                task.New(fam,function()
                    task.MoveTo(_x,100,t,MOVE_DECEL)
                    wigstealer(fam.x,fam.y,Angle(fam,player),20,3,60,80,0,0,96,-0.25)
                    wigstealer(fam.x,fam.y,Angle(fam,player),20,3,60,80,0,0,96,0.25)
                    Del(fam)
                end)
            end
            task.Wait(240)
            wigstealer(self.x,self.y,ran:Float(0,360),30,15,30,120,0,0,96,-1)
            task.Wait(60)
            time_sign = -time_sign
        end
    end)
end

return M