local Grappler_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Grappler
)
local t = setmetatable({}, Grappler_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Grappler_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Grappler_m.new(...), t)
    t_1._line_rope = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Grey"):WaitForChild(
        "Attachment"
    ):WaitForChild("RopeConstraint")
    t_1:_Init()

    return t_1
end

function t.PlayShootSounds(arg1) -- line: 22
    arg1:CreateSound(
        "rbxassetid://71757681243259",
        1.5,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.PlayPullSounds(arg2) -- line: 26
    arg2:CreateSound(
        "rbxassetid://133299501943334",
        1.5,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t._UpdateLine(arg3) -- line: 34
    arg3._line_rope.Enabled = not arg3.ClientItem:Get("GrapplingHookPartActive")
end

function t._Init(arg4) -- line: 38
    arg4.ClientItem:GetDataChangedSignal("GrapplingHookPartActive"):Connect(function() -- line: 39
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateLine()
    end)
    arg4:_UpdateLine()
end

return t
