local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1:_Init()

    return t_1
end

function t.StartAiming(_) -- line: 22
    return false
end

function t.FinishAiming(_) -- line: 26
    return false
end

function t.ReplicateFromServer(arg3, arg4, ...) -- line: 30
    -- upvalues:
    --  [1] Gun_m (copy)

    if arg4 == "TransformProjectile" then
        if not arg3:IsRendered() then
            return
        end

        local v2 = ...
        arg3.ViewModel:TransformProjectile(v2, arg3._projectile_part_to_model[v2])

        return
    elseif arg4 == "MiniExplosionEffect" then
        if not arg3:IsRendered() then
            return
        end

        local v3 = ...
        v3:Destroy()
        arg3.ViewModel:PlayCastParticles(v3.Position, 2)

        return
    else
        Gun_m.ReplicateFromServer(arg3, arg4, ...)

        return
    end
end

function t._Init(_) -- line: 57
end

return t
