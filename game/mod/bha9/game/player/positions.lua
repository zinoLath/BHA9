
LoadTexture("satori_sheet", "game/player/satori_sheet.png")
local function LoadImageRect2(image, texname, l, t, r, b, ...)
    return LoadImage(image,texname, l, t, r-l, b-t,...)
end
local function SetImageCenterFromTexture(img,x,y)
    SetImageCenter(img,x-ImageList[img][2],y-ImageList[img][3])
end
LoadImageRect2("satoriArmR", "satori_sheet", 9,18,34,87)
LoadImageRect2("satoriHead", "satori_sheet", 44,4,146,106)
LoadImageRect2("satoriTorso", "satori_sheet", 152,5,249,108)
LoadImageRect2("satoriSkirt", "satori_sheet", 1,118,121,185)
LoadImageRect2("satoriLegR", "satori_sheet", 204,122,238,218)
LoadImageRect2("satoriLegL", "satori_sheet", 157,120,187,219)
LoadImageRect2("satoriArmL2", "satori_sheet", 270,10,302,93)
LoadImageRect2("satoriArmL1", "satori_sheet", 265,117,287,171)

SetImageCenterFromTexture("satoriArmR",20,28)
SetImageCenterFromTexture("satoriHead",94,40)
SetImageCenterFromTexture("satoriTorso",200,60)
SetImageCenterFromTexture("satoriSkirt",60,127)
SetImageCenterFromTexture("satoriLegR",218,80)
SetImageCenterFromTexture("satoriLegL",174,80)
SetImageCenterFromTexture("satoriArmL2",280,19)
SetImageCenterFromTexture("satoriArmL1",275,122)

local drawlist = {
    "satoriArmL1",
    "satoriArmL2",
    "satoriLegL",
    "satoriLegR",
    "satoriSkirt",
    "satoriTorso",
    "satoriHead",
    "satoriArmR",
}
local M = {
    satoriTorso = {Vector(0,-40), 0},
    satoriHead = {Vector(0,63), 0},
    satoriArmR = {Vector(30,2),22},
    satoriArmL1 = {Vector(-35,8),-10},
    satoriArmL2 = {Vector(-40,-25),-30},
    satoriSkirt = {Vector(0,-70), 0},
    satoriLegR = {Vector(20,-60), 5},
    satoriLegL = {Vector(-20,-60), -5},
}
--rest1, rest2, moveL, moveR
M.anglist = {
    satoriTorso = {-2, 2, 8, -8},
    satoriHead = {-3,3,6,-6},
    satoriArmR = {17,25,28,15},
    satoriArmL1 = {-10,-14,-8,-14},
    satoriArmL2 = {-30,-35,-14,-50},
    satoriSkirt = { 0,0,12,-12},
    satoriLegR = { 5,-5,20,-20},
    satoriLegL = { -5,5,20,-20},
}
return M