local Custom_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom
)
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1._portal_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 22
    return nil
end

function t.StartShooting(arg2, ...) -- line: 26
    return arg2:_OpenPortal("StartShooting", ...)
end

function t.StartAiming(arg3, ...) -- line: 30
    return arg3:_OpenPortal("StartAiming", ...)
end

function t._OpenPortal(arg4, arg5, arg6) -- line: 38
    if not arg6 and (tick() < arg4._portal_cooldown or arg4:IsEquipping()) then
        return
    end

    arg4._portal_cooldown = tick() + arg4.Info.ShootCooldown
    local v2 = arg4.ClientFighter:GetCameraData()
    arg4:_Recoil(1)
    arg4.ViewModel:MuzzleFlash()
    arg4.ViewModel:StopAnimation("Equip", 0)
    arg4.ViewModel:PlayAnimation("Shoot1", arg4.Info.ShootCooldown, 0)

    return true, arg5, v2
end

function t._Init(_) -- line: 55
end

return t
