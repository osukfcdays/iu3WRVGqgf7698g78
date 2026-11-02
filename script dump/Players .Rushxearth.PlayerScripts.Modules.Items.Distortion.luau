local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1._vortex_cooldown = 0
    t_1:_Init()

    return t_1
end

function t.StartAiming(arg1, arg2) -- line: 24
    if not arg2 and (tick() < arg1._vortex_cooldown or arg1:IsEquipping()) then
        return
    end

    arg1._vortex_cooldown = tick() + arg1.Info.VortexCooldown
    local v2 = arg1.ClientFighter:GetCameraData()
    arg1:_Recoil(1)
    arg1:CooldownEffect("rbxassetid://76793585944473", arg1.Info.VortexCooldown, "Vortex")
    arg1.ViewModel:MuzzleFlash()
    arg1.ViewModel:StopAnimation("Inspect")
    arg1.ViewModel:StopAnimation("Equip", 0)
    arg1.ViewModel:PlayAnimation("Shoot1")

    return true, "StartAiming", v2
end

function t.FinishAiming(_, _) -- line: 43
    return false
end

function t.StartSprinting(_, _) -- line: 47
    return false
end

function t._Init(_) -- line: 55
end

return t
