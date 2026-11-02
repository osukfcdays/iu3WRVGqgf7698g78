local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 16
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 28
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local v3 = 0.975 + 0.05 * math.random()
    arg1:CreateSound(
        "rbxassetid://125154957015218",
        0.5,
        v3,
        nil,
        true,
        20
    )

    local function spawn_tumbleweed(arg2) -- line: 35
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] v2 (copy)
        --  [3] RunService (ref)

        local v4 = script.Tumbleweed:Clone()
        v4.PrimaryPart = v4.Primary
        v4.Parent = workspace
        table.insert(arg1._destroy_these, v4)
        arg2 += Vector3.new(0, 1, 0) * v4.PrimaryPart.Size.Y / 2
        local v5 = CFrame.new(arg2 * Vector3.new(1, 0, 1), v2.Position * Vector3.new(1, 0, 1)).RightVector * math.sign(
            math.random() - 0.5
        )
        local v6 = arg2 - v5 * 20 / 2
        local v7 = arg2 + v5 * 20 / 2
        v5 = CFrame.identity
        local v8 = Random.new():NextUnitVector() * 0.08726646259971647 * 60
        local now = tick()
        local v9 = tick() + 3

        while true do
            if arg1._destroyed or not (v9 > tick()) then
                break
            end

            local clampedValue = math.clamp((tick() - now) / 3, 0, 1)
            local absoluteValue = math.abs((math.sin(12.566370614359172 * clampedValue)))
            local v12 = v6:Lerp(v7, clampedValue) + Vector3.new(0, 1, 0) * absoluteValue * 3
            local absoluteValue_1 = math.abs(
                math.sin(3.141592653589793 * (clampedValue - 0.5)) ^ 10
            )
            v4:PivotTo(CFrame.new(v12) * v5)

            for _, val in pairs(v4:GetChildren()) do
                if val:IsA("BasePart") then
                    val.LocalTransparencyModifier = absoluteValue_1
                end
            end

            local v16 = RunService.RenderStepped:Wait()
            v5 *= CFrame.Angles(v8.X * v16, v8.Y * v16, v8.Z * v16)
        end

        v4:Destroy()
    end

    for _ = 1, 15 do
        local v17 = math.random() * 3.141592653589793 * 2
        local v18 = arg1:_GetGroundPosition(v2.Position)
        local cosine = math.cos(v17)
        arg1:_InternalThread(
            task.spawn,
            spawn_tumbleweed,
            v18 + Vector3.new(cosine, 0, (math.sin(v17))) * (0.25 + 3 * math.random())
        )
        wait(0.25)
    end

    wait(3)
end

function t._Init(_) -- line: 88
end

return t
