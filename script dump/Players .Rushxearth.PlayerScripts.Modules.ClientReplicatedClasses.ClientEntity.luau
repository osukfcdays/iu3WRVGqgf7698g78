local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local SlowParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.SlowParticles
local Finishers = ReplicatedStorage.Modules.Finishers
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc.InvincibilityParticles.Attachment
local ExtinguishParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.ExtinguishParticles
local FreezeEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.FreezeEffects
local BurningEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.BurningEffects
local BlipEffects = Players.LocalPlayer.PlayerScripts.Assets.Misc.BlipEffects
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t.new(arg1) -- line: 26
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(arg1), t)
    t_1.Died = Signal_m.new()
    t_1.HealthChanged = Signal_m.new()
    t_1.BurnEffectPlaying = Signal_m.new()
    t_1.Model = arg1.Model
    t_1.RootPart = arg1.RootPart
    t_1.AimAssistBlacklist = false
    t_1._destroyed = nil
    t_1._is_hidden = nil
    t_1._is_dead = nil
    t_1._connections = {}
    t_1._hurt_effect_hash = 0
    t_1._hitboxes = {}
    t_1._hitboxes_small = {}
    t_1._burn_effect_finish = 0
    t_1._burn_effect_sound = nil
    t_1._burn_effect_particles = {}
    t_1._model_original_parent_hurt_effect = nil
    t_1._thaw_callback = nil
    t_1._thaw_highlight = nil
    t_1._current_finisher = nil
    t_1._invincibility_visual = nil
    t_1._headshot_particles = nil
    t_1._permafrost_slow_particles = nil
    t_1:_Init()

    return t_1
end

function t.IsRendered(arg2) -- line: 70
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    local v2 = CONSTANTS_m.SHOULD_ALWAYS_REPLICATE()

    if not v2 then
        if arg2.ClientFighter then
            return (arg2.ClientFighter:IsRendered())
        end

        v2 = (workspace.CurrentCamera.CFrame.Position - arg2.RootPart.Position).Magnitude < CONSTANTS_m.RENDER_DISTANCE
    end

    return v2
end

function t.IsAlive(arg3) -- line: 74
    local v3 = not arg3._destroyed

    if v3 then
        v3 = not arg3._is_dead

        if v3 then
            v3 = arg3:GetHealth() > 0 and true
        end
    end

    return v3
end

function t.IsHidden(arg4) -- line: 78
    return arg4._is_hidden
end

function t.GetScreenPoint(arg5) -- line: 82
    return workspace.CurrentCamera:WorldToScreenPoint(arg5.RootPart.Position)
end

function t.GetHitboxes(arg6, arg7) -- line: 86
    return arg7 and #arg6._hitboxes_small > 0 and arg6._hitboxes_small or arg6._hitboxes
end

function t.SetHidden(arg8, arg9) -- line: 90
    arg8._is_hidden = arg9
end

function t.ReplicateFromServer(arg10, arg11, ...) -- line: 94
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    if arg11 == "BurnEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_BurnEffect(...)

        return
    elseif arg11 == "ExtinguishEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_ExtinguishEffect(...)

        return
    elseif arg11 == "HurtEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_HurtEffect(...)

        return
    elseif arg11 == "HealEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_HealEffect(...)

        return
    elseif arg11 == "FreezeEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_FreezeEffect(...)

        return
    elseif arg11 == "ThawFreezeEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_ThawFreezeEffect(...)

        return
    elseif arg11 == "FinisherEffect" then
        if not arg10:IsRendered() then
            return
        end

        local v5, v6, v7, v8 = ...
        arg10:_PlayFinisher(arg10:FromEnum(v5), v6, v7, v8)

        return
    elseif arg11 == "BlipEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_BlipEffect(...)

        return
    elseif arg11 == "SlowEffect" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_SlowEffect(...)

        return
    elseif arg11 == "CreateSound" then
        if not arg10:IsRendered() then
            return
        end

        arg10:_CreateSound(...)

        return
    else
        if arg11 == "Died" then
            arg10._is_dead = true
            arg10.Died:Fire()

            return
        end

        ReplicatedClass_m.ReplicateFromServer(arg10, arg11, ...)

        return
    end
