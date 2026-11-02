local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = { "rbxassetid://95537657751620", "rbxassetid://79660414273289" }
local t_1 = setmetatable({}, ClientEnemy_m)
t_1.__index = t_1

function t_1.new(...) -- line: 13
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(ClientEnemy_m.new(...), t_1)
    t_2._charge_hash = 0
    t_2._charge_animation_tracks = {}
    t_2:_Init()

    return t_2
end

function t_1.ReplicateFromServer(arg1, arg2, ...) -- line: 28
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] t (copy)
    --  [3] ClientEnemy_m (copy)

    if arg2 == "ChargerZombieChargeStart" then
        if not arg1:IsRendered() then
            return
        end

        local v2 = ...
        arg1._charge_hash += 1
        local ChargeHash = arg1._charge_hash
        table.insert(
            arg1._charge_animation_tracks,
            arg1:_PlayAnimation("rbxassetid://89451767520037", 0)
        )
        task.spawn(function() -- line: 41
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] ChargeHash (copy)
            --  [3] Utility_m (ref)

            wait(0.4)

            if arg1._charge_hash ~= ChargeHash then
                return
            end

            Utility_m:CreateSound(
                "rbxassetid://104718122128210",
                0.5,
                0.75 + 0.125 * math.random(),
                arg1.RootPart,
                true,
                10
            )
            Utility_m:CreateSound(
                "rbxassetid://129922197154277",
                1,
                0.875 + 0.25 * math.random(),
                arg1.RootPart,
                true,
                10
            )
            wait(3.05)

            if arg1._charge_hash ~= ChargeHash then
                return
            end

            table.insert(
                arg1._charge_animation_tracks,
                arg1:_PlayAnimation("rbxassetid://81364239879886", 0)
            )
        end)
        task.spawn(function() -- line: 60
            -- upvalues:
            --  [1] v2 (copy)
            --  [2] Utility_m (ref)
            --  [3] arg1 (copy)

            wait(0.6)

            for _ = 0, v2 - 0.6, 0.2 do
                Utility_m:CreateSound(
                    "rbxassetid://76804323076444",
                    0.75 + 0.25 * math.random(),
                    0.875 + 0.25 * math.random(),
                    arg1.RootPart,
                    true,
                    10
                )
                wait(0.2)
            end
        end)
        wait(v2)

        if arg1._charge_hash ~= ChargeHash then
            return
        end

        arg1._charge_hash += 1
        arg1:_StopChargingAnimationTracks()
        arg1:_PlayAnimation("rbxassetid://114972482950857")

        return
    elseif arg2 == "ChargerZombieChargeImpact" then
        if not arg1:IsRendered() then
            return
        end

        arg1._charge_hash += 1
        arg1:_StopChargingAnimationTracks()
        arg1:_PlayAnimation("rbxassetid://102061691949401", 0)

        return
    elseif arg2 == "DinkEffect" then
        if not arg1:IsRendered() then
            return
        end

        Utility_m:CreateSound(
            t[math.random(1, #t)],
            0.625 + 0.25 * math.random(),
            1 + 0.5 * math.random(),
            arg1.RootPart,
            true,
            10
        )
        local v15 = Utility_m
        local v16 = arg1.Model:FindFirstChild("Head")

        if v16 then
            v16 = arg1.Model.Head:FindFirstChild("DinkVFX")
        end

        v15:PlayParticles(v16)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t_1.Destroy(arg3) -- line: 101
    -- upvalues:
    --  [1] ClientEnemy_m (copy)

    arg3._charge_hash += 1
    ClientEnemy_m.Destroy(arg3)
end

function t_1._StopChargingAnimationTracks(arg4) -- line: 110
    for _, val in pairs(arg4._charge_animation_tracks) do
        val:Stop()
    end

    arg4._charge_animation_tracks = {}
end

function t_1._Init(_) -- line: 118
end

return t_1
