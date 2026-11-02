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
            val.Color = Color3.fromRGB(255, 255, 255)
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
            or val:IsA("Accessory")
        then
            val:Destroy()
        end
    end

    local v3 = script.Particles.Attachment:Clone()
    v3.Parent = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    table.insert(arg1._destroy_these, v3)
    Utility_m:PlayParticles(v3)

    if arg1._is_humanoid then
        local v5 = script.Face:Clone()
        local v6 = arg1._subject.Parent

        if v6 then
            v6 = arg1._subject.Parent:FindFirstChild("Head")
        end

        v5.Parent = v6
        table.insert(arg1._destroy_these, v5)
    end

    arg1:CreateSound(
        "rbxassetid://79150386787758",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg1:CreateSound(
        "rbxassetid://125902611007483",
        1.25,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 58
end

return t
