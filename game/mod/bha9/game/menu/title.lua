local menu = require("zinolib.menu.menu")
local M = Class(menu)
local title_menu = M
LoadTexture("title_options","assets/menu/title_options.png")
local prefix = "to:"
local suffix1 = "sel"
local suffix2 = "unsel"
local w,h = 384,128
local afor = require("zinolib.advancedfor")
local tween = require("math.tween")
LoadImageFromFile("logo_menu_thing", "assets/menu/logo.png")
LoadImage(prefix.."start"..suffix1,"title_options",0,h*0,w,h)
LoadImage(prefix.."deck"..suffix1,"title_options",0,h*1,w,h)
LoadImage(prefix.."option"..suffix1,"title_options",0,h*2,w,h)
LoadImage(prefix.."spprac"..suffix1,"title_options",0,h*3,w,h)
LoadImage(prefix.."quit"..suffix1,"title_options",0,h*4,w,h)
LoadImage(prefix.."mroom"..suffix1,"title_options",0,h*5,w,h)
LoadImage(prefix.."replay"..suffix1,"title_options",0,h*6,w,h)

LoadImage(prefix.."start"..suffix2,"title_options",w,h*0,w,h)
LoadImage(prefix.."deck"..suffix2,"title_options",w,h*1,w,h)
LoadImage(prefix.."option"..suffix2,"title_options",w,h*2,w,h)
LoadImage(prefix.."spprac"..suffix2,"title_options",w,h*3,w,h)
LoadImage(prefix.."quit"..suffix2,"title_options",w,h*4,w,h)
LoadImage(prefix.."mroom"..suffix2,"title_options",w,h*5,w,h)
LoadImage(prefix.."replay"..suffix2,"title_options",w,h*6,w,h)

local select_sq = Class()
select_sq[".render"] = true
function select_sq:init(master)
    self.menu = master
    self.bound = false
    self.layer = -100
    self._pos = math.lerp(title_menu.option.p1,title_menu.option.p2,0.5)
    _connect(master, self, 0, true)
    self._color = Color(255,0,0,0)
end
function select_sq:frame()
    self._a = 128 * self.menu._in
end
function select_sq:render()
    RenderFadingRect(self._pos + Vector(-self.x,8), 200,128,24,0,self._color)
end

function title_menu:init(manager)
    menu.init(self)
    menu.select_init(self)
    self.manager = manager
    self.check_up = coroutine.create(menu.input_checker)
    self.check_down = coroutine.create(menu.input_checker)
    self.direction = 1
    local opttable = {
        "start",
        "spprac",
        "deck",
        "mroom",
        "replay",
        "option",
        "quit",
    }
    for index, value in ipairs(opttable) do
        local t = (index-1)/7-0.5
        table.insert(self.selectables, New(title_menu.option,value,t,self))
    end
    self.selectables[self.select_id].selected = 1
    for index, value in ipairs(self.selectables) do
        table.insert(self.children,value)
    end
    self.logo = New(title_menu.logo)
    table.insert(self.children,self.logo)
    self.selected = self.selectables[self.select_id]
    self._in = 1
    New(select_sq,self)
end

function title_menu:co_update()
    local ok, prevok = KeyIsDown("shoot"),KeyIsDown("shoot")
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
        if ok and (not prevok) then
            if title_menu.enterfunc[self.selected.name] then
                title_menu.enterfunc[self.selected.name](self)
            end
        end
        prevok = ok
        ok = KeyIsDown("shoot")
        coroutine.yield()
    end
end

function title_menu:select_update(new_opt)
    if self.selected == new_opt then
        return 
    end
    menu.select_update(self,new_opt)
    local dir = self.direction
    --print(dir)

    local dist = -(dir)/7
    for index, obj in ipairs(self.selectables) do
        obj.selected = 0
        task.New(obj, function ()
            ex.SmoothSetValueToEx("selpos", obj.selpos+dist,15,MOVE_DECEL)
        end)
    end
    self.selected.selected = 1
end

