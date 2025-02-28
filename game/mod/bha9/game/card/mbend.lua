local bcard = require("zinolib.card.card")
local M = Class(bcard)
local card = M
local manager = require("zinolib.card.manager")
local afor = require("zinolib.advancedfor")
card.id = "mbend"
card.img = manager:LoadCardIcon("mbend","mbend")
card.name = "Mind Bending"
card.description = "Your spell now hits a wide area around you."
card.cost = 1
card.discard = false
card.type = manager.TYPE_SPELL

card.obj = Class()
local bomb = card.obj
function bomb:init(player,x,y,size)
    self.x, self.y = x,y
    self.size_mul = player.stats.spell_size
    self.dmg_mul = player.stats.spell_damage
    self.sizemax = size * self.size_mul
    self.size = 0
    self.rect = false 
    self.group = GROUP_SPELL
    self.layer = LAYER_PLAYER_BULLET-50
    self.dmg = 1000
    self.bound = falser
    task.New(self, function()
        ex.SmoothSetValueTo("size",self.sizemax,10,MOVE_DECEL,nil,0,MODE_SET)
    end)
end

function bomb:frame()
    task.Do(self)
    self.a = self.size
    self.b = self.size
end

function bomb:colli(other)
    if other.group == GROUP_ENEMY_BULLET and other.timer % 2 == 1 then
        other.pause = 1
    end
end

function bomb:render()
    SetImageState('white', 'mul+sub',
            Color(255, 0, 0, 0),
            Color(255, 255, 0, 0),
            Color(255, 255, 0, 0),
            Color(255, 255, 0, 0)
    )
    rendercircimg("white",self.x, self.y, self.size, 60)
end


function card:init(is_focus)
    bcard.init(self,is_focus)
    bcard.debug_lvl_up(self,card.id)

    function player.spell(pl)
        pl.collecttimer = 60
        pl.nextspell = ({360,300,240,180})[self.context.lvl] * pl.stats.spell_rate
        pl.death = 0
        local timeinvul = ({60,75,90,105})[self.context.lvl]
        pl.protect = math.clamp(timeinvul,0,pl.protect)
        task.New(self, function()
            for iter in afor(16) do
                local vec = pl._pos + math.polar(({60,120,160,220})[self.context.lvl],iter:circle())
                task.New(pl, function()
                    task.Wait(ran:Int(0,30))
                    local bomb = New(card.obj,pl,vec.x,vec.y,({30,45,60,90})[self.context.lvl])
                    task.New(bomb, function()
                        task.Wait(200)
                        ex.SmoothSetValueTo("size",0,10,MOVE_DECEL,nil,0,MODE_SET)
                        Del(bomb)
                    end)
                end)
            end
        end)
    end
end
manager.cardlist[card.id] = M 
table.insert(manager.cardorder,card.id)
return M