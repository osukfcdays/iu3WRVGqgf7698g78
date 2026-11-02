local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.Utility)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local tweenInfo_1 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 27
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(0, 10000, 0)
    BodyVelocity.Velocity = Vector3.new(0, -100, 0)
    BodyVelocity.Parent = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    BetterDebris_m:AddItem(BodyVelocity, 3)
end

function t.PlayClient(arg2, ...) -- line: 37
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] TweenService (copy)
    --  [3] tweenInfo (copy)
    --  [4] RunService (copy)
    --  [5] tweenInfo_1 (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local Position = v3.Position
    local v4 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    local v5 = arg2:_GetGroundPosition(Position, { v4 })

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") and val ~= v3 then
            val:Destroy()
        end
    end

    v3.Size = Vector3.new(0, 0, 0)
    local v7 = script.DustPile:Clone()
    v7.Anchored = true
    v7.Size = Vector3.new(0, 0, 0)
    local cframe = CFrame.new(v5)
    v7.CFrame = cframe * CFrame.new(0, v7.Size.Y / 2, 0)
    v7.CollisionGroup = "IgnoreEntities"
    v7.Parent = v3
    table.insert(arg2._destroy_these, v7)
    TweenService:Create(v7, tweenInfo, { Size = script.DustPile.Size }):Play()
    local v10 = script.Particles:Clone()
    v10.Parent = v7
    table.insert(arg2._destroy_these, v10)
    v3 = RunService.RenderStepped:Connect(function() -- line: 64
        -- upvalues:
        --  [1] v10 (copy)
        --  [2] v7 (copy)

        v10.CFrame = CFrame.new(v7.Position + Vector3.new(0, 1, 0))
    end)
    table.insert(arg2._connections, v3)
    arg2:CreateSound(
        "rbxassetid://118654142384127",
        1.25,
        0.95 + 0.1 * math.random(),
        v10,
        true,
        10
    )
    wait(1)
    v3:Disconnect()

    for _, descendant in pairs(v10:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Enabled = false
        end
    end

    v7.Smoke.smoke1.Enabled = false
    v7.Smoke.smoke2.Enabled = false
    wait(1)
    v10:Destroy()
    wait(1)
    TweenService:Create(v7, tweenInfo_1, { Size = Vector3.new(0, 0, 0) }):Play()
    wait(1)
end

function t._Init(_) -- line: 100
end

return t
