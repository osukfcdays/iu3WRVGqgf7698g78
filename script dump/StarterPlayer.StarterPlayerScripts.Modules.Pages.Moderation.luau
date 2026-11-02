local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserService = game:GetService("UserService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local ModerationLibrary_m = require(ReplicatedStorage.Modules.ModerationLibrary)
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local BanLibrary_m = require(ReplicatedStorage.Modules.BanLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local DropdownSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot")
)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RankIcon"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = {
    { "permission_moderation_modpanel_access" },
    {
        "permission_moderation_modpanel_viewbanned_full",
        "permission_moderation_modpanel_viewactions_full",
        "permission_moderation_modpanel_viewdata_limited",
        "permission_moderation_modpanel_viewdata_most",
        "permission_moderation_modpanel_viewdata_full"
    },
    { "permission_moderation_modpanel_teleport_full" },
    { "permission_moderation_modpanel_warn_template", "permission_moderation_modpanel_warn_custom" },
    { "permission_moderation_modpanel_evict_limited", "permission_moderation_modpanel_evict_full" },
    {
        "permission_moderation_modpanel_moderate_limited",
        "permission_moderation_modpanel_moderate_most",
        "permission_moderation_modpanel_moderate_full",
        "permission_moderation_modpanel_unban"
    },
    { "permission_moderation_modpanel_restrict" },
    {
        "permission_moderation_modpanel_removelbs_limited",
        "permission_moderation_modpanel_investigate_full"
    },
    {
        "permission_moderation_modpanel_pardon_limited",
        "permission_moderation_modpanel_pardon_full"
    },
    { "permission_moderation_modpanel_lock" }
}
local t_11 = setmetatable({}, Page_m)
t_11.__index = t_11

function t_11._new() -- line: 66
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_11 (copy)
    --  [3] PromptSystem_m (copy)

    local t_12 = setmetatable(Page_m.new(script.Name), t_11)
    t_12.PromptsFrame = t_12.PageFrame:WaitForChild("Prompts")
    t_12.PageContainer = t_12.PageFrame:WaitForChild("Container")
    t_12.CloseButton = t_12.PageContainer:WaitForChild("Close")
    t_12.List = t_12.PageContainer:WaitForChild("List")
    t_12.Container = t_12.List:WaitForChild("Container")
    t_12.Layout = t_12.Container:WaitForChild("Layout")
    t_12.HeaderFrame = t_12.Container:WaitForChild("Header")
    t_12.InfoButton = t_12.HeaderFrame:WaitForChild("Info")
    t_12.InfoButtonBubble = t_12.InfoButton:WaitForChild("Bubble")
    t_12.InfoButtonBubbleTitle = t_12.InfoButtonBubble:WaitForChild("Title")
    t_12.InfoButtonBubbleBackground = t_12.InfoButtonBubble:WaitForChild("Background")
    t_12.PowersButton = t_12.HeaderFrame:WaitForChild("Powers")
    t_12.PowersButtonBubble = t_12.PowersButton:WaitForChild("Bubble")
    t_12.PowersButtonBubbleTitle = t_12.PowersButtonBubble:WaitForChild("Container"):WaitForChild(
        "Title"
    )
    t_12.LookupFrame = t_12.Container:WaitForChild("Lookup")
    t_12.LookupBox = t_12.LookupFrame:WaitForChild("Box")
    t_12.LookupButton = t_12.LookupFrame:WaitForChild("Button")
    t_12.LookupDropdownButton = t_12.LookupFrame:WaitForChild("Dropdown")
    t_12.DropdownReferenceFrame = t_12.LookupFrame:WaitForChild("DropdownReference")
    t_12.InvestigateFrame = t_12.Container:WaitForChild("Investigate")
    t_12.InvestigateContainer = t_12.InvestigateFrame:WaitForChild("Container")
    t_12.InvestigateWinStreaksFrame = t_12.InvestigateContainer:WaitForChild("Top100WinStreaks")
    t_12.InvestigateWinStreaksButton = t_12.InvestigateWinStreaksFrame:WaitForChild("Button")
    t_12.InvestigateTrueWinStreaksFrame = t_12.InvestigateContainer:WaitForChild(
        "Top100TrueWinStreaks"
    )
    t_12.InvestigateTrueWinStreaksButton = t_12.InvestigateTrueWinStreaksFrame:WaitForChild(
        "Button"
    )
    t_12.PlayerFrame = t_12.Container:WaitForChild("Player")
    t_12.PlayerWaitingFrame = t_12.PlayerFrame:WaitForChild("Waiting")
    t_12.PlayerWaitingDotsFrame = t_12.PlayerWaitingFrame:WaitForChild("Dots")
    t_12.PlayerLoadedFrame = t_12.PlayerFrame:WaitForChild("Loaded")
    t_12.PlayerLoadedActionsFrame = t_12.PlayerLoadedFrame:WaitForChild("Actions")
    t_12.PlayerLoadedInformationFrame = t_12.PlayerLoadedFrame:WaitForChild("Information")
    t_12.PlayerLoadedInformationPicture = t_12.PlayerLoadedInformationFrame:WaitForChild("Picture"):WaitForChild(
        "Picture"
    )
    t_12.PromptSystem = PromptSystem_m.new(t_12.PromptsFrame)
    t_12._ban_data = nil
    t_12._result_data = nil
    t_12._player_data = nil
    t_12._player_metadata = nil
    t_12._is_this_dude_banned = false
    t_12._ban_data_hash = 0
    t_12._lookup_disabled = false
    t_12._player_data_debounce = false
    t_12._last_rank_icon = nil
    t_12._dropdown_slot = nil
    t_12._cached_players = {}
    t_12:_Init()

    return t_12
