local Utility_m = require(game:GetService("ReplicatedStorage").Modules.Utility)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.RefillAmmoVignette = t_1.FighterInterface.Frame:WaitForChild("RefillAmmoVignette")
    t_1.RefillAmmoVignetteTexture = t_1.RefillAmmoVignette:WaitForChild("Texture")
    t_1._refill_ammo_effect_hash = 0
    t_1:_Init()

    return t_1
end

function t.RefillAmmoEffect(arg2) -- line: 26
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg2.FighterInterface:IsActive() then
        return
    end

    arg2._refill_ammo_effect_hash += 1
    local RefillAmmoEffectHash = arg2._refill_ammo_effect_hash
    arg2.FighterInterface:CreateSound(
        "rbxassetid://93185674378015",
        1,
        1,
        script,
        true,
        10
    )
    arg2.FighterInterface:CreateSound(
        "rbxassetid://96308464356768",
        1.5,
        1,
        script,
        true,
        10
    )
    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        4,
        function(arg3) -- line: 40
            -- upvalues:
            --  [1] RefillAmmoEffectHash (copy)
            --  [2] arg2 (copy)

            if RefillAmmoEffectHash ~= arg2._refill_ammo_effect_hash then
                return true
            end

            local v1 = 0 + 1 * (arg3 / 100)
            arg2.RefillAmmoVignette.ImageTransparency = v1
            arg2.RefillAmmoVignetteTexture.ImageTransparency = v1
        end
    )
end

function t.Destroy(arg4) -- line: 53
    arg4._refill_ammo_effect_hash += 1
end

function t._Init(_) -- line: 61
end

return t
