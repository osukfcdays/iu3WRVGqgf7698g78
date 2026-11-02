local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local FlagZombieEmpoweredEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc.FlagZombieEmpoweredEffect
local ZombieFlag = Players.LocalPlayer.PlayerScripts.Assets.Misc.ZombieFlag
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1._dropped_flags = {}
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 28
    -- upvalues:
    --  [1] ZombieFlag (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] FlagZombieEmpoweredEffect (copy)
    --  [5] ClientEnemy_m (copy)

    if arg2 == "DropFlagEffect" then
        if not arg1:IsRendered() then
            return
        end

        local v2, v3 = ...
        local v4 = ZombieFlag:Clone()
        local cframe = CFrame.new(v2)
        v4:PivotTo(cframe * CFrame.Angles(0, 6.283185307179586 * math.random(), 0))
        v4.Parent = workspace
        BetterDebris_m:AddItem(v4, 30)

        for _, val in pairs(v4.Effect:GetDescendants()) do
            if val:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val, v3 / 25)
            end
        end

        task.spawn(function() -- line: 47
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] v4 (copy)

            for _ = 1, 3 do
                Utility_m:PlayParticles(v4)
                wait(0.25)
            end
        end)
        Utility_m:CreateSound(
            "rbxassetid://98975031346830",
            1,
            0.9 + 0.2 * math.random(),
            v4.PrimaryPart,
            true,
            10
        )
        local pivot = v4:GetPivot()
        local cframe_1 = CFrame.Angles(
            6.283185307179586 * math.random(),
            6.283185307179586 * math.random(),
            6.283185307179586 * math.random()
        )
        local scale = v4:GetScale()
        local v13 = scale * 0.5
        local Effect = v4.Effect
        Utility_m:RenderstepForLoop(0, 100, 2, function(arg3) -- line: 64
            -- upvalues:
            --  [1] v4 (copy)
            --  [2] v13 (copy)
            --  [3] scale (copy)
            --  [4] pivot (copy)
            --  [5] cframe_1 (copy)
            --  [6] Effect (copy)

            local v14 = 1 - (1 - arg3 / 100) ^ 3
            v4:ScaleTo(v13 + (scale - v13) * v14)
            v4:PivotTo(
                pivot * CFrame.Angles(0, 0 + 9.42477796076938 * v14, 0) * cframe_1:Lerp(
                    CFrame.identity,
                    v14
                )
            )
            Effect.CFrame = CFrame.new(Effect.Position)
        end)
        wait(15)
        Utility_m:RenderstepForLoop(0, 100, 1, function(arg4) -- line: 74
            -- upvalues:
            --  [1] v4 (copy)

            local v21 = (arg4 / 100) ^ 3

            for _, descendant in pairs(v4:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    descendant.LocalTransparencyModifier = v21
                end
            end
        end)
        v4:Destroy()

        return
    elseif arg2 == "EmpowerOtherEntityEffect" then
        if not arg1:IsRendered() then
            return
        end

        local v23, v24 = ...

        if not v23 then
            return
        end

        wait(1 * math.random())
        Utility_m:CreateSound(
            "rbxassetid://104302486797762",
            0.5 + 0.5 * math.random(),
            0.75 + 0.5 * math.random(),
            v23,
            true,
            10
        )
        local v28 = FlagZombieEmpoweredEffect:Clone()
        v28.CFrame = v23.CFrame * CFrame.new(0, -2, 0)
        v28.Parent = v23
        BetterDebris_m:AddItem(v28, v24 + 10)
        local WeldConstraint = Instance.new("WeldConstraint")
        WeldConstraint.Part0 = v23
        WeldConstraint.Part1 = v28
        WeldConstraint.Parent = v28
        wait(v24)

        for _, val_1 in pairs(v28:GetDescendants()) do
            if val_1:IsA("ParticleEmitter") then
                val_1.Enabled = false
            end
        end

        wait(3)
        v28:Destroy()

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t.Destroy(arg5) -- line: 126
    -- upvalues:
    --  [1] ClientEnemy_m (copy)

    for _, val_2 in pairs(arg5._dropped_flags) do
        val_2:Destroy()
    end

    ClientEnemy_m.Destroy(arg5)
end

function t._Init(_) -- line: 138
end

return t
