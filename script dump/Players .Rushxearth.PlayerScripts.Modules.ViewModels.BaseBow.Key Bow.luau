local BaseBow_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseBow
)
local t = {
    Color3.fromRGB(191, 191, 191),
    Color3.fromRGB(250, 228, 116),
    Color3.fromRGB(248, 214, 44),
    Color3.fromRGB(229, 192, 6)
}
local t_1 = setmetatable({}, BaseBow_m)
t_1.__index = t_1

function t_1.new(...) -- line: 10
    -- upvalues:
    --  [1] BaseBow_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(BaseBow_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.GetChargeColor(_, arg2) -- line: 22
    -- upvalues:
    --  [1] t (copy)

    return t[arg2]
end

function t_1.PlayChargeSound(arg3, arg4) -- line: 26
    -- upvalues:
    --  [1] BaseBow_m (copy)

    BaseBow_m.PlayChargeSound(arg3, arg4)
    arg3:CreateSound(
        "rbxassetid://90757583550672",
        0.5,
        1.25 + 0.25 * arg4,
        true,
        5
    )
    arg3:CreateSound(
        "rbxassetid://90757583550672",
        0.125,
        1,
        true,
        5
    )
end

function t_1._UpdateAmmoContext(arg5) -- line: 36
    local v3 = arg5.ClientItem:Get("Ammo") <= 0 and true

    if v3 == arg5._is_empty then
        return
    end

    arg5._is_empty = v3
    arg5:ChangeInspectAnimation(if not arg5._is_empty then "Inspect" else "InspectEmpty")
    arg5.Animator:ChangeRareInspectAnimation(if arg5._is_empty then "nil" else "RareInspect")
end

function t_1._Init(arg6) -- line: 49
    arg6.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 50
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAmmoContext()
    end)
    arg6.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateAmmoContext()
    end)
    arg6:_UpdateAmmoContext()
    arg6:_RegisterAmmoVisual(arg6.ItemModel:WaitForChild("Arrow"):WaitForChild("Stick"))
end

return t_1
