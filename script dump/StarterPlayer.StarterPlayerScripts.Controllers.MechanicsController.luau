local ContextActionService = game:GetService("ContextActionService")
local _ = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local _ = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local _ = require(ReplicatedStorage.Modules.BetterDebris)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local _ = require(ReplicatedStorage.Modules.ItemLibrary)
local _ = require(ReplicatedStorage.Modules.TestLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local UserInterfaceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local EmoteController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.EmoteController)
local DebugState_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState
)
local t = { "Aim", "Sprint", "Crouch" }
local t_1 = { Aim = false, Sprint = false, Crouch = false }
local t_2 = {}
t_2.__index = t_2

function t_2._new() -- line: 45
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] Signal_m (copy)

    local t_3 = setmetatable({}, t_2)
    t_3.StateChanged = Signal_m.new()
    t_3.SlideStep = Signal_m.new()
    t_3.LocalFighter = nil
    t_3.IsCrouching = false
    t_3.IsSprinting = false
    t_3.IsSliding = false
    t_3.CameraLean = 0
    t_3._internal_local_fighter_added = Signal_m.new()
    t_3._controls_connections = {}
    t_3._crouching_start_time = 0
    t_3._crouching_release_time = 0
    t_3._sprinting_start_time = 0
    t_3._sprinting_release_time = 0
    t_3._sliding_cooldown = 0
    t_3._sliding_start_time = 0
    t_3._sliding_release_time = 0
    t_3._sliding_velocity = nil
    t_3._sliding_last_floor = nil
    t_3._sliding_last_floor_physical_properties = nil
    t_3._update_slide_direction = nil
    t_3._is_input_spamming = {}
    t_3._mobile_input_down = {}
    t_3._is_leaning_right = false
    t_3._is_leaning_left = false
    t_3._original_jump_power = nil
    t_3._jump_hash = 0
    t_3._double_jumps_used = {}
    t_3._auto_shoot_hash = 0
    t_3._auto_shoot_connection = nil
    t_3._scroll_delta = 0.5
    t_3:_Init()

    return t_3
end

function t_2.AreInputsDisabled(arg1) -- line: 90
    -- upvalues:
    --  [1] GamepadService (copy)
    --  [2] GuiService (copy)
    --  [3] ControlsController_m (copy)
    --  [4] Players (copy)
    --  [5] SpectateController_m (copy)

    if
        GamepadService.GamepadCursorEnabled
        or GuiService.SelectedObject
        or arg1.LocalFighter and arg1.LocalFighter:Get("IsHiddenByCutscene")
    then
        return true
    end

    if ControlsController_m.CurrentControls == "Gamepad" then
        local Equipment_m = require(
            Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Equipment
        )

        if
            require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages).PageSystem.CurrentPage
            or Equipment_m.IsOpen
            or SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject.DuelInterface.Voting:IsOpen()
        then
            return true
        end
    end

    return false
end

function t_2.IsAlive(arg2) -- line: 111
    local v1 = arg2.LocalFighter

    if v1 then
        v1 = arg2.LocalFighter:IsAlive()
    end

    return v1
end

function t_2.IsFrozen(arg3) -- line: 115
    local v2 = arg3.LocalFighter

    if v2 then
        v2 = arg3.LocalFighter.Entity

        if v2 then
            v2 = arg3.LocalFighter.Entity:Get("IsFrozen")
        end
    end

    return v2
end

function t_2.IsInputDown(arg4, arg5) -- line: 120
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] ControlsController_m (copy)
    --  [3] InputLibrary_m (copy)

    local v4 = CameraController_m:GetPublicState() == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse and {
        Enum.UserInputType.MouseButton2
    } or nil

    if ControlsController_m.CurrentControls == "Touch" then
        return (arg4:IsMobileInputDown(arg5))
    end

    return (InputLibrary_m:IsInputDown(arg5, v4))
end

function t_2.IsMobileInputDown(arg6, arg7) -- line: 127
    return arg6._mobile_input_down[arg7]
end

function t_2.GetTimeSince(arg8, arg9, arg10) -- line: 132
    return tick() - arg8["_" .. string.lower(arg9) .. "_" .. string.lower(arg10) .. "_time"]
end

function t_2.SetCameraLean(arg11, arg12) -- line: 137
    arg11.CameraLean = arg12
    arg11.LocalFighter.LocalCameraLean = arg11.CameraLean
    arg11:_UpdateServerState("CameraLean", arg11.CameraLean)
end

function t_2.SetCrouching(arg13, arg14) -- line: 144
    -- upvalues:
    --  [1] ControlsController_m (copy)

    if not arg14 then
        ControlsController_m:ToggleInput("Crouch", false)
    end

    if arg14 == arg13.IsCrouching then
        return
    end

    arg13.IsCrouching = arg14
    arg13.LocalFighter.IsCrouchingLocally = arg13.IsCrouching
    arg13[if arg13.IsCrouching then "_crouching_start_time" else "_crouching_release_time"] = tick()
    arg13:_UpdateServerState("IsCrouching", arg13.IsCrouching)
    arg13.StateChanged:Fire("IsCrouching")
    arg13:_UpdateWalkSpeed()

    if arg13.IsCrouching then
        arg13:SetSprinting(false)
        arg13.LocalFighter.Entity.RootPart.Velocity = Vector3.new(
            arg13.LocalFighter.Entity.RootPart.Velocity.X,
            math.min(0, arg13.LocalFighter.Entity.RootPart.Velocity.Y),
            arg13.LocalFighter.Entity.RootPart.Velocity.Z
        )
    end
end

function t_2.SetSprinting(arg15, arg16) -- line: 168
    if arg16 == arg15.IsSprinting then
        return
    end

    arg15.IsSprinting = arg15.LocalFighter and arg15.LocalFighter:CanSprint() and arg16 or false
    arg15.LocalFighter.IsSprintingLocally = arg15.IsSprinting
    arg15[if arg15.IsSprinting then "_sprinting_start_time" else "_sprinting_release_time"] = tick()
    arg15:_UpdateServerState("IsSprinting", arg15.IsSprinting)
    arg15.StateChanged:Fire("IsSprinting")
    arg15:_UpdateWalkSpeed()

    if arg15.IsSprinting then
        arg15:SetCrouching(false)
    end
end

function t_2.PlayMechanicsSound(arg17, ...) -- line: 186
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg17.LocalFighter then
        return
    end

    ReplicatedStorage.Remotes.Replication.Fighter.PlayMechanicsSound:FireServer(...)

    return arg17.LocalFighter:PlayMechanicsSound(...)
end

function t_2.StopSliding(arg18, arg19) -- line: 196
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if not arg18.IsSliding then
        return
    end

    if arg18._sliding_last_floor then
        arg18._sliding_last_floor.CustomPhysicalProperties = arg18._sliding_last_floor_physical_properties
        arg18._sliding_last_floor = nil
        arg18._sliding_last_floor_physical_properties = nil
    end

    if arg18._sliding_velocity then
        arg18._sliding_velocity:Destroy()
        arg18._sliding_velocity = nil
    end

    arg18._sliding_cooldown = tick() + 0.25
    arg18._update_slide_direction = nil
    arg18.IsSliding = false
    arg18.LocalFighter.IsSlidingLocally = false
    arg18._sliding_release_time = tick()
    arg18:_UpdateServerState("IsSliding", false)
    arg18.StateChanged:Fire("IsSliding")
    arg18:_UpdateWalkSpeed()

    if arg18:IsAlive() then
        arg18.LocalFighter.Entity:StopSlidingAnimation()
        arg18.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)

        if arg19 then
            arg18.LocalFighter.Entity:AirborneTrigger(
                arg18.LocalFighter.Entity.RootPart.Velocity * 0.6 + Vector3.new(
                    0,
                    CONSTANTS_m.BASE_JUMPPOWER * 0.5,
                    0
                ),
                12,
                true
            )
        end

        if arg18:IsInputDown("Sprint") then
            arg18:SetSprinting(true)
        end
    end
