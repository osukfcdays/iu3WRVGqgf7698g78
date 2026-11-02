local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local AcidExplosionParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.AcidExplosionParticles
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 27
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CameraController_m (copy)
    --  [3] AcidExplosionParticles (copy)
    --  [4] BetterDebris_m (copy)
    --  [5] ClientEnemy_m (copy)

    if arg2 == "FutileIntro" then
        if not arg1:IsRendered() then
            return
        end

        arg1:_PlayAnimation("rbxassetid://122946493954520")
        wait(7.45)
        Utility_m:CreateSound(
            "rbxassetid://129922197154277",
            1.5,
            0.875 + 0.25 * math.random(),
            arg1.RootPart,
            true,
            10
        )
        CameraController_m:ShakeOnce(
            50,
            10,
            0.1,
            0.4,
            Vector3.new(0.25, 0.25, 0),
            Vector3.new(0, 0, 0)
        )

        return
    elseif arg2 == "AcidSlam" then
        if not arg1:IsRendered() then
            return
        end

        wait(... - 0.55)
        arg1:_PlayAnimation("rbxassetid://85325408755364")
        wait(0.55)
        Utility_m:CreateSound(
            "rbxassetid://129922197154277",
            1.5,
            0.875 + 0.25 * math.random(),
            arg1.RootPart,
            true,
            10
        )
        CameraController_m:ShakeOnce(
            50,
            10,
            0.1,
            0.4,
            Vector3.new(0.25, 0.25, 0),
            Vector3.new(0, 0, 0)
        )

        return
    elseif arg2 == "AcidExplosion" then
        if not arg1:IsRendered() then
            return
        end

        local v6, v7 = ...
        local v8 = AcidExplosionParticles:Clone()
        v8.CFrame = CFrame.new(v6) + Vector3.new(0, 1, 0) * v7 * 0.4
        v8.Parent = workspace
        BetterDebris_m:AddItem(v8, 10)

        for _, val in pairs(v8:GetDescendants()) do
            if val:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val, v7 / 4)
            end
        end

        Utility_m:PlayParticles(v8)
        Utility_m:CreateSound(
            "rbxassetid://79150386787758",
            1,
            1 + 0.1 * math.random(),
            v8,
            true,
            10
        )
        Utility_m:CreateSound(
            "rbxassetid://125902611007483",
            0.8,
            1 + 0.1 * math.random(),
            v8,
            true,
            10
        )

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Init(_) -- line: 84
end

return t
