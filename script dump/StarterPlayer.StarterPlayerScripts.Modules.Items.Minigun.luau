local Gun_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
local t = setmetatable({}, Gun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Gun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gun_m.new(...), t)
    t_1._charging_move_speed_hash = 0
    t_1:_Init()

    return t_1
end

function t.CanQuickAttack(_) -- line: 24
    return false
end

function t._UpdateChargingMoveSpeed(arg2) -- line: 32
    if not arg2.ClientFighter.IsLocalPlayer then
        return
    end

    arg2._charging_move_speed_hash += 1

    repeat
        local Entity = arg2.ClientFighter.Entity
        local v2 = arg2.IsEquipped and arg2:Get("IsAiming") and arg2.Info.ChargingSpeedBoost or 0
        Entity:SetBoost("Speed", "MinigunCharge", 0.5, v2)
        wait(0.25)
    until arg2._destroyed or arg2._charging_move_speed_hash ~= arg2._charging_move_speed_hash or not arg2.ClientFighter:IsAlive() or not arg2.IsEquipped
end

function t._Init(arg3) -- line: 51
    arg3:GetDataChangedSignal("IsAiming"):Connect(function() -- line: 52
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateChargingMoveSpeed()
    end)
    arg3.EquippedChanged:Connect(function() -- line: 56
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateChargingMoveSpeed()
    end)
end

return t
