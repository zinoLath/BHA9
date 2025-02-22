local M = Class()
local cardui = M
local cardmanager = require("zinolib.card.manager")
local afor = require("zinolib.advancedfor")

function cardui:init()
    self.bound = false
    self.layer = LAYER_UI_TOP+100
    self.x = 447
    self.t = 240
    self.b = 30

end
function cardui:frame()
    if KeyIsPressed("special") then
        cardmanager:scroll_hand()
    end
    if KeyIsPressed("spell") then
        cardmanager:get_card()
    end
    if KeyIsPressed("shoot") then
        cardmanager:use_card()
    end
end

cardui.p1 = Vector(lstg.world.scrr+64,200)
cardui.p2 = Vector(lstg.world.scrr+64+100,100)
function cardui:render()
    local prevview = lstg.viewmode
    SetViewMode("ui")
    for k, obj in ipairs(lstg.var.card_context.hand) do
        RenderText("time",obj, player.x,player.y, 0.5)
    end

    local id = 1
    for k,v in pairs(player.stats) do
        RenderText("time", k .. ": " .. v, 200, 300- id * 30, 0.5)
        id = id + 1
    end
end

return M