local Players = game:GetService("Players")
local ViewModelParticlesLogic_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModelParticlesLogic
)
local BaseCrossbow_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.BaseCrossbow)
local gradient = ColorSequence.new(Color3.fromRGB(8, 255, 152))
local t = setmetatable({}, BaseCrossbow_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] BaseCrossbow_m (copy)
    --  [2] t (copy)
    --  [3] ViewModelParticlesLogic_m (copy)

    local t_1 = setmetatable(BaseCrossbow_m.new(...), t)
    t_1.ShouldPlayReloadAnimationInstantly = true
    t_1._particles_logic = ViewModelParticlesLogic_m.new(t_1)
    t_1._is_empty = nil
    t_1:_Init()

    return t_1
end

function t.GetFriendlyTracerColor(_) -- line: 28
    -- upvalues:
    --  [1] gradient (copy)

    return gradient
end

function t.Unequip(arg2, ...) -- line: 32
    -- upvalues:
    --  [1] BaseCrossbow_m (copy)

    arg2._particles_logic:CancelEffect()
    BaseCrossbow_m.Unequip(arg2, ...)
end

function t.Destroy(arg3) -- line: 37
    -- upvalues:
    --  [1] BaseCrossbow_m (copy)

    arg3._particles_logic:Destroy()
    BaseCrossbow_m.Destroy(arg3)
end

function t._UpdateDefaultAnimationsFromAmmo(arg4) -- line: 46
    local v3 = arg4.ClientItem:Get("Ammo")
    local v4 = arg4.ClientItem:Get("AmmoReserve")
    v4 = v3 <= 0 and true

    if v4 == arg4._is_empty then
        return
    end

    arg4._is_empty = v4
    arg4:ChangeInspectAnimation("Inspect" .. (if not arg4._is_empty then "" else "Empty"))
end

function t._Init(arg5) -- line: 59
    arg5.Equipped:Connect(function(mouse: Mouse) -- line: 60
        -- upvalues:
        --  [1] arg5 (copy)

        local v7 = if not mouse then 0.7 else 0
        arg5._particles_logic:PlayEffect(0, v7)
    end)
    arg5.ClientItem:GetDataChangedSignal("AmmoReserve"):Connect(function() -- line: 64
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateDefaultAnimationsFromAmmo()
    end)
    arg5.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 68
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateDefaultAnimationsFromAmmo()
    end)
    arg5:_UpdateDefaultAnimationsFromAmmo()
    arg5:_RegisterAmmoVisual(arg5.ItemModel:WaitForChild("Arrow"):WaitForChild("MeshPart"))
    arg5:_RegisterAmmoVisual(
        arg5.ItemModel:WaitForChild("Arrow"):WaitForChild("MeshPart"):WaitForChild("Attachment"):WaitForChild(
            "arrow"
        )
    )
end

return t
