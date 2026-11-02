local t = {}
t.__index = t
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local VRService = game:GetService("VRService")
local _ = script.Parent:WaitForChild("CommonUtils")
local Keyboard_m = require(script:WaitForChild("Keyboard"))
local Gamepad_m = require(script:WaitForChild("Gamepad"))
local DynamicThumbstick_m = require(script:WaitForChild("DynamicThumbstick"))
local Success, Result = pcall(function() -- line: 41
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate")
end)
local v4 = Success and Result
local TouchThumbstick_m = require(script:WaitForChild("TouchThumbstick"))
local ClickToMoveController_m = require(script:WaitForChild("ClickToMoveController"))
local TouchJump_m = require(script:WaitForChild("TouchJump"))
local VehicleController_m = require(script:WaitForChild("VehicleController"))
local Success_1, Result_1 = pcall(function() -- line: 58
    return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsSupportMicroGamepad")
end)
local Value = Enum.ContextActionPriority.Medium.Value
local t_1 = {}
t_1[Enum.TouchMovementMode.DPad] = DynamicThumbstick_m
t_1[Enum.DevTouchMovementMode.DPad] = DynamicThumbstick_m
t_1[Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick_m
t_1[Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick_m
t_1[Enum.TouchMovementMode.Thumbstick] = TouchThumbstick_m
t_1[Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick_m
t_1[Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick_m
t_1[Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick_m
t_1[Enum.TouchMovementMode.ClickToMove] = ClickToMoveController_m
t_1[Enum.DevTouchMovementMode.ClickToMove] = ClickToMoveController_m
t_1[Enum.TouchMovementMode.Default] = DynamicThumbstick_m
t_1[Enum.ComputerMovementMode.Default] = Keyboard_m
t_1[Enum.ComputerMovementMode.KeyboardMouse] = Keyboard_m
t_1[Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard_m
t_1[Enum.DevComputerMovementMode.Scriptable] = nil
t_1[Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController_m
t_1[Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController_m

function t.new() -- line: 92
    -- upvalues:
    --  [1] t (copy)
    --  [2] Players (copy)
    --  [3] VehicleController_m (copy)
    --  [4] Value (copy)
    --  [5] RunService (copy)
    --  [6] UserGameSettings (copy)
    --  [7] GuiService (copy)
    --  [8] UserInputService (copy)

    local t_2 = setmetatable({}, t)
    t_2.controllers = {}
    t_2.activeControlModule = nil
    t_2.activeController = nil
    t_2.touchJumpController = nil
    t_2.moveFunction = Players.LocalPlayer.Move
    t_2.humanoid = nil
    t_2.controlsEnabled = true
    t_2.humanoidSeatedConn = nil
    t_2.vehicleController = nil
    t_2.touchControlFrame = nil
    t_2.currentTorsoAngle = 0
    t_2.inputMoveVector = Vector3.new(0, 0, 0)
    t_2.vehicleController = VehicleController_m.new(Value)
    Players.LocalPlayer.CharacterAdded:Connect(function(character: Model) -- line: 117
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:OnCharacterAdded(character)
    end)
    Players.LocalPlayer.CharacterRemoving:Connect(function(character_1: Model) -- line: 118
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:OnCharacterRemoving(character_1)
    end)

    if Players.LocalPlayer.Character then
        t_2:OnCharacterAdded(Players.LocalPlayer.Character)
    end

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(
        arg3
    ) -- line: 123
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:OnRenderStepped(arg3)
    end)
    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- line: 127
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:UpdateMovementMode()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- line: 130
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:UpdateMovementMode()
    end)
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- line: 134
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:UpdateMovementMode()
    end)
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- line: 137
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:UpdateMovementMode()
    end)
    t_2.playerGui = nil
    t_2.touchGui = nil
    t_2.playerGuiAddedConn = nil
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- line: 146
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:UpdateMovementMode()
        t_2:UpdateActiveControlModuleEnabled()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 151
        -- upvalues:
        --  [1] t_2 (copy)

        t_2:UpdateMovementMode()
    end)
    t_2.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if not t_2.playerGui then
        t_2.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(child: Instance) -- line: 157
            -- upvalues:
            --  [1] t_2 (copy)

            if child:IsA("PlayerGui") then
                t_2.playerGui = child
                t_2.playerGuiAddedConn:Disconnect()
                t_2.playerGuiAddedConn = nil
                t_2:UpdateMovementMode()
            end
        end)
    end

    t_2:UpdateMovementMode()

    return t_2
end

function t.GetMoveVector(arg5) -- line: 175
    if arg5.activeController then
        return arg5.activeController:GetMoveVector()
    end

    return Vector3.new(0, 0, 0)
end

local _ = function(arg6) --[[ NormalizeAngle ]] -- line: 182
    arg6 = (arg6 + 12.566370614359172) % 6.283185307179586
    arg6 = if not (arg6 > 3.141592653589793) then arg6 else arg6 - 6.283185307179586

    return arg6
end

local _ = function(arg7, arg8) --[[ AverageAngle ]] -- line: 190
    local v9 = (arg8 - arg7 + 12.566370614359172) % 6.283185307179586
    v9 = if not (v9 > 3.141592653589793) then v9 else v9 - 6.283185307179586
    local v10 = (arg7 + v9 / 2 + 12.566370614359172) % 6.283185307179586
    v10 = if not (v10 > 3.141592653589793) then v10 else v10 - 6.283185307179586

    return v10
end

function t.GetEstimatedVRTorsoFrame(arg9) -- line: 195
    -- upvalues:
    --  [1] VRService (copy)

    local v11 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
    local _, v13, _ = v11:ToEulerAnglesYXZ()
    v13 = -v13

    if
        not VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
        or not VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
    then
        arg9.currentTorsoAngle = v13
    else
        local v15 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
        local v16 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
        local v17 = v11.Position - v15.Position
        local v18 = v11.Position - v16.Position
        local v19 = -math.atan2(v17.X, v17.Z)
        local v20 = (-math.atan2(v18.X, v18.Z) - v19 + 12.566370614359172) % 6.283185307179586

        if v20 > 3.141592653589793 then
            v20 -= 6.283185307179586
        end

        local v21 = (v19 + v20 / 2 + 12.566370614359172) % 6.283185307179586
        v21 = if not (v21 > 3.141592653589793) then v21 else v21 - 6.283185307179586
        local v22 = (v13 - arg9.currentTorsoAngle + 12.566370614359172) % 6.283185307179586
        v22 = if not (v22 > 3.141592653589793) then v22 else v22 - 6.283185307179586
        local v23 = (v21 - arg9.currentTorsoAngle + 12.566370614359172) % 6.283185307179586

        if v23 > 3.141592653589793 then
            v23 -= 6.283185307179586
        end

        v21 = v23 > -1.5707963267948966 and v23 < 1.5707963267948966

        if not v21 then
            v23 = v22
        end

        v21 = math.min(v23, v22)
        local maximum = math.max(v23, v22)
        v22 = 0

        if v21 > 0 then
            v22 = v21
        elseif maximum < 0 then
            v22 = maximum
        end

        arg9.currentTorsoAngle = v22 + arg9.currentTorsoAngle
    end

    return CFrame.new(v11.Position) * CFrame.fromEulerAnglesYXZ(0, -arg9.currentTorsoAngle, 0)
end

function t.GetActiveController(arg10) -- line: 239
    return arg10.activeController
end

function t.UpdateActiveControlModuleEnabled(arg11) -- line: 244
    -- upvalues:
    --  [1] Players (copy)
    --  [2] UserInputService (copy)
    --  [3] ClickToMoveController_m (copy)
    --  [4] TouchThumbstick_m (copy)
    --  [5] DynamicThumbstick_m (copy)
    --  [6] TouchJump_m (copy)
    --  [7] GuiService (copy)

    local _ = function() -- line: 246
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] Players (ref)

        arg11.activeController:Enable(false)

        if arg11.touchJumpController then
            arg11.touchJumpController:Enable(false)
        end

        if arg11.moveFunction then
            arg11.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end
    end

    if not arg11.activeController then
        return
    end

    if not arg11.controlsEnabled then
        arg11.activeController:Enable(false)

        if arg11.touchJumpController then
            arg11.touchJumpController:Enable(false)
        end

        if arg11.moveFunction then
            arg11.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end

        return
    end

    if
        not GuiService.TouchControlsEnabled
        and UserInputService.PreferredInput == Enum.PreferredInput.Touch
        and (arg11.activeControlModule == ClickToMoveController_m or arg11.activeControlModule == TouchThumbstick_m or arg11.activeControlModule == DynamicThumbstick_m)
    then
        arg11.activeController:Enable(false)

        if arg11.touchJumpController then
            arg11.touchJumpController:Enable(false)
        end

        if arg11.moveFunction then
            arg11.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true)
        end

        return
    end

    (function() -- line: 257
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] UserInputService (ref)
        --  [3] ClickToMoveController_m (ref)
        --  [4] TouchThumbstick_m (ref)
        --  [5] DynamicThumbstick_m (ref)
        --  [6] TouchJump_m (ref)
        --  [7] Players (ref)

        if
            arg11.touchControlFrame
            and UserInputService.PreferredInput == Enum.PreferredInput.Touch
            and (arg11.activeControlModule == ClickToMoveController_m or arg11.activeControlModule == TouchThumbstick_m or arg11.activeControlModule == DynamicThumbstick_m)
        then
            if not arg11.controllers[TouchJump_m] then
                arg11.controllers[TouchJump_m] = TouchJump_m.new()
            end

            arg11.touchJumpController = arg11.controllers[TouchJump_m]
            arg11.touchJumpController:Enable(true, arg11.touchControlFrame)
        elseif arg11.touchJumpController then
            arg11.touchJumpController:Enable(false)
        end

        if arg11.activeControlModule == ClickToMoveController_m then
            arg11.activeController:Enable(
                true,
                Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice,
                arg11.touchJumpController
            )

            return
        end

        if arg11.touchControlFrame then
            arg11.activeController:Enable(true, arg11.touchControlFrame)

            return
        end

        arg11.activeController:Enable(true)
    end)()
