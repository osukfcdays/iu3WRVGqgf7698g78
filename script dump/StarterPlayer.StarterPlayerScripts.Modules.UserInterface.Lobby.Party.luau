local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local MatchmakingController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MatchmakingController")
)
local Matchmaking_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Lobby"):WaitForChild(
        "Matchmaking"
    )
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local PartyDisplay_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PartyDisplay")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] PartyDisplay_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.IsVisible = false
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Lobby", "Party")
    t_1.BottomDisplayFrame = t_1.Frame:WaitForChild("BottomDisplay")
    t_1.BottomDisplayContainer = t_1.BottomDisplayFrame:WaitForChild("Container")
    t_1.BottomDisplayLayout = t_1.BottomDisplayContainer:WaitForChild("Layout")
    t_1.BottomPartyDisplay = PartyDisplay_m.new(t_1.BottomDisplayContainer)
    t_1._last_tween = nil
    t_1:_Init()

    return t_1
end

function t._UpdateVisibility(arg1) -- line: 46
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] GuiService (copy)
    --  [7] Matchmaking_m (copy)
    --  [8] MatchmakingController_m (copy)
    --  [9] TweenService (copy)

    if arg1._last_tween then
        arg1._last_tween:Pause()
        arg1._last_tween = nil
    end

    local v10 = not Pages_m.PageSystem.CurrentPage

    if v10 then
        v10 = not Equipment_m.IsOpen

        if v10 then
            v10 = not Queue_m:IsVisible()

            if v10 then
                v10 = not Teleporting_m.Enabled and not MobileInputs_m.EditorEnabled and not GuiService.MenuIsOpen
            end
        end
    end

    local v11 = Matchmaking_m:IsVisible()
    local v12 = MatchmakingController_m:IsRematchAvailable()
    local v13 = if v11 then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left
    local vec2 = if not v11 then Vector2.new(0, 0) else Vector2.new(0.5, 0.5)
    local udim2 = if not v11 then if not v11 then if not v10 then if not v10 then UDim2.new(
        2.75,
        0,
        7,
        0
    ) else UDim2.new(2.75, 0, 0, 0) else if not v12 then if not v10 then UDim2.new(2.75, 0, 7, 0) else UDim2.new(
        2.75,
        0,
        0,
        0
    ) else UDim2.new(2.75, 0, -1.25, 0) else if v10 then if not v10 then if not v10 then UDim2.new(
        2.75,
        0,
        7,
        0
    ) else UDim2.new(2.75, 0, 0, 0) else if not v12 then if not v10 then UDim2.new(2.75, 0, 7, 0) else UDim2.new(
        2.75,
        0,
        0,
        0
    ) else UDim2.new(2.75, 0, -1.25, 0) else UDim2.new(0.5, 0, 7, 0) else if not v10 then if not v11 then if not v10 then if not v10 then UDim2.new(
        2.75,
        0,
        7,
        0
    ) else UDim2.new(2.75, 0, 0, 0) else if not v12 then if not v10 then UDim2.new(2.75, 0, 7, 0) else UDim2.new(
        2.75,
        0,
        0,
        0
    ) else UDim2.new(2.75, 0, -1.25, 0) else if v10 then if not v10 then if not v10 then UDim2.new(
        2.75,
        0,
        7,
        0
    ) else UDim2.new(2.75, 0, 0, 0) else if not v12 then if not v10 then UDim2.new(2.75, 0, 7, 0) else UDim2.new(
        2.75,
        0,
        0,
        0
    ) else UDim2.new(2.75, 0, -1.25, 0) else UDim2.new(0.5, 0, 7, 0) else UDim2.new(0.5, 0, 0.5, 0)
    arg1.IsVisible = v10
    arg1.BottomDisplayLayout.HorizontalAlignment = v13
    arg1._last_tween = TweenService:Create(
        arg1.BottomDisplayContainer,
        TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = udim2, AnchorPoint = vec2 }
    )
    arg1._last_tween:Play()
end

function t._Init(arg2) -- line: 70
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] Pages_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Matchmaking_m (copy)
    --  [5] Teleporting_m (copy)
    --  [6] MobileInputs_m (copy)
    --  [7] MatchmakingController_m (copy)
    --  [8] GuiService (copy)

    Equipment_m.Opened:Connect(function() -- line: 71
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 75
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 79
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 83
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    Matchmaking_m.VisibilityChanged:Connect(function() -- line: 87
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 91
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 95
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    MatchmakingController_m.RematchDetailsChanged:Connect(function() -- line: 99
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 103
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateVisibility()
    end)
    arg2:_UpdateVisibility()
end

return t._new()
