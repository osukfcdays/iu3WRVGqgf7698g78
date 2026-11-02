local Gunblade_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Gunblade
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 218, 155))
local t = setmetatable({}, Gunblade_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Gunblade_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gunblade_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 22
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.PlayAimSound(arg2, arg3) -- line: 26
    arg2:CreateSound(
        "rbxassetid://96253147006478",
        0.375,
        2 + (if not arg3 then 0 else 0.1),
        true,
        5
    )
end

function t._Init(arg4) -- line: 34
    arg4.Animator:OverridePreviousAnimationsOnPlay(true)
end

return t
