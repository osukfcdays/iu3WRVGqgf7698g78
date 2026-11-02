local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 24
    arg1:_AnchorModel(0)
end

function t.PlayClient(arg2, ...) -- line: 28
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] Utility_m (copy)

    if not arg2._is_humanoid then
        return
    end

    arg2:CreateSound(
        "rbxassetid://140285154660882",
        1.25,
        1,
        arg2._subject.RootPart.Position,
        true,
        5
    )
    local Parent = arg2._subject.Parent
    local v2 = Random.new():NextUnitVector()
    local pivot = Parent:GetPivot()
    local scale = Parent:GetScale()
    local now = tick()

    while true do
        if not (tick() < now + 0.5) then
            break
        end

        local v4 = 1 - (1 - (1 - (now + 0.5 - tick()) / 0.5)) ^ 2
        local v5 = v2 * -v4 * 3.141592653589793 * 2 * 3
        Parent:ScaleTo(scale * (1 - v4))
        Parent:PivotTo(pivot * CFrame.Angles(v5.X, v5.Y, v5.Z))
        RunService.RenderStepped:Wait()
    end

    local v8 = script.Particles.Attachment:Clone()
    v8.Parent = arg2._subject.RootPart
    table.insert(arg2._destroy_these, v8)
    Utility_m:PlayParticles(v8)
    wait(0.25)
    arg2:CreateSound(
        "rbxassetid://73926817558125",
        1,
        1,
        arg2._subject.RootPart.Position,
        true,
        5
    )
    wait(1)
end

function t._Init(_) -- line: 68
end

return t
