local M = {}
local bulletdef = M
bulletdef.tex = "bullet"
local tex = bulletdef.tex
LoadTexture(bulletdef.tex,"zinolib/bullet/shotsheet.png",true)
SetTexturePreMulAlphaState(tex, false)
local w, h = GetTextureSize(bulletdef.tex)
local countx,county = 4,6
local _w, _h = 220,160

local function getrect(x,y)
    return x * _w, y * _h, _w, _h
end
local function getab(size,imgab)
    return (size/_w) * imgab, (size/_w) * imgab
end
local function setscale(name)
    if M[name].ani == true then
        SetAnimationScale(name,M[name].size/_w)
    else
        SetImageScale(name,M[name].size/_w)
    end
end
local function LoadBulImg(name,x,y,a)
    local _x,_y,_w,_h = getrect(x,y)
    local _a, _b = getab(M[name].size,a)
    LoadImage(name,tex,_x,_y,_w,_h,_a,_b,false)
    setscale(name)
end
local function LoadBulAni(name,x,y,col,row,aniv,a)
    local _x,_y,_w,_h = getrect(x,y)
    local _a, _b = getab(M[name].size,a)
    LoadAnimation(name,tex,_x,_y,_w,_h,col,row,aniv,_a,_b,false)
    setscale(name)
end

M.scale = Class()
M.scale.size = 24
M.scale.img = "scale"
LoadBulImg("scale",2,1,20)

M.fire = Class()
M.fire.size = 40
M.fire.img = "fire"
M.fire.ani = true
LoadBulAni("fire", 0,0, 1, 4,4, 20)
SetAnimationCenter("fire",126, _h/2)

M.amulet = Class()
M.amulet.size = 24
M.amulet.img = "amulet"
LoadBulImg("amulet",3,1,20)

M.cursor = Class()
M.cursor.size = 32
M.cursor.img = "cursor"
LoadBulImg("cursor",1,1,20)

M.circle = Class()
M.circle.size = 40
M.circle.img = "circle"
LoadBulImg("circle",0,4,20)

M.ellipse = Class()
M.ellipse.size = 60
M.ellipse.img = "ellipse"
LoadBulImg("ellipse",2,4,20)

M.kunai = Class()
M.kunai.size = 30
M.kunai.img = "kunai"
LoadBulImg("kunai",3,2,20)

M.star = Class()
M.star.size = 40
M.star.img = "star"
LoadBulImg("star",2,3,20)
function M.star:init()
    self.navi = false
    self.omiga = 3
end

return M 