local M = require("yabmfr.class")()

function M:create(p1,p2)
    self.p2 = p1
    self.p3 = p2
    return self
end

function M:sample(t)
    local p1 = self.origin or self.p1 or (self.p2*0)

    return (1-t)^2*p1 + 2*(1-t)*t*self.p2 + t^2*self.p3
end

return M