stage_init = stage.New("init",true,true)

local main_manager = require("game.menu.manager")
local cardmanager = require("zinolib.card.manager")

function stage_init:init()

    New(mask_fader,'open')
    self.menuman = New(main_manager)
    cardmanager:init_save()
end
local delboss = false 
local delboss_press = false
local delboss_pre = false
function stage_init:frame()
    delboss_pre = delboss
    delboss = KEY.GetKeyState(KEY.R)
    delboss_press = delboss and not delboss_pre
    if delboss_press  then
        for index, value in ipairs(main_manager.menus) do
            package.loaded[value] = nil
        end
        package.loaded["game.menu.manager"] = nil
        main_manager = require("game.menu.manager")
        InitAllClass()
        Del(self.menuman)
        self.menuman = New(main_manager)
        
    end
end

--[[ local yabmfr = require("yabmfr")
local font = yabmfr.LoadFont("yabmfr/test.fnt")
local fontpool = yabmfr(font)
fontpool:PushString("testing")
fontpool.state = 1
fontpool:PushString(" testing with wiggle")
LoadTexture("testing", "debug_red.png")
SetTextureSamplerState("testing","linear+wrap")
local afor = require("zinolib.advancedfor")
LoadImageFromFile("hrlp","hrlp.png") ]]
function stage_init:render()
    SetViewMode("ui")
    RenderClear(0)--[[ 
    local pos = (Vector(GetMousePosition()) - Vector(screen.dx,screen.dy))/ Vector(screen.vScale,screen.hScale)
    SetImageState("white","",Color(255,255,255,255))
    Render("white",pos.x,pos.y)
    fontpool:Clean()
    fontpool:Apply(function (font,p)
        if p.extra2 == 1 then
            p.y = p.y + sin(self.timer*7 + p.extra3*30) * 10
            return true
        end
    end)
    fontpool:Transform(pos,self.timer*2,1)
    fontpool:Render()

    local t = self.timer
    lstg.RenderSimpleTexture("testing","hue+alpha",pos,Rect(t,0,t+256,64),-self.timer*2,Vector2(1,1),
        BulletColor(t*10))
    for iter in afor(360) do
        y = iter:linear(0,screen.height)
        lstg.RenderSimpleTexture("testing","hue+alpha",Vector(0,y),Rect(-1000,-1,1000,1),0,Vector2(1,1),
            BulletColor(iter:linear(0,360)))
    end
    RenderRect("hrlp",60,200,0,screen.height)
    --RenderClear(Color(255,255,0,0)) ]]
end