local menu = require("zinolib.menu.menu")
local M = Class(menu)
local difficulty = M
local afor = require("zinolib.advancedfor")
LoadImageFromFile("diff_select", "assets/menu/mdiff.png")

function difficulty:init(manager)
    menu.init(self)
    menu.select_init(self)
    self.manager = manager
    self._in = 0
    self.button = New(difficulty.button,self)
    _connect(self, self.button)
end

function difficulty:co_update()
    while true do
        if KeyIsDown("spell") then
            self.manager.class.pop(self.manager)
        end
        coroutine.yield()
    end
end
function difficulty:move_in()
    local t = 60
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,1)
            task.Wait(1)
        end
    end)
end
function difficulty:move_out()
    local t = 30
    task.NewNamed(self,"move", function()
        local initin = self._in
        for iter in afor(t*1.2) do
            self._in = iter:linear(initin,0)
            task.Wait(1)
        end
    end)
end

local button = Class()
difficulty.button = button
button[".render"] = true
function button:init(_menu)
    self.x, self.y = screen.width/2, screen.height/2
    self.menu = _menu
    self.bound = false
    self.img = "diff_select"
end
function button:frame()
    self._a = 255 * (self.menu._in)
end
function button:render()
    local _rot = self.rot + 3 * sin(self.timer)
    local col = Color(self._a*0.7,0,0,0)
    RenderFadingRect(self._pos, 96,96,110,_rot,col)
    RenderFadingRect(self._pos, 96,96,110,180+_rot,col)
    DefaultRenderFunc(self)
end


return M