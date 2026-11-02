local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local t = {}
local DashParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.DashParticles
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.RedirectSliding = Signal_m.new()
    t_1.ClientFighterCharacter = arg1
    t_1._destroyed = false
    t_1._fov_offset_spring = Spring_m.new(0, 0.75, 10)
    t_1._hard_dashes = {}
    t_1:_Init()

    return t_1
end

function t.GetFOVOffset(arg2) -- line: 36
    return arg2._fov_offset_spring.Value
end

function t.CancelHardDash(arg3, arg4) -- line: 40
    local v1 = arg3._hard_dashes[arg4]

    if not v1 then
        return
    end

    v1.Velocity:Destroy()

    for _, val in pairs(v1.Threads) do
        pcall(task.cancel, val)
    end

    arg3._hard_dashes[arg4] = nil
    local RootPart = arg3.ClientFighterCharacter.RootPart
    RootPart.AssemblyLinearVelocity *= v1.StopVector
end

function t.HardDash(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10
) -- line: 57
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] DashParticles (copy)
    --  [3] RunService (copy)

    arg5.ClientFighterCharacter:AirborneCancel()
    arg5.ClientFighterCharacter.ClientFighter.StopSliding:Fire()
    arg5.ClientFighterCharacter.Sounds:DisableFootsteps(arg7)
    local t_2 = {
        Velocity = Instance.new("BodyVelocity"),
        Threads = {},
        StopVector = arg9 or Vector3.new(0, 0, 0)
    }
    t_2.Velocity.MaxForce = Vector3.new(40000, 40000, 40000)
    t_2.Velocity.Velocity = arg6
    t_2.Velocity.Parent = arg5.ClientFighterCharacter.RootPart
    BetterDebris_m:AddItem(t_2.Velocity, arg7 + 0.1)
    table.insert(t_2.Threads, task.delay(arg7, function() -- line: 74
        -- upvalues:
        --  [1] arg10 (copy)
        --  [2] arg5 (copy)
        --  [3] t_2 (copy)

        if arg10 then
            arg5:CancelHardDash(arg10)
        end

        t_2.Velocity:Destroy()
        local RootPart_1 = arg5.ClientFighterCharacter.RootPart
        RootPart_1.AssemblyLinearVelocity *= t_2.StopVector
        arg5.ClientFighterCharacter:AirborneCancel()
        arg5.ClientFighterCharacter.ClientFighter.StopSliding:Fire()
    end))

    if not arg8 then
        table.insert(t_2.Threads, task.spawn(function() -- line: 86
            -- upvalues:
            --  [1] arg5 (copy)
            --  [2] DashParticles (ref)
            --  [3] BetterDebris_m (ref)
            --  [4] arg7 (copy)
            --  [5] RunService (ref)

            local RootPart_2 = arg5.ClientFighterCharacter.RootPart

            if not RootPart_2 then
                return
            end

            local v3 = DashParticles:Clone()
            v3.Parent = RootPart_2
            BetterDebris_m:AddItem(v3, arg7 + 5)
            local Position = RootPart_2.Position
            local v5 = tick() + arg7

            for _, val_1 in pairs(v3:GetChildren()) do
                if val_1:IsA("ParticleEmitter") then
                    val_1.Enabled = true
                end
            end

            while true do
                if arg5._destroyed or not (v5 > tick()) then
                    break
                end

                if (Position - RootPart_2.Position).Magnitude > 0.01 then
                    v3.CFrame = CFrame.new(RootPart_2.Position, Position) * CFrame.Angles(
                        0,
                        3.141592653589793,
                        0
                    )
                end

                RunService.Heartbeat:Wait()
            end

            local v7 = pairs
            local _ = CFrame.Angles(0, 3.141592653589793, 0)

            for _, val_2 in v7(v3:GetChildren()) do
                if val_2:IsA("ParticleEmitter") then
                    val_2.Enabled = false
                end
            end
        end))
    end

    if arg10 then
        arg5._hard_dashes[arg10] = t_2
    end
end

function t.WarpTo(arg11, arg12) -- line: 128
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CameraController_m (copy)

    if
        not arg11.ClientFighterCharacter.ClientFighter.IsLocalPlayer
        or not arg11.ClientFighterCharacter:IsAlive()
    then
        return
    end

    arg11.ClientFighterCharacter.RootPart.CFrame = arg12
    arg11._fov_offset_spring.Value = 10
    local v8 = if not (Utility_m:AngleBetweenVectors(arg12.LookVector, Vector3.new(0, 1, 0)) < 0.7853981633974483) then Utility_m:AngleBetweenVectors(
        arg12.LookVector,
        Vector3.new(-0, -1, -0)
    ) < 0.7853981633974483 and true else true

    if not v8 then
        CameraController_m:MimicRotation(arg12)
    end

    if arg11.ClientFighterCharacter.ClientFighter:IsSliding() and not v8 then
        arg11.RedirectSliding:Fire(arg12.LookVector)

        return
    end

    local Velocity = arg11.ClientFighterCharacter.RootPart.Velocity
    local LookVector = arg12.LookVector
    local squareRoot = math.sqrt(Velocity.Magnitude)
    local v9 = LookVector * math.max(16, squareRoot)
    local v10 = if not v8 then nil else Velocity.Unit * math.max(
        (Velocity * (Vector3.new(1, 0, 1)).Unit).Magnitude,
        arg11.ClientFighterCharacter.Humanoid.WalkSpeed
    )
    local v11 = if not v10 then nil else if v10 ~= v10 then nil else v10.Magnitude > 0.001 and v10 or nil
    arg11.ClientFighterCharacter:AirborneTrigger(v9, 12, nil, v11)
end

function t.Update(_, _, _) -- line: 154
end

function t.Destroy(arg16) -- line: 158
    arg16._destroyed = true
end

function t._Init(_) -- line: 166
end

return t
