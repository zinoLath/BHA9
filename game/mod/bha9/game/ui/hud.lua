local M = Class()
local ui = M
local cardmanager = require("zinolib.card.manager")
local prefix_path = "assets/ui/"
local afor = require("zinolib.advancedfor")
require("game.vfx.misc")
local function ReloadTexture(tex,path,mipmap)
    local pool = CheckRes("tex",tex)
    if pool then
        RemoveResource(pool,1,tex)
    end
    LoadTexture(tex,path,mipmap)
end
local function ReloadImage(img,...)
    local pool = CheckRes("img",img)
    if pool then
        RemoveResource(pool,2,img)
    end
    LoadImage(img,...)
end
local function UpdateScore(self)

    local var = lstg.var
    local cur_score = var.score
    local score = self.score or cur_score
    local score_tmp = self.score_tmp or cur_score
    if score_tmp < cur_score then
        if cur_score - score_tmp <= 100 then
            score = score + 10
        elseif cur_score - score_tmp <= 1000 then
            score = score + 100
        else
            score = int(score / 10 + int((cur_score - score_tmp) / 600)) * 10 + cur_score % 10
        end
    end
    if score_tmp > cur_score then
        score_tmp = cur_score
        score = cur_score
    end
    if score >= cur_score then
        score_tmp = cur_score
        score = cur_score
    end
    self.score = math.min(score,999999999999)
    self.score_tmp = score_tmp
end
local particle = require("particle")
LoadImageFromFile("hud_bg",prefix_path .. "hud.png",true)

ReloadTexture("bar_shadow",prefix_path .. "bar_shadow.png",true)
SetTextureSamplerState("bar_shadow","linear+wrap")
ReloadTexture("bar_shell",prefix_path .. "bar_shell.png",true)
SetTextureSamplerState("bar_shell","linear+wrap")
ReloadTexture("bg_scroll",prefix_path .. "bg_scroll.png",true)
SetTextureSamplerState("bg_scroll","linear+wrap")
ReloadTexture("health_scroll",prefix_path .. "health_scroll.png",true)
SetTextureSamplerState("health_scroll","linear+wrap")
ReloadTexture("numbers",prefix_path .. "numbers.png",true)
SetTextureSamplerState("numbers","linear+wrap")
ReloadTexture("hudelem",prefix_path .. "hudelem.png",true)
ReloadImage("ui:difficulty","hudelem",0,0,384,128)
ReloadImage("ui:hscore","hudelem",0,128,256,64)
ReloadImage("ui:score" ,"hudelem",0,192,256,64)
ReloadImage("ui:health","hudelem",0,256,256,64)
ReloadImage("ui:value" ,"hudelem",0,320,256,64)
ReloadImage("ui:graze" ,"hudelem",0,384,256,64)
local images = {
"ui:hscore",
"ui:score" ,
"ui:health",
"ui:value" ,
"ui:graze" 
}
local names = {
    "hscore", "score", "health", "value", "graze"
}
for index, value in ipairs(images) do
    SetImageCenter(value,0,32)
end

local function RenderTextureRectR(tex, blend, rectuv, rectpos,color,...)
    local pos = rectpos.center
    local scale = rectpos.dimension/rectuv.dimension
    color = color or Color(255,255,255,255)
    RenderTextureRect(tex, blend, pos, rectuv, 0, scale, color,...)
end

