local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local Melee_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Melee)
local t = setmetatable({}, Melee_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Melee_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Melee_m.new(...), t)
    t_1._is_slamming = false
    t_1._slam_hash = 0
    t_1._slam_cooldown = 0
    t_1._leap_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.StartAiming(arg1, arg2, arg3) -- line: 30
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)

    local v2

    if arg2 then
        v2 = arg3
    else
        v2 = arg1.ClientFighter.Entity

        if v2 then
            v2 = arg1.ClientFighter.Entity:IsAirborne() or not arg1.ClientFighter.Entity:IsGrounded()
        end
    end

    v2 = not (not v2)
    local v3

    if arg2 then
        v3 = arg3
    else
        v3 = v2

        if v3 then
            v3 = not arg1.ClientFighter.Entity:GetFloor(arg1.Info.SlamFloorDistance)
        end
    end

    v3 = not (not v3)

    if not arg2 then
        if arg1:IsEquipping() or v3 and tick() < arg1._slam_cooldown or v2 and not v3 then
            return false
        end

        if
            arg1.ClientFighter.Entity.Humanoid:GetState() == Enum.HumanoidStateType.Climbing
            or not v2 and not v3 and tick() < arg1._leap_cooldown
        then
            return false
        end
    end

    arg1.ClientFighter.Entity:AirborneCancel()

    if v3 then
        arg1._slam_hash += 1
        local SlamHash = arg1._slam_hash
        arg1._is_slamming = true
        arg1._slam_cooldown = tick() + arg1.Info.SlamCooldown
        arg1._attack_cooldown = math.huge
        arg1.ClientFighter.Entity.RootPart.Velocity = Vector3.new(0, -128, 0)
        arg1:CooldownEffect("rbxassetid://127897416506738", arg1.Info.SlamCooldown, "Slam")
        task.spawn(function() -- line: 66
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] AnimationLibrary_m (ref)
            --  [3] SlamHash (copy)

            arg1.ViewModel:PlayAnimation("SlamIntro", math.huge, 0)
            wait(AnimationLibrary_m.Info[arg1.ViewModel.Info.Animations.SlamIntro].Length)

            if SlamHash ~= arg1._slam_hash then
                return
            end

            arg1.ViewModel:PlayAnimation("SlamLoop", math.huge, 0)
        end)
    else
        arg1._leap_cooldown = tick() + arg1.Info.LeapCooldown
        local v5 = arg1.ClientFighter:GetCameraData(nil, nil, true)[utf8.char(1)].LookVector * 32 * Vector3.new(1, 0, 1) + Vector3.new(0, 24, 0)
        arg1.ClientFighter.Entity:AirborneTrigger(v5, 2, true)
        local v6 = 1 + 0.25 * math.random()
        arg1:CreateSound(
            "rbxassetid://98587858115094",
            v6,
            0.9 + 0.2 * math.random(),
            true,
            10
        )
    end

    return true, "StartAiming", v3
end

function t.Unequip(arg4) -- line: 90
    -- upvalues:
    --  [1] Melee_m (copy)

    arg4:_CancelSlam()
    Melee_m.Unequip(arg4)
end

function t.ReplicateFromServer(arg5, arg6, ...) -- line: 95
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] Melee_m (copy)

    if arg6 == "SlamAttack" then
        if not arg5:IsRendered() then
            return
        end

        local v8, v9 = ...
        arg5:_CancelSlam()
        arg5._attack_cooldown = tick() + arg5.Info.SlamEndLag
        arg5.ViewModel:PlayAnimation("SlamOutro", 0, 0)
        arg5.ViewModel:SlamEffect(v8, v9)
        arg5.ViewModel:SlamSoundEffect(v8, v9)

        if arg5.ClientFighter:Get("IsSpectating") then
            CameraController_m:ShakeOnce(
                50,
                10,
                0.1,
                0.4,
                Vector3.new(0.25, 0.25, 0),
                Vector3.new(0, 0, 0)
            )

            return
        end
    elseif arg6 == "CancelSlam" then
        if not arg5:IsRendered() then
            return
        end

        arg5:_CancelSlam()

        return
    else
        Melee_m.ReplicateFromServer(arg5, arg6, ...)
    end
end

function t._CancelSlam(arg7) -- line: 127
    arg7._slam_hash += 1

    if not arg7._is_slamming then
        return
    end

    arg7._is_slamming = false
    arg7._attack_cooldown = 0
    arg7.ViewModel:StopAnimation("SlamIntro")
    arg7.ViewModel:StopAnimation("SlamLoop")
    arg7.ViewModel.Animator:SetInspectCooldown(0)
end

function t._Init(_) -- line: 142
end

return t
