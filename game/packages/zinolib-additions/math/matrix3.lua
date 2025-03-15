---Code by Zino
---@module math.matrix3
local ffi
local MATRIXTYPE = "cdata"
---@type Vector3
local vec3 = require("math.vector3")
---@type Vector2
local vec2 = require("math.vector")

local cos, sin = cos, sin

if jit and jit.status() then
    ffi = require "ffi"
    ffi.cdef[[
  typedef struct {
    double m00;
    double m01;
    double m02;
    double m10;
    double m11;
    double m12;
    double m20;
    double m21;
    double m22;
  } matrix3;
  ]]
else
    MATRIXTYPE = "table"
end

local fields = {"m00", "m01", "m02","m10", "m11", "m12","m20", "m21", "m22",}

---@class Matrix3
local Matrix3 = {}
setmetatable(Matrix3,Matrix3)
local Matrix3x3 = Matrix3

local special_properties = {
}

function Matrix3.__index(t, k)
    if special_properties[k] then
        return Matrix3[special_properties[k]](t)
    end
    if type(k) == "number" then
        rawget(Matrix3,fields[k])
    end
    return rawget(Matrix3,k)
end
---@return Matrix3
function Matrix3.newIdentity()
    return Matrix3(1,0,0,0,1,0,0,0,1)
end
---@return Matrix3
function Matrix3.new2D(m00,m01,m02,m10,m11,m12)
    return Matrix3(m00,m01,m02,m10,m11,m12,0,0,1)
end
---@return Matrix3
function Matrix3.new2DScale(x,y)
    if type(x) == "cdata" or type(x) == "table" then
        y = x.y
        x = x.x
    end
    return Matrix3.new2D(x,0,0,0,y,0)
end
---@return Matrix3
function Matrix3.new2DRotate(rot)
    return Matrix3.new2D(cos(rot),-sin(rot),0,sin(rot),cos(rot),0)
end
---@return Matrix3
function Matrix3.new2DShear(x,y)
    if type(x) == "cdata" or type(x) == "table" then
        y = x.y
        x = x.x
    end
    return Matrix3.new2D(1,x,0,y,1,0)
end
---@return Matrix3
function Matrix3.new2DTranslate(x,y)
    if type(x) == "cdata" or type(x) == "table" then
        y = x.y
        x = x.x
    end
    return Matrix3.new2D(1,0,x,0,1,y)
end

function Matrix3:copy()
    return Matrix3.new(self.m00,self.m01,self.m02,
                       self.m10,self.m11,self.m12,
                       self.m20,self.m21,self.m22)
end
function Matrix3:col(i)
    if i == 0 then
        return vec3(self.m00,self.m10,self.m20)
    elseif i == 1 then
        return vec3(self.m01,self.m11,self.m21)
    elseif i == 2 then
        return vec3(self.m02,self.m12,self.m22)
    end
end
function Matrix3:row(j)
    if j == 0 then
        return vec3(self.m00,self.m01,self.m02)
    elseif j == 1 then
        return vec3(self.m10,self.m11,self.m12)
    elseif j == 2 then
        return vec3(self.m20,self.m21,self.m22)
    end
end
function Matrix3:det()
    local a, b, c, d, e, f, g, h, i = self[1],self[2],self[3],self[4],self[5],self[6],self[7],self[8],self[9]
    return a * e * i + b * f * g + c * d * h - c * e * g - a * f * h - b * d * i
end
function Matrix3:_add(m2)
    return Matrix3.new( self.m00 + m2.m00,self.m01 + m2.m01,self.m02 + m2.m02,
                        self.m10 + m2.m10,self.m11 + m2.m11,self.m12 + m2.m12,
                        self.m20 + m2.m20,self.m21 + m2.m21,self.m22 + m2.m22)
end
function Matrix3:__sub(m2)
    return Matrix3.new( self.m00 - m2.m00,self.m01 - m2.m01,self.m02 - m2.m02,
            self.m10 - m2.m10,self.m11 - m2.m11,self.m12 - m2.m12,
            self.m20 - m2.m20,self.m21 - m2.m21,self.m22 - m2.m22)
end
function Matrix3:mul(m2)
    return Matrix3.new(
            (self:col(0) * m2:row(0)):sumcomponents(),
            (self:col(1) * m2:row(0)):sumcomponents(),
            (self:col(2) * m2:row(0)):sumcomponents(),

            (self:col(0) * m2:row(1)):sumcomponents(),
            (self:col(1) * m2:row(1)):sumcomponents(),
            (self:col(2) * m2:row(1)):sumcomponents(),

            (self:col(0) * m2:row(2)):sumcomponents(),
            (self:col(1) * m2:row(2)):sumcomponents(),
            (self:col(2) * m2:row(2)):sumcomponents()
            )
end
---@param v Vector3
function Matrix3:mulvec3(v)
    return vec3(
            self.m00 * v.x + self.m01 * v.y + self.m02 * v.z,
            self.m10 * v.x + self.m11 * v.y + self.m12 * v.z,
            self.m20 * v.x + self.m21 * v.y + self.m22 * v.z
            )
end
---@param v Vector2
function Matrix3:mulvec2(v)
    return vec2(
            self.m00 * v.x + self.m01 * v.y + self.m02,
            self.m10 * v.x + self.m11 * v.y + self.m12
    )
end

function Matrix3:__mul(m2)
    if type(m2) == MATRIXTYPE then
        if m2.m00 then
            return self:mul(m2)
        elseif m2.z then
            return self:mulvec3(m2)
        elseif m2.y then
            return self:mulvec2(m2)
        end
    end
end

if ffi then
    ---@return Matrix3
    function Matrix3.new(m00,m01,m02,m10,m11,m12,m20,m21,m22)
        return ffi.new("matrix3",m00 or 0,m01 or 0,m02 or 0,
                m10 or 0,m11 or 0,m12 or 0,
                m20 or 0,m21 or 0,m22 or 0)
    end
    ffi.metatype("matrix3",Matrix3)
else
    ---@return Matrix3
    function Matrix3.new(m00,m01,m02,m10,m11,m12,m20,m21,m22)
        return { m00 = m00,m01 = m01,m02 = m02,m10 = m10,m11 = m11,m12 = m12,m20 = m20,m21 = m21,m22 = m22 }
    end
end
function Matrix3:__call(...)
    return Matrix3.new(...)
end


return Matrix3