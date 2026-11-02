local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Gun_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local ImpactMarkerSplat = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ImpactMarkerSplat"
)
local t = { "rbxassetid://17098901439", "rbxassetid://17098901515", "rbxassetid://16833617681" }
local t_1 = setmetatable({}, Gun_m)
t_1.__index = t_1

function t_1.new(...) -- line: 15
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Gun_m.new(...), t_1)
    t_2._grenade_cooldown = 0
    t_2:_Init()

    return t_2
end

function t_1.StartAiming(arg1, arg2) -- line: 29
    if
        not arg2
        and (tick() < arg1._grenade_cooldown or tick() < arg1._reload_cooldown or arg1:IsEquipping())
    then
        return
    end

    arg1._grenade_cooldown = tick() + arg1.Info.GrenadeCooldown
    local ShootCooldown = arg1._shoot_cooldown
    local now_1 = tick()
    arg1._shoot_cooldown = math.max(ShootCooldown, now_1 + arg1.Info.GrenadeShootCooldown)
    arg1.ViewModel:StopAnimation("Inspect")
    arg1.ViewModel:PlayAnimation("Throw", 1)
    arg1:CooldownEffect("rbxassetid://77802568386086", arg1.Info.GrenadeCooldown, "Cooldown")

    return true, "StartAiming", (arg1.ClientFighter:GetCameraData())
end

function t_1.FinishAiming(_, _) -- line: 45
    return false
end

function t_1.StartSprinting(_, _) -- line: 49
    return false
end

function t_1.ReplicateFromServer(arg7, arg8, ...) -- line: 53
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Gun_m (copy)

    if arg8 == "PaintballSplatter" then
        if not arg7:IsRendered() then
            return
        end

        local v2, v3, v4 = ...

        if not v2 or not v3 or not v4 or v2:FuzzyEq(v3) then
            return
        end

        local raycastResult = Utility_m:Raycast(
            v2,
            v3,
            (v2 - v3).Magnitude + 1,
            { v4 },
            Enum.RaycastFilterType.Whitelist
        )

        if not raycastResult.Instance then
            return
        end

        arg7:_ImpactMarkers({ raycastResult })

        return
    else
        Gun_m.ReplicateFromServer(arg7, arg8, ...)

        return
    end
end

function t_1._ImpactMarker(arg9, arg10) -- line: 81
    -- upvalues:
    --  [1] ImpactMarkerSplat (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] t (copy)

    local v6 = if arg10.IsFromPaintGrenade then Color3.fromHSV(math.random(), 0.75, 1) else arg9.ViewModel:GetPaintballColor()
    local v7 = ImpactMarkerSplat.Size * (0.5 + 0.75 * math.random()) * 2

    for index = #arg9._impact_markers, 1, -1 do
        local v8 = arg9._impact_markers[index]

        if
            (v8.Position - arg10.Position).Magnitude <= v7.X / 2 + v8.Size.X / 2
            and v8.Size.Magnitude < 10
        then
            v7 += v8.Size
            v6:Lerp(v8.Decal.Color3, 0.5)
            v8.Decal.Transparency = 1
            BetterDebris_m:AddItem(v8, 1)
            table.remove(arg9._impact_markers, index)
        end
    end

    local v9 = ImpactMarkerSplat:Clone()
    v9.Decal.Color3 = v6
    v9.Decal.Texture = t[math.random(#t)]
    v9.Decal.ZIndex = 0.75 + 0.5 * math.random()
    v9.Attachment.Particles.Color = ColorSequence.new(v6)
    local minimum = math.min(v7.X, 10)
    local minimum_1 = math.min(v7.X, 10)
    v9.Size = Vector3.new(minimum, minimum_1, 0)
    v9.CFrame = CFrame.new(arg10.Position, arg10.Position + arg10.Normal) * CFrame.Angles(
        0,
        0,
        math.random() * 3.141592653589793 * 2
    )
    v9.Parent = arg10.Part or workspace
    arg9:_AddImpactMarker(v9, 10, 40)
    v6 = v7.Magnitude / ImpactMarkerSplat.Size.Magnitude
    v9.Attachment.Particles.Size = NumberSequence.new(
        {
            NumberSequenceKeypoint.new(0, 0.075 * v6, 0.05 * v6),
            NumberSequenceKeypoint.new(1, 0.05 * v6, 0.05 * v6)
        }
    )
    v9.Attachment.Particles:Emit(10)
    arg9.ViewModel:CustomImpactMarker(v9)

    if not arg10.IsFromPaintGrenade then
        arg9.ViewModel:PlaySplatSound(v9)
    end
end

function t_1._Tracers(arg11, arg12) -- line: 125
    -- upvalues:
    --  [1] Gun_m (copy)

    local t_6 = {
        Color = ColorSequence.new(arg11.ViewModel:GetPaintballColor()),
        BeamProperties = { LightEmission = 0, Brightness = 2 },
        MaxLength = 2,
        MaxLengthFirstPerson = 5
    }

    return Gun_m._Tracers(arg11, arg12, t_6)
end

function t_1._Init(arg13) -- line: 139
    arg13.ProjectileShot:Connect(function(_, arg15) -- line: 140
        -- upvalues:
        --  [1] arg13 (copy)

        if arg15.Name == "_paintballgun_grenade" then
            return
        end

        local v12 = arg13.ViewModel:GetPaintballColor()
        arg15.Ball.Color = v12
        arg15.Ball.Trail.Color = ColorSequence.new(v12)
    end)
end

return t_1