function ui:init()
    self.layer = LAYER_UI
    self.jiggles = {}
    self.state = {}
    for index, value in ipairs(names) do
        self.jiggles[value] = {
            val = 0,
            spd = 0,
            accel = 0.1
        }
        self.state[value] = {
            a = 0
        }
    end
    self.cardcount = 0
    self.state.hscore.pool = particle.NewTexPool2D("numbers","hue+alpha",20)
    local xnum = lstg.world.scrr+256*0.4
    self.numsize = Vector(90,92)
    self.numtime = 1 
    local p1, p2 = Vector(xnum,400),Vector(screen.width-16,395)
    for iter in afor(4) do
        for iter1 in afor(3) do
            local p = self.state.hscore.pool:AddParticle(0,0,0,0,0,0,0)
            p.pos = iter:linear(p2-Vector(20,0),p1)
            p.x = p.x + iter1:linear(17,0)
            p.u = self.numsize.x
            p.w = self.numsize.x
            p.h = self.numsize.y
            p.v = p.h/self.numtime
            p.sx = 0.2
            p.sy = 0.2
            p.color = Color(255,255,255,255)
            p.extra1 = iter.current*iter1.max_count+iter1.current
            p.extra2 = 0
            p.vy = p.y
        end
    end
    self.state.score.pool = particle.NewTexPool2D("numbers","hue+alpha",20)
    local p1, p2 = Vector(xnum,370),Vector(screen.width-16,365)
    for iter in afor(4) do
        for iter1 in afor(3) do
            local p = self.state.score.pool:AddParticle(0,0,0,0,0,0,0)
            p.pos = iter:linear(p2-Vector(20,0),p1)
            p.x = p.x + iter1:linear(17,0)
            p.u = self.numsize.x
            p.w = self.numsize.x
            p.h = self.numsize.y
            p.v = p.h/self.numtime
            p.sx = 0.2
            p.sy = 0.2
            p.color = Color(255,255,255,255)
            p.extra1 = iter.current*iter1.max_count+iter1.current
            p.extra2 = 0
            p.vy = p.y
        end
    end
    self.state.graze.pool = particle.NewTexPool2D("numbers","hue+alpha",20)
    xnum = lstg.world.scrr+256*0.4+32
    local p1, p2 = Vector(xnum,265),Vector(screen.width-16,260)
    for iter in afor(6) do
        local p = self.state.graze.pool:AddParticle(0,0,0,0,0,0,0)
        p.pos = iter:linear(p2,p1)
        p.u = self.numsize.x
        p.w = self.numsize.x
        p.h = self.numsize.y
        p.v = p.h/self.numtime
        p.sx = 0.25
        p.sy = 0.2
        p.color = Color(255,255,255,255)
        p.extra1 = iter.current
        p.extra2 = 0
        p.vy = p.y
    end
    self.state.value.pool = particle.NewTexPool2D("numbers","hue+alpha",20)
    xnum = lstg.world.scrr+256*0.4+32
    local p1, p2 = Vector(xnum,295),Vector(screen.width-16,290)
    for iter in afor(6) do
        local p = self.state.value.pool:AddParticle(0,0,0,0,0,0,0)
        p.pos = iter:linear(p2,p1)
        p.u = self.numsize.x
        p.w = self.numsize.x
        p.h = self.numsize.y
        p.v = p.h/self.numtime
        p.sx = 0.25
        p.sy = 0.2
        p.color = Color(255,255,255,255)
        p.extra1 = iter.current
        p.extra2 = 0
        p.vy = p.y
    end
    self.jiggles.health.accel = 0.03
    self.jiggles.graze.accel = 0.2
    UpdateScore(self)
    task.New(self,function()
        task.Wait(15)
        for k,v in ipairs(names) do
            local cur = v
            task.New(self,function()
                for iter in afor(30) do
                    self.state[cur].a = iter:linear(0,255,MOVE_DECEL)
                    task.Wait(1)
                end
            end)
            task.Wait(5)
        end
    end)
    self.cardcostpool = particle.NewPool2D("white","mul+add",256)
    self.cpoolvar = 0
    self.cpoolfreq = 1/10
end
local function getDigit(num, digit)
	local n = 10 ^ digit
	local n1 = 10 ^ (digit - 1)
	return int((num % n) / n1)
end

