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

    local t_2 = {}

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            val.Color = Color3.fromRGB(248, 151, 255)
            val.Material = Enum.Material.Glass

            if val:IsA("MeshPart") then
                val.TextureID = ""
            end

            table.insert(t_2, val)
        end
    end

    local v3 = arg2._is_humanoid and arg2._subject.Parent or nil
    local v4 = v3

    if v4 then
        v4 = v3:GetScale()
    end

    local now = tick()
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 55
        -- upvalues:
        --  [1] now (copy)
        --  [2] v3 (copy)
        --  [3] v4 (copy)
        --  [4] t_2 (copy)

        local v5 = ((tick() - now) / 2) ^ 1.5
        local v6 = ((1 - math.cos(15.707963267948966 * v5)) / 4 + 4 * v5) / 4.5
        local v7 = 0.5 + 2.5 * v6

        if v3 then
            v3:ScaleTo(v4 * v7)
        end

        v7 = if not (v6 < 0.15) then (v6 ^ 4 - 0.15) / 0.75 * 0.5 else 0

        for _, val_1 in pairs(t_2) do
            val_1.LocalTransparencyModifier = v7
        end
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:_InternalThread(task.defer, function() -- line: 73
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
    local v9 = script.Particles:Clone()
    v9.Parent = workspace
    local v10 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    v9.CFrame = v10.CFrame
    table.insert(arg2._destroy_these, v9)
    Utility_m:PlayParticles(v9)
    arg2:CreateSound(
        "rbxassetid://94915446476512",
        1,
        1,
        v9,
        true,
        5
    )
end

function t._Init(_) -- line: 102
end

return t
