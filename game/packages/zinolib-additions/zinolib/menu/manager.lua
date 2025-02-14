local M = Class() --manager class
local manager = M
local namedtask = require("zinolib.namedtask")

function manager:init()
    self.menu_stack = {} --stack of menu object
end

function manager:frame()
    task.Do(self)
    if #self.menu_stack > 0 then
        local top_menu = self.menu_stack[#self.menu_stack]
        top_menu.class.update(top_menu) --update should be used to get input and change the current selected option
    end
end

function manager:push(new_menu)
    local old_menu = self.menu_stack[#self.menu_stack]
    namedtask.New(old_menu,"move",old_menu.class.move_out(old_menu,new_menu))
    namedtask.New(new_menu,"move",new_menu.class.move_in(new_menu,old_menu))


    table.insert(self.menu_stack,new_menu)
end

function manager:pop()
    local old_menu = self.menu_stack[#self.menu_stack]
    local new_menu = self.menu_stack[#self.menu_stack-1]
    namedtask.New(old_menu,"move",old_menu.class.move_out(old_menu,new_menu))


    table.remove(self.menu_stack)
end

return M