local function Wrap(x, x_min, x_max)
    return (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min;
end
function ui:frame()
    local cardpartlifetime = 30
    local ww, wh  = GetImageSize("white")
    local w,h = GetImageSize("card_bg")
    self.cardcostpool:Apply(function(p)
        local t = p.timer/cardpartlifetime
        p.timer = p.timer+1
        local sx,sy = p.vx, p.vx
        p.sx = sx * w/ww
        p.sy = sy * h/wh
        p.scale = p.scale * math.lerp(1.1,1.5,t)
        p.color = math.lerpcolor(ColorS("7FFFCB1F"),ColorS("00FFFD85"),t)
        if p.timer >= cardpartlifetime then
            return true
        end
    end)

    local p1 = Vector(lstg.world.scrr+48,80)
    local p2 = Vector(screen.width-30,30)
    local hand = lstg.var.card_context.hand
    local firstcard = hand[1]
    local firstcardclass = cardmanager.cardlist[firstcard]
    while self.cpoolvar >=1 and #hand > 0 do
        if firstcardclass.cost > #hand then
            break
        end
        for k = firstcardclass.cost , 2, -1 do
            local obj = lstg.var.card_context.hand[k]
            local pos = math.lerp(p1,p2,k/5)
            local cl = cardmanager.cardlist[obj]
            local scale = math.lerp(0.35,0.12,k/5)
            local xoff = 0
            local t = self.cardcount-int(k-1)
            t = math.clamp(t,0,1)
            if k == 5 then
                xoff = -8
            end
            if k ~= 1 then
                local p = self.cardcostpool:AddParticle(pos.x+xoff,pos.y)
                p.vx = scale
                p.vy = scale*t
            end
        end
        if #lstg.var.card_context.hand > 0 then
            local t = self.cardcount
            t = math.clamp(t,0,1)
            local pos = p1
            local p = self.cardcostpool:AddParticle(pos.x+10,pos.y)
            p.vx = 0.4
            p.vy = 0.4*t
        end
        self.cpoolvar = self.cpoolvar-1
    end
    self.cpoolvar = math.clamp(self.cpoolvar + self.cpoolfreq,0,3)
    
    task.Do(self)
    local hand = lstg.var.card_context.hand
    self.cardcount = math.lerp(self.cardcount,#hand,0.1)
    if self.cardcount > #hand or #hand-self.cardcount < 0.01 then
        self.cardcount = #hand
    end
    UpdateScore(self)
    for index, value in pairs(self.jiggles) do
        self.jiggles[index].val = math.clamp(self.jiggles[index].spd + self.jiggles[index].val,-1,1)
        self.jiggles[index].spd = math.lerp(self.jiggles[index].spd,-self.jiggles[index].val,self.jiggles[index].accel)
    end
    
    if player.grazer.last_graze == player.grazer.timer-2 and player.grazer.last_graze ~= 0 then
        self.jiggles.graze.spd = -0.8
    end
    if player.death == 99 then
        self.jiggles.health.spd = -0.6
    end
    local tnum = 0.2
    self.state.hscore.pool:Apply(function(p)
        local tgtnum = (getDigit(max(lstg.tmpvar.hiscore or 0, self.score or 0), p.extra1))%10
        if tgtnum >= p.extra2 then
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum,tnum), 0, 10)
        else
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum+10,tnum), 0, 10)
        end
        p.v = -p.extra2 * p.h
    end)
    self.state.score.pool:Apply(function(p)
        local tgtnum = (getDigit(self.score, p.extra1))%10
        if tgtnum >= p.extra2 then
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum,tnum), 0, 10)
        else
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum+10,tnum), 0, 10)
        end
        p.v = -p.extra2 * p.h
    end)
    self.state.graze.pool:Apply(function(p)
        local tgtnum = (getDigit(lstg.var.graze, p.extra1))%10
        if tgtnum >= p.extra2 then
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum,tnum), 0, 10)
        else
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum+10,tnum), 0, 10)
        end
        p.v = -p.extra2 * p.h
    end)
    self.state.value.pool:Apply(function(p)
        local tgtnum = (getDigit(lstg.var.pointrate, p.extra1))%10
        if tgtnum >= p.extra2 then
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum,tnum), 0, 10)
        else
            p.extra2 = Wrap(math.lerp(p.extra2,tgtnum+10,tnum), 0, 10)
        end
        p.v = -p.extra2 * p.h
    end)

    for key, value in pairs(self.state) do
        if value.pool then
            value.pool:Apply(function (p)
                p.y = p.vy + 1 * sin(p.extra1*30 + self.timer*2)
                p.rot = 5 * sin(p.extra1*45 - self.timer*2)
            end)
        end
    end
    cardmanager:get_gauge(100/60)
    lstg.var.score = lstg.var.score + 10000
