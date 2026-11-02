local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = { "rbxassetid://95537657751620", "rbxassetid://79660414273289" }
local t_1 = setmetatable({}, ClientEnemy_m)
t_1.__index = t_1

function t_1.new(...) -- line: 12
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(ClientEnemy_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.ReplicateFromServer(arg1, arg2, ...) -- line: 24
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] t (copy)
    --  [3] ClientEnemy_m (copy)

    if arg2 == "DinkEffect" then
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
        local v7 = Utility_m
        local v8 = arg1.Model:FindFirstChild("Head")

        if v8 then
            v8 = arg1.Model.Head:FindFirstChild("DinkVFX")
        end

        v7:PlayParticles(v8)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t_1._Init(_) -- line: 41
end

return t_1