end

function t_11.SetBanData(arg1, arg2, arg3, arg4) -- line: 125
    -- upvalues:
    --  [1] BanLibrary_m (copy)
    --  [2] ServerOsTime_m (copy)
    --  [3] SeasonLibrary_m (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] Utility_m (copy)
    --  [6] RankIcon_m (copy)
    --  [7] UserService (copy)

    local v8 = not arg3 or (if typeof(arg3) ~= "table" then false else true)
    assert(v8, "Argument 1 invalid, expected a table or nil, got " .. tostring(arg3))
    v8 = not arg4 or (if typeof(arg4) ~= "table" then false else true)
    assert(v8, "Argument 2 invalid, expected a table or nil, got " .. tostring(arg4))
    local v9

    if not arg2 then
        v9 = arg3 and arg3.UserID
        v8 = arg1._ban_data

        if v8 then
            v8 = arg1._ban_data.UserID
        end

        if v9 ~= v8 then
            return
        end
    end

    arg1._ban_data = arg3
    arg1._result_data = arg4
    v9 = arg1._result_data and arg1._result_data.RawData or nil
    arg1._player_data = v9
    v9 = arg1._result_data and arg1._result_data.Metadata or nil
    arg1._player_metadata = v9
    arg1._is_this_dude_banned = nil
    arg1._ban_data_hash += 1
    local PlayerLoadedFrame = arg1.PlayerLoadedFrame
    PlayerLoadedFrame.Visible = arg1._ban_data ~= nil

    if arg1._last_rank_icon then
        arg1._last_rank_icon:Destroy()
        arg1._last_rank_icon = nil
    end

    if not arg1._ban_data then
        return
    end

    local BanDataHash = arg1._ban_data_hash
    local v11 = BanLibrary_m:IsBanned(arg1._ban_data)
    local v12 = v11

    if v12 then
        v12 = math.max(0, v11.EndTime - ServerOsTime_m:GetRounded())
    end

    local v13 = arg1._player_data and arg1._player_data.RedFlags and arg1._player_data.RedFlags[#arg1._player_data.RedFlags]
    local v14 = arg1._player_data and arg1._player_data.SessionID ~= nil
    local v15 = arg1._player_data and arg1._player_data.Level
    local v16 = arg1._player_data and arg1._player_data.StatisticDuelsWinStreak
    local v17 = arg1._player_data and arg1._player_data.LastKnownControls
    local v18 = arg1._player_data and arg1._player_data.Seasons and arg1._player_data.Seasons[SeasonLibrary_m.CurrentSeason.Name] and arg1._player_data.Seasons[SeasonLibrary_m.CurrentSeason.Name].RankedPerformances[SeasonLibrary_m.UNIVERSAL_ELO_NAME]
    local v19 = v18 and v18.CurrentELO
    local v20 = v18

    if v20 then
        v20 = SeasonLibrary_m:GetHighestELOLeaderboardRanking(v19, arg1._ban_data.UserID)
    end

    local v21 = v18

    if v21 then
        v21 = SeasonLibrary_m:GetRank(v19, arg1._ban_data.UserID, v20)
    end

    local v22 = v21 and SeasonLibrary_m.CurrentSeason.RankProfile.Ranks[v21]
    v21 = if not arg1._ban_data.BanLocked then "" else "\240\159\148\146"
    local v23 = arg1._ban_data.Restrictions and arg1._ban_data.Restrictions.RestrictedFromCasualLeaderboards
    local v24 = arg1._ban_data.Restrictions and arg1._ban_data.Restrictions.RestrictedFromCompetitiveLeaderboards
    local v25 = 0
    local v26 = 0

    for _, val in pairs(arg1._ban_data.BanHistory) do
        if BanLibrary_m:IsBanLogAWarning(val) then
            v25 += 1
        end

        if BanLibrary_m:IsBanLogABan(val) then
            v26 += 1
        end
    end

    arg1._is_this_dude_banned = v11 ~= nil
    arg1.PlayerLoadedInformationPicture.Image = string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        (tostring(arg1._ban_data.UserID))
    )
    arg1:_SetInformationFrameVisible("ELO", v18)
    local v28 = v19 and Utility_m:PrettyNumber(v19) or "N/A"
    arg1:_SetInformationFrameText(
        "ELO",
        v28 .. " " .. (v22 and v22.DisplayName or "N/A") .. " " .. (v20 and " #" .. v20 or "")
    )
    arg1:_SetInformationFrameVisible("Level", v15)
    local v32 = v15 and Utility_m:PrettyNumber(v15) or ""
    arg1:_SetInformationFrameText("Level", v32)
    v32 = v16

    if v32 then
        v32 = v16 > 0
    end

    arg1:_SetInformationFrameVisible("WinStreak", v32)
    v32 = v16 and v16 > 0 and Utility_m:PrettyNumber(v16) or ""
    arg1:_SetInformationFrameText("WinStreak", v32)
    arg1:_SetInformationFrameVisible("Controls", v17)
    arg1:_SetInformationFrameText("Controls", v17 or "")
    arg1:_SetInformationFrameText("Username", "@" .. arg1._ban_data.Name)
    arg1:_SetInformationFrameText("DisplayName", "\226\128\162 \226\128\162 \226\128\162")
    arg1:_SetInformationFrameText("UserID", "#" .. tostring(arg1._ban_data.UserID))
    arg1:_SetInformationFrameText(
        "Online",
        if v14 then "\240\159\159\162 Online" else "\240\159\148\180 Offline"
    )
    local v34 = if arg1._ban_data.BanLocked then "Locked" else "Not locked"
    local v35 = arg1._ban_data.BanLocked and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(
        100,
        255,
        50
    )
    arg1:_SetInformationFrameText("Lock", v34, v35)
    local v37 = v11 and "Banned [" .. (if v11.Duration and v11.Duration >= BanLibrary_m.PERMANENT_BAN_DURATION then "Permanent" else Utility_m:TimeFormat2(
        v12
    )) .. "]" or "Not banned"
    v34 = v21 .. v37
    local v38 = v11 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
    arg1:_SetInformationFrameText("Status", v34, v38)
    local v39, v40

    if v11 then
        v39 = "\240\159\154\168 " .. v11.Reason

        if not v39 then
            if v26 > 0 then
                v40 = if v26 ~= 1 then "s" else ""
                v39 = "Banned " .. v26 .. " time" .. v40 or "No ban history"
            else
                v39 = "No ban history"
            end
        end
    elseif v26 > 0 then
        v40 = if v26 ~= 1 then "s" else ""
        v39 = "Banned " .. v26 .. " time" .. v40 or "No ban history"
    else
        v39 = "No ban history"
    end

    local v41 = v21 .. v39
    local v42 = v11 and Color3.fromRGB(255, 50, 50) or v26 > 0 and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(
        100,
        255,
        50
    )
    arg1:_SetInformationFrameText("History", v41, v42)
    local v44 = v21 .. (v13 and tostring(v13.Reason) or "Not flagged")
    local v45 = v13 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
    arg1:_SetInformationFrameText("Flags", v44, v45)
    local v47 = v21 .. (if v23 then "Restricted" else "Not restricted")
    local v48 = v23 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
    arg1:_SetInformationFrameText("CasualLBs", v47, v48)
    local v50 = v21 .. (if v24 then "Restricted" else "Not restricted")
    local v51 = v24 and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(100, 255, 50)
    arg1:_SetInformationFrameText("CompLBs", v50, v51)
    local v53

    if v25 > 0 then
        v53 = v25 .. " warning" .. (if v25 ~= 1 then "s" else "") or "No warnings"
    else
        v53 = "No warnings"
    end

    local v54 = v21 .. v53
    local v55 = v25 > 0 and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(100, 255, 50)
    arg1:_SetInformationFrameText("Warnings", v54, v55)

    if v18 then
        arg1._last_rank_icon = RankIcon_m.new(v19, arg1._ban_data.UserID)
        arg1._last_rank_icon:SetParent(arg1.PlayerRank)
    end

    task.spawn(function() -- line: 209
        -- upvalues:
        --  [1] UserService (ref)
        --  [2] arg1 (copy)
        --  [3] BanDataHash (copy)

        local v56 = UserService:GetUserInfosByUserIdsAsync({ arg1._ban_data.UserID })

        if BanDataHash ~= arg1._ban_data_hash or not v56[1] or not v56[1].DisplayName then
            return
        end

        arg1:_SetInformationFrameText("DisplayName", v56[1].DisplayName)
    end)
    arg1:_UpdatePermissions()
