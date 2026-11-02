local t = {}
t.__index = t
local t_1 = {
    "CameraMinZoomDistance",
    "CameraMaxZoomDistance",
    "CameraMode",
    "DevCameraOcclusionMode",
    "DevComputerCameraMode",
    "DevTouchCameraMode",
    "DevComputerMovementMode",
    "DevTouchMovementMode",
    "DevEnableMouseLock"
}
local t_2 = {
    "ComputerCameraMovementMode",
    "ComputerMovementMode",
    "ControlMode",
    "GamepadCameraSensitivity",
    "MouseSensitivity",
    "RotationType",
    "TouchCameraMovementMode",
    "TouchMovementMode"
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VRService = game:GetService("VRService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local CommonUtils = script.Parent:WaitForChild("CommonUtils")
local ConnectionUtil_m = require(CommonUtils:WaitForChild("ConnectionUtil"))
local FlagUtil_m = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraUtils_m = require(script:WaitForChild("CameraUtils"))
local CameraInput_m = require(script:WaitForChild("CameraInput"))
local ClassicCamera_m = require(script:WaitForChild("ClassicCamera"))
local OrbitalCamera_m = require(script:WaitForChild("OrbitalCamera"))
local LegacyCamera_m = require(script:WaitForChild("LegacyCamera"))
local VehicleCamera_m = require(script:WaitForChild("VehicleCamera"))
local VRCamera_m = require(script:WaitForChild("VRCamera"))
local VRVehicleCamera_m = require(script:WaitForChild("VRVehicleCamera"))
local Invisicam_m = require(script:WaitForChild("Invisicam"))
local Poppercam_m = require(script:WaitForChild("Poppercam"))
local TransparencyController_m = require(script:WaitForChild("TransparencyController"))
local MouseLockController_m = require(script:WaitForChild("MouseLockController"))

if not Players.LocalPlayer then
    return {}
end

local t_3 = {}
local t_4 = {}
assert(Players.LocalPlayer, "Strict typing check")
local PlayerScripts = Players.LocalPlayer:WaitForChild("PlayerScripts")
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Default)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Follow)
PlayerScripts:RegisterTouchCameraMovementMode(Enum.TouchCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Default)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Follow)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.Classic)
PlayerScripts:RegisterComputerCameraMovementMode(Enum.ComputerCameraMovementMode.CameraToggle)
local UserPlayerConnectionMemoryLeak = FlagUtil_m.getUserFlag("UserPlayerConnectionMemoryLeak")
local UserPSFixCameraControllerReset = FlagUtil_m.getUserFlag("UserPSFixCameraControllerReset")

