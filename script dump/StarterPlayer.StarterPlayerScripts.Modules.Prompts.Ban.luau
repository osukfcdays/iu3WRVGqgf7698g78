local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ModerationLibrary_m = require(ReplicatedStorage.Modules.ModerationLibrary)
local SettingsInfo_m = require(ReplicatedStorage.Modules.SettingsInfo)
local _ = require(ReplicatedStorage.Modules.BanLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local Dropdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings"):WaitForChild("Dropdown")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = {
    "Exploiting",
    "Exploiting - Movement Cheats",
    "Exploiting - Aim Cheats",
    "Exploiting - Vision Cheats",
    "Requesting Exploits",
    "Playing With Exploiters",
    "Fake Reporting",
    "Farming",
    "Abusing Minor Bugs",
    "Harassment / Hate Speech",
    "Ban Evasion",
    "Custom"
}
local t_1 = {
    "Permanent",
    "1 day",
    "3 days",
    "7 days",
    "14 days",
    "30 days",
    "90 days",
    "180 days",
    "365 days",
    "Custom"
}
local t_2 = setmetatable({}, Prompt_m)
t_2.__index = t_2

function t_2.new(arg1) -- line: 26
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t_2 (copy)
    --  [3] Dropdown_m (copy)
    --  [4] SettingsInfo_m (copy)
    --  [5] t (copy)
    --  [6] t_1 (copy)

    local t_3 = setmetatable(Prompt_m.new(script.Name), t_2)
    t_3.CloseButton = t_3.PromptFrame:WaitForChild("Close")
    t_3.ConfirmButton = t_3.PromptFrame:WaitForChild("Confirm")
    t_3.TitleText = t_3.PromptFrame:WaitForChild("Title")
    t_3.RestrictionNotice = t_3.PromptFrame:WaitForChild("RestrictionNotice")
    t_3.DetailsFrame = t_3.PromptFrame:WaitForChild("Details")
    t_3.ReasonFrame = t_3.DetailsFrame:WaitForChild("Reason")
    t_3.ReasonDropdownFrame = t_3.ReasonFrame:WaitForChild("Dropdown")
    t_3.ReasonCustomFrame = t_3.DetailsFrame:WaitForChild("ReasonCustom")
    t_3.ReasonCustomBox = t_3.ReasonCustomFrame:WaitForChild("Input"):WaitForChild("Box")
    t_3.DurationFrame = t_3.DetailsFrame:WaitForChild("Duration")
    t_3.DurationDropdownFrame = t_3.DurationFrame:WaitForChild("Dropdown")
    t_3.DurationCustomFrame = t_3.DetailsFrame:WaitForChild("DurationCustom")
    t_3.DurationCustomBox = t_3.DurationCustomFrame:WaitForChild("Input"):WaitForChild("Box")
    t_3.WarnFrame = t_3.DetailsFrame:WaitForChild("Warn")
    t_3.WarnContainer = t_3.WarnFrame:WaitForChild("Container")
    t_3.WarnButton = t_3.WarnContainer:WaitForChild("Button")
    t_3.WarnButtonEmpty = t_3.WarnButton:WaitForChild("Empty")
    t_3.WarnButtonFilled = t_3.WarnButton:WaitForChild("Filled")
    t_3.CasualLBsFrame = t_3.DetailsFrame:WaitForChild("CasualLBs")
    t_3.CasualLBsContainer = t_3.CasualLBsFrame:WaitForChild("Container")
    t_3.CasualLBsButton = t_3.CasualLBsContainer:WaitForChild("Button")
    t_3.CasualLBsButtonEmpty = t_3.CasualLBsButton:WaitForChild("Empty")
    t_3.CasualLBsButtonFilled = t_3.CasualLBsButton:WaitForChild("Filled")
    t_3.CompLBsFrame = t_3.DetailsFrame:WaitForChild("CompLBs")
    t_3.CompLBsContainer = t_3.CompLBsFrame:WaitForChild("Container")
    t_3.CompLBsButton = t_3.CompLBsContainer:WaitForChild("Button")
    t_3.CompLBsButtonEmpty = t_3.CompLBsButton:WaitForChild("Empty")
    t_3.CompLBsButtonFilled = t_3.CompLBsButton:WaitForChild("Filled")
    t_3.ReasonDropdown = Dropdown_m.new(SettingsInfo_m.new(
        "",
        "",
        "",
        "",
        "",
        "Dropdown",
        t[1],
        t
    ))
    t_3.DurationDropdown = Dropdown_m.new(
        SettingsInfo_m.new(
            "",
            "",
            "",
            "",
            "",
            "Dropdown",
            t_1[1],
            t_1
        )
    )
    t_3._ban_data = arg1
    t_3:_Init()

    return t_3
