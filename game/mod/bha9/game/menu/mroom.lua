local menu = require("zinolib.menu.menu")
local M = Class(menu)
local mroom = M
local afor = require("zinolib.advancedfor")
local yabmfr = require("yabmfr")
local hadirsans = require("game.font").hadirsans
LoadImageFromFile("yass", "assets/menu/yass.png")
LoadImageFromFile("naur", "assets/menu/naur.png")
local midboss = require("game.boss.midboss")
local haiji = require("game.boss.haiji")
local scprac = require("game.stage.scprac")

local select_sq = Class()
select_sq[".render"] = true
function select_sq:init(master,pos,w1,w2,h)
    self.menu = master
    self.bound = false
    self.layer = -100
    self._pos = pos or master.selected._pos
    self.w1 = w1 or 150
    self.w2 = w2 or 128
    self.h = h or 32
    _connect(master, self, 0, true)
    self._color = Color(255,0,0,0)
end
function select_sq:frame()
    --self._pos = math.lerp(self._pos,self.menu.selected._pos,0.3)
    --self.x = 320
    self._a = 128 * self.menu._in
end
function select_sq:render()
    RenderFadingRect(self._pos, self.w1,self.w2,self.h,self.rot,self._color)
    RenderFadingRect(self._pos, self.w1,self.w2,self.h,self.rot+180,self._color)
end
mroom.spacing = Vector(0,-30)
function mroom:init(manager)
    menu.init(self)
    menu.select_init(self)
    self.manager = manager
    self.check_up = coroutine.create(menu.input_checker)
    self.check_down = coroutine.create(menu.input_checker)
    self._in = 0
    self.selectables = {
    }
    for index, value in ipairs(musicorder) do
        
        table.insert(self.selectables,New(mroom.opt,self, musicentry[value], index, "perf"))
    end
    self.selected = self.selectables[self.select_id]
    self.selected.selected = 1
    New(select_sq,self)
    New(select_sq,self,Vector(320,150),280,32,150)
    self.ysel = 0
    
end
local function Wrap(x, x_min, x_max)
    return (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min;
end

function mroom:co_update()
    while true do
        local _, upval = coroutine.resume(self.check_up,"up") 
        local _, downval = coroutine.resume(self.check_down,"down")
        local is_up = upval and -1 or 0
        local is_down = downval and 1 or 0
        local directionV = is_up + is_down
        if directionV ~= 0 then     
            self.direction = directionV
        end
        menu.select_dir(self, directionV)
        if KeyIsDown("spell") then
            self.manager.class.pop(self.manager)
        end
        if KeyIsPressed("shoot") then
            local sound, _ = EnumRes('bgm')
            for _,v in pairs(sound) do
                if GetMusicState(v)=='playing' and v ~= 'pause' then
                    PauseMusic(v)
                end
            end
            _play_music(self.selected.spell.id)
        end
        coroutine.yield()
    end
end
function mroom:move_in()
    local t = 60
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,1)
            task.Wait(1)
        end
    end)
end
function mroom:move_out()
    local t = 30
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,0)
            task.Wait(1)
        end
    end)
end
function mroom:select_update(new_opt)
    if self.selected == new_opt then
        return 
    end
    PlaySound("select00")
    menu.select_update(self,new_opt)
    local dir = self.direction
    --print(dir)

    task.NewNamed(self, "selectcardmove", function()
        local init = self.ysel
        for iter in afor(15) do
            self.ysel = iter:linear(init,(self.select_id-1) * mroom.spacing,MOVE_DECEL)
            task.Wait(1)
        end
    end)
    for index, value in ipairs(self.selectables) do
        value.selected = 0
    end
    self.selected.selected = 1
end

