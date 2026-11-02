local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = setmetatable({}, ClientEnemy_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientEnemy_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.ReplicateFromServer(arg1, arg2, ...) -- line: 23
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CameraController_m (copy)
    --  [3] ClientEnemy_m (copy)

    if arg2 == "FlightIntro" then
        if not arg1:IsRendered() then
            return
        end

        arg1:_PlayAnimation("rbxassetid://91697782514164")

        return
    elseif arg2 == "ClawAttack" then
        if not arg1:IsRendered() then
            return
        end

        arg1:_PlayAnimation("rbxassetid://83924855123571")
        task.delay(0.7, function() -- line: 39
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg1 (copy)

            Utility_m:CreateSound(
                "rbxassetid://128361063555965",
                2.25 + 0.25 * math.random(),
                1.25 + 0.2 * math.random(),
                arg1.RootPart,
                true,
                10
            )
        end)
        wait((...))
        Utility_m:CreateSound(
            "rbxassetid://134852748577803",
            2,
            0.75 + 0.25 * math.random(),
            arg1.RootPart,
            true,
            10
        )
        CameraController_m:ShakeOnce(
            25,
            10,
            0.1,
            0.4,
            Vector3.new(0.25, 0.25, 0),
            Vector3.new(0, 0, 0)
        )

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t._Init(_) -- line: 56
end

return t
