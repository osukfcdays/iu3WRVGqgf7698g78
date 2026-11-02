local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local ClientItem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem
)
local TrajectoryVisual_m = require(Players.LocalPlayer.PlayerScripts.Modules.TrajectoryVisual)
local Throwables = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Throwables")
local cframe = CFrame.new(0.75, -0.5, 0)
local t = setmetatable({}, ClientItem_m)
t.__index = t

function t.new(...) -- line: 20
    -- upvalues:
    --  [1] ClientItem_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(ClientItem_m.new(...), t)
    t_1.ProjectileThrown = Signal_m.new()
    t_1._is_throwing = nil
    t_1._throw_type = nil
    t_1._throw_cooldown = 0
    t_1._throw_hash = 0
    t_1._trajectory_visual = nil
    local v2 = t_1.Info.CanCook

    if v2 then
        v2 = t_1.Info.DetonateDelay
    end

    t_1._cook_detonate_delay = v2
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 41
    return nil
end

function t.CanQuickAttack(arg2) -- line: 45
    local v3 = not arg2._is_throwing

    if v3 then
        v3 = if tick() > arg2._throw_cooldown then if (arg2:Get("Ammo") or math.huge) > 0 then not arg2:IsEquipping() else false else false
    end

    return v3
end

function t.StartShooting(arg3, arg4) -- line: 49
    if
        not arg4
        and (arg3._is_throwing or tick() < arg3._throw_cooldown or (arg3:Get("Ammo") or math.huge) <= 0 or arg3:IsEquipping())
    then
        return false
    end

    arg3._throw_type = "Throw"
    arg3:_StartThrow(
        "ThrowStart",
        "ThrowIdle",
        arg3.Info.ThrowMaxChargeTime,
        arg3.Info.ThrowForceMin,
        arg3.Info.ThrowForceMax,
        arg3.Info.ThrowGravity,
        "FinishShooting"
    )

    return true, "StartShooting"
end

function t.FinishShooting(arg5, arg6) -- line: 60
    if
        not arg6
        and (not arg5._is_throwing or tick() < arg5._throw_cooldown or (arg5:Get("Ammo") or math.huge) <= 0 or arg5._throw_type ~= "Throw")
    then
        return false
    end

    arg5._throw_type = nil
    local v4, v5 = arg5:_FinishThrow(
        "ThrowStart",
        "ThrowIdle",
        "ThrowFinish",
        arg5.Info.ThrowMaxChargeTime
    )

    if not v4 then
        return false
    end

    return true, "FinishShooting", arg5:_GetThrowCameraCFrame(), v4, v5
end

function t.StartAiming(arg7, arg8) -- line: 75
    if
        not arg8
        and (arg7._is_throwing or tick() < arg7._throw_cooldown or (arg7:Get("Ammo") or math.huge) <= 0 or arg7:IsEquipping())
    then
        return false
    end

    arg7._throw_type = "Lob"
    arg7:_StartThrow(
        "LobStart",
        "LobIdle",
        arg7.Info.LobMaxChargeTime,
        arg7.Info.LobForceMin,
        arg7.Info.LobForceMax,
        arg7.Info.LobGravity,
        "FinishAiming"
    )

    return true, "StartAiming"
end

function t.FinishAiming(arg9, arg10) -- line: 86
    if
        not arg10
        and (not arg9._is_throwing or tick() < arg9._throw_cooldown or (arg9:Get("Ammo") or math.huge) <= 0 or arg9._throw_type ~= "Lob")
    then
        return false
    end

    arg9._throw_type = nil
    local v7, v8 = arg9:_FinishThrow("LobStart", "LobIdle", "LobFinish", arg9.Info.LobMaxChargeTime)

    if not v7 then
        return false
    end

    return true, "FinishAiming", arg9:_GetThrowCameraCFrame(), v7, v8
end

