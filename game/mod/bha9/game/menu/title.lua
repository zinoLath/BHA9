local menu = require("zinolib.menu.menu")
local M = Class(menu)
local title_menu = M

function title_menu:init()
    menu.init(self)
    menu.select_init(self)
    self.check_up = coroutine.create(menu.input_checker)
    self.check_down = coroutine.create(menu.input_checker)
    local opt1 = New(self.class.option, 100,500,"nicki_minaj")
    local opt2 = New(self.class.option, 100,60,"is_the")
    local opt3 = New(self.class.option, 100,20,"queen_of_rap")
    local opt4 = New(self.class.option, 100,-20,"i think")
    local opt5 = New(self.class.option, 100,-60,"what")
    self.selectables = {opt1, opt2, opt3, opt4, opt5}
end

function title_menu:co_update()
    while true do
        local _, upval = coroutine.resume(self.check_up,"up") 
        local _, downval = coroutine.resume(self.check_down,"down")
        local is_up = upval and -1 or 0
        local is_down = downval and 1 or 0
        local direction = is_up + is_down
        menu.select_dir(self, direction)
        if direction ~= 0 then        
            print(direction)
            print(self.selected)
        end
        coroutine.yield()
    end
end

function title_menu:select_update(new_opt)
    if self.selected == new_opt then
        return 
    end
    menu.select_update(self,new_opt)
    task.NewNamed(self.selected, "move", function()
        task.MoveTo(self.selected._x+100,self.selected._y,15,MOVE_ACC_DEC)
    end)
    if IsValid(self.prev_selected) then
        task.NewNamed(self.prev_selected, "move", function()
            task.MoveTo(self.prev_selected._x,self.prev_selected._y,15,MOVE_ACC_DEC)
        end)
    end
end

title_menu.option = Class()
local option = title_menu.option
function option:init(x,y,name)
    self._x = x
    self._y = y
    self.x, self.y = self._x, self._y
    self.bound = false
    self.name = name
end
function option:frame()
    task.Do(self)
end
function option:render()
    RenderText('time', self.name, self.x, self.y,
                        0.5, 'vcenter', 'right')
end

return M