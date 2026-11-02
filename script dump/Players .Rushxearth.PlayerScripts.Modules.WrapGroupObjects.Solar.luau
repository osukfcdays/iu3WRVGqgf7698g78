local WrapGroupObject_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.WrapGroupObject
)
local t = setmetatable({}, WrapGroupObject_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] WrapGroupObject_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(WrapGroupObject_m.new(...), t)
    t_1._shake_these = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 24
    for _, val in pairs(arg1._shake_these) do
        val.OffsetStudsU = (math.random() - 0.5) * 0.01
        val.OffsetStudsV = (math.random() - 0.5) * 0.01
    end
end

function t._Setup(arg3) -- line: 35
    for _, val_1 in pairs(arg3.ExtraObjects) do
        if val_1.Name == "Wireframe" then
            table.insert(arg3._shake_these, val_1)
        end
    end
end

function t._Init(arg4) -- line: 43
    arg4:_Setup()
end

return t
