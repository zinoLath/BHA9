local M = boss.card.New("Eleventh Curse \"Precursor of Kaiser\"", 3, 5, 60, 100, {0, 0, 0}, false)
M.boss = "game.boss.haiji"
boss.addspell {
    name = "Eleventh Curse \"Precursor of Kaiser\"",
    owner = "Haiji Senri",
    comment = "I inspired myself on Autocatalysis of Unrecognizable\n\
Katzenjammer's Act #4. I also added some Senri spice!",
    id = "game.boss.haiji.spell3"
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

local push_rt = Class()
local pop_rt = Class()

local function RenderRectText(texture,cw,l,r,b,t,ul,ur,vb,vt)
    --local cw = Color(255,255,255,255)
    RenderTexture(texture, "",
        {l, t, 0, ul, vt, cw},
        {r, t, 0, ur, vt, cw},
        {r, b, 0, ur, vb, cw},
        {l, b, 0, ul, vb, cw}
    )
end

CreateRenderTarget("aoukasseffect")
function pop_rt:init()
    self.push = New(push_rt,self)
    self.x,self.y = 0,0
    self.bound = false 
    self.layer = LAYER_UI_TOP
end
function pop_rt:frame()
    self.x = self.x - player.dx
    self.y = self.y - player.dy
    if player.x >= lstg.world.pr-10 and KeyIsDown("right") then
        player.x = lstg.world.pl
    end
    if player.x <= lstg.world.pl+10 and KeyIsDown("left") then
        player.x = lstg.world.pr
    end
    if player.y >= lstg.world.pt-32 and KeyIsDown("up") then
        player.y = lstg.world.pb
    end
    if player.y <= lstg.world.pb+17 and KeyIsDown("down") then
        player.y = lstg.world.pt
    end
end
function pop_rt:kill()
    Kill(self.push)
end
function pop_rt:del()
    Del(self.push)
end
local function RenderFuckassScreen(px,py,scale,bordercount,color)
    local w = lstg.world
    local wr = w.pr * scale
    local wl = w.pl * scale
    local wt = w.pt * scale
    local wb = w.pb * scale
    while px > wr do
    px = px - wr*2
    end
    while px < wl do
        px = px + wr*2
    end
    while py > wt do
       py = py - wt*2
    end
    while py < wb do
       py = py + wt*2
    end
    local _w,_h = wr*2, wt*2
    local ratio = screen.scale
    for x=-bordercount,bordercount do
        for y=-bordercount,bordercount do
            local _x, _y = x * _w + px, y * _h + py
            RenderRectText("aoukasseffect",color,wl+_x,wr+_x,wb+_y,wt+_y,
                                           w.scrl*ratio,w.scrr*ratio,w.scrt*ratio,w.scrb*ratio)
        end
    end

end
function pop_rt:render()
    PopRenderTarget("aoukasseffect")
    local vw = lstg.viewmode
    SetViewMode("world")
    for iter in afor(10) do
        local r = self.timer
        local ang = iter:circle()

        --RenderFuckassScreen(self.x + r * cos(ang),self.y + r * sin(ang),0.5,5,HSVColor(25,ang/3.6,100,50))

    end
    RenderFuckassScreen(self.x,self.y,1,1,Color(255,255,255,255))
    SetViewMode(vw)
end

function push_rt:init(master)
    self.master = master
    self.layer = LAYER_BG+10
end
function push_rt:render()
    PushRenderTarget("aoukasseffect")
    RenderClear(0)
end

function M:init()
    local color_familiar = HSVColor(100,240/3.6,100,100)
    task.New(self, function()
        task.New(player, function()
            task.MoveTo(0,0,60,MOVE_ACC_DEC)
            local obj = New(pop_rt)
            _connect(self, obj, 0, true)
        end)
        task.MoveTo(0,120,60,MOVE_ACC_DEC)
        --task.Wait(60)
        task.New(self,function()
            local spin_rot = 0.6
            local spin = 0
            local wttime = 2
            for iter_master in afor(_infinite) do
                for iter1 in afor(7) do
                    for iter in afor(5) do
                        local ang = spin + iter:circle() + iter1:linear(0,wttime*spin_rot)*5
                        local obj = bullet("amulet",BulletColor(0),self.x,self.y,1,ang)
                        local spd = iter1:linear(8,10)
                        local wait = iter1:linear(20,5)
                        task.New(obj,function()
                            task.Wait(30)
                            --ex.AsyncSmoothSetValueTo(obj,"_angle",obj._angle-180*spin_rot,15,MOVE_ACC_DEC)
                            ex.SmoothSetValueTo("_speed",spd,wait,MOVE_ACC_DEC)
                        end)
                    end
                end
                
                task.Wait(wttime)
                spin = spin + spin_rot * wttime
                if iter_master.current%100 == 0 then
                    spin_rot = -spin_rot
                end
            end 
        end)
        task.New(self,function()
            task.Wait(180)
            while true do
                local ang = ran:Float(0,360)
                local count = 13
                local spread = 5
                for iter1 in afor(count) do
                    for iter2 in afor(5) do
                        local _ang = ang + iter1:circle() + iter2:linear(-spread,spread)
                        bullet("amulet", BulletColor(240), self.x,self.y,3/2,_ang)
                    end
                end
                for iter1 in afor(count) do
                    for iter2 in afor(5) do
                        local _ang = ang + iter1:circle() + iter2:linear(-spread,spread) + 180/count
                        bullet("amulet", BulletColor(120), self.x,self.y,2.5/2,_ang)
                    end
                end
                task.Wait(60)
            end
        end)
    end)
end

return M