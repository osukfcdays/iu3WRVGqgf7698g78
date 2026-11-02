local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    wait(0.25)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Chalk:Clone()
    v3.CFrame = CFrame.new(v2.Position) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0) + Vector3.new(0, 2, 0)
    v3.BodyGyro.CFrame = v3.CFrame
    v3.Top.LocalTransparencyModifier = 1
    v3.Bottom.LocalTransparencyModifier = 1
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            v2 = Instance.new("NoCollisionConstraint")
            v2.Part0 = v3
            v2.Part1 = val
            v2.Parent = v3
        end
    end

    wait(0.25)
    local now = tick()

    while true do
        if not (tick() < now + 0.5) then
            break
        end

        local clampedValue = math.clamp((tick() - now) / 0.5, 0, 1)
        local v5 = 1 - (1 - clampedValue) ^ 5

        for _, val_1 in pairs(arg1:_GetObjects(true)) do
            if
                val_1:IsA("BasePart")
                or val_1:IsA("Decal")
                or val_1:IsA("Texture")
                or val_1:IsA("Beam")
                or val_1:IsA("ParticleEmitter")
                or val_1:IsA("Trail")
            then
                val_1.LocalTransparencyModifier = v5
            end
        end

        v3.Top.LocalTransparencyModifier = 1 - clampedValue ^ 5
        v3.Bottom.LocalTransparencyModifier = 1 - clampedValue ^ 5
        RunService.RenderStepped:Wait()
    end

    wait(15)
end

function t._Init(_) -- line: 74
end

return t
