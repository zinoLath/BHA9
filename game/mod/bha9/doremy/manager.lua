local menumanager = require("zinolib.menu.manager")
local tween = require("math.tween")
local M = Class(menumanager)
local manager = M

local title = require("doremy.title")
local act = require("doremy.act")
manager.menus = {
    "doremy.title",
    "doremy.act",
    --"doremy.mroom",
    --"doremy.options",
}
function manager:init()
    self.bg = New(manager.background)
    _connect(self,self.bg)
    menumanager.init(self)
    self.title = New(title,self)
    self.act = New(act,self)
    _connect(self,self.title)
    _connect(self,self.act)
    table.insert(self.menu_stack, self.title)
end
function manager:frame()
    menumanager.frame(self)
end

manager.background = Class()
local manbg = manager.background

function manbg:init()
    self.layer = -10000
end
function manbg:frame()
end

function manbg:render()
    RenderRect("menu_bg",0,screen.width,0,screen.height)
end

return M