end

function t.Destroy(arg12) -- line: 165
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    arg12._destroyed = true

    for _, val in pairs(arg12._connections) do
        val:Disconnect()
    end

    arg12._hitboxes = {}
    arg12._hitboxes_small = {}
    arg12.Died:Destroy()
    arg12.HealthChanged:Destroy()
    arg12.BurnEffectPlaying:Destroy()

    if arg12.Model then
        arg12.Model:Destroy()
    end

    if arg12._current_finisher then
        arg12._current_finisher:Destroy()
        arg12._current_finisher = nil
    end

    ReplicatedClass_m.Destroy(arg12)
end

function t._CreateSound(
    arg13,
    arg14,
    arg15,
    arg16,
    arg17,
    arg18
) -- line: 195
    -- upvalues:
    --  [1] Utility_m (copy)

    local v10 = if not arg18 then 1 else 2
    local v11 = arg15 * v10
    v10 = if not arg18 then nil else 400
    local v13 = Utility_m:CreateSound(
        arg14,
        v11,
        arg16,
        arg13.RootPart,
        true,
        15,
        v10,
        v10
    )

    if arg17 and arg17 ~= 1 then
        v10 = Instance.new("PitchShiftSoundEffect")
        v10.Octave = arg17
        v10.Parent = v13
    end
end

function t._UpdatePermafrostSlowStacks(arg19) -- line: 208
    -- upvalues:
    --  [1] SlowParticles (copy)

    if arg19._permafrost_slow_highlight then
        arg19._permafrost_slow_highlight:Destroy()
        arg19._permafrost_slow_highlight = nil
    end

    if not arg19:IsAlive() then
        return
    end

    local v14 = arg19:IsAlive()

    if v14 then
        v14 = arg19:Get("ReplicatedExternalGameplayData")

        if v14 then
            v14 = arg19:Get("ReplicatedExternalGameplayData").PermafrostSlowStacks
        end
    end

    local v15 = v14 and v14.Stacks or 0
    local v16 = v14 and v14.MaxStacks or 0
    v14 = v15 / math.max(1, v16)

    if v14 <= 0 then
        local v17 = pairs
        local v18 = arg19._permafrost_slow_particles or {}

        for _, val_1 in v17(v18) do
            val_1:Destroy()
        end

        arg19._permafrost_slow_particles = nil

        return
    end

    if not arg19._permafrost_slow_particles then
        arg19._permafrost_slow_particles = {}

        for _, val_2 in pairs(SlowParticles:GetChildren()) do
            v16 = val_2:Clone()
            v16.Parent = arg19.RootPart
            table.insert(arg19._permafrost_slow_particles, v16)
        end
    end

    for _, val_3 in pairs(arg19._permafrost_slow_particles) do
        val_3.LocalTransparencyModifier = 1 + -1 * v14
    end
end

function t._UpdateInvincibilityVisual(arg20) -- line: 248
    -- upvalues:
    --  [1] Attachment (copy)

    if not arg20:Get("IsInvincible") and arg20._invincibility_visual then
        arg20._invincibility_visual:Destroy()
        arg20._invincibility_visual = nil

        return
    end

    if arg20:Get("IsInvincible") and not arg20._invincibility_visual then
        arg20._invincibility_visual = Attachment:Clone()
        arg20._invincibility_visual.Parent = arg20.RootPart
    end
end