end

function ui:render()
    SetViewMode("ui")
    RenderRect("hud_bg",screen.dx,screen.dx+screen.width,screen.dy,screen.dy+screen.height)
    SetImageState("white", "", Color(8,0,0,0))
    local w = lstg.world
    local screenrect = Rect(w.scrl, w.scrb,w.scrr,w.scrt)
    --print(tostring(screenrect) .. " x " .. string.format("%d, %d, %d, %d",w.scrl, w.scrt,w.scrr,w.scrt))
    for iter1 in afor(64) do
        local _rect = Rect(0,0,0,0)
        _rect.dimension = screenrect.dimension + iter1:linear(0,32)
        _rect.center = screenrect.center
        RenderRect("white", _rect.l,_rect.r,_rect.b,_rect.t)
    end
    local centerx = math.lerp(w.scrr,screen.width+screen.dx,0.5)
    Render("ui:difficulty",centerx+12,450,0,0.4)
    local hinterx = w.scrr+16
    local hue = 180
    SetImageState("ui:hscore","hue+alpha",BulletColor(hue,nil,self.state.hscore.a))
    RenderFadingRect(Vector(w.scrr,400),100,100,27,0,Color(150,0,0,0))
    Render("ui:hscore",hinterx,400+2*sin(self.timer-180),1*sin(self.timer),0.4)
    self.state.hscore.pool:Apply(function(p)
        p.color = BulletColor(hue,nil,self.state.hscore.a)
        if 10^(p.extra1-1) > max(lstg.tmpvar.hiscore or 0, self.score or 0) then
            p.a = p.a * 0.5
        end
    end)
    self.state.hscore.pool:Render()
    local hue = 210
    SetImageState("ui:score","hue+alpha",BulletColor(hue,nil,self.state.score.a))
    RenderFadingRect(Vector(w.scrr,370),100,100,27,0,Color(150,0,0,0))
    Render("ui:score" ,hinterx,370+2*sin(self.timer-90),1*sin(self.timer*2),0.4)
    self.state.score.pool:Apply(function(p)
        p.color = BulletColor(hue,nil,self.state.score.a)
        if 10^(p.extra1-1) > self.score then
            p.a = p.a * 0.5
        end
    end)
    self.state.score.pool:Render()
    local hue = 10
    local jigglec = self.jiggles.health.val * 0.06
    SetImageState("ui:health","hue+alpha",BulletColor(hue + self.jiggles.health.val * 10,nil,self.state.health.a))
    RenderFadingRect(Vector(w.scrr,325),100,100,27,0,Color(150,0,0,0))
    Render("ui:health",hinterx,325+2*sin(self.timer-45),1*sin(self.timer*1.5),0.4+jigglec,0.4-jigglec)
    local hue = 100
    SetImageState("ui:value","hue+alpha",BulletColor(hue,nil,self.state.value.a))
    RenderFadingRect(Vector(w.scrr,295),115,100,27,0,Color(150,0,0,0))
    Render("ui:value" ,hinterx+15,295+2*sin(self.timer-15),1*sin(self.timer*2.3),0.4)
    self.state.value.pool:Apply(function(p)
        p.color = BulletColor(hue,nil,self.state.value.a)
        if 10^(p.extra1-1) > lstg.var.pointrate then
            p.a = p.a * 0.5
        end
    end)
    self.state.value.pool:Render()
    local hue = 40
    local jigglec = self.jiggles.graze.val * 0.02
    SetImageState("ui:graze","hue+alpha",BulletColor(hue,nil,self.state.graze.a))
    RenderFadingRect(Vector(w.scrr,265),115,100,27,0,Color(150,0,0,0))
    Render("ui:graze" ,hinterx+15,265+2*sin(self.timer-64),1*sin(self.timer*3),0.4+jigglec,0.4-jigglec)

    self.state.graze.pool:Apply(function(p)
        p.color = BulletColor(hue,nil,self.state.graze.a)
        if 10^(p.extra1-1) > lstg.var.graze then
            p.a = p.a * 0.5
        end
    end)
    self.state.graze.pool:Render()

    local health_count = 0.3
    local bg_rect = RectWHV(Vector(w.scrr+100,321),Vector(120,15))
    local bg_uv = RectWH(0,0,GetTextureSize("bg_scroll"))
    RenderTextureRectR("bg_scroll", "", bg_uv + Vector(self.timer*-2,0), bg_rect)

    local health_uv = bg_uv.copy
    local health_rect = bg_rect.copy
    health_rect.r = health_rect.l + health_rect.width * health_count
    health_uv.r = health_uv.l + health_uv.width * health_count
    local undershadow = bg_rect.copy
    undershadow.l  = health_rect.r
    RenderTextureRectR("bar_shadow", "", bg_uv, undershadow,Color(160,0,0,0))
    RenderTextureRectR("health_scroll", "", health_uv + Vector(self.timer*-2,0), health_rect)
    RenderTextureRectR("bar_shadow", "", bg_uv, health_rect,Color(255,0,0,0))
    --RenderTextureRectR("bar_shadow", "", bg_uv, bg_rect,Color(64,0,0,0))

    local shell_rect= bg_rect.copy
    shell_rect.lb = shell_rect.lb - (Vector(4.7,-3.5)/Vector(150,25))*bg_rect.dimension
    RenderTextureRectR("bar_shell", "", RectWH(0,0,GetTextureSize("bar_shell")), shell_rect)
    self.cardcostpool:Render()
    local p1 = Vector(lstg.world.scrr+48,80)
    local p2 = Vector(screen.width-30,30)
    local hand = lstg.var.card_context.hand
    for k = 5 , 2, -1 do
        local pos = math.lerp(p1,p2,k/5)
        local scale = math.lerp(0.35,0.12,k/5)
        local xoff = 0
        local t = self.cardcount-int(k-1)
        t = math.clamp(t,0,1)
        if k == 4 then
            xoff = -4
        end
        if k == 5 then
            xoff = -13
        end
        SetImageState("card_bg","",Color(192,128,128,128))
        Render("card_bg",pos.x+xoff,pos.y,0,scale,scale)
        if k <= #hand then
            local obj = lstg.var.card_context.hand[k]
            local cl = cardmanager.cardlist[obj]
            cardmanager:RenderCard(cl.img,pos.x+xoff,pos.y,0,scale,scale*t)
        elseif k == #hand+1 then
            local ww, wh = GetImageSize("white")
            local w, h = GetImageSize("card_bg")
            SetImageState("white","", Color(128,255,0,0))
            local val = lstg.var.card_context.gauge/100
            SetImageCenter("white",8,16)
            Render("white",pos.x+xoff,pos.y-h*scale/2,0,w*scale/ww,h*scale*val/wh)
            SetImageCenter("white",8,8)
        end
    end
    
    SetImageState("card_bg","",Color(192,128,128,128))
    Render("card_bg",p1.x+10,p1.y,0,0.4,0.4)
    if #hand > 0 then
        local t = self.cardcount
        t = math.clamp(t,0,1)
        local cl = cardmanager.cardlist[lstg.var.card_context.hand[1]]
        cardmanager:RenderCard(cl.img,p1.x+10,p1.y,0,0.4,0.4*t)
    end
end

return M