end

function t_2.Slide(arg20) -- line: 238
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] RunService (copy)

    if
        arg20.IsSliding
        or tick() < arg20._sliding_cooldown
        or not arg20:IsAlive()
        or arg20.LocalFighter.Entity.Humanoid:GetState() == Enum.HumanoidStateType.Climbing
        or arg20.LocalFighter:AreItemsLocked()
        or not arg20.LocalFighter:CanSlide()
        or arg20:IsFrozen()
    then
        return
    end

    arg20._sliding_cooldown = math.huge
    arg20.IsSliding = true
    arg20.LocalFighter.IsSlidingLocally = true
    arg20._sliding_start_time = tick()
    arg20:_UpdateServerState("IsSliding", true)
    arg20.StateChanged:Fire("IsSliding")
    arg20.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    arg20.LocalFighter.Entity.Humanoid.AutoRotate = false
    arg20.LocalFighter.Entity:AirborneCancel()
    arg20:SetCrouching(false)
    arg20:SetSprinting(false)
    arg20:_UpdateWalkSpeed()
    arg20._sliding_velocity = Instance.new("BodyVelocity")
    arg20._sliding_velocity.Parent = arg20.LocalFighter.Entity.RootPart
    local now_1 = tick()
    local v10 = arg20.LocalFighter.Entity.RootPart.Position.Y
    local v11 = nil
    local v12 = nil
    local v13 = arg20:PlayMechanicsSound("Slide")
    local v14 = tick() + 0.25
    local v15 = 0
    local Rotation = arg20.LocalFighter.Entity.RootPart.CFrame.Rotation
    local v17 = arg20:_GetWalkSpeed(true)

    function arg20._update_slide_direction(arg21) -- line: 271
        -- upvalues:
        --  [1] v12 (ref)
        --  [2] arg20 (copy)

        v12 = arg21 or arg20.LocalFighter:GetMoveVector(
            true,
            true,
            arg20.LocalFighter.Entity.RootPart.CFrame.LookVector
        )
        task.spawn(
            arg20.LocalFighter.Entity.PlaySlidingAnimationAsync,
            arg20.LocalFighter.Entity,
            v12
        )
    end

    arg20._update_slide_direction()

    while true do
        if not arg20:IsAlive() or not arg20.IsSliding or not (tick() < now_1 + 1) then
            break
        end

        local v19 = arg20.LocalFighter:GetFloor()
        local Y = arg20.LocalFighter.Entity.RootPart.Position.Y

        if v19 then
            v11 = nil
        elseif not v11 then
            v11 = tick()
        end

        if Y < v10 - 1 then
            now_1 = tick()
            v10 = Y

            if v13 and v14 < tick() then
                v13.TimePosition = 0
                v13.Volume = 0
            end

            v14 = tick() + 0.25
        else
            v10 = math.max(v10, Y)
        end

        if v13 and v13.Volume == 0 and v19 then
            v13.TimePosition = 0
            v13.Volume = 0.375
        end

        local v20 = v12.Magnitude <= 0.01 and arg20.LocalFighter.Entity.RootPart.CFrame.LookVector or v12.Unit
        local v21 = Vector3.new(0, 1, 0)

        if v19 ~= arg20._sliding_last_floor then
            if arg20._sliding_last_floor then
                arg20._sliding_last_floor.CustomPhysicalProperties = arg20._sliding_last_floor_physical_properties
                arg20._sliding_last_floor = nil
                arg20._sliding_last_floor_physical_properties = nil
            end

            if v19 and not v19:IsA("Terrain") then
                arg20._sliding_last_floor = v19
                arg20._sliding_last_floor_physical_properties = arg20._sliding_last_floor.CurrentPhysicalProperties
            end
        end

        if v19 then
            local Position = arg20.LocalFighter.Entity.RootPart.Position
            local v22 = Position + v20 * 0.1
            local raycastResult = Utility_m:Raycast(
                Position,
                Position + Vector3.new(0, -1, 0),
                999,
                { v19 },
                Enum.RaycastFilterType.Include
            )
            local raycastResult_1 = Utility_m:Raycast(
                v22,
                v22 + Vector3.new(0, -1, 0),
                999,
                { v19 },
                Enum.RaycastFilterType.Include
            )

            if Utility_m:AngleBetweenVectors(
                (raycastResult_1.Position - raycastResult.Position).Unit,
                Vector3.new(-0, -1, -0)
            ) > 0.7853981633974483 then
                v20 = (raycastResult_1.Position - raycastResult.Position).Unit
                v21 = raycastResult_1.Normal or raycastResult.Normal or v21
            end
        end

        if v21.Magnitude < 0.5 then
            arg20.SlideStep:Fire()
        end

        v15 = v19 and (tick() - now_1) / 1 or v15
        local v27 = arg20.LocalFighter:Get("SlidingSpeedMax") or 3
        local v28 = v20 * (v27 + (1 - v27) * v15) * v17
        local v29 = if not v11 then Vector3.new(0, 0, 0) else v21 * -workspace.Gravity * (tick() - v11) ^ 2
        arg20._sliding_velocity.Velocity = v28 + v29
        local v31 = if v11 then 0.1 else 1
        arg20._sliding_velocity.MaxForce = Vector3.new(1, v31, 1) * 100000

        if v28.Magnitude > 0.01 then
            arg20.LocalFighter.Entity.RootPart.CFrame = arg20.LocalFighter.Entity.RootPart.CFrame:Lerp(
                CFrame.new(
                    arg20.LocalFighter.Entity.RootPart.Position,
                    arg20.LocalFighter.Entity.RootPart.Position + v28
                ),
                0.25
            )
            Rotation = arg20.LocalFighter.Entity.RootPart.CFrame.Rotation
        else
            arg20.LocalFighter.Entity.RootPart.CFrame = CFrame.new(
                arg20.LocalFighter.Entity.RootPart.Position
            ) * Rotation
        end

        RunService.RenderStepped:Wait()
    end

    v13:Destroy()

    if arg20.IsSliding then
        arg20:StopSliding()
    end
end

function t_2.Jump(arg22, arg23, arg24, arg25) -- line: 382
    if
        not arg22:IsAlive()
        or arg22:IsFrozen()
        or not arg25 and arg22.LocalFighter.Entity:IsAirborne()
    then
        return
    end

    local v33 = arg22._original_jump_power or arg22.LocalFighter.Entity.Humanoid.JumpPower
    arg22._original_jump_power = v33
    arg22._jump_hash += 1
    local JumpHash = arg22._jump_hash
    local Humanoid = arg22.LocalFighter.Entity.Humanoid
    local v34 = arg23 or arg22._original_jump_power
    Humanoid.JumpPower = v34 * (arg24 or 1)
    arg22.LocalFighter.Entity.Humanoid.Jump = true

    if arg23 or arg24 then
        task.defer(function() -- line: 395
            -- upvalues:
            --  [1] JumpHash (copy)
            --  [2] arg22 (copy)

            if JumpHash ~= arg22._jump_hash or not arg22:IsAlive() then
                return
            end

            arg22.LocalFighter.Entity.Humanoid.JumpPower = arg22._original_jump_power
            arg22._original_jump_power = nil
        end)
    end
