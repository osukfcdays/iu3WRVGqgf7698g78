local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local QueuePadController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local SocialController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SocialController")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local PlayerList_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("PlayerList")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local JoinQueuePadSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("JoinQueuePadSlot")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local RequestChallengeSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "RequestChallengeSlot"
)
local RequestPartySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "RequestPartySlot"
)
local t = {}
t.__index = t

function t._new() -- line: 27
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Lobby", "Requests")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.PlayerListBuffer = t_1.Container:WaitForChild("PlayerListBuffer")
    t_1:_Init()

    return t_1
end

function t.SendRequest(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6
) -- line: 43
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] UILibrary_m (copy)
    --  [3] ComplianceController_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] ButtonEffect_m (copy)
    --  [6] PlayerList_m (copy)

    if not arg2 then
        return
    end

    local v15 = FighterController_m:GetFighter(arg2)
    local v16 = arg3:Clone()
    v16.Container.Background.ImageColor3 = UILibrary_m.BUTTON_BACKGROUND_COLOR
    v16.Container.Background.ImageTransparency = UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY
    v16.Container.DisplayName.Text = ComplianceController_m:GetName(arg2)
    local v17 = v15
    local Controls = v16.Container.DisplayName.Controls
    local CONTROLSIMAGES = CONSTANTS_m.CONTROLS_IMAGES

    if v17 then
        v17 = v15:Get("Controls")
    end

    Controls.Image = CONTROLSIMAGES[v17] or ""
    v16.Container.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg2.UserId)
    v16.Parent = arg1.Container
    ButtonEffect_m:Add(v16.Container.Accept)
    ButtonEffect_m:Add(v16.Container.Decline)

    local function remove() -- line: 60
        -- upvalues:
        --  [1] v16 (copy)
        --  [2] arg5 (copy)
        --  [3] PlayerList_m (ref)
        --  [4] arg2 (copy)

        v16:Destroy()

        if arg5 then
            PlayerList_m:SetRequestDuration(arg2, arg5, 0)
        end
    end

    v16.Container.Decline.MouseButton1Click:Connect(remove)
    task.delay(arg4, remove)
    v16.Container.Accept.MouseButton1Click:Connect(function() -- line: 71
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] v16 (copy)
        --  [3] arg5 (copy)
        --  [4] PlayerList_m (ref)
        --  [5] arg2 (copy)

        if arg6 then
            arg6()
        end

        v16:Destroy()

        if arg5 then
            PlayerList_m:SetRequestDuration(arg2, arg5, 0)
        end
    end)
    v16.Container.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ update ]] -- line: 79
        -- upvalues:
        --  [1] v16 (copy)

        v16.Container.DisplayName.Controls.Position = UDim2.new(
            0,
            v16.Container.DisplayName.TextBounds.X,
            0.5,
            0
        )
    end)
    v16.Container.DisplayName.Controls.Position = UDim2.new(
        0,
        v16.Container.DisplayName.TextBounds.X,
        0.5,
        0
    )
    v16.Container.Position = UDim2.new(4, 0, 0, 0)
    v16.Container:TweenPosition(
        UDim2.new(0, 0, 0, 0),
        "Out",
        "Quint",
        0.5,
        true
    )
    v16.Container.Timeout.Bar.Size = UDim2.new(1, 0, 1, 0)
    v16.Container.Timeout.Bar:TweenSize(
        UDim2.new(0, 0, 1, 0),
        "Out",
        "Linear",
        arg4,
        true
    )

    if arg5 then
        PlayerList_m:SetRequestDuration(arg2, arg5, arg4)
    end
end

function t.ChallengeRequest(arg7, arg8, arg9) -- line: 96
    -- upvalues:
    --  [1] RequestChallengeSlot (copy)
    --  [2] ReplicatedStorage (copy)

    if not arg7:_CanReceiveRequest(arg8, "Challenge Requests") then
        return
    end

    arg7:SendRequest(
        arg8,
        RequestChallengeSlot,
        arg9,
        "Challenge",
        function() -- line: 101
            -- upvalues:
            --  [1] ReplicatedStorage (ref)
            --  [2] arg8 (copy)

            ReplicatedStorage.Remotes.Misc.AcceptChallengeRequest:FireServer(arg8)
        end
    )
