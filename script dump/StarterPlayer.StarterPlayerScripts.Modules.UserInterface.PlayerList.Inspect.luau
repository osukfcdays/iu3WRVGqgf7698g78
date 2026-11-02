local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PrivateServerController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PrivateServerController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local QueuePadController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("QueuePadController")
)
local PartyController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PartyController")
)
local DuelController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DuelController")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local udim2 = UDim2.new(1.25, 0, 0.5, 0)
local udim2_1 = UDim2.new(0, 0, 0.5, 0)
local PlayerListInspectActionSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PlayerListInspectActionSlot"
)
local t_2 = { HoverRatio = 1, ReleaseRatio = 1 }
local t = {
    { "Invite", "Party Invite", Color3.fromRGB(100, 255, 0), "rbxassetid://89570813431745", 0.55 },
    { "Friend", "Add Friend", Color3.fromRGB(100, 255, 0), "rbxassetid://95245645462537" },
    { "Challenge", "Challenge", Color3.fromRGB(255, 150, 0), "rbxassetid://18525954682" },
    { "Spectate", "Spectate", Color3.fromRGB(255, 150, 0), "rbxassetid://77908042044589" },
    {
        "ViewProfile",
        "View Profile",
        Color3.fromRGB(0, 150, 255),
        "rbxassetid://113844621753627",
        0.65
    },
    {
        "ViewAvatar",
        "View Avatar",
        Color3.fromRGB(0, 150, 255),
        "rbxassetid://113844621753627",
        0.65
    },
    { "Gift", "Send Gift", Color3.fromRGB(255, 149, 253), "rbxassetid://127400882945494", 0.65 },
    { "Unfriend", "Remove Friend", Color3.fromRGB(255, 50, 50), "rbxassetid://99528569460280" },
    { "Block", "Block", Color3.fromRGB(255, 50, 50), "rbxassetid://71490041005019" },
    { "Unblock", "Unblock", Color3.fromRGB(255, 50, 50), "rbxassetid://71490041005019" },
    { "Kick", "Server Kick", Color3.fromRGB(255, 50, 50), "rbxassetid://76417427319315", 0.65 },
    { "Ban", "Server Ban", Color3.fromRGB(255, 50, 50), "rbxassetid://76417427319315" }
}
local t_14 = {}
t_14.__index = t_14

function t_14.new(arg1) -- line: 43
    -- upvalues:
    --  [1] t_14 (copy)

    local t_15 = setmetatable({}, t_14)
    t_15.PlayerList = arg1
    t_15.Frame = t_15.PlayerList.Container:WaitForChild("Inspect")
    t_15.Container = t_15.Frame:WaitForChild("Container")
    t_15.Layout = t_15.Container:WaitForChild("Layout")
    t_15.PlayerFrame = t_15.Container:WaitForChild("Player")
    t_15.PlayerHeadshot = t_15.PlayerFrame:WaitForChild("Headshot")
    t_15.PlayerUsername = t_15.PlayerFrame:WaitForChild("Username")
    t_15.PlayerDisplayName = t_15.PlayerFrame:WaitForChild("DisplayName")
    t_15._selected_player_list_slot = false
    t_15._action_slots = {}
    t_15:_Init()

    return t_15
end

function t_14.SetScale(arg2, arg3) -- line: 67
    arg2.Frame.Size = UDim2.new(0.95 * arg3, 0, 5, 0)
end

