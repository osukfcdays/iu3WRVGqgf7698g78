local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 24
    local v2 = math.floor(tick() * 10) * 0.027 % 0.25
    local _ = tick() * 10

    for _, val in pairs(arg1.ExtraObjects) do
        val.OffsetStudsV = v2
    end
end

function t._Init(_) -- line: 36
end

return t
