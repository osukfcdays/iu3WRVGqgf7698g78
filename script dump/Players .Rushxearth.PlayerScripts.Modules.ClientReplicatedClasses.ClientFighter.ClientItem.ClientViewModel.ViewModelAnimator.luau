local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local SoundLibrary_m = require(ReplicatedStorage.Modules.SoundLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.AnimationPlayed = Signal_m.new()
    t_1.AnimationStopped = Signal_m.new()
    t_1.ClientViewModel = arg1
    t_1.SprintTrackSpeed = 1
    t_1._viewmodel_animations = t_1.ClientViewModel.Info.Animations
    t_1._play_animations_instantly = t_1.ClientViewModel.Info.PlayAnimationsInstantly
    t_1._render_cooldown = 0
    t_1._inspect_cooldown = 0
    t_1._animations_loaded = false
    t_1._animation_cleanup = {}
    t_1._animation_tracks = {}
    t_1._animation_hashes = {}
    t_1._animation_threads = {}
    t_1._animation_keys_lookup = {}
    t_1._equip_animation = nil
    t_1._idle_animation = nil
    t_1._inspect_animation = nil
    t_1._rare_inspect_animation = nil
    t_1._sprint_animation = nil
    t_1._should_override_previous_animations_on_play = false
    t_1._last_animation_key_played = nil
    t_1._blocked_animations = {}
    t_1:_Init()

    return t_1
end

function t.HasEmptyReloadAnimations(arg2) -- line: 50
    return arg2._viewmodel_animations.EmptyReload ~= nil or arg2._viewmodel_animations.EmptyReloadStart ~= nil
end

function t.IsRenderingDisabled(arg3) -- line: 54
    return tick() < arg3._render_cooldown
end

function t.IsAnimationPlaying(arg4, arg5) -- line: 58
    local v3 = arg4:GetAnimationTrack(arg5)
    local v4 = v3

    if v4 then
        v4 = v3.IsPlaying
    end

    return v4
end

function t.AreAnimationsPlaying(arg6, arg7) -- line: 63
    for _, val in pairs(arg7) do
        if arg6:IsAnimationPlaying(val) then
            return true
        end
    end
end

function t.GetEquipAnimationKey(arg8) -- line: 71
    return arg8._equip_animation
end

function t.GetIdleAnimationKey(arg9) -- line: 75
    return arg9._idle_animation
end

function t.GetInspectAnimationKey(arg10) -- line: 79
    return arg10._inspect_animation
end

function t.GetRareInspectAnimationKey(arg11) -- line: 83
    return arg11._rare_inspect_animation
end

function t.GetAnimationTrack(arg12, arg13) -- line: 87
    return arg12._animation_tracks[arg13]
end

function t.GetAnimationKeys(arg14, arg15) -- line: 91
    if arg14._animation_keys_lookup[arg15] then
        return arg14._animation_keys_lookup[arg15]
    end

    local t_2 = {}

    for index = 1, math.huge do
        local v5 = arg15 .. index

        if not arg14:GetAnimationTrack(v5) then
            break
        end

        table.insert(t_2, v5)
    end

    arg14._animation_keys_lookup[arg15] = t_2

    return t_2
end

function t.IsInspectAnimationPlaying(arg16) -- line: 113
    return arg16:IsAnimationPlaying(arg16._inspect_animation) or arg16:IsAnimationPlaying(
        arg16._rare_inspect_animation
    )
end

function t.GetSprintTrack(arg17) -- line: 117
    return arg17:GetAnimationTrack(arg17._sprint_animation)
end

function t.IsAnimationHashValid(arg18, arg19, arg20) -- line: 122
    return arg18._animation_hashes[arg19] == arg20
end

function t.AnimationWait(arg21, arg22, arg23, arg24) -- line: 127
    local v8 = wait(arg24)

    if v8 then
        v8 = arg21:IsAnimationHashValid(arg22, arg23)
    end

    return v8
end

function t.SetInspectCooldown(arg25, arg26) -- line: 131
    arg25._inspect_cooldown = tick() + arg26
end

function t.CreateSound(arg27, ...) -- line: 135
    return arg27.ClientViewModel:CreateSound(...)
end

function t.OverridePreviousAnimationsOnPlay(arg28, arg29) -- line: 139
    arg28._should_override_previous_animations_on_play = arg29
end

function t.BlockAnimation(arg30, arg31, arg32) -- line: 143
    assert(
        if typeof(arg31) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    assert(
        if typeof(arg32) ~= "number" then false else true,
        "Argument 2 invalid, expected a number"
    )
    arg30._blocked_animations[arg31] = tick() + arg32
end

function t.PlayAnimation(
    arg33,
    arg34,
    arg35,
    arg36,
    arg37,
    arg38
) -- line: 152
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    assert(
        if typeof(arg34) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    assert(
        not arg35 or (if typeof(arg35) ~= "number" then false else true),
        "Argument 2 invalid, expected a number"
    )

    if tick() < (arg33._blocked_animations[arg34] or 0) then
        return
    end

    local v11 = if not arg33._play_animations_instantly then arg36 else 0

    if arg35 then
        arg33:SetInspectCooldown(arg35)
        arg33:StopInspecting()
    end

    local v12 = arg33:_AnimationKeyToName(arg34)

    if v12 then
        arg33:_CancelAnimationSoundCallback(v12)
    end

    local v13 = arg33._should_override_previous_animations_on_play or (if arg34 ~= arg33:GetInspectAnimationKey() then if arg34 ~= arg33:GetRareInspectAnimationKey() then false else true else true)

    if
        arg34 ~= arg33:GetIdleAnimationKey()
        and arg34 ~= arg33._sprint_animation
        and arg33._last_animation_key_played ~= arg33:GetIdleAnimationKey()
        and arg33._last_animation_key_played ~= arg33._sprint_animation
    then
        if v13 and arg33._last_animation_key_played then
            arg33:StopAnimation(arg33._last_animation_key_played, 0)
        end

        arg33._last_animation_key_played = arg34
    end

    v13 = arg33:GetAnimationTrack(arg34)

    if v13 then
        local v14 = arg33._animation_hashes[v12]
        local v15 = AnimationLibrary_m.Info[v12]
        local v16 = v15.Speed * (arg38 or 1)
        v13:Play(v11, arg37, v16)

        if v15.SoundCallback then
            table.insert(
                arg33._animation_threads[v12],
                task.defer(v15.SoundCallback, arg33.ClientViewModel, v16, v14)
            )
        end

        if v15.EffectCallback then
            table.insert(
                arg33._animation_threads[v12],
                task.defer(v15.EffectCallback, arg33.ClientViewModel, v16, v14)
            )
        end

        arg33.AnimationPlayed:Fire(arg34, v12, v14)

        return
    end

    warn("Animation key failed to play (not found): " .. tostring(arg34))
end

function t.PlayIdleAnimation(arg39) -- line: 206
    if arg39.ClientViewModel:IsEquipped() then
        arg39:PlayAnimation(arg39._idle_animation, nil, 0)
    end
end

function t.PlayEquipAnimation(arg40) -- line: 212
    if not arg40:GetAnimationTrack(arg40._equip_animation) then
        return
    end

    arg40:PlayAnimation(arg40._equip_animation)

    return true
end

function t.PlaySprintAnimation(arg41) -- line: 222
    arg41:PlayAnimation(arg41._sprint_animation)
end

function t.Inspect(arg42, arg43) -- line: 228
    -- upvalues:
    --  [1] SoundLibrary_m (copy)

    assert(
        not arg43 or (if typeof(arg43) ~= "boolean" then false else true),
        "Argument 1 invalid, expected a boolean or nil"
    )

    if tick() < arg42._inspect_cooldown or arg42.ClientViewModel.ClientItem:IsEquipping() then
        return false
    end

    arg42:StopAnimation(arg42._equip_animation, 0)
    local v20 = arg42:StopInspecting()

    if v20 then
    end

    local v21 = arg43

    if not v21 then
        v21 = false

        if arg43 == nil then
            v21 = arg42:GetAnimationTrack(arg42._rare_inspect_animation)

            if v21 then
                v21 = math.random() < 0.1 and true
            end
        end
    end

    if v21 then
        arg42:CreateSound(
            SoundLibrary_m.EquipSounds[math.random(#SoundLibrary_m.EquipSounds)],
            0.375,
            1.4 + 0.2 * math.random(),
            true,
            5
        )
        arg42:CreateSound(
            "rbxassetid://13159969353",
            0.25,
            1 + 0.25 * math.random(),
            true,
            5
        )
        arg42:PlayAnimation(arg42._rare_inspect_animation, nil, if v20 then 0 else 0.2)
    elseif arg42:GetAnimationTrack(arg42._inspect_animation) then
        arg42:CreateSound(
            SoundLibrary_m.EquipSounds[math.random(#SoundLibrary_m.EquipSounds)],
            0.375,
            1.4 + 0.2 * math.random(),
            true,
            5
        )
        arg42:PlayAnimation(arg42._inspect_animation, nil, if v20 then 0 else 0.2)
    else
        return false
    end

    return true, v21
end

function t.StopAnimation(arg44, arg45, arg46, arg47) -- line: 260
    assert(
        if typeof(arg45) ~= "string" then false else true,
        "Argument 1 invalid, expected a string"
    )
    assert(
        not arg47 or (if typeof(arg47) ~= "number" then false else true),
        "Argument 3 invalid, expected a number"
    )
    local v28 = if arg44._play_animations_instantly then 0 else arg46

    if arg47 then
        arg44:SetInspectCooldown(arg47)
        arg44:StopInspecting()
    end

    local v29 = arg44:_AnimationKeyToName(arg45)

    if v29 then
        arg44:_CancelAnimationSoundCallback(v29)
    end

    local v30 = arg44:GetAnimationTrack(arg45)

    if v30 then
        v30:Stop(v28)
        arg44.AnimationStopped:Fire(arg45, v29)

        return
    end
end

function t.StopInspecting(arg48) -- line: 287
    if
        arg48:GetAnimationTrack(arg48._inspect_animation)
        and arg48:GetAnimationTrack(arg48._inspect_animation).IsPlaying
    then
        arg48:StopAnimation(arg48._inspect_animation, 0.1)

        return 0.1
    end

    if
        arg48:GetAnimationTrack(arg48._rare_inspect_animation)
        and arg48:GetAnimationTrack(arg48._rare_inspect_animation).IsPlaying
    then
        arg48:StopAnimation(arg48._rare_inspect_animation, 0.1)

        return 0.1
    end
end

function t.StopSprintAnimation(arg49) -- line: 297
    arg49:StopAnimation(arg49._sprint_animation)
end

function t.StopAllAnimations(arg50) -- line: 301
    for key_1, _ in pairs(arg50._animation_tracks) do
        arg50:StopAnimation(key_1)
    end
end

function t.ChangeEquipAnimation(arg51, arg52) -- line: 307
    local v31 = arg52 or "Equip"

    if v31 == arg51._equip_animation then
        return
    end

    arg51._equip_animation = v31
end

function t.ChangeIdleAnimation(arg53, arg54) -- line: 317
    local v32 = arg54 or "Idle"

    if v32 == arg53._idle_animation then
        return
    end

    if arg53._idle_animation then
        arg53:StopAnimation(arg53._idle_animation)
    end

    arg53._idle_animation = v32
    arg53:PlayIdleAnimation()
end

function t.ChangeSprintAnimation(arg55, arg56) -- line: 332
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    local v33 = arg56 or "Sprint"

    if v33 == arg55._sprint_animation then
        return
    end

    if arg55._sprint_animation then
        arg55:StopAnimation(arg55._sprint_animation)
    end

    arg55._sprint_animation = v33
    arg55.SprintTrackSpeed = arg55:_AnimationKeyToName(arg55._sprint_animation) and AnimationLibrary_m.Info[arg55:_AnimationKeyToName(
        arg55._sprint_animation
    )].Speed or 1
end

function t.ChangeInspectAnimation(arg57, arg58) -- line: 347
    local v35 = arg58 or "Inspect"

    if v35 == arg57._inspect_animation then
        return
    end

    if arg57._inspect_animation then
        arg57:StopAnimation(arg57._inspect_animation)
    end

    arg57._inspect_animation = v35
end

function t.ChangeRareInspectAnimation(arg59, arg60) -- line: 361
    local v36 = if arg60 == "nil" then nil else arg60 or "RareInspect"

    if v36 == arg59._rare_inspect_animation then
        return
    end

    if arg59._rare_inspect_animation then
        arg59:StopAnimation(arg59._rare_inspect_animation)
    end

    arg59._rare_inspect_animation = v36
end

function t.LoadAnimations(arg61) -- line: 375
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] ContentProvider (copy)

    if arg61._animations_loaded or not arg61.ClientViewModel.Model:IsDescendantOf(game) then
        return
    end

    arg61._animations_loaded = true
    local t_3 = {}

    local function preload_animation(arg62, arg63) -- line: 384
        -- upvalues:
        --  [1] AnimationLibrary_m (ref)
        --  [2] t_3 (copy)
        --  [3] arg61 (copy)

        local AnimationID = AnimationLibrary_m.Info[arg63].AnimationID
        local Animation = Instance.new("Animation")
        Animation.AnimationId = AnimationID
        table.insert(t_3, Animation)
        table.insert(arg61._animation_cleanup, Animation)
        local Success, Result = pcall(
            arg61.ClientViewModel.Model.AnimationController.Animator.LoadAnimation,
            arg61.ClientViewModel.Model.AnimationController.Animator,
            Animation
        )

        if not Success then
            warn(
                "FAILED TO LOAD ANIMATION FOR " .. arg61.ClientViewModel.Name .. ": " .. arg62 .. ", " .. arg63 .. ", " .. AnimationID
            )

            return
        end

        table.insert(arg61._animation_cleanup, Result)
        Result.Stopped:Connect(function() -- line: 401
            -- upvalues:
            --  [1] arg61 (ref)
            --  [2] arg63 (copy)
            --  [3] arg62 (copy)
            --  [4] Result (copy)

            arg61:_CancelAnimationSoundCallback(arg63)
            arg61.AnimationStopped:Fire(arg62, arg63)

            if arg61._play_animations_instantly then
                Result:Stop(0)
            end
        end)
        arg61._animation_tracks[arg62] = Result
    end

    for key_2, val_2 in pairs(arg61._viewmodel_animations) do
        task.spawn(preload_animation, key_2, val_2)
    end

    task.spawn(function() -- line: 417
        -- upvalues:
        --  [1] ContentProvider (ref)
        --  [2] t_3 (copy)
        --  [3] arg61 (copy)

        ContentProvider:PreloadAsync(t_3)
        arg61._render_cooldown = tick() + 0.1
    end)
    arg61._render_cooldown = tick() + 5
    arg61:ChangeEquipAnimation("Equip")
    arg61:ChangeIdleAnimation("Idle")
    arg61:ChangeSprintAnimation("Sprint")
    arg61:ChangeInspectAnimation("Inspect")
    arg61:ChangeRareInspectAnimation("RareInspect")
    arg61:PlayIdleAnimation()
end

function t.Destroy(arg64) -- line: 431
    arg64.AnimationPlayed:Destroy()
    arg64.AnimationStopped:Destroy()

    for _, val_3 in pairs(arg64._animation_cleanup) do
        val_3:Destroy()
    end

    for _, _ in pairs(arg64._animation_threads) do
        for _, val_5 in pairs(arg64._animation_threads) do
            pcall(task.cancel, val_5)
        end
    end

    arg64._animation_cleanup = {}
    arg64._animation_threads = {}
    arg64._animation_hashes = {}
end

function t._ResetIdleAfterEquipping(arg65, arg66, arg67, arg68) -- line: 454
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    local v38 = AnimationLibrary_m.Info[arg67]
    local v39 = v38 and v38.ExtraInformation.ResetIdleTimestamp

    if arg66 ~= "Equip" or not v39 then
        return
    end

    wait(v39)

    if not arg65:IsAnimationHashValid(arg67, arg68) then
        return
    end

    v39 = arg65:GetAnimationTrack(arg65:GetIdleAnimationKey())

    if not v39 then
        return
    end

    v39.TimePosition = 0
end

function t._CancelAnimationSoundCallback(arg69, arg70) -- line: 477
    local v40 = pairs
    local v41 = arg69._animation_threads[arg70] or {}

    for _, val_6 in v40(v41) do
        pcall(task.cancel, val_6)
    end

    arg69._animation_threads[arg70] = {}
    arg69._animation_hashes[arg70] = (arg69._animation_hashes[arg70] or 0) + 1
end

function t._AnimationKeyToName(arg71, arg72) -- line: 487
    return arg71._viewmodel_animations[arg72]
end

function t._Init(arg73) -- line: 491
    arg73.AnimationPlayed:Connect(function(arg74, arg75, arg76) -- line: 492
        -- upvalues:
        --  [1] arg73 (copy)

        arg73:_ResetIdleAfterEquipping(arg74, arg75, arg76)
    end)
end

return t
