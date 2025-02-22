local menumanager = require("zinolib.menu.manager")
local tween = require("math.tween")
local M = Class(menumanager)
local manager = M

local title = require("game.menu.title")
local difficulty = require("game.menu.difficulty")
local deck = require("game.menu.deck")
local option = require("game.menu.option")
local spprac = require("game.menu.spprac")
manager.menus = {
    "game.menu.title",
    "game.menu.difficulty",
    "game.menu.deck",
    "game.menu.option",
    "game.menu.spprac",
}
function manager:init()
    self.bg = New(manager.background)
    self.lightpart = New(manager.lightpart)
    _connect(self,self.bg)
    _connect(self.bg,self.lightpart)
    menumanager.init(self)
    self.title = New(title,self)
    self.deck = New(deck,self)
    self.difficulty = New(difficulty,self)
    self.option = New(option,self)
    self.spprac = New(spprac,self)
    _connect(self,self.title)
    _connect(self,self.deck)
    _connect(self,self.difficulty)
    _connect(self,self.option)
    _connect(self,self.spprac)
    table.insert(self.menu_stack, self.title)
    table.insert(self.children,self.bg)
    table.insert(self.children,self.lightpart)
end
function manager:frame()
    menumanager.frame(self)
end

manager.background = Class()
local manbg = manager.background
LoadImageFromFile("menu_bg1", "assets/menu/menu_bg.png")
LoadImageFromFile("menu_shadow", "assets/menu/menu_shadow.png")
SetTexturePreMulAlphaState("menu_shadow",false)
LoadTexture("card_part", "assets/menu/card_part.png")
SetTextureSamplerState("card_part", "point+wrap")
LoadImage("card_part_back", "card_part", 0,0,22,32)
LoadImage("card_part_front", "card_part", 22,0,22,32)
local particle = require("particle")


LoadTexture("plaid", "assets/menu/plaid.png")
SetTextureSamplerState("plaid", "linear+wrap")
--SetTexturePreMulAlphaState("plaid",true)

function manbg:init()
    self.pool = particle.NewPool3D("card_part_front", "", 1024)
    self.freq = 0.2
    self.partval = 0
    self.layer = -10000
    self.scroll = Vector(0,0)
    self.scrollvel = Vector(-0.25,0.1)
end
function manbg:frame()
    while self.partval > 1 do
        local p = self.pool:AddParticle(pran:Float(-60,60),-70,pran:Float(60,120))
        local spd, ang = pran:Float(0.1,0.2)*2, 90+pran:Float(30,-30)
        p.vx = spd * cos(ang)
        p.vy = spd * sin(ang)
        p.sx = 0.2
        p.sy = 0.2
        p.ox = ran:Float(-1,1)
        p.oy = ran:Float(-1,1)
        p.oz = ran:Float(-1,1)
        p.a = 64
        self.partval = self.partval - 1
    end
    self.partval = self.partval + self.freq
    self.pool:Update()
    self.scroll = self.scroll + self.scrollvel
end

function manbg:render()
    RenderRect("menu_bg1",0,screen.width,0,screen.height)
	--set 3d camera and fog
	Set3D('eye',0,0,-10)
	--Set3D('eye',0,20,20)
	Set3D('at',0,0,0)
	Set3D('up',0,1,0)
	Set3D('z',0.01,400)
	--Set3D('z',1,100)
	Set3D('fovy',1)
	self.fagcolor = ColorS("FF071530")
	Set3D('fog',0.1,120,self.fagcolor)
    SetViewMode("3dui")
    self.pool:Render()
    SetViewMode("ui")
    local cplaid = ColorS("FF4C207E")
    local scale = 2
    local u,v = self.scroll.x*scale, self.scroll.y*scale
    local w,h = screen.width*scale, screen.height*scale
    local l,r,b,t = 0,screen.width,0,screen.height
    RenderTexture("plaid", "alpha+bal", 
                  {l,t,0,u,v,cplaid}, 
                  {r,t,0,u+w,v,cplaid}, 
                  {r,b,0,u+w,v+h,cplaid}, 
                  {l,b,0,u,v+h,cplaid})
    SetImageState("menu_shadow", "mul+mul", Color(255,255,255,255))
    RenderRect("menu_shadow",0,screen.width,0,screen.height)
    --RenderRect("menu_shadow",0,screen.width,0,screen.height)
end

manager.lightpart = Class()
local manlpart = manager.lightpart
LoadImageFromFile("lightraypart", "assets/menu/lightray2.png")
SetImageCenter("lightraypart",0,64)

function manlpart:init()

    self.layer = -10000 + 10
    self.lightpool = particle.NewPool2D("lightraypart","hue+screen",16)
    self.lightfreq = 0.05
    self.lightval = 1
    self.lft1 = 240
    self.lft2 = 0
    self.lft3 = 120
end

function manlpart:frame()
    while self.lightval > 1 do
        local a = ran:Float(30,60)
        local p = self.lightpool:AddParticle(pran:Float(-600,screen.width*1),screen.height*-0.5,a)
        p.omiga = ran:Float(-0.00,0.01)*2
        p.sx = 6
        p.sy = 1
        p.color = BulletColor(240,100)
        self.lightval = self.lightval - 1
    end
    self.lightval = self.lightval + self.lightfreq
    self.lightpool:Update()
    self.lightpool:Apply(function(p)
        local maxa = 48
        if p.timer < self.lft1 then
            local i = p.timer
            local t = i/self.lft1
            p.a = math.lerp(0,maxa,tween.quadOut(t))
        elseif p.timer-self.lft1 < self.lft2 then
            local i = p.timer-self.lft1
            local t = i/self.lft2
        elseif p.timer-self.lft1-self.lft2 < self.lft3  then
            local i = p.timer-self.lft1-self.lft2
            local t = i/self.lft3
            p.a = math.lerp(maxa,0,tween.quadOut(t))
        end
    end)
end

function manlpart:render()
    self.lightpool:Render()
end

return M