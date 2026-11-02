local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local tweenInfo_1 = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
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

function t.PlayClient(arg1) -- line: 24
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)
    --  [3] tweenInfo_1 (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject

    for _, val in pairs(arg1:_GetObjects(true)) do
        if val:IsA("BasePart") and val ~= v2 then
            val:Destroy()
        end
    end

    v2.Size = Vector3.new(0, 0, 0)

    for _ = 1, math.random(5, 10) do
        local v5 = Random.new():NextUnitVector() * Vector3.new(1, 0, 1) + Vector3.new(
            0,
            0.5 + 0.5 * math.random(),
            0
        )
        local v6 = script.Bone:Clone()
        v6.CFrame = v2.CFrame
        v6.Size = v6.Size * (0.875 + 0.25 * math.random())
        v6.Velocity = v5 * (15 + 15 * math.random())
        v6.RotVelocity = Random.new():NextUnitVector() * (5 + 10 * math.random())
        v6.Parent = v2
        table.insert(arg1._destroy_these, v6)
    end

    local v8 = script.BonePile:Clone()
    v8.Size = Vector3.new(0, 0, 0)
    v8.CFrame = v2.CFrame
    v8.Velocity = Random.new():NextUnitVector() * (5 + 10 * math.random())
    v8.CollisionGroup = "IgnorePlayers"
    v8.Parent = v2
    table.insert(arg1._destroy_these, v8)
    TweenService:Create(v8, tweenInfo, { Size = script.BonePile.Size }):Play()
    arg1:CreateSound(
        "rbxassetid://71015990947254",
        1.25,
        0.95 + 0.1 * math.random(),
        v8,
        true,
        10
    )
    wait(3)
    TweenService:Create(v8, tweenInfo_1, { Size = Vector3.new(0, 0, 0) }):Play()
    wait(1)
end

function t._Init(_) -- line: 70
end

return t
