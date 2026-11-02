local PaintballGun_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels["Paintball Gun"]
)
local color = Color3.fromRGB(0, 0, 0)
local t = setmetatable({}, PaintballGun_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] PaintballGun_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(PaintballGun_m.new(...), t)
    t_1._bobas_part = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Bobas")
    t_1:_Init()

    return t_1
end

function t.GetPaintballColor(_) -- line: 24
    -- upvalues:
    --  [1] color (copy)

    return color
end

function t._UpdateAmmoVisual(arg2) -- line: 32
    if arg2._destroyed then
        return
    end

    arg2:_LocalTransparencyModifier(
        arg2._bobas_part,
        "AmmoVisual",
        if arg2.ClientItem:Get("Ammo") <= 0 then 1 else 0
    )
end

function t._Init(arg3) -- line: 40
    arg3.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 41
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    task.spawn(arg3._UpdateAmmoVisual, arg3)
end

return t
