stage_init = stage.New("init",true,true)

local main_manager = require("game.menu.manager")

function stage_init:init()
    New(main_manager)
end
function stage_init:render()
    SetViewMode("ui")
    RenderClear(0)
end