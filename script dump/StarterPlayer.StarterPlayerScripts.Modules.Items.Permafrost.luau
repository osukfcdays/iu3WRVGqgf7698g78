local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1.ToggleAimEnabled = nil
    t_1:_Init()

    return t_1
end

function t.StartAiming(arg1, arg2) -- line: 24
    if
        not arg2
        and (tick() < arg1._shoot_cooldown or tick() < arg1._reload_cooldown or arg1:Get("Ammo") <= 0 or arg1:IsEquipping())
    then
        return
    end

    arg1._reload_cooldown = tick() + 1.5
    task.delay(1.5, arg1._CheckReload, arg1)
    arg1.ViewModel:StopAnimation("Inspect")
    arg1.ViewModel:PlayAnimation("Throw", 1)

    return true, "StartAiming", (arg1.ClientFighter:GetCameraData())
end

function t.FinishAiming(_, _) -- line: 39
    return false
end

function t.StartSprinting(_, _) -- line: 43
    return false
end

function t._Init(_) -- line: 51
end

return t
