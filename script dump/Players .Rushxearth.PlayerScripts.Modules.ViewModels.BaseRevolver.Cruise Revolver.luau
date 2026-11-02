local BaseRevolver_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRevolver
)
local gradient = ColorSequence.new(Color3.fromRGB(53, 194, 255))
local t = setmetatable({}, BaseRevolver_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] BaseRevolver_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRevolver_m.new(...), t)
    t_1._is_empty = false
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 24
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._UpdateDefaultAnimationsFromAmmo(arg2) -- line: 32
    local v3 = arg2.ClientItem:Get("Ammo")
    local v4 = arg2.ClientItem:Get("AmmoReserve")
    v4 = v3 <= 0 and true

    if v4 == arg2._is_empty then
        return
    end

    arg2._is_empty = v4
    v4 = if not arg2._is_empty then "" else "Empty"
    arg2:ChangeEquipAnimation("Equip" .. v4)
    arg2:ChangeIdleAnimation("Idle" .. v4)
    arg2:ChangeSprintAnimation("Sprint" .. v4)
    arg2:ChangeInspectAnimation("Inspect" .. v4)
end

function t._Init(arg3) -- line: 50
    arg3.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 51
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateDefaultAnimationsFromAmmo()
    end)
    arg3.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 55
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateDefaultAnimationsFromAmmo()
    end)
    arg3:_UpdateDefaultAnimationsFromAmmo()
end

return t