function t_14.SelectPlayer(arg4, arg5) -- line: 71
    -- upvalues:
    --  [1] udim2_1 (copy)
    --  [2] udim2 (copy)
    --  [3] Players (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] PartyController_m (copy)
    --  [6] QueuePadController_m (copy)
    --  [7] DuelController_m (copy)
    --  [8] Utility_m (copy)
    --  [9] WeaponStatusHandler_m (copy)

    if arg5 == arg4._selected_player_list_slot or arg5 and not arg4.PlayerList.IsOpen then
        return
    end

    arg4._selected_player_list_slot = arg5

    for _, val in pairs(arg4.PlayerList.Elements.PlayerListSlots) do
        val:SetHighlighted(arg4._selected_player_list_slot == val)
    end

    local v11 = if not arg4._selected_player_list_slot then arg4.Frame.Position else UDim2.new(
        0,
        -4,
        0,
        arg4._selected_player_list_slot.Frame.AbsolutePosition.Y - arg4.PlayerList.Container.AbsolutePosition.Y
    )
    local v12 = if not arg4._selected_player_list_slot then udim2 else udim2_1
    arg4.Frame.Position = v11
    local Container = arg4.Container
    Container.Position = if not arg4._selected_player_list_slot then arg4.Container.Position else udim2

    if arg4.Container:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
        arg4.Container:TweenPosition(
            v12,
            "Out",
            "Quint",
            0.25,
            true
        )
    else
        arg4.Container.Position = v12
    end

    if not arg4._selected_player_list_slot then
        return
    end

    v12 = arg4._selected_player_list_slot.ClientFighter.Player
    v11 = arg4._selected_player_list_slot.ClientFighter.IsLocalPlayer
    local v14 = arg4._selected_player_list_slot:IsBlocked()
    local v15 = not v14

    if v15 then
        v15 = arg4._selected_player_list_slot:IsFriend()
    end

    local v16 = CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId)
    local v17 = not v14
    local Invite = arg4._action_slots.Invite

    if v17 then
        v17 = PartyController_m:CanInvitePlayerToParty(v12)
    end

    Invite.Visible = v17
    v17 = not v14 and not v15 and not v11 and true
    arg4._action_slots.Friend.Visible = v17
    v17 = not v14
    local Challenge = arg4._action_slots.Challenge

    if v17 then
        v17 = QueuePadController_m:CanChallenge(v12)
    end

    Challenge.Visible = v17
    v17 = not v14
    local Spectate = arg4._action_slots.Spectate

    if v17 then
        v17 = if DuelController_m:GetDuel(v12) == nil then false else true
    end

    Spectate.Visible = v17
    arg4._action_slots.ViewProfile.Visible = not v14
    arg4._action_slots.ViewAvatar.Visible = not v14
    local v18 = not v14 and v15 and not v11 and true
    arg4._action_slots.Unfriend.Visible = v18
    v18 = not v14
    local Block = arg4._action_slots.Block

    if v18 then
        v18 = not v11
    end

    Block.Visible = v18
    v18 = v14
    local Unblock = arg4._action_slots.Unblock

    if v18 then
        v18 = not v11
    end

    Unblock.Visible = v18
    v18 = not v14 and not v11
    arg4._action_slots.Gift.Visible = v18
    arg4._action_slots.Kick.Visible = not v11 and v16
    arg4._action_slots.Ban.Visible = not v11 and v16
    arg4.PlayerHeadshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, v12.UserId)
    arg4.PlayerDisplayName.Text = Utility_m:GetName(
        arg4._selected_player_list_slot.ClientFighter.Player,
        v12.DisplayName,
        true
    )
    arg4.PlayerUsername.Text = "@" .. v12.Name
    WeaponStatusHandler_m:ClearStatusElements(arg4.PlayerDisplayName)
    WeaponStatusHandler_m:ApplyItemStatusToText(
        arg4.PlayerDisplayName,
        v12:GetAttribute("PlayerStatus")
    )
    arg4:_UpdateCooldowns()
end

function t_14.OnOpened(arg6) -- line: 134
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] PartyController_m (copy)
    --  [3] UserInputService (copy)
    --  [4] UILibrary_m (copy)

    arg6.PlayerList:AddOpenedConnection(QueuePadController_m.ChallengeRequestCooldownChanged:Connect(
        function() -- line: 135
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateCooldowns()
        end
    ))
    arg6.PlayerList:AddOpenedConnection(PartyController_m.InviteRequestCooldownChanged:Connect(function() -- line: 139
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateCooldowns()
    end))
    arg6.PlayerList:AddOpenedConnection(UserInputService.InputBegan:Connect(function(
        input: InputObject
    ) -- line: 143
        -- upvalues:
        --  [1] UILibrary_m (ref)
        --  [2] arg6 (copy)

        if
            UILibrary_m:IsMouseWithinBounds(
                arg6.Container.AbsolutePosition,
                arg6.Layout.AbsoluteContentSize
            )
            or UILibrary_m:IsMouseWithinBounds(
                arg6.PlayerList.Elements.Frame.AbsolutePosition,
                arg6.PlayerList.Elements.Frame.AbsoluteSize
            )
        then
            return
        end

        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            arg6:SelectPlayer(nil)
        end
    end))
    arg6:_UpdateCooldowns()
end

