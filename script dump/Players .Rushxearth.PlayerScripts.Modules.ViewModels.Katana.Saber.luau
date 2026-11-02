local Katana_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Katana
)
local t = setmetatable({}, Katana_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Katana_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Katana_m.new(...), t)
    t_1._equip_effect_hash = 0
    t_1._blade = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Blade")
    t_1:_Init()

    return t_1
end

function t.PlayDeflectHitSounds(arg1) -- line: 25
    arg1:CreateSound(
        "rbxassetid://17640978084",
        1.75,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.Unequip(arg2, ...) -- line: 29
    -- upvalues:
    --  [1] Katana_m (copy)

    arg2._equip_effect_hash += 1
    Katana_m.Unequip(arg2, ...)
end

function t.Destroy(arg3) -- line: 34
    -- upvalues:
    --  [1] Katana_m (copy)

    arg3._equip_effect_hash += 1
    Katana_m.Destroy(arg3)
end

function t._EquipEffect(arg4, arg5) -- line: 43
    arg4._equip_effect_hash += 1
    local EquipEffectHash = arg4._equip_effect_hash
    arg4:_LocalTransparencyModifier(arg4._blade, "EquipEffect", 1)

    if not arg5 then
        wait(0.4)
    end

    if arg4._equip_effect_hash ~= EquipEffectHash then
        return
    end

    arg4:CreateSound(
        "rbxassetid://17641562119",
        1.5,
        1,
        true,
        5
    )
    arg4:_LocalTransparencyModifier(arg4._blade, "EquipEffect", 0)
end

function t._Init(arg6) -- line: 61
    arg6.Equipped:Connect(function(mouse: Mouse) -- line: 62
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_EquipEffect(mouse)
    end)
end

return t
