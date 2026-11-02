local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
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

function t.PlayClient(arg2, ...) -- line: 25
    -- upvalues:
    --  [1] Utility_m (copy)

    local v2 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local v3 = script.Model:Clone()
    v3.Parent = workspace
    table.insert(arg2._destroy_these, v3)
    arg2:CreateSound(
        "rbxassetid://91581971640099",
        1.5,
        1,
        nil,
        true,
        5
    )
    local v4 = 1.25 + 0.25 * math.random()
    arg2:CreateSound(
        "rbxassetid://17812496122",
        0.5,
        v4,
        nil,
        true,
        5
    )
    local v5 = 1 + 0.2 * math.random()
    arg2:CreateSound(
        "rbxassetid://17812566721",
        2,
        v5,
        nil,
        true,
        5
    )
    arg2:_InternalThread(task.spawn, function() -- line: 36
        -- upvalues:
        --  [1] arg2 (copy)

        wait(0.25)
        arg2:CreateSound(
            "rbxassetid://18128895977",
            2,
            1,
            nil,
            true,
            5
        )
        wait(0.25)
        local v6 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject

        for _, descendant in pairs(v6:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1
            elseif
                descendant:IsA("ParticleEmitter")
                or descendant:IsA("Beam")
                or descendant:IsA("Trail")
                or descendant:IsA("Decal")
            then
                descendant:Destroy()
            end
        end
    end)
    local Position = nil
    local v9 = (Random.new():NextUnitVector() * Vector3.new(1, 0, 1)).Unit * 30
    Utility_m:RenderstepForLoop(0, 100, 2, function(arg3) -- line: 59
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] v2 (copy)
        --  [3] Position (ref)
        --  [4] v3 (copy)

        local v10 = arg3 / 100
        local sine = math.sin(3.141592653589793 * v10)
        local v12 = if v10 < 0.5 then v9:Lerp(Vector3.new(0, 0, 0), v10 * 2) else (Vector3.new(0, 0, 0)):Lerp(
            -v9,
            v10 * 2 - 1
        )
        v10 = CFrame.new(v2.Position) + (Vector3.new(0, -30, 0)):Lerp(Vector3.new(0, 0, 0), sine) + v12

        if Position and not Position:FuzzyEq(v10.Position) then
            v10 = CFrame.new(v10.Position, Position) * CFrame.Angles(1.5707963267948966, 0, 0)
        end

        v3:PivotTo(v10)
        Position = v10.Position
    end)
    v3:Destroy()
end

function t._Init(_) -- line: 81
end

return t
