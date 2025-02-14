local M = Class()
doremy_laser = M

local function rotatevec2(vec, ang)
    local cos = cos(ang)
    local sin = sin(ang)
    local vecx = vec.x
    vec.x = vecx * cos - vec.y * sin
    vec.y = vecx * sin + vec.y * cos
    return vec
end

function doremy_laser:init(w, node_count)
    self.groups_to_check = { -- the groups you're going to be checking against
        GROUP_ENEMY,
        GROUP_NONTJT
    }
    self.w = w -- width
    self.node_count = node_count -- really high just for demo purposes lmfao
    self.killflag = true
    self.texscroll_x = 0 --how much it should move on the x axis of the texture
    self.texscroll_y = 0 --how much it should move on the y axis of the texture
    ------ complicated stuff !!!
    self.data = BentLaserData()
    self.xlist = {}
    self.ylist = {}
    if self.class.samplewidth then        
        self.wlist = {}
    else
        self.wlist = nil
    end
end
function doremy_laser:frame()
    for i = 1, self.node_count do
        local vec = rotatevec2(self.class.sample(self, i/self.node_count),self.rot)
        self.xlist[i] = vec.x + self.x
        self.ylist[i] = vec.y + self.y
        if self.class.samplewidth then        
            self.wlist[i] = self.class.samplewidth(self, i/self.node_count)
        end
    end
    self.data:UpdateAllNode(self.node_count,self.xlist,self.ylist,self.wlist or self.w)
    
    if self.colli then
        for i, group in ipairs(self.groups_to_check) do
            for _i, obj in ObjList(group) do
                local is_check = self.data:CollisionCheck(obj.x,obj.y,obj.rot,obj.a,obj.b,obj.rect)
                if is_check then
                    obj.class.colli(obj, self)
                end
            end
        end
    end
end

function doremy_laser:render()
    local img_val = ImageList[self.img]
    SetTextureSamplerState(img_val[1],"linear+wrap")
    self.data:Render(img_val[1],self._blend,self._color,img_val[2],img_val[3],img_val[4],img_val[5],self.hscale)
    SetTextureSamplerState(img_val[1],"linear+clamp")
end

function doremy_laser:kill()
    self.data:Release()
end
function doremy_laser:del()
    self.data:Release()
end

function doremy_laser:sample(t)
    local length = 1000
    return lstg.Vector2(length * t,30 * sin(self.timer + t * 360)) --return a lstg.Vector2 starting from 0,0. it will get moved and rotated and everything in the frame
end
function doremy_laser:samplewidth(t)
    return self.w --this is just to like. if you want REALLY fucky lasers that change width
end

return M