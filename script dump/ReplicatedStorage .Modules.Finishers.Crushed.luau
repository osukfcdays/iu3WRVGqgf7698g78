local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 28
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    wait(0.5)
    arg1:_HideBody({ v2 })
end

function t.PlayClient(arg2, ...) -- line: 38
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
    v3 = arg2:_GetTemplate():Clone()
    v3.Parent = workspace
    table.insert(arg2._destroy_these, v3)
    local Broken = v3:FindFirstChild("Broken")

    if Broken then
        for _, val in pairs(Broken:GetDescendants()) do
            if val:IsA("BasePart") then
                val.LocalTransparencyModifier = 1
            end
        end
    end

    local v6 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local cframe_3 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local now = tick()
    local HeartbeatConnection = RunService.Heartbeat:Connect(function() -- line: 64
        -- upvalues:
        --  [1] v6 (copy)
        --  [2] now (copy)
        --  [3] cframe_3 (copy)
        --  [4] v3 (copy)

        local v8 = CFrame.new(v6.Position)
        local v10, v9

        if tick() < now + 0.5 then
            v9 = math.clamp((tick() - now) / 0.5, 0, 1)
            v10 = Vector3.new(0, 128, 0)
            v8 *= cframe_3 * CFrame.Angles(0, 3.141592653589793, 0):Lerp(CFrame.identity, v9 ^ 6)
        else
            local clampedValue = math.clamp((tick() - now - 0.5) / 0.5, 0, 1)
            v9 = 1 - math.abs(math.sin(4.71238898038469 * clampedValue) * (1 - clampedValue))
            v10 = Vector3.new(0, 12, 0)
            v8 *= cframe_3 * CFrame.identity:Lerp(
                CFrame.Angles(0, 2.827433388230814, 0),
                1 - (1 - clampedValue) ^ 6
            )
        end

        v3:PivotTo(v8 + v10:Lerp(Vector3.new(0, 0, 0), v9))
    end)
    table.insert(arg2._connections, HeartbeatConnection)
    wait(0.5)

    if Broken then
        v3.Normal:Destroy()

        for _, val_1 in pairs(Broken:GetDescendants()) do
            if val_1:IsA("BasePart") then
                val_1.LocalTransparencyModifier = 0
            end
        end
    end

    local Camera = Instance.new("Camera")
    local v18 = script.Flattened:Clone()
    v18.CFrame = CFrame.new(v6.Position)
    v18.Parent = workspace
    table.insert(arg2._destroy_these, v18)
    local _ = {}

    for _, val_2 in pairs({ v3:GetDescendants(), arg2:_GetObjects(true) }) do
        for _, val_3 in pairs(val_2) do
            if val_3:IsA("BasePart") then
                local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
                NoCollisionConstraint.Part0 = val_3
                NoCollisionConstraint.Part1 = v18
                NoCollisionConstraint.Parent = v18
            end
        end
    end

    for _, descendant in pairs(v18:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            Utility_m:ScaleParticleEmitter(descendant, 2)
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
    arg2:CreateSound(
        "rbxassetid://122470995632560",
        1,
        1,
        nil,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://88491524279903",
        1,
        1,
        nil,
        true,
        5
    )

    if v3.Name == "Piano" then
        arg2:CreateSound(
            "rbxassetid://129097983310355",
            1,
            0.75 + 0.5 * math.random(),
            nil,
            true,
            5
        )
    end

    wait(0.5)
    HeartbeatConnection:Disconnect()
    wait(3)
end

function t._GetSortedChildren(_) -- line: 157
    -- upvalues:
    --  [1] Utility_m (copy)

    local children = script.Models:GetChildren()
    table.sort(children, function(arg4, arg5) -- line: 160
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg4.Name, arg5.Name)
    end)

    return children
end

function t._GetTemplate(arg6) -- line: 167
    local v23 = arg6:_GetSortedChildren()

    return v23[Random.new(arg6._serial and arg6._serial.Seed or arg6._seed):NextInteger(1, #v23)]
end

function t._Init(_) -- line: 172
end

return t
