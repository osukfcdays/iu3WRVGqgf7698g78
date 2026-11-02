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

function t.PlayServer(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] RunService (copy)

    arg1:_Ragdoll()
    arg1:_AnchorModel(0, false)
    arg1:_AnchorModel(6.2)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = v2
    table.insert(arg1._destroy_these, Attachment)
    local v3 = script.Model:Clone()
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local HeartbeatConnection = RunService.Heartbeat:Connect(function() -- line: 41
        -- upvalues:
        --  [1] v3 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v3:PivotTo(CFrame.new(v2.Position) * cframe - Vector3.new(0, 1.5, 0))
    end)
    table.insert(arg1._connections, HeartbeatConnection)
    local Success, Result = pcall(
        v3.AnimationController.LoadAnimation,
        v3.AnimationController,
        v3.Animation
    )

    if Success then
        Result:Play(0)
        arg1:CreateSound(
            "rbxassetid://92178332551602",
            1,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        wait(1.95)
        arg1:CreateSound(
            "rbxassetid://8971407217",
            1,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        HeartbeatConnection:Disconnect()
        Attachment.WorldCFrame = v3.Hook.Attachment.WorldCFrame
        local AlignPosition = Instance.new("AlignPosition")
        AlignPosition.RigidityEnabled = true
        AlignPosition.Attachment1 = v3.Hook.Attachment
        AlignPosition.Attachment0 = Attachment
        AlignPosition.Parent = v3
        table.insert(arg1._destroy_these, AlignPosition)
        wait(0.75)
        arg1:CreateSound(
            "rbxassetid://105623111691289",
            1,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        wait(0.5)
        AlignPosition:Destroy()
        Attachment:Destroy()
        arg1:_AnchorModel()
    end

    HeartbeatConnection:Disconnect()
    v3:Destroy()
end

function t._Init(_) -- line: 87
end

return t