end

function t_2.Confirm(arg2) -- line: 72
    -- upvalues:
    --  [1] ModerationLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ReplicatedStorage (copy)

    local v6 = if arg2.ReasonDropdown.Value ~= "Custom" then arg2.ReasonDropdown.Value else arg2.ReasonCustomBox.Text
    local v7 = arg2:_GetBanDurationInteger()

    if not v7 or #v6 < 5 or #v6 > 100 then
        return
    end

    local v9

    if ModerationLibrary_m:CanWarnTemplate(PlayerDataController_m:Get("PermissionsRoles")) then
        v9 = arg2.WarnButtonFilled.Visible
    end

    if not ModerationLibrary_m:CanRestrict(PlayerDataController_m:Get("PermissionsRoles")) then
        v9 = nil
    else
        v9 = { RestrictedFromCasualLeaderboards = nil, RestrictedFromCompetitiveLeaderboards = nil }
        local v11 = arg2.CasualLBsButtonFilled.Visible or arg2._ban_data.Restrictions and arg2._ban_data.Restrictions.RestrictedFromCasualLeaderboards
        v9.RestrictedFromCasualLeaderboards = v11
        v11 = arg2.CompLBsButtonFilled.Visible or arg2._ban_data.Restrictions and arg2._ban_data.Restrictions.RestrictedFromCompetitiveLeaderboards
        v9.RestrictedFromCompetitiveLeaderboards = v11
    end

    ReplicatedStorage.Remotes.Moderator.Ban:FireServer(
        arg2._ban_data.Name,
        v7,
        v6,
        arg2.WarnButtonFilled.Visible,
        v9
    )
    task.defer(arg2.CloseRequest, arg2)
end

function t_2.Destroy(arg3) -- line: 99
    -- upvalues:
    --  [1] Prompt_m (copy)

    arg3.ReasonDropdown:Destroy()
    arg3.DurationDropdown:Destroy()
    Prompt_m.Destroy(arg3)
end

function t_2._GetBanDurationInteger(arg4) -- line: 109
    if arg4.DurationDropdown.Value == "Custom" then
        return (tonumber(arg4.DurationCustomBox.Text))
    end

    if arg4.DurationDropdown.Value == "Permanent" then
        return -1
    end

    return (tonumber(
        (string.sub(
            arg4.DurationDropdown.Value,
            1,
            string.find(arg4.DurationDropdown.Value, " ") - 1
        ))
    ))
end

function t_2._SetCasualLBsRestriction(arg5, arg6) -- line: 115
    arg5.CasualLBsButtonFilled.Visible = arg6
    arg5.CasualLBsButtonEmpty.Visible = not arg6
end

function t_2._SetCompLBsRestriction(arg7, arg8) -- line: 120
    arg7.CompLBsButtonFilled.Visible = arg8
    arg7.CompLBsButtonEmpty.Visible = not arg8
end

function t_2._SetWarn(arg9, arg10) -- line: 125
    arg9.WarnButtonFilled.Visible = arg10
    arg9.WarnButtonEmpty.Visible = not arg10
end

function t_2._AutomaticallyCheckBoxes(arg11) -- line: 130
    local v12 = arg11:_GetBanDurationInteger()

    if not v12 then
        v12 = 0
    elseif v12 == -1 then
        v12 = math.huge
    end

    arg11:_SetCasualLBsRestriction(v12 >= 3)
    arg11:_SetCompLBsRestriction(if not (v12 >= 7) then false else true)
end

