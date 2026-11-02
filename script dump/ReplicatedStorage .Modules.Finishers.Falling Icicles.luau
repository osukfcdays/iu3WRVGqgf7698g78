local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 15
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayClient(arg1, ...) -- line: 27
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] RunService (copy)
    --  [3] TweenService (copy)
    --  [4] tweenInfo (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = script.Model:Clone()
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 37
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v4:PivotTo(CFrame.new(v2.Position) * cframe)
    end)
    table.insert(arg1._connections, RenderSteppedConnection)
    local Success, Result = pcall(
        v4.AnimationController.LoadAnimation,
        v4.AnimationController,
        v4.Animation
    )

    if Success then
        Result:Play(0)
        Result:AdjustSpeed(2)
        arg1:_InternalThread(task.defer, function() -- line: 49
            -- upvalues:
            --  [1] v4 (copy)
            --  [2] TweenService (ref)
            --  [3] tweenInfo (ref)

            local t_2 = {}

            for index = 1, 16 do
                table.insert(t_2, v4["Icicles" .. index])
            end

            local t_3 = {}

            for _, val in pairs(t_2) do
                t_3[val] = val.Size
                val.Size = Vector3.new(0, 0, 0)
            end

            for _, val_1 in pairs(t_2) do
                TweenService:Create(val_1, tweenInfo, { Size = t_3[val_1] }):Play()
                wait(0.05)
            end
        end)
        arg1:CreateSound(
            "rbxassetid://93583856628897",
            1,
            1.5 + 0.2 * math.random(),
            nil,
            true,
            5
        )
        wait(0.55)

        for _ = 1, 6 do
            arg1:CreateSound(
                "rbxassetid://99261833097954",
                0.8 + 0.2 * math.random(),
                1 + 0.2 * math.random(),
                nil,
                true,
                10
            )
            wait(0.05 + 0.1 * math.random())
        end

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end
    end

    v4:Destroy()
    RenderSteppedConnection:Disconnect()
end

function t._Init(_) -- line: 91
end

return t
