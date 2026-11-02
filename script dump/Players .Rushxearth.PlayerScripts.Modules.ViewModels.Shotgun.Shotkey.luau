local Shotgun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Shotgun
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 218, 155))
local t = setmetatable({}, Shotgun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Shotgun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Shotgun_m.new(...), t)
    t_1._ammo_visuals = {}
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 24
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._UpdateAmmoVisuals(arg2) -- line: 32
    local v3 = arg2.ClientItem:Get("Ammo")

    for key, val in pairs(arg2._ammo_visuals) do
        local v4 = if not (v3 >= key) then if key == 1 then arg2:IsAnimationPlaying(
            "EmptyReloadStart"
        ) else false else true

        for _, val_1 in pairs(val) do
            arg2:_LocalTransparencyModifier(val_1, "AmmoVisual", if not v4 then 1 else 0)
        end
    end

    local task_defer = task.defer
    task_defer(
        arg2.ChangeInspectAnimation,
        arg2,
        if not (v3 <= 3) then "Inspect" else "EmptyInspect"
    )
end

function t._Setup(arg3) -- line: 46
    for index = 1, 7 do
        local _ = {}
        arg3._ammo_visuals[index] = {
            arg3.ItemModel:WaitForChild("Shell" .. index):WaitForChild("Black"),
            arg3.ItemModel:WaitForChild("Shell" .. index):WaitForChild("Metal")
        }
    end
end

function t._Init(arg4) -- line: 52
    arg4.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 53
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisuals()
    end)
    arg4.AnimationPlayed:Connect(function() -- line: 57
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisuals()
    end)
    arg4.AnimationStopped:Connect(function() -- line: 61
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisuals()
    end)
    arg4:_Setup()
    task.defer(arg4._UpdateAmmoVisuals, arg4)
end

return t
