local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local _ = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local WinAffiliationSlot = Players.LocalPlayer.PlayerScripts.UserInterface.WinAffiliationSlot
local RawDataText = Players.LocalPlayer.PlayerScripts.UserInterface.RawDataText
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1, arg2) -- line: 20
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)

    assert(
        if typeof(arg1) ~= "string" then false else true,
        "Argument 1 invalid, expected a string, got " .. tostring(arg1)
    )
    assert(
        if typeof(arg2) ~= "table" then false else true,
        "Argument 2 invalid, expected a table, got " .. tostring(arg2)
    )
    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.UsernameText = t_1.PromptFrame:WaitForChild("Username")
    t_1.TabsFrame = t_1.PromptFrame:WaitForChild("Tabs")
    t_1.RawDataButton = t_1.TabsFrame:WaitForChild("RawData")
    t_1.HaveWonAgainstButton = t_1.TabsFrame:WaitForChild("HaveWonAgainst")
    t_1.HaveWonWithButton = t_1.TabsFrame:WaitForChild("HaveWonWith")
    t_1.PagesFrame = t_1.PromptFrame:WaitForChild("Pages")
    t_1.RawDataFrame = t_1.PagesFrame:WaitForChild("RawData")
    t_1.RawDataSearchFrame = t_1.RawDataFrame:WaitForChild("Search")
    t_1.RawDataSearchBox = t_1.RawDataSearchFrame:WaitForChild("Box")
    t_1.RawDataLoadButton = t_1.RawDataFrame:WaitForChild("Load")
    t_1.RawDataList = t_1.RawDataFrame:WaitForChild("List")
    t_1.RawDataContainer = t_1.RawDataList:WaitForChild("Container")
    t_1.RawDataLayout = t_1.RawDataContainer:WaitForChild("Layout")
    t_1.HaveWonAgainstFrame = t_1.PagesFrame:WaitForChild("HaveWonAgainst")
    t_1.HaveWonAgainstList = t_1.HaveWonAgainstFrame:WaitForChild("List")
    t_1.HaveWonAgainstContainer = t_1.HaveWonAgainstList:WaitForChild("Container")
    t_1.HaveWonAgainstLayout = t_1.HaveWonAgainstContainer:WaitForChild("Layout")
    t_1.HaveWonAgainstEmptyText = t_1.HaveWonAgainstContainer:WaitForChild("Empty")
    t_1.HaveWonWithFrame = t_1.PagesFrame:WaitForChild("HaveWonWith")
    t_1.HaveWonWithList = t_1.HaveWonWithFrame:WaitForChild("List")
    t_1.HaveWonWithContainer = t_1.HaveWonWithList:WaitForChild("Container")
    t_1.HaveWonWithLayout = t_1.HaveWonWithContainer:WaitForChild("Layout")
    t_1.HaveWonWithEmptyText = t_1.HaveWonWithContainer:WaitForChild("Empty")
    t_1._name = arg1
    t_1._data = arg2 and arg2.RawData or {}
    t_1._metadata = arg2 and arg2.Metadata or {}
    t_1._raw_data_texts = {}
    t_1:_Init()

    return t_1
end

function t.SetPage(arg3, arg4) -- line: 65
    for _, child in pairs(arg3.PagesFrame:GetChildren()) do
        local v8 = child.Name == arg4
        child.Visible = v8
    end
end

function t._UpdateRawDataSearch(arg5) -- line: 75
    local lowerText = string.lower(arg5.RawDataSearchBox.Text)
    local t_2 = {}

    for key_1, _ in pairs(arg5._raw_data_texts) do
        key_1.Visible = false
        t_2[key_1] = string.find(string.lower(key_1.Text), lowerText) or nil
    end

    local function make_children_visible(arg6) -- line: 84
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] make_children_visible (copy)

        for key_2, val_1 in pairs(arg5._raw_data_texts) do
            if val_1 == arg6 then
                key_2.Visible = true
                make_children_visible(key_2)
            end
        end
    end

    local _ = function(arg7) --[[ make_ancestors_visible ]] -- line: 93
        -- upvalues:
        --  [1] arg5 (copy)

        local v10 = arg7

        while true do
            if arg5._raw_data_texts[v10] == true then
                break
            end

            v10 = arg5._raw_data_texts[v10]
            v10.Visible = true
        end
    end

    for key_3, _ in pairs(t_2) do
        key_3.Visible = true
        make_children_visible(key_3)
        local v11 = key_3

        while true do
            if arg5._raw_data_texts[v11] == true then
                break
            end

            v11 = arg5._raw_data_texts[v11]
            v11.Visible = true
        end
    end
end

