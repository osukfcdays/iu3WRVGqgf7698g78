local BaseChainsaw_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild(
        "BaseChainsaw"
    )
)
local t = setmetatable({}, BaseChainsaw_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseChainsaw_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseChainsaw_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.CreateHoldSounds(arg1) -- line: 20
    local t_2 = {}
    local v3 = arg1:CreateSound("rbxassetid://16359327230", 0.75, 1.25, true)
    local PitchShiftSoundEffect = Instance.new("PitchShiftSoundEffect")
    PitchShiftSoundEffect.Octave = 0.625
    PitchShiftSoundEffect.Parent = v3
    table.insert(t_2, v3)
    local v4 = arg1:CreateSound("rbxassetid://16359327230", 0.5, 1.2, true)
    local PitchShiftSoundEffect_1 = Instance.new("PitchShiftSoundEffect")
    PitchShiftSoundEffect_1.Octave = 0.5
    PitchShiftSoundEffect_1.Parent = v4
    table.insert(t_2, v4)

    return t_2
end

function t.PlayStartingHoldSounds(arg2) -- line: 38
    arg2:CreateSound(
        "rbxassetid://18763594759",
        0.5,
        1,
        true,
        10
    )
end

function t._Init(arg3) -- line: 46
    arg3:_RegisterBlade(arg3.ItemModel:WaitForChild("Drill"):WaitForChild("Blade"))
end

return t
