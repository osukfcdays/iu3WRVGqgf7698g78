local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local cframe = CFrame.new(0, 0, 35)
local cframe_1 = CFrame.new(0, -2, 0)
local udim2 = UDim2.new(0.5, 0, -2.5, 0)
local udim2_1 = UDim2.new(0.5, 0, 3.5, 0)
local t = {}
t.__index = t

function t.new(arg1) -- line: 33
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.FinishedOpenEffect = Signal_m.new()
    t_1.Equipment = arg1
    t_1._frame = UILibrary_m:GetTo("MainFrame", "Equipment", "CameraFade")
    t_1._look_at_attachment = nil
    t_1._look_at_offset = Vector3.new(0, 0, 0)
    t_1._fov_spring = Spring_m.new(15, 0.875, 5)
    t_1._equipment_open_hash = 0
    t_1._equipment_open_start_cframe = CFrame.identity
    t_1._equipment_open_start = 0
    t_1._equipment_open_finished = true
    t_1._equipment_open_is_closing = false
    t_1._controls_connections = {}
    t_1._scroll_fov_spring = Spring_m.new(0, 1, 20)
    t_1._fov_zoom_direction = Vector2.zero
    t_1:_Init()

    return t_1
end

function t.IsOpenEffectDone(arg2) -- line: 62
    return arg2._equipment_open_finished
end

function t.IsClosing(arg3) -- line: 66
    return arg3._equipment_open_is_closing
end

function t.SetFocus(
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 70
    arg4._look_at_attachment = arg5 or nil
    arg4._look_at_offset = arg6 or Vector3.new(0, 0, 0)
    arg4._fov_spring.Target = arg7 or 15
    arg4._fov_spring.Speed = arg8 or 5
end

function t.Update(arg9, arg10) -- line: 77
    -- upvalues:
    --  [1] cframe_1 (copy)
    --  [2] cframe (copy)
    --  [3] CameraController_m (copy)

    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    arg9:_IncrementFOVSpringFromInput(
        (arg9._fov_zoom_direction.X - arg9._fov_zoom_direction.Y) * arg10 * 60 * 0.25
    )
    local now = tick()
    local clampedValue = math.clamp((now - arg9._equipment_open_start) / 0.375, 0, 1)

    if clampedValue < 1 then
        local v2 = clampedValue ^ 2

        if arg9._equipment_open_is_closing then
            workspace.CurrentCamera.CFrame = arg9._equipment_open_start_cframe * CFrame.identity:Lerp(
                cframe_1,
                v2
            )

            return
        end

        workspace.CurrentCamera.CFrame = arg9._equipment_open_start_cframe * CFrame.new(
            0,
            v2 * 25,
            0
        )

        return
    else
        local v3 = arg9.Equipment:GetCustomizingType()
        local v4 = if v3 ~= "Finisher" then v3 == "Emote" else true
        local v5 = arg9.Equipment.Scene:GetCFrame() * cframe
        local v6, v7

        if not arg9._equipment_open_finished then
            v6 = arg9:_IsOpenEffectDisabled() and CFrame.identity or cframe_1
            v7 = v5 * v6
        else
            v7 = workspace.CurrentCamera.CFrame
        end

        v6 = if v4 then CFrame.new(
            v5.Position + Vector3.new(0, 5, 0),
            arg9.Equipment.Scene:GetHumanoidCFrame().Position
        ) else if not arg9._look_at_attachment then v5 else CFrame.new(
            v5.Position,
            arg9._look_at_attachment.WorldPosition + arg9._look_at_offset
        )
        local Angles = CFrame.Angles
        local v9 = math.sin(tick() * 0.23983 % 6.283185307179586) * 0.00017453292519943296
        v4 = Angles(
            v9,
            math.sin(tick() * 0.372721 % 6.283185307179586) * 0.00017453292519943296,
            math.sin(tick() * 0.43123 % 6.283185307179586) * 0.00017453292519943296
        )
        v5 = if arg9.Equipment:IsCustomizing() then 0.025 else 0.05
        workspace.CurrentCamera.FieldOfView = arg9._fov_spring.Value + arg9._scroll_fov_spring.Value + CameraController_m:GetExternalFOVOffset()
        workspace.CurrentCamera.CFrame = CFrame.new(v7.Position:Lerp(v6.Position, 0.1)) * v7.Rotation:Lerp(
            v6.Rotation,
            v5
        ) * v4

        if not arg9._equipment_open_finished then
            arg9._equipment_open_finished = true
            arg9.FinishedOpenEffect:Fire()
        end

        return
    end
end

function t.OnStateChanged(arg11) -- line: 121
    if arg11.Equipment:IsCustomizing() then
    end
end

function t.OnOpen(arg12) -- line: 127
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] udim2 (copy)
    --  [3] udim2_1 (copy)
    --  [4] Utility_m (copy)

    task.spawn(
        CameraController_m.CameraState.SetCustomFreecamEnabled,
        CameraController_m.CameraState,
        false
    )
    CameraController_m:Freeze(arg12.Equipment.IsOpen)
    arg12:_VerifyControls()

    if arg12.Equipment.IsOpen then
        arg12._scroll_fov_spring.Target = 0
        arg12._scroll_fov_spring.Value = 0

        if arg12:_IsOpenEffectDisabled() then
            arg12._equipment_open_hash += 1
            arg12._equipment_open_is_closing = false
            arg12._equipment_open_start_cframe = CFrame.identity
            arg12._equipment_open_start = 0
            arg12._equipment_open_finished = false
            arg12.FinishedOpenEffect:Fire()

            return
        end

        arg12._equipment_open_hash += 1
        arg12._equipment_open_is_closing = false
        arg12._equipment_open_start_cframe = workspace.CurrentCamera.CFrame
        arg12._equipment_open_start = tick()
        arg12._equipment_open_finished = false
        arg12.FinishedOpenEffect:Fire()
        arg12._frame.Position = udim2
        arg12._frame:TweenPosition(
            udim2_1,
            "InOut",
            "Quint",
            0.9375,
            true
        )
        Utility_m:CreateSound(
            "rbxassetid://106551800007995",
            1.5,
            1 + 0.2 * math.random(),
            script,
            true,
            5
        )
    end
