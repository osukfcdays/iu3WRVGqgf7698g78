local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._PlayWarpstoneSounds(arg1, ...) -- line: 28
    -- upvalues:
    --  [1] Utility_m (copy)

    local t_2 = {}

    for _, val in pairs({ ... }) do
        t_2[val] = val.Volume
        val.Looped = true
    end

    Utility_m:RenderstepForLoop(0, 100, 2, function(arg2) -- line: 36
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] t_2 (copy)

        if arg1._destroyed then
            return true
        end

        local v3 = arg2 / 100

        for key_1, val_1 in pairs(t_2) do
            key_1.Volume = val_1 * v3
        end
    end)
end

function t._Init(_) -- line: 49
end

return t
