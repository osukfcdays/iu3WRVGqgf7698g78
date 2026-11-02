local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
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

    if arg1._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://90573604180891"
        local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

        if Success then
            Result:Play(0)
        end
    end

    wait(1.8)
    v2.Anchored = false
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2) -- line: 48
    -- upvalues:
    --  [1] RunService (copy)

    if not arg2._is_humanoid then
        return
    end

    local Subject = arg2._subject.Parent.Head
    local v3 = Subject:Clone()
    v3.CanCollide = false
    v3.CanTouch = false
    v3.CanQuery = false
    v3.Anchored = true
    v3.Parent = Subject

    for _, val in pairs(v3:GetChildren()) do
        if not val:IsA("Decal") then
            val:Destroy()
        end
    end

    for _, val_1 in pairs(Subject:GetChildren()) do
        if val_1:IsA("Decal") then
            val_1.LocalTransparencyModifier = 1
        end
    end

    Subject.LocalTransparencyModifier = 1
    local now = tick()
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function(_) -- line: 77
        -- upvalues:
        --  [1] now (copy)
        --  [2] v3 (copy)
        --  [3] Subject (copy)

        local clampedValue = math.clamp((tick() - now) / 1.8, 0, 1)
        v3.Size = Subject.Size * (clampedValue * 2 + 1)
        v3.CFrame = Subject.CFrame * CFrame.new(0, -Subject.Size.Y / 2 + v3.Size.Y / 2, 0)
    end))
    arg2:CreateSound(
        "rbxassetid://102780719481956",
        1,
        1,
        nil,
        true,
        5
    )
end

function t._Init(_) -- line: 91
end

return t