end

function t_2.DoubleJump(arg26) -- line: 406
    if not arg26:IsAlive() or arg26:IsFrozen() then
        return
    end

    local v36 = arg26.LocalFighter:GetMoveVector(true, true) * arg26.LocalFighter.Entity.Humanoid.WalkSpeed * 1
    arg26.LocalFighter.Entity.RootPart.Velocity = v36 + Vector3.new(
        0,
        arg26.LocalFighter.Entity.Humanoid.JumpPower * 1.1,
        0
    )
    arg26.LocalFighter.Entity:AirborneRedirect()
    arg26:PlayMechanicsSound("DoubleJump")
end

function t_2.JumpRequest(arg27, ...) -- line: 419
    arg27:Jump(...)
end

function t_2.DoubleJumpRequest(arg28) -- line: 423
    local v37 = arg28.LocalFighter

    if v37 then
        v37 = arg28.LocalFighter.EquippedItem

        if v37 then
            v37 = arg28.LocalFighter.EquippedItem:Get("ObjectID")
        end
    end

    local v38 = arg28.LocalFighter

    if v38 then
        v38 = arg28.LocalFighter.EquippedItem

        if v38 then
            v38 = not arg28.LocalFighter:Get("DisableDoubleJumping")

            if v38 then
                v38 = arg28.LocalFighter.EquippedItem.Info.MaxDoubleJumps
            end
        end
    end

    if
        v37
        and v38
        and (arg28._double_jumps_used[v37] or 0) < (v38 or 0)
        and not arg28.LocalFighter:IsGrounded()
    then
        arg28._double_jumps_used[v37] = (arg28._double_jumps_used[v37] or 0) + 1
        arg28:DoubleJump()
    end
end

function t_2.HighJump(arg29) -- line: 433
    if not arg29:IsAlive() then
        return
    end

    arg29:StopSliding(true)
    arg29:_SpamJumpRequests(nil, 1.25, true)
end

function t_2.EquippedItemInput(arg30, ...) -- line: 442
    if not arg30.LocalFighter then
        return
    end

    arg30.LocalFighter:Input(...)
end

function t_2.SimulateInputBegan(arg31, arg32, arg33) -- line: 451
    -- upvalues:
    --  [1] InputLibrary_m (copy)
    --  [2] UserInterfaceController_m (copy)
    --  [3] t (copy)
    --  [4] ControlsController_m (copy)
    --  [5] CameraController_m (copy)
    --  [6] SpectateController_m (copy)
    --  [7] PlayerDataController_m (copy)
    --  [8] EmoteController_m (copy)
    --  [9] CONSTANTS_m (copy)
    --  [10] ReplicatedStorage (copy)

    if InputLibrary_m:InputIs(arg32, "UseEmote") then
        local PickEmote = UserInterfaceController_m:GetPage("PickEmote")

        if PickEmote and PickEmote:IsOpen() then
            PickEmote:SetAllEmotesOpen(true)
        end
    end

    if arg31:AreInputsDisabled() then
        return
    end

    for _, val in pairs(t) do
        if InputLibrary_m:InputIs(arg32, val) and ControlsController_m:IsToggled(val) then
            ControlsController_m:ToggleInput(val, false)

            return arg31:SimulateInputEnded(arg32, arg33)
        end

        if InputLibrary_m:InputIs(arg32, val) and arg31:_IsToggleInput(val) then
            ControlsController_m:ToggleInput(val, true)
        end
    end

    if
        arg33
        and not UserInterfaceController_m:IsPageOpen("Panels")
        and ControlsController_m.CurrentControls == "MouseKeyboard"
    then
        return
    end

    if
        CameraController_m:GetPublicState() == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse
        and arg32.UserInputType == Enum.UserInputType.MouseButton2
    then
        return
    end

    if InputLibrary_m:InputIs(arg32, "OpenPlayerList") then
        if SpectateController_m.CurrentDuelSubject then
            SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard:Open(true)
        end
    elseif InputLibrary_m:InputIs(arg32, "Ping") then
        arg31.LocalFighter:Ping()
    end

    if not arg31:IsAlive() then
        return
    end

    if
        InputLibrary_m:InputIs(arg32, "Jump")
        and arg31.LocalFighter.Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing
    then
        if arg31.IsSliding then
            arg31:HighJump()

            return
        end

        arg31:DoubleJumpRequest()
        arg31:_SpamJumpRequests()

        return
    end

    if InputLibrary_m:InputIs(arg32, "Crouch") and not arg31.IsSliding and not arg31:IsFrozen() then
        local v40 = arg31.IsSprinting or tick() - arg31._sprinting_release_time < 0.125

        if
            (if ControlsController_m.CurrentControls == "Touch" then PlayerDataController_m:GetSetting(
                "Easy Slide Mobile"
            ) else PlayerDataController_m:GetSetting("Easy Slide"))
            and v40
            and arg31.LocalFighter:GetMoveVector(true, true).Magnitude > 0.01
            and arg31.LocalFighter:IsGrounded()
        then
            arg31:Slide()

            return
        end

        arg31:SetCrouching(true)

        return
    end

    if
        InputLibrary_m:InputIs(arg32, "Slide")
        and not arg31.IsSliding
        and arg31.LocalFighter:IsGrounded()
    then
        arg31:Slide()

        return
    end

    if if InputLibrary_m:InputIs(arg32, "Sprint") then not arg31.IsSliding else InputLibrary_m:InputIs(
        arg32,
        "AutoSprint"
    ) and not arg31.IsSliding then
        arg31:SetSprinting(true)

        return
    end

    if InputLibrary_m:InputIs(arg32, "LeanLeft") then
        if not arg31._is_leaning_left then
            arg31._is_leaning_left = true
            arg31:SetCameraLean(arg31.CameraLean - 1)

            return
        end
    elseif InputLibrary_m:InputIs(arg32, "LeanRight") then
        if not arg31._is_leaning_right then
            arg31._is_leaning_right = true
            arg31:SetCameraLean(arg31.CameraLean + 1)

            return
        end
    else
        if EmoteController_m:CanEmote() then
            for index = 1, CONSTANTS_m.MAX_EQUIPPABLE_EMOTES do
                if InputLibrary_m:InputIs(arg32, "UseEmote" .. index) then
                    EmoteController_m:UseEmote((tostring(index)))
                end
            end
        end

        if InputLibrary_m:InputIs(arg32, "EquipPrimary") then
            arg31.LocalFighter:EquipItem(1)

            return
        end

        if InputLibrary_m:InputIs(arg32, "EquipSecondary") then
            arg31.LocalFighter:EquipItem(2)

            return
        end

        if InputLibrary_m:InputIs(arg32, "EquipMelee") then
            arg31.LocalFighter:EquipItem(3)

            return
        end

        if InputLibrary_m:InputIs(arg32, "EquipUtility") then
            arg31.LocalFighter:EquipItem(4)

            return
        end

        if InputLibrary_m:InputIs(arg32, "EquipLast") then
            arg31.LocalFighter:EquipIncrement(-1)

            return
        end

        if InputLibrary_m:InputIs(arg32, "EquipNext") then
            arg31.LocalFighter:EquipIncrement(1)

            return
        end

        if InputLibrary_m:InputIs(arg32, "QuickMelee") then
            arg31.LocalFighter:QuickAttackDown("Melee", arg32)

            return
        end

        if InputLibrary_m:InputIs(arg32, "QuickUtility") then
            arg31.LocalFighter:QuickAttackDown("Utility", arg32)

            return
        end

        if InputLibrary_m:InputIs(arg32, "UseEmote") and EmoteController_m:CanEmote() then
            local PickEmote_1 = UserInterfaceController_m:GetPage("PickEmote")

            if PickEmote_1 then
                if not PickEmote_1:IsOpen() then
                    UserInterfaceController_m:OpenPage("PickEmote", true)

                    return
                end
            else
                UserInterfaceController_m:OpenPage("PickEmote", true)

                return
            end
        else
            if arg31.LocalFighter.EquippedItem then
                for _, val_1 in pairs(InputLibrary_m.ItemInputs) do
                    if InputLibrary_m:InputIs(arg32, val_1) then
                        task.spawn(function() -- line: 565
                            -- upvalues:
                            --  [1] InputLibrary_m (ref)
                            --  [2] val_1 (copy)
                            --  [3] arg31 (copy)

                            local StartName = InputLibrary_m.Inputs[val_1].StartName

                            if arg31.LocalFighter.EquippedItem.Info.InputSpammingEnabled[StartName] then
                                arg31:_InputSpam(val_1, StartName)

                                return
                            end

                            arg31:EquippedItemInput(StartName)
                        end)
                    end
                end

                return
            end

            if
                InputLibrary_m:InputIs(arg32, "Shoot")
                and arg31.LocalFighter.Entity
                and arg31.LocalFighter.Entity:Get("IsGrabbingSnowball")
            then
                local v46 = arg31.LocalFighter:GetCameraData(nil, nil, true, true)
                local v47 = v46[utf8.char(2)]
                local v48 = v46[utf8.char(3)]
                v46 = v47

                if v46 then
                    v46 = v47.CFrame * v48
                end

                if v46 then
                    ReplicatedStorage.Remotes.Replication.Fighter.SnowballThrow:FireServer(
                        v46.Position
                    )
                end
            end
        end
    end
