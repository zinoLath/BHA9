local tw = require("math.tween")
local M = function(times)
    times = int(times)
    local iter = {
        max_count = times,
        current = 0,
        linear = function(self, a,b,tween)
            tween = tween or tw.linear
            return math.lerp(a,b,tween((self.current-1)/(self.max_count-1)))
        end,
        linearA = function(self, a,b,tween)
            tween = tween or tw.linear
            return math.lerp(a,b,tween((self.current-1)/self.max_count))
        end,
        circle = function(self,tween)
            local a = 0
            local b = 360
            tween = tween or tw.linear
            return math.lerp(a,b,tween((self.current-1)/self.max_count))
        end,
        sine = function(self, a,b,init,total)
            local t = (self.current-1)/self.max_count
            local cur = init + total *t
            return math.lerp(a,b, lstg.sin(cur*360))
        end,
        increment = function(self, a, inc)
            return a + self.current * inc 
        end,
        sign = function(self)
            return ((self.current-1) % 2)*2-1
        end,
        zigzag = function(self,a,b,times,tween)
            tween = tween or tw.linear
            local t = (((self.current-1)/(self.max_count-1))*times)
            local tt = t -int(t)
            if int(t) % 2 == 0 then            
                return math.lerp(a,b,tween(tt))
            else
                return math.lerp(a,b,1-tween(tt))
            end
            
        end
    }
    return function ()
        iter.current = iter.current + 1
        if iter.current <= iter.max_count then
            return iter
        end
    end
end
return M