function t.new() -- line: 144
    -- upvalues:
    --  [1] TransparencyController_m (copy)
    --  [2] UserPlayerConnectionMemoryLeak (copy)
    --  [3] ConnectionUtil_m (copy)
    --  [4] t (copy)
    --  [5] Players (copy)
    --  [6] MouseLockController_m (copy)
    --  [7] RunService (copy)
    --  [8] t_1 (copy)
    --  [9] t_2 (copy)
    --  [10] UserGameSettings (copy)
    --  [11] UserInputService (copy)

    local t_6 = setmetatable(
        {
            activeTransparencyController = TransparencyController_m.new(),
            connectionUtil = if not UserPlayerConnectionMemoryLeak then nil else ConnectionUtil_m.new()
        },
        t
    )
    t_6.activeCameraController = nil
    t_6.activeOcclusionModule = nil
    t_6.activeMouseLockController = nil
    t_6.currentComputerCameraMovementMode = nil
    t_6.cameraSubjectChangedConn = nil
    t_6.cameraTypeChangedConn = nil

    for _, val in pairs(Players:GetPlayers()) do
        t_6:OnPlayerAdded(val)
    end

    Players.PlayerAdded:Connect(function(player: Player) -- line: 167
        -- upvalues:
        --  [1] t_6 (copy)

        t_6:OnPlayerAdded(player)
    end)

    if UserPlayerConnectionMemoryLeak then
        Players.PlayerRemoving:Connect(function(arg2) -- line: 172
            -- upvalues:
            --  [1] t_6 (copy)

            t_6:OnPlayerRemoving(arg2)
        end)
    end

    t_6.activeTransparencyController:Enable(true)
    t_6.activeMouseLockController = MouseLockController_m.new()
    assert(t_6.activeMouseLockController, "Strict typing check")
    local v17 = t_6.activeMouseLockController:GetBindableToggleEvent()

    if v17 then
        v17:Connect(function() -- line: 184
            -- upvalues:
            --  [1] t_6 (copy)

            t_6:OnMouseLockToggled()
        end)
    end

    t_6:ActivateCameraController()
    t_6:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)
    t_6:OnCurrentCameraChanged()
    RunService:BindToRenderStep("cameraRenderUpdate", Enum.RenderPriority.Camera.Value, function(
        arg3
    ) -- line: 192
        -- upvalues:
        --  [1] t_6 (copy)

        t_6:Update(arg3)
    end)

    for _, val_1 in pairs(t_1) do
        Players.LocalPlayer:GetPropertyChangedSignal(val_1):Connect(function() -- line: 196
            -- upvalues:
            --  [1] t_6 (copy)
            --  [2] val_1 (copy)

            t_6:OnLocalPlayerCameraPropertyChanged(val_1)
        end)
    end

    for _, val_2 in pairs(t_2) do
        UserGameSettings:GetPropertyChangedSignal(val_2):Connect(function() -- line: 202
            -- upvalues:
            --  [1] t_6 (copy)
            --  [2] val_2 (copy)

            t_6:OnUserGameSettingsPropertyChanged(val_2)
        end)
    end

    game.Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 206
        -- upvalues:
        --  [1] t_6 (copy)

        t_6:OnCurrentCameraChanged()
    end)
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 209
        -- upvalues:
        --  [1] t_6 (copy)

        t_6:OnPreferredInputChanged()
    end)

    return t_6
end

function t.GetCameraMovementModeFromSettings(_) -- line: 216
    -- upvalues:
    --  [1] Players (copy)
    --  [2] CameraUtils_m (copy)
    --  [3] UserInputService (copy)
    --  [4] UserGameSettings (copy)

    if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        return CameraUtils_m.ConvertCameraModeEnumToStandard(
            Enum.ComputerCameraMovementMode.Classic
        )
    end

    local v18, v19

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        v18 = CameraUtils_m.ConvertCameraModeEnumToStandard(Players.LocalPlayer.DevTouchCameraMode)
        v19 = CameraUtils_m.ConvertCameraModeEnumToStandard(
            UserGameSettings.TouchCameraMovementMode
        )
    else
        v18 = CameraUtils_m.ConvertCameraModeEnumToStandard(
            Players.LocalPlayer.DevComputerCameraMode
        )
        v19 = CameraUtils_m.ConvertCameraModeEnumToStandard(
            UserGameSettings.ComputerCameraMovementMode
        )
    end

    if v18 == Enum.DevComputerCameraMovementMode.UserChoice then
        return v19
    end

    return v18
end

function t.ActivateOcclusionModule(arg5, arg6) -- line: 241
    -- upvalues:
    --  [1] Poppercam_m (copy)
    --  [2] Invisicam_m (copy)
    --  [3] t_4 (copy)
    --  [4] Players (copy)

    local v20

    if arg6 == Enum.DevCameraOcclusionMode.Zoom then
        v20 = Poppercam_m
    elseif arg6 == Enum.DevCameraOcclusionMode.Invisicam then
        v20 = Invisicam_m
    else
        warn("CameraScript ActivateOcclusionModule called with unsupported mode")

        return
    end

    arg5.occlusionMode = arg6

    if arg5.activeOcclusionModule and arg5.activeOcclusionModule:GetOcclusionMode() == arg6 then
        if not arg5.activeOcclusionModule:GetEnabled() then
            arg5.activeOcclusionModule:Enable(true)
        end

        return
    end

    local ActiveOcclusionModule = arg5.activeOcclusionModule
    arg5.activeOcclusionModule = t_4[v20]

    if not arg5.activeOcclusionModule then
        arg5.activeOcclusionModule = v20.new()

        if arg5.activeOcclusionModule then
            t_4[v20] = arg5.activeOcclusionModule
        end
    end

    if arg5.activeOcclusionModule then
        if arg5.activeOcclusionModule:GetOcclusionMode() ~= arg6 then
            warn(
                "CameraScript ActivateOcclusionModule mismatch: ",
                arg5.activeOcclusionModule:GetOcclusionMode(),
                "~=",
                arg6
            )
        end

        if ActiveOcclusionModule then
            if ActiveOcclusionModule ~= arg5.activeOcclusionModule then
                ActiveOcclusionModule:Enable(false)
            else
                warn(
                    "CameraScript ActivateOcclusionModule failure to detect already running correct module"
                )
            end
        end

        if arg6 == Enum.DevCameraOcclusionMode.Invisicam then
            if Players.LocalPlayer.Character then
                arg5.activeOcclusionModule:CharacterAdded(
                    Players.LocalPlayer.Character,
                    Players.LocalPlayer
                )
            end
        else
            for _, val_3 in pairs(Players:GetPlayers()) do
                if val_3 and val_3.Character then
                    arg5.activeOcclusionModule:CharacterAdded(val_3.Character, val_3)
                end
            end

            arg5.activeOcclusionModule:OnCameraSubjectChanged(
                game.Workspace.CurrentCamera.CameraSubject
            )
        end

        arg5.activeOcclusionModule:Enable(true)
    end