local mopt = Class()
mopt[".render"] = true
mroom.opt = mopt
function mopt:init(menu,spell,id,func)
    local name = spell.name
    self.spell = spell
    self.menu = menu
    self.name = yabmfr(hadirsans,string.len(name))
    self.name:PushString(name)
    self.bound = false
    self.id = id
    self.t = (id-1)/5
    local ylvl = 350
    self._pos = Vector(100,ylvl) + mroom.spacing * (self.id-1)
    _connect(menu, self)
    self.selected = 0
    self.selalpha = 0
    self.func = func
    self.desc = nil
end
function mopt:frame()
    local ylvl = 350
    self._pos = Vector(50,ylvl) + mroom.spacing * (self.id-1) - self.menu.ysel
    local yalpha = math.clamp((self.y-270)/80,0,1)
    if self.y > ylvl then
        yalpha = 1-math.clamp((self.y-ylvl)/45,0,1)
    end
    
    self.selalpha = math.lerp(self.selalpha,(self.selected),0.2)
    self._a = 255 * self.menu._in * math.lerp(0.5,1,self.selalpha) * yalpha
    if (not IsValid(self.desc) or self.dying == true) and (self.selected == 1 and self.menu._in == 1) then
        self.desc = New(mroom.desc,self.spell.comment,self.menu)
    end
    if (IsValid(self.desc) or self.dying == false) and (self.selected == 0 or self.menu._in ~= 1) then
        Kill(self.desc)
    end
end

function mopt:render()
    if self._a == 0 then
        return 
    end
    self.name:Clean()
    
    self.name:Transform(self._pos + Vector(0,10),0,0.2)
    local distance = Vector(6,-3)
    local alpha = 0.2
    local c1 = math.lerpcolor(ColorS("FFC3BFFF"),ColorS("FFFFFFFF"),self.selalpha)
    local c2 = math.lerpcolor(ColorS("FF8C87CE"),ColorS("FFC3BFFF"),self.selalpha)
    c1.a = self._a
    c2.a = self._a
    self.name:Apply(function (font,p)
        p.rot = sin(self.timer*5+p.extra3*30)*5 * self.selalpha
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
        lstg.RenderTextureRect(
            font.font.texture, "", 
            p.pos, 
            RectWH(p.u, p.v, p.w, p.h), 
            p.rot, p.scale, c1,c1,c2,c2
        )
    end)
end

local desc = Class()
mroom.desc = desc
desc[".render"] = true

function desc:init(txt,menu)
    self.txt = yabmfr(hadirsans,string.len(txt))
    self.txt:PushString(txt)
    self.selalpha = 1
    self.bound = false
    self._pos = Vector(75,200)
    _connect(menu, self)
    self.dying = false
    self._a = 0
    print("a")
    task.New(self, function()
        ex.SmoothSetValueTo("_a",255,15,MOVE_DECEL)
    end)
end
function desc:frame()
    task.Do(self)
end
function desc:kill()
    PreserveObject(self)
    self.dying = true 
    task.New(self, function()
        ex.SmoothSetValueTo("_a",0,15,MOVE_DECEL)
        Del(self)
    end)
end
function desc:render()

    if self._a == 0 then
        return 
    end
    self.txt:Clean()
    
    self.txt:Transform(self._pos + Vector(0,10),0,0.15)
    local distance = Vector(6,-3)
    local alpha = 0.2
    local c1 = math.lerpcolor(ColorS("FFC3BFFF"),ColorS("FFFFFFFF"),self.selalpha)
    local c2 = math.lerpcolor(ColorS("FF8C87CE"),ColorS("FFC3BFFF"),self.selalpha)
    c1.a = self._a
    c2.a = self._a
    self.txt:Apply(function (font,p)
        p.rot = sin(self.timer*5+p.extra3*30)*3 * self.selalpha
        for iter in afor(2) do
            do break end
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
        lstg.RenderTextureRect(
            font.font.texture, "", 
            p.pos, 
            RectWH(p.u, p.v, p.w, p.h), 
            p.rot, p.scale, c1,c1,c2,c2
        )
    end)
end

return M