function t_2._Update(arg12) -- line: 138
    local v14 = arg12.ReasonDropdown.Value == "Custom"
    local Value_1 = arg12.DurationDropdown.Value
    arg12.ReasonCustomFrame.Visible = v14
    arg12.DurationFrame.Visible = true
    local DurationCustomFrame = arg12.DurationCustomFrame
    DurationCustomFrame.Visible = Value_1 == "Custom"
end

function t_2._FormatSettingSlot(_, arg14) -- line: 147
    arg14.SettingFrame.Size = UDim2.new(1, 0, 1, 0)
    arg14.SettingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    arg14.SettingFrame.SizeConstraint = Enum.SizeConstraint.RelativeXY
    arg14.ControlsFrame.Size = UDim2.new(1, 0, 1, 0)
    arg14.ControlsFrame.SizeConstraint = Enum.SizeConstraint.RelativeXY
    arg14.DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
    arg14.Background.Visible = false
    arg14.DetailsResetButton.Size = UDim2.new(0, 0, 0, 0)
end

function t_2._Setup(arg15) -- line: 158
    -- upvalues:
    --  [1] ModerationLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    arg15.TitleText.Text = "@" .. arg15._ban_data.Name
    arg15.ReasonDropdown.SettingFrame.Parent = arg15.ReasonDropdownFrame
    arg15.DurationDropdown.SettingFrame.Parent = arg15.DurationDropdownFrame
    arg15.WarnFrame.Visible = ModerationLibrary_m:CanWarnTemplate(
        PlayerDataController_m:Get("PermissionsRoles")
    )
    arg15.CasualLBsFrame.Visible = ModerationLibrary_m:CanRestrict(
        PlayerDataController_m:Get("PermissionsRoles")
    )
    arg15.CompLBsFrame.Visible = ModerationLibrary_m:CanRestrict(
        PlayerDataController_m:Get("PermissionsRoles")
    )
    arg15.RestrictionNotice.Visible = ModerationLibrary_m:CanRestrict(
        PlayerDataController_m:Get("PermissionsRoles")
    )
end

function t_2._Init(arg16) -- line: 168
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg16.CloseButton.MouseButton1Click:Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:CloseRequest()
    end)
    arg16.ConfirmButton.MouseButton1Click:Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:Confirm()
    end)
    arg16.DurationCustomBox.FocusLost:Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg16 (copy)

        if arg16.DurationCustomBox.Text ~= "" then
            local DurationCustomBox = arg16.DurationCustomBox
            DurationCustomBox.Text = tonumber(arg16.DurationCustomBox.Text) and math.clamp(
                math.floor((tonumber(arg16.DurationCustomBox.Text))),
                1,
                999
            ) or ""
        end

        arg16:_AutomaticallyCheckBoxes()
    end)
    arg16.ReasonDropdown.Replicate:Connect(function() -- line: 185
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_Update()
    end)
    arg16.DurationDropdown.Replicate:Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_Update()
        arg16:_AutomaticallyCheckBoxes()
    end)
    arg16.WarnButton.MouseButton1Click:Connect(function() -- line: 194
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_SetWarn(not arg16.WarnButtonFilled.Visible)
    end)
    arg16.CasualLBsButton.MouseButton1Click:Connect(function() -- line: 198
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_SetCasualLBsRestriction(not arg16.CasualLBsButtonFilled.Visible)
    end)
    arg16.CompLBsButton.MouseButton1Click:Connect(function() -- line: 202
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_SetCasualLBsRestriction(not arg16.CompLBsButtonFilled.Visible)
    end)
    arg16:_Setup()
    arg16:_FormatSettingSlot(arg16.ReasonDropdown)
    arg16:_FormatSettingSlot(arg16.DurationDropdown)
    arg16:_Update()
    arg16:_AutomaticallyCheckBoxes()
    arg16:_SetWarn(true)
    ButtonEffect_m:Add(arg16.CloseButton)
    ButtonEffect_m:Add(arg16.ConfirmButton)
    ButtonEffect_m:Add(arg16.WarnButton)
    ButtonEffect_m:Add(arg16.CasualLBsButton)
    ButtonEffect_m:Add(arg16.CompLBsButton)
end

return t_2
