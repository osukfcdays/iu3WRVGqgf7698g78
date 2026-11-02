local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local color = Color3.fromRGB(221, 221, 221)
local color_1 = Color3.fromRGB(27, 42, 53)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
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
    --  [3] Utility_m (copy)
    --  [4] color (copy)
    --  [5] color_1 (copy)

    Ragdoll_m.PlayClient(arg1, ...)
    local v2 = script.Model:Clone()
    v2.Parent = workspace
    table.insert(arg1._destroy_these, v2)
    local v3 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local HeartbeatConnection_1 = RunService.Heartbeat:Connect(function() -- line: 37
        -- upvalues:
        --  [1] v2 (copy)
        --  [2] v3 (copy)
        --  [3] cframe (copy)

        v2:PivotTo(CFrame.new(v3.Position) * cframe)
    end)
    table.insert(arg1._connections, HeartbeatConnection_1)
    local Success, Result = pcall(
        v2.AnimationController.LoadAnimation,
        v2.AnimationController,
        v2.Animation
    )

    if Success then
        Result:Play(0)
        wait(1.375)
        v2.Cloud.vfx.water1.Enabled = true
        v2.Cloud.vfx2.water2.Enabled = true
        v2.Cloud.ground.ring1.Enabled = true
        v2.Cloud.ground.splash1.Enabled = true
        arg1:_InternalThread(
            task.spawn,
            Utility_m.RenderstepForLoop,
            Utility_m,
            0,
            100,
            2,
            function(arg2) -- line: 55
                -- upvalues:
                --  [1] v2 (copy)
                --  [2] color (ref)
                --  [3] color_1 (ref)

                v2.Cloud.Color = color:Lerp(color_1, 1 - (1 - arg2 / 100) ^ 2)
            end
        )
        arg1:_InternalThread(task.defer, function() -- line: 61
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] v2 (copy)
            --  [3] arg1 (copy)

            wait(0.5)
            Utility_m:PlayParticles(v2.Cloud.Thunder)
            arg1:CreateSound(
                "rbxassetid://79197041664081",
                1.5,
                0.75 + 0.25 * math.random(),
                nil,
                true,
                5
            )
            wait(1)
            Utility_m:PlayParticles(v2.Cloud.Thunder)
            arg1:CreateSound(
                "rbxassetid://79197041664081",
                1.5,
                0.75 + 0.25 * math.random(),
                nil,
                true,
                5
            )
            wait(0.3)
            Utility_m:PlayParticles(v2.Cloud.Thunder)
            arg1:CreateSound(
                "rbxassetid://79197041664081",
                1.5,
                0.75 + 0.25 * math.random(),
                nil,
                true,
                5
            )
        end)
        arg1:CreateSound(
            "rbxassetid://114760171297145",
            2,
            1,
            nil,
            true,
            5
        )
        wait(2.75)
        v2.Cloud.vfx.water1.Enabled = false
        v2.Cloud.vfx2.water2.Enabled = false
        v2.Cloud.ground.ring1.Enabled = false
        v2.Cloud.ground.splash1.Enabled = false
        arg1:_InternalThread(
            task.spawn,
            Utility_m.RenderstepForLoop,
            Utility_m,
            0,
            100,
            2,
            function(arg3) -- line: 87
                -- upvalues:
                --  [1] v2 (copy)
                --  [2] color_1 (ref)
                --  [3] color (ref)

                v2.Cloud.Color = color_1:Lerp(color, (arg3 / 100) ^ 2)
            end
        )
        wait(1)
    end

    v2:Destroy()
end

function t._Init(_) -- line: 103
end

return t