end

function t.Enable(t1: table, b1: boolean?) -- line: 315
    if b1 == nil then
        b1 = true
    end

    if t1.controlsEnabled == b1 then
        return
    end

    t1.controlsEnabled = b1

    if not t1.activeController then
        return
    end

    t1:UpdateActiveControlModuleEnabled()
end

function t.Disable(arg12) -- line: 330
    arg12:Enable(false)
end

local v27 = Success_1 and Result_1

function t.SelectComputerMovementModule(_) -- line: 336
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] Players (copy)
    --  [3] v27 (ref)
    --  [4] Gamepad_m (copy)
    --  [5] Keyboard_m (copy)
    --  [6] UserGameSettings (copy)
    --  [7] ClickToMoveController_m (copy)
    --  [8] t_1 (copy)

    if not UserInputService.KeyboardEnabled and not UserInputService.GamepadEnabled then
        return nil, false
    end

    local v28 = nil
    local DevComputerMovementMode_1 = Players.LocalPlayer.DevComputerMovementMode

    if DevComputerMovementMode_1 == Enum.DevComputerMovementMode.UserChoice then
        local v29 = false

        if v27 then
            pcall(function() -- line: 347
                -- upvalues:
                --  [1] v29 (ref)
                --  [2] UserInputService (ref)

                v29 = UserInputService.PreferredInput == Enum.PreferredInput.MicroGamepad
            end)
        end

        v28 = if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then Gamepad_m else if not v29 then if UserInputService.PreferredInput ~= Enum.PreferredInput.KeyboardAndMouse then v28 else Keyboard_m else Gamepad_m

        if
            UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
            and v28 == Keyboard_m
        then
            v28 = ClickToMoveController_m
        end
    else
        v28 = t_1[DevComputerMovementMode_1]
        local DevComputerMovementMode_Scriptable = Enum.DevComputerMovementMode.Scriptable

        if not v28 and DevComputerMovementMode_1 ~= DevComputerMovementMode_Scriptable then
            warn(
                "No character control module is associated with DevComputerMovementMode ",
                DevComputerMovementMode_1
            )
        end
    end

    if v28 then
        return v28, true
    end

    if DevComputerMovementMode_1 == Enum.DevComputerMovementMode.Scriptable then
        return nil, true
    end

    return nil, false