end

function t.ShouldUseVehicleCamera(arg7) -- line: 320
    local v22 = workspace.CurrentCamera

    if not v22 then
        return false
    end

    local v23 = v22.CameraType
    local v24 = v22.CameraSubject
    v22 = v23 == Enum.CameraType.Custom or v23 == Enum.CameraType.Follow
    v23 = v24 and v24:IsA("VehicleSeat") or false
    v24 = arg7.occlusionMode ~= Enum.DevCameraOcclusionMode.Invisicam

    return v23 and v22 and v24
end

function t.ActivateCameraController(arg8) -- line: 336
    -- upvalues:
    --  [1] LegacyCamera_m (copy)
    --  [2] VRService (copy)
    --  [3] VRCamera_m (copy)
    --  [4] ClassicCamera_m (copy)
    --  [5] OrbitalCamera_m (copy)
    --  [6] VRVehicleCamera_m (copy)
    --  [7] VehicleCamera_m (copy)
    --  [8] t_3 (copy)
    --  [9] UserPSFixCameraControllerReset (copy)

    local CameraType: userdata = workspace.CurrentCamera.CameraType
    local v26 = arg8:GetCameraMovementModeFromSettings()
    local v27 = nil

    if CameraType == Enum.CameraType.Scriptable then
        if arg8.activeCameraController then
            arg8.activeCameraController:Enable(false)
            arg8.activeCameraController = nil
        end

        return
    end

    if CameraType == Enum.CameraType.Custom then
        v26 = arg8:GetCameraMovementModeFromSettings()
    elseif CameraType == Enum.CameraType.Track then
        v26 = Enum.ComputerCameraMovementMode.Classic
    elseif CameraType == Enum.CameraType.Follow then
        v26 = Enum.ComputerCameraMovementMode.Follow
    elseif CameraType == Enum.CameraType.Orbital then
        v26 = Enum.ComputerCameraMovementMode.Orbital
    elseif
        CameraType == Enum.CameraType.Attach
        or CameraType == Enum.CameraType.Watch
        or CameraType == Enum.CameraType.Fixed
    then
        v27 = LegacyCamera_m
    else
        warn("CameraScript encountered an unhandled Camera.CameraType value: ", CameraType)
    end

    if not v27 then
        if VRService.VREnabled then
            v27 = VRCamera_m
        elseif
            v26 == Enum.ComputerCameraMovementMode.Classic
            or v26 == Enum.ComputerCameraMovementMode.Follow
            or v26 == Enum.ComputerCameraMovementMode.Default
            or v26 == Enum.ComputerCameraMovementMode.CameraToggle
        then
            v27 = ClassicCamera_m
        elseif v26 == Enum.ComputerCameraMovementMode.Orbital then
            v27 = OrbitalCamera_m
        else
            warn("ActivateCameraController did not select a module.")

            return
        end
    end

    if arg8:ShouldUseVehicleCamera() then
        v27 = if not VRService.VREnabled then VehicleCamera_m else VRVehicleCamera_m
    end

    local v28

    if not t_3[v27] then
        v28 = v27.new()
        t_3[v27] = v28
    else
        v28 = t_3[v27]

        if UserPSFixCameraControllerReset then
            if v28.Reset and arg8.activeCameraController ~= v28 then
                v28:Reset()
            end
        elseif v28.Reset then
            v28:Reset()
        end
    end

    if arg8.activeCameraController then
        if arg8.activeCameraController ~= v28 then
            if v28.HandleSubjectDistance then
                v28:HandleSubjectDistance(arg8.activeCameraController)
            end

            arg8.activeCameraController:Enable(false)
            arg8.activeCameraController = v28
            arg8.activeCameraController:Enable(true)
        elseif not arg8.activeCameraController:GetEnabled() then
            arg8.activeCameraController:Enable(true)
        end
    elseif v28 ~= nil then
        arg8.activeCameraController = v28
        assert(arg8.activeCameraController, "Strict typing check")
        arg8.activeCameraController:Enable(true)
    end

    if arg8.activeCameraController then
        arg8.activeCameraController:SetCameraMovementMode(v26)
        arg8.activeCameraController:SetCameraType(CameraType)
    end
