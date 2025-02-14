local stack = require("std.stack")
local tester = require("test.tester")

tester.set_module_name("std.stack")

tester.case("push pop", function()
    local stk = stack.create()
    assert(stk:empty())
    assert(stk:size() == 0)
    stk:push(1000)
    assert(not stk:empty())
    assert(stk:size() == 1)
    assert(stk:top() == 1000)
    stk:push(2000)
    assert(not stk:empty())
    assert(stk:size() == 2)
    assert(stk:top() == 2000)
    stk:pop()
    assert(not stk:empty())
    assert(stk:size() == 1)
    assert(stk:top() == 1000)
    stk:pop()
    assert(stk:empty())
    assert(stk:size() == 0)
end)
