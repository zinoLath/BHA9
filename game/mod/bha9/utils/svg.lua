local M = require("utils.class")()
local xml2lua = require("utils.xml")
local handler = require("utils.xml.xmlhandler.tree")
local function parsePath(input)
    local out = {};

    for instr, vals in input:gmatch("([a-df-zA-DF-Z])([^a-df-zA-DF-Z]*)") do
        local line = { instr };
        for v in vals:gmatch("([+-]?[%deE.]+)") do
            if tonumber(v) then
                line[#line+1] = tonumber(v);
            else
                line[#line+1] = v;
            end
        end
        out[#out+1] = line;
    end
    return out;
end

function M:create(path)
    local str = LoadTextFile(path)
    self.xml = handler:new()
    self.parser = xml2lua.parser(self.xml)
    self.parser:parse(str)
    self.data = self.xml.root
    local viewbox = {};
    for m in self.data.svg._attr.viewBox:gmatch("%S+") do
        print(m)
        viewbox[#viewbox+1] = tonumber(m);
    end
    self.viewbox = Rect(viewbox[1],viewbox[2],viewbox[3],viewbox[4])
    return self
end

local path = require("utils.path")
local line = require("utils.path.line")
local cbezier = require("utils.path.cbezier")
local qbezier = require("utils.path.qbezier")
function M:getPathID(id)
    for k,v in pairs(self.data.svg.path) do
        if v._attr.id == id then
            return self:path(v._attr.d,v._attr.transform)
        end
    end
end
function M:getAllPath()
    local ret = {}
    for k,v in ipairs(self.data.svg.path) do
        table.insert(ret,self:path(v._attr.d,v._attr.transform))
    end
    return ret
end
local transformenv = {}
function transformenv.translate(x,y)
    transformenv.current = transformenv.current * Matrix3(1,0,x,0,1,y,0,0,1)
end
function transformenv.rotate(a)
    local c,s = cos(a),-sin(a)
    transformenv.current = transformenv.current * Matrix3(c,-s,0,s,c,0,0,0,1)
end
function transformenv.scale(x,y)
    transformenv.current = transformenv.current * Matrix3(x,0,0,0,y,0,0,0,1)
end
function transformenv.shear(x,y)
    transformenv.current = transformenv.current * Matrix3(1,x,0,y,1,0,0,0,1)
end
function transformenv.matrix(a,b,c,d,x,y)
    transformenv.current = transformenv.current *Matrix3(a,b,x,c,d,y,0,0,1)
end
transformenv.Matrix3 = lstg.Matrix3
transformenv.cos = cos
transformenv.sin = sin
transformenv.print = print
transformenv.transformenv = transformenv
transformenv.current = lstg.Matrix3(1,0,0,0,1,0,0,0,1)
local function readtransform(str)
    if str:byte(1) == 27 then return nil, "binary bytecode prohibited" end
    local strcpy = ""
    for i = 1, #str do
        local c = str:sub(i,i)
        if tonumber(str:sub(i-1,i-1)) and c == " " then
            strcpy = strcpy .. ",\n"
        end
        strcpy = strcpy .. c
    end
    str1 =  strcpy .. "\n return transformenv.current "
    print(str1)
    local untrusted_function, message = loadstring(str1)
    --print(str1)
    if not untrusted_function then return nil, message end
    transformenv.current = lstg.Matrix3(1,0,0,0,1,0,0,0,1)
    return pcall(setfenv(untrusted_function, transformenv))
end
function M:path(str,strtrans)
    strtrans = strtrans or ""
    local parsed = parsePath(str)
    local ret = path()
    local _, transform = readtransform(strtrans)
    ret.transform = transform
    local cursor = Vector(0,0)
    local last_control = Vector(0,0)
    local last_control_id = 0
    for k, v in ipairs(parsed) do
        local command = v[1]
        local initial = cursor
        if command == "M" then
            for i=2,#v,2 do
                if ret.origin == nil then
                    ret.origin = Vector(v[i+0],v[i+1])
                end
                cursor = Vector(v[i+0],v[i+1])
            end
        end
        if command == "m" then
            if ret.origin == nil then
                ret.origin = cursor + Vector(v[2],v[3])
            end
            cursor = cursor + Vector(v[2],v[3])
        end
        if command == "L" then
            for i=2,#v,2 do
                local p = Vector(v[i],v[i+1])
                local segment = line(p)
                ret:push(segment)
                segment.origin = cursor
                cursor = p
            end
        end
        if command == "l" then
            for i=2,#v,2 do
                local p = Vector(v[i],v[i+1]) + initial
                local segment = line(p)
                ret:push(segment)
                segment.origin = cursor
                cursor = p
            end
        end
        if command == "C" then
            for i=2,#v,6 do
                local p2 = Vector(v[i],v[i+1])
                local p3 = Vector(v[i+2],v[i+3])
                local p4 = Vector(v[i+4],v[i+5])
                last_control = p4-p3
                last_control_id = 3
                local segment = cbezier(p2,p3,p4)
                ret:push(segment)
                segment.origin = cursor
                cursor = p4
            end
        end
        if command == "c" then
            for i=2,#v,6 do
                local p2 = Vector(v[i],v[i+1]) + initial
                local p3 = Vector(v[i+2],v[i+3]) + initial
                local p4 = Vector(v[i+4],v[i+5]) + initial
                last_control = p4-p3
                last_control_id = 3
                local segment = cbezier(p2,p3,p4)
                ret:push(segment)
                segment.origin = cursor
                cursor = p4
            end
        end
        if command == "S" then
            for i=2,#v,4 do
                local p3 = Vector(v[i],v[i+1])
                local p4 = Vector(v[i+2],v[i+3])
                local p2 = cursor-last_control
                if last_control_id ~= 0 then
                    p2 = Vector(0,0)
                end
                last_control = p4-p3
                last_control_id = 3
                local segment = cbezier(p2,p3,p4)
                ret:push(segment)
                segment.origin = cursor
                cursor = p4
            end
        end
        if command == "s" then
            for i=2,#v,4 do
                local p3 = Vector(v[i],v[i+1]) + initial
                local p4 = Vector(v[i+2],v[i+3]) + initial
                local p2 = cursor-last_control
                if last_control_id ~= 0 then
                    p2 = Vector(0,0)
                end
                last_control = p4-p3
                last_control_id = 3
                local segment = cbezier(p2,p3,p4)
                ret:push(segment)
                segment.origin = cursor
                cursor = p4
            end
        end
        if command == "Q" then
            for i=2,#v,4 do
                local p2 = Vector(v[i],v[i+1])
                local p3 = Vector(v[i+2],v[i+3])
                last_control = p3-p2
                last_control_id = 2
                local segment = qbezier(p2,p3)
                ret:push(segment)
                segment.origin = cursor
                cursor = p3
            end
        end
        if command == "q" then
            for i=2,#v,4 do
                local p2 = Vector(v[i],v[i+1])+initial
                local p3 = Vector(v[i+2],v[i+3])+initial
                last_control = p3-p2
                last_control_id = 2
                local segment = qbezier(p2,p3)
                ret:push(segment)
                segment.origin = cursor
                cursor = p3
            end
        end
        if command == "T" then
            for i=2,#v,2 do
                local p3 = Vector(v[i+0],v[i+1])
                local p2 = cursor-last_control
                if last_control_id ~= 2 then
                    p2 = Vector(0,0)
                end
                last_control = p3-p2
                last_control_id = 2
                local segment = qbezier(p2,p3)
                ret:push(segment)
                segment.origin = cursor
                cursor = p3
            end
        end
        if command == "t" then
            for i=2,#v,2 do
                local p3 = Vector(v[i+0],v[i+1]) + initial
                local p2 = cursor-last_control
                if last_control_id ~= 2 then
                    p2 = Vector(0,0)
                end
                last_control = p3-p2
                last_control_id = 2
                local segment = qbezier(p2,p3)
                ret:push(segment)
                segment.origin = cursor
                cursor = p3
            end
        end
        if command == "Z" then
            local p = ret.origin
            local segment = line(p)
            --ret:push(segment)
            segment.origin = cursor
            cursor = p
        end
    end
    return ret
end

return M