local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
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
    -- upvalues:
    --  [1] RunService (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v2.Anchored = true
    wait(2.55)
    local v4 = arg1:_GetObjects(true)
    local v5 = arg1:_GetGroundPosition(v2.Position, v4)
    local v6 = v2.CFrame
    local v7 = CFrame.new(v5 + Vector3.new(0, -16, 0)) * v6.Rotation
    local now = tick()

    while true do
        if not (tick() < now + 0.25) then
            break
        end

        v2.CFrame = v6:Lerp(v7, math.clamp((tick() - now) / 0.25, 0, 1) ^ 2)
        RunService.Heartbeat:Wait()
    end

    wait(0.25)
    v2.Anchored = false
    arg1:_Ragdoll()
    arg1:_AnchorModel()
    wait(0.5)
end

function t.PlayClient(arg2) -- line: 58
    -- upvalues:
    --  [1] RunService (copy)

    if arg2._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://82538222745985"
        local Success, Result = pcall(arg2._subject.LoadAnimation, arg2._subject, Animation)

        if Success then
            Result:Play(0)
        end
    end

    local v10 = script.Hole:Clone()
    v10.Parent = workspace
    table.insert(arg2._destroy_these, v10)
    local v11 = arg2:_GetObjects(true)
    table.insert(v11, v10)
    arg2:CreateSound(
        "rbxassetid://93213527475361",
        1,
        1,
        nil,
        true,
        5
    )
    arg2:_InternalThread(task.defer, function() -- line: 80
        -- upvalues:
        --  [1] arg2 (copy)

        wait(2.4499999999999997)
        arg2:CreateSound(
            "rbxassetid://128064423147007",
            1,
            0.875,
            nil,
            true,
            5
        )
        wait(0.6)
        arg2:CreateSound(
            "rbxassetid://128064423147007",
            0.375,
            1.5,
            nil,
            true,
            5
        )
    end)
    local v12 = arg2._is_humanoid and arg2._subject.RootPart or arg2._subject
    local Position = v12.Position
    v12 = tick()

    while true do
        if not (tick() < v12 + 2.55 + 0.25 + 0.5) then
            break
        end

        local now_3 = tick()
        local clampedValue = if now_3 < v12 + 2.55 + 0.25 then math.clamp(
            (tick() - v12) / 2.55,
            0,
            1
        ) else math.clamp((tick() - v12 - 2.55 - 0.25) / 0.5, 0, 1)
        local v14 = if not (tick() < v12 + 2.55 + 0.25) then 1 - clampedValue ^ 5 else clampedValue < 0.5 and clampedValue ^ 5 * 16 or 1 - (clampedValue * -2 + 2) ^ 5 / 2
        v10.Size = (Vector3.new(0, 0, 0)):Lerp(Vector3.new(0.5, 12, 12), v14)
        v10.CFrame = CFrame.new(arg2:_GetGroundPosition(Position, v11)) * CFrame.Angles(
            0,
            0,
            1.5707963267948966
        )
        RunService.RenderStepped:Wait()
    end

    v10:Destroy()
end

function t._Init(_) -- line: 108
end

return t
