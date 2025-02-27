local M = Class()
local hpbar = M

local function RenderRing(img,x,y,fill,r,w,rot,n)
    local r1 = r - w/2
    local r2 = r + w/2
    local iimg = img
    
    for i = 1, int(n * fill) do
        if type(img) == "table" then
            iimg = LoopTable(img,i)
        else
            iimg = img
        end
        local da = 360/n
        local a = rot + (i-1)*360/n
        Render4V(iimg,
                r1 * cos(a + da) + x, r1 * sin(a + da) + y, 0.5,
                r2 * cos(a + da) + x, r2 * sin(a + da) + y, 0.5,
                r2 * cos(a) + x, r2 * sin(a) + y, 0.5,
                r1 * cos(a) + x, r1 * sin(a) + y, 0.5)
    end
    if (n * fill) ~= int(n * fill) then
        local i = int(n * fill)+1
        if type(img) == "table" then
            iimg = LoopTable(img,i)
        else
            iimg = img
        end
        local t = n * fill - int(n * fill)
        local da = (360/n)
        local a = rot + (i-1)*360/n
        local sc1 = lstg.Vector2(cos(a),sin(a))
        local sc2 = math.lerp(sc1,lstg.Vector2(cos(a + da),sin(a + da)),t)
        Render4V(iimg,
                r1 * (sc2.x) + x, r1 * (sc2.y) + y, 0.5,
                r2 * (sc2.x) + x, r2 * (sc2.y) + y, 0.5,
                r2 * (sc1.x) + x, r2 * (sc1.y) + y, 0.5,
                r1 * (sc1.x) + x, r1 * (sc1.y) + y, 0.5)
    end 
end


function hpbar:init(master)
    self.master = master 
    master.hpbar = self
    self.cjuice = ColorS("FFFFF9C5")
    self.cjuiceflash = ColorS("FFFFD0A3")
    self.cback = ColorS("FF463027")
    self.cbleed = ColorS("671be0ff")

    self.layer = LAYER_UI_TOP
    self.group = GROUP_GHOST
    self.bound = false
    self.colli = false
    self.x, self.y = self.master.x, self.master.y
    self.update_pos = true
    self.current_level = 1
    self.blood_level = 0
    self.blood_speed = 1/240
    self.w = 6
    self._w = 0
    self.r = 64
    self.border = 3
    self._a = 255
    self.is_dying = false
end
function hpbar:frame()
    if IsValid(self.master) then
        if self.update_pos then
            self.x, self.y = self.master.x, self.master.y
        end
        self.current_level = self.master.hp/self.master.maxhp
    else
        if not self.is_dying then
            task.New(self, function()
                ex.AsyncSmoothSetValueTo(self,"_a",0,30,MOVE_DECEL)
                ex.AsyncSmoothSetValueTo(self,"r",self.r * 2,30,MOVE_DECEL)
                ex.AsyncSmoothSetValueTo(self,"w",self.w * 2,30,MOVE_DECEL)
                task.Wait(30)
                Kill(self)
            end)
        end
        self.is_dying = true
        self.current_level = 0
        
    end
    self.blood_level = math.max(self.current_level, self.blood_level-self.blood_speed)
    if Dist(self,player) < self.r * 1.5 then
        self._a = math.lerp(self._a, 32, 0.1)
    else
        self._a = math.lerp(self._a, 255, 0.1)
    end
    task.Do(self)
    if lstg.player.dialog then
        self._w = math.lerp(self._w,0,0.1)
    else
        self._w = math.lerp(self._w,1,0.1)
    end
end
function hpbar:render()
    local ca = Color(self._a,255,255,255)
    local n = 64
    SetImageState("white","",self.cback * ca)
    RenderRing("white",self.x,self.y,1,self.r,self._w*self.w+self.border*self._w,self.rot+90,n)
    SetImageState("white","",self.cbleed * ca)
    RenderRing("white",self.x,self.y,self.blood_level,self.r,self._w*self.w,self.rot+90,n)
    SetImageState("white","",self.cjuice * ca)
    RenderRing("white",self.x,self.y,self.current_level,self.r,self._w*self.w,self.rot+90,n)
end

return M