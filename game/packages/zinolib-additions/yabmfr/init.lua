local M = require("yabmfr.class")()
local particle = require("particle")
local buffer = require("string.buffer")

--#region File Loading Helpers
local function bytes2uint(str)
    local uint = 0
    for i = 1, #str do
        uint = uint + str:byte(i) * 0x100^(i-1)
    end
    return uint
end
local function bytes2int(str)
    local uint = bytes2uint(str)
    local max = 0x100 ^ #str
    if uint >= max / 2 then
        return uint - max
    end
    return uint
end
local function readInt(buf, size)
    return bytes2int(buf:get(size))
end
local function readUInt(buf, size)
    return bytes2uint(buf:get(size))
end
local function readStr(buf)
    local str = ""
    while true do
        local c = buf:get(1)
        if c == "\0" then
            break
        end
        str = str .. c
    end
    return str
end
local function readBlock1(buf,size)
    local self = {}
    self.size = readInt(buf, 2)
    self.bitfield = readInt(buf, 1)
    self.charset = readInt(buf, 1)
    self.stretchH = readInt(buf, 2)
    self.aa = readInt(buf, 1)
    self.paddingUp = readInt(buf, 1)
    self.paddingRight = readInt(buf, 1)
    self.paddingDown = readInt(buf, 1)
    self.paddingLeft = readInt(buf, 1)
    self.spacingHoriz = readInt(buf, 1)
    self.spacingVert = readInt(buf, 1)
    self.outline = readInt(buf, 1)
    self.name = readStr(buf)
    return self
end
local function readBlock2(buf,size)
    local self = {}
    self.lineHeight = readUInt(buf,2)
    self.base = readUInt(buf,2)
    self.scaleW = readUInt(buf,2)
    self.scaleH = readUInt(buf,2)
    self.pages = readUInt(buf,2)
    self.bitfield = readUInt(buf,1)
    self.alphaChnl = readUInt(buf,1)
    self.redChnl = readUInt(buf,1)
    self.greenChnl = readUInt(buf,1)
    self.blueChnl = readUInt(buf,1)
    return self
end
local function readBlock3(buf,size)
    local self = {}
    while size > 0 do
        local str = readStr(buf)
        table.insert(self, str)
        size = size - #str - 1
    end
    return self
end
local function readBlock4(buf,size)
    local self = {}
    local charcount = size/20
    for i = 1, charcount, 1 do
        local id = readUInt(buf,4)
        local c = {}
        self[id] = c
        c.id = id
        c.x = readUInt(buf,2)
        c.y = readUInt(buf,2)
        c.width = readUInt(buf,2)
        c.height = readUInt(buf,2)
        c.xoffset = readInt(buf,2)
        c.yoffset = readInt(buf,2)
        c.xadvance = readInt(buf,2)
        c.chnl = readInt(buf,2)
    end
    return self
end
local function readBlock5(buf,size)
    local self = {}
    local kerncount = size/10
    for i = 1, kerncount, 1 do
        local first = readUInt(buf,4)
        local second = readUInt(buf,4)
        local amount = readInt(buf,2)
        self[first] = self[first] or {}
        self[first][second] = amount
    end
    return self
end
local getPath = function(str,sep)sep=sep or'/'return str:match("(.*"..sep..")")end
--#endregion

function M.LoadFont(font)
    local self = {}
    local str = LoadTextFile(font)
    local buf = buffer.new(string.len(str))
    buf:set(str)
    buf:skip(4)
    
    while #buf > 0 do
        local blocktype = readUInt(buf, 1)
        local block1size = readUInt(buf, 4)
        if blocktype == 1 then
            self.info = readBlock1(buf, block1size)
        end
        if blocktype == 2 then
            self.common = readBlock2(buf, block1size)
        end
        if blocktype == 3 then
            self.pages = readBlock3(buf, block1size)
        end
        if blocktype == 4 then
            self.chars = readBlock4(buf, block1size)
        end
        if blocktype == 5 then
            self.kerning = readBlock5(buf, block1size)
        end
    end
    LoadTexture("font:"..self.pages[1],getPath(font)..self.pages[1],true)
    self.texture = "font:"..self.pages[1]
    return self
end

function M:create(font, glyphcount, blend)
    glyphcount = glyphcount or 512
    blend = blend or "mul+alpha"
    self.font = font
    self.glyphcount = glyphcount
    self.pool = particle.NewTexPool2D(self.font.texture,blend,glyphcount)
    self.state = 0
    self.xcursor = 0
    self.linecount = 0
    self.clean = {}
    self.char_index = 0
    self.last_char = -1
end
local pfields = {
    "x", "y", "w", "h", "u", "v", "sx", "sy", "rot", "color", "extra1", "extra2", "extra3", "ax", "ay", "color", "timer"
}
function M:PushChar(charid)
    self.char_index = self.char_index + 1
    if charid == string.byte("\n") then
        self.xcursor = 0
        self.linecount = self.linecount + 1
        return
    end
    local char = self.font.chars[charid]
    local p = self.pool:AddParticle(char.x, char.y, char.width, char.height,0,0)
    p.u = char.x
    p.v = char.y
    p.w = char.width
    p.h = char.height
    p.extra1 = charid
    p.extra2 = self.state
    p.extra3 = self.char_index
    p.sx, p.sy = 1,1
    p.rot = 0
    p.x = self.xcursor + char.xoffset + char.width/2
    p.y = self.linecount * -self.font.common.lineHeight - char.yoffset - char.height/2
    p.color = Color(255,255,255,255)
    local kerning = 0
    if self.font.kerning then
        if self.font.kerning[charid] then
            if self.font.kerning[charid][self.last_char] then
                kerning = self.font.kerning[charid][self.last_char]
            end
        end
    end
    p.x = p.x + kerning
    self.xcursor = self.xcursor + char.xadvance + kerning
    self.clean[p.extra3] = {}
    for index, value in ipairs(pfields) do
        self.clean[p.extra3][value] = p[value]
    end
    self.last_char = charid
end
function M:PushString(str)
    for i=1, #str do
        self:PushChar(str:byte(i))
    end
end
function M:Apply(fun)
    self.pool:Apply(function (p)
        fun(self,p)
    end)
end
function M:Clean()
    self.pool:Apply(function (p)
        for index, value in ipairs(pfields) do
            p[value] = self.clean[p.extra3][value]
        end
    end)
end
function M:Transform(translate, rotate, scale)
    self.pool:Apply(function (p)
        p.pos = math.rotate2(p.pos * scale ,rotate) + translate
        p.rot = p.rot + rotate
        p.scale = p.scale * scale
    end)

end
function M:Render()
    self.pool:Render()
end

return M