end

function t.CloseEffect(arg13) -- line: 159
    -- upvalues:
    --  [1] udim2_1 (copy)
    --  [2] udim2 (copy)
    --  [3] Utility_m (copy)

    if arg13:_IsOpenEffectDisabled() then
        arg13._equipment_open_hash += 1
        arg13._equipment_open_is_closing = true
        arg13._equipment_open_start_cframe = CFrame.identity
        arg13._equipment_open_start = 0
        arg13._equipment_open_finished = true
        arg13.FinishedOpenEffect:Fire()

        return
    end

    arg13._equipment_open_hash += 1
    arg13._equipment_open_is_closing = true
    arg13._equipment_open_start_cframe = workspace.CurrentCamera.CFrame
    arg13._equipment_open_start = tick()
    arg13._equipment_open_finished = false
    arg13.FinishedOpenEffect:Fire()
    arg13._frame.Position = udim2_1
    arg13._frame:TweenPosition(
        udim2,
        "InOut",
        "Quint",
        0.75,
        true
    )
    Utility_m:CreateSound(
        "rbxassetid://106551800007995",
        1.25,
        0.8 + 0.2 * math.random(),
        script,
        true,
        5
    )
    local EquipmentOpenHash = arg13._equipment_open_hash
    wait(0.375)

    if EquipmentOpenHash ~= arg13._equipment_open_hash then
        return
    end

    if not arg13._equipment_open_finished then
        arg13._equipment_open_finished = true
        arg13.FinishedOpenEffect:Fire()
    end
end

function t._IsOpenEffectDisabled(_) -- line: 200
    -- upvalues:
    --  [1] GuiService (copy)

    return GuiService.ReducedMotionEnabled
end

function t._IncrementFOVSpringFromInput(arg15, arg16) -- line: 204
    arg15._scroll_fov_spring.Target = math.clamp(arg15._scroll_fov_spring.Target + arg16, -10, 10)
end

