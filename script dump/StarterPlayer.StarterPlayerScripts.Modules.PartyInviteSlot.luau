local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SocialService = game:GetService("SocialService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local QueuePadController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.QueuePadController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local SocialController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.SocialController)
local PartyController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PartyController)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local PartyInviteSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PartyInviteSlot"
)
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3, arg4) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] PartyInviteSlot (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = PartyInviteSlot:Clone()
    t_1._destroyed = false
    t_1._player_object = arg1
    t_1._user_id = arg2 or t_1._player_object and t_1._player_object.UserId or nil
    t_1._display_name = arg3 or t_1._player_object and t_1._player_object.DisplayName or nil
    t_1._username = arg4 or t_1._player_object and t_1._player_object.Name or nil
    t_1:_Init()

    return t_1
end

function t.StillHere(arg5) -- line: 39
    -- upvalues:
    --  [1] Players (copy)

    return arg5._player_object and arg5._player_object.Parent == Players
end

function t.GetUserID(arg6) -- line: 43
    return arg6._user_id
end

function t.UpdateCooldowns(arg7) -- line: 47
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] PartyController_m (copy)

    arg7.Frame.Buttons.Challenge.Button.Off.Visible = QueuePadController_m:IsChallengeRequestOnCooldown(
        arg7._player_object
    )
    arg7.Frame.Buttons.Challenge.Button.On.Visible = not arg7.Frame.Buttons.Challenge.Button.Off.Visible
    arg7.Frame.Buttons.Invite.Button.Off.Visible = PartyController_m:IsInviteRequestOnCooldown(
        arg7._player_object
    )
    arg7.Frame.Buttons.Invite.Button.On.Visible = not arg7.Frame.Buttons.Invite.Button.Off.Visible
end

function t.Destroy(arg8) -- line: 54
    arg8._destroyed = true
    arg8.Frame:Destroy()
end

function t._Update(arg9) -- line: 63
    arg9.Frame.DisplayName.Controls.Position = UDim2.new(
        0,
        arg9.Frame.DisplayName.TextBounds.X,
        0.5,
        0
    )
end

function t._CheckFriendsWith(arg10) -- line: 67
    -- upvalues:
    --  [1] SocialController_m (copy)

    if arg10._destroyed or not SocialController_m:IsFriendsWith(arg10._user_id) then
        return
    end

    arg10.Frame.Name = "Friends"
    local Frame = arg10.Frame
    Frame.LayoutOrder += 999999
end

function t._Setup(arg11) -- line: 80
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] QueuePadController_m (copy)
    --  [3] PartyController_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] ComplianceController_m (copy)

    local v3 = FighterController_m:GetFighter(arg11._player_object)
    arg11.Frame.Buttons.Challenge.Visible = QueuePadController_m:CanChallenge(arg11._player_object)
    arg11.Frame.Buttons.Invite.Visible = PartyController_m:CanInvitePlayerToParty(
        arg11._player_object
    )
    arg11.Frame.Buttons.InviteExternal.Visible = not arg11._player_object
    arg11.Frame.Icon.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg11._user_id)
    local Controls_1 = arg11.Frame.DisplayName.Controls
    local v4 = v3 and CONSTANTS_m.CONTROLS_IMAGES[v3:Get("Controls")] or ""
    Controls_1.Image = v4
    local DisplayName = arg11.Frame.DisplayName
    v4 = arg11._player_object and ComplianceController_m:GetName(arg11._player_object) or arg11._display_name or ""
    DisplayName.Text = v4
    local Username = arg11.Frame.Username

    if arg11._player_object then
        v4 = "@" .. arg11._player_object.Name

        if not v4 then
            v4 = arg11._username and "@" .. arg11._username or ""
        end
    else
        v4 = arg11._username and "@" .. arg11._username or ""
    end

    Username.Text = v4
    arg11.Frame.Name = "Lobby"
    arg11.Frame.LayoutOrder = 0
end

function t._Init(arg12) -- line: 94
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] PartyController_m (copy)
    --  [3] HttpService (copy)
    --  [4] ReplicatedStorage (copy)
    --  [5] SocialService (copy)
    --  [6] Players (copy)
    --  [7] ButtonEffect_m (copy)

    arg12.Frame.DisplayName:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 95
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_Update()
    end)
    arg12.Frame.Buttons.Challenge.Button.MouseButton1Click:Connect(function() -- line: 99
        -- upvalues:
        --  [1] QueuePadController_m (ref)
        --  [2] arg12 (copy)

        QueuePadController_m:SendChallengeRequest(arg12._player_object)
    end)
    arg12.Frame.Buttons.Invite.Button.MouseButton1Click:Connect(function() -- line: 103
        -- upvalues:
        --  [1] PartyController_m (ref)
        --  [2] arg12 (copy)

        PartyController_m:SendPartyInvite(arg12._player_object)
    end)
    arg12.Frame.Buttons.InviteExternal.Button.MouseButton1Click:Connect(function() -- line: 107
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] HttpService (ref)
        --  [3] ReplicatedStorage (ref)
        --  [4] SocialService (ref)
        --  [5] Players (ref)

        local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions")
        ExperienceInviteOptions.PromptMessage = "Invite to your party!"
        ExperienceInviteOptions.InviteMessageId = "466fc19d-8334-514f-80e7-cba27e22bc22"
        ExperienceInviteOptions.InviteUser = arg12._user_id
        local t_2 = {
            PartyInviteHash = ReplicatedStorage.Remotes.Matchmaking.RequestPartyInviteData:InvokeServer()
        }
        ExperienceInviteOptions.LaunchData = HttpService:JSONEncode(t_2)
        SocialService:PromptGameInvite(Players.LocalPlayer, ExperienceInviteOptions)
        arg12.Frame.Buttons.InviteExternal.Button.On.Visible = false
        arg12.Frame.Buttons.InviteExternal.Button.Off.Visible = true
    end)
    arg12:_Setup()
    arg12:_Update()
    arg12:UpdateCooldowns()
    task.defer(arg12._CheckFriendsWith, arg12)
    ButtonEffect_m:Add(arg12.Frame.Buttons.Invite.Button)
    ButtonEffect_m:Add(arg12.Frame.Buttons.InviteExternal.Button)
    ButtonEffect_m:Add(arg12.Frame.Buttons.Challenge.Button)
end

return t