end

function t.SelectTouchModule(_) -- line: 385
    -- upvalues:
    --  [1] Players (copy)
    --  [2] t_1 (copy)
    --  [3] UserGameSettings (copy)

    local DevTouchMovementMode_1 = Players.LocalPlayer.DevTouchMovementMode
    local v35

    if DevTouchMovementMode_1 == Enum.DevTouchMovementMode.UserChoice then
        v35 = t_1[UserGameSettings.TouchMovementMode]
    else
        if DevTouchMovementMode_1 == Enum.DevTouchMovementMode.Scriptable then
            return nil, true
        end

        v35 = t_1[DevTouchMovementMode_1]
    end

    return v35, true
end

local function getGamepadRightThumbstickPosition() -- line: 398
    -- upvalues:
    --  [1] UserInputService (copy)

    for _, val in pairs((UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1))) do
        if val.KeyCode == Enum.KeyCode.Thumbstick2 then
            return val.Position
        end
    end

    return Vector3.new(0, 0, 0)
end

function t.calculateRawMoveVector(t2: table, u1: userdata, vec1: Vector3) -- line: 408
    -- upvalues:
    --  [1] Workspace (copy)
    --  [2] VRService (copy)
    --  [3] getGamepadRightThumbstickPosition (copy)

    local CurrentCamera = Workspace.CurrentCamera

    if not CurrentCamera then
        return vec1
    end

    local v36 = CurrentCamera.CFrame

    if VRService.VREnabled and u1.RootPart then
        local _ = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local v38 = t2:GetEstimatedVRTorsoFrame()

        if (CurrentCamera.Focus.Position - v36.Position).Magnitude < 3 then
            v36 *= v38
        else
            v36 = CurrentCamera.CFrame * (v38.Rotation + v38.Position * CurrentCamera.HeadScale)
        end
    end

    if u1:GetState() == Enum.HumanoidStateType.Swimming then
        if VRService.VREnabled then
            vec1 = Vector3.new(vec1.X, 0, vec1.Z)

            if vec1.Magnitude < 0.01 then
                return Vector3.new(0, 0, 0)
            end

            local v39 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636
            local angle = math.atan2(-vec1.X, -vec1.Z)
            local _, v41, _ = v36:ToEulerAnglesYXZ()

            return CFrame.fromEulerAnglesYXZ(v39, angle + v41, 0).LookVector
        else
            return v36:VectorToWorldSpace(vec1)
        end
    else
        local _, _, _, v47, v48, v49, _, _, v52, _, _, v55 = v36:GetComponents()
        local v56, v57

        if v52 < 1 and v52 > -1 then
            v56 = v55
            v57 = v49
        else
            v56 = v47
            v57 = -v48 * math.sign(v52)
        end

        local squareRoot = math.sqrt(v56 * v56 + v57 * v57)

        return (Vector3.new(
            (v56 * vec1.X + v57 * vec1.Z) / squareRoot,
            0,
            (v56 * vec1.Z - v57 * vec1.X) / squareRoot
        ))
    end
