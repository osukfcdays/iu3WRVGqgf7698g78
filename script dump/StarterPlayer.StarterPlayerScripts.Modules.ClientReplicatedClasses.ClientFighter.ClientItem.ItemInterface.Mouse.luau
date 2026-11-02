local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local _ = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local _ = require(ReplicatedStorage.Modules.Signal)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local MouseCrosshair_m = require(script:WaitForChild("MouseCrosshair"))
local Scope_m = require(script:WaitForChild("Scope"))
local MouseCooldownSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "MouseCooldownSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 22
    -- upvalues:
    --  [1] t (copy)
    --  [2] MouseCrosshair_m (copy)
    --  [3] Scope_m (copy)
    --  [4] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ItemInterface = arg1
    t_1.Frame = t_1.ItemInterface.Frame:WaitForChild("Mouse")
    t_1.CooldownsFrame = t_1.Frame:WaitForChild("Cooldowns")
    t_1.MouseCrosshair = MouseCrosshair_m.new(t_1)
    t_1.Scope = Scope_m.new(t_1)
    t_1._connections = {}
    t_1._slide_spring = Spring_m.new(0, 0.875, 20)
    t_1:_Init()

    return t_1
end

function t.SetVisible(arg2, arg3) -- line: 44
    arg2.Frame.Visible = arg3
end

function t.Refresh(arg4) -- line: 48
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] CameraController_m (copy)
    --  [3] CONSTANTS_m (copy)

    local v3 = UserInputService.MouseIconEnabled

    if v3 then
        v3 = if CameraController_m:GetPublicState() ~= CameraController_m.CameraState.States.ThirdPersonUnlockedMouse then false else true
    end

    local v5 = false
    local Crosshair = arg4.MouseCrosshair.Crosshair

    if CONSTANTS_m.DEVICE ~= "VR" then
        v5 = not v3
    end

    Crosshair:SetVisible(v5)
    arg4.CooldownsFrame.Visible = if CONSTANTS_m.DEVICE == "VR" then false else true
    arg4.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
end

function t.Update(arg5, arg6, arg7, arg8) -- line: 56
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] UILibrary_m (copy)

    if not arg7.IsSpectating then
        return
    end

    arg5._slide_spring.Target = if not arg7.IsSliding or not arg7.IsFirstPerson or arg5.MouseCrosshair.Crosshair:IsStatic() then 0 else 1
    local SlideSpring_1 = arg5._slide_spring
    local v7 = arg5._slide_spring.Target > arg5._slide_spring.Value and arg5._slide_spring.Target or arg5._slide_spring.Value
    SlideSpring_1.Value = v7
    local Value = arg5._slide_spring.Value
    v7 = UDim2.new()
    local v8 = CameraController_m.ViewModelOffsetCFrame * CameraController_m.ShakeCFrame

    if
        arg7.IsFirstPerson
        and v8 ~= CFrame.identity
        and not arg5.MouseCrosshair.Crosshair:IsStatic()
    then
        local screenPoint = workspace.CurrentCamera:WorldToScreenPoint(
            (workspace.CurrentCamera.CFrame * v8:Inverse() * CFrame.new(0, 0, -100)).Position
        )
        v7 = UDim2.new(
            0,
            screenPoint.X - arg7.MouseLocation.X,
            0,
            screenPoint.Y - arg7.MouseLocation.Y
        )
    end

    local v11 = UILibrary_m:ScreenPointToPosition(
        arg7.MouseLocation,
        arg5.ItemInterface.Frame.AbsolutePosition
    )
    arg5.Frame.Position = UDim2.new(0, v11.X, 0, v11.Y) + v7
    arg5.Frame.Rotation = math.floor(Value * 20 + 0.5)
    arg5.MouseCrosshair:Update(arg6, arg7, arg8)
    arg5.Scope:Update(arg6, arg7, arg8)
end

function t.Destroy(arg9) -- line: 82
    for _, val in pairs(arg9._connections) do
        val:Disconnect()
    end

    arg9.MouseCrosshair:Destroy()
    arg9.Scope:Destroy()
end

function t._CooldownEffect(arg10, arg11) -- line: 95
    -- upvalues:
    --  [1] MouseCooldownSlot (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] TweenService (copy)

    local v12, v13, v14 = arg11.GetVariables()
    local v15 = MouseCooldownSlot:Clone()
    v15.Icon.Image = arg11.Image
    v15.Icon.Container.Icon.Image = arg11.Image
    v15.Icon.Container.Size = UDim2.new(v13, 0, 1, 0)
    v15.Bar.Bar.Size = UDim2.new(v13, 0, 1.5, 0)
    v15.Parent = arg10.CooldownsFrame
    table.insert(arg11.Cleanup, v15)
    BetterDebris_m:AddItem(v15, v12)
    TweenService:Create(
        v15.Icon.Container,
        TweenInfo.new(v12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        { Size = UDim2.new(v14, 0, 1, 0) }
    ):Play()
    TweenService:Create(
        v15.Bar.Bar,
        TweenInfo.new(v12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        { Size = UDim2.new(v14, 0, 1.5, 0) }
    ):Play()
end

function t._Init(arg12) -- line: 111
    arg12.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 112
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:Refresh()
    end)
    table.insert(arg12._connections, arg12.ItemInterface.ClientItem.Cooldowns.CooldownAdded:Connect(
        function(arg13) -- line: 116
            -- upvalues:
            --  [1] arg12 (copy)

            arg12:_CooldownEffect(arg13)
        end
    ))
    local _ = arg12.ItemInterface.ClientItem.Cooldowns.CooldownAdded:Connect(function(arg13) -- line: 116
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_CooldownEffect(arg13)
    end)

    for _, val_1 in pairs(arg12.ItemInterface.ClientItem.Cooldowns.Cooldowns) do
        task.spawn(arg12._CooldownEffect, arg12, val_1)
    end
end

return t
