local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "gourd"
card.img = manager:LoadCardIcon("gourd","fanta")
card.name = "Ibuki Gourd"
card.description = "Increases your card get rate."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SYSTEM

function card:init(is_focus)
    bcard.init(self,is_focus)
    player.class.add_modifier(player, 100, "gourd", function(stats)
        stats.card_rate = stats.card_rate + self.context.lvl * 0.4
    end)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M