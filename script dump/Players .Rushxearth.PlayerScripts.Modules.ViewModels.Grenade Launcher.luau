local ClientViewModel_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1.ReloadBulletsModel = t_1.ItemModel:WaitForChild("ReloadBullets")
    t_1.BulletsModel = t_1.ItemModel:WaitForChild("Bullets")
    t_1._bullet_parts = {}
    t_1:_Init()

    return t_1
end

function t._UpdateAmmoVisual(arg1) -- line: 31
    if arg1._destroyed then
        return
    end

    local v3 = arg1.ClientItem:Get("AmmoReserve")
    local v4 = arg1.ClientItem:Get("Ammo")
    local v6

    for key, val in pairs(arg1._bullet_parts.BulletsModel) do
        for _, val_1 in pairs(val:GetChildren()) do
            v6 = if not (v4 >= key) then 1 else 0
            arg1:_LocalTransparencyModifier(val_1, "AmmoVisual", v6)
        end
    end

    for key_2, val_2 in pairs(arg1._bullet_parts.ReloadBulletsModel) do
        for _, val_3 in pairs(val_2:GetChildren()) do
            v6 = if not (v3 >= key_2) then 1 else 0
            arg1:_LocalTransparencyModifier(val_3, "AmmoVisual", v6)
        end
    end
end

function t._Setup(arg2) -- line: 52
    for _, val_4 in pairs({ "ReloadBulletsModel", "BulletsModel" }) do
        arg2._bullet_parts[val_4] = {}

        for index = 1, 6 do
            arg2._bullet_parts[val_4][index] = arg2[val_4]:WaitForChild(index)
        end
    end
end

function t._Init(arg3) -- line: 62
    arg3.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 63
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    arg3.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 67
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    arg3:_Setup()
    task.spawn(arg3._UpdateAmmoVisual, arg3)
end

return t
