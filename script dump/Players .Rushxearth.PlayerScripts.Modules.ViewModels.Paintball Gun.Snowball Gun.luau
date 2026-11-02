local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PaintballGun_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Paintball Gun"]
)
local color = Color3.fromRGB(255, 255, 255)
local color_1 = Color3.fromRGB(253, 234, 141)
local t = setmetatable({}, PaintballGun_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] PaintballGun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(PaintballGun_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetPaintballColor(_) -- line: 25
    -- upvalues:
    --  [1] color_1 (copy)
    --  [2] color (copy)

    return math.random() < 0.001 and color_1 or color
end

function t.PlaySplatSound(_, arg3) -- line: 29
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:CreateSound(
        "rbxassetid://11800684590",
        0.5,
        0.9 + 0.2 * math.random(),
        arg3,
        true,
        5
    )
end

function t._Init(_) -- line: 37
end

return t
