local menu = require("zinolib.menu.menu")
local M = Class(menu)
local option = M
local afor = require("zinolib.advancedfor")
local yabmfr = require("yabmfr")
local hadirsans = require("game.font").hadirsans
LoadImageFromFile("yass", "assets/menu/yass.png")
LoadImageFromFile("naur", "assets/menu/naur.png")

local select_sq = Class()
select_sq[".render"] = true
function select_sq:init(master)
    self.menu = master
    self.bound = false
    self.layer = -100
    self._pos = master.selected._pos
    _connect(master, self, 0, true)
    self._color = Color(255,0,0,0)
end
function select_sq:frame()
    self._pos = math.lerp(self._pos,self.menu.selected._pos,0.3)
    self.x = 320
    self._a = 128 * self.menu._in
end
function select_sq:render()
    RenderFadingRect(self._pos, 150,128,32,0,self._color)
    RenderFadingRect(self._pos, 150,128,32,180,self._color)
end

function option:init(manager)
    menu.init(self)
    menu.select_init(self)
    self.manager = manager
    self.check_up = coroutine.create(menu.input_checker)
    self.check_down = coroutine.create(menu.input_checker)
    self.check_right = coroutine.create(menu.input_checker)
    self.check_left = coroutine.create(menu.input_checker)
    self._in = 0
    self.selectables = {
        New(option.opt,self, "Performance Mode", 1, "perf"),
        New(option.opt,self, "SFX Volume", 2, "sfx"),
        New(option.opt,self, "BGM Volume", 3, "bgm"),
        New(option.opt,self, "Resolution", 4, "res"),
        New(option.opt,self, "Fullscreen", 5, "fs"),
        New(option.opt,self, "Vsync", 6, "vsync"),
        New(option.opt,self, "Background Brightness", 7, "bg"),
        New(option.opt,self, "Judge Mode", 8, "judge"),
        New(option.opt,self, "Go Back", 9, "back"),
    }
    self.selected = self.selectables[self.select_id]
    self.selected.selected = 1
    New(select_sq,self)
    local ssetting = self.setting
    local res = self.setting.res.res
    ssetting.res.state = 0
    for k,v in ipairs(res) do
        if v.x == setting.resx and v.y == setting.resy then
            ssetting.res.state = k-1
            break
        end
    end
    ssetting.bgm.state = setting.bgmvolume/10
    ssetting.sfx.state = setting.sevolume/10
    ssetting.fs.state = setting.windowed and 0 or 1
    ssetting.vsync.state = setting.vsync and 1 or 0
    ssetting.judge.state = setting.judge and 1 or 0
    ssetting.perf.state = setting.perf and 1 or 0
    
end
local function Wrap(x, x_min, x_max)
    return (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min;
end

function option:co_update()
    local ok, prevok = KeyIsDown("shoot"),KeyIsDown("shoot")
    while true do
        local _, upval = coroutine.resume(self.check_up,"up") 
        local _, downval = coroutine.resume(self.check_down,"down")
        local is_up = upval and -1 or 0
        local is_down = downval and 1 or 0
        local directionV = is_up + is_down
        local _, leftval = coroutine.resume(self.check_right,"left") 
        local _, rightval = coroutine.resume(self.check_left,"right")
        local is_left = leftval and -1 or 0
        local is_right = rightval and 1 or 0
        local isok = ok and (not prevok)
        prevok = ok
        ok = KeyIsDown("shoot")
        local directionH = is_left + is_right
        if directionV ~= 0 then     
            self.direction = directionV
        end
        if directionH ~= 0 then
            print(directionH)
            self.selected.state = Wrap(self.selected.state+directionH, 0, self.selected.statemax+1)
        end
        menu.select_dir(self, directionV)
        if isok then
            PlaySound("ok00")
            print(PrintTable(self.setting))
            setting.bgmvolume = self.setting.bgm.state*10
            setting.sevolume = self.setting.sfx.state*10
            local res = self.setting.res.res[self.setting.res.state+1]
            setting.resx = res.x
            setting.resy = res.y
            setting.windowed = self.setting.fs.state == 0
            setting.vsync = self.setting.vsync.state == 1
            setting.judge = self.setting.judge.state == 1
            setting.perf = self.setting.perf.state == 1
            local ret = self.selected:confirm()
            saveConfigure()
            lstg.SetWindowed(setting.windowed)
            lstg.SetResolution(setting.resx,setting.resy)
            lstg.SetVsync(setting.vsync)
            lstg.SetSEVolume(setting.sevolume/100)
            lstg.SetBGMVolume(setting.bgmvolume/100)
            lstg.VideoModeWindowed(setting.resx, setting.resy, setting.vsync,0)
            ResetScreen2()
            if ret == "quit" then
                self.manager.class.pop(self.manager)
            end
        end
        if KeyIsPressed("spell") then
            self.manager.class.pop(self.manager)
        end
        coroutine.yield()
    end
end
function option:move_in()
    local t = 60
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,1)
            task.Wait(1)
        end
    end)
end
function option:move_out()
    local t = 30
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,0)
            task.Wait(1)
        end
    end)