function t._VerifyControls(arg17) -- line: 208
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] Pages_m (copy)
    --  [3] UILibrary_m (copy)

    for _, val in pairs(arg17._controls_connections) do
        val:Disconnect()
    end

    arg17._controls_connections = {}
    arg17._fov_zoom_direction = Vector2.zero

    if not arg17.Equipment.IsOpen then
        return
    end

    table.insert(arg17._controls_connections, UserInputService.TouchPinch:Connect(function(
        _,
        _,
        arg20,
        _,
        arg22
    ) -- line: 220
        -- upvalues:
        --  [1] arg17 (copy)

        if arg22 then
            return
        end

        arg17:_IncrementFOVSpringFromInput(arg20 * -0.25)
    end))
    table.insert(arg17._controls_connections, UserInputService.InputChanged:Connect(function(
        arg23,
        _
    ) -- line: 228
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] UILibrary_m (ref)
        --  [3] arg17 (copy)

        if
            Pages_m.PageSystem.CurrentPage
            or arg23.UserInputType ~= Enum.UserInputType.MouseWheel
            or UILibrary_m:IsMouseWithinBounds(
                arg17.Equipment.Interface.Left.Frame.AbsolutePosition,
                arg17.Equipment.Interface.Left.Frame.AbsoluteSize
            )
            or UILibrary_m:IsMouseWithinBounds(
                arg17.Equipment.Interface.Right.Frame.AbsolutePosition,
                arg17.Equipment.Interface.Right.Frame.AbsoluteSize
            )
            or UILibrary_m:IsMouseWithinBounds(
                arg17.Equipment.Interface.Customize.Cosmetics.List.AbsolutePosition,
                arg17.Equipment.Interface.Customize.Cosmetics.List.AbsoluteSize
            )
        then
            return
        end

        arg17:_IncrementFOVSpringFromInput(arg23.Position.Z * -1)
    end))
    table.insert(arg17._controls_connections, UserInputService.InputBegan:Connect(function(arg25, _) -- line: 248
        -- upvalues:
        --  [1] arg17 (copy)

        if arg25.KeyCode == Enum.KeyCode.ButtonL2 then
            arg17._fov_zoom_direction = Vector2.new(1, arg17._fov_zoom_direction.Y)

            return
        end

        if arg25.KeyCode == Enum.KeyCode.ButtonR2 then
            arg17._fov_zoom_direction = Vector2.new(arg17._fov_zoom_direction.X, 1)
        end
    end))
    table.insert(arg17._controls_connections, UserInputService.InputEnded:Connect(function(arg27, _) -- line: 256
        -- upvalues:
        --  [1] arg17 (copy)

        if arg27.KeyCode == Enum.KeyCode.ButtonL2 then
            arg17._fov_zoom_direction = Vector2.new(0, arg17._fov_zoom_direction.Y)

            return
        end

        if arg27.KeyCode == Enum.KeyCode.ButtonR2 then
            arg17._fov_zoom_direction = Vector2.new(arg17._fov_zoom_direction.X, 0)
        end
    end))
end

function t._UpdateFocus(arg29) -- line: 265
    -- upvalues:
    --  [1] Pages_m (copy)

    local v23 = arg29.Equipment:GetCustomizingType()
    local v24 = if v23 == "Charm" then Vector3.new(0, -0.075, 0) else Vector3.new(0, 0, 0)
    arg29._look_at_offset = v24
    v24 = v23 == "Charm" and arg29.Equipment.FloatingModel and arg29.Equipment.FloatingModel:GetCharmPivotAttachment() or nil
    arg29._look_at_attachment = v24
    v24 = arg29._fov_spring
    v24.Speed = if not Pages_m.PageSystem.CurrentPage then 5 else 15
    local FovSpring = arg29._fov_spring
    FovSpring.Target = if v23 ~= "Finisher" then if v23 ~= "Emote" then if v23 ~= "Charm" then if not v23 then if not Pages_m.PageSystem.CurrentPage then 15 else 20 else 12.5 else 5 else 25 else 40
end

function t._Setup(arg30) -- line: 280
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg30._frame.Parent = UILibrary_m.MainGui
end

function t._Init(arg31) -- line: 284
    -- upvalues:
    --  [1] Pages_m (copy)

    arg31.Equipment.CustomizingChanged:Connect(function() -- line: 285
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateFocus()
    end)
    arg31.Equipment.CharmAttachmentVisibleChanged:Connect(function() -- line: 289
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateFocus()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 293
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateFocus()
    end)
    arg31:_Setup()
    arg31:_UpdateFocus()
end

return t
