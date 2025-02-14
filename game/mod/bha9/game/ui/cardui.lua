local M = Class()
local cardui = M
local cardmanager = require("zinolib.card.manager")

function cardui:init()
    self.bound = false
    self.layer = LAYER_MENU
    self.x = 447
    self.t = 240
    self.b = 30
end
function cardui:frame()
    if KeyIsPressed("special") then
        cardmanager:scroll_hand()
    end
    if KeyIsPressed("spell") then
        cardmanager:use_card()
    end
end

function cardui:render()
    local prevview = lstg.viewmode
    SetViewMode("ui")
    local mousex,mousey = GetMousePosition()
    --Render("debug_white",mousex,mousey)
    
    for k, obj in ipairs(lstg.var.card_context.hand) do
        RenderText("time", obj, 447, self.t - k * 30, 0.5)
    end

    local id = 1
    for k,v in pairs(player.stats) do
        RenderText("time", k .. ": " .. v, 200, 300- id * 30, 0.5)
        id = id + 1
    end
end

return M