function t_14._UpdateCooldowns(arg8) -- line: 164
    -- upvalues:
    --  [1] QueuePadController_m (copy)
    --  [2] PartyController_m (copy)

    local v20 = arg8._selected_player_list_slot and arg8._selected_player_list_slot.ClientFighter.Player
    local v21 = v20
    local Cooldown = arg8._action_slots.Challenge.Button.Cooldown

    if v21 then
        v21 = QueuePadController_m:IsChallengeRequestOnCooldown(v20)
    end

    Cooldown.Visible = v21
    arg8._action_slots.Challenge.Button.Icon.Visible = not arg8._action_slots.Challenge.Button.Cooldown.Visible
    local v22 = v20
    local Cooldown_1 = arg8._action_slots.Invite.Button.Cooldown

    if v22 then
        v22 = PartyController_m:IsInviteRequestOnCooldown(v20)
    end

    Cooldown_1.Visible = v22
    arg8._action_slots.Invite.Button.Icon.Visible = not arg8._action_slots.Invite.Button.Cooldown.Visible
end

function t_14._SlotAdded(arg9, arg10) -- line: 174
    arg10.Clicked:Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] arg10 (copy)

        arg9:SelectPlayer(if arg9._selected_player_list_slot ~= arg10 then arg10 else nil)
    end)
    arg10:SetHighlighted(if arg9._selected_player_list_slot ~= arg10 then false else true)
end

