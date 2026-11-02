local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.DebugLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local InsetButtonsBar_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("InsetButtonsBar")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Inbox_m = require(Players.LocalPlayer.PlayerScripts.Modules.Pages:WaitForChild("Inbox"))
local InboxNotification = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "InboxNotification"
)
local t = {
    { "Open", "See more", "rbxassetid://14641612286", nil, nil, nil },
    {
        "Settings",
        "Change your crosshair & hotkeys",
        "rbxassetid://14641612286",
        nil,
        nil,
        "Settings"
    },
    { "PatchNotes", "Read the latest news", "rbxassetid://18457336026", nil, nil, "PatchNotes" },
    { "Restrictions", "", "rbxassetid://120647688402991", nil, nil, nil },
    { "Inbox", "View your recent notifications", "rbxassetid://96509180790493", nil, nil, "Inbox" },
    {
        "PrivateServerControls",
        "Edit your private server",
        "rbxassetid://12343093905",
        nil,
        nil,
        "PrivateServerControls"
    },
    {
        "MobileEditor",
        "Move & resize your touch buttons",
        "rbxassetid://98757786697658",
        UDim2.new(0.525, 0, 0.525, 0),
        UDim2.new(0.55, 0, 0.55, 0),
        nil
    },
    { "Freecam", "Turn on freecam mode", "rbxassetid://17548980857", nil, nil, nil }
}
local t_9 = {}
t_9.__index = t_9

function t_9.new(arg1) -- line: 35
    -- upvalues:
    --  [1] t_9 (copy)
    --  [2] InsetButtonsBar_m (copy)
    --  [3] UILibrary_m (copy)
    --  [4] InboxNotification (copy)

    local t_10 = setmetatable({}, t_9)
    t_10.Inset = arg1
    t_10.Bar = InsetButtonsBar_m.new(
        UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY,
        UILibrary_m.BUTTON_BACKGROUND_COLOR,
        UILibrary_m.BUTTON_ICON_COLOR,
        true
    )
    t_10._inbox_notification_frame = InboxNotification:Clone()
    t_10:_Init()

    return t_10
end

function t_9.GetNotificationGoal(arg2) -- line: 52
    if arg2.Bar.IsOpen then
        return arg2.Bar.Buttons.Inbox
    end

    return arg2.Bar.Buttons.Open
end

function t_9.SetVisible(arg3, arg4, arg5) -- line: 56
    arg3.Bar.Frame.Visible = arg4
    local Frame = arg3.Bar.Frame
    local v8 = arg5 or arg3.Bar.Frame.Size
    Frame.Size = v8
    arg3.Bar:Toggle(if arg3.Bar.Frame.Visible then arg3.Bar.IsOpen else false)
end

function t_9._UpdateRestrictions(arg6) -- line: 66
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CONSTANTS_m (copy)

    local R5
    local v11 = PlayerDataController_m:Get("WinsFromDuelPadsToday") >= CONSTANTS_m.MAX_DUEL_PAD_WINS_PER_DAY_BEFORE_BEING_BLOCKED and true
    local v12 = PlayerDataController_m:Get("IsRestrictedFromCasualLeaderboards")
    local v13 = PlayerDataController_m:Get("IsRestrictedFromCompetitiveLeaderboards")
    local v14 = if v11 then "You've reached the max amount of wins from duel pads today\n" else ""

    if v12 then
        local _ = "" .. v14
        v14 = "You've been restricted from casual leaderboards due to your ban history\n"
    else
        local _ = "" .. v14
        v14 = ""
    end

    if v13 then
        local _ = R5 .. v14
        v14 = "You've been restricted from competitive leaderboards due to your ban history\n"
    else
        local _ = R5 .. v14
        v14 = ""
    end

    local v19 = R5 .. v14

    if v19 == "" then
        v19 = ""
    else
        v19 = string.sub(v19, 1, #v19 - 1)
    end

    arg6.Bar.Buttons.Restrictions:SetBubbleText(v19)
    arg6.Bar.Buttons.Restrictions.Frame.Visible = if v19 == "" then false else true
end

function t_9._UpdateFreecam(arg7) -- line: 81
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] ControlsController_m (copy)

    local v21 = CameraController_m.CameraState:HasFreecamAccess()
    local v23 = if CameraController_m:GetPublicState() ~= CameraController_m.CameraState.States.CustomFreecam then false else true
    local Frame_2 = arg7.Bar.Buttons.Freecam.Frame
    local v24 = v21 and not v23 and ControlsController_m.CurrentControls == "MouseKeyboard"
    Frame_2.Visible = v24
end

function t_9._UpdateInbox(arg8) -- line: 88
    -- upvalues:
    --  [1] Inbox_m (copy)
    --  [2] Utility_m (copy)

    local v25 = Inbox_m:GetNumNewNotifications()
    arg8.Bar.Buttons.Inbox.Frame.Visible = Inbox_m:GetNumNotifications() > 0 and true
    arg8._inbox_notification_frame.Title.Text = Utility_m:PrettyNumber(v25)
    arg8._inbox_notification_frame.Parent = if v25 <= 0 then nil else if not arg8.Bar.IsOpen then arg8.Bar.Buttons.Open.Frame.Button else arg8.Bar.Buttons.Inbox.Frame.Button
