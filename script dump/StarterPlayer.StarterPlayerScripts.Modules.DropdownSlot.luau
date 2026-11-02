local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local WeaponStatusHandler_m = require(Players.LocalPlayer.PlayerScripts.Modules.WeaponStatusHandler)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local _ = { ReleaseRatio = 1.025 }
local t_1 = {}
local DropdownButton = Players.LocalPlayer.PlayerScripts.UserInterface.DropdownButton
local DropdownSlot = Players.LocalPlayer.PlayerScripts.UserInterface.DropdownSlot
t_1.__index = t_1

function t_1.new(arg1, arg2, arg3) -- line: 21
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Signal_m (copy)
    --  [3] DropdownSlot (copy)

    assert(
        if typeof(arg1) ~= "Instance" then false else true,
        "Argument 1 invalid, expected a valid UI element"
    )
    assert(if typeof(arg2) ~= "table" then false else true, "Argument 2 invalid, expected a table")
    local t_2 = setmetatable({}, t_1)
    t_2.Selected = Signal_m.new()
    t_2.Frame = DropdownSlot:Clone()
    t_2.Background = t_2.Frame:WaitForChild("Background")
    t_2.List = t_2.Frame:WaitForChild("List")
    t_2.Container = t_2.List:WaitForChild("Container")
    t_2.Layout = t_2.Container:WaitForChild("Layout")
    t_2._destroyed = false
    t_2._reference = arg1
    t_2._options = arg2
    t_2._max_options = arg3 or 5
    t_2._connections = {}
    t_2._selected = false
    t_2:_Init()

    return t_2
end

function t_1.Cancel(arg4) -- line: 51
    arg4:_Select(nil)
end

function t_1.Destroy(arg5) -- line: 55
    if arg5._destroyed then
        return
    end

    arg5._destroyed = true

    for _, val in pairs(arg5._connections) do
        val:Disconnect()
    end

    arg5.Selected:Destroy()
    pcall(arg5.Frame.Destroy, arg5.Frame)
end

function t_1._Select(arg6, ...) -- line: 75
    if arg6._selected then
        return
    end

    arg6._selected = true
    arg6.Selected:Fire(...)
end

function t_1._Update(arg7) -- line: 84
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local v2 = UILibrary_m:ScreenPointToPosition(arg7._reference.AbsolutePosition)
    local AbsoluteSize = arg7._reference.AbsoluteSize
    local v3 = AbsoluteSize.Y / AbsoluteSize.X
    local Frame = arg7.Frame
    local New = UDim2.new
    local X = v2.X
    local Y = v2.Y
    local maximum = math.max(
        20,
        UILibrary_m.MainGui.AbsoluteSize.Y + UILibrary_m.MainGui.AbsolutePosition.Y - arg7.Frame.AbsoluteSize.Y - 20
    )
    Frame.Position = New(0, X, 0, (math.clamp(Y, 20, maximum)))
    arg7.Frame.Size = UDim2.new(0, AbsoluteSize.X, 0, AbsoluteSize.Y)
    arg7.Container.Size = UDim2.new(1, 0, v3, 0)
end

