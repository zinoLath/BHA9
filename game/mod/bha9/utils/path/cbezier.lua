local M = require("yabmfr.class")()

function M:create(p1,p2,p3)
    self.p2 = p1
    self.p3 = p2
    self.p4 = p3
    return self
end

function M:sample(t)
    local p1 = self.origin or self.p1 or (self.p2*0)

    return (1-t)^3*p1 + 3*(1-t)^2*t*self.p2 + 3*(1-t)*t^2*self.p3 + t^3*self.p4
end

return M