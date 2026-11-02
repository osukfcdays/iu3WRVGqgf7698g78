local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 12
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1) -- line: 24
    -- upvalues:
    --  [1] RunService (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 32
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v4:PivotTo(CFrame.new(v2.Position) * cframe * CFrame.Angles(1.5707963267948966, 0, 0))
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    local Success, Result = pcall(
        v4.AnimationController.LoadAnimation,
        v4.AnimationController,
        v4.Animation
    )

    if Success then
        Result:Play(0)
        wait(0.65)
        arg1:CreateSound(
            "rbxassetid://121251326830312",
            1.25,
            1,
            nil,
            true,
            5
        )
        wait(0.1)
        local t_2 = {}

        for _, val in pairs(arg1:_GetObjects(true)) do
            if
                val:IsA("BasePart")
                or val:IsA("Decal")
                or val:IsA("Texture")
                or val:IsA("Beam")
                or val:IsA("ParticleEmitter")
                or val:IsA("Trail")
            then
                t_2[val] = true
            end
        end

        local now = tick()

        while true do
            if not (tick() < now + 0.75) then
                break
            end

            local clampedValue = math.clamp((tick() - now) / 0.75, 0, 1)

            for key_1, _ in pairs(t_2) do
                key_1.LocalTransparencyModifier = clampedValue
            end

            RunService.RenderStepped:Wait()
        end

        for key_2, _ in pairs(t_2) do
            key_2.LocalTransparencyModifier = 1
        end

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end
    end

    v4:Destroy()
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 86
end

return t
