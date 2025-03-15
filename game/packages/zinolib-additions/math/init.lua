math.vector = require("math.vector")
math.vector3 = require("math.vector3")
math.rect = require("math.rect")
math.matrix3 = require("math.matrix3")

function math.lerp(a,b,x)
    return a + (b-a) * x
end
function math.signpow(a,b)
    return math.pow(math.abs(a),b) * sign(a)
end
--Stole these from DNH ph3sx (it's open source, credit to Naudiz/Natashi)
function math.nangle(a)
    return a % 360
end
function math.anglediff(from,to)
    local delta = (to-from)%360
    return (delta > 180 and delta-360 or delta)
end
function math.lerpangle(a,b,x)
    local delta = AngleDifference(a,b)
    return a + delta * x
end