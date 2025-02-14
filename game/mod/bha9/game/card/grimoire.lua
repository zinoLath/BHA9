local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "grimoire"
card.img = "img_void"
card.name = "Grimoire"
card.description = "Increases your spell rate."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SYSTEM

function card:init(is_focus)
    bcard.init(self,is_focus)
    player.class.add_modifier(player, 100, "grimoire", function(stats)
        stats.spell_rate = stats.spell_rate - self.context.lvl * 0.1
    end)
end
manager.cardlist[card.id] = M 
return M