function t.Unequip(arg11, ...) -- line: 101
    -- upvalues:
    --  [1] ClientItem_m (copy)

    arg11:_CancelThrow()
    ClientItem_m.Unequip(arg11, ...)
end

function t.ReplicateFromServer(arg12, arg13, ...) -- line: 106
    -- upvalues:
    --  [1] Throwables (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] WrapController_m (copy)
    --  [4] Spring_m (copy)
    --  [5] RunService (copy)
    --  [6] ClientItem_m (copy)

    if arg13 == "ThrowEffect" then
        if not arg12:IsRendered() then
            return
        end

        local v10 = ...

        if not v10 then
            return
        end

        v10.Transparency = 1
        v10.CanCollide = false
        local v13 = (Throwables:FindFirstChild(arg12.ViewModel.Name) or Throwables[arg12.Name]):Clone()
        v13.WorldPivot = v13.Primary.CFrame
        v13.Parent = workspace
        BetterDebris_m:AddItem(v13, arg12.Info.Lifetime + 10)
        WrapController_m:ApplyWrap(
            WrapController_m:RecordOriginalWrapProperties(v13),
            arg12:GetWrap(),
            true
        )

        for _, val in pairs(v13:GetChildren()) do
            val.CanCollide = false
            val.CanTouch = false
            val.CanQuery = false
            val.Anchored = true
        end

        arg12.ProjectileThrown:Fire(v10, v13)
        task.defer(function() -- line: 136
            -- upvalues:
            --  [1] arg12 (copy)
            --  [2] Spring_m (ref)
            --  [3] v10 (copy)
            --  [4] v13 (copy)
            --  [5] RunService (ref)
            --  [6] BetterDebris_m (ref)

            local v19 = arg12.ClientFighter:IsActuallyFirstPerson()
            local New = Spring_m.new
            New = New(
                v10.Position + (v19 and -v10.Velocity.Unit * 200 or Vector3.new(0, 0, 0)),
                1,
                40
            )
            local cframe_4 = CFrame.Angles(
                math.random() * 3.141592653589793 * 2,
                math.random() * 3.141592653589793 * 2,
                math.random() * 3.141592653589793 * 2
            )
            local now_1 = tick()
            local v21 = 0
            local v22 = 0
            local v24 = nil
            local ThrowableOrientation = nil

            local function update_throwable_orientation() -- line: 148
                -- upvalues:
                --  [1] ThrowableOrientation (ref)
                --  [2] v10 (ref)

                ThrowableOrientation = v10:GetAttribute("ThrowableOrientation")
            end

            v10:GetAttributeChangedSignal("ThrowableOrientation"):Connect(
                update_throwable_orientation
            )
            ThrowableOrientation = v10:GetAttribute("ThrowableOrientation")
            local cframe_1
            local v26, v27

            while true do
                if not v10:IsDescendantOf(workspace) then
                    break
                end

                local clampedValue = math.clamp((tick() - now_1) * 1.5, 0.01, 1)
                New.Speed = clampedValue * 60 + 40
                New.Target = v10.Position - workspace.CurrentCamera.CFrame.UpVector * (1 - clampedValue) * 0.5
                v21 += v10.Velocity.Magnitude * v22 * 0.25

                if v10.Velocity.Magnitude > 0.01 then
                    v26 = CFrame.new(New.Position, New.Position + v10.Velocity)

                    if not v26 then
                        cframe_1 = CFrame.new(New.Position)
                        v27 = v24 and v24.Rotation or CFrame.identity
                        v26 = cframe_1 * v27
                    end
                else
                    cframe_1 = CFrame.new(New.Position)
                    v27 = v24 and v24.Rotation or CFrame.identity
                    v26 = cframe_1 * v27
                end

                v24 = v26
                v26 = v24 * cframe_4 * CFrame.Angles(-v21, 0, 0)
                v26 = if not ThrowableOrientation then v26 else CFrame.new(v26.Position) * ThrowableOrientation.Rotation

                if
                    arg12.ViewModel.Name == "Skullbang"
                    and not v26.Position:FuzzyEq(workspace.CurrentCamera.CFrame.Position)
                then
                    v26 = v26:Lerp(
                        CFrame.new(v26.Position, workspace.CurrentCamera.CFrame.Position),
                        (math.min(1, 1.25 * (tick() - now_1) / arg12.Info.DetonateDelay))
                    )
                end

                v13:ScaleTo(clampedValue * 1.5)
                v13:PivotTo(v26)
                v22 = RunService.RenderStepped:Wait()
            end

            v24 = 0
            local v30 = pairs
            local _ = CFrame.Angles(-v21, 0, 0)

            for _, descendant in v30(v13:GetDescendants()) do
                if
                    descendant:IsA("BasePart")
                    or descendant:IsA("Texture")
                    or descendant:IsA("Beam")
                    or descendant:IsA("Decal")
                then
                    descendant.LocalTransparencyModifier = 1
                elseif descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false
                elseif descendant:IsA("Trail") then
                    v24 = math.max(v24, descendant.Lifetime)
                end
            end

            BetterDebris_m:AddItem(v13, v24)
        end)

        return
    else
        ClientItem_m.ReplicateFromServer(arg12, arg13, ...)

        return
    end
