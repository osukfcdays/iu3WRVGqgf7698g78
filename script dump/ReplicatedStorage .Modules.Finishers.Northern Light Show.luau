local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

function t.PlayClient(arg1) -- line: 22
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)

    Ragdoll_m.PlayClient(arg1)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, 6.283185307179586 * math.random(), 0)
    local v4 = script.Aurora:Clone()
    v4.PrimaryPart = v4.Primary
    v4.Parent = arg1._subject
    table.insert(arg1._destroy_these, v4)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 33
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v4:PivotTo(CFrame.new(v2.Position) * cframe)
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    arg1:CreateSound(
        "rbxassetid://81606650181214",
        1,
        1.25 + 0.125 * math.random(),
        nil,
        true,
        5
    )
    local children = v4.Beams:GetChildren()
    Utility_m:RenderstepForLoop(0, 100, 1, function(arg2) -- line: 43
        -- upvalues:
        --  [1] children (copy)

        for _, val in pairs(children) do
            val.LocalTransparencyModifier = 1 - arg2 / 100
        end
    end)
    wait(3)
    Utility_m:RenderstepForLoop(0, 100, 1, function(arg3) -- line: 51
        -- upvalues:
        --  [1] children (copy)

        for _, val_1 in pairs(children) do
            val_1.LocalTransparencyModifier = arg3 / 100
        end
    end)
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 64
end

return t