function t_1._Setup(arg8) -- line: 94
    -- upvalues:
    --  [1] DropdownButton (copy)
    --  [2] ButtonEffect_m (copy)
    --  [3] WeaponStatusHandler_m (copy)
    --  [4] ItemLibrary_m (copy)
    --  [5] UILibrary_m (copy)

    arg8.Background.Size = UDim2.new(1, 10, math.min(arg8._max_options, #arg8._options), 10)
    arg8.List.Size = UDim2.new(1, 0, arg8._max_options, 0)
    arg8.Layout.CellSize = UDim2.new(1, 0, 1, 0)

    for _, val_1 in pairs(arg8._options) do
        local str = tostring(val_1)
        local v5 = DropdownButton:Clone()
        v5.Button.Title.Text = str
        v5.Parent = arg8.Container
        local t_3 = {
            ReleaseRatio = UDim2.new(0, -3, 0, -3),
            HoverRatio = UDim2.new(0, -3, 0, -3),
            PressRatio = UDim2.new(0, -10, 0, -10)
        }
        ButtonEffect_m:Add(v5.Button, nil, t_3)
        local v7 = ItemLibrary_m.Items[str]
        local v8 = WeaponStatusHandler_m
        local Title = v5.Button.Title

        if v7 then
            v7 = ItemLibrary_m.Items[str].Status
        end

        v8:ApplyItemStatusToText(Title, v7)
        v5.Button.MouseButton1Click:Connect(function() -- line: 108
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] val_1 (copy)

            arg8:_Select(val_1)
        end)

        local _ = function(arg9) --[[ hover ]] -- line: 112
            -- upvalues:
            --  [1] v5 (copy)

            v5.Button.Hovering.Visible = arg9
            local Title_1 = v5.Button.Title
            Title_1.TextColor3 = arg9 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        end

        v5.MouseEnter:Connect(function() -- line: 117
            -- upvalues:
            --  [1] v5 (copy)

            v5.Button.Hovering.Visible = true
            local Title_2 = v5.Button.Title
            local v10 = Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            Title_2.TextColor3 = v10
        end)
        v5.MouseLeave:Connect(function() -- line: 121
            -- upvalues:
            --  [1] v5 (copy)

            v5.Button.Hovering.Visible = false
            v5.Button.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
        end)
        v5.Button.Hovering.Visible = false
        v5.Button.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
    end

    arg8.Frame.Parent = UILibrary_m.MainGui
end

function t_1._Init(arg10) -- line: 131
    -- upvalues:
    --  [1] Players (copy)
    --  [2] UserInputService (copy)
    --  [3] UILibrary_m (copy)

    arg10.Selected:Connect(function() -- line: 132
        -- upvalues:
        --  [1] arg10 (copy)

        task.defer(arg10.Destroy, arg10)
    end)
    arg10.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 136
        -- upvalues:
        --  [1] arg10 (copy)

        arg10.List.CanvasSize = UDim2.new(0, 0, 0, arg10.Layout.AbsoluteContentSize.Y)
    end)
    arg10.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end)
    table.insert(arg10._connections, arg10._reference.AncestryChanged:Connect(function() -- line: 144
        -- upvalues:
        --  [1] Players (ref)
        --  [2] arg10 (copy)

        if
            not Players.LocalPlayer:FindFirstChild("PlayerGui")
            or not arg10._reference:IsDescendantOf(Players.LocalPlayer.PlayerGui)
        then
            arg10.Selected:Fire(nil)
        end
    end))
    local Connections_1 = arg10._connections
    local AbsolutePosition = arg10._reference:GetPropertyChangedSignal("AbsolutePosition")
    table.insert(Connections_1, AbsolutePosition:Connect(function() -- line: 150
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end))
    local Connections_2 = arg10._connections
    local AbsoluteSize_2 = arg10._reference:GetPropertyChangedSignal("AbsoluteSize")
    table.insert(Connections_2, AbsoluteSize_2:Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_Update()
    end))
    table.insert(arg10._connections, UserInputService.InputBegan:Connect(function(arg11, _) -- line: 158
        -- upvalues:
        --  [1] UILibrary_m (ref)
        --  [2] arg10 (copy)

        if
            arg11.UserInputType ~= Enum.UserInputType.MouseButton1
            and arg11.UserInputType ~= Enum.UserInputType.Touch
            and arg11.KeyCode ~= Enum.KeyCode.ButtonA
        then
            return
        end

        if not UILibrary_m:IsMouseWithinBounds(
            arg10.Background.AbsolutePosition,
            arg10.Background.AbsoluteSize
        ) then
            arg10.Selected:Fire(nil)
        end
    end))
    arg10:_Setup()
    arg10:_Update()
end

return t_1
