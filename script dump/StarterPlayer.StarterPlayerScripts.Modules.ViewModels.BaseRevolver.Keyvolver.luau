local BaseRevolver_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.BaseRevolver
)
local gradient = ColorSequence.new(Color3.fromRGB(255, 218, 155))
local t = setmetatable({}, BaseRevolver_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] BaseRevolver_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BaseRevolver_m.new(...), t)
    t_1._is_empty = nil
    t_1._keyvolver_bullets = {}
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 25
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._UpdateAmmoContext(arg2) -- line: 33
    local v3 = arg2.ClientItem:Get("Ammo")
    local v4 = arg2.ClientItem:Get("AmmoReserve")
    local v5

    for key, val in pairs(arg2._keyvolver_bullets.Bullets) do
        v5 = if not (v3 >= key) then 1 else 0
        arg2:_LocalTransparencyModifier(val, "AmmoVisual", v5)
    end

    for key_1, val_1 in pairs(arg2._keyvolver_bullets.ReloadBullets) do
        v5 = if not (v3 < key_1) then 1 else if not (key_1 <= v3 + v4) then 1 else 0
        arg2:_LocalTransparencyModifier(val_1, "AmmoVisual", v5)
    end

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

function t._Setup(arg3) -- line: 60
    for _, val_2 in pairs({ "Bullets", "ReloadBullets" }) do
        arg3._keyvolver_bullets[val_2] = {}

        for index = 1, 6 do
            arg3._keyvolver_bullets[val_2][index] = arg3.ItemModel:WaitForChild(val_2 .. index):WaitForChild(
                "Bullet"
            )
        end
    end
end

function t._Init(arg4) -- line: 70
    arg4.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 71
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoContext()
    end)
    arg4.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 75
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAmmoContext()
    end)
    arg4:_Setup()
    arg4:_UpdateAmmoContext()
end

return t
