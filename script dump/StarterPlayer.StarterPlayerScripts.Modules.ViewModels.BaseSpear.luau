local ClientViewModel_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._registered_ammo_visuals = {}
    local v3 = t_1._charm_pivot_attachment

    if v3 then
        v3 = t_1._charm_pivot_attachment.Parent
    end

    t_1._charm_attachment_parent = v3
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoVisual(arg1) -- line: 29
    if arg1._destroyed then
        return
    end

    for key, val in pairs(arg1._registered_ammo_visuals) do
        local v4 = if not (val <= arg1.ClientItem:Get("Ammo")) then arg1:IsAnimationPlaying(
            "Reload"
        ) else true
        arg1:_LocalTransparencyModifier(key, "AmmoVisual", if not v4 then 1 else 0)

        if val == 1 and arg1._charm_pivot_attachment then
            local CharmPivotAttachment = arg1._charm_pivot_attachment
            local v6 = v4 and arg1._charm_attachment_parent or nil
            CharmPivotAttachment.Parent = v6
        end
    end
end

function t._RegisterAmmoVisual(arg2, arg3, arg4) -- line: 45
    arg2._registered_ammo_visuals[arg3] = arg4
end

function t._Init(arg5) -- line: 49
    arg5.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 50
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateAmmoVisual()
    end)
    arg5.AnimationPlayed:Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateAmmoVisual()
    end)
    arg5.AnimationStopped:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateAmmoVisual()
    end)
    task.spawn(arg5._UpdateAmmoVisual, arg5)
end

return t
