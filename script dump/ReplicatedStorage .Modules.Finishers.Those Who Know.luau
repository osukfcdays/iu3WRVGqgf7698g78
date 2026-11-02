local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 9
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 21
    arg1:_AnchorModel(0)
end

function t.PlayClient(arg2) -- line: 25
    -- upvalues:
    --  [1] RunService (copy)

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            local v3, _, v5 = val.Color:ToHSV()
            val.Color = Color3.fromHSV(v3, 0, v5 * 0.5)
        elseif val:IsA("ParticleEmitter") or val:IsA("Beam") or val:IsA("Trail") then
            val:Destroy()
        end
    end

    local v7 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    local v8 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v9 = script.Skull:Clone()
    v9.Parent = v8
    table.insert(arg2._destroy_these, v9)
    arg2:CreateSound(
        "rbxassetid://117434088219830",
        0.75,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    v8 = v7:GetPivot()
    table.insert(arg2._connections, RunService.RenderStepped:Connect(function(_) -- line: 46
        -- upvalues:
        --  [1] v8 (copy)
        --  [2] v7 (copy)
        --  [3] v9 (copy)

        local v11 = v8
        local v12 = math.random() - 0.5
        local v13 = math.random() - 0.5
        local v14 = v11 + Vector3.new(v12, v13, math.random() - 0.5) * 0.1
        v7:PivotTo(v14)
        local v15 = v9
        local LookVector = CFrame.new(workspace.CurrentCamera.CFrame.Position, v14.Position).LookVector
        v15.CFrame = v14 + LookVector * -math.min(
            3,
            (workspace.CurrentCamera.CFrame.Position - v14.Position).Magnitude * 0.5
        )
    end))
end

function t._Init(_) -- line: 58
end

return t
