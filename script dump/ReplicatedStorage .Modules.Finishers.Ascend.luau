local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 24
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v2.Anchored = true
end

function t.PlayClient(arg2) -- line: 30
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] RunService (copy)

    if arg2._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://134648473605383"
        local Success, Result = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

        if Success then
            Result:Play(0)
        end
    end

    local v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v4 = script.Explosion.Attachment:Clone()
    v4.Parent = v3
    Utility_m:PlayParticles(v4)
    local v5 = script.Idle.Attachment:Clone()
    v5.Parent = arg2._is_humanoid and arg2._subject.Parent.UpperTorso or arg2._subject
    arg2:CreateSound(
        "rbxassetid://86210336908274",
        1,
        1,
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://112056531317514",
        1,
        1,
        nil,
        true,
        5
    )
    wait(1)
    local t_2 = {}

    for _, val in pairs(arg2:_GetObjects(true)) do
        if
            val:IsA("BasePart")
            or val:IsA("Decal")
            or val:IsA("Texture")
            or val:IsA("Beam")
            or val:IsA("ParticleEmitter")
            or val:IsA("Trail")
        then
            t_2[val] = true
        end
    end

    v3 = tick()

    while true do
        if not (tick() < v3 + 0.3333333333333333) then
            break
        end

        local v8 = 1 - (1 - math.clamp((tick() - v3) / 0.3333333333333333, 0, 1)) ^ 3

        for key_1, _ in pairs(t_2) do
            key_1.LocalTransparencyModifier = v8
        end

        RunService.RenderStepped:Wait()
    end

    arg2:_HideBody()
end

function t._Init(_) -- line: 84
end

return t
