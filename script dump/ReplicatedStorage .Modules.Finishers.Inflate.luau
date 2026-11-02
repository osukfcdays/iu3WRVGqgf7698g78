local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

function t.PlayServer(arg1) -- line: 27
    arg1:_AnchorModel(0)
    wait(2)
    arg1:_HideBody()
end

function t.PlayClient(arg2) -- line: 35
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] Utility_m (copy)

    local color = Color3.fromHSV(math.random(), 1, 1)
    local t_2 = {}

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = color
            val.Material = Enum.Material.Glass

            if val:IsA("MeshPart") then
                val.TextureID = ""
            end

            table.insert(t_2, val)
        end
    end

    local v4 = arg2._is_humanoid and arg2._subject.Parent or nil
    local v5 = v4

    if v5 then
        v5 = v4:GetScale()
    end

    local now = tick()
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 56
        -- upvalues:
        --  [1] now (copy)
        --  [2] v4 (copy)
        --  [3] v5 (copy)
        --  [4] t_2 (copy)

        local v6 = ((tick() - now) / 2) ^ 1.5
        local v7 = ((1 - math.cos(15.707963267948966 * v6)) / 4 + 4 * v6) / 4.5
        local v8 = 0.5 + 2.5 * v7

        if v4 then
            v4:ScaleTo(v5 * v8)
        end

        v8 = if not (v7 < 0.15) then (v7 ^ 4 - 0.15) / 0.75 * 0.5 else 0

        for _, val_1 in pairs(t_2) do
            val_1.LocalTransparencyModifier = v8
        end
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:_InternalThread(task.defer, function() -- line: 74
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:CreateSound(
            "rbxassetid://135921915396785",
            1,
            1,
            nil,
            true,
            5
        )
        wait(0.78)
        arg2:CreateSound(
            "rbxassetid://135921915396785",
            1,
            1,
            nil,
            true,
            5
        )
        wait(0.8)
        arg2:CreateSound(
            "rbxassetid://135921915396785",
            1,
            1,
            nil,
            true,
            5
        )
    end)
    wait(2)
    RenderSteppedConnection:Disconnect()
    local v10 = script.Particles:Clone()
    v10.Parent = workspace
    local v11 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    v10.CFrame = v11.CFrame
    table.insert(arg2._destroy_these, v10)
    Utility_m:PlayParticles(v10)

    for _, descendant in pairs(v10:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Color = ColorSequence.new(color)
        end
    end

    arg2:CreateSound(
        "rbxassetid://94915446476512",
        1,
        1,
        v10,
        true,
        5
    )
end

function t._Init(_) -- line: 109
end

return t
