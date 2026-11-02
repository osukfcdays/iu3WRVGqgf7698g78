local Players = game:GetService("Players")
local InfiniteAmmoParticle = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "InfiniteAmmoParticle"
)
local t = { "RichText", "Text", "TextColor", "TextTransparency" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1, arg2) -- line: 10
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2._ammo_element = arg1
    t_2._reserve_element = arg2
    t_2._is_active = false
    t_2._ammo_active = false
    t_2._reserve_active = false
    t_2._particles = {}
    t_2._next_particle = 0
    t_2:_Init()

    return t_2
end

function t_1.SetActive(arg3, arg4, arg5) -- line: 30
    arg3._ammo_active = not (not arg4)
    arg3._reserve_active = not (not arg5)
    arg3._is_active = arg3._ammo_active or arg3._reserve_active

    if not arg3._is_active then
        arg3:_Clear()
    end
end

function t_1.Update(arg6, arg7) -- line: 40
    if arg6._is_active then
        arg6:_UpdateInfiniteAmmo(arg7, arg6._ammo_active, arg6._reserve_active)
    end
end

function t_1.Destroy(arg8) -- line: 46
    arg8:_Clear()
end

function t_1._Clear(arg9) -- line: 54
    for index = #arg9._particles, 1, -1 do
        arg9:_CleanupParticle(index)
    end
end

function t_1._CleanupParticle(arg10, arg11) -- line: 60
    local v2 = arg10._particles[arg11]

    for _, val in pairs(v2.Connections) do
        val:Disconnect()
    end

    v2.Particle:Destroy()
    table.remove(arg10._particles, arg11)
end

function t_1._SpawnInfiniteAmmoParticle(arg12, arg13) -- line: 71
    -- upvalues:
    --  [1] Players (copy)
    --  [2] InfiniteAmmoParticle (copy)
    --  [3] t (copy)

    if not arg13 or not arg13:IsDescendantOf(Players) then
        return
    end

    local v3 = InfiniteAmmoParticle:Clone()
    local New = UDim2.new
    local v4 = if arg13.TextXAlignment == Enum.TextXAlignment.Left then 0 else 1
    local v5 = arg13.TextBounds.X * math.random()
    local v6 = if arg13.TextXAlignment ~= Enum.TextXAlignment.Left then -1 else 1
    v3.Position = New(v4, v5 * v6, 0.5, arg13.TextBounds.Y * 0.5 * (math.random() - 0.5))
    v3.Parent = arg13
    local udim2 = UDim2.new()
    v3:TweenSize(
        udim2,
        "In",
        "Back",
        0.75,
        true
    )
    local t_3 = {}

    local function update() -- line: 88
        -- upvalues:
        --  [1] t (ref)
        --  [2] v3 (copy)
        --  [3] arg13 (copy)

        for _, val_1 in pairs(t) do
            v3[val_1] = arg13[val_1]
        end
    end

    for _, val_2 in pairs(t) do
        table.insert(t_3, arg13:GetPropertyChangedSignal(val_2):Connect(update))
    end

    for _, val_3 in pairs(t) do
        v3[val_3] = arg13[val_3]
    end

    local t_4 = {
        Particle = v3,
        Connections = t_3,
        Position = v3.Position,
        Velocity = nil,
        Start = nil
    }
    local Particles = arg12._particles
    t_4.Velocity = Vector2.new(math.random() - 0.5, -math.random() - 0.5) * 100
    t_4.Start = tick()
    table.insert(Particles, t_4)
end

function t_1._UpdateInfiniteAmmo(arg14, arg15) -- line: 109
    for index_1 = #arg14._particles, 1, -1 do
        local v11 = arg14._particles[index_1]

        if tick() - v11.Start >= 1 or not v11.Particle.Parent then
            arg14:_CleanupParticle(index_1)
        else
            local minimum = math.min(
                v11.Particle.Parent.AbsoluteSize.X,
                v11.Particle.Parent.AbsoluteSize.Y
            )
            local v12 = v11.Velocity.X * arg15 / 60 * 4
            local v13 = v11.Velocity.Y * arg15 / 60
            local now_1 = tick()
            v11.Position = v11.Position + UDim2.new(
                0,
                minimum * v12,
                0,
                minimum * (v13 + 0.25 * (now_1 - v11.Start) ^ 2)
            )
            v11.Particle.Position = v11.Position
            local Particle = v11.Particle
            Particle.Rotation += v12 * 200
        end
    end

    if tick() < arg14._next_particle then
        return
    end

    arg14._next_particle = tick() + 0.1

    if arg14._ammo_active then
        arg14:_SpawnInfiniteAmmoParticle(arg14._ammo_element)
    end

    if arg14._reserve_active then
        arg14:_SpawnInfiniteAmmoParticle(arg14._reserve_element)
    end
end

function t_1._Init(_) -- line: 143
end

return t_1