function t_14._Setup(arg11) -- line: 182
    -- upvalues:
    --  [1] t (copy)
    --  [2] PlayerListInspectActionSlot (copy)
    --  [3] ButtonEffect_m (copy)
    --  [4] t_2 (copy)
    --  [5] PartyController_m (copy)
    --  [6] StarterGui (copy)
    --  [7] QueuePadController_m (copy)
    --  [8] DuelController_m (copy)
    --  [9] SpectateController_m (copy)
    --  [10] Pages_m (copy)
    --  [11] GuiService (copy)
    --  [12] PrivateServerController_m (copy)

    local v28

    for _, val_1 in pairs(t) do
        local v26, v27, v29, v30
        v26, v27, v28, v29, v30 = table.unpack(val_1)
        local v31 = PlayerListInspectActionSlot:Clone()
        v31.Button.Background.ImageColor3 = v28
        v31.Button.Icon.Image = v29
        v31.Button.Icon.Size = UDim2.new(0.2, 0, v30 or 0.75, 0)
        v31.Button.Title.Text = v27
        v31.Parent = arg11.Container
        arg11._action_slots[v26] = v31
        ButtonEffect_m:Add(v31.Button, nil, t_2)
        v31.Button.MouseLeave:Connect(function() --[[ unhover ]] -- line: 195
            -- upvalues:
            --  [1] v31 (copy)
            --  [2] v28 (copy)

            v31.Button.Background.ImageColor3 = v28
            v31.Button.Background.ImageTransparency = 0.5
            v31.Button.Background.UIGradient.Enabled = true
            v31.Button.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            v31.Button.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        v31.Button.MouseEnter:Connect(function() --[[ hover ]] -- line: 205
            -- upvalues:
            --  [1] v31 (copy)

            v31.Button.Background.ImageColor3 = Color3.fromRGB(255, 255, 255)
            v31.Button.Background.ImageTransparency = 0
            v31.Button.Background.UIGradient.Enabled = false
            v31.Button.Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
            v31.Button.Title.TextColor3 = Color3.fromRGB(0, 0, 0)
        end)
    end

    arg11._action_slots.Invite.Button.MouseButton1Click:Connect(function() -- line: 216
        -- upvalues:
        --  [1] PartyController_m (ref)
        --  [2] arg11 (copy)

        PartyController_m:SendPartyInvite(arg11._selected_player_list_slot.ClientFighter.Player)
    end)
    arg11._action_slots.Friend.Button.MouseButton1Click:Connect(function() -- line: 220
        -- upvalues:
        --  [1] StarterGui (ref)
        --  [2] arg11 (copy)

        StarterGui:SetCore(
            "PromptSendFriendRequest",
            arg11._selected_player_list_slot.ClientFighter.Player
        )
    end)
    arg11._action_slots.Challenge.Button.MouseButton1Click:Connect(function() -- line: 224
        -- upvalues:
        --  [1] QueuePadController_m (ref)
        --  [2] arg11 (copy)

        QueuePadController_m:SendChallengeRequest(
            arg11._selected_player_list_slot.ClientFighter.Player
        )
    end)
    arg11._action_slots.Spectate.Button.MouseButton1Click:Connect(function() -- line: 228
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] DuelController_m (ref)
        --  [3] SpectateController_m (ref)

        arg11._action_slots.Spectate.Visible = false
        local v32 = DuelController_m:GetDuel(arg11._selected_player_list_slot.ClientFighter.Player)

        if v32 then
            SpectateController_m:SpectateDuelRequest(v32)
        end
    end)
    arg11._action_slots.ViewProfile.Button.MouseButton1Click:Connect(function() -- line: 238
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] Pages_m (ref)

        local Player = arg11._selected_player_list_slot.ClientFighter.Player
        Pages_m.PageSystem:OpenPage("ViewProfile")
        Pages_m.PageSystem:WaitForPage("ViewProfile"):Fetch(Player)
    end)
    arg11._action_slots.ViewAvatar.Button.MouseButton1Click:Connect(function() -- line: 245
        -- upvalues:
        --  [1] GuiService (ref)
        --  [2] arg11 (copy)

        GuiService:InspectPlayerFromUserId(
            arg11._selected_player_list_slot.ClientFighter.Player.UserId
        )
    end)
    arg11._action_slots.Unfriend.Button.MouseButton1Click:Connect(function() -- line: 249
        -- upvalues:
        --  [1] StarterGui (ref)
        --  [2] arg11 (copy)

        StarterGui:SetCore("PromptUnfriend", arg11._selected_player_list_slot.ClientFighter.Player)
    end)
    arg11._action_slots.Block.Button.MouseButton1Click:Connect(function() -- line: 253
        -- upvalues:
        --  [1] StarterGui (ref)
        --  [2] arg11 (copy)

        StarterGui:SetCore(
            "PromptBlockPlayer",
            arg11._selected_player_list_slot.ClientFighter.Player
        )
    end)
    arg11._action_slots.Unblock.Button.MouseButton1Click:Connect(function() -- line: 257
        -- upvalues:
        --  [1] StarterGui (ref)
        --  [2] arg11 (copy)

        StarterGui:SetCore(
            "PromptUnblockPlayer",
            arg11._selected_player_list_slot.ClientFighter.Player
        )
    end)
    arg11._action_slots.Gift.Button.MouseButton1Click:Connect(function() -- line: 261
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] Pages_m (ref)

        local Player_1 = arg11._selected_player_list_slot.ClientFighter.Player
        Pages_m.PageSystem:OpenPage("Gifting")
        Pages_m.PageSystem:WaitForPage("Gifting"):SelectPlayer(Player_1)
        Pages_m.PageSystem:WaitForPage("Gifting"):DontRedirect()
    end)
    arg11._action_slots.Kick.Button.MouseButton1Click:Connect(function() -- line: 269
        -- upvalues:
        --  [1] PrivateServerController_m (ref)
        --  [2] arg11 (copy)

        PrivateServerController_m:ServerKick(arg11._selected_player_list_slot.ClientFighter.Player)
    end)
    arg11._action_slots.Ban.Button.MouseButton1Click:Connect(function() -- line: 273
        -- upvalues:
        --  [1] PrivateServerController_m (ref)
        --  [2] arg11 (copy)

        PrivateServerController_m:ServerBan(arg11._selected_player_list_slot.ClientFighter.Player)
    end)
end

function t_14._Init(arg12) -- line: 278
    arg12.PlayerList.OpenedChanged:Connect(function() -- line: 279
        -- upvalues:
        --  [1] arg12 (copy)

        if not arg12.PlayerList.IsOpen then
            arg12:SelectPlayer(nil)
        end
    end)
    arg12.PlayerList.Elements.PlayerListSlotRemoved:Connect(function(arg13) -- line: 285
        -- upvalues:
        --  [1] arg12 (copy)

        if arg13 == arg12._selected_player_list_slot then
            arg12:SelectPlayer(nil)
        end
    end)
    arg12.PlayerList.Elements.PlayerListSlotAdded:Connect(function(arg14) -- line: 291
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_SlotAdded(arg14)
    end)

    for _, val_2 in pairs(arg12.PlayerList.Elements.PlayerListSlots) do
        task.defer(arg12._SlotAdded, arg12, val_2)
    end

    arg12:_Setup()
    arg12:SelectPlayer(nil)
end

return t_14
