local menu = require("zinolib.menu.menu")
local M = Class(menu)
local title_menu = M
LoadTexture("title_options","assets/menu/title_options.png")
LoadImageFromFile("doremygamelogo","doremy/logo.png",true)
local w,h = 384,128
local afor = require("zinolib.advancedfor")
local tween = require("math.tween")
require("math.additions")

function title_menu:init(manager)
    menu.init(self)
    menu.select_init(self)
    self.manager = manager
    self.check_up = coroutine.create(menu.input_checker)
    self.check_down = coroutine.create(menu.input_checker)
    self.direction = 1
    local completetab = {
        "start",
        "startex",
        "cards",
        "mroom",
        "manual",
        "option",
        "quit",
    }
    local opttable = {
        "start",
        "mroom",
        "manual",
        "option",
        "quit",
    }
    for index, value in ipairs(completetab) do
        local t = (index-1)/7
        local obj = New(title_menu.option,value,t,self)
        obj.invalid = true
        for k,v in ipairs(opttable) do
            if value == v then
                obj.invalid = false
                table.insert(self.selectables, obj)
                break
            end
        end
    end
    self.selectables[self.select_id].selected = 1
    for index, value in ipairs(self.selectables) do
        table.insert(self.children,value)
    end
    self.logo = New(title_menu.logo)
    table.insert(self.children,self.logo)
    self.selected = self.selectables[self.select_id]
    self._in = 1
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
            self.manager.class.push(self.manager,self.manager.act)
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

    for index, value in ipairs(self.selectables) do
        value.selected = 0
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
        local inita = self.logo._a
        for iter in afor(t) do
            local t = iter:linear(0,1,MOVE_ACC_DEC)
            self.logo._a = math.lerp(inita,255,t)
            self.logo._x = math.lerp(initx,tgtx,t)
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
        local inita = self.logo._a
        for iter in afor(t) do
            local t = iter:linear(0,1,MOVE_ACC_DEC)
            self.logo._a = math.lerp(inita,0,t)
            self.logo._x = math.lerp(initx,tgtx,t)
            task.Wait(1)
        end
    end)
end

title_menu.option = Class()
local option = title_menu.option
option[".render"] = true 
option.p1 = Vector(600,150)
option.p2 = Vector(560,40)
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
    self._a = (192 + self.selected*63)*tween.cubicInOut(self.menu._in)
    if self.invalid then
        self._a = (128)*tween.cubicInOut(self.menu._in)
    end
    SetFontState("menu",self._blend,self._color)
    RenderText("menu",self.name,self.x,self.y,self.hscale,"right")
end

local logo = Class()
title_menu.logo = logo
function logo:init()
    --self.layer = LAYER_UI
    self._x, self._y = 470, 360
    self.img = "doremygamelogo"
    self.bound = false
    self.x, self.y = self._x, self._y
    local scale = 0.2
    self.hscale, self.vscale = scale,scale
    self.dist = 32
    self._a = 255
    self.rot = -15
end
function logo:frame()
    local spd = 0.4
    self.y = self._y + 2 * sin(self.timer*spd)
    self.x = self._x
    self.dist = math.lerp(16,32,nsin(self.timer*spd))/4
    self.rad = math.lerp(4,6,nsin(self.timer*spd))
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

return M