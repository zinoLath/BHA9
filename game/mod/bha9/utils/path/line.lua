local M = require("yabmfr.class")()

function M:create(p)
    self.p = p
    return self
end

function M:sample(t)
    local p1 = self.origin or self.p1 or (self.p)
    return math.lerp(p1, self.p, t)
end

return M