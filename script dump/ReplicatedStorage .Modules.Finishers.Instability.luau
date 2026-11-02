local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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
    arg1:_BreakJoints()
    arg1:_AnchorModel()

    for _, val in pairs(arg1:_GetObjects()) do
        if val:IsA("BasePart") and val.Name ~= "HumanoidRootPart" then
            local v3 = math.random() - 0.5
            val.AssemblyLinearVelocity = Vector3.new(v3, math.random(), math.random() - 0.5) * 128
            local v4 = math.random() - 0.5
            val.AssemblyAngularVelocity = Vector3.new(v4, math.random(), math.random() - 0.5) * 32
        end
    end
end

function t.PlayClient(arg2) -- line: 34
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)

    arg2:CreateSound(
        "rbxassetid://119382605046173",
        1,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    local v6 = script.Explosion:Clone()
    local v7 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    v6.CFrame = v7.CFrame
    v6.Parent = arg2._subject
    table.insert(arg2._destroy_these, v6)
    BetterDebris_m:AddItem(v6, 5)
    Utility_m:PlayParticles(v6)
end

function t._Init(_) -- line: 49
end

return t