end

function t.Destroy(arg14) -- line: 198
    -- upvalues:
    --  [1] ClientItem_m (copy)

    arg14.ProjectileThrown:Destroy()
    arg14:_ClearTrajectoryVisual()
    ClientItem_m.Destroy(arg14)
end

function t._CancelThrow(arg15) -- line: 208
    arg15:_ClearTrajectoryVisual()

    if arg15._is_throwing then
        arg15._throw_type = nil
        arg15._is_throwing = nil
        arg15._throw_hash += 1
    end

    arg15.ViewModel:StopAnimation("ThrowStart")
    arg15.ViewModel:StopAnimation("ThrowIdle")
    arg15.ViewModel:StopAnimation("ThrowFinish")
    arg15.ViewModel:StopAnimation("LobStart")
    arg15.ViewModel:StopAnimation("LobIdle")
    arg15.ViewModel:StopAnimation("LobFinish", nil, 0)
end

function t._FinishThrow(
    arg16,
    arg17,
    arg18,
    arg19,
    arg20
) -- line: 225
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    arg16:_ClearTrajectoryVisual()
    local v32 = arg16._is_throwing

    if v32 then
        v32 = math.clamp((tick() - arg16._is_throwing) / arg20, 0, 1)
    end

    local v33 = arg16._is_throwing and (arg16._cook_detonate_delay and arg16._is_throwing + (arg16._cook_detonate_delay or 0) - tick() or arg16.Info.DetonateDelay)
    arg16._is_throwing = nil
    arg16._throw_cooldown = arg16.Info.Cooldown and tick() + arg16.Info.Cooldown or 0
    arg16._throw_hash += 1
    arg16.ViewModel:StopAnimation(arg17, nil, 0)
    arg16.ViewModel:StopAnimation(arg18, nil, 0)

    if not arg16._cook_detonate_delay or not v33 or v33 > 0 then
        arg16.ViewModel:PlayAnimation(
            arg19,
            AnimationLibrary_m.Info[arg16.ViewModel.Info.Animations[arg19]].Length
        )
    end

    if arg16.Info.Cooldown then
        arg16:CooldownEffect("rbxassetid://17156089790", arg16.Info.Cooldown, "Throw")
    end

    return v32, v33
end

