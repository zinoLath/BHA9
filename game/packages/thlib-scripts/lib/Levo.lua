HSVColor = lstg.HSVColor
Vector2 = lstg.Vector2
Vector = Vector2
Vector3 = lstg.Vector3
Vector4 = lstg.Vector4
Matrix2 = lstg.Matrix2
Matrix3 = lstg.Matrix3
Matrix4 = lstg.Matrix4
Rect = lstg.Rect
RenderTextureRect = lstg.RenderTextureRect
function RectWH(x,y,w,h)
    return Rect(x,y+h,x+w,y)
end
function RectWHV(xy,wh)
    return RectWH(xy.x,xy.y,wh.x,wh.y)
end

function MatrixTranslate(v)
    return Matrix3(1,0,v.x,0,1,v.y,0,0,1)
end

function MatrixRotate(a)
    local c,s = cos(a),sin(a)
    return Matrix3(c,-s,0,s,c,0,0,0,1)
end

function MatrixScale(v)
    return Matrix3(v.x,0,0,0,v.y,0,0,0,1)
end

function MatrixShear(v)
    return Matrix3(1,v.x,0,v.y,1,0,0,0,1)
end
function MatrixIdentity()
    return Matrix3(1,0,0,0,1,0,0,0,1)
end


function VectorRectToRect(v,r1,r2)
    local t = (v - r1.lt) / r1.dimension
    return math.lerp(r2.lt,r2.rb,t)
end