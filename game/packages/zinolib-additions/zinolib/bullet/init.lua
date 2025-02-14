
local M = Class()
---@param img any
---@param color any
---@param x any
---@param y any
---@param vel any
---@param ang any
---@param indes any
---@param add any
local bullet = M
local tween = require("math.tween")
bullet.images = {
    "fire1",
    "bullet_white",
    "bullet_shaded",
    "fire2",
    "cursor",
    "scale",
    "amulet",
    "fire3",
    "butterfly_back",
    "butterfly_front",
    "kunai",
    "fire4",
    "droplet",
    "star",
    "",
    "circle",
    "rice",
    "ellipse",
    "knife",
    "circle_border"
}
bullet.img_class = require("zinolib.bullet.def")
bullet[".render"] = true

function bullet:init(img,color,x,y,vel,ang,indes,add)
    self.img = img
    self._color = color
    self.x = x
    self.y = y
    self.navi = true
    self._speed = vel
    self._angle = ang
    self.rot = ang
    if indes then
        self.group = GROUP_INDES
    else
        self.group = GROUP_ENEMY_BULLET
    end
    if add then
        self._blend = "hue+add"
        self.layer = LAYER_ENEMY_BULLET_ADD
    else
        self._blend = "hue+alpha"
        self.layer = LAYER_ENEMY_BULLET
    end
    self.delay = 15
    self.pause = 0
    self.scale = 1
    self.last_pause = -1
    if self.class.img_class[img] then
        self.class.img_class[img].init(self)
    end
end
function bullet:frame()
    if self.pause > 0 then
        self.pause = self.pause - 1
        self.last_pause = self.timer
        self.timer = self.timer-1
        self.x = self.x - self.dx
        self.y = self.y - self.dy 
        self.vx = self.vx - self.ax
        self.vy = self.vy - self.ay
        self._b = 200
        return
    elseif self.timer-self.last_pause >= 1 then
        self._b = 0
    end 
    if self.class.img_class[img] then
        self.class.img_class[img].frame(self)
    end
    if self.delay >= 0 then
        local t = tween.cubicOut(self.delay/15)
        self._a = math.lerp(255,32,t)
        self.hscale = math.lerp(1,2,t) * self.scale
        self.vscale = math.lerp(1,2,t) * self.scale
        self.delay = self.delay - 1
    else
        self.hscale, self.vscale = self.scale,self.scale
    end
    task.Do(self)
end
function bullet:del()

end
function bullet:kill()
    New(item_faith_minor, self.x, self.y)
end


return M