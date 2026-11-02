local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.AirborneChanged = Signal_m.new()
    t_1.ClientFighterCharacter = arg1
    t_1.IsAirborne = false
    t_1._destroyed = false
    t_1._airborne_spring = nil
    t_1._airborne_velocity = nil
    t_1._airborne_start = 0
    t_1._effect_objects = {}
    t_1._animation_hash = 0
    t_1._animation_track = nil
    t_1._cleanup = {}
    t_1:_Init()

    return t_1
end

function t.IsActive(arg2) -- line: 41
    if arg2.ClientFighterCharacter.ClientFighter.IsLocalPlayer then
        return arg2.IsAirborne
    end

    return (arg2.ClientFighterCharacter:Get("IsAirborne"))
end

function t.Redirect(arg3, arg4, arg5) -- line: 45
    if not arg3._airborne_spring then
        return
    end

    local v1 = arg4 or arg3._airborne_spring.Target
    arg3._airborne_spring.Value = v1 * (arg5 or 1)
end

function t.Trigger(
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 56
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Spring_m (copy)
    --  [3] Utility_m (copy)
    --  [4] RunService (copy)

    if
        not arg6.ClientFighterCharacter.ClientFighter.IsLocalPlayer
        or arg7.Magnitude <= 0.01
        or arg6.ClientFighterCharacter:Get("IsFrozen")
        or arg6._airborne_velocity and arg9
    then
        return
    end

    local v2 = arg6._airborne_velocity and arg6._airborne_velocity.Velocity or Vector3.new(0, 0, 0)
    local v3 = arg6._airborne_velocity and arg6._airborne_velocity.Velocity or arg7
    local absoluteValue = math.abs(arg7.X)
    local absoluteValue_1 = math.abs(v2.X)
    local v4 = math.max(absoluteValue, absoluteValue_1) * math.sign(v3.X)
    local Y = arg7.Y
    local absoluteValue_2 = math.abs(arg7.Z)
    local absoluteValue_3 = math.abs(v2.Z)
    local maximum_1 = math.max(absoluteValue_2, absoluteValue_3)
    local vec3 = Vector3.new(v4, Y, maximum_1 * math.sign(v3.Z))

    if arg6._airborne_velocity then
        arg6._airborne_velocity:Destroy()
        arg6._airborne_velocity = nil
    end

    v3 = Instance.new("BodyVelocity")
    v3.MaxForce = Vector3.new(100000, 100000, 100000)
    v3.Velocity = Vector3.new(0, 0, 0)
    BetterDebris_m:AddItem(v3, 5)
    arg6._airborne_start = tick()
    arg6._airborne_velocity = v3
    arg6.ClientFighterCharacter.ClientFighter.StopSliding:Fire()
    arg6:_SetIsAirborne(true)
    local v5 = arg11 or 1
    local v6 = arg12 or 1
    local v7 = arg13 or 1
    task.spawn(function() -- line: 93
        -- upvalues:
        --  [1] v3 (copy)
        --  [2] arg6 (copy)
        --  [3] Spring_m (ref)
        --  [4] arg10 (copy)
        --  [5] vec3 (copy)
        --  [6] arg8 (copy)
        --  [7] arg14 (copy)
        --  [8] Utility_m (ref)
        --  [9] v5 (copy)
        --  [10] v6 (copy)
        --  [11] v7 (copy)
        --  [12] RunService (ref)

        v3.Parent = arg6.ClientFighterCharacter.RootPart
        local v8 = arg6
        local New = Spring_m.new
        local v9 = arg10 and arg10.Unit or vec3.Unit
        v8._airborne_spring = New(v9, 1, arg8)
        local v10: Vector3 = arg10 and arg10.Magnitude or (vec3 * Vector3.new(1, 0, 1)).Magnitude
        local now = tick()
        local v11 = now + (arg14 or math.huge)
        local v12 = nil
        local Position = nil
        local v14 = false

        while true do
            if
                not (v11 > tick())
                or arg6._destroyed
                or v3 ~= arg6._airborne_velocity
                or not v3:IsDescendantOf(arg6.ClientFighterCharacter.RootPart)
                or not arg6.ClientFighterCharacter:IsAlive()
                or tick() - now > 0.2 and arg6.ClientFighterCharacter.RootPart.Velocity.Magnitude < 5
            then
                break
            end

            if not v14 and tick() - now > 0.2 then
                v14 = true
                local v15 = v3
                v15.MaxForce *= Vector3.new(0.1, 1, 0.1)
            end

            local v16, v17 = arg6.ClientFighterCharacter:GetFloor()
            local v18 = v16

            if v18 then
                v18 = Utility_m:AngleBetweenVectors(Vector3.new(0, 1, 0), v17.Normal) < 0.1308996938995747 and true
            end

            if tick() - now > 0.2 and v18 then
                if vec3.Y < 0 then
                    break
                end

                if not v12 then
                    v12 = tick()
                elseif tick() - v12 > 1 then
                    break
                end
            else
                v12 = nil
            end

            if not Position or math.abs(
                arg6.ClientFighterCharacter.RootPart.Position.Y - Position.Y
            ) > 1 then
                Position = arg6.ClientFighterCharacter.RootPart.Position
            elseif
                v18
                and ((Position - arg6.ClientFighterCharacter.RootPart.Position) * Vector3.new(1, 0, 1)).Magnitude > 8
            then
                break
            end

            arg6._airborne_spring.Target = arg6.ClientFighterCharacter.ClientFighter:GetMoveVector(
                true,
                true
            )
            v18 = arg6._airborne_spring.Value * Vector3.new(1, 0, 1) * v10 + Vector3.new(
                0,
                vec3.Y,
                0
            )
            v3.Velocity = v18 * (1 + (v5 - 1) * math.clamp((tick() - now) / v6, 0, 1)) * (16 / arg6.ClientFighterCharacter.RootPart.AssemblyMass)

            if v3.MaxForce.Y > 0 and tick() - now > 0.2 then
                local v21 = v3
                v21.MaxForce = v21.MaxForce * Vector3.new(1, 1 - v7, 1)
            end

            RunService.Heartbeat:Wait()
        end

        if arg6._airborne_velocity ~= v3 then
            return
        end

        arg6:Cancel()
    end)
end

function t.Cancel(arg15) -- line: 169
    if not arg15.ClientFighterCharacter.ClientFighter.IsLocalPlayer then
        return
    end

    arg15._airborne_spring = nil

    if arg15._airborne_velocity then
        arg15._airborne_velocity:Destroy()
        arg15._airborne_velocity = nil
    end

    arg15:_SetIsAirborne(false)
end

function t.FromServer(
    arg16,
    arg17,
    arg18,
    arg19,
    arg20
) -- line: 184
    if not arg16.ClientFighterCharacter.ClientFighter.IsLocalPlayer then
        return
    end

    if arg20 then
        arg16:Cancel()
    end

    arg16:Trigger(
        arg17 * 0.75,
        arg19 or 4,
        nil,
        nil,
        nil,
        nil,
        nil,
        arg18
    )
end

function t.Update(_, _, _) -- line: 196
end

function t.Destroy(arg24) -- line: 200
    arg24._destroyed = true

    for _, val in pairs(arg24._cleanup) do
        val:Destroy()
    end

    arg24.AirborneChanged:Destroy()
    arg24:Cancel()
end

function t._UpdateEffect(arg25) -- line: 216
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    for _, val_1 in pairs(arg25._effect_objects) do
        if val_1:IsA("Trail") then
            val_1.Enabled = false
        end

        BetterDebris_m:AddItem(val_1, 0.25)
    end

    arg25._effect_objects = {}

    if
        not arg25:IsActive()
        or arg25.ClientFighterCharacter.ClientFighter:Get("IsHiddenByEmotes")
        or arg25.ClientFighterCharacter.ClientFighter:Get("IsHiddenByCutscene")
    then
        return
    end

    local Airborne0_Attachment = Instance.new("Attachment")
    Airborne0_Attachment.Position = Vector3.new(-0.5, -2.9, 0)
    Airborne0_Attachment.Name = "Airborne0"
    Airborne0_Attachment.Parent = arg25.ClientFighterCharacter.RootPart
    table.insert(arg25._effect_objects, Airborne0_Attachment)
    local Attachment_1 = Instance.new("Attachment")
    Attachment_1.Position = Vector3.new(0.5, -2.9, 0)
    Attachment_1.Name = "Airborne1"
    Attachment_1.Parent = arg25.ClientFighterCharacter.RootPart
    table.insert(arg25._effect_objects, Attachment_1)
    local Trail = Instance.new("Trail")
    Trail.Transparency = NumberSequence.new(1, 0)
    Trail.WidthScale = NumberSequence.new(1, 0)
    Trail.LightEmission = 1
    Trail.FaceCamera = true
    Trail.Lifetime = 0.25
    Trail.Attachment0 = Airborne0_Attachment
    Trail.Attachment1 = Attachment_1
    Trail.Parent = arg25.ClientFighterCharacter.RootPart
    table.insert(arg25._effect_objects, Trail)
end

function t._UpdateAnimation(arg26) -- line: 255
    -- upvalues:
    --  [1] PreloadController_m (copy)

    if not arg26.ClientFighterCharacter.ClientFighter.IsLocalPlayer then
        return
    end

    local v23 = arg26:IsActive()
    local v24 = if v23 then 0 else nil

    if arg26._animation_track then
        arg26._animation_track:Stop(v24)
        arg26._animation_track:Destroy()
        arg26._animation_track = nil
    end

    arg26._animation_hash += 1

    if not v23 then
        return
    end

    local AnimationHash = arg26._animation_hash
    local Success, Result = pcall(
        arg26.ClientFighterCharacter.Humanoid.LoadAnimation,
        arg26.ClientFighterCharacter.Humanoid,
        PreloadController_m:GetPreloadedAnimation("SlidingJump")
    )

    if not Success then
        return
    end

    table.insert(arg26._cleanup, Result)
    Result:Play(0)
    arg26.ClientFighterCharacter:DisableIKArms(1, true)
    task.delay(0.18333333333333332, function() -- line: 286
        -- upvalues:
        --  [1] AnimationHash (copy)
        --  [2] arg26 (copy)
        --  [3] PreloadController_m (ref)

        if AnimationHash ~= arg26._animation_hash or not arg26.ClientFighterCharacter:IsAlive() then
            return
        end

        local Success_1, Result_1 = pcall(
            arg26.ClientFighterCharacter.Humanoid.LoadAnimation,
            arg26.ClientFighterCharacter.Humanoid,
            PreloadController_m:GetPreloadedAnimation("SlidingJumpFall")
        )

        if Success_1 then
            table.insert(arg26._cleanup, Result_1)
            arg26._animation_track = Result_1
            arg26._animation_track:Play(0)
        end
    end)
end

function t._SetIsAirborne(arg27, arg28) -- line: 301
    arg27.IsAirborne = arg28
    arg27.AirborneChanged:Fire()
end

function t._Init(arg29) -- line: 306
    arg29.AirborneChanged:Connect(function() -- line: 307
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateAnimation()
        arg29:_UpdateEffect()
    end)
    arg29.ClientFighterCharacter:GetDataChangedSignal("IsFrozen"):Connect(function() -- line: 312
        -- upvalues:
        --  [1] arg29 (copy)

        if arg29.ClientFighterCharacter:Get("IsFrozen") then
            arg29:Cancel()
        end
    end)
    arg29.ClientFighterCharacter:AddConnection(arg29.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsHiddenByEmotes"
    ):Connect(function() -- line: 318
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateEffect()
    end))
    arg29.ClientFighterCharacter:AddConnection(arg29.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsHiddenByCutscene"
    ):Connect(function() -- line: 322
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateEffect()
    end))

    if arg29.ClientFighterCharacter.ClientFighter.IsLocalPlayer then
        arg29.ClientFighterCharacter:AddConnection(arg29.ClientFighterCharacter.Humanoid.StateChanged:Connect(
            function(_, arg31) -- line: 327
                -- upvalues:
                --  [1] arg29 (copy)

                if
                    arg29._airborne_velocity
                    and not arg29.ClientFighterCharacter:IsHumanoidStateAirborne(arg31)
                    and tick() > arg29._airborne_start + 0.1
                then
                    arg29:Cancel()
                end
            end
        ))

        return
    end

    arg29.ClientFighterCharacter:GetDataChangedSignal("IsAirborne"):Connect(function() -- line: 333
        -- upvalues:
        --  [1] arg29 (copy)

        arg29:_UpdateEffect()
    end)
end

return t
