local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 10
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 22
    arg1:_AnchorModel(0)
end

function t.PlayClient(arg2, ...) -- line: 26
    -- upvalues:
    --  [1] RunService (copy)

    local t_2 = {}

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") then
            t_2[val] = val.CFrame
        end
    end

    table.insert(arg2._connections, RunService.RenderStepped:Connect(function(_) -- line: 35
        -- upvalues:
        --  [1] t_2 (copy)

        for key_1, val_1 in pairs(t_2) do
            local v3 = math.random() - 0.5
            key_1.CFrame = val_1 + Vector3.new(v3, math.random() - 0.5, math.random() - 0.5) * 0.2
        end
    end))
    arg2:CreateSound(
        "rbxassetid://82637145735352",
        1,
        1 + 0.1 * math.random(),
        nil,
        true
    )
end

function t._Init(_) -- line: 48
end

return t
