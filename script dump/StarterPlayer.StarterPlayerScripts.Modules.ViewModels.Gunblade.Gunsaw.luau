local Gunblade_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ViewModels.Gunblade
)
local t = setmetatable({}, Gunblade_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Gunblade_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Gunblade_m.new(...), t)
    t_1._spike_toggle = false
    t_1._next_toggle = 0
    t_1._spikes1 = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Spikes1")
    t_1._spikes2 = t_1.ItemModel:WaitForChild("Body"):WaitForChild("Spikes2")
    t_1:_Init()

    return t_1
end

function t.Update(arg1, arg2, arg3, arg4) -- line: 27
    -- upvalues:
    --  [1] Gunblade_m (copy)

    Gunblade_m.Update(arg1, arg2, arg3, arg4)

    if not arg4.IsActive then
        return
    end

    if tick() < arg1._next_toggle then
        return
    end

    arg1._next_toggle = tick() + 0.03
    arg1._spike_toggle = not arg1._spike_toggle
    arg1:_LocalTransparencyModifier(
        arg1._spikes1,
        "Update",
        if not arg1._spike_toggle then 1 else 0
    )
    arg1:_LocalTransparencyModifier(arg1._spikes2, "Update", if arg1._spike_toggle then 1 else 0)
end

function t._PlayIdleSound(arg5) -- line: 48
    local v3 = arg5:CreateSound(
        "rbxassetid://13645858587",
        0.375,
        1,
        true,
        nil,
        10,
        40
    )

    if v3 then
        v3.Looped = true
    end

    local v4 = arg5:CreateSound(
        "rbxassetid://13646484249",
        0.375,
        1,
        true,
        nil,
        10,
        40
    )

    if v4 then
        v4.Looped = true
    end

    local v5 = arg5:CreateSound(
        "rbxassetid://13646484113",
        0.25,
        1,
        true,
        nil,
        10,
        40
    )

    if v5 then
        v5.Looped = true
    end
end

function t._Init(arg6) -- line: 68
    arg6.Equipped:Connect(function() -- line: 69
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_PlayIdleSound()
    end)
end

return t