function t._StartThrow(
    arg21,
    arg22,
    arg23,
    arg24,
    arg25,
    arg26,
    arg27,
    arg28
) -- line: 249
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    arg21._is_throwing = tick()
    arg21._throw_hash += 1
    arg21.ViewModel:StopAnimation("Equip")
    arg21.ViewModel:PlayAnimation(arg22, math.huge)

    if arg21.ClientFighter.IsLocalPlayer then
        arg21:_CreateTractoryVisual(arg24, arg25, arg26, arg27)
    end

    local ThrowHash = arg21._throw_hash
    task.spawn(function() -- line: 263
        -- upvalues:
        --  [1] AnimationLibrary_m (ref)
        --  [2] arg21 (copy)
        --  [3] arg22 (copy)
        --  [4] ThrowHash (copy)
        --  [5] arg23 (copy)

        wait(AnimationLibrary_m.Info[arg21.ViewModel.Info.Animations[arg22]].Length or 0.1)

        if ThrowHash ~= arg21._throw_hash then
            return
        end

        arg21.ViewModel:PlayAnimation(arg23, nil, 0)
    end)

    if arg21._cook_detonate_delay then
        task.delay(arg21._cook_detonate_delay, function() -- line: 275
            -- upvalues:
            --  [1] ThrowHash (copy)
            --  [2] arg21 (copy)
            --  [3] arg28 (copy)

            if ThrowHash ~= arg21._throw_hash then
                return
            end

            arg21:SimulateInputFromGameplayMechanic(arg28, true)
        end)
    end
end

function t._GetThrowCameraCFrame(arg29, arg30, arg31, arg32) -- line: 285
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] cframe (copy)

    local v35 = arg29.ClientFighter:GetCameraData(arg30, arg31, true)
    local v36 = v35[utf8.char(0)]
    local v37 = v35[utf8.char(1)]
    local v38 = v35[utf8.char(2)]
    local v39 = v35[utf8.char(3)]
    v35 = v38

    if v35 then
        v35 = v38.CFrame * (v39 or CFrame.identity)
    end

    local v42 = v35 and CFrame.new(v37.Position, v35.Position) or v37
    local raycastResult = Utility_m:Raycast(
        v42.Position,
        v42.Position + v42.LookVector * 999,
        999,
        arg30,
        Enum.RaycastFilterType.Include
    )
    v42 = CFrame.new(v36.Position, raycastResult.Position) * cframe

    if arg32 then
        return v42
    end

    return (Utility_m:EncodeCFrame(v42))
end

function t._ClearTrajectoryVisual(arg33) -- line: 296
    if arg33._trajectory_visual then
        arg33._trajectory_visual:Destroy()
        arg33._trajectory_visual = nil
    end
end

function t._CreateTractoryVisual(
    arg34,
    arg35,
    arg36,
    arg37,
    arg38
) -- line: 304
    -- upvalues:
    --  [1] TrajectoryVisual_m (copy)

    arg34:_ClearTrajectoryVisual()
    local v44 = arg34.ClientFighter:GetRaycastWhitelist(true)
    arg34._trajectory_visual = TrajectoryVisual_m.new()
    arg34._trajectory_visual:OnStep(function() -- line: 310
        -- upvalues:
        --  [1] arg34 (copy)
        --  [2] v44 (copy)
        --  [3] arg35 (copy)
        --  [4] arg36 (copy)
        --  [5] arg37 (copy)
        --  [6] arg38 (copy)

        local v45 = arg34:_GetThrowCameraCFrame(v44, nil, true)
        local now_3 = tick()
        local v46 = arg34._is_throwing or arg34._is_lobbing
        local v47 = math.clamp((now_3 - v46) / arg35, 0, 1)
        local v48 = arg36 + (arg37 - arg36) * v47
        v47 = if arg34._cook_detonate_delay then arg34._is_throwing + arg34._cook_detonate_delay - tick() else arg34.Info.DetonateDelay
        arg34._trajectory_visual:Update(
            v45.Position,
            v45.LookVector * v48,
            workspace.Gravity * 0.5 * arg38,
            nil,
            v44,
            v47
        )
    end)
end

function t._Init(arg39) -- line: 320
    table.insert(arg39._connections, arg39.ClientFighter.Interrupted:Connect(function() -- line: 321
        -- upvalues:
        --  [1] arg39 (copy)

        arg39:_CancelThrow()
    end))
end

return t
