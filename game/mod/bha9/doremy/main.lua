stage_init = stage.New("init",true,true)

local main_manager = require("doremy.manager")

function stage_init:init()
    self.menuman = New(main_manager)
end
local delboss = false 
local delboss_press = false
local delboss_pre = false
function stage_init:frame()
    delboss_pre = delboss
    delboss = KEY.GetKeyState(KEY.R)
    delboss_press = delboss and not delboss_pre
    if delboss_press  then
        for index, value in ipairs(main_manager.menus) do
            package.loaded[value] = nil
        end
        package.loaded["doremy.manager"] = nil
        main_manager = require("doremy.manager")
        InitAllClass()
        Del(self.menuman)
        self.menuman = New(main_manager)
        
    end
end

function stage_init:render()
    SetViewMode("ui")
    RenderClear(0)
end