local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 26
    arg1:_AnchorModel(0)
    wait(0.3)
    arg1:_HideBody()
end

function t.PlayClient(arg2) -- line: 34
    -- upvalues:
    --  [1] Spring_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)
    --  [4] Players (copy)

    local v2 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    v4.Archivable = true
    local v5 = v4:Clone()
    table.insert(arg2._destroy_these, v5)
    v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg2._destroy_these, v4)
    local pivot = v4.Left:GetPivot():ToObjectSpace(v4.PrimaryPart.CFrame):Inverse()
    local pivot_1 = v4.Right:GetPivot():ToObjectSpace(v4.PrimaryPart.CFrame):Inverse()
    local v6 = Spring_m.new(v2.Position, 1, 10)
    local Size = v4.Right.Size
    local Size_1 = v4.Left.Size
    local now = tick()

    while true do
        if not (tick() < now + 0.3) then
            break
        end

        local v7 = math.clamp((tick() - now) / 0.3, 0, 1) ^ 2
        v6.Target = v2.Position
        v4.PrimaryPart.CFrame = CFrame.new(v6.Value) * cframe
        v4.Right.Size = Size * (v7 * 1 + 1)
        v4.Left.Size = Size_1 * (v7 * 1 + 1)
        v4.Right:PivotTo(
            v4.PrimaryPart.CFrame * pivot_1 * CFrame.Angles(0, 0, v7 * -2.356194490192345)
        )
        v4.Left:PivotTo(v4.PrimaryPart.CFrame * pivot * CFrame.Angles(0, 0, v7 * 2.356194490192345))
        RunService.RenderStepped:Wait()
    end

    arg2:CreateSound(
        "rbxassetid://100411689677104",
        1.5,
        1,
        v4.Primary,
        true,
        5
    )
    arg2:CreateSound(
        "rbxassetid://92760487729234",
        2.5,
        1,
        v4.Primary,
        true,
        5
    )
    Utility_m:PlayParticles(v4)
    local v12 = script.Flattened:Clone()
    v12.CFrame = CFrame.new(v2.Position) * cframe
    v12.RotVelocity = Vector3.new(0, 20, 0) + Random.new():NextUnitVector() * 5
    v12.Parent = workspace
    table.insert(arg2._destroy_these, v12)

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
            NoCollisionConstraint.Part0 = val
            NoCollisionConstraint.Part1 = v12
            NoCollisionConstraint.Parent = v12
        end
    end

    for key_1, val_1 in pairs(
        {
            cframe * CFrame.new(0, 0, 15),
            cframe * CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, 15)
        }
    ) do
        local Camera = Instance.new("Camera")
        local v16 = v12[key_1]
        v16.ViewportFrame.CurrentCamera = Camera
        v16.Adornee = v12
        v16.Parent = Players.LocalPlayer.PlayerGui
        local v17 = v5:Clone()
        v17:PivotTo(v17:GetPivot().Rotation)
        v17.Parent = v16.ViewportFrame
        Camera.CFrame = CFrame.new(val_1.Position, Vector3.new(0, 0, 0))
        Camera.FieldOfView = 30
        Camera.Parent = v16.ViewportFrame
    end

    local pivot_2 = v4:GetPivot()
    local now_2 = tick()

    while true do
        if not (tick() < now_2 + 0.1) then
            break
        end

        local v18 = math.random() - 0.5
        local v20 = pivot_2 + Vector3.new(v18, math.random() - 0.5, math.random() - 0.5) * math.random() * 1
        v4:PivotTo(v20)
        RunService.RenderStepped:Wait()
    end

    for _, descendant in pairs(v4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false
        end
    end
end

function t._Init(_) -- line: 131
end

return t
