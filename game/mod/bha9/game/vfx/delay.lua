local M = Class()
M[".render"] = true 
local delay = M

CopyImage("delaywhite","white")
SetImageCenter("delaywhite",0,8)
function delay:init(x,y,ang,color)
    self._color = color
    self.group = GROUP_GHOST
    self.colli = false
    self.bound = false
    self.x, self.y = x, y
    self.hscale = 0
    self.vscale = 0
    self.rot = ang
    self._blend = ""
    self.img = "delaywhite"
end
function delay:frame()
    task.Do(self)
end

return M