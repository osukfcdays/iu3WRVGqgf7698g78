local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local t = { "RightShoulderBallSocket", "RightElbowBallSocket", "RightWristBallSocket" }
local t_1 = { "LeftShoulderBallSocket", "LeftElbowBallSocket", "LeftWristBallSocket" }
local t_2 = {}
t_2.__index = t_2

function t_2.new(arg1) -- line: 12
    -- upvalues:
    --  [1] t_2 (copy)

    local t_3 = setmetatable({}, t_2)
    t_3.ClientFighterCharacter = arg1
    t_3._destroyed = false
    t_3._right_hand_ik_control = Instance.new("IKControl")
    t_3._left_hand_ik_control = Instance.new("IKControl")
    t_3._ik_control_target_item = nil
    t_3._ik_arms_disable_hash = 0
    t_3._arm_ball_socket_constraints = {}
    t_3:_Init()

    return t_3
end

function t_2.SetIKControlTargetItem(arg2, arg3) -- line: 34
    if arg3 == arg2._ik_control_target_item then
        return
    end

    arg2._ik_control_target_item = arg3
    arg2._right_hand_ik_control.Enabled = false
    arg2._left_hand_ik_control.Enabled = false
    local RightHandIkControl = arg2._right_hand_ik_control
    RightHandIkControl.Target = if not arg2._ik_control_target_item then nil else if arg2._ik_control_target_item.ViewModel.RightArmIKControlDisabled then nil else arg2._ik_control_target_item.ViewModel.Model.RightArm.HandAttachment or nil
    local LeftHandIkControl = arg2._left_hand_ik_control
    LeftHandIkControl.Target = if not arg2._ik_control_target_item then nil else if arg2._ik_control_target_item.ViewModel.LeftArmIKControlDisabled then nil else arg2._ik_control_target_item.ViewModel.Model.LeftArm.HandAttachment or nil
    arg2:_UpdateArmBallSocketConstraints()
    arg2:Update(0, nil)
end

function t_2.DisableIKArms(arg4, arg5, arg6, arg7) -- line: 50
    -- upvalues:
    --  [1] RunService (copy)

    arg4._ik_arms_disable_hash += 1

    local _ = function(arg8) --[[ set ]] -- line: 54
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] arg4 (copy)
        --  [3] arg7 (copy)

        if not arg6 then
            arg4._right_hand_ik_control.Weight = arg8
        end

        if not arg7 then
            arg4._left_hand_ik_control.Weight = arg8
        end
    end

    if arg5 >= math.huge then
        if not arg6 then
            local _ = arg4._ik_arms_disable_hash
            arg4._right_hand_ik_control.Weight = 0
        end

        if not arg7 then
            arg4._left_hand_ik_control.Weight = 0
        end

        return
    end

    local IkArmsDisableHash_1 = arg4._ik_arms_disable_hash
    task.spawn(function() -- line: 69
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] IkArmsDisableHash_1 (copy)
        --  [3] arg4 (copy)
        --  [4] arg6 (copy)
        --  [5] arg7 (copy)
        --  [6] RunService (ref)

        local now = tick()

        while true do
            if not (tick() < now + arg5) then
                break
            end

            if IkArmsDisableHash_1 ~= arg4._ik_arms_disable_hash then
                return
            end

            local v2 = math.clamp((tick() - now) / arg5, 0, 1) ^ 4

            if not arg6 then
                arg4._right_hand_ik_control.Weight = v2
            end

            if not arg7 then
                arg4._left_hand_ik_control.Weight = v2
            end

            RunService.RenderStepped:Wait()
        end

        if not arg6 then
            arg4._right_hand_ik_control.Weight = 1
        end

        if not arg7 then
            arg4._left_hand_ik_control.Weight = 1
        end
    end)
end

function t_2.Update(arg9, _, arg11) -- line: 86
    if if not arg11 then arg9.ClientFighterCharacter:IsHidden() else not arg11.IsAlive or arg9.ClientFighterCharacter:IsHidden() then
        return
    end

    local v3 = arg9._ik_control_target_item and (arg9._ik_control_target_item.ViewModel.Model.HumanoidRootPart.Position - arg9.ClientFighterCharacter.RootPart.Position).Magnitude < 16
    arg9._right_hand_ik_control.Enabled = arg9._right_hand_ik_control.Target and v3
    arg9._left_hand_ik_control.Enabled = arg9._left_hand_ik_control.Target and v3
    arg9:_UpdateArmBallSocketConstraints()
end

function t_2.Destroy(arg12) -- line: 98
    arg12._destroyed = true
    arg12._ik_control_target_item = nil
    arg12._ik_arms_disable_hash += 1
    arg12._right_hand_ik_control:Destroy()
    arg12._left_hand_ik_control:Destroy()
end

function t_2._UpdateArmBallSocketConstraints(arg13) -- line: 111
    for key, val in pairs(arg13._arm_ball_socket_constraints) do
        key.Enabled = not val.Enabled
    end
end

function t_2._SetupAsync(arg14) -- line: 117
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_1 (copy)
    --  [3] Utility_m (copy)

    arg14.ClientFighterCharacter:WaitUntilIsInWorld()

    if arg14._destroyed then
        return
    end

    arg14._right_hand_ik_control.Name = "RightHandIKControl"
    arg14._right_hand_ik_control.EndEffector = arg14.ClientFighterCharacter.Model:WaitForChild(
        "RightHand"
    )
    arg14._right_hand_ik_control.ChainRoot = arg14.ClientFighterCharacter.Model:WaitForChild(
        "RightUpperArm"
    )
    arg14._right_hand_ik_control.SmoothTime = 0
    arg14._right_hand_ik_control.Enabled = false
    arg14._right_hand_ik_control.Parent = arg14.ClientFighterCharacter.Humanoid
    arg14._left_hand_ik_control.Name = "LeftHandIKControl"
    arg14._left_hand_ik_control.EndEffector = arg14.ClientFighterCharacter.Model:WaitForChild(
        "LeftHand"
    )
    arg14._left_hand_ik_control.ChainRoot = arg14.ClientFighterCharacter.Model:WaitForChild(
        "LeftUpperArm"
    )
    arg14._left_hand_ik_control.SmoothTime = 0
    arg14._left_hand_ik_control.Enabled = false
    arg14._left_hand_ik_control.Parent = arg14.ClientFighterCharacter.Humanoid

    for _, val_1 in pairs(
        { { t, arg14._right_hand_ik_control }, { t_1, arg14._left_hand_ik_control } }
    ) do
        local v4, v5 = table.unpack(val_1)

        for _, val_2 in pairs(v4) do
            arg14._arm_ball_socket_constraints[Utility_m:WaitForChildRecursive(
                arg14.ClientFighterCharacter.Model,
                val_2
            )] = v5
        end
    end

    arg14:Update(0, nil)
    arg14:_UpdateArmBallSocketConstraints()
end

function t_2._Init(arg15) -- line: 152
    arg15.ClientFighterCharacter.EmoteStatusChanged:Connect(function() -- line: 153
        -- upvalues:
        --  [1] arg15 (copy)

        if arg15.ClientFighterCharacter:IsEmoting() then
            arg15:DisableIKArms(math.huge)

            return
        end

        arg15:DisableIKArms(0)
    end)
    arg15.ClientFighterCharacter:AddConnection(arg15.ClientFighterCharacter.ClientFighter.EquippedItemChanged:Connect(
        function() -- line: 161
            -- upvalues:
            --  [1] arg15 (copy)

            arg15:Update(nil, nil)
        end
    ))
    task.defer(arg15._SetupAsync, arg15)
end

return t_2
