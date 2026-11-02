local Spring_m = require(game:GetService("ReplicatedStorage").Modules.Spring)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)
    --  [2] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._camera_rotation_spring = Spring_m.new(Vector2.zero, 1, 50)
    t_1._camera_lean_spring = Spring_m.new(0, 1, 20)
    t_1._waist_joint = nil
    t_1._waist_joint_is_motor6d = nil
    t_1._neck_joint = nil
    t_1._neck_joint_is_motor6d = nil
    t_1._root_joint = nil
    t_1._root_joint_is_motor6d = nil
    t_1._root_joint_origin = nil
    t_1:_Init()

    return t_1
end

function t.Update(arg2, _, arg4) -- line: 32
    if not arg4.IsAlive or arg2.ClientFighterCharacter:IsHidden() then
        return
    end

    arg2._camera_lean_spring.Target = arg4.CameraLean
    local CameraRotationSpring = arg2._camera_rotation_spring
    local New = Vector2.new
    local v1 = arg4.CameraRotationRaw.X > 3.141592653589793 and arg4.CameraRotationRaw.X - 6.283185307179586 or arg4.CameraRotationRaw.X
    local v2 = arg4.CameraRotationRaw.Y > 3.141592653589793 and arg4.CameraRotationRaw.Y - 6.283185307179586 or arg4.CameraRotationRaw.Y
    CameraRotationSpring.Target = New(v1, v2)
    local Value = arg2._camera_rotation_spring.Value
    local Value_1 = arg2._camera_lean_spring.Value

    if arg2._waist_joint then
        local v3 = CFrame.new(arg2._waist_joint.C0.Position) * CFrame.Angles(Value.X * 0.25, 0, 0)
        local cframe = CFrame.new(arg2._waist_joint.C1.Position)

        if arg2._waist_joint_is_motor6d then
            arg2._waist_joint.C0 = v3
            arg2._waist_joint.C1 = cframe
        else
            arg2._waist_joint.Attachment0.CFrame = v3
            arg2._waist_joint.Attachment1.CFrame = cframe
        end
    end

    if arg2._neck_joint then
        local v4 = CFrame.new(arg2._neck_joint.C0.Position) * CFrame.Angles(Value.X * 0.75, 0, 0)
        local cframe_2 = CFrame.new(arg2._neck_joint.C1.Position)

        if arg2._neck_joint_is_motor6d then
            arg2._neck_joint.C0 = v4
            arg2._neck_joint.C1 = cframe_2
        else
            arg2._neck_joint.Attachment0.CFrame = v4
            arg2._neck_joint.Attachment1.CFrame = cframe_2
        end
    end

    if arg2._root_joint and arg2._root_joint_origin then
        local v6 = arg2._root_joint_origin * CFrame.new(Value_1 * 1.25, 0, 0) * CFrame.Angles(
            0,
            0,
            Value_1 * -0.3490658503988659
        )

        if arg2._root_joint_is_motor6d then
            arg2._root_joint.C0 = v6

            return
        end

        arg2._root_joint.Attachment0.CFrame = v6
    end
end

function t.Destroy(_) -- line: 83
end

function t._SetupAsync(arg6) -- line: 91
    arg6.ClientFighterCharacter:WaitUntilIsInWorld()
    arg6._waist_joint = arg6.ClientFighterCharacter.Model:WaitForChild("UpperTorso"):WaitForChild(
        "Waist"
    )
    arg6._waist_joint_is_motor6d = arg6._waist_joint:IsA("Motor6D")
    arg6._neck_joint = arg6.ClientFighterCharacter.Model:WaitForChild("Head"):WaitForChild("Neck")
    arg6._neck_joint_is_motor6d = arg6._neck_joint:IsA("Motor6D")
    arg6._root_joint = arg6.ClientFighterCharacter.Model:WaitForChild("LowerTorso"):WaitForChild(
        "Root"
    )
    arg6._root_joint_is_motor6d = arg6._root_joint:IsA("Motor6D")
    arg6._root_joint_origin = arg6._root_joint.C0
end

function t._Init(arg7) -- line: 105
    task.spawn(arg7._SetupAsync, arg7)
end

return t
