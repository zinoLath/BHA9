local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
local afor = require("zinolib.advancedfor")
card.id = "mspark"
card.img = manager:LoadCardIcon("mspark","mspark")
card.name = "Magic Shortspark"
card.description = "Your spell now hits a wide area in front of you."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SPELL
CopyImage("msparkthing","white")
SetImageScale("msparkthing",1/16)
card.obj = Class()
local bomb = card.obj
bomb[".render"] = true
function bomb:init(player,size)
    self._pos = player._pos
    self.l = 500
    self.y = self.y + self.l/2
    self.size_mul = player.stats.spell_size
    self.dmg_mul = player.stats.spell_damage
    self.sizemax = size * self.size_mul
    self.size = 0
    self.rect = false 
    self.group = GROUP_SPELL
    self.layer = LAYER_PLAYER+100
    self.dmg = 1000
    self.bound = false
    self.img = "msparkthing"
    self._color = ColorS("FFFFCE2C")
    self._blend = "mul+sub"
    task.New(self, function()
        ex.SmoothSetValueTo("size",self.sizemax,10,MOVE_DECEL,nil,0,MODE_SET)
    end)
end

function bomb:frame()
    task.Do(self)
    self._pos = player._pos
    self.y = self.y + self.l/2 - 64
    self.vscale = self.l
    self.hscale = self.size
    self.a = self.hscale
    self.b = self.vscale

end

function bomb:colli(other)
    if other.group == GROUP_ENEMY_BULLET and other.timer % 2 == 1 then
        other.pause = 1
    end
end

function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)

    function player.spell(pl)
        pl.collecttimer = 60
        pl.nextspell = ({300,260,220,200})[self.context.lvl] * pl.stats.spell_rate
        pl.death = 0
        local timeinvul = ({60,75,90,105})[self.context.lvl]
        pl.protect = math.clamp(timeinvul,0,pl.protect)
        task.New(self, function()
            local bomb = New(card.obj,pl,({30,60,90,120})[self.context.lvl])
            task.New(bomb, function()
                task.Wait(({60,60,70,90})[self.context.lvl])
                ex.SmoothSetValueTo("size",0,10,MOVE_DECEL,nil,0,MODE_SET)
                Del(bomb)
            end)
        end)
    end
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M