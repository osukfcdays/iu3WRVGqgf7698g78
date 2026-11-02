local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local SettingsProfileSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "SettingsProfileSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Clicked = Signal_m.new()
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Profiles")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.ShareFrame = t_1.Container:WaitForChild("Share")
    t_1.ShareButton = t_1.ShareFrame:WaitForChild("Button")
    t_1.ShareBubbleFrame = t_1.ShareFrame:WaitForChild("Bubble")
    t_1.ShareCloseButton = t_1.ShareBubbleFrame:WaitForChild("Close")
    t_1.ShareExportBox = t_1.ShareBubbleFrame:WaitForChild("Export")
    t_1.ShareExportSectionBox = t_1.ShareBubbleFrame:WaitForChild("ExportSection")
    t_1.ShareExportSectionTitle = t_1.ShareBubbleFrame:WaitForChild("ExportSectionTitle")
    t_1.ShareImportFrame = t_1.ShareBubbleFrame:WaitForChild("Import")
    t_1.ShareImportButton = t_1.ShareImportFrame:WaitForChild("Button")
    t_1.ShareImportButtonTitle = t_1.ShareImportButton:WaitForChild("Title")
    t_1.ShareImportButtonSection = t_1.ShareImportButton:WaitForChild("Section")
    t_1.ShareImportBox = t_1.ShareImportFrame:WaitForChild("Box")
    t_1._slots = {}
    t_1._update_hash = 0
    t_1:_Init()

    return t_1
end

function t.SetPage(arg2) -- line: 54
    arg2:_SetShareBubbleVisible(false)
end

function t.Open(arg3) -- line: 58
    arg3:_SetShareBubbleVisible(false)
end

function t._ImportSettings(arg4) -- line: 66
    -- upvalues:
    --  [1] EnumLibrary_m (copy)
    --  [2] Utility_m (copy)
    --  [3] SettingsController_m (copy)

    local v4, v5 = EnumLibrary_m:DecryptTable(arg4.ShareImportBox.Text)

    if not v4 then
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    SettingsController_m:ChangeSettings(v5)
    arg4:_SetShareBubbleVisible(false)
end

function t._GetBulkSettings(_, arg6) -- line: 78
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    local t_2 = {}

    for _, val in pairs(SettingsLibrary_m.Order) do
        if val.InputType ~= "Divider" and (not arg6 or val.Section == arg6) then
            local _ = {}
            table.insert(t_2, { val.Name, PlayerDataController_m:GetSetting(val.Name) })
        end
    end

    return t_2
end

function t._UpdateImportButton(arg7) -- line: 96
    -- upvalues:
    --  [1] EnumLibrary_m (copy)
    --  [2] SettingsLibrary_m (copy)

    local v7, v8 = EnumLibrary_m:DecryptTable(arg7.ShareImportBox.Text)
    local v9 = nil

    if v7 then
        for _, val_1 in pairs(v8) do
            local v10 = SettingsLibrary_m.Info[val_1[1]]

            if v10 then
                v10 = SettingsLibrary_m.Info[val_1[1]].Section
            end

            if v10 then
                if not v9 then
                    v9 = v10
                elseif v9 ~= v10 and v9 ~= v10 then
                    v9 = "Everything"
                    break
                end
            end
        end
    end

    local ShareImportButtonTitle = arg7.ShareImportButtonTitle
    ShareImportButtonTitle.Position = if not v7 then UDim2.new(0.5, 0, 0.5, 0) else UDim2.new(
        0.5,
        0,
        0.35,
        0
    )
    arg7.ShareImportButtonSection.Visible = v7
    arg7.ShareImportButtonSection.Text = v9 or "Nothing"
end

function t._SetShareBubbleVisible(arg8, arg9) -- line: 124
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    if arg9 == arg8.ShareBubbleFrame.Visible then
        return
    end

    arg8.ShareBubbleFrame.Visible = arg9
    arg8.ShareExportSectionTitle.Text = string.format(
        "Share only your %s settings by copying this: ",
        arg8.Page.CurrentPage or ""
    )
    arg8.ShareExportBox.Text = EnumLibrary_m:EncryptTable(arg8:_GetBulkSettings(nil))
    local ShareExportSectionBox = arg8.ShareExportSectionBox
    ShareExportSectionBox.Text = if not arg8.Page.CurrentPage then "???" else EnumLibrary_m:EncryptTable(
        arg8:_GetBulkSettings(arg8.Page.CurrentPage)
    )
    arg8.ShareImportBox.Text = ""
