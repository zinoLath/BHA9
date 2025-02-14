local menumanager = require("zinolib.menu.manager")
local M = Class(menumanager)
local manager = M


local title = require("game.menu.title")
function manager:init()
    menumanager.init(self)
    table.insert(self.menu_stack, New(title))
end
function manager:frame()
    menumanager.frame(self)
end

return M