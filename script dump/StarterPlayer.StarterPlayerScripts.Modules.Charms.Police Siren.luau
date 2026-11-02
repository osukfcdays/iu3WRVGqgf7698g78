local Charm_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.Charm)
local t = setmetatable({}, Charm_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Charm_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Charm_m.new(...), t)
    t_1._spin_anchor = t_1.Model:WaitForChild("Extra"):WaitForChild("SpinAnchor")
    t_1._spin_objects = {}
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2) -- line: 23
    -- upvalues:
    --  [1] Charm_m (copy)

    Charm_m.Update(arg1, arg2)
    local cframe = CFrame.Angles(0, tick() * 3.141592653589793 * 2 % 6.283185307179586, 0)

    for key, val in pairs(arg1._spin_objects) do
        key.CFrame = arg1._spin_anchor.CFrame * cframe * val
    end
end

function t._Setup(arg3) -- line: 37
    for index = 1, 3 do
        local Extra = arg3.Model:WaitForChild("Extra"):WaitForChild("Spin" .. index)
        arg3._spin_objects[Extra] = Extra.CFrame:ToObjectSpace(arg3._spin_anchor.CFrame):Inverse()
    end
end

function t._Init(arg4) -- line: 44
    arg4:_Setup()
end

return t