end

function t._Update(arg10, arg11) -- line: 136
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg10._update_hash += 1
    local UpdateHash = arg10._update_hash
    local v15 = PlayerDataController_m:Get("SettingsProfile")

    for key_2, val_2 in pairs(arg10._slots) do
        local v16 = if key_2 ~= v15 then false else true
        val_2.Button.Background.Visible = v16
        local Title = val_2.Button.Title
        local color = if not v16 then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(0, 0, 0)
        Title.TextColor3 = color
        val_2.Bubble.Visible = false

        if v16 and not arg11 then
            val_2.Bubble.Visible = true
            val_2.Bubble.Size = UDim2.new(0.5, 0, 0.5, 0)
            val_2.Bubble:TweenSize(
                UDim2.new(1, 0, 1, 0),
                "Out",
                "Quint",
                0.25,
                true
            )
            task.delay(3, function() -- line: 153
                -- upvalues:
                --  [1] UpdateHash (copy)
                --  [2] arg10 (copy)
                --  [3] val_2 (copy)

                if UpdateHash ~= arg10._update_hash then
                    return
                end

                val_2.Bubble:TweenSize(
                    UDim2.new(0.5, 0, 0.5, 0),
                    "In",
                    "Quint",
                    0.25,
                    true
                )
                task.delay(0.25, function() -- line: 160
                    -- upvalues:
                    --  [1] UpdateHash (ref)
                    --  [2] arg10 (ref)
                    --  [3] val_2 (ref)

                    if UpdateHash ~= arg10._update_hash then
                        return
                    end

                    val_2.Bubble.Visible = false
                end)
            end)
        end
    end
end

function t._ButtonEffect(_, arg13) -- line: 172
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg13.MouseEnter:Connect(function() -- line: 173
        -- upvalues:
        --  [1] arg13 (copy)

        arg13.OnHover.Visible = true
    end)
    arg13.MouseLeave:Connect(function() -- line: 177
        -- upvalues:
        --  [1] arg13 (copy)

        arg13.OnHover.Visible = false
    end)
    ButtonEffect_m:Add(arg13)
end

function t._Setup(arg14) -- line: 184
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] SettingsProfileSlot (copy)

    for index = 1, SettingsLibrary_m.NUM_PROFILES do
        local v18 = SettingsProfileSlot:Clone()
        v18.Button.Title.Text = index
        v18.Bubble.Container.Title.Text = "Switched to profile #" .. index
        v18.Parent = arg14.Container
        v18.Button.MouseButton1Click:Connect(function() -- line: 191
            -- upvalues:
            --  [1] arg14 (copy)
            --  [2] index (copy)

            arg14.Clicked:Fire(index)
        end)
        arg14._slots[index] = v18
        arg14:_ButtonEffect(v18.Button)
    end
end

function t._Init(arg15) -- line: 200
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg15.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 201
        -- upvalues:
        --  [1] arg15 (copy)

        arg15.Background.Size = UDim2.new(1, 0, 0, arg15.Layout.AbsoluteContentSize.Y)
    end)
    arg15.ShareButton.MouseButton1Click:Connect(function() -- line: 205
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_SetShareBubbleVisible(true)
    end)
    arg15.ShareCloseButton.MouseButton1Click:Connect(function() -- line: 209
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_SetShareBubbleVisible(false)
    end)
    arg15.ShareImportButton.MouseButton1Click:Connect(function() -- line: 213
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_ImportSettings()
    end)
    arg15.ShareImportBox:GetPropertyChangedSignal("Text"):Connect(function() -- line: 217
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_UpdateImportButton()
    end)
    PlayerDataController_m:GetDataChangedSignal("SettingsProfile"):Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_Update()
    end)
    arg15:_Setup()
    arg15:_Update(true)
    arg15:_UpdateImportButton()
    arg15:_ButtonEffect(arg15.ShareButton)
    ButtonEffect_m:Add(arg15.ShareImportButton, true)
end

return t
