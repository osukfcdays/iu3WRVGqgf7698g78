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

function t.StartAiming(_, _) -- line: 22
    return false
end

function t.FinishAiming(_, _) -- line: 26
    return false
end

function t.StartSprinting(_, _) -- line: 30
    return false
end

function t._UpdateViewModelAnimations(arg7) -- line: 38
    local v2 = if arg7:Get("Ammo") <= 0 then arg7:Get("AmmoReserve") <= 0 and true else false
    local v3 = if not v2 then "Equip" else "EmptyEquip"
    arg7.ViewModel:ChangeEquipAnimation(v3)
    arg7.ViewModel:ChangeIdleAnimation(if v2 then "EmptyIdle" else "Idle")
    arg7.ViewModel:ChangeInspectAnimation(if v2 then "EmptyInspect" else "Inspect")
    arg7.ViewModel:ChangeSprintAnimation(if v2 then "EmptySprint" else "Sprint")
end

function t._Init(arg8) -- line: 47
    arg8:GetDataChangedSignal("Ammo"):Connect(function() -- line: 48
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateViewModelAnimations()
    end)
    task.defer(arg8._UpdateViewModelAnimations, arg8)
end

return t
