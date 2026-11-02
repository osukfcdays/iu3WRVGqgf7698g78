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

function t.PlayFlashSound(arg1, arg2) -- line: 22
    -- upvalues:
    --  [1] Flashbang_m (copy)
    --  [2] Utility_m (copy)

    Flashbang_m.PlayFlashSound(arg1, arg2)
    Utility_m:CreateSound(
        "rbxassetid://17643323391",
        1,
        1,
        arg2,
        true,
        10
    )
end

function t.PlayRingingSound(_) -- line: 27
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:CreateSound(
        "rbxassetid://17643323267",
        1,
        0.85,
        script,
        true,
        10
    )
end

function t._Init(_) -- line: 35
end

return t
