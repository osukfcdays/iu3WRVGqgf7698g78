local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = { "rbxassetid://95537657751620", "rbxassetid://79660414273289" }
local Attachment = Players.LocalPlayer.PlayerScripts.Assets.Misc.ShockerZombieZapEffect.Attachment
local t_1 = setmetatable({}, ClientEnemy_m)
t_1.__index = t_1

function t_1.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(ClientEnemy_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.ReplicateFromServer(arg1, arg2, ...) -- line: 26
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] t (copy)
    --  [3] BetterDebris_m (copy)
    --  [4] Attachment (copy)
    --  [5] ClientEnemy_m (copy)

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
    elseif arg2 == "ShockerZombieZap" then
        if not arg1:IsRendered() then
            return
        end

        local v9 = ...

        if not v9 then
            return
        end

        Utility_m:CreateSound(
            "rbxassetid://125973620031504",
            0.375,
            1 + 0.25 * math.random(),
            v9,
            true,
            10
        )
        local Attachment_1 = Instance.new("Attachment")
        Attachment_1.Parent = v9
        BetterDebris_m:AddItem(Attachment_1, 0.2)
        local v12 = Attachment:Clone()
        v12.Beam1.Attachment1 = Attachment_1
        v12.Beam2.Attachment1 = Attachment_1
        v12.Parent = arg1.Model.Appearance.Head.ContainsParticles:FindFirstChild("ZapStart")
        BetterDebris_m:AddItem(v12, 0.2)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t_1._Init(_) -- line: 65
end

return t_1
