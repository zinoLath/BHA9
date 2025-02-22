local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "crod"
card.img = manager:LoadCardIcon("crod","crod")
card.name = "Control Rod"
card.description = "Increases your damage overall."
card.cost = 3
card.discard = false
card.type = manager.TYPE_SYSTEM

function card:init(is_focus)
    bcard.init(self,is_focus)
    player.class.add_modifier(player, 100, "crod", function(stats)
        stats.damage = stats.damage + self.context.lvl * 0.1
    end)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M