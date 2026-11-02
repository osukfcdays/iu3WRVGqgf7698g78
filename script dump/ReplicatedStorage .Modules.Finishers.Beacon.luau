local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = Instance.new("BodyAngularVelocity")
    v3.MaxTorque = Vector3.new(100000, 100000, 100000)
    v3.AngularVelocity = Random.new():NextUnitVector() * 10
    v3.Parent = v2
    BetterDebris_m:AddItem(v3, 3)
    v3 = nil

    for _, val in pairs(arg1:_GetObjects()) do
        if val:IsA("BasePart") then
            local BodyVelocity = Instance.new("BodyVelocity")
            local v5 = if val ~= v2 then 500 else 10000
            BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * v5
            BodyVelocity.Velocity = Vector3.new(0, 2, 0)
            BodyVelocity.Parent = val
            BetterDebris_m:AddItem(BodyVelocity, 3)

            if val == v2 then
                v3 = BodyVelocity
            end
        end
    end

    wait(0.25)

    if v3 then
        v3.Velocity *= 150
    end
end

function t.PlayClient(arg2, ...) -- line: 57
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] Utility_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v6 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v7 = script.Particles:Clone()
    local cframe = CFrame.new(v6.Position)
    v7.CFrame = cframe * CFrame.Angles(0, 0, 1.5707963267948966) - Vector3.new(0, 2, 0)
    v7.Parent = v6
    table.insert(arg2._destroy_these, v7)
    local v8 = 0.95 + 0.1 * math.random()
    arg2:CreateSound(
        "rbxassetid://116502031018076",
        1.5,
        v8,
        v7,
        true,
        10
    )
    local task_delay = task.delay
    local CreateSound = arg2.CreateSound
    local v9 = 0.95 + 0.1 * math.random()
    arg2:_InternalThread(
        task_delay,
        0.1,
        CreateSound,
        arg2,
        "rbxassetid://76502718325596",
        1.5,
        v9,
        v7,
        true,
        10
    )
    local t_2 = {}
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg3) -- line: 72
        -- upvalues:
        --  [1] v7 (copy)
        --  [2] t_2 (copy)

        local v10 = 1 - (arg3 / 100) ^ 3

        for _, descendant in pairs(v7:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
                local v12 = t_2[descendant]
                local v13 = t_2
                v12 = v12 or descendant.Width1
                v13[descendant] = v12
                descendant.Width1 = t_2[descendant] * v10
            elseif descendant:IsA("Light") then
                local v14 = t_2[descendant]
                local v15 = t_2
                v14 = v14 or descendant.Brightness
                v15[descendant] = v14
                descendant.Brightness = t_2[descendant] * v10
            end
        end
    end)

    for _, descendant_1 in pairs(v7:GetDescendants()) do
        if descendant_1:IsA("ParticleEmitter") or descendant_1:IsA("Beam") then
            descendant_1.Enabled = false
        end
    end

    Utility_m:RenderstepForLoop(0, 100, 4, function(arg4) -- line: 92
        -- upvalues:
        --  [1] arg2 (copy)

        local v17 = 1 - (1 - arg4 / 100) ^ 3

        for _, val_1 in pairs(arg2:_GetObjects(true)) do
            if val_1:IsA("BasePart") then
                val_1.LocalTransparencyModifier = v17
            end
        end
    end)

    for _, val_2 in pairs(arg2:_GetObjects(true)) do
        if val_2:IsA("BasePart") and val_2 ~= v6 then
            val_2:Destroy()
        end
    end

    v7:Destroy()
end

function t._Init(_) -- line: 115
end

return t