end

function t_2.SimulateInputEnded(arg34, arg35) -- line: 588
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] t (copy)
    --  [3] InputLibrary_m (copy)
    --  [4] ControlsController_m (copy)
    --  [5] SpectateController_m (copy)
    --  [6] UserInterfaceController_m (copy)

    if not arg34.LocalFighter then
        return
    end

    if
        CameraController_m:GetPublicState() == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse
        and arg35.UserInputType == Enum.UserInputType.MouseButton2
    then
        return
    end

    for _, val_2 in pairs(t) do
        if
            InputLibrary_m:InputIs(arg35, val_2)
            and arg34:_IsToggleInput(val_2)
            and ControlsController_m:IsToggled(val_2)
        then
            return
        end
    end

    if InputLibrary_m:InputIs(arg35, "Crouch") then
        if arg34.IsCrouching then
            arg34:SetCrouching(false)

            if arg34:IsInputDown("Sprint") then
                arg34:SetSprinting(true)
            end
        end
    elseif InputLibrary_m:InputIs(arg35, "Sprint") or InputLibrary_m:InputIs(arg35, "AutoSprint") then
        arg34:SetSprinting(false)
    elseif InputLibrary_m:InputIs(arg35, "LeanLeft") then
        if arg34._is_leaning_left then
            arg34._is_leaning_left = false
            arg34:SetCameraLean(arg34.CameraLean + 1)
        end
    elseif InputLibrary_m:InputIs(arg35, "LeanRight") and arg34._is_leaning_right then
        arg34._is_leaning_right = false
        arg34:SetCameraLean(arg34.CameraLean - 1)
    end

    if InputLibrary_m:InputIs(arg35, "QuickMelee") then
        arg34.LocalFighter:QuickAttackUp("Melee")

        return
    end

    if InputLibrary_m:InputIs(arg35, "QuickUtility") then
        arg34.LocalFighter:QuickAttackUp("Utility")

        return
    end

    if InputLibrary_m:InputIs(arg35, "OpenPlayerList") then
        if SpectateController_m.CurrentDuelSubject then
            SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard:Open(false)

            return
        end
    elseif
        InputLibrary_m:InputIs(arg35, "UseEmote")
        and ControlsController_m.CurrentControls == "MouseKeyboard"
    then
        local PickEmote_2 = UserInterfaceController_m:GetPage("PickEmote")

        if PickEmote_2 then
            PickEmote_2:PickEarly()

            return
        end
    elseif arg34.LocalFighter.EquippedItem then
        for _, val_3 in pairs(InputLibrary_m.ItemInputs) do
            if InputLibrary_m:InputIs(arg35, val_3) then
                arg34:EquippedItemInput(InputLibrary_m.Inputs[val_3].FinishName)
            end
        end
    end
end

function t_2.MobileInput(arg36, arg37, arg38) -- line: 651
    -- upvalues:
    --  [1] InputLibrary_m (copy)

    if arg38 and arg36:AreInputsDisabled() then
        return
    end

    local v52 = InputLibrary_m.MobileButtons[arg37]
    local MobileInputDown = arg36._mobile_input_down
    local v53 = v52 and v52.InputName or arg37
    MobileInputDown[v53] = arg38
    v53 = if not arg38 then "SimulateInputEnded" else "SimulateInputBegan"
    arg36[v53](arg36, arg37, false)
end

function t_2.WaitForLocalFighter(arg39) -- line: 662
    if not arg39.LocalFighter then
        arg39._internal_local_fighter_added:Wait()
    end

    return arg39.LocalFighter
end

function t_2._CanAutoShoot(arg40) -- line: 674
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] DebugState_m (copy)

    if
        not arg40.LocalFighter
        or not arg40.LocalFighter.EquippedItem
        or arg40.LocalFighter:Get("IsHiddenByCutscene")
    then
        return false
    end

    return if ControlsController_m.CurrentControls ~= "Touch" then if ControlsController_m.CurrentControls ~= "Gamepad" then arg40.LocalFighter:Get(
        "CheaterMode"
    ) or DebugState_m:Get("AreHandicapsEnabled") else true else true
end

