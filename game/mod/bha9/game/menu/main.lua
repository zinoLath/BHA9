stage_init = stage.New("init",true,true)

local main_manager = require("game.menu.manager")
local cardmanager = require("zinolib.card.manager")


function stage_init:init()
end

local delboss = false 
local delboss_press = false
local delboss_pre = false
function stage_init:frame()
    if self.timer == 1 then
        package.loaded["yabmfr2"] = nil
        yabmfr = require("yabmfr2")
        font = yabmfr.LoadFont("yabmfr/test.fnt")
        --font2 = yabmfr.LoadFont("yabmfr/latinfont.fnt")
        font2 = yabmfr.LoadFont("yabmfr/chinesefont.fnt")
        fontpool = yabmfr({font2}, {"田兆間送拉收戊兆回", {state = 1},"新成您給！"})
        fontpool:setAlignment("center","center")
        fontpool:applyAlignment()
        print(yabmfr)
    end
    delboss_pre = delboss
    delboss = KEY.GetKeyState(KEY.R)
    delboss_press = delboss and not delboss_pre
    if delboss_press  then
        self.timer = 0
        stage.Restart()
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
local afor = require("zinolib.advancedfor")
function stage_init:render()
    SetViewMode("ui")
    RenderClear(0)
    if fontpool then
        --Render("white",320,240)
        fontpool:renderOutline(320,240,1,8,0,1,1,Color(255,255,255,255))
        fontpool:SetState("",Color(255,0,0,0))
        --fontpool:render(320,240,self.timer*0,1,1)
    end
end