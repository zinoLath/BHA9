local ww, wh  = GetImageSize("white")

function RenderFadingRect(pos,w1,w2,h,rot,color,blend)
    color = color or Color(255,0,0,0)
    blend = blend or ""
    SetImageState("white",blend, color)
    local p1 = pos + math.rotate2(Vector(w1/2,0),rot)
    Render("white", p1.x, p1.y, rot, w1/ww, h/wh)
    local c1 = Color(color.a, color.r, color.g, color.b)
    local c2 = Color(0, color.r, color.g, color.b)
    SetImageState("white",blend, c1,c2,c2,c1)
    local p2 = pos + math.rotate2(Vector(w1+w2/2,0),rot)
    Render("white", p2.x, p2.y, rot, w2/ww, h/wh)
end