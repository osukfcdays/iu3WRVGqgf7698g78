local Players = game:GetService("Players")
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local Flamethrower_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Flamethrower)
local t = setmetatable({}, Flamethrower_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Flamethrower_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Flamethrower_m.new(...), t)
    t_1._inspect_fire_effect_hash = 0
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 23
    -- upvalues:
    --  [1] Flamethrower_m (copy)

    arg1._inspect_fire_effect_hash += 1
    Flamethrower_m.Destroy(arg1)
end

function t._CreateFlameSoundEffects(arg2) -- line: 32
    local _ = {}

    return {
        arg2:CreateSound("rbxassetid://17209245734", 1, 1, true),
        arg2:CreateSound("rbxassetid://129124742663895", 2.25, 2, true)
    }
end

function t._InspectFireEffect(arg3) -- line: 36
    arg3._inspect_fire_effect_hash += 1
    local InspectFireEffectHash = arg3._inspect_fire_effect_hash
    wait(2.9)

    if arg3._inspect_fire_effect_hash ~= InspectFireEffectHash then
        return
    end

    arg3:SetFlameParticlesEnabled(true)
    local FlameParticlesHash = arg3._flame_particles_hash
    wait(0.2)

    if arg3._flame_particles_hash ~= FlameParticlesHash then
        return
    end

    arg3:SetFlameParticlesEnabled(false)
end

function t._Setup(arg4) -- line: 59
    -- upvalues:
    --  [1] WrapController_m (copy)

    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(arg4._flame_particles),
        arg4.ClientItem:GetWrap(),
        true
    )
end

function t._Init(arg5) -- line: 63
    arg5.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 64
        -- upvalues:
        --  [1] arg5 (copy)

        if animationTrack == "Inspect" then
            arg5:_InspectFireEffect()
        end
    end)
    arg5.Unequipped:Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg5 (copy)

        local v6 = arg5
        v6._inspect_fire_effect_hash += 1
    end)
    task.defer(function() -- line: 74
        -- upvalues:
        --  [1] arg5 (copy)

        arg5.ClientItem.Airblasted:Connect(function() -- line: 75
            -- upvalues:
            --  [1] arg5 (ref)

            local v7 = arg5
            v7._inspect_fire_effect_hash += 1
        end)
    end)
    arg5:_Setup()
end

return t
