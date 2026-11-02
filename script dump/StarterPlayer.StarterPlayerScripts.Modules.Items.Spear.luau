local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local SpearThrowParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.SpearThrowParticles
local SpearThrowTrail = Players.LocalPlayer.PlayerScripts.Assets.Misc.SpearThrowTrail
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._throw_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.CanEasyQuickAttack(arg1) -- line: 30
    local v2 = arg1:CanQuickAttack()

    if v2 then
        v2 = if tick() > arg1._throw_cooldown then not arg1:IsEquipping() else false
    end

    return v2
end

function t.StartAiming(arg2, arg3, arg4) -- line: 34
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    if not arg3 and (arg2:IsEquipping() or tick() < arg2._throw_cooldown or arg2:Get("Ammo") <= 0) then
        return false
    end

    if arg2._last_attack_animation_name then
        arg2.ViewModel:StopAnimation(arg2._last_attack_animation_name)
    end

    local v3 = if arg4 then arg2:FromEnum(arg4) or (if arg2:Get("Ammo") <= 1 then "ThrowFinal" else "Throw") else if arg2:Get(
        "Ammo"
    ) <= 1 then "ThrowFinal" else "Throw"
    arg2._throw_cooldown = tick() + arg2.Info.ThrowCooldown
    arg2._attack_cooldown = tick() + arg2.Info.ThrowCooldown
    arg2:CooldownEffect("rbxassetid://86982712098586", arg2.Info.ThrowCooldown, v3)
    arg2.ViewModel:StopAnimation("Inspect", 0)
    arg2.ViewModel:StopAnimation("Throw", 0)
    arg2.ViewModel:StopAnimation("ThrowFinal", 0)
    arg2.ViewModel:PlayAnimation(
        v3,
        AnimationLibrary_m.Info[arg2.ViewModel.Info.Animations[v3]].Length
    )
    arg2:_Shake("SpearThrow")
    task.spawn(arg2._PlayThrowParticles, arg2)

    return true, "StartAiming", arg2.ClientFighter:GetCameraData(), arg2:ToEnum(v3)
end

function t._PlayThrowParticles(arg5) -- line: 64
    -- upvalues:
    --  [1] GameplayUtility_m (copy)
    --  [2] SpearThrowParticles (copy)
    --  [3] BetterDebris_m (copy)
    --  [4] Utility_m (copy)
    --  [5] SpearThrowTrail (copy)

    local v5 = nil
    local v6 = nil

    if arg5.ClientFighter.IsLocalPlayer then
        local v7 = arg5.ClientFighter:GetCameraData(nil, nil, true)
        v5 = (v7[utf8.char(0)] * CFrame.new(0.5, -0.5, -0.5)).Position
        v6 = GameplayUtility_m:GetMousePositionFromCameraData(
            arg5.ClientFighter:Get("EnvironmentID"),
            arg5.ClientFighter:GetEntityLookupParams(),
            v7[utf8.char(0)],
            v7[utf8.char(1)],
            v7[utf8.char(2)],
            v7[utf8.char(3)]
        )
    else
        local v15 = arg5.ClientFighter.Entity and (arg5.ClientFighter.Entity.Head or arg5.ClientFighter.Entity.RootPart)

        if v15 then
            local v16 = CFrame.new(v15.Position) * arg5.ClientFighter:GetRotationCFrame()
            v5 = v16.Position
            v6 = GameplayUtility_m:GetMousePositionFromCameraData(
                arg5.ClientFighter:Get("EnvironmentID"),
                arg5.ClientFighter:GetEntityLookupParams(),
                v16,
                v16
            )
        end
    end

    if not v5 or not v6 or v5:FuzzyEq(v6) then
        return
    end

    local v20 = SpearThrowParticles:Clone()
    v20.CFrame = CFrame.new(v5, v6) * CFrame.new(0, 0, -math.min(10, (v5 - v6).Magnitude - 1))
    v20.Parent = workspace
    BetterDebris_m:AddItem(v20, 5)
    Utility_m:PlayParticles(v20)
    local v21 = SpearThrowTrail:Clone()
    v21.Parent = workspace
    v21.Attachment0.WorldCFrame = CFrame.new(v5, v6)
    v21.Attachment1.WorldCFrame = CFrame.new(v6) * v21.Attachment0.WorldCFrame.Rotation
    BetterDebris_m:AddItem(v21, 5)
    v6 = v21.Beam1
    v5 = v21.Beam2
    local Width0 = v6.Width0
    local Width1 = v6.Width1
    local Width0_1 = v5.Width0
    local Width1_1 = v5.Width1
    Utility_m:RenderstepForLoop(0, 100, 10, function(arg6) -- line: 108
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] Width0 (copy)
        --  [3] Width1 (copy)
        --  [4] v5 (copy)
        --  [5] Width0_1 (copy)
        --  [6] Width1_1 (copy)

        local v22 = (arg6 / 100) ^ 3
        v6.Width0 = Width0 + (0 - Width0) * v22
        v6.Width1 = Width1 + (0 - Width1) * v22
        v5.Width0 = Width0_1 + (0 - Width0_1) * v22
        v5.Width1 = Width1_1 + (0 - Width1_1) * v22
    end)
    v21:Destroy()
end

function t._UpdateViewModelAnimations(arg7) -- line: 120
    local v23 = arg7:Get("Ammo") <= 0 and true
    local v24 = if not v23 then "Equip" else "EmptyEquip"
    arg7.ViewModel:ChangeEquipAnimation(v24)
    arg7.ViewModel:ChangeIdleAnimation(if v23 then "EmptyIdle" else "Idle")
    arg7.ViewModel:ChangeInspectAnimation(if v23 then "EmptyInspect" else "Inspect")
    arg7.ViewModel:ChangeSprintAnimation(if v23 then "EmptySprint" else "Sprint")
    arg7.ViewModel:OverrideRootPartOffset(if v23 then CFrame.identity else nil)
end

function t._Setup(arg8) -- line: 130
    function arg8._on_attack_callback() -- line: 131
        -- upvalues:
        --  [1] arg8 (copy)

        arg8.ViewModel:StopAnimation("Throw", 0)
        arg8.ViewModel:StopAnimation("ThrowFinal", 0)
    end
end

function t._Init(arg9) -- line: 137
    arg9:GetDataChangedSignal("Ammo"):Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateViewModelAnimations()
    end)
    arg9:_Setup()
    task.defer(arg9._UpdateViewModelAnimations, arg9)
end

return t