end

function t.PartyRequest(arg10, arg11, arg12) -- line: 106
    -- upvalues:
    --  [1] RequestPartySlot (copy)
    --  [2] ReplicatedStorage (copy)

    if not arg10:_CanReceiveRequest(arg11, "Party Invites") then
        return
    end

    arg10:SendRequest(
        arg11,
        RequestPartySlot,
        arg12,
        "Party",
        function() -- line: 111
            -- upvalues:
            --  [1] ReplicatedStorage (ref)
            --  [2] arg11 (copy)

            ReplicatedStorage.Remotes.Matchmaking.AcceptPartyInvite:FireServer(arg11)
        end
    )
end

function t._UpdatePlayerList(arg13) -- line: 120
    -- upvalues:
    --  [1] PlayerList_m (copy)

    local v18 = PlayerList_m.Elements.Frame.AbsolutePosition.Y - PlayerList_m.Frame.AbsolutePosition.Y
    local v19 = if PlayerList_m.IsOpen then PlayerList_m.Elements.Frame.AbsoluteSize.Y else -4
    arg13.PlayerListBuffer:TweenSize(
        UDim2.new(1, 0, 0, v18 + v19),
        "Out",
        "Quint",
        0.25,
        true
    )
    arg13.Container.Size = UDim2.new(
        0,
        PlayerList_m.Elements.Frame.AbsoluteSize.X,
        0,
        PlayerList_m.Elements.Frame.AbsoluteSize.X
    )
end

function t._UpdateVisibility(arg14) -- line: 127
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] GuiService (copy)

    local v20 = not Pages_m.PageSystem.CurrentPage

    if v20 then
        v20 = not Equipment_m.IsOpen

        if v20 then
            v20 = not Queue_m:IsVisible()

            if v20 then
                v20 = not Teleporting_m.Enabled and not MobileInputs_m.EditorEnabled and not GuiService.MenuIsOpen
            end
        end
    end

    arg14.Container:TweenPosition(
        if not v20 then UDim2.new(2, 20, 0, 0) else UDim2.new(1, 0, 0, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t._CanReceiveRequest(_, arg16, arg17) -- line: 133
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SocialController_m (copy)

    local v22 = PlayerDataController_m:GetSetting(arg17)

    if v22 == "Everyone" then
        return true
    end

    if v22 == "Friends" then
        return (SocialController_m:IsFriendsWith(arg16.UserId))
    end

    return false
end

function t._QueuePadAdded(arg18, arg19) -- line: 141
    -- upvalues:
    --  [1] JoinQueuePadSlot_m (copy)

    JoinQueuePadSlot_m.new(arg19).Frame.Parent = arg18.Container
end

function t._Init(arg20) -- line: 146
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] Pages_m (copy)
    --  [3] Queue_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] MobileInputs_m (copy)
    --  [6] GuiService (copy)
    --  [7] PlayerList_m (copy)
    --  [8] QueuePadController_m (copy)

    Equipment_m.Opened:Connect(function() -- line: 147
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 151
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 155
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 159
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 163
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 167
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 171
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateVisibility()
    end)
    PlayerList_m.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayerList()
    end)
    PlayerList_m.Elements.Frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 179
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayerList()
    end)
    PlayerList_m.Elements.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 183
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayerList()
    end)
    PlayerList_m.OpenedChanged:Connect(function() -- line: 187
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdatePlayerList()
    end)
    QueuePadController_m.ObjectAdded:Connect(function(arg21) -- line: 191
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_QueuePadAdded(arg21)
    end)

    for _, val in pairs(QueuePadController_m.Objects) do
        task.defer(arg20._QueuePadAdded, arg20, val)
    end

    arg20:_UpdateVisibility()
    arg20:_UpdatePlayerList()
end

return t._new()
