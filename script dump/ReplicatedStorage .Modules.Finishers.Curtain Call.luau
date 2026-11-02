local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
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

function t.PlayClient(arg1, ...) -- line: 22
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)
    --  [3] TweenService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Model:Clone()
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)
    local now = tick()
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 33
        -- upvalues:
        --  [1] now (copy)
        --  [2] v3 (copy)
        --  [3] v2 (copy)

        local v4 = 1 - (1 - math.clamp((tick() - now) / 1, 0, 1)) ^ 5
        v3:PivotTo(
            CFrame.new(v2.Position, workspace.CurrentCamera.CFrame.Position) * CFrame.Angles(
                0,
                3.141592653589793,
                0
            ) * CFrame.new(0, v4 * 8 + -8, 0)
        )
    end)
    table.insert(arg1._connections, RenderSteppedConnection)

    local function reposition() -- line: 41
        -- upvalues:
        --  [1] v3 (copy)

        v3.LeftCurtain.CFrame = v3.Main.LeftAttachment.WorldCFrame * CFrame.new(
            0,
            0,
            -v3.LeftCurtain.Size.Z / 2
        )
        v3.RightCurtain.CFrame = v3.Main.RightAttachment.WorldCFrame * CFrame.new(
            0,
            0,
            v3.RightCurtain.Size.Z / 2
        )
    end

    v3.LeftCurtain:GetPropertyChangedSignal("Size"):Connect(reposition)
    v3.RightCurtain:GetPropertyChangedSignal("Size"):Connect(reposition)
    TweenService:Create(
        v3.LeftCurtain,
        TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = Vector3.new(0.865, 6.719, 5.066) }
    ):Play()
    TweenService:Create(
        v3.RightCurtain,
        TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = Vector3.new(0.865, 6.719, 5.066) }
    ):Play()
    arg1:CreateSound(
        "rbxassetid://129997046680336",
        0.75,
        0.75 + 0.1 * math.random(),
        v2,
        true,
        10
    )
    wait(1.5)
    arg1:_HideBody()
    TweenService:Create(
        v3.LeftCurtain,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        { Size = Vector3.new(0.865, 6.719, 2.066) }
    ):Play()
    TweenService:Create(
        v3.RightCurtain,
        TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        { Size = Vector3.new(0.865, 6.719, 2.066) }
    ):Play()
    arg1:CreateSound(
        "rbxassetid://129997046680336",
        1,
        0.9 + 0.1 * math.random(),
        v2,
        true,
        10
    )
    wait(1.5)

    for _, descendant in pairs(v3:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false
        end
    end

    RenderSteppedConnection:Disconnect()
    wait(0.5)
end

function t._Init(_) -- line: 80
end

return t
