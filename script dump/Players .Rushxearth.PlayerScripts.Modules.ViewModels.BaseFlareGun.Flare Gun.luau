local BaseFlareGun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseFlareGun
)
local t = setmetatable({}, BaseFlareGun_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] BaseFlareGun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseFlareGun_m.new(...), t)
    t_1._is_empty = nil
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoContext(arg1) -- line: 28
    local v2 = arg1.ClientItem:Get("Ammo") <= 0 and true

    if v2 == arg1._is_empty then
        return
    end

    arg1._is_empty = v2
    v2 = if not arg1._is_empty then "" else "Empty"
    arg1:ChangeEquipAnimation("Equip" .. v2)
    arg1:ChangeIdleAnimation("Idle" .. v2)
    arg1:ChangeSprintAnimation("Sprint" .. v2)
    arg1:ChangeInspectAnimation("Inspect" .. v2)
end

function t._Init(arg2) -- line: 44
    arg2.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 45
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateAmmoContext()
    end)
    arg2:_UpdateAmmoContext()
    arg2:_RegisterDefaultAmmoVisuals()
end

return t
