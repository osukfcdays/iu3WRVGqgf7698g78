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
            val.Color = Color3.fromRGB(0, 0, 0)
            val.Material = Enum.Material.Slate
            val.MaterialVariant = "Slate02gun"

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

    for _, val_1 in pairs(arg1:_GetObjects()) do
        if val_1:IsA("BasePart") then
            for _, val_2 in pairs(script.Particles:GetChildren()) do
                local v5 = val_2:Clone()
                v5.Parent = val_1
                table.insert(arg1._destroy_these, v5)
                task.delay(0.25 * math.random(), Utility_m.PlayParticles, Utility_m, v5)
            end
        end
    end

    arg1:CreateSound(
        "rbxassetid://128688584579956",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 60
end

return t
