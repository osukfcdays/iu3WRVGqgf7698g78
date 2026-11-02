local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Sniper_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModels:WaitForChild("Sniper")
)
local gradient = ColorSequence.new(Color3.fromRGB(198, 99, 255))
local t = setmetatable({}, Sniper_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Sniper_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Sniper_m.new(...), t)
    t_1._reload_start_attachment = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Black"):WaitForChild(
        "Start"
    )
    t_1._reload_finish_attachment = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Black"):WaitForChild(
        "Finish"
    )
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 27
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.PlayReloadStartParticles(arg2) -- line: 31
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:PlayParticles(arg2._reload_start_attachment)
end

function t.PlayReloadFinishParticles(arg3) -- line: 35
    -- upvalues:
    --  [1] Utility_m (copy)

    Utility_m:PlayParticles(arg3._reload_finish_attachment)
end

function t._Init(_) -- line: 43
end

return t
