local M = Class()
local menu = M
local namedtask = require("zinolib.namedtask")

function menu:init()
    self.coroutine = coroutine.create(self.class.co_update)
    self.curr_select = self.first_selectable
    self.children = {}
    self.selected = nil
    self.prev_selected = nil
end

function menu:frame()
    namedtask.Do(self)
    task.Do(self)
end

function menu:co_update() --this is the coroutine function that should be updating everything (it's better to use a coroutine with a while true tbh)
    while true do

        coroutine.yield()
    end
end

function menu:update()
    local C, E = coroutine.resume(self.coroutine,self)
    if(not C)then
        error(E)
    end
end

function menu:move_in() --both of these are coroutines!!

end

function menu:move_out()

end

function menu:kill()
    for id, obj in ipairs(self.children) do
        Kill(obj)
    end
end
function menu:del()
    for id, obj in ipairs(self.children) do
        Del(obj)
    end
end

function menu:select_update(new_opt)
    if self.selected == new_opt then
        return 
    end
    self.prev_selected = self.selected
    self.selected = new_opt
end

function menu:select_init()
    self.selectables = {}
    self.select_id = 1
end
function menu:select_dir(direction)
    local new_select = self.select_id + direction
    while new_select < 1 do
        new_select = new_select + (#self.selectables)
    end
    while new_select > #self.selectables do
        new_select = new_select - (#self.selectables)
    end
    if new_select == self.select_id then
        return
    end
    self.select_id = new_select
    self.class.select_update(self,self.selectables[self.select_id])
end

function menu.input_checker(name)
    while(true) do
        while(not KeyIsPressed(name))do
            coroutine.yield(false) --return false until the key is pressed
        end
        coroutine.yield(true) --return true once
        for i=0, 20 do
            coroutine.yield(false) --return false for 30 frames
            if (not KeyIsDown(name)) then
                break --if the key is not being held down, break out of for (which will make you consequently restart
            end
        end
        while (KeyIsDown(name)) do
            coroutine.yield(true) -- return true once every 3 frames
            for i=0, 2 do
                coroutine.yield(false) --return false for 3 frames
            end
        end
    end
end

return M