local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Ragdoll_m = require(ReplicatedStorage.Modules.Finishers.Ragdoll)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local _ = require(ReplicatedStorage.Modules.Utility)
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
    --  [1] Players (copy)
    --  [2] RunService (copy)

    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    local cframe = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v4 = arg1._is_humanoid

    if v4 then
        v4 = Players:GetPlayerFromCharacter(arg1._subject.Parent)
    end

    local v5 = v4 and v4.DisplayName or ""
    v4 = script.Model:Clone()
    v4.Tomb.Part.Front.Player.Text = v5
    v4.Tomb.Part.Back.Player.Text = v5
    v4.Parent = workspace
    table.insert(arg1._destroy_these, v4)
    v5 = RunService.RenderStepped:Connect(function() -- line: 37
        -- upvalues:
        --  [1] v4 (copy)
        --  [2] v2 (copy)
        --  [3] cframe (copy)

        v4:PivotTo(CFrame.new(v2.Position) * cframe + Vector3.new(0, 2.25, 0))
    end)
    table.insert(arg1._connections, v5)
    local Success, Result = pcall(
        v4.AnimationController.LoadAnimation,
        v4.AnimationController,
        v4.Animation
    )

    if Success then
        Result:Play(0)
        arg1:CreateSound(
            "rbxassetid://85156927480464",
            1.5,
            0.75,
            nil,
            true,
            5
        )
        wait(0.7)
        local v8 = pairs
        local v9 = arg1._is_humanoid and arg1._subject.Parent or arg1._subject

        for _, val in v8(v9:GetDescendants()) do
            if val:IsA("BasePart") then
                val.Transparency = 1
            elseif val:IsA("ParticleEmitter") or val:IsA("Beam") or val:IsA("Trail") or val:IsA(
                "Decal"
            ) then
                val:Destroy()
            end
        end

        arg1:CreateSound(
            "rbxassetid://112796414625817",
            2,
            0.75,
            nil,
            true,
            5
        )
        wait(9)
        arg1:CreateSound(
            "rbxassetid://125843357117650",
            2,
            0.75,
            nil,
            true,
            5
        )

        if Result.IsPlaying then
            Result.Stopped:Wait()
        end

        v4:Destroy()
        wait(3)
    end

    v5:Disconnect()
end

function t._Init(_) -- line: 82
end

return t