function t_2._ToggleAutoShoot(arg41) -- line: 682
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Players (copy)
    --  [3] Utility_m (copy)
    --  [4] GameplayUtility_m (copy)
    --  [5] RunService (copy)

    arg41._auto_shoot_hash += 1
    local AutoShootHash = arg41._auto_shoot_hash

    if arg41._auto_shoot_connection then
        arg41._auto_shoot_connection:Disconnect()
        arg41._auto_shoot_connection = nil
    end

    if not arg41:_CanAutoShoot() then
        return
    end

    local v55 = arg41.LocalFighter:Get("CheaterMode")
    local v56 = if v55 then 0 else PlayerDataController_m:GetSetting("Auto Shoot Reaction Time") / 1000
    local v58 = if v55 then nil else PlayerDataController_m:GetSetting("Auto Shoot")
    local v60 = if v55 then nil else arg41.LocalFighter:Get("AutoShootRestriction")
    local v62 = if not v55 then v60 or v58 else nil

    if v58 == "Disabled" or v60 == "Disabled" then
        return
    end

    local v63 = nil
    local v64 = 0
    local v65 = true

    local function can_autoshoot() -- line: 709
        -- upvalues:
        --  [1] arg41 (copy)
        --  [2] v64 (ref)
        --  [3] v63 (ref)
        --  [4] Players (ref)
        --  [5] Utility_m (ref)
        --  [6] GameplayUtility_m (ref)

        local v66 = arg41.LocalFighter

        if v66 then
            v66 = arg41.LocalFighter.EquippedItem

            if v66 then
                v66 = arg41.LocalFighter:IsAlive()
            end
        end

        if not v66 then
            return
        end

        v66 = arg41.LocalFighter.EquippedItem:GetAutoShootReactionTime()
        local v67 = arg41.LocalFighter.EquippedItem:GetAutoShootReach()

        if not v66 or not v67 then
            return
        end

        if tick() > v64 then
            v64 = tick() + 2
            v63 = arg41.LocalFighter:GetRaycastWhitelist(true, { arg41.LocalFighter }, nil, true)
        end

        if Players.LocalPlayer.PlayerGui:FindFirstChild("FlashbangGui") then
            return
        end

        local raycastResult_2 = Utility_m:Raycast(
            workspace.CurrentCamera.CFrame.Position,
            workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * v67,
            v67,
            v63,
            Enum.RaycastFilterType.Include
        )

        if not raycastResult_2.Instance then
            return
        end

        v67 = Utility_m:AngleBetweenVectors(
            workspace.CurrentCamera.CFrame.LookVector,
            CFrame.new(
                arg41.LocalFighter.Entity.RootPart.Position,
                raycastResult_2.Instance.Position
            ).LookVector
        ) < 1.5707963267948966 and true

        if not v67 then
            return
        end

        v67 = raycastResult_2.Instance

        if v67 then
            v67 = raycastResult_2.Instance.AssemblyRootPart

            if v67 then
                v67 = raycastResult_2.Instance.AssemblyRootPart.Parent

                if v67 then
                    v67 = raycastResult_2.Instance.AssemblyRootPart.Parent:HasTag("Entity")
                end
            end
        end

        local v70 = v67

        if v70 then
            v70 = GameplayUtility_m:GetEntityFromModel(
                raycastResult_2.Instance.AssemblyRootPart.Parent
            )
        end

        if
            not v70
            or v70.AimAssistBlacklist
            or not v70:IsAlive()
            or GameplayUtility_m:GetSmokeCloudBetweenPoints(
                workspace.CurrentCamera.CFrame.Position,
                raycastResult_2.Position
            )
        then
            return
        end

        return arg41.LocalFighter.EquippedItem, v66
    end

    function v58(arg42) --[[ finish_shooting ]] -- line: 763
        -- upvalues:
        --  [1] v65 (ref)
        --  [2] arg41 (copy)

        if not v65 then
            return
        end

        v65 = false
        task.delay(arg42 or 0, arg41.EquippedItemInput, arg41, "FinishShooting")
    end

    local _ = function() --[[ start_shooting ]] -- line: 772
        -- upvalues:
        --  [1] v65 (ref)
        --  [2] arg41 (copy)

        v65 = true
        arg41:EquippedItemInput("StartShooting")

        if arg41.LocalFighter.EquippedItem and arg41.LocalFighter.EquippedItem.Name ~= "Flamethrower" then
            if not v65 then
                return
            end

            v65 = false
            task.delay(0.03, arg41.EquippedItemInput, arg41, "FinishShooting")
        end
    end

    local v71 = false

    local function hold(arg43) -- line: 784
        -- upvalues:
        --  [1] v71 (ref)
        --  [2] arg41 (copy)
        --  [3] can_autoshoot (copy)
        --  [4] v65 (ref)
        --  [5] RunService (ref)
        --  [6] AutoShootHash (copy)

        if v71 then
            return
        end

        v71 = true
        local EquippedItem = arg41.LocalFighter.EquippedItem
        local v72 = tick() + arg43

        while true do
            local _, v74 = can_autoshoot()

            if not v74 or arg41.LocalFighter.EquippedItem ~= EquippedItem then
                break
            end

            if v72 < tick() then
                v65 = true
                arg41:EquippedItemInput("StartShooting")

                if
                    arg41.LocalFighter.EquippedItem
                    and arg41.LocalFighter.EquippedItem.Name ~= "Flamethrower"
                    and v65
                then
                    v65 = false
                    task.delay(0.03, arg41.EquippedItemInput, arg41, "FinishShooting")
                end
            end

            RunService.RenderStepped:Wait()

            if AutoShootHash == arg41._auto_shoot_hash then
                continue
            end

            return
        end

        v71 = false
    end

    arg41._auto_shoot_connection = RunService.RenderStepped:Connect(function() -- line: 815
        -- upvalues:
        --  [1] v71 (ref)
        --  [2] can_autoshoot (copy)
        --  [3] v65 (ref)
        --  [4] arg41 (copy)
        --  [5] v62 (copy)
        --  [6] v56 (copy)
        --  [7] hold (copy)

        if v71 then
            return
        end

        local _, v76 = can_autoshoot()

        if not v76 then
            if not v65 then
                return
            end

            v65 = false
            task.delay(0, arg41.EquippedItemInput, arg41, "FinishShooting")

            return
        else
            task.defer(hold, if v62 == "Dynamic" then math.clamp(v76, 0.025, 0.125) else v56)

            return
        end
    end)
end

function t_2._IsToggleInput(arg44, arg45) -- line: 833
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] t_1 (copy)
    --  [3] SettingsLibrary_m (copy)
    --  [4] PlayerDataController_m (copy)

    local v77 = if ControlsController_m.CurrentControls == "Touch" then t_1[arg45] else nil
    local v78 = "Toggle " .. arg45
    local v79

    if v77 ~= nil then
        v79 = v77
    else
        v79 = SettingsLibrary_m.Info[v78]

        if v79 then
            v79 = PlayerDataController_m:GetSetting(v78)
        end
    end

    v78 = arg44.LocalFighter and arg44.LocalFighter.EquippedItem and arg44.LocalFighter.EquippedItem.ToggleAimEnabled

    return v79 and (arg45 ~= "Aim" or v78)
end

function t_2._AutoSprintEnabled(_) -- line: 842
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ControlsController_m (copy)

    return PlayerDataController_m:GetSetting("Auto Sprint") or ControlsController_m.CurrentControls == "Touch"
end

function t_2._UpdateServerState(_, arg48, ...) -- line: 846
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] EnumLibrary_m (copy)

    ReplicatedStorage.Remotes.Replication.Fighter.UpdateState:FireServer(
        EnumLibrary_m:ToEnum(arg48),
        ...
    )
end

