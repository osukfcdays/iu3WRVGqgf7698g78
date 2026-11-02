local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 14
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.MainFrame = UILibrary_m:GetTo("MainFrame")
    t_1:_Init()

    return t_1
end

function t._UpdateSize(arg1) -- line: 34
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Pages_m (copy)
    --  [3] ControlsController_m (copy)
    --  [4] Players (copy)

    local v7 = PlayerDataController_m:GetSetting("Padded HUD")
    local v8 = not Pages_m.PageSystem.CurrentPage

    if v8 then
        v8 = if v7 ~= "Always On" then if v7 ~= "Using Controller" then false else ControlsController_m.CurrentControls == "Gamepad" else true
    end

    v7 = v8 and UDim2.new(0.9, 0, 0.9, 0) or UDim2.new(1, 0, 1, 0)

    if arg1.MainFrame:IsDescendantOf(Players) then
        arg1.MainFrame:TweenSize(
            v7,
            "Out",
            "Quint",
            0.25,
            true
        )

        return
    end

    arg1.MainFrame.Size = v7
end

function t._Update(arg2) -- line: 46
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] SpectateController_m (copy)
    --  [4] GuiService (copy)

    local v9

    if FighterController_m.LocalFighter then
        v9 = not FighterController_m.LocalFighter:Get("IsHiddenByCutscene")

        if v9 then
            v9 = not PlayerDataController_m:GetSetting("Hide HUD")
        end
    else
        v9 = not PlayerDataController_m:GetSetting("Hide HUD")
    end

    local v10 = SpectateController_m.CurrentDuelSubject

    if v10 then
        v10 = if SpectateController_m.CurrentDuelSubject:Get("Status") ~= "Voting" then false else true
    end

    local v11 = not GuiService.MenuIsOpen
    arg2.MainFrame.BottomStack.Visible = v9
    arg2.MainFrame.Notifications.Visible = v9
    arg2.MainFrame.DuelInterfaces.Visible = if v9 then v11 else v10 and v11
    arg2.MainFrame.EliminatedEffect.Visible = v9
    arg2.MainFrame.FighterInterfaces.Visible = v9 and v11
    arg2.MainFrame.Lobby.Visible = v9
end

function t._HookLocalFighter(arg3) -- line: 59
    -- upvalues:
    --  [1] FighterController_m (copy)

    FighterController_m:WaitForLocalFighter():GetDataChangedSignal("IsHiddenByCutscene"):Connect(
        function() -- line: 62
            -- upvalues:
            --  [1] arg3 (copy)

            arg3:_Update()
        end
    )
    task.defer(arg3._Update, arg3)
end

function t._Init(arg4) -- line: 69
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] ControlsController_m (copy)
    --  [4] Pages_m (copy)
    --  [5] GuiService (copy)

    PlayerDataController_m:GetSettingChangedSignal("Hide HUD"):Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Update()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Padded HUD"):Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateSize()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Update()
    end)
    SpectateController_m.DuelSubjectStatusChanged:Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Update()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 86
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateSize()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateSize()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_Update()
    end)
    arg4:_Update()
    arg4:_UpdateSize()
    task.defer(arg4._HookLocalFighter, arg4)
end

return t._new()
