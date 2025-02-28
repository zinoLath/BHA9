local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "tfan"
card.img = manager:LoadCardIcon("tfan","tfan")
card.name = "Tengu Fan"
card.description = "Increases your speed."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SYSTEM

function card:init(is_focus)
    bcard.init(self,is_focus)
    player.class.add_modifier(player, 100, "tfan", function(stats)
        stats.speed = stats.speed + self.context.lvl * 0.4
    end)
end

manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M