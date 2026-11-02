local t = {}
local Finishers = game:GetService("ReplicatedStorage").Modules.Finishers
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Scene = arg1
    t_1._dummy_template = t_1.Scene.Model:WaitForChild("FinisherDummy")
    t_1._fake_player = t_1.Scene.Model:WaitForChild("FakePlayer")
    t_1._playing_hash = 0
    t_1._last_rig = nil
    t_1._last_finisher = nil
    t_1:_Init()

    return t_1
end

function t.GetHumanoidCFrame(arg2) -- line: 30
    return arg2._dummy_template:GetPivot()
end

function t.OnCustomizingStateChanged(arg3) -- line: 34
    task.defer(arg3._StartPlaying, arg3)
end

function t.OnStateChanged(arg4) -- line: 38
    task.defer(arg4._StartPlaying, arg4)
end

function t._StartPlaying(arg5) -- line: 46
    -- upvalues:
    --  [1] Finishers (copy)

    arg5._playing_hash += 1
    local PlayingHash = arg5._playing_hash

    if arg5._last_rig then
        arg5._last_rig:Destroy()
        arg5._last_rig = nil
    end

    if arg5._last_finisher then
        arg5._last_finisher:Destroy()
        arg5._last_finisher = nil
    end

    local v1 = arg5.Scene.Equipment:GetSelectedCosmetic()

    if arg5.Scene.Equipment:GetCustomizingType() ~= "Finisher" then
        return
    end

    while true do
        arg5._last_rig = arg5._dummy_template:Clone()
        arg5._last_rig:PivotTo(arg5:GetHumanoidCFrame() * CFrame.new(0, 0, 8))
        arg5._last_rig.Parent = arg5.Scene.Model
        arg5._last_rig.Humanoid:MoveTo((arg5._last_rig:GetPivot() * CFrame.new(0, 0, -16)).Position)
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://14266666697"
        local v4, Result = pcall(
            arg5._last_rig.Humanoid.LoadAnimation,
            arg5._last_rig.Humanoid,
            Animation
        )

        if v4 then
            Result:Play(0)
        end

        wait(0.5)

        if arg5._playing_hash ~= PlayingHash then
            return
        end

        if v4 then
            Result:Stop(0)
        end

        arg5._last_rig:PivotTo(
            arg5._last_rig:GetPivot() * CFrame.Angles(
                0.17453292519943295,
                0,
                math.sign(math.random() - 0.5) * 0.17453292519943295
            )
        )
        local HumanoidRootPart = arg5._last_rig.HumanoidRootPart
        HumanoidRootPart.AssemblyLinearVelocity *= 0
        arg5._last_rig.Humanoid.Health = 0

        for _, val in pairs(arg5._last_rig:GetChildren()) do
            if val:IsA("BasePart") then
                for _, val_1 in pairs(arg5._last_rig:GetChildren()) do
                    if val_1:IsA("BasePart") and val_1 ~= val then
                        local NoCollisionConstraint = Instance.new("NoCollisionConstraint")
                        NoCollisionConstraint.Part1 = val_1
                        NoCollisionConstraint.Part0 = val
                        NoCollisionConstraint.Parent = val
                    end
                end
            end
        end

        for _, val_2 in pairs(arg5._last_rig:GetDescendants()) do
            if val_2:IsA("BasePart") then
                val_2.CanCollide = true
            end
        end

        v4 = v1 ~= "RANDOM_COSMETIC" and v1 or "Ragdoll"
        arg5._last_finisher = require(Finishers[v4]).new(
            arg5._last_rig.Humanoid,
            false,
            { Character = arg5._fake_player }
        )
        arg5._last_finisher:Simulate()

        if arg5._playing_hash ~= PlayingHash then
            return
        end

        wait(3)

        if arg5._playing_hash ~= PlayingHash then
            return
        end

        if arg5._last_rig then
            arg5._last_rig:Destroy()
            arg5._last_rig = nil
        end

        if not arg5._last_finisher then
            continue
        end

        arg5._last_finisher:Destroy()
        arg5._last_finisher = nil
    end
end

function t._Setup(arg6) -- line: 147
    arg6._dummy_template.Parent = nil
end

function t._Init(arg7) -- line: 151
    arg7:_Setup()
end

return t