end

function t_11.Open(arg5, ...) -- line: 226
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] ReplicatedStorage (copy)

    Page_m.Open(arg5, ...)
    task.spawn(function() -- line: 229
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] ReplicatedStorage (ref)

        local v57 = arg5
        v57._cached_players = ReplicatedStorage.Remotes.Moderator.RequestCachedPlayers:InvokeServer() or arg5._cached_players
    end)
end

function t_11._SetActionButtonVisible(arg6, arg7, arg8) -- line: 238
    arg6.PlayerLoadedActionsFrame:WaitForChild(arg7).Visible = arg8
end

function t_11._SetInformationFrameText(arg9, arg10, arg11, arg12) -- line: 242
    arg9.PlayerLoadedInformationFrame:WaitForChild(arg10):WaitForChild("Value").Text = arg11
    local Value = arg9.PlayerLoadedInformationFrame:WaitForChild(arg10):WaitForChild("Value")
    Value.TextColor3 = arg12 or Color3.fromRGB(255, 255, 255)
end

function t_11._SetInformationFrameVisible(arg13, arg14, arg15) -- line: 247
    arg13.PlayerLoadedInformationFrame:WaitForChild(arg14).Visible = arg15
end

function t_11._UpdatePowersButtonBubble(arg16) -- line: 251
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] t (copy)
    --  [3] PermissionsLibrary_m (copy)

    local v60 = PlayerDataController_m:Get("PermissionsRoles")
    local v61 = ""

    for key_1, val_1 in pairs(t) do
        if key_1 > 1 then
            v61 ..= "\n\n"
        end

        for key_2, val_2 in pairs(val_1) do
            if key_2 > 1 then
                v61 ..= "\n"
            end

            v61 = v61 .. string.format(
                "%s %s",
                if PermissionsLibrary_m:HasPermission(val_2, v60) then "\226\156\133" else "\240\159\159\165",
                PermissionsLibrary_m.Permissions[val_2].Description
            )
        end
    end

    arg16.PowersButtonBubbleTitle.Text = v61
