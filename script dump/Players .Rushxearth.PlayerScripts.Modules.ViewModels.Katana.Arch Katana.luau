local Players = game:GetService("Players")
local ViewModelParticlesLogic_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ViewModelParticlesLogic
)
local Katana_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Katana)
local t = setmetatable({}, Katana_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Katana_m (copy)
    --  [2] t (copy)
    --  [3] ViewModelParticlesLogic_m (copy)

    local t_1 = setmetatable(Katana_m.new(...), t)
    t_1._particles_logic = ViewModelParticlesLogic_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.PlayDeflectHitSounds(arg1) -- line: 23
    arg1:CreateSound(
        "rbxassetid://14776414133",
        1.25,
        1.5 + 0.5 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://14776437962",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://82797934287631",
        1,
        0.9 + 0.2 * math.random(),
        true,
        5
    )
end

function t.Unequip(arg2, ...) -- line: 29
    -- upvalues:
    --  [1] Katana_m (copy)

    arg2._particles_logic:CancelEffect()
    Katana_m.Unequip(arg2, ...)
end

function t.Destroy(arg3) -- line: 34
    -- upvalues:
    --  [1] Katana_m (copy)

    arg3._particles_logic:Destroy()
    Katana_m.Destroy(arg3)
end

function t._Init(arg4) -- line: 43
    arg4.Equipped:Connect(function(mouse: Mouse) -- line: 44
        -- upvalues:
        --  [1] arg4 (copy)

        local v5 = if not mouse then 0.5 else 0
        arg4._particles_logic:PlayEffect(0, v5)
    end)
end

return t
