local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseWarpstone_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseWarpstone)
local t = setmetatable({}, BaseWarpstone_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] BaseWarpstone_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseWarpstone_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 28
    -- upvalues:
    --  [1] Utility_m (copy)

    task.defer(function() -- line: 29
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Utility_m (ref)

        arg1.ClientItem.ProjectileThrown:Connect(function(arg2, _) -- line: 30
            -- upvalues:
            --  [1] arg1 (ref)
            --  [2] Utility_m (ref)

            arg1:_PlayWarpstoneSounds(
                Utility_m:CreateSound(
                    "rbxassetid://115283360430297",
                    0.5,
                    1 + 0.125 * math.random(),
                    arg2,
                    true
                ),
                Utility_m:CreateSound(
                    "rbxassetid://115283360430297",
                    0.375,
                    1.5 + 0.25 * math.random(),
                    arg2,
                    true
                )
            )
        end)
    end)
end

return t
