local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local PageSystem_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PageSystem"))
local t = {}
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] t (copy)
    --  [2] PageSystem_m (copy)
    --  [3] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Part = Instance.new("Part")
    t_1.SurfaceGui = Instance.new("SurfaceGui")
    t_1.PagesFrame = Instance.new("Frame")
    t_1.PageSystem = PageSystem_m.new(t_1.PagesFrame)
    t_1._previous_part_offset = CFrame.identity
    t_1._part_offset = nil
    t_1._offset_spring = Spring_m.new(1, 1, 15)
    t_1._raycast_params = RaycastParams.new()
    t_1._next_raycast = 0
    t_1:_Init()

    return t_1
end

function t._Debug(arg1) -- line: 47
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] Pages_m (copy)

    RunService.RenderStepped:Connect(function() -- line: 48
        -- upvalues:
        --  [1] arg1 (copy)

        arg1:_Update()
    end)
    Pages_m.Frame.Visible = false
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg1 (copy)
        --  [2] Pages_m (ref)

        arg1.PageSystem:OpenPage(Pages_m.PageSystem.CurrentPage.Name)
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg1 (copy)

        arg1.PageSystem:CloseCurrentPage()
    end)
end

function t._Update(arg2) -- line: 63
    -- upvalues:
    --  [1] CameraController_m (copy)

    local v3 = CameraController_m:GetCameraCFrame()
    local v4 = v3.LookVector * 20

    if
        arg2._offset_spring.Value >= 0.75
        and (not arg2._part_offset or tick() > arg2._next_raycast and not workspace:Raycast(
            v3.Position,
            v4,
            arg2._raycast_params
        ))
    then
        local v5 = arg2._part_offset
        local PreviousPartOffset = arg2._previous_part_offset
        v5 = v5 or CFrame.identity
        arg2._previous_part_offset = PreviousPartOffset:Lerp(v5, arg2._offset_spring.Value)
        arg2._part_offset = workspace.CurrentCamera.CFrame.Rotation * CFrame.new(0, 0, -7)
        arg2._offset_spring.Value = 0
        arg2._next_raycast = tick() + 0.25
    end

    arg2.Part.CFrame = CFrame.new(v3.Position) * arg2._previous_part_offset:Lerp(
        arg2._part_offset,
        arg2._offset_spring.Value
    )
end

function t._Setup(arg3) -- line: 76
    -- upvalues:
    --  [1] Players (copy)

    arg3.Part.Color = Color3.fromRGB(0, 0, 0)
    arg3.Part.Transparency = 1
    arg3.Part.Size = Vector3.new(16, 9, 1)
    arg3.Part.Anchored = true
    arg3.Part.CastShadow = false
    arg3.Part.CanCollide = false
    arg3.Part.CanTouch = false
    arg3.Part.CanQuery = true
    arg3.Part.Name = "Panel"
    arg3.Part.Parent = workspace
    arg3.SurfaceGui.MaxDistance = 100
    arg3.SurfaceGui.Adornee = arg3.Part
    arg3.SurfaceGui.AlwaysOnTop = false
    arg3.SurfaceGui.LightInfluence = 0
    arg3.SurfaceGui.Brightness = 2
    arg3.SurfaceGui.Name = "PanelsGui"
    arg3.SurfaceGui.Face = Enum.NormalId.Back
    arg3.SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    arg3.SurfaceGui.PixelsPerStud = 100
    arg3.SurfaceGui.ResetOnSpawn = false
    arg3.SurfaceGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    arg3.PagesFrame.Size = UDim2.new(1, 0, 1, 0)
    arg3.PagesFrame.BackgroundTransparency = 1
    arg3.PagesFrame.Name = "Pages"
    arg3.PagesFrame.Parent = arg3.SurfaceGui
    arg3._raycast_params = RaycastParams.new()
    arg3._raycast_params.FilterType = Enum.RaycastFilterType.Include
    arg3._raycast_params.FilterDescendantsInstances = { arg3.Part }
    arg3._raycast_params.BruteForceAllSlow = true
    arg3._raycast_params.IgnoreWater = true
end

function t._Init(arg4) -- line: 112
    arg4.PageSystem.PageOpened:Connect(function(arg5) -- line: 113
        -- upvalues:
        --  [1] arg4 (copy)

        local UIAspectRatioConstraint = arg5.PageFrame:FindFirstChildOfClass(
            "UIAspectRatioConstraint"
        )
        local v6 = UIAspectRatioConstraint and UIAspectRatioConstraint.AspectRatio or arg5.PageFrame.Size.X.Scale / arg5.PageFrame.Size.Y.Scale
        arg4.Part.Size = Vector3.new(8, 8 / v6, 1)
        arg5.PageFrame.Size = UDim2.new(0, 0, 0, 0)
        arg5.PageFrame.Position = UDim2.new(0.5, 0, 1, 0)
        arg5.PageFrame:TweenPosition(
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Quint",
            0.5,
            true
        )
        arg5.PageFrame:TweenSize(
            UDim2.new(0.75, 0, 0.75, 0),
            "Out",
            "Quint",
            0.25,
            true
        )
    end)
    arg4:_Setup()
end

return t._new()