function t._PlayFinisher(
    arg21,
    arg22,
    arg23,
    arg24,
    arg25
) -- line: 258
    -- upvalues:
    --  [1] Finishers (copy)
    --  [2] CONSTANTS_m (copy)

    local v20 = arg21.Humanoid or arg21.RootPart

    if not v20 or not v20:IsDescendantOf(workspace) then
        return
    end

    if arg21._current_finisher then
        arg21._current_finisher:Destroy()
    end

    arg21._current_finisher = require(Finishers[arg22]).new(v20, arg23, arg24)
    arg21._current_finisher:SetSerial(arg25)

    if CONSTANTS_m.IS_STUDIO then
        arg21._current_finisher:PlayClient()

        return
    end

    pcall(arg21._current_finisher.PlayClient, arg21._current_finisher)
end

function t._SlowEffect(arg26, arg27) -- line: 279
    -- upvalues:
    --  [1] SlowParticles (copy)
    --  [2] BetterDebris_m (copy)

    for _, child in pairs(SlowParticles:GetChildren()) do
        local v22 = child:Clone()
        v22.Parent = arg26.RootPart
        BetterDebris_m:AddItem(v22, arg27)
    end
end

function t._BlipEffect(
    arg28,
    arg29,
    arg30,
    arg31,
    arg32
) -- line: 287
    -- upvalues:
    --  [1] BlipEffects (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] WrapController_m (copy)

    local v23 = arg32

    if v23 then
        v23 = arg28.ClientFighter

        if v23 then
            v23 = arg28.ClientFighter:GetItem(arg32)
        end
    end

    local v24 = v23

    if v24 then
        v24 = v23:GetWrap()
    end

    for _, val_4 in pairs({ arg29, arg30 }) do
        local v25 = BlipEffects:FindFirstChild(arg31) or BlipEffects.Default
        v23 = v25:Clone()
        v25 = val_4 or arg28.RootPart.CFrame
        v23.CFrame = v25
        v23.Parent = workspace
        BetterDebris_m:AddItem(v23, 5)
        Utility_m:PlayParticles(v23)

        if v24 then
            WrapController_m:ApplyWrap(
                WrapController_m:RecordOriginalWrapProperties(v23),
                v24,
                true
            )
        end
    end

    Utility_m:CreateSound(
        "rbxassetid://123181974576488",
        1,
        1.5 + 0.2 * math.random(),
        arg28.RootPart,
        true,
        5
    )
end

function t._ThawFreezeEffect(arg33, arg34) -- line: 306
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)

    if arg33._thaw_highlight then
        arg33._thaw_highlight:Destroy()
        arg33._thaw_highlight = nil
    end

    if arg34 and arg34 > 0 then
        arg33._thaw_highlight = Instance.new("Highlight")
        arg33._thaw_highlight.FillColor = Color3.fromRGB(161, 222, 255)
        arg33._thaw_highlight.OutlineColor = Color3.fromRGB(0, 200, 255)
        arg33._thaw_highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        arg33._thaw_highlight.Adornee = arg33.Model
        arg33._thaw_highlight.Parent = arg33.Model
        BetterDebris_m:AddItem(arg33._thaw_highlight, arg34)
        task.spawn(function() -- line: 321
            -- upvalues:
            --  [1] arg33 (copy)
            --  [2] arg34 (copy)
            --  [3] RunService (ref)

            local ThawHighlight_2 = arg33._thaw_highlight
            local now = tick()

            while true do
                if not (tick() < now + arg34) then
                    break
                end

                local v30 = ((tick() - now) / arg34) ^ 4
                ThawHighlight_2.FillTransparency = 0.5 + 0.5 * v30
                ThawHighlight_2.OutlineTransparency = 0 + 1 * v30
                RunService.RenderStepped:Wait()
            end
        end)
    end

    if arg33._thaw_callback then
        pcall(arg33._thaw_callback, arg33)
        arg33._thaw_callback = nil
    end
end

