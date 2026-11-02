local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ViewModelParticlesLogic_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModelParticlesLogic
)
local Molotov_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Molotov)
local t = setmetatable({}, Molotov_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Molotov_m (copy)
    --  [2] t (copy)
    --  [3] ViewModelParticlesLogic_m (copy)

    local t_1 = setmetatable(Molotov_m.new(...), t)
    t_1._particles_logic = ViewModelParticlesLogic_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.ExplosionEffect(arg1, arg2, arg3) -- line: 25
    -- upvalues:
    --  [1] Molotov_m (copy)
    --  [2] Utility_m (copy)

    Molotov_m.ExplosionEffect(arg1, arg2, arg3)
    Utility_m:CreateSound(
        "rbxassetid://72790275842437",
        0.5,
        1 + 0.25 * math.random(),
        arg2,
        true,
        10
    )
end

function t.Unequip(arg4, ...) -- line: 30
    -- upvalues:
    --  [1] Molotov_m (copy)

    arg4._particles_logic:CancelEffect()
    Molotov_m.Unequip(arg4, ...)
end

function t.Destroy(arg5) -- line: 35
    -- upvalues:
    --  [1] Molotov_m (copy)

    arg5._particles_logic:Destroy()
    Molotov_m.Destroy(arg5)
end

function t._Init(arg6) -- line: 44
    arg6.Equipped:Connect(function(mouse: Mouse) -- line: 45
        -- upvalues:
        --  [1] arg6 (copy)

        local v4 = if not mouse then 0.55 else 0
        arg6._particles_logic:PlayEffect(0, v4)
    end)
    arg6.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 49
        -- upvalues:
        --  [1] arg6 (copy)

        if animationTrack == "ThrowFinish" then
            arg6._particles_logic:PlayEffect(0.65, 0.5)

            return
        end

        if animationTrack == "LobFinish" then
            arg6._particles_logic:PlayEffect(0.65, 0.5)
        end
    end)
end

return t
