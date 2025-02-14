local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "gourd"
card.img = "img_void"
card.name = "Ibuki Gourd"
card.description = "Increases your card get rate."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SYSTEM

function card:init(is_focus)
    bcard.init(self,is_focus)
    player.class.add_modifier(player, 100, "gourd", function(stats)
        stats.card_rate = stats.card_rate + self.context.lvl * 0.1
    end)
end
manager.cardlist[card.id] = M 
return M