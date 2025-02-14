local M = {}

require("math.additions")
---@~english Collision check for circle and parameter. Uses Cocos2D positions for operations. Code by Texel (Texel#4217)
---@param circP vec2_table|cc.p Circle's position
---@param circR number Circle's radius
---@param capA vec2_table|cc.p Capsule's location A
---@param capB vec2_table|cc.p Capsule's location B
---@param capR number Capsule's radius
---@return boolean True if it's colliding.
function M:CircleToCapsule(circP, circR, capA, capB, capR)
    local effWidth = circR + capR; -- Compute total radius
    local effA, effB = circP - capA, circP - capB; -- Shift line segment coordinate system
    local h = math.clamp( effA:Dot(effB) / effB:Dot(effB) , 0, 1); -- Distance along line segment that we are closet too
    return (circP - (effB * h )):Length() > effWidth; -- Check if the distance to our closet point on line to the circle point is within the combined radius
end

return M