end

function t.OnRenderStepped(arg15, arg16) -- line: 467
    -- upvalues:
    --  [1] Gamepad_m (copy)
    --  [2] VRService (copy)
    --  [3] Players (copy)

    if arg15.activeController and arg15.activeController.enabled and arg15.humanoid then
        local v59 = arg15.activeController:GetMoveVector()
        local v60 = arg15.activeController:IsMoveVectorCameraRelative()
        local v61 = arg15:GetClickToMoveController()

        if arg15.activeController == v61 then
            v61:OnRenderStepped(arg16)
        elseif v59.magnitude > 0 then
            v61:CleanupPath()
        else
            v61:OnRenderStepped(arg16)
            v59 = v61:GetMoveVector()
            v60 = v61:IsMoveVectorCameraRelative()
        end

        if arg15.vehicleController then
            local VehicleController = arg15.vehicleController
            local v62 = arg15.activeControlModule == Gamepad_m
            local _
            VehicleController, _ = VehicleController:Update(v59, v60, v62)
            v59 = VehicleController
        end

        if v60 then
            v59 = arg15:calculateRawMoveVector(arg15.humanoid, v59)
        end

        arg15.inputMoveVector = v59

        if VRService.VREnabled then
            v59 = arg15:updateVRMoveVector(v59)
        end

        arg15.moveFunction(Players.LocalPlayer, v59, false)
        local Humanoid = arg15.humanoid
        Humanoid.Jump = arg15.activeController:GetIsJumping() or arg15.touchJumpController and arg15.touchJumpController:GetIsJumping()
    end
end

function t.updateVRMoveVector(arg17, arg18) -- line: 516
    -- upvalues:
    --  [1] VRService (copy)

    local CurrentCamera_1 = workspace.CurrentCamera
    local v65 = (CurrentCamera_1.Focus.Position - CurrentCamera_1.CFrame.Position).Magnitude < 5 and true

    if
        arg18.Magnitude == 0
        and v65
        and VRService.AvatarGestures
        and arg17.humanoid
        and not arg17.humanoid.Sit
    then
        local v66 = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local v67 = CurrentCamera_1.CFrame * (v66.Rotation + v66.Position * CurrentCamera_1.HeadScale)
        local v68 = (v67 * CFrame.new(0, -0.7 * arg17.humanoid.RootPart.Size.Y / 2, 0)).Position - arg17.humanoid.RootPart.CFrame.Position

        return (Vector3.new(v68.x, 0, v68.z))
    end

    return arg18
