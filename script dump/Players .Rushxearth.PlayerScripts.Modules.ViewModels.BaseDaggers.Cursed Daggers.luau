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

function t.PlayHitmarkerSound(arg1, arg2, arg3) -- line: 20
    -- upvalues:
    --  [1] BaseDaggers_m (copy)

    BaseDaggers_m.PlayHitmarkerSound(arg1, arg2, arg3)
    arg1:_CreateHitmarkerSound(
        "rbxassetid://96571931025850",
        1.25 / arg3,
        1 + 0.25 * math.random(),
        script,
        true,
        1
    )

    if arg2 then
        arg1:_CreateHitmarkerSound(
            "rbxassetid://106523082492142",
            1 / arg3,
            1.75 + 0.25 * math.random(),
            script,
            true,
            1
        )
    end
end

function t._Init(arg4) -- line: 33
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart1"), 1)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart2"), 1)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart3"), 1)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart4"), 1)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("LeftBody"):WaitForChild("MeshPart5"), 1)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart1"), 2)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart2"), 2)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart3"), 2)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart4"), 2)
    arg4:_RegisterAmmoVisual(arg4.ItemModel:WaitForChild("RightBody"):WaitForChild("MeshPart5"), 2)
end

return t
