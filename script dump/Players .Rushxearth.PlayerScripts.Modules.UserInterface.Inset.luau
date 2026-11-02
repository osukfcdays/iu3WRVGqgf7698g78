local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MatchmakingCountdown")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Shutdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Shutdown")
)
local _ = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local MobileEditorBar_m = require(script:WaitForChild("MobileEditorBar"))
local ContextBar_m = require(script:WaitForChild("ContextBar"))
local MainBar_m = require(script:WaitForChild("MainBar"))
local Details_m = require(script:WaitForChild("Details"))
local InsetGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("InsetGui")
local t = {}
t.__index = t

function t._new() -- line: 30
    -- upvalues:
    --  [1] t (copy)
    --  [2] InsetGui (copy)
    --  [3] Details_m (copy)
    --  [4] MobileEditorBar_m (copy)
    --  [5] ContextBar_m (copy)
    --  [6] MainBar_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.InsetGui = InsetGui
    t_1.MainFrame = t_1.InsetGui:WaitForChild("MainFrame")
    t_1.Container = t_1.MainFrame:WaitForChild("Container")
    t_1.LeftButtonsFrame = t_1.Container:WaitForChild("LeftButtons")
    t_1.RightButtonsFrame = t_1.Container:WaitForChild("RightButtons")
    t_1.Details = Details_m.new(t_1)
    t_1.MobileEditorBar = MobileEditorBar_m.new(t_1)
    t_1.ContextBar = ContextBar_m.new(t_1)
    t_1.MainBar = MainBar_m.new(t_1)
    t_1._local_fighter = nil
    t_1:_Init()

    return t_1
end

function t.IsWithinAnyBar(arg1, arg2, arg3) -- line: 55
    return arg1.MobileEditorBar.Bar:IsWithin(arg2, arg3) or arg1.ContextBar.Bar:IsWithin(arg2, arg3) or arg1.MainBar.Bar:IsWithin(
        arg2,
        arg3
    )
end

function t._UpdateMirrored(arg4) -- line: 63
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local v14 = false

    if ControlsController_m.CurrentControls == "Touch" then
        v14 = arg4._local_fighter

        if v14 then
            v14 = arg4._local_fighter:Get("IsInDuel") or arg4._local_fighter:Get(
                "IsInShootingRange"
            ) or #arg4._local_fighter.Items > 0 and true
        end
    end

    local v15 = not v14
    local v16 = if not v14 then arg4.RightButtonsFrame else arg4.LeftButtonsFrame
    arg4.MainBar.Bar:SetMirrored(v15)
    arg4.MainBar.Bar.Frame.Parent = v16
    arg4.ContextBar.Bar:SetMirrored(v15)
    arg4.ContextBar.Bar.Frame.Parent = v16
    v16 = if v15 then 1 else -1
    arg4.ContextBar.Bar.Frame.LayoutOrder = v16 * 1
    arg4.MainBar.Bar.Frame.LayoutOrder = v16 * 2
end

function t._UpdateVisibility(arg5) -- line: 79
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Teleporting_m (copy)
    --  [3] MatchmakingCountdown_m (copy)
    --  [4] GuiService (copy)
    --  [5] Shutdown_m (copy)

    local v17 = not Pages_m.PageSystem.CurrentPage

    if v17 then
        v17 = not Teleporting_m.Enabled

        if v17 then
            v17 = not MatchmakingCountdown_m:IsVisible()

            if v17 then
                v17 = not GuiService.MenuIsOpen and not Shutdown_m.Enabled
            end
        end
    end

    arg5.Details:SetVisible(v17)
    local v18 = v17
    local MainBar = arg5.MainBar

    if v18 then
        v18 = not arg5.MobileEditorBar.Bar.Frame.Visible
    end

    MainBar:SetVisible(v18)
    v18 = v17
    local ContextBar = arg5.ContextBar

    if v18 then
        v18 = not arg5.MobileEditorBar.Bar.Frame.Visible
    end

    ContextBar:SetVisible(v18)
    v18 = v17
    local MobileEditorBar = arg5.MobileEditorBar

    if v18 then
        v18 = not arg5.MainBar.Bar.Frame.Visible
    end

    MobileEditorBar:SetVisible(v18)
end

function t._CheckBigInset(arg6) -- line: 89
    -- upvalues:
    --  [1] GuiService (copy)

    arg6.LeftButtonsFrame.Size = UDim2.new(1, 0, 1, -12)
    arg6.LeftButtonsFrame.Position = UDim2.new(0, 12, 1, 0)
    arg6.LeftButtonsFrame.AnchorPoint = Vector2.new(0, 1)
    local v19 = arg6.MainFrame.AbsoluteSize.Y > 100 and true
    local Container = arg6.Container
    Container.Size = v19 and UDim2.new(0, GuiService.TopbarInset.Width, 0, 58) or UDim2.new(
        1,
        0,
        1,
        0
    )
    local Container_1 = arg6.Container
    Container_1.Position = v19 and UDim2.new(0, GuiService.TopbarInset.Min.X, 0, 0) or UDim2.new(
        0,
        0,
        0,
        0
    )
    arg6.RightButtonsFrame.Size = arg6.LeftButtonsFrame.Size
    arg6.RightButtonsFrame.Position = UDim2.new(
        -arg6.LeftButtonsFrame.Position.X.Scale,
        -arg6.LeftButtonsFrame.Position.X.Offset,
        arg6.LeftButtonsFrame.Position.Y.Scale,
        arg6.LeftButtonsFrame.Position.Y.Offset
    )
    arg6.RightButtonsFrame.AnchorPoint = arg6.LeftButtonsFrame.AnchorPoint
end

function t._HookLocalFighter(arg7) -- line: 114
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg7._local_fighter = FighterController_m:WaitForLocalFighter()
    arg7._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 117
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateMirrored()
    end)
    arg7._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 121
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateMirrored()
    end)
    arg7._local_fighter.ItemAdded:Connect(function() -- line: 125
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateMirrored()
    end)
    arg7._local_fighter.ItemRemoved:Connect(function() -- line: 129
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateMirrored()
    end)
    arg7:_UpdateMirrored()
end

function t._Setup(arg8) -- line: 136
    -- upvalues:
    --  [1] Players (copy)

    arg8.MainFrame.Size = UDim2.new(1, 0, 1, 0)
    arg8.InsetGui.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg9) -- line: 141
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Teleporting_m (copy)
    --  [4] Shutdown_m (copy)
    --  [5] Pages_m (copy)
    --  [6] MatchmakingCountdown_m (copy)
    --  [7] GuiService (copy)

    arg9.MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 142
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_CheckBigInset()
    end)
    arg9.MainBar.Bar.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 146
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    arg9.MobileEditorBar.Bar.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 150
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 154
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateMirrored()
    end)
    Equipment_m.Opened:Connect(function() -- line: 158
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 162
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Shutdown_m.EnabledChanged:Connect(function() -- line: 166
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 170
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
        task.defer(arg9._UpdateVisibility, arg9)
    end)
    MatchmakingCountdown_m.VisibilityChanged:Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 179
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_CheckBigInset()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 183
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    arg9:_Setup()
    arg9:_CheckBigInset()
    arg9:_UpdateVisibility()
    task.defer(arg9._HookLocalFighter, arg9)
end

return t._new()
