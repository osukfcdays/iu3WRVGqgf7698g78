local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = {
    "rbxassetid://1848267914",
    "rbxassetid://1848267930",
    "rbxassetid://9038367984",
    "rbxassetid://9042144091",
    "rbxassetid://9038367978"
}
local t_1 = setmetatable({}, Finisher_m)
t_1.__index = t_1

function t_1.new(...) -- line: 11
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Finisher_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayServer(arg1) -- line: 23
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Velocity = Vector3.new(0, 4, 0)
    BodyVelocity.Parent = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    table.insert(arg1._destroy_these, BodyVelocity)
    local BodyAngularVelocity = Instance.new("BodyAngularVelocity")
    BodyAngularVelocity.MaxTorque = Vector3.new(10000, 10000, 10000)
    BodyAngularVelocity.AngularVelocity = Vector3.new(0, 2, 0) * math.sign(math.random() - 0.5)
    BodyAngularVelocity.Parent = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    table.insert(arg1._destroy_these, BodyAngularVelocity)
    arg1:_InternalThread(task.delay, 3, function() -- line: 36
        -- upvalues:
        --  [1] BodyVelocity (copy)
        --  [2] BodyAngularVelocity (copy)
        --  [3] arg1 (copy)

        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        wait(3)
        BodyVelocity:Destroy()
        BodyAngularVelocity:Destroy()
        arg1:_AnchorModel()
        arg1:_Ragdoll()
    end)
end

function t_1.PlayClient(arg2) -- line: 49
    -- upvalues:
    --  [1] Utility_m (copy)

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") and val.Transparency < 0.99 then
            val.Color = Color3.fromRGB(255, 255, 255)
            val.Material = Enum.Material.SmoothPlastic
            val.MaterialVariant = ""
            val.Reflectance = 0.5

            for _, val_1 in pairs(script.Texture:GetChildren()) do
                val_1:Clone().Parent = val
            end

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

    local v6 = script.Particles.Enabled:Clone()
    local v7 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    v6.Parent = v7
    v7 = script.Particles.Emit:Clone()
    v7.Parent = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    Utility_m:PlayParticles(v7)

    if arg2._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://109647828518093"
        local Success, Result = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

        if Success then
            Result:Play(0)
            Result:AdjustSpeed(0.75)
        end
    end

    arg2:_InternalThread(task.delay, 6, function() -- line: 88
        -- upvalues:
        --  [1] v6 (copy)

        for _, descendant in pairs(v6:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Light") then
                descendant.Enabled = false
            end
        end
    end)
    arg2:CreateSound(
        arg2:_GetMusicID(),
        1,
        1,
        nil,
        true,
        5
    )
end

function t_1._GetMusicID(arg3) -- line: 103
    -- upvalues:
    --  [1] t (copy)

    local v11 = t

    return v11[Random.new(arg3._serial and arg3._serial.Seed or arg3._seed):NextInteger(1, #t)]
end

function t_1._Init(_) -- line: 107
end

return t_1
