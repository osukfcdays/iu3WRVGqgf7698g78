local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local _ = game:GetService("RunService")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.Utility)
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
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
    local v2 = if arg1._is_humanoid then arg1._subject.Parent:FindFirstChild("UpperTorso") or arg1._subject.RootPart or arg1._subject else arg1._subject
    local v3 = arg1._eliminator

    if v3 then
        v3 = arg1._eliminator.Character

        if v3 then
            v3 = arg1._eliminator.Character:FindFirstChild("HumanoidRootPart")
        end
    end

    if not v3 then
        return
    end

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.CustomPhysicalProperties = PhysicalProperties.new(
                val.CurrentPhysicalProperties.Density,
                2,
                0,
                100,
                100
            )
        end
    end

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Velocity = CFrame.new(v3.Position, v2.Position).LookVector * 300
    BodyVelocity.Parent = v2
    BetterDebris_m:AddItem(BodyVelocity, 5)
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(v2.Position, v3.Position)
    BodyGyro.Parent = v2
    BetterDebris_m:AddItem(BodyGyro, 5)
end

function t.PlayClient(arg2, ...) -- line: 55
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] tweenInfo (copy)
    --  [4] TweenService (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v5 = if arg2._is_humanoid then arg2._subject.Parent:FindFirstChild("UpperTorso") or arg2._subject.RootPart or arg2._subject else arg2._subject
    local v6 = script.Icicle:Clone()
    v6.CFrame = v5.CFrame * CFrame.Angles(-1.5707963267948966, 0, 0)
    v6.WeldConstraint.Part0 = v5
    v6.Parent = v5
    table.insert(arg2._destroy_these, v6)
    BetterDebris_m:AddItem(v6.WeldConstraint, 5 + tweenInfo.Time / 2)
    arg2:CreateSound(
        "rbxassetid://73317248668904",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://115260318005653",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(5)
    TweenService:Create(v6, tweenInfo, { Size = Vector3.new(0, 0, 0) }):Play()
    wait(tweenInfo.Time)
end

function t._Init(_) -- line: 81
end

return t
