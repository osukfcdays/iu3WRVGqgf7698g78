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

function t.PlayFlashSound(_, arg2) -- line: 22
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://14778230670",
        1,
        1,
        arg2,
        true,
        10
    )
end

function t.PlayRingingSound(_) -- line: 26
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:CreateSound(
        "rbxassetid://14778230632",
        1,
        1,
        script,
        true,
        10
    )
end

function t._Init(_) -- line: 34
end

return t
