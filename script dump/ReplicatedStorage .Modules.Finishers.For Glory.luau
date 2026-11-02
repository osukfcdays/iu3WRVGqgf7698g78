local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local t = {
    "rbxassetid://91261888651237",
    "rbxassetid://116627376811943",
    "rbxassetid://131046967935934",
    "rbxassetid://98510973512946",
    "rbxassetid://102276174123211",
    "rbxassetid://119206791261589",
    "rbxassetid://85250994493837",
    "rbxassetid://80578622827590",
    "rbxassetid://108990615121442",
    "rbxassetid://123917383226893"
}
local t_1 = setmetatable({}, Finisher_m)
t_1.__index = t_1

function t_1.new(...) -- line: 14
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Finisher_m.new(...), t_1)
    t_2:_Init()

    return t_2
end

function t_1.PlayServer(arg1) -- line: 26
    if not arg1._is_humanoid then
        return
    end

    local Subject = arg1._subject
    Subject.HipHeight += 1.5
    local RootPart = arg1._subject.RootPart
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = CFrame.new(
        Vector3.new(0, 0, 0),
        RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
    )
    BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    BodyGyro.Parent = RootPart
    table.insert(arg1._destroy_these, BodyGyro)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = arg1:_GetAnimationID()
    local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

    if Success then
        Result:Play(0)
    end

    wait(1.5)
    arg1:_AnchorModel(0)
end

function t_1.PlayClient(arg2) -- line: 55
    -- upvalues:
    --  [1] RunService (copy)

    if not arg2._is_humanoid then
        return
    end

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromRGB(105, 104, 106)
            val.Material = Enum.Material.SmoothPlastic
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

    local Animation_1 = Instance.new("Animation")
    Animation_1.AnimationId = arg2:_GetAnimationID()
    local v6 = script.Model:Clone()
    v6.PrimaryPart = v6.HumanoidRootPart
    v6:PivotTo(arg2._subject.RootPart.CFrame)
    v6.Parent = workspace
    table.insert(arg2._destroy_these, v6)

    for _, val_1 in pairs(v6:GetDescendants()) do
        if val_1:IsA("BasePart") then
            val_1.CollisionGroup = "Noclip"
        end
    end

    local Success_1, Result_1 = pcall(
        v6.AnimationController.LoadAnimation,
        v6.AnimationController,
        Animation_1
    )

    if Success_1 then
        Result_1:Play(0)
    end

    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 95
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] arg2 (copy)

        v6:PivotTo(arg2._subject.RootPart.CFrame * CFrame.new(0, 2.25, 0))
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://90323515241815",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(1.5)
    RenderSteppedConnection:Disconnect()

    for _, val_2 in pairs(v6:GetDescendants()) do
        if val_2:IsA("BasePart") then
            val_2.Anchored = true
        end
    end
end

function t_1._GetAnimationID(arg3) -- line: 118
    -- upvalues:
    --  [1] t (copy)

    local v13 = t

    return v13[Random.new(arg3._serial and arg3._serial.Seed or arg3._seed):NextInteger(1, #t)]
end

function t_1._Init(_) -- line: 122
end

return t_1
