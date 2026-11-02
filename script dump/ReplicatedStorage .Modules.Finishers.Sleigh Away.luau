local Finisher_m = require(game:GetService("ReplicatedStorage").Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 20
    local v2 = arg1._is_humanoid and arg1._subject.RootPart or arg1._subject
    v2.Anchored = true

    if arg1._is_humanoid then
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://4769412289"
        local Success, Result = pcall(arg1._subject.LoadAnimation, arg1._subject, Animation)

        if Success then
            Result:Play(0)
            Result:AdjustSpeed(0.16666666666666666)
        end
    end

    local Attachment = Instance.new("Attachment")
    Attachment.Parent = v2
    table.insert(arg1._destroy_these, Attachment)
    local v3 = script.Model:Clone()
    v3:PivotTo(CFrame.new(v2.Position) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0))
    v3.Parent = workspace
    table.insert(arg1._destroy_these, v3)
    local Success_1, Result_1 = pcall(
        v3.AnimationController.LoadAnimation,
        v3.AnimationController,
        v3.Animation
    )

    if Success_1 then
        Result_1:Play(0)
        arg1:CreateSound(
            "rbxassetid://70986468462566",
            1.5,
            1 + 0.1 * math.random(),
            v3.HumanoidRootPart,
            true,
            5
        )
        wait(0.3)
        local t_2 = {}

        for _, val in pairs(arg1:_GetObjects(true)) do
            if val:IsA("BasePart") then
                t_2[val] = val.CollisionGroup
                val.CollisionGroup = "Noclip"
            end
        end

        v2.Anchored = false
        arg1:_Ragdoll()
        local AlignPosition = Instance.new("AlignPosition")
        AlignPosition.RigidityEnabled = true
        AlignPosition.ApplyAtCenterOfMass = true
        AlignPosition.Attachment1 = v3.Broomm.Attachment
        AlignPosition.Attachment0 = Attachment
        AlignPosition.Parent = v3
        table.insert(arg1._destroy_these, AlignPosition)
        wait(1.9)
        wait(0.75)
        AlignPosition:Destroy()
        arg1:_AnchorModel()

        for key_1, val_1 in pairs(t_2) do
            key_1.CollisionGroup = val_1
        end

        if Result_1.IsPlaying then
            Result_1.Stopped:Wait()
        end

        v3:Destroy()
        wait(3)
    end
end

function t._Init(_) -- line: 102
end

return t
