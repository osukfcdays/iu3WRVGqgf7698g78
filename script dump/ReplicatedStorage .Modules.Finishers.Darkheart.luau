local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 21
    arg1:_AnchorModel(0)
    arg1:_InternalThread(task.delay, 0.25, function() -- line: 24
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_AnchorModel(0, false)
        arg1:_AnchorModel()
        arg1:_BreakJoints()

        if arg1._is_humanoid then
            arg1._subject.Parent:BreakJoints()
        end

        for _, val in pairs(arg1:_GetObjects()) do
            if val:IsA("BasePart") then
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.Velocity = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5).Unit * 40
                BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                BodyVelocity.Parent = val
                table.insert(arg1._destroy_these, BodyVelocity)
                val.CFrame = val.CFrame * CFrame.Angles(
                    math.random() * 3.141592653589793 * 2,
                    math.random() * 3.141592653589793 * 2,
                    math.random() * 3.141592653589793 * 2
                )
            end
        end
    end)
end

function t.PlayClient(arg2) -- line: 49
    -- upvalues:
    --  [1] Utility_m (copy)

    for _, val_1 in pairs(arg2:_GetObjects(true)) do
        if val_1:IsA("BasePart") then
            val_1.Color = Color3.fromRGB(0, 0, 0)
            val_1.Material = Enum.Material.Glass
            val_1.MaterialVariant = ""

            if val_1:IsA("MeshPart") then
                val_1.TextureID = ""
            end
        elseif val_1:IsA("ParticleEmitter") or val_1:IsA("Beam") or val_1:IsA("Trail") then
            val_1.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
        elseif val_1:IsA("Texture") or val_1:IsA("Decal") then
            val_1.Color3 = Color3.fromRGB(0, 0, 0)
        elseif val_1:IsA("Clothing") or val_1:IsA("ShirtGraphic") then
            val_1:Destroy()
        end
    end

    for _, val_2 in pairs(arg2:_GetObjects()) do
        if val_2:IsA("BasePart") and not (val_2.Transparency > 0) then
            for _, val_3 in pairs(script.Particles:GetChildren()) do
                local v10 = val_3:Clone()
                v10.Parent = val_2
                table.insert(arg2._destroy_these, v10)
            end
        end
    end

    arg2:CreateSound(
        "rbxassetid://133729942047865",
        1,
        1 + 0.2 * math.random(),
        arg2._is_humanoid and arg2._subject.RootPart.Position or arg2._subject.Position,
        true,
        5
    )
    wait(0.25)
    local t_2 = {}

    for _, child in pairs(script.ExplodeParticles:GetChildren()) do
        local v16 = child:Clone()
        local v17 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
        v16.Parent = v17
        table.insert(arg2._destroy_these, v16)
        table.insert(t_2, v16)

        for _, val_4 in pairs(v16:GetDescendants()) do
            if val_4:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val_4, 3)
            end
        end
    end

    Utility_m:PlayParticles(t_2)
    arg2:CreateSound(
        "rbxassetid://90611785538933",
        1,
        0.8 + 0.2 * math.random(),
        arg2._is_humanoid and arg2._subject.RootPart.Position or arg2._subject.Position,
        true,
        10
    )
end

function t._Init(_) -- line: 110
end

return t