end
function option:select_update(new_opt)
    if self.selected == new_opt then
        return 
    end
    PlaySound("select00")
    menu.select_update(self,new_opt)
    local dir = self.direction
    --print(dir)

    task.NewNamed(self, "selectcardmove", function()
        --local init = self.ysel
        for iter in afor(15) do
            --self.ysel = iter:linear(init,(self.select_id-1) * option.spacing,MOVE_DECEL)
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
option.opt = mopt
function mopt:init(menu,name,id,func)
    self.menu = menu
    menu.setting = menu.setting or {}
    menu.setting[func] = self
    self.name = yabmfr(hadirsans,string.len(name))
    self.name:PushString(name)
    self.bound = false
    self.id = id
    self.t = (id-1)/5
    self._pos = math.lerp(Vector(320,450),Vector(320,350),self.t)
    _connect(menu, self)
    self.selected = 0
    self.selalpha = 0
    self.func = func
    self.state = 0
    local statemax = {
        perf = 1,
        sfx = 10,
        bgm = 10,
        res = 4,
        fs = 1,
        vsync = 1,
        bg = 10,
        judge = 1,
        back = 0,
    }
    self.statemax = statemax[func]
    self.res = {
        Vector(640,480),
        Vector(800,600),
        Vector(1024,768),
        Vector(1280,960),
        Vector(1600,1200),
    }
    if func == "res" then
        self.statemax = #self.res-1
    end
    self.respool = {}
    for index, value in ipairs(self.res) do
        local str = string.format("%dx%d",value.x,value.y)
        self.respool[index] = yabmfr(hadirsans,string.len(str))
        self.respool[index]:PushString(str)
    end
    self.name:Clean()
    local namerect = Rect(_infinite,-_infinite,-_infinite,_infinite)
    self.name:Apply(function (font, p)
        namerect.l = math.min(namerect.l,p.x - p.w/2)
        namerect.r = math.max(namerect.r,p.x + p.w/2)
        namerect.t = math.max(namerect.t,p.y + p.h/2)
        namerect.b = math.min(namerect.b,p.y - p.h/2)
        p.rot = sin(self.timer*3+p.extra3*30)*2
    end)
    print(namerect)
    self.confirm = function()

    end
    if func == "back" then
        self.confirm = function(self)
            return "quit"
        end
    end

end
function mopt:frame()
    self._pos = math.lerp(Vector(420,350),Vector(420,170),self.t) + Vector(-50,0) * MOVE_DECEL(self.menu._in)
    
    self.selalpha = math.lerp(self.selalpha,(self.selected),0.2)
    self._a = 255 * self.menu._in * math.lerp(0.5,1,self.selalpha)
end

function mopt:render()
    if self._a == 0 then
        return 
    end
    self.name:Clean()
    local namerect = Rect(_infinite,-_infinite,-_infinite,_infinite)
    self.name:Apply(function (font, p)
        namerect.l = math.min(namerect.l,p.x - p.w/2)
        namerect.r = math.max(namerect.r,p.x + p.w/2)
        namerect.t = math.max(namerect.t,p.y + p.h/2)
        namerect.b = math.min(namerect.b,p.y - p.h/2)
        p.rot = sin(self.timer*3+p.extra3*30)*2
    end)
    
    self.name:Transform(self._pos - Vector(100+namerect.width*0.2,-7),0,0.2)
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
    local pos = Vector(self.x + 50, self.y)
    if self.statemax == 0 then
        return
    end
    if self.statemax == 1 then
        local img = "naur"
        pos = pos - Vector(-10,0)
        if self.state == 0 then
            img = "yass"
        else
            img = "naur"
        end
        for iter in afor(8) do
            local off = math.polar(4,iter:circle()) + distance
            local pos1 = pos + off
            SetImageState(img,"",Color(self._a*alpha,0,0,0))
            Render(img, pos.x, pos.y,0,0.2)
            local off = math.polar(2,iter:circle())
            local pos1 = pos + off
            SetImageState(img,"",Color(self._a,0,0,0))
            Render(img, pos1.x, pos1.y,0,0.2)
        end
        SetImageState(img,"",Color(self._a,255,255,255))
        local pos = Vector(pos.x, pos.y)
        Render(img, pos.x, pos.y,0,0.2)
    elseif self.statemax == 10 then
        for iter in afor(8) do
            local off = math.polar(4,iter:circle()) + distance
            local pos1 = pos + off
            RenderFadingRect(pos1,10*10,0,16,0,Color(self._a*alpha,0,0,0))
            local off = math.polar(2,iter:circle())
            local pos1 = pos + off
            RenderFadingRect(pos1,10*10,0,16,0,Color(self._a,0,0,0))
        end
        RenderFadingRect(pos,10*10,0,16,0,Color(self._a*0.4,255,255,255))
        RenderFadingRect(pos,10*self.state,0,16,0,Color(self._a,255,255,255))
    else
        local pool = self.respool[self.state+1]
        pool:Clean()
        local namerect = Rect(_infinite,-_infinite,-_infinite,_infinite)
        pool:Apply(function (font, p)
            namerect.l = math.min(namerect.l,p.x - p.w/2)
            namerect.r = math.max(namerect.r,p.x + p.w/2)
            namerect.t = math.max(namerect.t,p.y + p.h/2)
            namerect.b = math.min(namerect.b,p.y - p.h/2)
            p.rot = sin(self.timer*3+p.extra3*30)*2
        end)
        pool:Transform(pos - Vector(0,-7),0,0.2)
        pool:Apply(function (font,p)
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
end


return M