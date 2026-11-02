local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = { "rbxassetid://135005054893837", "rbxassetid://131160196025684" }
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
    --  [3] ClientEnemy_m (copy)

    if arg2 == "ZombieReanimation" then
        if not arg1:IsRendered() then
            return
        end

        local v2 = arg1:_PlayAnimation("rbxassetid://116248625896064", 0)
        local v3 = arg1:_PlayAnimation("rbxassetid://80790379621135", 0)
        local v4 = arg1:_PlayAnimation("rbxassetid://106390578093849", 0)
        v3:Stop(0)
        v4:Stop(0)
        wait(2.4)
        v2:Stop(0)
        v3:Play(0)
        wait(... - 2.4 - 3.4)
        v3:Stop(0)
        v4:Play(0)
        task.spawn(function() -- line: 51
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg1 (copy)
            --  [3] t (ref)

            wait(1.65)
            Utility_m:CreateSound(
                "rbxassetid://87428186485980",
                0.75 + 0.25 * math.random(),
                1 + 0.25 * math.random(),
                arg1.RootPart,
                true,
                10
            )
            wait(1)
            Utility_m:CreateSound(
                t[math.random(#t)],
                0.75 + 0.25 * math.random(),
                1 + 0.25 * math.random(),
                arg1.RootPart,
                true,
                10
            )
        end)
        wait(3.4)
        v4:Stop(0)

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t_1._Init(_) -- line: 71
end

return t_1
