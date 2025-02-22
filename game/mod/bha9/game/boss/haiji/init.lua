local M = Class(boss)
local haiji = M

boss.record.haiji = haiji
haiji.cards = {}
haiji.name = "Haiji Senri"
haiji.difficulty = "All"
haiji.pos = lstg.Vector2(240,384)

local hpbar = require("game.ui.hpbar")

haiji.cards = {
    require("game.boss.haiji.nonspell1"),
    require("game.boss.haiji.spell1"),
    require("game.boss.haiji.nonspell2"),
    require("game.boss.haiji.spell2"),
    require("game.boss.haiji.nonspell3"),
    require("game.boss.haiji.spell3"),
    require("game.boss.haiji.nonspell4"),
    require("game.boss.haiji.spell4"),
    require("game.boss.haiji.nonspell5"),
    require("game.boss.haiji.spell5"),
    require("game.boss.haiji.nonspell6"),
    require("game.boss.haiji.spell6"),
    require("game.boss.haiji.spell7"),
    require("game.boss.haiji.spell8"),
    require("game.boss.haiji.spell9"),
}
function haiji:init(cards)
    local _cards = cards or self.class.cards
    boss.init(self, self.class.pos.x, self.class.pos.y, self.class.name, _cards, New(spellcard_background), "All")
    self.ui.drawhp = false 
    hpbar(self)
end

return M