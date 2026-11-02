local Uzi_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Uzi)
local gradient = ColorSequence.new(Color3.fromRGB(0, 255, 0))
local t = setmetatable({}, Uzi_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Uzi_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Uzi_m.new(...), t)
    t_1._body_money = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Money")
    t_1._body_money_decal1 = t_1._body_money:WaitForChild("Decal1")
    t_1._body_money_decal2 = t_1._body_money:WaitForChild("Decal2")
    t_1._magazine_money = t_1.ItemModel:WaitForChild("Magazine"):WaitForChild("Money")
    t_1._magazine_money_decal1 = t_1._magazine_money:WaitForChild("Decal1")
    t_1._magazine_money_decal2 = t_1._magazine_money:WaitForChild("Decal2")
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 29
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t._UpdateAmmoVisual(arg2) -- line: 37
    if arg2._destroyed then
        return
    end

    local v3 = arg2.ClientItem:Get("Ammo")
    local v4 = if v3 > 0 then 0 else 1
    local v5 = if v3 > 1 or arg2:IsAnimationPlaying("Reload") then 0 else 1
    arg2:_LocalTransparencyModifier(arg2._body_money, "AmmoVisual", v4)
    arg2:_LocalTransparencyModifier(arg2._body_money_decal1, "AmmoVisual", v4)
    arg2:_LocalTransparencyModifier(arg2._body_money_decal2, "AmmoVisual", v4)
    arg2:_LocalTransparencyModifier(arg2._magazine_money, "AmmoVisual", v5)
    arg2:_LocalTransparencyModifier(arg2._magazine_money_decal1, "AmmoVisual", v5)
    arg2:_LocalTransparencyModifier(arg2._magazine_money_decal2, "AmmoVisual", v5)
end

function t._Init(arg3) -- line: 55
    arg3.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 56
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    arg3.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 60
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    arg3.AnimationPlayed:Connect(function() -- line: 64
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    arg3.AnimationStopped:Connect(function() -- line: 68
        -- upvalues:
        --  [1] arg3 (copy)

        arg3:_UpdateAmmoVisual()
    end)
    task.defer(arg3._UpdateAmmoVisual, arg3)
end

return t
