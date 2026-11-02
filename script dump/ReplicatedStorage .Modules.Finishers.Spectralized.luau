local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 22
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local BodyAngularVelocity = Instance.new("BodyAngularVelocity")
    BodyAngularVelocity.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyAngularVelocity.AngularVelocity = Random.new():NextUnitVector() * 10
    BodyAngularVelocity.Parent = v2
    BetterDebris_m:AddItem(BodyAngularVelocity, 3)

    for _, val in pairs(arg1:_GetObjects()) do
        if val:IsA("BasePart") then
            local BodyVelocity = Instance.new("BodyVelocity")
            local v4 = if val ~= v2 then 500 else 10000
            BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * v4
            BodyVelocity.Velocity = Vector3.new(0, 2, 0)
            BodyVelocity.Parent = val
            BetterDebris_m:AddItem(BodyVelocity, 3)
        end
    end
end

function t.PlayClient(arg2, ...) -- line: 44
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v5 = 1 + 0.1 * math.random()
    arg2:CreateSound(
        "rbxassetid://115639979533179",
        1,
        v5,
        nil,
        true,
        5
    )
    local v6 = 1 + 0.1 * math.random()
    arg2:CreateSound(
        "rbxassetid://70584026980041",
        1.5,
        v6,
        nil,
        true,
        5
    )

    for _, val_1 in pairs(arg2:_GetObjects(true)) do
        if val_1:IsA("BasePart") then
            val_1.Color = Color3.fromRGB(11, 91, 43)
            val_1.Material = Enum.Material.SmoothPlastic
            val_1.MaterialVariant = ""

            if val_1:IsA("MeshPart") then
                val_1.TextureID = ""
            end
        elseif
            val_1:IsA("ParticleEmitter")
            or val_1:IsA("Beam")
            or val_1:IsA("Trail")
            or val_1:IsA("Texture")
            or val_1:IsA("Decal")
            or val_1:IsA("Clothing")
            or val_1:IsA("ShirtGraphic")
        then
            val_1:Destroy()
        end
    end

    local v8 = script.Particles.Attachment:Clone()
    v8.Parent = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    table.insert(arg2._destroy_these, v8)
    Utility_m:PlayParticles(v8)
    Utility_m:RenderstepForLoop(0, 100, 0.5, function(arg3) -- line: 70
        -- upvalues:
        --  [1] arg2 (copy)

        local v10 = 1 - (1 - arg3 / 100) ^ 3

        for _, val_2 in pairs(arg2:_GetObjects(true)) do
            if val_2:IsA("BasePart") then
                val_2.LocalTransparencyModifier = v10
            end
        end
    end)
end

function t._Init(_) -- line: 85
end

return t
