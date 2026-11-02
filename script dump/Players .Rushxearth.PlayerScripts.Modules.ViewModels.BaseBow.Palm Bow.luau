local BaseBow_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseBow
)
local t = setmetatable({}, BaseBow_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseBow_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseBow_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayChargeSound(arg1, arg2) -- line: 20
    -- upvalues:
    --  [1] BaseBow_m (copy)

    BaseBow_m.PlayChargeSound(arg1, arg2)
    arg1:CreateSound(
        "rbxassetid://113094896439924",
        1,
        1 + 0.1 * arg2,
        true,
        10
    )
end

function t._Init(arg3) -- line: 29
    arg3:_RegisterAmmoVisual(arg3.ItemModel:WaitForChild("Arrow"):WaitForChild("Feather"))
    arg3:_RegisterAmmoVisual(arg3.ItemModel:WaitForChild("Arrow"):WaitForChild("Stick"))
    arg3:_RegisterAmmoVisual(arg3.ItemModel:WaitForChild("Arrow"):WaitForChild("Tip"))
end

return t
