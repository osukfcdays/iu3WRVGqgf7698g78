local BaseDaggers_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseDaggers
)
local t = setmetatable({}, BaseDaggers_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseDaggers_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseDaggers_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    for key, val in pairs({ "LeftBody", "RightBody" }) do
        for index = 1, 7 do
            arg1:_RegisterAmmoVisual(
                arg1.ItemModel:WaitForChild(val):WaitForChild("MeshPart" .. index),
                key
            )
        end
    end
end

return t