function t_2._InputSpam(arg49, arg50, arg51) -- line: 851
    -- upvalues:
    --  [1] RunService (copy)

    if arg49._is_input_spamming[arg50] then
        return
    end

    arg49._is_input_spamming[arg50] = true

    while true do
        if
            not arg49.LocalFighter
            or not arg49.LocalFighter.EquippedItem
            or not arg49.LocalFighter.EquippedItem.Info.InputSpammingEnabled[arg51]
            or not arg49:IsInputDown(arg50)
            or arg49.LocalFighter:Get("IsHiddenByCutscene")
        then
            break
        end

        local v83 = arg49:_IsToggleInput(arg50)
        arg49:EquippedItemInput(arg51)

        if v83 then
            break
        end

        local v84 = arg49.LocalFighter.EquippedItem.Info.InputSpammingEnabled[arg51]

        if not v84 then
            break
        end

        if v84 <= 0 then
            RunService.RenderStepped:Wait()
            continue
        end

        wait(v84)
    end

    arg49._is_input_spamming[arg50] = false
end

function t_2._SpamJumpRequests(arg52, ...) -- line: 882
    -- upvalues:
    --  [1] RunService (copy)

    while true do
        if arg52.IsSliding or not arg52:IsInputDown("Jump") then
            break
        end

        arg52:JumpRequest(...)
        RunService.RenderStepped:Wait()
    end
end

function t_2._GetWalkSpeed(arg53, arg54) -- line: 890
    -- upvalues:
    --  [1] UserInterfaceController_m (copy)
    --  [2] CosmeticLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)

    if arg53:IsFrozen() then
        return 0
    end

    local v85 = arg53.LocalFighter.Entity:IsEmoting()
    local v86 = arg53.LocalFighter.Entity:GetCurrentEmote()
    local v87 = UserInterfaceController_m:IsPageOpen()
    local v88 = if arg53.IsSprinting and not v85 then arg53.LocalFighter:Get("SprintingSpeedBoost") or 0.5 else 0
    local v89 = arg53.LocalFighter and arg53.LocalFighter.Entity and arg53.LocalFighter.Entity:GetBoost(
        "Speed"
    ) or 0
    local v90 = v88 + v89
    v89 = if not v87 then 1 else if v87.Name ~= "PickEmote" then 1 else 0
    v88 = v85 and CosmeticLibrary_m.Cosmetics[v86.Name].TraversalWalkSpeedMultiplier or 1
    local v91 = arg53.LocalFighter and arg53.LocalFighter.EquippedItem and arg53.LocalFighter.EquippedItem.Info.WalkSpeedMultiplier or 1
    v86 = if not arg53.IsCrouching then 1 else 0.5
    v85 = if not arg53.IsSliding then 1 else if arg54 then 1 else 0

    return CONSTANTS_m.BASE_WALKSPEED * (1 + v90) * (v89 * v88 * v91 * v86 * v85)
end

function t_2._UpdateWalkSpeed(arg55) -- line: 913
    if arg55.IsSliding or not arg55:IsAlive() then
        return
    end

    arg55.LocalFighter.Entity.Humanoid.WalkSpeed = arg55:_GetWalkSpeed()
end

function t_2._UpdateCharacterRotation(arg56) -- line: 921
    -- upvalues:
    --  [1] CameraController_m (copy)

    if arg56.IsSliding or not arg56:IsAlive() then
        return
    end

    local v92 = CameraController_m:GetPublicState()
    local v93 = arg56.LocalFighter.Entity:IsEmoting()
    local v94 = not v92
    local Humanoid_2 = arg56.LocalFighter.Entity.Humanoid

    if not v94 then
        v94 = v92 == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse
    end

    Humanoid_2.AutoRotate = v94

    if
        not v92
        or v92 == CameraController_m.CameraState.States.CustomFreecam
        or v92 == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse and v93
    then
        return
    end

    local v95 = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)

    if v95.Magnitude > 0.01 then
        arg56.LocalFighter.Entity.RootPart.CFrame = CFrame.new(
            arg56.LocalFighter.Entity.RootPart.Position,
            arg56.LocalFighter.Entity.RootPart.Position + v95
        )
    end
end

function t_2._SetupControls(arg57) -- line: 942
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] ControlsController_m (copy)
    --  [3] UserInputService (copy)
    --  [4] CameraController_m (copy)
    --  [5] PlayerDataController_m (copy)

    for _, val_4 in pairs(arg57._controls_connections) do
        val_4:Disconnect()
    end

    arg57._controls_connections = {}

    if arg57:IsMobileInputDown("AutoSprint") then
        task.spawn(arg57.MobileInput, arg57, "AutoSprint", false)
    end

    if not arg57.LocalFighter then
        return
    end

    RunService.RenderStepped:Connect(function() -- line: 958
        -- upvalues:
        --  [1] arg57 (copy)

        arg57:_UpdateCharacterRotation()
        arg57:_UpdateWalkSpeed()

        if not arg57:_AutoSprintEnabled() then
            return
        end

        local v96 = arg57.LocalFighter and not arg57.IsCrouching and not arg57.IsSliding
        local v97 = v96

        if v97 then
            v97 = arg57.LocalFighter:GetMoveVector()
        end

        v96 = v97 and v97.Magnitude >= 0.9

        if v96 and not arg57.IsSprinting then
            arg57:MobileInput("AutoSprint", true)

            return
        end

        if not v96 and arg57.IsSprinting then
            arg57:MobileInput("AutoSprint", false)
        end
    end)

    if ControlsController_m.CurrentControls == "Touch" then
        return
    end

    table.insert(arg57._controls_connections, UserInputService.InputBegan:Connect(function(...) -- line: 982
        -- upvalues:
        --  [1] arg57 (copy)

        arg57:SimulateInputBegan(...)
    end))
    table.insert(arg57._controls_connections, UserInputService.InputEnded:Connect(function(...) -- line: 986
        -- upvalues:
        --  [1] arg57 (copy)

        arg57:SimulateInputEnded(...)
    end))

    if ControlsController_m.CurrentControls == "MouseKeyboard" then
        table.insert(arg57._controls_connections, UserInputService.InputChanged:Connect(function(
            input: InputObject,
            gameProcessedEvent: boolean
        ) -- line: 992
            -- upvalues:
            --  [1] CameraController_m (ref)
            --  [2] arg57 (copy)
            --  [3] PlayerDataController_m (ref)

            if
                gameProcessedEvent
                or CameraController_m:GetPublicState() == CameraController_m.CameraState.States.ThirdPersonUnlockedMouse
                or not arg57:IsAlive()
                or not PlayerDataController_m:GetSetting("Scroll Equip")
            then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local v98 = math.floor(arg57._scroll_delta + input.Position.Z) - math.floor(
                    arg57._scroll_delta
                )
                local v99 = arg57
                v99._scroll_delta += input.Position.Z

                if math.abs(v98) > 0 then
                    arg57.LocalFighter:EquipIncrement(-math.sign(v98))
                end
            end
        end))
    end
end

