local M = boss.card.New("Influencer Trap \"Virginia Betting\"", 4, 6, 60, 4000, {60, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "Influencer Trap \"Virginia Betting\"",
    owner = "Haiji Senri",
    comment = "This is one of my favorite skillcards in Hisoutensoku! Also\n\
don't ask me what I was thinking naming this, lol.",
    id = "game.boss.haiji.spell7"
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
local delay = require("game.vfx.delay")

CopyImage("delaywhite","white")
SetImageCenter("delaywhite",0,8)
function M:init()

    task.New(self, function()
        task.MoveTo(0,120,120,MOVE_ACC_DEC)
        task.Wait(60)
        while true do
            
            for iter1 in afor(10) do
                local fam = familiar(self,self.x,self.y,9000,Color(255,0,255,255),0)
                task.New(fam, function ()
                    task.MoveTo(ran:Float(-192,192),ran:Float(lstg.world.b,lstg.world.t),60,MOVE_DECEL)
                    for iter in afor(1) do
                        local ang = ran:Float(0,360)
                        for delayter in afor(2) do
                            local __sign = delayter:sign()
                            local del = delay(fam.x,fam.y,ang+90 + 90 * __sign,Color(64,0,0,255))
                            _connect(self,del,0,true)
                            del.hscale = 1000
                            task.New(del,function()
                                ex.SmoothSetValueTo("vscale", 2,30,MOVE_DECEL)
                                task.Wait(105)
                                ex.SmoothSetValueTo("_a", 0,30,MOVE_DECEL)
                            end)
                        end
                        for iter2 in afor(4) do
                            for iter3 in afor(5) do
                                local pos = math.vecfromobj(fam) +
                                            math.polar(iter2:linear(-8,8),ang+90) +
                                            math.polar(iter3:linear(64,128)+512,ang)
                                local obj = bullet("ellipse", BulletColor(240),pos.x,pos.y,0,ang+180,false,true)
                                obj.bound = false
                                obj.scale = 2
                                task.New(obj,function()
                                    task.Wait(105)
                                    ex.SmoothSetValueTo("_speed", 20+ran:Float(0,10),16,MOVE_DECEL)
                                    task.Wait(120)
                                    obj.bound = true
                                end)
                                
                            end
                        end
                        PlaySound("tan00")
                        task.Wait(10)
                    end
                    task.Wait(150)
                    local sqang = Angle(fam,player) + 45
                    PlaySound("tan01")
                    for itersq in afor(12) do
                        local pos = math.vecfromobj(fam) + math.polygon(4,itersq:circle()/360) * -16
                        local obj = bullet("scale", BulletColor(210),pos.x, pos.y, 0, itersq:circle())
                        local spd = math.polygon(4,itersq:circle()/360) * 1
                        ex.AsyncSmoothSetValueTo(obj,"vx",spd.x,480,MOVE_DECEL)
                        ex.AsyncSmoothSetValueTo(obj,"vy",spd.y,480,MOVE_DECEL)
                    end
                    Del(fam)
                end)
            end
            task.Wait(90)
        end
        
    end)
end
function M:del()
    for _, obj in ObjList(GROUP_ENEMY_BULLET) do
        if IsValid(obj) then
            Del(obj)
        end
    end
    for _, obj in ObjList(GROUP_INDES) do
        if IsValid(obj) then
            Del(obj)
        end
    end
end

return M