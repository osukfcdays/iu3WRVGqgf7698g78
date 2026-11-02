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
    arg1:_AnchorModel(10)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.CustomPhysicalProperties = PhysicalProperties.new(
                val.CurrentPhysicalProperties.Density,
                0,
                0,
                100,
                100
            )
            val.Velocity = Random.new():NextUnitVector() * 10
            val.RotVelocity = Random.new():NextUnitVector() * 25
        end
    end
end

function t.PlayClient(arg2) -- line: 33
    -- upvalues:
    --  [1] Utility_m (copy)

    for _, val_1 in pairs(arg2:_GetObjects(true)) do
        if val_1:IsA("BasePart") then
            val_1.Color = Color3.fromRGB(110, 241, 243)
            val_1.Material = Enum.Material.Glass
            val_1.MaterialVariant = ""
            val_1.Reflectance = 0.4
        elseif val_1:IsA("ParticleEmitter") or val_1:IsA("Beam") or val_1:IsA("Trail") then
            val_1:Destroy()
        end
    end

    local v4 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v5 = script.Particles.Appear:Clone()
    v5.Parent = v4
    table.insert(arg2._destroy_these, v5)
    Utility_m:PlayParticles(v5)
    arg2:CreateSound(
        "rbxassetid://93583856628897",
        1.5,
        1.5 + 0.2 * math.random(),
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 59
end

return t
