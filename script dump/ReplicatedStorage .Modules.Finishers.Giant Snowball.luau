local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 25
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = script.Model:Clone()
    v3.PrimaryPart = v3.Primary
    v3.Parent = v2
    local v4 = v3:GetScale() * (1 + 1 * math.random())
    v3:ScaleTo(v4)
    table.insert(arg1._destroy_these, v3)
    BetterDebris_m:AddItem(v3, 10)

    local _ = function() --[[ get_position ]] -- line: 37
        -- upvalues:
        --  [1] v2 (copy)

        return v2.Position - Vector3.new(0, 1.5, 0)
    end

    local v5 = math.random() * 3.141592653589793 * 2
    Utility_m:RenderstepForLoop(0, 100, 4, function(arg2) -- line: 43
        -- upvalues:
        --  [1] v2 (copy)
        --  [2] v5 (copy)
        --  [3] v3 (copy)

        local v6 = v2.Position - Vector3.new(0, 1.5, 0)
        local cosine = math.cos(v5)
        local sine = math.sin(v5)
        local v7 = v6 + Vector3.new(cosine, 0, sine) * 128 + Vector3.new(0, 128, 0)
        local v8 = (v7 - v6).Magnitude * (1 - arg2 / 100)
        v3:PivotTo(CFrame.new(v6, v7) * CFrame.new(0, 0, -v8 / 2))
    end)
    Utility_m:PlayParticles(v3)
    arg1:CreateSound(
        "rbxassetid://110743147230828",
        1.5,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    local now = tick()

    while true do
        if not (tick() < now + 2) then
            break
        end

        v3:PivotTo(CFrame.new(v2.Position - Vector3.new(0, 1.5, 0)))
        RunService.RenderStepped:Wait()
    end

    v3.PrimaryPart.Anchored = false
end

function t._Init(_) -- line: 72
end

return t
