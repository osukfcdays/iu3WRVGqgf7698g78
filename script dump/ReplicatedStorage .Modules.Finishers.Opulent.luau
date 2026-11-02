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
            val.Color = Color3.fromRGB(255, 232, 128)
            val.Material = Enum.Material.Glass
            val.MaterialVariant = ""
            val.Reflectance = 0.4

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

    local _ = function(arg2, arg3) --[[ scale ]] -- line: 39
        -- upvalues:
        --  [1] Utility_m (ref)

        if arg2:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(arg2, arg3)
        end
    end

    local t_2 = {}

    for _, child in pairs(script.Particles:GetChildren()) do
        local v4 = child:Clone()
        local v5 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
        v4.Parent = v5
        table.insert(arg1._destroy_these, v4)
        table.insert(t_2, v4)

        if child:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(child, 0.5)
        end

        for _, val_1 in pairs(v4:GetDescendants()) do
            if val_1:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val_1, 0.5)
            end
        end
    end

    Utility_m:PlayParticles(t_2)
    arg1:CreateSound(
        "rbxassetid://18179281854",
        2,
        0.9 + 0.2 * math.random(),
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 68
end

return t