end

function t_9._UpdateOpenButton(arg9) -- line: 96
    -- upvalues:
    --  [1] Players (copy)

    local Open = arg9.Bar.Buttons.Open
    local Image = Open.Frame.Button.Icon.Image
    Open:SetBubbleText(if arg9.Bar.IsOpen then "See less" else "See more")
    Open.Frame.Button.Icon.Image = if arg9.Bar.IsOpen then "rbxassetid://108220438104376" else "rbxassetid://14641612286"

    if Open.Frame.Button.Icon.Image ~= Image then
        if Open.Frame.Button:IsDescendantOf(Players) then
            Open.Frame.Button.Icon.Size = UDim2.new(0, 0, 0, 0)
            Open.Frame.Button.Icon:TweenSize(
                UDim2.new(0.5, 0, 0.5, 0),
                "Out",
                "Quint",
                0.25,
                true
            )

            return
        end

        Open.Frame.Button.Icon.Size = UDim2.new(0.5, 0, 0.5, 0)
    end
end

function t_9._UpdateMobileEditorVisibility(arg10) -- line: 113
    -- upvalues:
    --  [1] ControlsController_m (copy)

    local v29 = ControlsController_m.CurrentControls == "Touch"
    arg10.Bar.Buttons.MobileEditor.Frame.Visible = v29

    if arg10.Inset.MobileEditorBar.Bar.Frame.Visible and not v29 then
        arg10.Inset.MobileEditorBar:SetVisible(false)
    end
end

function t_9._Setup(arg11) -- line: 123
    -- upvalues:
    --  [1] t (copy)
    --  [2] Pages_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] Players (copy)

    local v35

    for key, val in pairs(t) do
        local v30, v31, v32, v33, v34
        v30, v31, v32, v33, v34, v35 = table.unpack(val)
        arg11.Bar:CreateButton(
            key,
            v30,
            v31,
            v32,
            v33,
            v34
        ).Clicked:Connect(function() -- line: 128
            -- upvalues:
            --  [1] v35 (copy)
            --  [2] Pages_m (ref)

            if v35 then
                Pages_m.PageSystem:OpenPage(v35)
            end
        end)
    end

    arg11.Bar.Buttons.Open.Clicked:Connect(function() -- line: 135
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.Bar:Toggle()
    end)
    arg11.Bar.Buttons.MobileEditor.Clicked:Connect(function() -- line: 139
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.Inset.MobileEditorBar:SetVisible(true, arg11.Bar.Frame.Size)
    end)
    arg11.Bar.Buttons.Freecam.Clicked:Connect(function() -- line: 143
        -- upvalues:
        --  [1] CameraController_m (ref)

        CameraController_m.CameraState:SetCustomFreecamEnabled(
            if CameraController_m:GetPublicState() == CameraController_m.CameraState.States.CustomFreecam then false else true
        )
    end)
    local v43 = CONSTANTS_m.IS_PRIVATE_HUB_SERVER
    local Frame_4 = arg11.Bar.Buttons.PrivateServerControls.Frame

    if v43 then
        v43 = CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId)
    end

    Frame_4.Visible = v43
    arg11.Bar.Buttons.Open.Frame.Visible = true
end

function t_9._Init(arg12) -- line: 151
    -- upvalues:
    --  [1] Inbox_m (copy)
    --  [2] ControlsController_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] PlayerDataController_m (copy)

    arg12.Bar.OpenedChanged:Connect(function() -- line: 152
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateOpenButton()
        arg12:_UpdateInbox()
    end)
    Inbox_m.NotificationAdded:Connect(function() -- line: 157
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateInbox()
    end)
    Inbox_m.NotificationQueued:Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateInbox()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 165
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateMobileEditorVisibility()
        arg12:_UpdateFreecam()
    end)
    CameraController_m.CustomFreecamStateChanged:Connect(function() -- line: 170
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateFreecam()
    end)
    CameraController_m.CameraState.FreecamAccessChanged:Connect(function() -- line: 174
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateFreecam()
    end)
    PlayerDataController_m:GetDataChangedSignal("IsBadGuy"):Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateRestrictions()
    end)
    PlayerDataController_m:GetDataChangedSignal("IsBadGuy2"):Connect(function() -- line: 182
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateRestrictions()
    end)
    PlayerDataController_m:GetDataChangedSignal("WinsFromDuelPadsToday"):Connect(function() -- line: 186
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateRestrictions()
    end)
    arg12:_Setup()
    arg12:_UpdateInbox()
    arg12:_UpdateFreecam()
    arg12:_UpdateOpenButton()
    arg12:_UpdateRestrictions()
    arg12:_UpdateMobileEditorVisibility()
    arg12:SetVisible(true)
end

return t_9
