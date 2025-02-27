local M = {}
local function dot(a,b)
    return a.x*b.x+a.y*b.y
end
local function cross(a,b)
    return a.x*b.y-a.y*b.x
end

require("math.additions")
---@~english Collision check for circle and parameter. Uses Cocos2D positions for operations. Code by Texel (Texel#4217)
---@param circP lstg.Vector2 Circle's position
---@param circR number Circle's radius
---@param capA lstg.Vector2 Capsule's location A
---@param capB lstg.Vector2 Capsule's location B
---@param capR number Capsule's radius
---@return boolean True if it's colliding.
function M:CircleToCapsule(circP, circR, capA, capB, capR)
    local effWidth = circR + capR; -- Compute total radius
    local effA, effB = circP - capA, capB - capA; -- Shift line segment coordinate system
    local h = dot(effA:Normalized(),effB); -- Distance along line segment that we are closet too
    print(h)
    --print((effA:Length() * effB:Length()))
    h = math.clamp(h,0,1)
    local finalpos = capA + ( effB * h )
    return Dist(finalpos.x,finalpos.y,circP.x,circP.y) <= effWidth, finalpos -- Check if the distance to our closet point on line to the circle point is within the combined radius
end

function M:AABB(pos1,w1,h1,pos2,w2,h2)
    return pos1.y > pos2.y - h2/2 - h1 and 
            pos1.y < pos2.y + h2/2 + h1 and
            pos1.x > pos2.x - w2/2 - w1 and 
            pos1.x < pos2.x + w2/2 + w1
end

return M