end

function t.OnCameraSubjectChanged(arg9) -- line: 445
    local CurrentCamera_1 = workspace.CurrentCamera
    local v29 = if not CurrentCamera_1 then nil else CurrentCamera_1.CameraSubject

    if arg9.activeTransparencyController then
        arg9.activeTransparencyController:SetSubject(v29)
    end

    if arg9.activeOcclusionModule then
        arg9.activeOcclusionModule:OnCameraSubjectChanged(v29)
    end

    arg9:ActivateCameraController()
end

function t.OnCameraTypeChanged(arg10, arg11) -- line: 460
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] CameraUtils_m (copy)

    if
        arg11 == Enum.CameraType.Scriptable
        and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
    then
        CameraUtils_m.restoreMouseBehavior()
    end

    arg10:ActivateCameraController()
end

function t.OnCurrentCameraChanged(arg12) -- line: 472
    local CurrentCamera_2 = game.Workspace.CurrentCamera

    if not CurrentCamera_2 then
        return
    end

    if arg12.cameraSubjectChangedConn then
        arg12.cameraSubjectChangedConn:Disconnect()
    end

    if arg12.cameraTypeChangedConn then
        arg12.cameraTypeChangedConn:Disconnect()
    end

    arg12.cameraSubjectChangedConn = CurrentCamera_2:GetPropertyChangedSignal("CameraSubject"):Connect(
        function() -- line: 484
            -- upvalues:
            --  [1] arg12 (copy)

            arg12:OnCameraSubjectChanged()
        end
    )
    arg12.cameraTypeChangedConn = CurrentCamera_2:GetPropertyChangedSignal("CameraType"):Connect(
        function() -- line: 488
            -- upvalues:
            --  [1] arg12 (copy)
            --  [2] CurrentCamera_2 (copy)

            arg12:OnCameraTypeChanged(CurrentCamera_2.CameraType)
        end
    )
    arg12:OnCameraSubjectChanged()
    arg12:OnCameraTypeChanged(CurrentCamera_2.CameraType)
end

function t.OnLocalPlayerCameraPropertyChanged(t1: table, s1: string) -- line: 496
    -- upvalues:
    --  [1] Players (copy)

    if s1 == "CameraMode" then
        if Players.LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
            if
                not t1.activeCameraController
                or t1.activeCameraController:GetModuleName() ~= "ClassicCamera"
            then
                t1:ActivateCameraController()
            end

            if t1.activeCameraController then
                t1.activeCameraController:UpdateForDistancePropertyChange()

                return
            end
        else
            if Players.LocalPlayer.CameraMode == Enum.CameraMode.Classic then
                t1:ActivateCameraController()

                return
            end

            warn("Unhandled value for property player.CameraMode: ", Players.LocalPlayer.CameraMode)

            return
        end
    else
        if s1 == "DevComputerCameraMode" or s1 == "DevTouchCameraMode" then
            t1:ActivateCameraController()

            return
        end

        if s1 == "DevCameraOcclusionMode" then
            t1:ActivateOcclusionModule(Players.LocalPlayer.DevCameraOcclusionMode)

            return
        end

        if s1 == "CameraMinZoomDistance" or s1 == "CameraMaxZoomDistance" then
            if t1.activeCameraController then
                t1.activeCameraController:UpdateForDistancePropertyChange()

                return
            end
        else
            if s1 == "DevTouchMovementMode" or s1 == "DevComputerMovementMode" then
                return
            end

            if s1 == "DevEnableMouseLock" then
            end
        end
    end
