local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Emote_m = require(ReplicatedStorage.Modules.Emote)
local t = setmetatable({}, Emote_m)
t.__index = t

function t.new(...) -- line: 27
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Emote_m.new(nil, script.Name, ...), t)
    t_1._illuminas = {}
    t_1._illumina_anchor = t_1._humanoid.RootPart
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 42
    -- upvalues:
    --  [1] Emote_m (copy)
    --  [2] RunService (copy)

    Emote_m.PlayClient(arg1, ...)
    arg1:_PlayAnimation("rbxassetid://77038993402535", nil, nil, 0.5)

    if not arg1._illumina_anchor then
        return
    end

    local v2 = if arg1:_IsWorkspaceEmote() then 0.5 else 0.125
    local v3 = pairs
    local t_2 = { "RightHand", "LeftHand" }

    for _, val in v3(t_2) do
        local v5 = arg1._humanoid.Parent

        if v5 then
            v5 = arg1._humanoid.Parent:FindFirstChild(val)
        end

        if v5 then
            local v6 = script.IlluminaHand:Clone()
            v6:PivotTo(v5.CFrame)
            v6.Parent = v5
            table.insert(arg1._destroy_these, v6)
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = v5
            WeldConstraint.Part1 = v6
            WeldConstraint.Parent = v6
        end
    end

    local v7 = script.IlluminaLight:Clone()
    v7.Parent = arg1._illumina_anchor
    table.insert(arg1._destroy_these, v7)
    local v10 = script.IlluminaSparkles:Clone()
    v10.Parent = arg1._illumina_anchor
    local DestroyThese = arg1._destroy_these
    local v11 = v10
    table.insert(DestroyThese, v11)

    local function new_illumina() -- line: 79
        -- upvalues:
        --  [1] arg1 (copy)

        local v12 = script.Illumina:Clone()
        v12.Name = "_Illumina"
        v12.Parent = arg1._illumina_anchor.Parent
        local v13 = -2 + 12 * math.random()
        local t_3 = {
            Object = v12,
            Start = tick(),
            Rad = math.random() * 3.141592653589793 * 2,
            Lifetime = 2 + 4 * math.random(),
            Speed = (1 + 6 * math.random()) * 2,
            Spin = nil,
            Height = nil,
            Spacing = nil
        }
        local Illuminas = arg1._illuminas
        t_3.Spin = Random.new():NextUnitVector() * (1 + 9 * math.random())
        t_3.Height = v13
        t_3.Spacing = 4 + 2 * math.random() + v13 / 2
        table.insert(Illuminas, t_3)
    end

    v11 = 1

    for _ = v11, v2 * 20, 1 do
        new_illumina()
    end

    local now = tick()
    local v16 = 0
    v11 = 0
    table.insert(arg1._connections, RunService.RenderStepped:Connect(function(deltaTime: number) -- line: 106
        -- upvalues:
        --  [1] v16 (ref)
        --  [2] v2 (copy)
        --  [3] new_illumina (copy)
        --  [4] v11 (ref)
        --  [5] now (copy)
        --  [6] arg1 (copy)

        if tick() >= v16 then
            v16 = tick() + 0.1 / v2
            new_illumina()
        end

        if tick() >= v11 then
            v11 = tick() + 0.05 + 0.15 * math.random()
            local v18 = 1 + (tick() - now) * 0.1
            arg1:CreateSound(
                "rbxassetid://114436319908436",
                (0.25 + 0.5 * math.random()) / v18,
                0.875 + 0.25 * math.random(),
                nil,
                true,
                5
            )
        end

        for index_1 = #arg1._illuminas, 1, -1 do
            local v22 = arg1._illuminas[index_1]

            if tick() > v22.Start + v22.Lifetime then
                v22.Object:Destroy()
                table.remove(arg1._illuminas, index_1)
            end

            v22.Rad -= deltaTime * v22.Speed
            local Object = v22.Object
            local v23 = if tick() - v22.Start < 0.5 then 1 - math.clamp(
                (tick() - v22.Start) / 0.5,
                0,
                1
            ) else if tick() > v22.Start + v22.Lifetime - 0.5 then math.clamp(
                (tick() - (v22.Start + v22.Lifetime - 0.5)) / 0.5,
                0,
                1
            ) else 0
            Object.Transparency = v23
            local Object_1 = v22.Object
            local v25 = CFrame.new(arg1._illumina_anchor.Position) * CFrame.new(
                math.sin(v22.Rad) * v22.Spacing,
                v22.Height,
                math.cos(v22.Rad) * v22.Spacing
            ) * v22.Object.CFrame.Rotation
            Object_1.CFrame = v25 * CFrame.Angles(
                v22.Spin.X * deltaTime,
                v22.Spin.Y * deltaTime,
                v22.Spin.Z * deltaTime
            )
        end
    end))
end

function t.Destroy(arg3) -- line: 138
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Emote_m (copy)

    for _, val_1 in pairs(arg3._illuminas) do
        val_1.Object.Anchored = false
        val_1.Object.Velocity = (val_1.Object.Position - arg3._illumina_anchor.Position).Unit * (10 + 30 * math.random())
        val_1.Object.RotVelocity = Random.new():NextUnitVector() * (5 + 20 * math.random())
        BetterDebris_m:AddItem(val_1.Object, 3)
    end

    Emote_m.Destroy(arg3)
end

function t._Init(_) -- line: 153
end

return t
