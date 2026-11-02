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
    local v2 = arg1._is_humanoid

    if v2 then
        v2 = arg1._subject.Parent:FindFirstChild("Head")
    end

    if not v2 then
        return
    end

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromRGB(248, 248, 248)
            val.Material = Enum.Material.SmoothPlastic
            val.MaterialVariant = ""

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

    local v4 = script.Model:Clone()
    v4.PrimaryPart = v4.Primary
    v4:PivotTo(v2.CFrame)
    v4.Parent = v2
    table.insert(arg1._destroy_these, v4)
    local WeldConstraint = Instance.new("WeldConstraint")
    WeldConstraint.Part0 = v2
    WeldConstraint.Part1 = v4.Primary
    WeldConstraint.Parent = v4
    local v5 = script.Particles.Attachment:Clone()
    v5.Parent = v2
    table.insert(arg1._destroy_these, v5)
    Utility_m:PlayParticles(v5)
    arg1:CreateSound(
        "rbxassetid://103150011493508",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 68
end

return t
