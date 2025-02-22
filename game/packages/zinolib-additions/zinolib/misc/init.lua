function task.NewUpdate(self, func)
    task.New(self,function() 
        while true do
            func(self)
            task.Wait(1)
        end
    end)
end

function task.NewPolar(self)
    self.rad = self.rad or 0
    self.theta = self.theta or 0
    self.deltarad = self.deltarad or 0
    self.wvel = self.wvel or 0
    self.center = self.center or Vector2(self.x,self.y)
    task.New(self,function()
        while true do
            self.rad = self.rad + self.deltarad
            self.theta = self.theta + self.wvel
            local center = Vector2(self.center.x,self.center.y)
            local pos = center + math.polar(self.rad,self.theta)
            self.x,self.y = pos.x, pos.y
            task.Wait(1)
        end
    end)
end
BUL_COLOR = {
    RED = 0,
    ORANGE = 30,
    YELLOW = 60,
    CHARTREUSE = 90,
    GREEN = 120,
    OCEAN = 150,
    CYAN = 180,
    SKY = 210,
    BLUE = 240,
    PURPLE = 270,
    MAGENTA = 300,
    PINK = 330,
}
function BulletColor(hue,sat,alpha)
    alpha = alpha or 255
    sat = sat or 100
    hue = hue % 360
    return Color(alpha, hue*255/360,sat*2.55,0)
end

function AngDelta(self)
    return Angle(0,0,self.dx,self.dy)
end

function nsin(t)
    return sin(t)/2 + 0.5
end

function ColorS(str)
    return Color(tonumber("0x" .. str))
end

function LoopTable(tb,id)
    local tid = (id-1)%#tb + 1
    return tb[tid]
end
function LoopTableK(tb,id)
    local tid = (id-1)%#tb + 1
    return tid
end

local Int = math.lerp
local Lin = function (x) return x end
function Interpolate_Element(arr, t, func)
    local src = arr[int(t)] --get the first value for lerp
    local did = LoopTableK(arr,int(t+1))
    local dest = arr[did] --get the second index for lerp
    local _t = t - int(t)
    func = func or Lin
    return Int(src,dest,func(_t))
end

function InterpolateColor(a,b,t)
    return Color(
            math.lerp(a.a,b.a,t),
            math.lerp(a.r,b.r,t),
            math.lerp(a.g,b.g,t),
            math.lerp(a.b,b.b,t)
    )
end