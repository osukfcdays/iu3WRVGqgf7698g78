local Molotov_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Molotov
)
local t = setmetatable({}, Molotov_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Molotov_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Molotov_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._Init(arg1) -- line: 26
    arg1.Animator.AnimationStopped:Connect(function(arg2) -- line: 27
        -- upvalues:
        --  [1] arg1 (copy)

        local v2 = arg1.Animator:GetEquipAnimationKey()
        local v3 = arg1.Animator:GetIdleAnimationKey()

        if arg2 ~= v2 then
            return
        end

        local v4 = arg1.Animator:GetAnimationTrack(v2)

        if v4 then
            v4:Stop(0)
        end

        local v6 = arg1.Animator:GetAnimationTrack(v3)

        if v6 then
            v6:Stop(0)
            v6:Play(0)
        end
    end)
end

return t
