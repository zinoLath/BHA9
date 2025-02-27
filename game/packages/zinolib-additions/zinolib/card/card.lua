local M = Class()
local manager = require("zinolib.card.manager")
local card = M
card.id = "DEFAULT_CARD"
card.img = "img_void"
card.name = "DEFAULT CARD"
card.description = "DEFAULT CARD DESCRIPTION"
card.cost = 1
card.discard = false
card.type = manager.TYPE_SKILL

function card:init(is_focus)
    if is_focus == nil then
        is_focus = player.slow
    end
    self.group = GROUP_GHOST
    if not lstg.var.card_context.cards[self.class.id] then 
        self.context = {
            is_focus = is_focus,
            lvl = 1,
            enabled = true
        }
        lstg.var.card_context.cards[self.class.id] = self.context
    else
        self.context = lstg.var.card_context.cards[self.class.id]
    end
    self.class.get(self)
    if player.cards == nil then
        player.cards = {}
    end
    player.cards[self.class.id] = self
end
function card:kill()
    self.class.throw(self)
end

function card:get()

end

function card:lvlup()

end

function card:frame()
    task.Do(self)
end

function card:circle()

end

function card:throw()

end

function card:debug_lvl_up(id)
    if is_debug == true or true then
        task.New(player,function()
            local prev_val = false
            local val = false
            while true do
                val = GetKeyState(KEY.S)
                if val and not prev_val then
                    manager:use_card(id)
                end
                prev_val = val
                task.Wait(1)
            end
        end)
    end
end

return M