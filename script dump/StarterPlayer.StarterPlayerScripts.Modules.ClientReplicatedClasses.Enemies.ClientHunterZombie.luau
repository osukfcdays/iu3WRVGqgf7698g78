local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 22
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] ClientEnemy_m (copy)

    if arg2 == "HunterLeapEffect" then
        if not arg1:IsRendered() then
            return
        end

        arg1:_PlayAnimation("rbxassetid://89570876299263", 0, nil, 3)
        Utility_m:CreateSound(
            "rbxassetid://118467983008802",
            1,
            1 + 0.25 * math.random(),
            arg1.RootPart,
            true,
            10
        )

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Init(_) -- line: 39
end

return t