function t._GenerateWinHistory(arg8) -- line: 109
    -- upvalues:
    --  [1] ButtonEffect_m (copy)
    --  [2] ComplianceController_m (copy)
    --  [3] WinAffiliationSlot (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] Utility_m (copy)
    --  [6] ServerOsTime_m (copy)

    for _, val_3 in pairs({ "HaveWonAgainst", "HaveWonWith" }) do
        local v12 = arg8[val_3 .. "EmptyText"]
        local v13 = arg8[val_3 .. "Container"]
        local v14 = arg8[val_3 .. "Button"]
        local v15 = arg8[val_3 .. "Layout"]
        local v16 = arg8[val_3 .. "List"]
        v14.MouseButton1Click:Connect(function() -- line: 117
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] val_3 (copy)

            arg8:SetPage(val_3)
        end)
        v15:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 121
            -- upvalues:
            --  [1] v16 (copy)
            --  [2] v15 (copy)

            v16.CanvasSize = UDim2.new(0, 0, 0, v15.AbsoluteContentSize.Y)
        end)
        ButtonEffect_m:Add(v14)
        v12.Visible = true
        v12.Text = "Loading..."
        v14 = arg8._data[val_3] or {}
        local v18 = {}

        for _, val_4 in pairs(v14) do
            table.insert(v18, val_4[1])
        end

        local v19 = ComplianceController_m:GetUserInfos(v18)
        v18 = true

        for key_6, val_5 in pairs(v14) do
            local v20, v21, v22 = table.unpack(val_5)
            local v23 = v19[tostring(v20)]
            local v24 = if v23 then ComplianceController_m:UseDisplayNames() and v23.DisplayName or v23.Username or "[Failed to load user info]" else "[Failed to load user info]"
            local v25 = "#" .. tostring(v20)
            local v26 = v23 and v23.Username and ComplianceController_m:UsernamesAllowed() and v23.Username ~= v24 and " @" .. tostring(
                v23.Username
            ) or ""
            local v27 = v25 .. v26
            local v28 = WinAffiliationSlot:Clone()
            v28.Picture.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, v20)
            v28.DisplayName.Text = v24
            local DisplayName = v28.DisplayName
            local v29 = v27 == "" and UDim2.new(0.15, 0, 0.5, 0) or UDim2.new(0.15, 0, 0.4, 0)
            DisplayName.Position = v29
            v28.Username.Text = v27
            local Username = v28.Username
            v29 = v27 ~= ""
            Username.Visible = v29
            v28.Quantity.Text = Utility_m:PrettyNumber(v21)
            local QuantityLabel = v28.QuantityLabel
            v29 = if val_3 == "HaveWonWith" then if v21 == 1 then "win with them" else "wins with them" else if v21 ~= 1 then "wins against them" else "win against them"
            QuantityLabel.Text = v29
            local LastLogged = v28.LastLogged
            v29 = if not v22 then "" else "last logged " .. Utility_m:TimeFormat2(
                (math.floor(ServerOsTime_m:Get() - v22))
            ) .. " ago"
            LastLogged.Text = v29
            v28.LayoutOrder = key_6
            v28.Parent = v13
            v18 = false
        end

        v12.Text = "Empty"
        v12.Visible = v18
    end
end

