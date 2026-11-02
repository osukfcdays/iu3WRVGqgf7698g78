local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.Frame = t_1.FighterInterface.BottomRight.Container:WaitForChild("Spectators")
    t_1.Icon = t_1.Frame:WaitForChild("Icon")
    t_1.Title = t_1.Frame:WaitForChild("Value")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.BackgroundGradient = t_1.Background:WaitForChild("UIGradient")
    t_1._connections = {}
    t_1:_Init()

    return t_1
end

function t.UpdateParent(arg2) -- line: 31
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    task.defer(pcall, function() -- line: 32
        -- upvalues:
        --  [1] PlayerDataController_m (ref)
        --  [2] arg2 (copy)

        local v1 = if PlayerDataController_m:GetSetting("Spectators Display") ~= "Bottom Center" then false else true
        local v2 = if PlayerDataController_m:GetSetting("Spectators Display") ~= "Bottom Left" then false else true
        local Icon = arg2.Icon
        Icon.Position = v2 and UDim2.new(0.162, 0, 0.5, 0) or UDim2.new(0.838, 0, 0.5, 0)
        local Title = arg2.Title
        Title.Position = v2 and UDim2.new(0.162, 0, 0.5, 0) or UDim2.new(0.838, 0, 0.5, 0)
        local Icon_1 = arg2.Icon
        Icon_1.AnchorPoint = v2 and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
        local Title_1 = arg2.Title
        Title_1.AnchorPoint = v2 and Vector2.new(0, 0.5) or Vector2.new(1, 0.5)
        local Title_2 = arg2.Title
        Title_2.TextXAlignment = v2 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
        arg2.BackgroundGradient.Rotation = if not v2 then 180 else 0
        local Frame = arg2.Frame
        Frame.Parent = v1 and arg2.FighterInterface.BottomCenter.Container or v2 and arg2.FighterInterface.BottomLeft.Container or arg2.FighterInterface.BottomRight.Container
        arg2:Refresh()
        arg2:_UpdateBackground()
    end)
end

function t.Refresh(arg3) -- line: 51
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v4 = arg3.FighterInterface.ClientFighter:Get("NumSpectators")
    local v5 = false
    local Frame_1 = arg3.Frame

    if v4 > 0 then
        v5 = if PlayerDataController_m:GetSetting("Spectators Display") == "Disabled" then false else true
    end

    Frame_1.Visible = v5
    arg3.Title.Text = v4
    arg3:_UpdateBackground()
end

function t.Destroy(arg4) -- line: 60
    for _, val in pairs(arg4._connections) do
        val:Disconnect()
    end

    arg4._connections = {}
end

function t._UpdateBackground(arg5) -- line: 72
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ControlsController_m (copy)

    local v6 = math.min(
        arg5.Frame.AbsolutePosition.X - UILibrary_m.MainGui.AbsolutePosition.X,
        UILibrary_m.MainGui.AbsolutePosition.X + UILibrary_m.MainGui.AbsoluteSize.X - (arg5.Frame.AbsolutePosition.X + arg5.Frame.AbsoluteSize.X)
    ) * 2
    arg5.Background.Size = UDim2.new(1, v6, 0.875, 0)
    v6 = if PlayerDataController_m:GetSetting("Padded HUD") == "Using Controller" then if ControlsController_m.CurrentControls ~= "Gamepad" then if PlayerDataController_m:GetSetting(
        "Padded HUD"
    ) ~= "Always On" then false else true else true else if PlayerDataController_m:GetSetting(
        "Padded HUD"
    ) ~= "Always On" then false else true
    local v8 = (if PlayerDataController_m:GetSetting("Spectators Display") == "Bottom Center" then false else true) and not v6
    arg5.Background.Visible = v8
end

function t._Init(arg6) -- line: 85
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg6.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 86
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateBackground()
    end)
    arg6.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateBackground()
    end)
    local Connections = arg6._connections
    local AbsolutePosition_1 = UILibrary_m.MainGui:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(Connections, AbsolutePosition_1:Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateBackground()
    end))
    local Connections_1 = arg6._connections
    local AbsoluteSize_1 = UILibrary_m.MainGui:GetPropertyChangedSignal("AbsoluteSize")
    table.insert(Connections_1, AbsoluteSize_1:Connect(function() -- line: 98
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateBackground()
    end))
    arg6:UpdateParent()
    arg6:_UpdateBackground()
end

return t
