local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BattleAxe_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels["Battle Axe"])
local t = setmetatable({}, BattleAxe_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] BattleAxe_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(BattleAxe_m.new(...), t)
    t_1._equip_effect_hash = 0
    t_1._vfx_attachment = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Gem"):WaitForChild("VFX")
    t_1._blade1 = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Blade1")
    t_1._blade2 = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Blade2")
    t_1:_Init()

    return t_1
end

function t.Unequip(arg1, ...) -- line: 30
    -- upvalues:
    --  [1] BattleAxe_m (copy)

    arg1._equip_effect_hash += 1
    BattleAxe_m.Unequip(arg1, ...)
end

function t.Destroy(arg2) -- line: 35
    -- upvalues:
    --  [1] BattleAxe_m (copy)

    arg2._equip_effect_hash += 1
    BattleAxe_m.Destroy(arg2)
end

function t._EquipEffect(arg3, arg4) -- line: 44
    -- upvalues:
    --  [1] Utility_m (copy)

    arg3._equip_effect_hash += 1
    local EquipEffectHash = arg3._equip_effect_hash
    arg3:_LocalTransparencyModifier(arg3._blade1, "EquipEffect", 1)
    arg3:_LocalTransparencyModifier(arg3._blade2, "EquipEffect", 1)

    if not arg4 then
        wait(0.55)
    end

    if arg3._equip_effect_hash ~= EquipEffectHash then
        return
    end

    Utility_m:PlayParticles(arg3._vfx_attachment)
    arg3:CreateSound(
        "rbxassetid://117746175185603",
        0.5,
        0.5 + 0.125 * math.random(),
        true,
        0.3
    )

    if not arg4 then
        wait(0.3)
    end

    if arg3._equip_effect_hash ~= EquipEffectHash then
        return
    end

    arg3:CreateSound(
        "rbxassetid://75313977551180",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg3:CreateSound(
        "rbxassetid://107162559513589",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg3:CreateSound(
        "rbxassetid://115716079009988",
        0.875,
        1 + 0.2 * math.random(),
        true,
        5
    )
    arg3:_LocalTransparencyModifier(arg3._blade1, "EquipEffect", 0)
    arg3:_LocalTransparencyModifier(arg3._blade2, "EquipEffect", 0)
end

function t._Init(arg5) -- line: 77
    arg5.Equipped:Connect(function(mouse: Mouse) -- line: 78
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_EquipEffect(mouse)
    end)
end

return t