function t._GenerateRawData(arg9) -- line: 167
    -- upvalues:
    --  [1] RawDataText (copy)
    --  [2] Utility_m (copy)

    arg9.RawDataLoadButton.Visible = false
    arg9.RawDataSearchFrame.Visible = true

    local _ = function(arg10, arg11) --[[ generate_top_text ]] -- line: 171
        -- upvalues:
        --  [1] RawDataText (ref)
        --  [2] arg9 (copy)

        local v31 = RawDataText:Clone()
        v31.Text = arg11
        v31.LayoutOrder = arg10
        v31.Parent = arg9.RawDataContainer
    end

    local v32 = arg9._data.RedFlags

    if v32 then
        v32 = arg9._data.RedFlags[#arg9._data.RedFlags]
    end

    if v32 then
        local formattedText_1 = string.format("-- red flag:    %s", (tostring(v32.Reason)))
        local v34 = RawDataText:Clone()
        v34.Text = formattedText_1
        v34.LayoutOrder = -999
        v34.Parent = arg9.RawDataContainer
    end

    if arg9._metadata.DataSize then
        local string_format_1 = string.format(
            "-- data size:    %s bytes    (%s%%)",
            Utility_m:PrettyNumber(arg9._metadata.DataSize),
            math.floor(arg9._metadata.DataSize / 4194304 * 1000) / 10
        )
        v32 = RawDataText:Clone()
        v32.Text = string_format_1
        v32.LayoutOrder = -998
        v32.Parent = arg9.RawDataContainer
    end

    if arg9._metadata.RobuxSpent then
        local string_format_2 = string.format(
            "-- robux spent:    %s%s %s",
            if arg9._metadata.TrueRobuxSpentHidden then ">" else "",
            Utility_m:PrettyNumber(arg9._metadata.RobuxSpent),
            utf8.char(57346)
        )
        local v39 = RawDataText:Clone()
        v39.Text = string_format_2
        v39.LayoutOrder = -997
        v39.Parent = arg9.RawDataContainer
    end

    local v40 = RawDataText:Clone()
    v40.Text = ""
    v40.LayoutOrder = -1
    v40.Parent = arg9.RawDataContainer
    local v41 = 0

    local function generate_text(arg12, arg13, arg14, arg15) -- line: 196
        -- upvalues:
        --  [1] RawDataText (ref)
        --  [2] v41 (ref)
        --  [3] arg9 (copy)

        local formattedText = string.format(
            if typeof(arg13) == "string" then "\"%s\"" else "%s",
            (tostring(arg13))
        )
        local v42 = RawDataText:Clone()
        v42.Text = string.format("%s[\"%s\"] = %s", arg14, arg12, formattedText) .. ";"
        v42.LayoutOrder = v41
        v42.Parent = arg9.RawDataContainer
        arg9._raw_data_texts[v42] = arg15 or true
        v41 += 1
    end

    local function generate_table(arg16, arg17, arg18, arg19) -- line: 207
        -- upvalues:
        --  [1] RawDataText (ref)
        --  [2] v41 (ref)
        --  [3] arg9 (copy)
        --  [4] generate_table (copy)
        --  [5] generate_text (copy)

        local repeatedText = string.rep(" ", 8 * (arg17 - 1))
        local repeatedText_1 = string.rep(" ", 8 * arg17)
        local v45 = nil

        if arg18 then
            v45 = RawDataText:Clone()
            v45.Text = string.format("%s[\"%s\"] = %s", repeatedText, arg18, "{")
            v45.LayoutOrder = v41
            v45.Parent = arg9.RawDataContainer
            arg9._raw_data_texts[v45] = arg19 or true
            v41 += 1
        end

        local v46 = true

        for key_7, val_6 in pairs(arg16) do
            v46 = false

            if typeof(val_6) == "table" then
                generate_table(val_6, arg17 + 1, key_7, v45)
            else
                generate_text(key_7, val_6, repeatedText_1, v45)
            end
        end

        if v46 then
            v45 = RawDataText:Clone()
            v45.Text = repeatedText_1 .. "-- empty"
            v45.LayoutOrder = v41
            v45.Parent = arg9.RawDataContainer
            arg9._raw_data_texts[v45] = arg19 or true
            v41 += 1
        end

        if arg18 then
            v46 = RawDataText:Clone()
            v46.Text = repeatedText .. "};"
            v46.LayoutOrder = v41
            v46.Parent = arg9.RawDataContainer
            arg9._raw_data_texts[v46] = arg19 or true
            v41 += 1
        end
    end

    local t_4 = {}

    for key_8, _ in pairs(arg9._data) do
        table.insert(t_4, key_8)
    end

    table.sort(t_4, function(arg20, arg21) -- line: 259
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg20, arg21)
    end)

    for _, val_8 in pairs(t_4) do
        local v47 = arg9._data[val_8]

        if typeof(v47) == "table" then
            generate_table(v47, 1, val_8)
        else
            generate_text(val_8, v47, "")
        end
    end

    arg9.RawDataList.Visible = true
end

function t._Setup(arg22) -- line: 276
    arg22.UsernameText.Text = "@" .. arg22._name
end

function t._Init(arg23) -- line: 280
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg23.CloseButton.MouseButton1Click:Connect(function() -- line: 281
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:CloseRequest()
    end)
    arg23.RawDataLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 285
        -- upvalues:
        --  [1] arg23 (copy)

        arg23.RawDataList.CanvasSize = UDim2.new(0, 0, 0, arg23.RawDataLayout.AbsoluteContentSize.Y)
    end)
    arg23.RawDataButton.MouseButton1Click:Connect(function() -- line: 289
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:SetPage("RawData")
    end)
    arg23.RawDataLoadButton.MouseButton1Click:Connect(function() -- line: 293
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_GenerateRawData()
    end)
    arg23.RawDataSearchBox.FocusLost:Connect(function() -- line: 297
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_UpdateRawDataSearch()
    end)
    arg23:_Setup()
    task.spawn(arg23._GenerateWinHistory, arg23)
    arg23:SetPage("RawData")
    ButtonEffect_m:Add(arg23.CloseButton)
    ButtonEffect_m:Add(arg23.RawDataButton)
    ButtonEffect_m:Add(arg23.RawDataLoadButton)
end

return t
