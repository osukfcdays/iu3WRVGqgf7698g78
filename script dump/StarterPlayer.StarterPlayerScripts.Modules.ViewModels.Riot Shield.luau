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
    local v2 = t_1._charm_pivot_attachment

    if v2 then
        v2 = t_1._charm_pivot_attachment.Parent
    end

    t_1._charm_attachment_parent = v2
    t_1:_Init()

    return t_1
end

function t.AbsorbedHit(arg1) -- line: 22
    arg1:CreateSound(
        "rbxassetid://131693414206770",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.ShieldBroken(arg2) -- line: 26
    arg2:CreateSound(
        "rbxassetid://113753363821942",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t._UpdateAmmoVisual(arg3) -- line: 34
    if arg3._destroyed then
        return
    end

    local v5 = arg3.ClientItem:Get("Ammo") > 0 and true
    arg3:HideSubModel("Body", if not v5 then math.huge else 0)
    local CharmPivotAttachment = arg3._charm_pivot_attachment
    CharmPivotAttachment.Parent = v5 and arg3._charm_attachment_parent or nil
end

function t._Init(arg4) -- line: 45
    arg4.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 46
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisual()
    end)
    arg4.AnimationPlayed:Connect(function() -- line: 50
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisual()
    end)
    arg4.AnimationStopped:Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoVisual()
    end)
    task.spawn(arg4._UpdateAmmoVisual, arg4)
end

return t
