local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Flashbang_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Flashbang)
local t = setmetatable({}, Flashbang_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Flashbang_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Flashbang_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayFlashSound(_, arg2) -- line: 22
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://94088948330527",
        1,
        1,
        arg2,
        true,
        10
    )
end

function t._Init(_) -- line: 30
end

return t