function t._FreezeEffect(arg35, arg36, arg37) -- line: 342
    -- upvalues:
    --  [1] FreezeEffects (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    arg35:_ThawFreezeEffect()
    local v31 = (FreezeEffects:FindFirstChild(arg37 or "Default") or FreezeEffects.Default):Clone()
    v31.PrimaryPart = v31.Primary

    for _, descendant in pairs(v31:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.CanTouch = false
            descendant.Massless = true
            descendant.Anchored = false

            if descendant ~= v31.PrimaryPart then
                local WeldConstraint = Instance.new("WeldConstraint")
                WeldConstraint.Part0 = v31.PrimaryPart
                WeldConstraint.Part1 = descendant
                WeldConstraint.Parent = v31.PrimaryPart
            end
        end
    end

    v31:SetPrimaryPartCFrame(arg35.RootPart.CFrame)
    v31.Parent = workspace
    BetterDebris_m:AddItem(v31, arg36 + 3)
    local WeldConstraint_1 = Instance.new("WeldConstraint")
    WeldConstraint_1.Part0 = arg35.RootPart
    WeldConstraint_1.Part1 = v31.PrimaryPart
    WeldConstraint_1.Parent = v31

    if arg37 == "Bubble" or arg37 == "Gum" then
        function arg35._thaw_callback() -- line: 380
            -- upvalues:
            --  [1] v31 (copy)
            --  [2] BetterDebris_m (ref)
            --  [3] Utility_m (ref)

            if not v31.PrimaryPart then
                v31:Destroy()

                return
            end

            BetterDebris_m:AddItem(v31, 2)
            local v34 = v31.PrimaryPart
            local v35 = Utility_m

            if v34 then
                v34 = v31.PrimaryPart.Position
            end

            v35:CreateSound(
                "rbxassetid://18763517194",
                1,
                1,
                v34,
                true,
                10
            )
            local Size = v31.PrimaryPart.Size
            Utility_m:RenderstepForLoop(0, 100, 10, function(arg38) -- line: 391
                -- upvalues:
                --  [1] v31 (ref)
                --  [2] Size (copy)

                if not v31.PrimaryPart then
                    return true
                end

                local v36 = 1 - (1 - arg38 / 100) ^ 3
                v31.PrimaryPart.Transparency = 0.5 + 0.5 * v36
                v31.PrimaryPart.Size = Size * (1 + 2 * v36)
            end)
            v31:Destroy()
        end
    elseif arg37 == "Temporal" then
        Utility_m:CreateSound(
            "rbxassetid://18431054727",
            1.5,
            1 + 0.1 * math.random(),
            v31.PrimaryPart,
            true,
            10
        )
        Utility_m:CreateSound(
            "rbxassetid://8571334160",
            0.75,
            1.2,
            v31.PrimaryPart,
            true,
            10
        )

        function arg35._thaw_callback() -- line: 408
            -- upvalues:
            --  [1] v31 (copy)
            --  [2] BetterDebris_m (ref)
            --  [3] Utility_m (ref)

            if not v31.PrimaryPart then
                v31:Destroy()

                return
            end

            BetterDebris_m:AddItem(v31, 2)
            local v39 = v31.PrimaryPart
            local v40 = Utility_m

            if v39 then
                v39 = v31.PrimaryPart.Position
            end

            v40:CreateSound(
                "rbxassetid://8571436177",
                0.5,
                2,
                v39,
                true,
                10
            )
            local Size_1 = v31.PrimaryPart.Size
            Utility_m:RenderstepForLoop(0, 100, 5, function(arg39) -- line: 419
                -- upvalues:
                --  [1] v31 (ref)
                --  [2] Size_1 (copy)

                if not v31.PrimaryPart then
                    return true
                end

                local v41 = (arg39 / 100) ^ 3
                v31.PrimaryPart.Transparency = v41
                v31.PrimaryPart.Size = Size_1 * (1 + 2 * v41)
            end)
            v31:Destroy()
        end
    elseif arg37 == "Cocoon" then
        function arg35._thaw_callback() -- line: 433
            -- upvalues:
            --  [1] v31 (copy)
            --  [2] BetterDebris_m (ref)
            --  [3] Utility_m (ref)

            local Cocoon = v31:FindFirstChild("Cocoon")

            if not Cocoon then
                v31:Destroy()

                return
            end

            Cocoon.Transparency = 1
            BetterDebris_m:AddItem(v31, 2)
            Utility_m:PlayParticles(Cocoon)
        end
    elseif arg37 == "SandBucket" then
        function arg35._thaw_callback() -- line: 446
            -- upvalues:
            --  [1] v31 (copy)

            v31:Destroy()
        end
    elseif arg37 == "Wires" or arg37 == "Ropes" or arg37 == "WhiteWires" or arg37 == "PurpleWires" then
        function arg35._thaw_callback() -- line: 450
            -- upvalues:
            --  [1] v31 (copy)

            v31:Destroy()
        end
    elseif arg37 == "Selection" then
        function arg35._thaw_callback() -- line: 454
            -- upvalues:
            --  [1] v31 (copy)

            v31:Destroy()
        end
    elseif arg37 == "Starforge" then
        function arg35._thaw_callback() -- line: 458
            -- upvalues:
            --  [1] v31 (copy)

            v31:Destroy()
        end
    elseif arg37 == "UFOBeam" then
        function arg35._thaw_callback() -- line: 462
            -- upvalues:
            --  [1] v31 (copy)

            v31:Destroy()
        end
    else
        if arg37 == "Wrapped" then
            Utility_m:CreateSound(
                "rbxassetid://74885181688460",
                0.875,
                1 + 0.1 * math.random(),
                v31.PrimaryPart,
                true,
                5
            )
        else
            Utility_m:CreateSound(
                "rbxassetid://18429138544",
                0.75,
                2 + 0.5 * math.random(),
                v31.PrimaryPart,
                true,
                10
            )
        end

        function arg35._thaw_callback() -- line: 472
            -- upvalues:
            --  [1] v31 (copy)
            --  [2] BetterDebris_m (ref)
            --  [3] arg37 (copy)
            --  [4] Utility_m (ref)

            if not v31.PrimaryPart then
                v31:Destroy()

                return
            end

            BetterDebris_m:AddItem(v31, 2)
            local Position = v31.PrimaryPart.Position
            v31.PrimaryPart:Destroy()

            for _, val_5 in pairs(v31:GetChildren()) do
                if val_5:IsA("BasePart") then
                    val_5.Velocity = CFrame.new(Position, val_5.Position).LookVector * (25 + 25 * math.random())
                    local Angles = CFrame.Angles
                    local v47 = math.random() * 3.141592653589793 * 2
                    val_5.RotVelocity = Angles(
                        v47,
                        math.random() * 3.141592653589793 * 2,
                        math.random() * 3.141592653589793 * 2
                    ).LookVector * (10 + 10 * math.random())
                end
            end

            if arg37 == "Wrapped" then
                Utility_m:CreateSound(
                    "rbxassetid://121822631205080",
                    0.875,
                    1,
                    Position,
                    true,
                    10
                )

                return
            end

            Utility_m:CreateSound(
                "rbxassetid://135970869546121",
                0.875,
                1,
                Position,
                true,
                10
            )
        end
    end

    local ThawCallback = arg35._thaw_callback
    task.delay(arg36, function() -- line: 501
        -- upvalues:
        --  [1] arg35 (copy)
        --  [2] ThawCallback (copy)

        if arg35._thaw_callback ~= ThawCallback then
            return
        end

        arg35._thaw_callback = nil
        ThawCallback()
    end)
end

function t._ExtinguishEffect(arg40) -- line: 511
    -- upvalues:
    --  [1] ExtinguishParticles (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    for _, val_6 in pairs(arg40._burn_effect_particles) do
        val_6:Destroy()
    end

    arg40._burn_effect_particles = {}
    arg40._burn_effect_finish = 0

    if arg40._burn_effect_sound then
        arg40._burn_effect_sound:Destroy()
        arg40._burn_effect_sound = nil
    end

    local v49 = ExtinguishParticles:Clone()
    v49.CFrame = arg40.RootPart.CFrame
    v49.Parent = workspace
    BetterDebris_m:AddItem(v49, 10)
    Utility_m:CreateSound(
        "rbxassetid://16812185839",
        0.75,
        1.3 + 0.2 * math.random(),
        v49,
        true
    )
    Utility_m:CreateSound(
        "rbxassetid://16812389263",
        0.75,
        1.3 + 0.2 * math.random(),
        v49,
        true
    )
    Utility_m:PlayParticles(v49.Attachment)
end

function t._BurnEffect(arg41, arg42, arg43, arg44) -- line: 535
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] BurningEffects (copy)
    --  [3] BetterDebris_m (copy)
    --  [4] WrapController_m (copy)

    local v54 = arg43

    if v54 then
        v54 = arg41:FromEnum(arg43)
    end

    local v55 = tick() < arg41._burn_effect_finish

    if arg41._burn_effect_sound then
        arg41._burn_effect_sound:Destroy()
    end

    arg41._burn_effect_sound = Utility_m:CreateSound(
        "rbxassetid://13702989275",
        0.25,
        0.9 + 0.2 * math.random(),
        arg41.RootPart,
        true,
        10
    )
    arg41._burn_effect_finish = tick() + arg42

    if v55 then
        return
    end

    v55 = arg41.RootPart.Size.Y / 2
    local t_3 = {}
    local v58 = pairs
    local v59 = BurningEffects:FindFirstChild(v54 or "Default") or BurningEffects.Default

    for _, val_7 in v58(v59:GetChildren()) do
        if val_7:IsA("ParticleEmitter") then
            local v60 = val_7:Clone()
            v60.Parent = arg41.RootPart
            table.insert(t_3, v60)
            Utility_m:ScaleParticleEmitter(v60, v55)
        elseif val_7:IsA("Light") then
            local v61 = val_7:Clone()
            v61.Range *= v55
            v61.Parent = arg41.RootPart
            BetterDebris_m:AddItem(v61, arg42 + 4)
            table.insert(t_3, v61)
        end
    end

    if arg44 then
        WrapController_m:ApplyWrap(WrapController_m:RecordOriginalWrapProperties(t_3), arg44, true)
    end

    arg41._burn_effect_particles = t_3
    arg41.BurnEffectPlaying:Fire(arg41._burn_effect_particles)

    while true do
        if not (tick() < arg41._burn_effect_finish) then
            break
        end

        wait(arg41._burn_effect_finish - tick())
    end

    for _, val_8 in pairs(t_3) do
        if val_8:IsA("ParticleEmitter") then
            val_8.Enabled = false
            BetterDebris_m:AddItem(val_8, val_8.Lifetime.Max / val_8.TimeScale)
        elseif val_8:IsA("Light") then
            task.spawn(function() -- line: 584
                -- upvalues:
                --  [1] val_8 (copy)
                --  [2] Utility_m (ref)

                local Brightness = val_8.Brightness
                Utility_m:RenderstepForLoop(0, 100, 1, function(arg45) -- line: 587
                    -- upvalues:
                    --  [1] val_8 (ref)
                    --  [2] Brightness (copy)

                    val_8.Brightness = Brightness * (1 - arg45 / 100)
                end)
                val_8:Destroy()
            end)
        end
    end

    arg41._burn_effect_sound = nil
end

function t._HealEffect(arg46) -- line: 601
    -- upvalues:
    --  [1] Utility_m (copy)

    local Highlight = Instance.new("Highlight")
    Highlight.FillColor = Color3.fromRGB(100, 255, 50)
    Highlight.OutlineColor = Color3.fromRGB(179, 255, 153)
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = arg46.Model
    Highlight.Parent = arg46.Model
    Utility_m:RenderstepForLoop(0, 100, 2, function(arg47) -- line: 609
        -- upvalues:
        --  [1] Highlight (copy)

        local v66 = arg47 / 100
        Highlight.OutlineTransparency = v66
        Highlight.FillTransparency = v66
    end)
    Highlight:Destroy()
end

function t._HurtEffect(arg48, arg49) -- line: 620
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] GameplayUtility_m (copy)

    if math.abs(arg49[utf8.char(0)] or 0) < 0.001 then
        return
    end

    if arg49[utf8.char(1)] and not arg48._is_hidden and arg48._headshot_particles then
        Utility_m:PlayParticles(arg48._headshot_particles)
    end

    if #GameplayUtility_m:GetSmokeCloudsInSphere(arg48.RootPart.Position) > 0 then
        return
    end

    arg48._hurt_effect_hash += 1

    if not arg48.Model.Parent then
        return
    end

    local v67 = arg48._model_original_parent_hurt_effect
    local HurtEffectHash = arg48._hurt_effect_hash

    if not v67 then
        v67 = arg48.Model.Parent
    end

    arg48._model_original_parent_hurt_effect = v67
    arg48.Model.Parent = workspace.HurtEffect
    workspace.HurtEffect:SetAttribute(
        "PlayHurtEffect",
        workspace.HurtEffect:GetAttribute("PlayHurtEffect") + 1
    )
    wait(1)

    if arg48._hurt_effect_hash ~= HurtEffectHash or not arg48.Model.Parent then
        return
    end

    arg48.Model.Parent = arg48._model_original_parent_hurt_effect
    arg48._model_original_parent_hurt_effect = nil
end

function t._PotentialHitboxAdded(arg50, arg51) -- line: 655
    -- upvalues:
    --  [1] CollectionService (copy)

    if not arg51:IsA("BasePart") then
        return
    end

    local function check() -- line: 660
        -- upvalues:
        --  [1] arg50 (copy)
        --  [2] arg51 (copy)
        --  [3] CollectionService (ref)

        local index = table.find(arg50._hitboxes_small, arg51)
        local index_1 = table.find(arg50._hitboxes, arg51)

        if index then
            table.remove(arg50._hitboxes_small, index)
        end

        if index_1 then
            table.remove(arg50._hitboxes, index_1)
        end

        if CollectionService:HasTag(arg51, "EntityHitbox") then
            table.insert(
                if arg51:GetAttribute("IsSmallHitbox") then arg50._hitboxes_small else arg50._hitboxes,
                arg51
            )
        end
    end

    arg51:GetAttributeChangedSignal("EntityHitboxUpdate"):Connect(check)
    check()
end

function t._Setup(arg52) -- line: 683
    if arg52.Model then
        arg52.Model.DescendantAdded:Connect(function(descendant_1: Instance) -- line: 685
            -- upvalues:
            --  [1] arg52 (copy)

            arg52:_PotentialHitboxAdded(descendant_1)
        end)

        for _, val_9 in pairs(arg52.Model:GetDescendants()) do
            arg52:_PotentialHitboxAdded(val_9)
        end
    end
end

function t._Init(arg54) -- line: 695
    arg54.Died:Connect(function() -- line: 696
        -- upvalues:
        --  [1] arg54 (copy)

        arg54.HealthChanged:Fire()
        arg54:_UpdatePermafrostSlowStacks()
    end)
    arg54:GetDataChangedSignal("IsInvincible"):Connect(function() -- line: 701
        -- upvalues:
        --  [1] arg54 (copy)

        arg54:_UpdateInvincibilityVisual()
    end)
    arg54:GetDataChangedSignal("ReplicatedExternalGameplayData"):Connect(function() -- line: 705
        -- upvalues:
        --  [1] arg54 (copy)

        arg54:_UpdatePermafrostSlowStacks()
    end)
    arg54:_Setup()
    arg54:_UpdateInvincibilityVisual()
    task.defer(arg54._UpdatePermafrostSlowStacks, arg54)
end

return t
