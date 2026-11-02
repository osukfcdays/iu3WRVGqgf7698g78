local function set_ltm(arg1, arg2) -- line: 7
    for _, descendant in pairs(arg1:GetDescendants()) do
        if descendant:IsA("BasePart") or descendant:IsA("ParticleEmitter") then
            descendant.LocalTransparencyModifier = arg2
        end
    end
end

local Drops = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.Drops

return function(arg3, arg4, arg5) -- line: 15
    -- upvalues:
    --  [1] Drops (copy)
    --  [2] set_ltm (copy)

    local Attachment = Instance.new("Attachment")
    Attachment.Parent = arg3
    local v2 = Drops[arg4]:Clone()
    v2.PrimaryPart = v2.Primary
    v2:PivotTo(
        arg3.CFrame * CFrame.Angles(
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2
        )
    )

    for _, descendant_1 in pairs(v2:GetDescendants()) do
        if descendant_1:IsA("BasePart") then
            local v8 = if descendant_1 ~= v2.PrimaryPart then false else true
            descendant_1.CanCollide = false
            descendant_1.CanTouch = false
            descendant_1.CanQuery = false
            descendant_1.Massless = true
            descendant_1.Anchored = v8

            if not v8 then
                v8 = Instance.new("WeldConstraint")
                v8.Part0 = v2.Primary
                v8.Part1 = descendant_1
                v8.Parent = descendant_1
            end
        end
    end

    v2.PrimaryPart.Anchored = false
    v2.Parent = arg3
    local Attachment_1 = Instance.new("Attachment")
    Attachment_1.Parent = v2.PrimaryPart
    local AngularVelocity = Instance.new("AngularVelocity")
    AngularVelocity.MaxTorque = 1000000
    AngularVelocity.AngularVelocity = Vector3.new(0, 2, 0) * math.sign(math.random() - 0.5)
    AngularVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    AngularVelocity.Attachment0 = Attachment_1
    AngularVelocity.Parent = v2.PrimaryPart
    local AlignPosition = Instance.new("AlignPosition")
    AlignPosition.RigidityEnabled = true
    AlignPosition.Attachment0 = Attachment_1
    AlignPosition.Attachment1 = Attachment
    AlignPosition.Parent = v2.PrimaryPart

    if arg5 < math.huge then
        wait(arg5 - 4)

        for _ = 1, 20 do
            set_ltm(arg3, 1)
            wait(0.07500000000000001)
            set_ltm(arg3, 0)
            wait(0.125)
        end
    end
end
