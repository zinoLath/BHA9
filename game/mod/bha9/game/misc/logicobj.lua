local M = Class()
local logicobj = M

function logicobj:init(x,y,master)
    self.x, self.y = x,y
    _connect(master, self, 0, true)
end
function logicobj:frame()
    task.Do(self)
end

return M