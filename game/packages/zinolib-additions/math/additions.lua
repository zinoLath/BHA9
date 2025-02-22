function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function math.lerp(a,b,x)
    return a - (a-b) * x
end
function math.lerpcolor(a,b,x)
    return Color(math.lerp(a.a,b.a,x),
                math.lerp(a.r,b.r,x),
                math.lerp(a.g,b.g,x),
                math.lerp(a.b,b.b,x))
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
    local delta = math.anglediff(a,b)
    return a + delta * x
end