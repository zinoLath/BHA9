local M = {} --named tasks are for stuff like movement, where you need one coroutine to replace the other one of the same name
local namedtask = M
local field = "stask"

local max = math.max
local floor = math.floor
local rawget = rawget
local rawset = rawset
local ipairs = ipairs
local insert = table.insert
local create = coroutine.create
local status = coroutine.status
local resume = coroutine.resume
local yield = coroutine.yield

function namedtask.New(target,name,f)
    ---@type thread[]?
    local tasks = rawget(target, field)
    if not tasks then
        tasks = {}
        ---@cast tasks -thread[]?, +thread[]
        rawset(target, field, tasks)
    end
    local co = coroutine.create(f)
    tasks[name] = co
    return co
end

function namedtask.Do(target)
    ---@type thread[]?
    local tasks = rawget(target, field)
    if tasks then
        for _, co in pairs(tasks) do
            if status(co) ~= "dead" then
                local result, errmsg = resume(co)
                if not result then
                    error(
                        tostring(errmsg)
                        .. "\n========== coroutine traceback ==========\n"
                        .. debug.traceback(co)
                        .. "\n========== C traceback =========="
                    )
                end
            end
        end
    end

end

return M