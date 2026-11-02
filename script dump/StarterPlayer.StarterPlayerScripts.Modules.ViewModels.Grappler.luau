local ClientViewModel_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.HideHookSubModel(arg1, arg2) -- line: 20
    arg1:HideSubModel("Hook", arg2)
end

function t.PlayShootSounds(arg3) -- line: 24
    arg3:CreateSound(
        "rbxassetid://92178332551602",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.PlayPullSounds(arg4) -- line: 28
    arg4:CreateSound(
        "rbxassetid://105623111691289",
        1.25,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t._Init(_) -- line: 36
end

return t
