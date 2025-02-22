---=====================================
---luastg math
---=====================================

----------------------------------------
---常量

PI = math.pi
PIx2 = math.pi * 2
PI_2 = math.pi * 0.5
PI_4 = math.pi * 0.25
SQRT2 = math.sqrt(2)
SQRT3 = math.sqrt(3)
SQRT2_2 = math.sqrt(0.5)
GOLD = 360 * (math.sqrt(5) - 1) / 2

----------------------------------------
---数学函数

int = math.floor
abs = math.abs
max = math.max
min = math.min
rnd = math.random
sqrt = math.sqrt

math.mod = math.mod or math.fmod
mod = math.mod

---获得数字的符号(1/-1/0)
function sign(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end

---获得(x,y)向量的模长
function hypot(x, y)
    return sqrt(x * x + y * y)
end

---阶乘，目前用于组合数和贝塞尔曲线
local fac = {}
function Factorial(num)
    if num < 0 then
        error("Can't get factorial of a minus number.")
    end
    if num < 2 then
        return 1
    end
    num = int(num)
    if fac[num] then
        return fac[num]
    end
    local result = 1
    for i = 1, num do
        if fac[i] then
            result = fac[i]
        else
            result = result * i
            fac[i] = result
        end
    end
    return result
end

---组合数，目前用于贝塞尔曲线
function combinNum(ord, sum)
    if sum < 0 or ord < 0 then
        error("Can't get combinatorial of minus numbers.")
    end
    ord = int(ord)
    sum = int(sum)
    return Factorial(sum) / (Factorial(ord) * Factorial(sum - ord))
end

--------------------------------------------------------------------------------
--- 弹幕逻辑随机数发生器，用于支持 replay 系统

local ENABLE_NEW_RNG = false

if ENABLE_NEW_RNG then
    -- 2019 年的新一代 xoshiro256** 随机数发生器
    local random = require("random")
    ran = random.xoshiro512ss()
else
    -- 2006 年的 WELL512 随机数发生器
    ran = lstg.Rand()
    pran = lstg.Rand()
end



function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function math.ang2(theta)
    return lstg.Vector2(cos(theta), sin(theta))
end
function math.polar(radius,theta)
    return math.ang2(theta) * radius
end

function math.rotate2(vec, ang)
    ang = -ang
    return Vector2(vec.x * cos(ang) + vec.y * sin(ang), vec.x * -sin(ang) + vec.y * cos(ang))
end

function math.vecfromobj(obj)
    return Vector(obj.x,obj.y)
end

function math.ellipse(rx,ry,eang,ang)
    local vec = Vector(cos(ang) * rx, sin(ang) * ry)
    return math.rotate2(vec,eang)
end 

function math.vlerp(v1,v2,t)
    return Vector(math.lerp(v1.x,v2.x,t),math.lerp(v1.y,v2.y,t))
end

function math.polygon(sides,t)
    local t1 = int(sides * t)
    local t2 = sides * t - t1
    local da = 360/sides
    return math.lerp(math.ang2(da * t1), 
                     math.ang2(da * t1 + da),t2)
end