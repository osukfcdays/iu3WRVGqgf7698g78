local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local v2 = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(
    1.5707963267948966,
    0,
    1.5707963267948966
) * CFrame.Angles(0, -1.5707963267948966, 0)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 27
    -- upvalues:
    --  [1] Finisher_m (copy)

    Finisher_m.PlayServer(arg1, ...)
    local v4 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v4.Anchored = true
    wait(3.15)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Anchored = true
            val.CanCollide = false
            val.CollisionGroup = "Noclip"
        end
    end
end

function t.PlayClient(arg2) -- line: 45
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] v2 (copy)
    --  [3] Utility_m (copy)
    --  [4] Players (copy)

    local v6 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject

    if arg2._is_humanoid then
        pcall(function() -- line: 49
            -- upvalues:
            --  [1] arg2 (copy)

            local Animation = Instance.new("Animation")
            Animation.AnimationId = "rbxassetid://102021872417441"
            arg2._subject:LoadAnimation(Animation):Play()
        end)
    end

    local v7 = script:WaitForChild("Sign"):Clone()
    v7.Parent = workspace
    table.insert(arg2._destroy_these, v7)
    arg2:CreateSound(
        "rbxassetid://8970814778",
        1,
        0.9,
        nil,
        true,
        5
    )
    local cframe_1 = CFrame.new(0, 256, 0)
    local _ = v7.Size
    local Identity = CFrame.identity
    local now = tick()
    local v8 = nil
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 72
        -- upvalues:
        --  [1] now (copy)
        --  [2] v8 (ref)
        --  [3] v6 (copy)
        --  [4] cframe_1 (copy)
        --  [5] Identity (copy)
        --  [6] v7 (copy)
        --  [7] v2 (ref)

        local v9 = math.clamp((tick() - now) / 3.15, 0, 1) ^ 2
        local now_1 = tick()
        local _ = math.clamp((now_1 - (now + 3.15)) / 4, 0, 1) ^ 2
        local v11 = v8 and v8.Position or v6.Position
        local v14 = CFrame.new(v11) * cframe_1:Lerp(Identity, v9) + Vector3.new(0, v7.Size.X / 2, 0)
        v11 = CFrame.new(
            v14.Position * Vector3.new(1, 0, 1),
            workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1)
        )
        v7:PivotTo(
            v14 * (v11.LookVector == v11.LookVector and v11.Rotation or CFrame.identity) * v2
        )
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    wait(3.15)
    arg2:CreateSound(
        "rbxassetid://105824621418784",
        1.25,
        1,
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://89635888410432",
        1.25,
        1,
        nil,
        true,
        5
    )
    local Camera = Instance.new("Camera")
    v8 = script.Flattened:Clone()
    v8.CFrame = CFrame.new(v6.Position)
    v8.Parent = workspace
    table.insert(arg2._destroy_these, v8)

    for _, descendant in pairs(v8:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(descendant, 3)
        end
    end

    Utility_m:PlayParticles(v8)
    local SurfaceGui = v8.SurfaceGui
    SurfaceGui.ViewportFrame.CurrentCamera = Camera
    SurfaceGui.Adornee = v8
    SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
    table.insert(arg2._destroy_these, SurfaceGui)
    local v19 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    v19.Archivable = true
    local v20 = v19:Clone()
    v20:PivotTo(v20:GetPivot().Rotation)
    v20.Parent = SurfaceGui.ViewportFrame
    Camera.CFrame = CFrame.new(Vector3.new(0, 15, 0), Vector3.new(0, 0, 0)) * CFrame.Angles(
        0,
        0,
        3.141592653589793
    )
    Camera.FieldOfView = 30
    Camera.Parent = SurfaceGui.ViewportFrame
    local v21 = pairs
    local _ = CFrame.Angles(0, 0, 3.141592653589793)

    for _, descendant_1 in v21(v19:GetDescendants()) do
        if descendant_1:IsA("BasePart") then
            descendant_1.Transparency = 1
        elseif
            descendant_1:IsA("ParticleEmitter")
            or descendant_1:IsA("Beam")
            or descendant_1:IsA("Trail")
            or descendant_1:IsA("Decal")
        then
            descendant_1:Destroy()
        end
    end

    wait(2)
    v8.CanCollide = false
    wait(2)
    RenderSteppedConnection:Disconnect()
    v7:Destroy()
end

function t._Init(_) -- line: 144
end

return t
