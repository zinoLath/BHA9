local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "clock"
card.img = manager:LoadCardIcon("mirror","mirror")
card.name = "Time Dilation"
card.description = "Increases your shot charge rate."
card.cost = 2
card.discard = false
card.type = manager.TYPE_SYSTEM

function card:init(is_focus)
    bcard.init(self,is_focus)
    player.class.add_modifier(player, 100, "clock", function(stats)
        stats.shot_rate = stats.shot_rate - self.context.lvl * 0.2
    end)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M