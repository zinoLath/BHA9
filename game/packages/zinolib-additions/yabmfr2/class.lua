local class = {}
setmetatable(class,class)

function class:__call()
    local new = {}
    setmetatable(new,{
        __call = function(self,...)
            return class.New(self,...)
        end
    })
    return new
end
function class:New(...)
    local obj = {}
    obj.__index = self
    self.create(obj,...)
    setmetatable(obj, obj)
    return obj
end


return class