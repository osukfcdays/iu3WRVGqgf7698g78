local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 21
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg1, ...)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromRGB(124, 92, 70)
            val.Material = Enum.Material.Wood
            val.MaterialVariant = "Wood01a"

            if val:IsA("MeshPart") then
                val.TextureID = ""
            end
        elseif
            val:IsA("ParticleEmitter")
            or val:IsA("Beam")
            or val:IsA("Trail")
            or val:IsA("Texture")
            or val:IsA("Decal")
            or val:IsA("Clothing")
            or val:IsA("ShirtGraphic")
        then
            val:Destroy()
        end
    end

    for _, val_1 in pairs({ "Head", "HumanoidRootPart" }) do
        local v3 = arg1._is_humanoid

        if v3 then
            v3 = arg1._subject.Parent:FindFirstChild(val_1)
        end

        if v3 then
            local v4 = script[val_1]:Clone()
            v4.PrimaryPart = v4.Primary
            v4:PivotTo(v3.CFrame)
            v4.Parent = v3
            table.insert(arg1._destroy_these, v4)
            local WeldConstraint = Instance.new("WeldConstraint")
            WeldConstraint.Part0 = v3
            WeldConstraint.Part1 = v4.Primary
            WeldConstraint.Parent = v4
        end
    end

    local t_3 = {}

    for _, child in pairs(script.Particles:GetChildren()) do
        local v6 = child:Clone()
        local v7 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
        v6.Parent = v7
        table.insert(arg1._destroy_these, v6)
        table.insert(t_3, v6)
    end

    Utility_m:PlayParticles(t_3)
    arg1:CreateSound(
        "rbxassetid://96385683410648",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 76
end

return t