function t_2._BindMovementActionsLoop(_) -- line: 1010
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ContextActionService (copy)
    --  [3] InputLibrary_m (copy)
    --  [4] PlayerDataController_m (copy)

    local ControlModule_m = require(
        Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")
    )
    local Keyboard_m = require(
        Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"):WaitForChild(
            "Keyboard"
        )
    )

    local _ = function() --[[ get_keyboard_module ]] -- line: 1016
        -- upvalues:
        --  [1] ControlModule_m (copy)
        --  [2] Keyboard_m (copy)

        for key_5, val_5 in pairs(ControlModule_m.controllers) do
            if key_5 == Keyboard_m then
                return val_5
            end
        end
    end

    local t_7 = {}
    t_7.WalkForward = {
        "moveForwardAction",
        function(_, arg62, _) -- line: 1024
            -- upvalues:
            --  [1] ControlModule_m (copy)
            --  [2] Keyboard_m (copy)

            local loop_exited = false
            local v103

            for key_6, val_6 in pairs(ControlModule_m.controllers) do
                if key_6 == Keyboard_m then
                    v103 = val_6
                    loop_exited = true
                    break
                end
            end

            if not loop_exited then
                v103 = nil
            end

            if not v103 then
                return
            end

            v103.forwardValue = if arg62 ~= Enum.UserInputState.Begin then 0 else -1
            v103:UpdateMovement(arg62)

            return Enum.ContextActionResult.Pass
        end
    }
    t_7.WalkBackward = {
        "moveBackwardAction",
        function(_, arg65, _) -- line: 1036
            -- upvalues:
            --  [1] ControlModule_m (copy)
            --  [2] Keyboard_m (copy)

            local loop_exited_1 = false
            local v105

            for key_7, val_7 in pairs(ControlModule_m.controllers) do
                if key_7 == Keyboard_m then
                    v105 = val_7
                    loop_exited_1 = true
                    break
                end
            end

            if not loop_exited_1 then
                v105 = nil
            end

            if not v105 then
                return
            end

            v105.backwardValue = if arg65 ~= Enum.UserInputState.Begin then 0 else 1
            v105:UpdateMovement(arg65)

            return Enum.ContextActionResult.Pass
        end
    }
    t_7.WalkLeftward = {
        "moveLeftAction",
        function(_, arg68, _) -- line: 1048
            -- upvalues:
            --  [1] ControlModule_m (copy)
            --  [2] Keyboard_m (copy)

            local loop_exited_2 = false
            local v107

            for key_8, val_8 in pairs(ControlModule_m.controllers) do
                if key_8 == Keyboard_m then
                    v107 = val_8
                    loop_exited_2 = true
                    break
                end
            end

            if not loop_exited_2 then
                v107 = nil
            end

            if not v107 then
                return
            end

            v107.leftValue = if arg68 ~= Enum.UserInputState.Begin then 0 else -1
            v107:UpdateMovement(arg68)

            return Enum.ContextActionResult.Pass
        end
    }
    t_7.WalkRightward = {
        "moveRightAction",
        function(_, arg71, _) -- line: 1060
            -- upvalues:
            --  [1] ControlModule_m (copy)
            --  [2] Keyboard_m (copy)

            local loop_exited_3 = false
            local v109

            for key_9, val_9 in pairs(ControlModule_m.controllers) do
                if key_9 == Keyboard_m then
                    v109 = val_9
                    loop_exited_3 = true
                    break
                end
            end

            if not loop_exited_3 then
                v109 = nil
            end

            if not v109 then
                return
            end

            v109.rightValue = if arg71 ~= Enum.UserInputState.Begin then 0 else 1
            v109:UpdateMovement(arg71)

            return Enum.ContextActionResult.Pass
        end
    }

    local function update(arg73) -- line: 1080
        -- upvalues:
        --  [1] t_7 (copy)
        --  [2] ContextActionService (ref)
        --  [3] InputLibrary_m (ref)

        local v111, v112 = table.unpack(t_7[arg73])

        if ContextActionService:GetBoundActionInfo(v111) then
            ContextActionService:UnbindAction(v111)
        end

        local v113 = InputLibrary_m:GetInputs(arg73)

        if v113 and #v113 > 0 then
            ContextActionService:BindActionAtPriority(
                v111,
                v112,
                false,
                2000,
                table.unpack(v113)
            )
        end
    end

    for key_10, _ in pairs(t_7) do
        for _, val_11 in pairs(InputLibrary_m.HOTKEY_FORMATS) do
            for _, val_12 in pairs(val_11) do
                PlayerDataController_m:GetSettingChangedSignal(string.format(val_12, key_10)):Connect(
                    function() -- line: 1097
                        -- upvalues:
                        --  [1] update (copy)
                        --  [2] key_10 (copy)

                        update(key_10)
                    end
                )
            end
        end
    end

    for key_13, val_13 in pairs(t_7) do
        local v118, _ = table.unpack(val_13)
        local v121 = ContextActionService:GetBoundActionInfo(v118)
        v118 = not v121 or not v121.inputTypes or not v121.inputTypes[1] or (if typeof(
            v121.inputTypes[1]
        ) == "EnumItem" then if v121.inputTypes[1].EnumType ~= Enum.PlayerActions then false else true else false)

        if v118 then
            update(key_13)
        end
    end

    wait(1)
end

function t_2._DisableRobloxJumpButton(_) -- line: 1121
    -- upvalues:
    --  [1] ContextActionService (copy)

    while true do
        if next(ContextActionService:GetBoundActionInfo("jumpAction") or {}) then
            ContextActionService:UnbindAction("jumpAction")
        end

        wait(1)
    end
end

