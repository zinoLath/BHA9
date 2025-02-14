local M = Class(enemybase)
local familiar = M
familiar[".render"] = true
LoadTexture("familiar", "game/enemy/familiar.png")
local size = 64
local rect = 128
local scale = size/rect
LoadImage("familiar_circle","familiar",0,0,rect,rect,113/4,113/4,false)
SetImageScale("familiar_circle",scale)
LoadImage("familar_hexagram","familiar",rect,0,rect,rect,113/4,113/4,false)
SetImageScale("familar_hexagram",scale)
LoadImage("familiar_background","familiar",rect*2,0,rect,rect,113/4,113/4,false)
SetImageScale("familiar_background",scale)
LoadAnimation("familiar_directional","familiar",0,rect,rect,rect,4,1,4,114/4,114/4,false)
SetAnimationScale("familiar_directional",scale)
SetAnimationCenter("familiar_directional",128-32,64)
local tween = require("math.tween")
local particle = require("particle")

function familiar:init(master,x,y,hp,color,dmg_transfer)
    SetObjectMetatable(self)
    self.master = master
    _connect(master, self, dmg_transfer or 0, true)
    self.x = x
    self.y = y
    enemybase.init(self,hp,true)
    self.core_alpha = 255
    self._color = color
    self.navi = true
    self.layer = LAYER_FAMILIAR
    self.bound = false
end 
function familiar:frame()
    local maxtime = 60
    enemybase.frame(self)
    if player.slow == 1 then
        self.colli = false
        self.core_alpha = math.max(self.core_alpha - 50,10)
    else
        self.colli = true
        self.core_alpha = math.min(self.core_alpha + 50,255)
    end
end
function familiar:render()
    SetImageState("familiar_background","add+add",self._color)
    Render("familiar_background",self.x,self.y,self.rot + self.timer*-5,self.hscale*1.5,self.vscale*1.5)
    SetImageState("familar_hexagram","add+add",self._color)
    Render("familar_hexagram",self.x,self.y,self.rot + self.timer*5,self.hscale,self.vscale)
    SetAnimationState("familiar_directional","add+add",self._color * Color(self.core_alpha,255,255,255))
    RenderAnimation("familiar_directional",self.timer,self.x,self.y,self.rot,self.hscale,self.vscale)
end

return M