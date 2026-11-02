local AssaultRifle_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Assault Rifle"]
)
local t = setmetatable({}, AssaultRifle_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] AssaultRifle_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(AssaultRifle_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._UpdateDefaultAnimationsFromAmmo(arg1) -- line: 26
    local v2 = arg1.ClientItem:Get("Ammo")
    local v3 = arg1.ClientItem:Get("AmmoReserve")
    v3 = v2 <= 0 and true

    if v3 == arg1._is_empty then
        return
    end

    arg1._is_empty = v3
    v3 = if not arg1._is_empty then "" else "Empty"
    arg1:ChangeEquipAnimation("Equip" .. v3)
    arg1:ChangeIdleAnimation("Idle" .. v3)
    arg1:ChangeSprintAnimation("Sprint" .. v3)
    arg1:ChangeInspectAnimation("Inspect" .. v3)
end

function t._Init(arg2) -- line: 44
    arg2.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 45
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateDefaultAnimationsFromAmmo()
    end)
    arg2.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 49
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateDefaultAnimationsFromAmmo()
    end)
    arg2:_UpdateDefaultAnimationsFromAmmo()
end

return t
