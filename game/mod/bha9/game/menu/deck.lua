require("game.vfx.misc")
local menu = require("zinolib.menu.menu")
local M = Class(menu)
local deck_creation = M
local cm = require("zinolib.card.manager")
local afor = require("zinolib.advancedfor")
local tween = require("math.tween")
local yabmfr = require("yabmfr")
local hadirsans = require("game.font").hadirsans

local select_sq = Class()
select_sq[".render"] = true
function select_sq:init(master)
    self.menu = master
    self.bound = false
    self.layer = -100
    self._pos = Vector(0,300)
    _connect(master, self, 0, true)
    self._color = Color(255,0,0,0)
end
function select_sq:frame()
    self._a = 128 * self.menu._in
end
function select_sq:render()
    RenderFadingRect(self._pos, 400,128,96,0,self._color)
end

deck_creation.spacing = 100
function deck_creation:init(manager)
    menu.init(self)
    menu.select_init(self)
    self.manager = manager
    self.check_up = coroutine.create(menu.input_checker)
    self.check_down = coroutine.create(menu.input_checker)
    self.check_left = coroutine.create(menu.input_checker)
    self.check_right = coroutine.create(menu.input_checker)
    self.direction = 1
    self.selectables = {}
    local i = 0
    for index, value in ipairs(cm.cardorder) do
        if scoredata.cardunlock[value] == true then
            local opt = New(deck_creation.coption,value,i,self)
            table.insert(self.selectables,opt)
            i = i + 1
        end
    end
    self._in = 0
    self.ysel = 0
    self.xoff = 100
    self.selected = self.selectables[self.select_id]
    self.selected.selected = 1
    New(select_sq,self)
end

function deck_creation:co_update()
    while true do
        local _, upval = coroutine.resume(self.check_up,"up") 
        local _, downval = coroutine.resume(self.check_down,"down")
        local is_up = upval and -1 or 0
        local is_down = downval and 1 or 0
        local direction = is_up + is_down
        if direction ~= 0 then        
            print(direction)
            self.direction = direction
        end
        menu.select_dir(self, direction)
        if KeyIsDown("spell") then
            self.manager.class.pop(self.manager)
        end
        if KeyIsDown("shoot") then
            print(self.selected.card)
        end

        local _, leftval = coroutine.resume(self.check_left,"left") 
        local _, rightval = coroutine.resume(self.check_right,"right")
        local is_left = leftval and -1 or 0
        local is_right = rightval and 1 or 0
        local directionH = is_left + is_right
        local count = scoredata.deck[self.selected.card] or 0
        local total = 0 
        for k,v in pairs(cm.cardlist) do
            total = total + (scoredata.deck[k] or 0)
        end
        if directionH ~= 0 and math.clamp(count + directionH,0,4) == count+directionH and total + directionH <= 20 then        
            scoredata.deck[self.selected.card] = count + directionH
        end
        coroutine.yield()
    end
end
function deck_creation:select_update(new_opt)
    if self.selected == new_opt then
        return 
    end
    menu.select_update(self,new_opt)
    local dir = self.direction
    --print(dir)

    task.NewNamed(self, "selectcardmove", function()
        local init = self.ysel
        for iter in afor(15) do
            self.ysel = iter:linear(init,(self.select_id-1) * deck_creation.spacing,MOVE_DECEL)
            task.Wait(1)
        end
    end)
    for index, value in ipairs(self.selectables) do
        value.selected = 0
    end
    self.selected.selected = 1
end
function deck_creation:move_in()
    local t = 60
    task.NewNamed(self,"move", function()
        local initin = self._in
        local initxoff = self.xoff
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,1)
            self.xoff = iter:linear(initxoff,0,tween.quadOut)
            task.Wait(1)
        end
    end)
end
function deck_creation:move_out()
    local t = 30
    task.NewNamed(self,"move", function()
        local initin = self._in
        local initxoff = self.xoff
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,0)
            self.xoff = iter:linear(initxoff,-200,tween.quadIn)
            task.Wait(1)
        end
        self.xoff = 100
    end)
end

local cardoption = Class()
deck_creation.coption = cardoption
cardoption[".render"] = true

function cardoption:init(card,id,_menu)
    self.card = card --card is the id
    self.cardclass = cm.cardlist[card]
    self.id = id
    self.bound = false
    self._x = 100
    self._y = 300 - id * deck_creation.spacing
    self.menu = _menu
    self.heightalpha = 1
    self.name = yabmfr(hadirsans,string.len(self.cardclass.name))
    self.name:PushString(self.cardclass.name)
    self.desc = yabmfr(hadirsans,string.len(self.cardclass.description))
    self.desc:PushString(self.cardclass.description)
    self.count = scoredata.deck[card] or 0
    self.prevcount = self.count
    self.selected = 0
    self.selalpha = 0
    local strcount = string.format("%d/4",self.count)
    self.countpool = yabmfr(hadirsans,string.len(strcount))
    self.countpool:PushString(strcount)
