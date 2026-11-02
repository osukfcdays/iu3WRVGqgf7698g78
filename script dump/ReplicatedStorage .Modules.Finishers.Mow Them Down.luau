local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    wait(0.794)
    arg1:_HideBody({ v2 })
end

function t.PlayClient(arg2, ...) -- line: 37
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)
    --  [4] Players (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v3 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    v3.Archivable = true
    local v4 = v3:Clone()
    table.insert(arg2._destroy_these, v4)
    v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v5 = arg2:_GetGroundPosition(v3.Position, arg2:_GetObjects(true))
    local v6 = script.Model:Clone()
    v6.Parent = workspace
    table.insert(arg2._destroy_these, v6)
    local t_3 = {}

    for _, descendant in pairs(v6:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            table.insert(t_3, descendant)
        end
    end

    local Position_2 = nil
    local Unit = (Random.new():NextUnitVector() * Vector3.new(1, 0, 1)).Unit
    local now = tick()
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 65
        -- upvalues:
        --  [1] now (copy)
        --  [2] Position_2 (ref)
        --  [3] v3 (copy)
        --  [4] v6 (copy)
        --  [5] v5 (copy)
        --  [6] Unit (copy)
        --  [7] t_3 (copy)

        local v9 = math.clamp((tick() - now) / 1, 0, 1) ^ 3
        local v10 = (1 - math.sin(3.141592653589793 * v9)) ^ 10

        if not Position_2 or v9 < 0.4 then
            Position_2 = v3.Position
        end

        local v11 = v6
        local v13 = CFrame.new(Position_2.X, v5.Y, Position_2.Z) * CFrame.new(
            Vector3.new(0, 0, 0),
            -Unit
        ).Rotation * CFrame.new(0, 0, v9 * 32 + -16)
        v11:PivotTo(v13 * CFrame.Angles(0, -1.5707963267948966, 0))
        local _ = v13 * CFrame.Angles(0, -1.5707963267948966, 0)

        for _, val in pairs(t_3) do
            val.LocalTransparencyModifier = v10
        end
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://70481114201477",
        1,
        1 + 0.25 * math.random(),
        v6:GetChildren()[1],
        true,
        10
    )
    arg2:CreateSound(
        "rbxassetid://96644061235295",
        1,
        1 + 0.25 * math.random(),
        v6:GetChildren()[1],
        true,
        10
    )
    wait(0.5940000000000001)
    arg2:CreateSound(
        "rbxassetid://88391131441060",
        1,
        1 + 0.25 * math.random(),
        v6:GetChildren()[1],
        true,
        10
    )
    wait(0.2)
    local Camera = Instance.new("Camera")
    local v18 = script.Flattened:Clone()
    v18.CFrame = CFrame.new(arg2:_GetGroundPosition(v3.Position, arg2:_GetObjects(true)))
    v18.Parent = workspace
    table.insert(arg2._destroy_these, v18)
    local _ = {}

    for _, val_1 in pairs({ v6:GetDescendants(), arg2:_GetObjects(true) }) do
        for _, val_2 in pairs(val_1) do
            if val_2:IsA("BasePart") then
                local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
                NoCollisionConstraint.Part0 = val_2
                NoCollisionConstraint.Part1 = v18
                NoCollisionConstraint.Parent = v18
            end
        end
    end

    for _, descendant_1 in pairs(v18:GetDescendants()) do
        if descendant_1:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(descendant_1, 2)
        end
    end

    Utility_m:PlayParticles(v18)
    local SurfaceGui = v18.SurfaceGui
    SurfaceGui.ViewportFrame.CurrentCamera = Camera
    SurfaceGui.Adornee = v18
    SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
    table.insert(arg2._destroy_these, SurfaceGui)
    local v21 = v4:Clone()
    v21:PivotTo(v21:GetPivot().Rotation)
    v21.Parent = SurfaceGui.ViewportFrame
    Camera.CFrame = CFrame.new(Vector3.new(0, 15, 0), Vector3.new(0, 0, 0)) * CFrame.Angles(
        0,
        0,
        3.141592653589793
    )
    Camera.FieldOfView = 30
    Camera.Parent = SurfaceGui.ViewportFrame
    wait(0.20599999999999996)
    RenderSteppedConnection:Disconnect()
    wait(3)
    v6:Destroy()
end

function t._Init(_) -- line: 146
end

return t