end

function t.OnUserGameSettingsPropertyChanged(t2: table, s2: string) -- line: 538
    if s2 == "ComputerCameraMovementMode" or s2 == "TouchCameraMovementMode" then
        t2:ActivateCameraController()
    end
end

function t.OnPreferredInputChanged(arg13) -- line: 544
    arg13:ActivateCameraController()
end

function t.Update(arg14, arg15) -- line: 554
    -- upvalues:
    --  [1] CameraInput_m (copy)

    if arg14.activeCameraController then
        arg14.activeCameraController:UpdateMouseBehavior()
        local v30, v31 = arg14.activeCameraController:Update(arg15)

        if arg14.activeOcclusionModule and not arg14.activeCameraController.skipOcclusion then
            local v32, v33 = arg14.activeOcclusionModule:Update(arg15, v30, v31)
            v30 = v32
            v31 = v33
        end

        local CurrentCamera_3 = game.Workspace.CurrentCamera
        CurrentCamera_3.CFrame = v30
        CurrentCamera_3.Focus = v31

        if arg14.activeTransparencyController then
            arg14.activeTransparencyController:Update(arg15)
        end

        if CameraInput_m.getInputEnabled() then
            CameraInput_m.resetInputForFrameEnd()
        end
    end
end

function t.OnCharacterAdded(t3: table, u1: userdata, u2: userdata) -- line: 580
    if t3.activeOcclusionModule then
        t3.activeOcclusionModule:CharacterAdded(u1, u2)
    end
end

function t.OnCharacterRemoving(arg16, arg17, arg18) -- line: 586
    if arg16.activeOcclusionModule then
        arg16.activeOcclusionModule:CharacterRemoving(arg17, arg18)
    end
end

function t.OnPlayerAdded(t4: table, u3: userdata) -- line: 592
    -- upvalues:
    --  [1] UserPlayerConnectionMemoryLeak (copy)

    if UserPlayerConnectionMemoryLeak then
        if t4.connectionUtil then
            t4.connectionUtil:trackConnection(`{u3.UserId}CharacterAdded`, u3.CharacterAdded:Connect(
                function(character: Model) -- line: 596
                    -- upvalues:
                    --  [1] t4 (copy)
                    --  [2] u3 (copy)

                    t4:OnCharacterAdded(character, u3)
                end
            ))
            t4.connectionUtil:trackConnection(`{u3.UserId}CharacterRemoving`, u3.CharacterRemoving:Connect(
                function(character_1: Model) -- line: 599
                    -- upvalues:
                    --  [1] t4 (copy)
                    --  [2] u3 (copy)

                    t4:OnCharacterRemoving(character_1, u3)
                end
            ))

            return
        end
    else
        u3.CharacterAdded:Connect(function(character_2: Model) -- line: 604
            -- upvalues:
            --  [1] t4 (copy)
            --  [2] u3 (copy)

            t4:OnCharacterAdded(character_2, u3)
        end)
        u3.CharacterRemoving:Connect(function(character_3: Model) -- line: 607
            -- upvalues:
            --  [1] t4 (copy)
            --  [2] u3 (copy)

            t4:OnCharacterRemoving(character_3, u3)
        end)
    end
end

function t.OnPlayerRemoving(t5: table, u4: userdata) -- line: 613
    if t5.connectionUtil then
        t5.connectionUtil:disconnect(`{u4.UserId}CharacterAdded`)
        t5.connectionUtil:disconnect(`{u4.UserId}CharacterRemoving`)
    end
end

function t.OnMouseLockToggled(arg23) -- line: 621
    if arg23.activeMouseLockController then
        local v38 = arg23.activeMouseLockController:GetIsMouseLocked()
        local v39 = arg23.activeMouseLockController:GetMouseLockOffset()

        if arg23.activeCameraController then
            arg23.activeCameraController:SetIsMouseLocked(v38)
            arg23.activeCameraController:SetMouseLockOffset(v39)
        end
    end
end

t.new()

return {}
