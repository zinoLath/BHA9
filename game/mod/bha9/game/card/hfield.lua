local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
card.id = "hfield"
card.img = manager:LoadCardIcon("hfield","hfield")
card.name = "Heat Field"
card.description = "Deals damage around you regardless of shot type."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SYSTEM
card.damage_delay = 4
card.damage_factor = 0.2
card.dmgtype = "item"

function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)
    self.rad = 128
    self.fire = 0
    self.layer = LAYER_PLAYER_BULLET+1.99
    self.killflag = true
    task.NewNamed(player,"hfield", function()
        while true do
            while player.fire > 0 do
                local maxdmg = ({1.4,1.6,1.8,2})[self.context.lvl]
                self.rad = ({128,160,200,256})[self.context.lvl]
                self.fire = math.lerp(self.fire,1,0.2)
                for i,o in ObjList(GROUP_ENEMY) do
                    if Dist(player,o) < self.rad then
                        self.dmg = maxdmg*(1-Dist(player,o)/self.rad)
                        o.class.colli(o,self)
                    end
                end
                for i,o in ObjList(GROUP_NONTJT) do
                    if Dist(player,o) < self.rad then
                        self.dmg = maxdmg*(1-Dist(player,o)/self.rad)
                        o.class.colli(o,self)
                    end
                end
                task.Wait(1)
            end
            self.fire = math.lerp(self.fire,0,0.2)
            task.Wait(1)
        end
    end)
end
function card:render()
    local alpha = (128 + 32 * nsin(self.timer)) * self.fire
    local green = 64 * nsin(self.timer *3 )
    SetImageState('white', 'mul+add',
            Color(alpha, 255, green, 0),
            Color(alpha, 255, green, 0),
            Color(alpha, 0, 0, 0),
            Color(alpha, 0, 0, 0)
    )
    rendercircimg("white",player.x, player.y, self.rad, 64)
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M