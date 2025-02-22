local M = require("yabmfr.class")()

function M:create(origin)
    self.segments = {}
    self.origin = origin or Vector(0,0)
    self.transform = Matrix3(1,0,0,0,1,0,0,0,1)
    return self
end
function M:push(segment)
    local final = self:sample(1)
    table.insert(self.segments,segment)
    segment.origin = final 
    return self
end
function M:sample(t)
    local origin = self.origin
    if #self.segments == 0 then
        return origin
    end
    local point
    if t >= 1 then
        point = self.segments[#self.segments]:sample(1)
    else
        local t = t or 0
        local n = #self.segments
        local t1 = t*n
        point = self.segments[math.floor(t1)+1]:sample(t1-math.floor(t1))
    end
    local p3 = Vector3(point.x,point.y,1) * self.transform 
    return Vector(p3.x,p3.y)
end

return M