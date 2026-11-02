local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local LeaderboardController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.LeaderboardController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local MobileInputs_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.MobileInputs)
local Teleporting_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Teleporting)
local Shutdown_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Shutdown)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local Nametag_m = require(Players.LocalPlayer.PlayerScripts.Modules.Nametag)
local t = {}
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientFighterCharacter = arg1
    t_1._destroyed = false
    t_1._nametag = nil
    t_1:_Init()

    return t_1
end

function t.Update(_, _, _) -- line: 33
end

function t.Destroy(arg5) -- line: 37
    arg5._destroyed = true

    if arg5._nametag then
        arg5._nametag:Destroy()
    end
end

function t._Refresh(arg6) -- line: 49
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] MobileInputs_m (copy)
    --  [3] Teleporting_m (copy)
    --  [4] Shutdown_m (copy)
    --  [5] GuiService (copy)
    --  [6] PlayerDataController_m (copy)
    --  [7] Nametag_m (copy)

    if arg6._nametag then
        arg6._nametag:Destroy()
        arg6._nametag = nil
    end

    if
        Pages_m.PageSystem.CurrentPage
        or MobileInputs_m.EditorEnabled
        or Teleporting_m.Enabled
        or Shutdown_m.Enabled
        or GuiService.MenuIsOpen
        or PlayerDataController_m:GetSetting("Hide HUD")
        or arg6._destroyed
        or not arg6.ClientFighterCharacter:IsInWorld()
        or arg6.ClientFighterCharacter.ClientFighter:IsActuallyFirstPerson()
        or arg6.ClientFighterCharacter.ClientFighter:Get("IsInDuel")
    then
        return
    end

    local New = Nametag_m.new
    local Player = arg6.ClientFighterCharacter.Player
    local v1 = arg6.ClientFighterCharacter.ClientFighter:Get("Controls")
    arg6._nametag = New(
        Player,
        v1,
        arg6.ClientFighterCharacter.ClientFighter.Player:GetAttribute("StatisticDuelsWinStreak"),
        arg6.ClientFighterCharacter.ClientFighter.Player:GetAttribute("Level"),
        arg6.ClientFighterCharacter.ClientFighter.Player:GetAttribute("DisplayELO"),
        arg6.ClientFighterCharacter.ClientFighter.Player:GetAttribute("PlayerStatus"),
        arg6.ClientFighterCharacter.ClientFighter:Get("IsMatchmaking")
    )
    arg6._nametag:SetParent(arg6.ClientFighterCharacter.RootPart)
end

function t._Init(arg7) -- line: 69
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] LeaderboardController_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] Pages_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] Teleporting_m (copy)
    --  [7] Shutdown_m (copy)
    --  [8] GuiService (copy)

    arg7.ClientFighterCharacter.EnteredWorld:Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end)
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsSpectating"
    ):Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsInDuel"
    ):Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "Controls"
    ):Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsInDuel"
    ):Connect(function() -- line: 86
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsMatchmaking"
    ):Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter.Player:GetAttributeChangedSignal(
        "StatisticDuelsWinStreak"
    ):Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter.Player:GetAttributeChangedSignal(
        "Level"
    ):Connect(function() -- line: 98
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter.Player:GetAttributeChangedSignal(
        "DisplayELO"
    ):Connect(function() -- line: 102
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(arg7.ClientFighterCharacter.ClientFighter.Player:GetAttributeChangedSignal(
        "PlayerStatus"
    ):Connect(function() -- line: 106
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(PlayerDataController_m:GetSettingChangedSignal(
        "Hide HUD"
    ):Connect(function() -- line: 110
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(PlayerDataController_m:GetSettingChangedSignal(
        "PlayerList Leaderstat"
    ):Connect(function() -- line: 114
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(LeaderboardController_m:GetLeaderboardRefreshedSignal(
        "Highest ELO"
    ):Connect(function() -- line: 118
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(CameraController_m.StateChanged:Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 126
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(Teleporting_m.EnabledChanged:Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(Shutdown_m.EnabledChanged:Connect(function() -- line: 138
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Refresh()
    end))
    arg7.ClientFighterCharacter:AddConnection(GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(
        function() -- line: 142
            -- upvalues:
            --  [1] arg7 (copy)

            arg7:_Refresh()
        end
    ))
    arg7:_Refresh()
end

return t
