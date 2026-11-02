local Players = game:GetService("Players")
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local ChainsawParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ChainsawParticles"
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1._spike_toggle = false
    t_1._spike_parts = {}
    t_1._next_toggle = 0
    t_1._hold_particles = {}
    t_1._idle_sound_hash = 0
    t_1:_Init()

    return t_1
end

function t.CreateHoldSounds(arg1) -- line: 29
    return { arg1:CreateSound("rbxassetid://16359327230", 0.5, 1, true) }
end

function t.PlayStartingHoldSounds(_) -- line: 33
end

function t.EnableParticles(arg3, arg4) -- line: 37
    for _, val in pairs(arg3._hold_particles) do
        val.Enabled = arg4
    end
end

function t.Update(arg5, arg6, arg7, arg8) -- line: 43
    -- upvalues:
    --  [1] ClientViewModel_m (copy)

    ClientViewModel_m.Update(arg5, arg6, arg7, arg8)

    if not arg8.IsActive then
        return
    end

    if tick() < arg5._next_toggle then
        return
    end

    arg5._next_toggle = tick() + 0.03
    arg5._spike_toggle = not arg5._spike_toggle

    for key_1, val_1 in pairs(arg5._spike_parts) do
        arg5:_LocalTransparencyModifier(
            key_1,
            "Update",
            if val_1 ~= arg5._spike_toggle then 1 else 0
        )
    end
end

function t._PlayIdleSound(arg9, arg10, arg11) -- line: 66
    local v4 = arg11 or 0.2

    if v4 > 0 then
        wait(v4)

        if arg10 ~= arg9._idle_sound_hash then
            return
        end
    end

    local v5 = arg9:CreateSound("rbxassetid://13645858587", 0.375, 1, true)

    if v5 then
        v5.Looped = true
    end

    local v6 = arg9:CreateSound("rbxassetid://13646484249", 0.375, 1, true)

    if v6 then
        v6.Looped = true
    end

    local v7 = arg9:CreateSound("rbxassetid://13646484113", 0.25, 1, true)

    if v7 then
        v7.Looped = true
    end
end

function t._RegisterSpikesPart(arg12, arg13, arg14) -- line: 96
    arg12._spike_parts[arg13] = arg14
end

function t._RegisterBlade(arg15, arg16) -- line: 100
    -- upvalues:
    --  [1] ChainsawParticles (copy)

    local v8 = pairs
    local v9 = ChainsawParticles:FindFirstChild(arg15.Name) or ChainsawParticles.Default

    for _, child in v8(v9:GetChildren()) do
        local v10 = child:Clone()
        v10.Parent = arg16
        table.insert(arg15._hold_particles, v10)
    end
end

function t._Init(arg17) -- line: 108
    arg17.Equipped:Connect(function() -- line: 109
        -- upvalues:
        --  [1] arg17 (copy)

        local v11 = arg17
        v11._idle_sound_hash += 1
        arg17:_PlayIdleSound(arg17._idle_sound_hash)
    end)
    arg17.Unequipped:Connect(function() -- line: 114
        -- upvalues:
        --  [1] arg17 (copy)

        local v12 = arg17
        v12._idle_sound_hash += 1
    end)
end

return t
