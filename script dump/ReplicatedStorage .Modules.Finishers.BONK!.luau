local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

function t.PlayServer(arg1, ...) -- line: 24
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    wait(1.0833333333333333)

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Anchored = true
            val.CanCollide = false
            val.CollisionGroup = "Noclip"
        end
    end
end

function t.PlayClient(arg2, ...) -- line: 38
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)
    --  [4] Players (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    local v3 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local cframe_2 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v5 = script.Model:Clone()
    v5.Parent = workspace
    table.insert(arg2._destroy_these, v5)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 48
        -- upvalues:
        --  [1] v5 (copy)
        --  [2] v3 (copy)
        --  [3] cframe_2 (copy)

        v5:PivotTo(CFrame.new(v3.Position) * cframe_2 - Vector3.new(0, 1.5, 0))
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://85156927480464",
        2,
        0.75,
        nil,
        true,
        5
    )
    local Success, Result = pcall(
        v5.AnimationController.LoadAnimation,
        v5.AnimationController,
        v5.Animation
    )

    if Success then
        Result:Play(0)
        wait(1.0833333333333333)
        arg2:CreateSound(
            "rbxassetid://4164190231",
            1,
            1 + 0.1 * math.random(),
            nil,
            true,
            5
        )
        local Camera = Instance.new("Camera")
        local v9 = script.Flattened:Clone()
        v9.CFrame = CFrame.new(v3.Position)
        v9.Parent = workspace
        table.insert(arg2._destroy_these, v9)

        for _, val_1 in pairs(v9:GetDescendants()) do
            if val_1:IsA("ParticleEmitter") then
                Utility_m:ScaleParticleEmitter(val_1, 2)
            end
        end

        Utility_m:PlayParticles(v9)
        local SurfaceGui = v9.SurfaceGui
        SurfaceGui.ViewportFrame.CurrentCamera = Camera
        SurfaceGui.Adornee = v9
        SurfaceGui.Parent = Players.LocalPlayer.PlayerGui
        table.insert(arg2._destroy_these, SurfaceGui)
        local v11 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
        v11.Archivable = true
        local v12 = v11:Clone()
        v12:PivotTo(v12:GetPivot().Rotation)
        v12.Parent = SurfaceGui.ViewportFrame
        Camera.CFrame = CFrame.new(Vector3.new(0, 15, 0), Vector3.new(0, 0, 0)) * CFrame.Angles(
            0,
            0,
            3.141592653589793
        )
        Camera.FieldOfView = 30
        Camera.Parent = SurfaceGui.ViewportFrame
        local v13 = pairs
        local _ = CFrame.Angles(0, 0, 3.141592653589793)

        for _, val_2 in v13(v11:GetDescendants()) do
            if val_2:IsA("BasePart") then
                val_2.Transparency = 1
            elseif
                val_2:IsA("ParticleEmitter")
                or val_2:IsA("Beam")
                or val_2:IsA("Trail")
                or val_2:IsA("Decal")
            then
                val_2:Destroy()
            end
        end

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end

        v5:Destroy()
        wait(3)
    end

    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 121
end

return t
