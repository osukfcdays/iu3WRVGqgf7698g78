local Flamethrower_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Flamethrower
)
local t = setmetatable({}, Flamethrower_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Flamethrower_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Flamethrower_m.new(...), t)
    t_1._inspect_fire_effect_hash = 0
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 22
    -- upvalues:
    --  [1] Flamethrower_m (copy)

    arg1._inspect_fire_effect_hash += 1
    Flamethrower_m.Destroy(arg1)
end

function t._CreateFlameSoundEffects(arg2) -- line: 31
    local _ = {}

    return {
        arg2:CreateSound("rbxassetid://17209245734", 0.5, 1.5, true),
        arg2:CreateSound("rbxassetid://85294603652818", 1.5, 1, true)
    }
end

function t._InspectFireEffect(arg3) -- line: 35
    arg3._inspect_fire_effect_hash += 1
    local InspectFireEffectHash = arg3._inspect_fire_effect_hash
    wait(1.7)

    if arg3._inspect_fire_effect_hash ~= InspectFireEffectHash then
        return
    end

    arg3:SetFlameParticlesEnabled(true)
    local FlameParticlesHash = arg3._flame_particles_hash
    wait(0.1)

    if arg3._flame_particles_hash == FlameParticlesHash then
        arg3:SetFlameParticlesEnabled(false)
    end

    wait(0.2)

    if arg3._inspect_fire_effect_hash ~= InspectFireEffectHash then
        return
    end

    arg3:SetFlameParticlesEnabled(true)
    local FlameParticlesHash_1 = arg3._flame_particles_hash
    wait(0.1)

    if arg3._flame_particles_hash == FlameParticlesHash_1 then
        arg3:SetFlameParticlesEnabled(false)
    end
end

function t._Init(arg4) -- line: 72
    arg4.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 73
        -- upvalues:
        --  [1] arg4 (copy)

        if animationTrack == "Inspect" then
            arg4:_InspectFireEffect()
        end
    end)
    arg4.Unequipped:Connect(function() -- line: 79
        -- upvalues:
        --  [1] arg4 (copy)

        local v3 = arg4
        v3._inspect_fire_effect_hash += 1
    end)
    task.defer(function() -- line: 83
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.ClientItem.Airblasted:Connect(function() -- line: 84
            -- upvalues:
            --  [1] arg4 (ref)

            local v4 = arg4
            v4._inspect_fire_effect_hash += 1
        end)
    end)
end

return t
