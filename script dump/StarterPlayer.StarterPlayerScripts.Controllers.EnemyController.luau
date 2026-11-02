local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.Utility)
local ReplicatedController_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ReplicatedController
)
local t = setmetatable({}, ReplicatedController_m)
t.__index = t

function t._new() -- line: 11
    -- upvalues:
    --  [1] ReplicatedController_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ReplicatedController_m.new("Enemy"), t)
    t_1._model_to_enemy = {}
    t_1:_Init()

    return t_1
end

function t.GetEnemy(arg1, arg2) -- line: 26
    local v2 = arg1._model_to_enemy[arg2]

    if v2 then
        return v2
    end

    for _, val in pairs(arg1.Objects) do
        if val.Model == arg2 then
            return val
        end
    end
end

function t.Update(arg3, arg4) -- line: 40
    for _, val_1 in pairs(arg3.Objects) do
        if val_1.Update then
            val_1:Update(arg4)
        end
    end
end

function t._EnemyAdded(arg5, arg6) -- line: 52
    if arg6.Model then
        arg5._model_to_enemy[arg6.Model] = arg6
    end
end

function t._Init(arg7) -- line: 58
    -- upvalues:
    --  [1] RunService (copy)

    arg7.ObjectAdded:Connect(function(arg8) -- line: 59
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_EnemyAdded(arg8)
    end)
    arg7.ObjectRemoved:Connect(function(arg9) -- line: 63
        -- upvalues:
        --  [1] arg7 (copy)

        for key_2, val_2 in pairs(arg7._model_to_enemy) do
            if val_2 == arg9 then
                arg7._model_to_enemy[key_2] = nil
            end
        end
    end)
    RunService:BindToRenderStep("EnemyController", Enum.RenderPriority.Camera.Value + 1, function(
        arg10
    ) -- line: 71
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Update(arg10)
    end)

    for _, val_3 in pairs(arg7.Objects) do
        arg7:_EnemyAdded(val_3)
    end
end

return t._new()