function title_menu:move_in()
    local t = 60
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,1)
            task.Wait(1)
        end
    end)

    task.NewNamed(self.logo,"move", function()
        local initx = self.logo._x
        local tgtx = 190
        local initrot = self.logo._rot
        local inita = self.logo._a
        for iter in afor(t) do
            local t = iter:linear(0,1,MOVE_ACC_DEC)
            self.logo._a = math.lerp(inita,255,t)
            self.logo._x = math.lerp(initx,tgtx,t)
            self.logo._rot = math.lerp(initrot,0,t)
            task.Wait(1)
        end
    end)

end
function title_menu:move_out()
    local t = 60
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,0)
            task.Wait(1)
        end
    end)
    task.NewNamed(self.logo,"move", function()
        local initx = self.logo._x
        local tgtx = 100
        local initrot = self.logo._rot
        local inita = self.logo._a
        for iter in afor(t) do
            local t = iter:linear(0,1,MOVE_ACC_DEC)
            self.logo._a = math.lerp(inita,0,t)
            self.logo._x = math.lerp(initx,tgtx,t)
            self.logo._rot = math.lerp(initrot,10,t)
            task.Wait(1)
        end
    end)
end

title_menu.option = Class()
local option = title_menu.option
option[".render"] = true 
option.p1 = Vector(50,220)
option.p2 = Vector(200,40)
option.off_set = Vector(-30,0)
function option:init(name,spos,_menu)
    self.bound = false
    self.name = name
    self.selpos = spos
    self.selected = 0
    local scale = 0.5
    self.hscale, self.vscale = scale,scale
    self.menu = _menu
end
function option:frame()
    task.Do(self)
    while self.selpos > 1 do
        self.selpos = self.selpos - 1
    end
    while self.selpos < 0 do
        self.selpos = self.selpos + 1
    end
    local vec = math.lerp(option.p1,option.p2,self.selpos) 
                + option.off_set * tween.cubicInOut(1-self.menu._in)
    self.x, self.y = vec.x, vec.y
end
function option:render()
    if self.selected == 1 then
        self.img = prefix..self.name..suffix1
    else
        self.img = prefix..self.name..suffix2
    end
    self._a = (0.5-math.abs(self.selpos-0.5))*255*2*tween.cubicInOut(self.menu._in)
    DefaultRenderFunc(self)
end

local logo = Class()
title_menu.logo = logo
function logo:init()
    --self.layer = LAYER_UI
    self._x, self._y = 190, 360
    self.img = "logo_menu_thing"
    self.bound = false
    self.x, self.y = self._x, self._y
    local scale = 0.6
    self.hscale, self.vscale = scale,scale
    self.dist = 32
    self._a = 255
    self._rot = 0
end
function logo:frame()
    local spd = 0.4
    self.y = self._y + 2 * sin(self.timer*spd)
    self.x = self._x
    self.dist = math.lerp(16,32,nsin(self.timer*spd))/4
    self.rad = math.lerp(4,6,nsin(self.timer*spd))
    self.rot = self._rot + math.lerp(-1,1,nsin(self.timer*spd/5))
    task.Do(self)
end
function logo:render()
    SetImageState(self.img, "", Color(8*self._a/255,0,0,0))
    local vec = math.vecfromobj(self) + math.polar(self.dist,-45)
    for iter in afor(32) do
        local pos = vec + math.polar(self.rad,iter:circle())
        Render(self.img,pos.x,pos.y,self.rot,self.hscale,self.vscale)
    end
    SetImageState(self.img, "hue+alpha", BulletColor(16*sin(self.timer),nil,self._a))
    Render(self.img,self.x,self.y,self.rot,self.hscale,self.vscale)
end


title_menu.enterfunc = {}
local efunc = title_menu.enterfunc

function efunc:deck()
    self.manager.class.push(self.manager,self.manager.deck)
end
function efunc:start()
    self.manager.class.push(self.manager,self.manager.difficulty)
end
function efunc:option()
    self.manager.class.push(self.manager,self.manager.option)
end
function efunc:spprac()
    self.manager.class.push(self.manager,self.manager.spprac)
end
function efunc:quit()
    stage.QuitGame()
end



return M