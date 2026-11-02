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
end

function t.PlayClient(arg2) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromRGB(163, 162, 165)
            val.Material = Enum.Material.Slate
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

    local t_2 = {}

    for _, child in pairs(script.Particles:GetChildren()) do
        local v4 = child:Clone()
        local v5 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
        v4.Parent = v5
        table.insert(arg2._destroy_these, v4)
        table.insert(t_2, v4)
    end

    Utility_m:PlayParticles(t_2)
    arg2:CreateSound(
        "rbxassetid://113140086283098",
        1.25,
        0.9 + 0.2 * math.random(),
        nil,
        true,
        10
    )
    arg2:CreateSound(
        "rbxassetid://120323428371971",
        1,
        0.9 + 0.2 * math.random(),
        nil,
        true,
        10
    )
end

function t._Init(_) -- line: 58
end

return t
