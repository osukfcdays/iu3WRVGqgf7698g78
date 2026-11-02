local Players = game:GetService("Players")
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local BowChargeEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.BowChargeEffects
local t = {
    Color3.fromRGB(191, 191, 191),
    Color3.fromRGB(100, 255, 50),
    Color3.fromRGB(255, 180, 0),
    Color3.fromRGB(255, 50, 50)
}
local t_1 = setmetatable({}, ClientViewModel_m)
t_1.__index = t_1

function t_1.new(...) -- line: 11
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(ClientViewModel_m.new(...), t_1)
    t_2._charge_attachment = t_2.Model:FindFirstChild("_bow_charge", true)
    t_2._charge_particles = {}
    t_2._visibility_delayed = nil
    local v3 = t_2._charm_pivot_attachment

    if v3 then
        v3 = t_2._charm_pivot_attachment.Parent
    end

    t_2._charm_attachment_parent = v3
    t_2._registered_ammo_visuals = {}
    t_2:_Init()

    return t_2
end

function t_1.GetChargeColor(_, arg2) -- line: 29
    -- upvalues:
    --  [1] t (copy)

    return t[arg2]
end

function t_1.PlayChargeSound(arg3, arg4) -- line: 33
    arg3:CreateSound(
        "rbxassetid://13744359504",
        1,
        0.75 + 0.25 * arg4,
        true,
        10
    )
end

function t_1.PlayChargeEffect(arg5, arg6) -- line: 37
    arg5:PlayChargeSound(arg6)

    for _, val in pairs(arg5._charge_particles) do
        val.Color = ColorSequence.new(arg5:GetChargeColor(arg6))
        val:Emit(1)
    end
end

function t_1._UpdateArrow(arg7) -- line: 50
    if arg7._destroyed then
        return
    end

    local v5 = if not (arg7.ClientItem:Get("Ammo") > 0) then arg7:IsAnimationPlaying("Reload") or arg7:IsAnimationPlaying(
        "Shoot1"
    ) or arg7:IsAnimationPlaying("ChargeRelease") and arg7.ClientItem:Get("AmmoReserve") > 0 and true else true

    if v5 and not arg7._visibility_delayed then
        arg7._visibility_delayed = true
        wait(0.1)
        arg7:_UpdateArrow()

        return
    end

    local v6

    if arg7._charm_pivot_attachment then
        v6 = arg7._charm_pivot_attachment
        v6.Parent = v5 and arg7._charm_attachment_parent or nil
    end

    v6 = if not v5 then 1 else 0

    for _, val_1 in pairs(arg7._registered_ammo_visuals) do
        arg7:_LocalTransparencyModifier(val_1, "AmmoVisual", v6)
    end

    arg7._visibility_delayed = nil
end

function t_1._RegisterAmmoVisual(arg8, arg9) -- line: 80
    table.insert(arg8._registered_ammo_visuals, arg9)
end

function t_1._Setup(arg10) -- line: 84
    -- upvalues:
    --  [1] BowChargeEffects (copy)

    local v8 = pairs
    local v9 = BowChargeEffects:FindFirstChild(arg10.Name) or BowChargeEffects.Default

    for _, child in v8(v9.Attachment:GetChildren()) do
        local v10 = child:Clone()
        v10.Parent = arg10._charge_attachment
        table.insert(arg10._charge_particles, v10)
    end
end

function t_1._Init(arg11) -- line: 92
    arg11.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 93
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateArrow()
    end)
    arg11.AnimationPlayed:Connect(function() -- line: 97
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateArrow()
    end)
    arg11.AnimationStopped:Connect(function() -- line: 101
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateArrow()
    end)
    arg11:_Setup()
    task.spawn(arg11._UpdateArrow, arg11)
end

return t_1