end

function cardoption:frame()
    self.x, self.y = self._x + self.menu.xoff, self._y + self.menu.ysel
    self.heightalpha = 1
    if self.y > 300 then
        self.heightalpha = 1-math.clamp((self.y-300)/150,0,1)
    end
    self.selalpha = math.lerp(self.selalpha,self.selected,0.2)
    self._a = self.heightalpha * 255 * self.menu._in * math.lerp(0.5,1,self.selalpha)
    self.count = scoredata.deck[self.card] or 0
    if self.count ~= self.prevcount then
        self.prevcount = self.count
        local strcount = string.format("%d/4",self.count)
        self.countpool = yabmfr(hadirsans,string.len(strcount))
        self.countpool:PushString(strcount)
    end
end

local afor = require("zinolib.advancedfor")
function cardoption:render()
    if self._a == 0 then
        return 
    end
    cm:RenderCard(self.cardclass.img,self.x,self.y,0,0.4,nil,self._color)
    SetFontState("menu", "", self._color)
    self.name:Clean()
    self.desc:Clean()
    self.countpool:Clean()
    self.name:Transform(self._pos + Vector(40,40),0,0.6/3)
    self.desc:Transform(self._pos + Vector(50,15),0,0.4/3)
    self.countpool:Transform(self._pos + Vector(200,40),0,0.4/3)
    
    local alpha = 0.2
    local distance = Vector(6,-3)
    self.name:Apply(function (font,p)
        p.rot = sin(self.timer*2+p.extra3*30)*4
        for iter in afor(8) do
            local off = math.polar(4,iter:circle()) + distance
            lstg.RenderTextureRect(
                font.font.texture, "", 
                p.pos+off, 
                lstg.Rect(p.u, p.v, p.u + p.w, p.v + p.h), 
                p.rot, p.scale, Color(self._a*alpha,0,0,0)
            )
            local off = math.polar(2,iter:circle())
            lstg.RenderTextureRect(
                font.font.texture, "", 
                p.pos+off, 
                lstg.Rect(p.u, p.v, p.u + p.w, p.v + p.h), 
                p.rot, p.scale, Color(self._a,0,0,0)
            )
        end
        p.color = self._color
    end)
    self.desc:Apply(function (font,p)
        for iter in afor(8) do
            local off = math.polar(4,iter:circle()) + distance
            lstg.RenderTextureRect(
                font.font.texture, "", 
                p.pos+off, 
                lstg.Rect(p.u, p.v, p.u + p.w, p.v + p.h), 
                p.rot, p.scale, Color(self._a*alpha,0,0,0)
            )
            local off = math.polar(2,iter:circle())
            lstg.RenderTextureRect(
                font.font.texture, "", 
                p.pos+off, 
                lstg.Rect(p.u, p.v, p.u + p.w, p.v + p.h), 
                p.rot, p.scale, Color(self._a,0,0,0)
            )
        end
        p.color = self._color
    end)
    self.countpool:Apply(function (font,p)
        for iter in afor(8) do
            local off = math.polar(4,iter:circle()) + distance
            lstg.RenderTextureRect(
                font.font.texture, "", 
                p.pos+off, 
                lstg.Rect(p.u, p.v, p.u + p.w, p.v + p.h), 
                p.rot, p.scale, Color(self._a*alpha,0,0,0)
            )
            local off = math.polar(2,iter:circle())
            lstg.RenderTextureRect(
                font.font.texture, "", 
                p.pos+off, 
                lstg.Rect(p.u, p.v, p.u + p.w, p.v + p.h), 
                p.rot, p.scale, Color(self._a,0,0,0)
            )
        end
        p.color = self._color
    end)
    local c1 = Color(self._a,255,255,255)
    local c2 = ColorS("FFC3BFFF")
    c2.a = self._a
    self.name:Apply(function (font,p)
        lstg.RenderTextureRect(
            font.font.texture, "", 
            p.pos, 
            RectWH(p.u, p.v, p.w, p.h), 
            p.rot, p.scale, c1,c1,c2,c2
        )
    end)
    self.desc:Apply(function (font,p)
        lstg.RenderTextureRect(
            font.font.texture, "", 
            p.pos, 
            RectWH(p.u, p.v, p.w, p.h), 
            p.rot, p.scale, c1,c1,c2,c2
        )
    end)
    local c1 = Color(self._a,255,255,255)
    local c2 = ColorS("FFFFBFBF")
    c2.a = self._a
    self.countpool:Apply(function (font,p)
        lstg.RenderTextureRect(
            font.font.texture, "", 
            p.pos, 
            RectWH(p.u, p.v, p.w, p.h), 
            p.rot, p.scale, c1,c1,c2,c2
        )
    end)
    --RenderText("menu", self.cardclass.name, self.x+ 40, self.y+40,0.6,"top","left")
    --RenderText("menu", self.cardclass.description, self.x+ 40, self.y+15,0.4,"top","left")
end

return M