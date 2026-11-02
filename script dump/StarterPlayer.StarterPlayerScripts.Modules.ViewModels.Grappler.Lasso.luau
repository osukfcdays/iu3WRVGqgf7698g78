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
    t_1._rope_constraint = t_1.ItemModel:WaitForChild("Rope 2"):WaitForChild("Part3"):WaitForChild(
        "Attachment"
    ):WaitForChild("RopeConstraint")
    t_1._hook_submodel_hidden_until = 0
    t_1:_Init()

    return t_1
end

function t.HideHookSubModel(arg1, arg2) -- line: 23
    arg1:HideSubModel("Rope 2", arg2)
    arg1._hook_submodel_hidden_until = tick() + arg2
    arg1:_UpdateRopeEnabled()
    task.delay(arg2, arg1._UpdateRopeEnabled, arg1)
end

function t.PlayShootSounds(arg3) -- line: 30
    arg3:CreateSound(
        "rbxassetid://125047201358688",
        1.25,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.PlayPullSounds(arg4) -- line: 34
    arg4:CreateSound(
        "rbxassetid://125047201358688",
        1.25,
        1.4 + 0.2 * math.random(),
        true,
        5
    )
end

function t._UpdateRopeEnabled(arg5) -- line: 42
    local v4 = false
    local RopeConstraint = arg5._rope_constraint

    if tick() > arg5._hook_submodel_hidden_until then
        v4 = not arg5.Animator:IsAnimationPlaying("Shoot")

        if v4 then
            v4 = not arg5.Animator:IsAnimationPlaying("ShootWaiting")
        end
    end

    RopeConstraint.Visible = v4
end

function t._Init(arg6) -- line: 46
    arg6.AnimationPlayed:Connect(function() -- line: 47
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateRopeEnabled()
    end)
    arg6.AnimationStopped:Connect(function() -- line: 51
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateRopeEnabled()
    end)
    arg6:_UpdateRopeEnabled()
end

return t
