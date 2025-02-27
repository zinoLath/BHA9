local M = boss.card.New("System \"Me and the OoMF-ies\"", 3, 5, 60, 5000, {0, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "System \"Me and the OoMF-ies\"",
    owner = "Haiji Senri",
    comment = "I've always wanted to make a spellcard with as many bosses\n\
as this one, and I was surprised at how easy it was!",
    id = "game.boss.haiji.spell8"
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

local hpbar = require("game.ui.hpbar")
local fakeboss = require("game.boss.fakeboss")
local function clone1(self)
    self.clone1 = fakeboss(self)
    self.clone1.x = 240
    self.clone1.y = 400
    self.clone1.img = "white"
    local bhp = hpbar(self.clone1)
    local clone = self.clone1
    clone._wisys = BossWalkImageSystem(clone)
    clone._wisys:SetImage("assets/boss/haijisprite1.png", 4,4, {4,4,4,4}, {4,2,2,4}, 6, 16,16)
    clone.hscale, clone.vscale = 0.75/2.25, 0.75/2.25

    bhp.cjuice = ColorS("FFC5FFE9")
    bhp.cjuiceflash = ColorS("FFFFD0A3")
    bhp.cback = ColorS("FF070333")
    bhp.cbleed = ColorS("FF025C69")

    task.New(clone, function()
        task.MoveTo(-100,100,60,MOVE_DECEL)
        --task.Wait(120)
        task.New(clone, function()
            while true do
                bullet("scale",BulletColor(330),clone.x,clone.y,ran:Float(1,3),-90+ran:Float(-10,10))
                task.Wait(7)
            end
        end)
        while true do
            task.MoveToPlayer(30, 
                              -150, 150, 60, 150, 
                              32, 64, 16, 32, 
                              MOVE_ACC_DEC, MOVE_X_TOWARDS_PLAYER
            )
            task.Wait(30)
        end
    end)
end
local function clone2(self)
    self.clone2 = fakeboss(self)
    self.clone2.x = 240
    self.clone2.y = 400
    self.clone2.img = "white"
    local bhp = hpbar(self.clone2)
    local clone = self.clone2
    clone._wisys = BossWalkImageSystem(clone)
    clone._wisys:SetImage("assets/boss/haijisprite2.png", 4,4, {4,4,4,4}, {4,2,2,4}, 6, 16,16)
    clone.hscale, clone.vscale = 0.75/2.25, 0.75/2.25

    bhp.cjuice = ColorS("FFFFC5C5")
    bhp.cjuiceflash = ColorS("FFFFD0A3")
    bhp.cback = ColorS("FF070333")
    bhp.cbleed = ColorS("FF690202")

    task.New(clone, function()
        task.MoveTo(-50,150,60,MOVE_DECEL)
        --task.Wait(120)
        while true do
            task.MoveToPlayer(120, 
                              -150, 150, 60, 150, 
                              32, 64, 16, 32, 
                              MOVE_ACC_DEC, MOVE_RANDOM
            )
            local bang = Angle(clone,player)
            for iter in afor(45) do
                local spread = iter:linear(180,15)
                for iter1 in afor(2) do
                    local _sign = iter1:sign()
                    for iter2 in afor(3) do
                        local spd = iter2:linear(5,2)
                        local ang = bang + spread * _sign
                        bullet("ellipse",BulletColor(0),clone.x, clone.y,spd,ang)
                    end
                end
                task.Wait(1)
            end
            task.Wait(45)
        end
    end)
end

local function clone3(self)
    local clone = fakeboss(self)
    self.clone3 = clone
    clone._wisys = BossWalkImageSystem(clone)
    clone._wisys:SetImage("assets/boss/haijisprite3.png", 4,4, {4,4,4,4}, {4,2,2,4}, 6, 16,16)
    clone.hscale, clone.vscale = 0.75/2.25, 0.75/2.25
    clone.x = 240
    clone.y = 400
    clone.img = "white"
    local bhp = hpbar(clone)

    bhp.cjuice = ColorS("FFFFC5C5")
    bhp.cjuiceflash = ColorS("FFFFD0A3")
    bhp.cback = ColorS("FF070333")
    bhp.cbleed = ColorS("FF690202")

    task.New(clone, function()
        task.MoveTo(50,150,60,MOVE_DECEL)
        while true do
            task.MoveToPlayer(60, 
                              -150, 150, 60, 150, 
                              32, 64, 16, 32, 
                              MOVE_ACC_DEC, MOVE_RANDOM
            )
            local bang = ran:Float(0,360)
            for iter in afor(3) do --count of rings
                for iter1 in afor(10) do --ring count
                    local ang = iter:increment(0,180/iter1.max_count) + bang + iter1:circle()
                    for iter2 in afor(5) do --per segment
                        local final_ang = ang + iter2:linear(-5,5)
                        local spd = iter2:zigzag(1,1.1,2) * iter:linear(1,2.5)
                        bullet("amulet", BulletColor(60), clone.x, clone.y, spd,final_ang)
                    end
                end
            end
            task.Wait(120)
        end
    end)
end
local function clonebase(self)
    local clone = fakeboss(self)
    self.clone3 = clone
    clone.x = 240
    clone.y = 400
    clone.img = "white"
    local bhp = hpbar(clone)

    bhp.cjuice = ColorS("FFFFC5C5")
    bhp.cjuiceflash = ColorS("FFFFD0A3")
    bhp.cback = ColorS("FF070333")
    bhp.cbleed = ColorS("FF690202")

    task.New(clone, function()
        task.MoveTo(-50,150,60,MOVE_DECEL)
    end)
end

function M:init()

    task.New(self, function()
        task.MoveTo(100,100,60,MOVE_ACC_DEC)
        task.Wait(60)
        clone1(self)

        clone2(self)
        clone3(self)
        task.New(self, function()
            while true do
                local bang = Angle(self,player)
                for iter in afor(20) do
                    for iter1 in afor(5) do
                        local spd = iter1:linear(3,4)
                        local ang = iter:circle() + bang
                        bullet("star", BulletColor(120),self.x,self.y,spd,ang)
                    end
                end
                task.Wait(90)
            end
        end)
        while true do
            task.MoveToPlayer(60, 
                              -150, 150, 60, 150, 
                              32, 64, 16, 32, 
                              MOVE_ACC_DEC, MOVE_RANDOM
            )
            --task.Wait(60)
        end
    end)
end

function M:kill()
    if self.clone1 then
        Kill(self.clone1)
    end
    if self.clone2 then
        Kill(self.clone2)
    end
    if self.clone3 then
        Kill(self.clone3)
    end
end
function M:del()
    if self.clone1 then
        Del(self.clone1)
    end
    if self.clone2 then
        Del(self.clone2)
    end
    if self.clone3 then
        Del(self.clone3)
    end
end
return M