end

function t.OnHumanoidSeated(t3: table, b2: boolean, u2: userdata) -- line: 541
    -- upvalues:
    --  [1] Value (copy)

    if b2 then
        if u2 and u2:IsA("VehicleSeat") then
            if not t3.vehicleController then
                t3.vehicleController = t3.vehicleController.new(Value)
            end

            t3.vehicleController:Enable(true, u2)

            return
        end
    elseif t3.vehicleController then
        t3.vehicleController:Enable(false, u2)
    end
end

function t.OnCharacterAdded(arg19, arg20) -- line: 556
    arg19.humanoid = arg20:FindFirstChildOfClass("Humanoid")

    while true do
        if arg19.humanoid then
            break
        end

        arg20.ChildAdded:wait()
        arg19.humanoid = arg20:FindFirstChildOfClass("Humanoid")
    end

    if arg19.humanoidSeatedConn then
        arg19.humanoidSeatedConn:Disconnect()
        arg19.humanoidSeatedConn = nil
    end

    arg19.humanoidSeatedConn = arg19.humanoid.Seated:Connect(function(
        active: boolean,
        currentSeatPart: BasePart
    ) -- line: 567
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:OnHumanoidSeated(active, currentSeatPart)
    end)
    arg19:UpdateMovementMode()
end

function t.OnCharacterRemoving(arg23, _) -- line: 574
    arg23.humanoid = nil
    arg23:UpdateMovementMode()
end

function t.UpdateTouchGuiVisibility(arg25) -- line: 580
    -- upvalues:
    --  [1] GuiService (copy)
    --  [2] UserInputService (copy)

    local v69 = arg25.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch

    if v69 and not arg25.touchGui then
        arg25:CreateTouchGuiContainer()
    end

    if arg25.touchGui then
        arg25.touchGui.Enabled = not (not v69)
    end
end

function t.SwitchToController(arg26, arg27) -- line: 599
    -- upvalues:
    --  [1] Value (copy)

    if not arg27 then
        if arg26.activeController then
            arg26.activeController:Enable(false)
        end

        arg26.activeController = nil
        arg26.activeControlModule = nil

        return
    end

    if not arg26.controllers[arg27] then
        arg26.controllers[arg27] = arg27.new(Value)
    end

    if arg26.activeController ~= arg26.controllers[arg27] then
        if arg26.activeController then
            arg26.activeController:Enable(false)
        end

        arg26.activeController = arg26.controllers[arg27]
        arg26.activeControlModule = arg27
        arg26:UpdateActiveControlModuleEnabled()
    end
end

function t.UpdateMovementMode(arg28) -- line: 638
    -- upvalues:
    --  [1] UserInputService (copy)

    arg28:UpdateTouchGuiVisibility()

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v70, v71 = arg28:SelectTouchModule()

        if v71 and arg28.touchControlFrame then
            arg28:SwitchToController(v70)

            return
        end
    else
        arg28:SwitchToController((arg28:SelectComputerMovementModule()))
    end
end

function t.CreateTouchGuiContainer(arg29) -- line: 654
    -- upvalues:
    --  [1] v4 (ref)

    if not arg29.playerGui then
        return
    end

    if arg29.touchGui then
        arg29.touchGui:Destroy()
    end

    arg29.touchGui = Instance.new("ScreenGui")
    arg29.touchGui.Name = "TouchGui"
    arg29.touchGui.ResetOnSpawn = false
    arg29.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if v4 then
        arg29.touchGui.ClipToDeviceSafeArea = false
    end

    arg29.touchControlFrame = Instance.new("Frame")
    arg29.touchControlFrame.Name = "TouchControlFrame"
    arg29.touchControlFrame.Size = UDim2.new(1, 0, 1, 0)
    arg29.touchControlFrame.BackgroundTransparency = 1
    arg29.touchControlFrame.Parent = arg29.touchGui
    arg29.touchGui.Parent = arg29.playerGui
end

function t.GetClickToMoveController(arg30) -- line: 680
    -- upvalues:
    --  [1] ClickToMoveController_m (copy)
    --  [2] Value (copy)

    if not arg30.controllers[ClickToMoveController_m] then
        arg30.controllers[ClickToMoveController_m] = ClickToMoveController_m.new(Value)
    end

    return arg30.controllers[ClickToMoveController_m]
end

return t.new()
