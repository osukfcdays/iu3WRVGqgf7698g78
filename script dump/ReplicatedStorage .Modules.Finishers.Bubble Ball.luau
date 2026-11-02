local v1 = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local Ragdoll_m = require(v1.Modules.Finishers.Ragdoll)
v1 = CONSTANTS_m.IS_SERVER

if v1 then
    v1 = require(ServerStorage.Services.CollisionsService)
end

local t = setmetatable({}, Ragdoll_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Ragdoll_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1, ...) -- line: 23
    -- upvalues:
    --  [1] Ragdoll_m (copy)
    --  [2] v1 (copy)

    Ragdoll_m.PlayServer(arg1, ...)
    arg1:_AnchorModel(0, false)

    if not arg1._is_humanoid then
        return
    end

    local v3 = script.Model:Clone()
    v3.Hitbox.CanCollide = false
    v3.Hitbox.Anchored = true
    local v4 = arg1._subject.RootPart.CFrame
    v3:PivotTo(
        v4 * CFrame.Angles(
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2,
            math.random() * 3.141592653589793 * 2
        )
    )
    v3.Parent = arg1._subject
    table.insert(arg1._destroy_these, v3)

    for _, val in pairs({ "RightHand", "RightFoot", "LeftHand", "LeftFoot" }) do
        local v8 = arg1._subject.Parent

        if v8 then
            v8 = arg1._subject.Parent:FindFirstChild(val)
        end

        if v8 then
            local Attachment = Instance.new("Attachment")
            Attachment.Parent = v8
            local AlignPosition = Instance.new("AlignPosition")
            AlignPosition.MaxForce = 100000
            AlignPosition.Responsiveness = 25
            AlignPosition.Attachment0 = Attachment
            AlignPosition.Attachment1 = v3.Hitbox[val]
            AlignPosition.Parent = Attachment
            local AlignOrientation = Instance.new("AlignOrientation")
            AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
            AlignOrientation.Attachment0 = Attachment
            AlignOrientation.CFrame = v8.CFrame
            AlignOrientation.Parent = Attachment
        end
    end

    v1:SetDescendants(arg1._subject.Parent, "OnlyMap")
    v3.Hitbox.CanCollide = true
    v3.Hitbox.Anchored = false
    v3.Hitbox:SetNetworkOwner(nil)
    v3.Hitbox.AssemblyLinearVelocity = Random.new():NextUnitVector() * (24 + 8 * math.random())
end

function t.PlayClient(arg2, ...) -- line: 69
    -- upvalues:
    --  [1] Ragdoll_m (copy)

    Ragdoll_m.PlayClient(arg2, ...)
    arg2:CreateSound(
        "rbxassetid://70645035845566",
        1,
        1 + 0.1 * math.random(),
        arg2._is_humanoid and arg2._subject.RootPart or arg2._subject,
        true,
        10
    )
end

function t._Init(_) -- line: 78
end

return t
