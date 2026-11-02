local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "MobileInputs"
    )
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "Teleporting"
    )
)
local PlayerList_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "PlayerList"
    )
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "Equipment"
    )
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local t = {}
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.LocalFighter = nil
    t_1:_Init()

    return t_1
end

function t._UpdatePlayerList(_) -- line: 35
    -- upvalues:
    --  [1] GuiService (copy)
    --  [2] PlayerList_m (copy)
    --  [3] StarterGui (copy)

    PlayerList_m:SetScale(
        if not (if GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small then false else true) then 1 else 0.75
    )
    PlayerList_m:SetDisabled(false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end

function t._UpdateTouchControls(_) -- line: 44
    -- upvalues:
    --  [1] GuiService (copy)
    --  [2] Equipment_m (copy)
    --  [3] Pages_m (copy)

    local v9 = not Equipment_m.IsOpen
    local v10 = GuiService
    v9 = v9 and not Pages_m.PageSystem.CurrentPage
    v10.TouchControlsEnabled = v9
end

function t._UpdateChat(_) -- line: 48
    -- upvalues:
    --  [1] Teleporting_m (copy)
    --  [2] MobileInputs_m (copy)
    --  [3] StarterGui (copy)

    local v11 = not Teleporting_m.Enabled and not MobileInputs_m.EditorEnabled
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, v11 or false)
end

function t._UpdateLoop(arg4) -- line: 54
    -- upvalues:
    --  [1] StarterGui (copy)

    while true do
        pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.EmotesMenu, false)
        pcall(StarterGui.SetCoreGuiEnabled, StarterGui, Enum.CoreGuiType.Health, false)
        task.defer(arg4._UpdatePlayerList, arg4)
        task.defer(arg4._UpdateChat, arg4)
        wait(1)
    end
end

function t._Init(arg5) -- line: 64
    -- upvalues:
    --  [1] Teleporting_m (copy)
    --  [2] MobileInputs_m (copy)
    --  [3] PlayerList_m (copy)
    --  [4] GuiService (copy)
    --  [5] ControlsController_m (copy)
    --  [6] Equipment_m (copy)
    --  [7] Pages_m (copy)

    Teleporting_m.EnabledChanged:Connect(function() -- line: 65
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateChat()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 69
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateChat()
    end)
    PlayerList_m.BaseVisibilityChanged:Connect(function() -- line: 73
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdatePlayerList()
    end)
    GuiService:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function() -- line: 77
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdatePlayerList()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 81
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdatePlayerList()
    end)
    Equipment_m.Opened:Connect(function() -- line: 85
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateTouchControls()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 89
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateTouchControls()
    end)
    task.defer(arg5._UpdateLoop, arg5)
    task.defer(arg5._UpdateChat, arg5)
    task.defer(arg5._UpdatePlayerList, arg5)
    task.defer(arg5._UpdateTouchControls, arg5)
end

return t._new()