end

function t_11._UpdatePermissions(arg17) -- line: 272
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ModerationLibrary_m (copy)

    local v67 = PlayerDataController_m:Get("PermissionsRoles")
    local v68 = arg17._ban_data

    if v68 then
        v68 = arg17._ban_data.BanLocked
    end

    for _, val_3 in pairs({ "Status", "CasualLBs", "CompLBs", "Flags", "History" }) do
        arg17:_SetInformationFrameVisible(val_3, ModerationLibrary_m:CanViewBanStatusAndLogs(v67))
    end

    arg17.InvestigateFrame.Visible = ModerationLibrary_m:CanUseInvestigativeCommands(v67)
    arg17:_SetActionButtonVisible("ViewLogs", ModerationLibrary_m:CanViewBanStatusAndLogs(v67))
    arg17:_SetActionButtonVisible("ViewData", ModerationLibrary_m:CanViewData(v67))
    arg17:_SetActionButtonVisible("ViewActions", ModerationLibrary_m:CanViewActionHistory(v67))
    arg17:_SetActionButtonVisible("Lock", ModerationLibrary_m:CanManageBanLocks(v67))
    local v69 = not v68

    if v69 then
        v69 = ModerationLibrary_m:CanEvict(v67)
    end

    arg17:_SetActionButtonVisible("Kick", v69)
    v69 = not v68

    if v69 then
        v69 = if arg17._is_this_dude_banned then ModerationLibrary_m:CanUnban(v67) else ModerationLibrary_m:CanBan(
            v67
        )
    end

    arg17:_SetActionButtonVisible("Moderate", v69)
    v69 = not v68

    if v69 then
        v69 = ModerationLibrary_m:CanRemoveFromLeaderboards(v67)
    end

    arg17:_SetActionButtonVisible("Wipe", v69)
    v69 = not v68

    if v69 then
        v69 = ModerationLibrary_m:CanPardon(v67)

        if v69 then
            v69 = arg17._player_data and arg17._player_data.RedFlags and arg17._player_data.RedFlags[#arg17._player_data.RedFlags]
        end
    end

    arg17:_SetActionButtonVisible("Pardon", v69)
    v69 = not v68

    if v69 then
        v69 = ModerationLibrary_m:CanRestrict(v67)
    end

    arg17:_SetActionButtonVisible("Restrict", v69)
    v69 = not v68

    if v69 then
        v69 = ModerationLibrary_m:CanWarnCustom(v67)
    end

    arg17:_SetActionButtonVisible("Warn", v69)
    arg17:_UpdatePowersButtonBubble()
end

function t_11._UpdateLayouts(arg18) -- line: 295
    arg18.InfoButtonBubbleBackground.Size = UDim2.new(
        0.0375,
        arg18.InfoButtonBubbleTitle.TextBounds.X,
        1,
        0
    )
    arg18.CloseButton.Position = UDim2.new(0.9, 0, 0.0225, arg18.PageFrame.AbsoluteSize.Y * 0.125)
    arg18.List.Position = UDim2.new(0.5, 9, 0, arg18.PageFrame.AbsoluteSize.Y * 0.125)
    arg18.List.Size = UDim2.new(0.7, 0, 0, arg18.PageFrame.AbsoluteSize.Y * 0.75)
    arg18.List.CanvasSize = UDim2.new(0, 0, 0, arg18.Layout.AbsoluteContentSize.Y)
end

function t_11._PlayersLookupDropdown(arg19) -- line: 303
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Players (copy)
    --  [3] DropdownSlot_m (copy)

    if arg19._dropdown_slot then
        arg19._dropdown_slot:Cancel()
        arg19._dropdown_slot = nil
    end

    local v70 = Utility_m:CloneTable(arg19._cached_players)

    for _, val_4 in pairs(Players:GetPlayers()) do
        local v72 = string.upper(val_4.DisplayName) .. " (@" .. string.upper(val_4.Name) .. ")"

        if not table.find(v70, v72) then
            table.insert(v70, v72)
        end
    end

    table.sort(v70, function(arg20, arg21) -- line: 319
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg20, arg21)
    end)
    arg19._dropdown_slot = DropdownSlot_m.new(arg19.DropdownReferenceFrame, v70)
    arg19._dropdown_slot.Selected:Connect(function(mouse: Instance) -- line: 325
        -- upvalues:
        --  [1] arg19 (copy)

        arg19._dropdown_slot = nil

        if not mouse then
            return
        end

        arg19.LookupBox.Text = string.sub(mouse, string.find(mouse, "@") + 1, #mouse - 1)
        task.defer(arg19._FetchBanData, arg19)
    end)
end

function t_11._FetchPlayerData(arg23) -- line: 337
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if arg23._player_data_debounce then
        return
    end

    arg23._player_data_debounce = true
    local Success, Result = pcall(function() -- line: 344
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg23 (copy)

        return ReplicatedStorage.Remotes.Moderator.RequestPlayerData:InvokeServer(
            arg23._ban_data.Name
        )
    end)
    arg23._player_data_debounce = false

    if not Success then
        arg23.PromptSystem:Open(
            "ErrorMessage",
            "Whoops!",
            "Something went wrong while fetching their data, error:",
            (tostring(Result))
        )

        return
    end

    if not Result then
        arg23.PromptSystem:Open(
            "ErrorMessage",
            "Whoops!",
            "This player has never played RIVALS before!"
        )

        return
    end

    arg23.PromptSystem:Open("ViewPlayerData", arg23._ban_data.Name, Result)
end

function t_11._RawFetchBanData(arg24, arg25) -- line: 359
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if arg24._lookup_disabled then
        return
    end

    arg24:SetBanData(true, nil, nil)

    if not arg25 or #arg25 == 0 then
        return
    end

    arg24._lookup_disabled = true
    arg24.PlayerWaitingFrame.Visible = true
    arg24.PlayerWaitingDotsFrame:AddTag("UILoadingDots")
    local v73 = ReplicatedStorage.Remotes.Moderator.RequestPlayer:InvokeServer(arg25) or {}
    arg24:SetBanData(true, table.unpack(v73))
    arg24._lookup_disabled = false
    arg24.PlayerWaitingFrame.Visible = false
    arg24.PlayerWaitingDotsFrame:RemoveTag("UILoadingDots")
end

function t_11._FetchBanData(arg26) -- line: 381
    arg26:_RawFetchBanData(arg26.LookupBox.Text)
end

function t_11._SetupActionButton(arg27, arg28, arg29) -- line: 385
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    local Button = arg27.PlayerLoadedActionsFrame:WaitForChild(arg28):WaitForChild("Button")
    local Title = Button:WaitForChild("Title")
    local Description = Button:WaitForChild("Description")
    local Icon = Button:WaitForChild("Icon")
    local Background = Button:WaitForChild("Background")
    local UIGradient = Background:WaitForChild("UIGradient")

    local function enter() -- line: 396
        -- upvalues:
        --  [1] Background (copy)
        --  [2] Title (copy)
        --  [3] Description (copy)
        --  [4] Icon (copy)
        --  [5] UIGradient (copy)

        Background.ImageColor3 = Color3.fromRGB(255, 255, 255)
        Background.ImageTransparency = 0
        Background.Size = UDim2.new(0.725, 0, 1, 0)
        Title.TextColor3 = Color3.fromRGB(0, 0, 0)
        Description.TextColor3 = Color3.fromRGB(0, 0, 0)
        Icon.ImageColor3 = Color3.fromRGB(0, 0, 0)
        UIGradient.Enabled = false
    end

    local ImageColor3 = Background.ImageColor3
    Button.MouseEnter:Connect(enter)

    local function leave() -- line: 408
        -- upvalues:
        --  [1] Background (copy)
        --  [2] ImageColor3 (copy)
        --  [3] Title (copy)
        --  [4] Description (copy)
        --  [5] Icon (copy)
        --  [6] UIGradient (copy)

        Background.ImageColor3 = ImageColor3
        Background.ImageTransparency = 0.5
        Background.Size = UDim2.new(1, 0, 1, 0)
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Description.TextColor3 = Color3.fromRGB(255, 255, 255)
        Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        UIGradient.Enabled = true
    end

    Button.MouseLeave:Connect(leave)
    leave()
    Button.MouseButton1Click:Connect(arg29)
    ButtonEffect_m:Add(Button, true)
end

function t_11._Init(arg30) -- line: 425
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg30.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 426
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateLayouts()
    end)
    arg30.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 430
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateLayouts()
    end)
    arg30.InfoButtonBubbleTitle:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 434
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdateLayouts()
    end)
    arg30.CloseButton.MouseButton1Click:Connect(function() -- line: 438
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:CloseRequest()
    end)
    arg30.InvestigateWinStreaksButton.MouseButton1Click:Connect(function() -- line: 442
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Moderator.CheckTop100Streaks:FireServer()
    end)
    arg30.InvestigateTrueWinStreaksButton.MouseButton1Click:Connect(function() -- line: 446
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Moderator.CheckTop100TrueStreaks:FireServer()
    end)
    arg30.LookupButton.MouseButton1Click:Connect(function() -- line: 450
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_FetchBanData()
    end)
    arg30.LookupDropdownButton.MouseButton1Click:Connect(function() -- line: 454
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_PlayersLookupDropdown()
    end)
    arg30.InfoButton.MouseButton1Click:Connect(function() -- line: 458
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.InfoButtonBubble.Visible = not arg30.InfoButtonBubble.Visible
    end)
    arg30.PowersButton.MouseButton1Click:Connect(function() -- line: 462
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PowersButtonBubble.Visible = not arg30.PowersButtonBubble.Visible
    end)
    arg30:_SetupActionButton("Moderate", function() -- line: 466
        -- upvalues:
        --  [1] arg30 (copy)

        if arg30._is_this_dude_banned then
            arg30.PromptSystem:Open("Unban", arg30._ban_data)

            return
        end

        arg30.PromptSystem:Open("Ban", arg30._ban_data)
    end)
    arg30:_SetupActionButton("ViewLogs", function() -- line: 474
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PromptSystem:Open("InspectBanLogs", arg30._ban_data)
    end)
    arg30:_SetupActionButton("Join", function() -- line: 478
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg30 (copy)

        ReplicatedStorage.Remotes.Moderator.Join:FireServer(arg30._ban_data.Name)
    end)
    arg30:_SetupActionButton("Kick", function() -- line: 482
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PromptSystem:Open("Kick", arg30._ban_data)
    end)
    arg30:_SetupActionButton("ViewData", function() -- line: 486
        -- upvalues:
        --  [1] arg30 (copy)

        if arg30._result_data then
            arg30.PromptSystem:Open("ViewPlayerData", arg30._ban_data.Name, arg30._result_data)

            return
        end

        arg30:_FetchPlayerData()
    end)
    arg30:_SetupActionButton("Pardon", function() -- line: 494
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PromptSystem:Open("Pardon", arg30._ban_data)
    end)
    arg30:_SetupActionButton("Lock", function() -- line: 498
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg30 (copy)

        ReplicatedStorage.Remotes.Moderator.LockBans:FireServer(arg30._ban_data.Name)
    end)
    arg30:_SetupActionButton("ViewActions", function() -- line: 502
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PromptSystem:Open("InspectActionLogs", arg30._ban_data)
    end)
    arg30:_SetupActionButton("Wipe", function() -- line: 506
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg30 (copy)

        ReplicatedStorage.Remotes.Moderator.RemoveFromLeaderboards:FireServer(arg30._ban_data.Name)
    end)
    arg30:_SetupActionButton("Restrict", function() -- line: 510
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PromptSystem:Open("Restrict", arg30._ban_data)
    end)
    arg30:_SetupActionButton("Warn", function() -- line: 514
        -- upvalues:
        --  [1] arg30 (copy)

        arg30.PromptSystem:Open("Warn", arg30._ban_data)
    end)
    PlayerDataController_m:GetDataChangedSignal("PermissionsRoles"):Connect(function() -- line: 518
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:_UpdatePermissions()
    end)
    ReplicatedStorage.Remotes.Moderator.UpdateBanData.OnClientEvent:Connect(function(arguments) -- line: 522
        -- upvalues:
        --  [1] arg30 (copy)

        arg30:SetBanData(false, arguments, arg30._result_data)
    end)
    arg30:_UpdateLayouts()
    arg30:_UpdatePermissions()
    arg30:SetBanData(true, nil, nil)
    ButtonEffect_m:Add(arg30.CloseButton)
    ButtonEffect_m:Add(arg30.InvestigateWinStreaksButton)
    ButtonEffect_m:Add(arg30.InvestigateTrueWinStreaksButton)
    ButtonEffect_m:Add(arg30.LookupButton)
    ButtonEffect_m:Add(arg30.LookupDropdownButton)
    ButtonEffect_m:Add(arg30.InfoButton)
    ButtonEffect_m:Add(arg30.PowersButton)
end

return t_11._new()
