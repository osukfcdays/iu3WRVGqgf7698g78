local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(3.9, script.Name, ...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] Utility_m (copy)

    Emote_m.PlayClient(arg1, ...)
    local v2 = arg1:_SetupProp(script.PhoneProp)
    arg1:_PlayAnimation("rbxassetid://87719925359671")
    wait(0.4)
    Utility_m:PlayParticles(v2)
    arg1:CreateSound(
        "rbxassetid://96932112018810",
        1,
        1,
        nil,
        true,
        5
    )
    wait(0.65)
    Utility_m:PlayParticles(v2)
    arg1:CreateSound(
        "rbxassetid://96932112018810",
        1,
        1,
        nil,
        true,
        5
    )
    wait(0.15)
    Utility_m:PlayParticles(v2)
    arg1:CreateSound(
        "rbxassetid://96932112018810",
        1,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 44
end

return t