function t_2._HookFighter(arg75) -- line: 1133
    -- upvalues:
    --  [1] Players (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CONSTANTS_m (copy)

    arg75.LocalFighter = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController):WaitForLocalFighter()
    arg75.LocalFighter.StopSliding:Connect(function() -- line: 1136
        -- upvalues:
        --  [1] arg75 (copy)

        arg75:StopSliding()
    end)
    arg75.LocalFighter:GetDataChangedSignal("AutoShootRestriction"):Connect(function() -- line: 1140
        -- upvalues:
        --  [1] arg75 (copy)

        arg75:_ToggleAutoShoot()
    end)
    arg75.LocalFighter:GetDataChangedSignal("CheaterMode"):Connect(function() -- line: 1144
        -- upvalues:
        --  [1] arg75 (copy)

        arg75:_ToggleAutoShoot()
    end)
    arg75.LocalFighter:GetDataChangedSignal("IsHiddenByCutscene"):Connect(function() -- line: 1148
        -- upvalues:
        --  [1] arg75 (copy)

        arg75:_ToggleAutoShoot()
    end)
    local t_12 = {}
    arg75.LocalFighter.EquippedItemChanged:Connect(function(arg76) -- line: 1154
        -- upvalues:
        --  [1] t_12 (ref)
        --  [2] arg75 (copy)

        for _, val_14 in pairs(t_12) do
            val_14:Disconnect()
        end

        t_12 = {}
        arg75:_UpdateWalkSpeed()
        arg75:_ToggleAutoShoot()

        if not arg76 then
            return
        end

        table.insert(t_12, arg76.StopSprinting:Connect(function() -- line: 1168
            -- upvalues:
            --  [1] arg75 (ref)

            arg75:SetSprinting(false)
        end))
        table.insert(t_12, arg76.AttemptToSprintAgain:Connect(function() -- line: 1172
            -- upvalues:
            --  [1] arg75 (ref)

            if arg75:IsInputDown("Sprint") or arg75:IsInputDown("AutoSprint") then
                arg75:SetSprinting(true)
            end
        end))
    end)

    local function update_auto_jump() -- line: 1179
        -- upvalues:
        --  [1] arg75 (copy)
        --  [2] PlayerDataController_m (ref)

        if arg75.LocalFighter.Entity and arg75.LocalFighter.Entity.Humanoid then
            local Humanoid_3 = arg75.LocalFighter.Entity.Humanoid
            Humanoid_3.AutoJumpEnabled = PlayerDataController_m:GetSetting("Auto Jump") or arg75.LocalFighter.Entity:IsAirborne()
        end
    end

    PlayerDataController_m:GetSettingChangedSignal("Auto Jump"):Connect(update_auto_jump)

    local function entity_added(arg77) -- line: 1187
        -- upvalues:
        --  [1] arg75 (copy)
        --  [2] CONSTANTS_m (ref)
        --  [3] PlayerDataController_m (ref)

        arg75._original_humanoid_animations = {}
        arg75._double_jumps_used = {}
        arg75:SetCrouching(false)
        arg75:SetSprinting(false)
        arg75:StopSliding()
        arg75:_UpdateWalkSpeed()
        arg77.Humanoid.CameraOffset = Vector3.new(0, 1, 0)
        local CustomGravity_BodyForce = Instance.new("BodyForce")
        CustomGravity_BodyForce.Name = "CustomGravity"
        CustomGravity_BodyForce.Parent = arg77.RootPart

        local function update_gravity() -- line: 1205
            -- upvalues:
            --  [1] arg75 (ref)
            --  [2] arg77 (copy)
            --  [3] CONSTANTS_m (ref)
            --  [4] CustomGravity_BodyForce (copy)

            local v126 = not arg75.IsCrouching and arg77:Get("Gravity") or 1
            CustomGravity_BodyForce.Force = Vector3.new(
                0,
                arg77.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_m.BASE_GRAVITY * v126),
                0
            )
            arg77.Humanoid.JumpPower = CONSTANTS_m.BASE_JUMPPOWER
        end

        arg77:GetDataChangedSignal("Gravity"):Connect(update_gravity)
        arg77.EmoteStatusChanged:Connect(update_gravity)
        arg75.StateChanged:Connect(update_gravity)
        local v128 = not arg75.IsCrouching and arg77:Get("Gravity") or 1
        CustomGravity_BodyForce.Force = Vector3.new(
            0,
            arg77.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_m.BASE_GRAVITY * v128),
            0
        )
        arg77.Humanoid.JumpPower = CONSTANTS_m.BASE_JUMPPOWER

        local function descendant_added(arg78) -- line: 1219
            -- upvalues:
            --  [1] update_gravity (copy)

            if arg78:IsA("BasePart") then
                arg78:GetPropertyChangedSignal("AssemblyMass"):Connect(update_gravity)
                arg78:GetPropertyChangedSignal("Mass"):Connect(update_gravity)
            end
        end

        arg77.Model.DescendantAdded:Connect(descendant_added)

        for _, descendant in pairs(arg77.Model:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant:GetPropertyChangedSignal("AssemblyMass"):Connect(update_gravity)
                descendant:GetPropertyChangedSignal("Mass"):Connect(update_gravity)
            end
        end

        arg77.Humanoid.Jumping:Connect(function() -- line: 1232
            -- upvalues:
            --  [1] arg75 (ref)
            --  [2] arg77 (copy)
            --  [3] CONSTANTS_m (ref)
            --  [4] CustomGravity_BodyForce (copy)

            local v130 = not arg75.IsCrouching and arg77:Get("Gravity") or 1
            CustomGravity_BodyForce.Force = Vector3.new(
                0,
                arg77.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_m.BASE_GRAVITY * v130),
                0
            )
            arg77.Humanoid.JumpPower = CONSTANTS_m.BASE_JUMPPOWER
            arg75:StopSliding(true)
        end)
        arg77.Humanoid.StateChanged:Connect(function(_, arg80) -- line: 1237
            -- upvalues:
            --  [1] arg75 (ref)
            --  [2] arg77 (copy)
            --  [3] CONSTANTS_m (ref)
            --  [4] CustomGravity_BodyForce (copy)

            local v132 = not arg75.IsCrouching and arg77:Get("Gravity") or 1
            CustomGravity_BodyForce.Force = Vector3.new(
                0,
                arg77.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_m.BASE_GRAVITY * v132),
                0
            )
            arg77.Humanoid.JumpPower = CONSTANTS_m.BASE_JUMPPOWER

            if arg80 == Enum.HumanoidStateType.Climbing then
                arg75:StopSliding()

                return
            end

            if arg80 == Enum.HumanoidStateType.Landed then
                arg75._double_jumps_used = {}
            end
        end)
        arg77.Humanoid.Died:Connect(function() -- line: 1247
            -- upvalues:
            --  [1] arg75 (ref)

            arg75:SetSprinting(false)
            arg75:SetCrouching(false)
            arg75:StopSliding()
        end)
        arg77.AirborneChanged:Connect(function() -- line: 1253
            -- upvalues:
            --  [1] arg75 (ref)
            --  [2] arg77 (copy)
            --  [3] PlayerDataController_m (ref)

            arg75:_UpdateServerState("IsAirborne", arg77:IsAirborne())

            if arg75.LocalFighter.Entity and arg75.LocalFighter.Entity.Humanoid then
                local Humanoid_4 = arg75.LocalFighter.Entity.Humanoid
                Humanoid_4.AutoJumpEnabled = PlayerDataController_m:GetSetting("Auto Jump") or arg75.LocalFighter.Entity:IsAirborne()
            end
        end)
        arg77.RedirectSliding:Connect(function(arg81) -- line: 1258
            -- upvalues:
            --  [1] arg75 (ref)

            if arg75._update_slide_direction then
                arg75._update_slide_direction(arg81)
            end
        end)

        if arg75.LocalFighter.Entity and arg75.LocalFighter.Entity.Humanoid then
            local Humanoid_5 = arg75.LocalFighter.Entity.Humanoid
            Humanoid_5.AutoJumpEnabled = PlayerDataController_m:GetSetting("Auto Jump") or arg75.LocalFighter.Entity:IsAirborne()
        end
    end

    arg75.LocalFighter.EntityAdded:Connect(entity_added)

    if arg75.LocalFighter.Entity then
        task.spawn(entity_added, arg75.LocalFighter.Entity)
    end

    arg75._internal_local_fighter_added:Fire()
    arg75:_SetupControls()
    arg75:_ToggleAutoShoot()
    task.defer(arg75._DisableRobloxJumpButton, arg75)
    task.defer(arg75._BindMovementActionsLoop, arg75)
end

function t_2._Init(arg82) -- line: 1281
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] DebugState_m (copy)

    ControlsController_m.ControlsChanged:Connect(function() -- line: 1282
        -- upvalues:
        --  [1] arg82 (copy)

        arg82:_SetupControls()
        arg82:_ToggleAutoShoot()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Auto Shoot"):Connect(function() -- line: 1287
        -- upvalues:
        --  [1] arg82 (copy)

        arg82:_ToggleAutoShoot()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Auto Shoot Reaction Time"):Connect(function() -- line: 1291
        -- upvalues:
        --  [1] arg82 (copy)

        arg82:_ToggleAutoShoot()
    end)
    DebugState_m:GetDataChangedSignal("AreHandicapsEnabled"):Connect(function() -- line: 1295
        -- upvalues:
        --  [1] arg82 (copy)

        arg82:_ToggleAutoShoot()
    end)
    task.defer(arg82._HookFighter, arg82)
end

return t_2._new()
