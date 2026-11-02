local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._build_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.CanEasyQuickAttack(arg1) -- line: 27
    local v2 = arg1:CanQuickAttack()

    if v2 then
        v2 = if tick() > arg1._build_cooldown then not arg1:IsEquipping() else false
    end

    return v2
end

function t.StartAiming(arg2, arg3) -- line: 31
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    if not arg3 and (tick() < arg2._build_cooldown or arg2:IsEquipping()) then
        return false
    end

    local _, v4 = arg2.ClientFighter:GetCameraData()
    arg2._build_cooldown = tick() + arg2.Info.BuildCooldown
    arg2:CooldownEffect("rbxassetid://17132668997", arg2.Info.BuildCooldown, "Build")
    arg2.ViewModel:PlayAnimation(
        "Build",
        AnimationLibrary_m.Info[arg2.ViewModel.Info.Animations.Build].Length
    )

    return true, "StartAiming", v4.Position
end

function t.FinishAiming(_, _) -- line: 45
    return false
end

function t.ReplicateFromServer(arg6, arg7, ...) -- line: 49
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Melee_m (copy)

    if arg7 == "HardenEffect" then
        if not arg6:IsRendered() then
            return
        end

        Utility_m:CreateSound(
            "rbxassetid://17138809559",
            1.25,
            1 + 0.2 * math.random(),
            ...,
            true,
            5
        )

        return
    elseif arg7 == "ThrowEffect" then
        if not arg6:IsRendered() then
            return
        end

        Utility_m:CreateSound(
            "rbxassetid://14522189766",
            1.25,
            2 + 0.25 * math.random(),
            ...,
            true,
            5
        )

        return
    else
        Melee_m.ReplicateFromServer(arg6, arg7, ...)

        return
    end
end

function t._Setup(arg8) -- line: 75
    function arg8._on_attack_callback() -- line: 76
        -- upvalues:
        --  [1] arg8 (copy)

        arg8.ViewModel:StopAnimation("Build")
    end
end

function t._Init(arg9) -- line: 81
    arg9:_Setup()
end

return t
