local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SettingsInfo_m = require(ReplicatedStorage.Modules.SettingsInfo)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local Settings = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local t = {
    {
        "QueueName",
        "Dropdown",
        "Gamemode",
        "rbxassetid://77802568386086",
        "Changes the gameplay, map pool, & more"
    },
    {
        "MapPool",
        "Dropdown",
        "Map Pool",
        "rbxassetid://83261934303870",
        "Change how the map pool is determined"
    },
    {
        "MapPoolGamemode",
        "Dropdown",
        "By Gamemode",
        "rbxassetid://14641612286",
        "You probably don't need to edit this"
    },
    {
        "MapPoolSpecific",
        "Dropdown",
        "Specific Map",
        "rbxassetid://14641612286",
        "Choose the specific map you want"
    },
    {
        "InfinitePlayersPerTeam",
        "Toggle",
        "Infinite Players",
        "rbxassetid://16782323002",
        "The private server owner has to manually start this duel"
    },
    {
        "PlayersPerTeam",
        "Slider",
        "Players Per Team",
        "rbxassetid://105821004981978",
        "Turn on Infinite Players if you have a big party"
    },
    {
        "UnlimitedTime",
        "Toggle",
        "Unlimited Time",
        "rbxassetid://18195730712",
        "The timer won't end while playing this duel"
    },
    {
        "CanSelfQueue",
        "Toggle",
        "Play Solo",
        "rbxassetid://17738769051",
        "Allows you to play this duel by yourself"
    },
    {
        "DisableOOB",
        "Toggle",
        "Out of Bounds",
        "rbxassetid://89987125943326",
        "Go out of bounds in any map"
    }
}
local t_10 = setmetatable({}, Page_m)
t_10.__index = t_10

function t_10._new() -- line: 27
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t_10 (copy)

    local t_11 = setmetatable(Page_m.new(script.Name), t_10)
    t_11.CloseButton = t_11.PageFrame:WaitForChild("Close")
    t_11.List = t_11.PageFrame:WaitForChild("List")
    t_11.Container = t_11.List:WaitForChild("Container")
    t_11.Layout = t_11.Container:WaitForChild("Layout")
    t_11.HeaderFrame = t_11.Container:WaitForChild("Header")
    t_11.HeaderTitle = t_11.HeaderFrame:WaitForChild("Title")
    t_11._client_queue_pad = nil
    t_11._setting_objects = {}
    t_11._connections = {}
    t_11:_Init()

    return t_11
end

function t_10.SetQueuePad(arg1, arg2) -- line: 50
    for _, val in pairs(arg1._connections) do
        val:Disconnect()
    end

    arg1._connections = {}
    arg1._client_queue_pad = arg2

    if not arg1._client_queue_pad then
        return
    end

    arg1.HeaderTitle.Text = arg2:Get("Model").Name

    for _, val_1 in pairs(arg1._setting_objects) do
        val_1.RegenerateSettingsInfo()
    end

    local function update() -- line: 68
        -- upvalues:
        --  [1] arg1 (copy)

        for key_2, val_2 in pairs(arg1._setting_objects) do
            local v4 = arg1._client_queue_pad:Get(key_2)

            if v4 == nil then
                v4 = val_2.SettingObject.SettingsInfo.DefaultValue
            end

            val_2.SettingObject:SetValue(v4, true, true)
        end
    end

    table.insert(arg1._connections, arg1._client_queue_pad.Activity:Connect(update))
    update()
end

function t_10.Close(arg3, ...) -- line: 81
    -- upvalues:
    --  [1] Page_m (copy)

    arg3:SetQueuePad(nil)
    Page_m.Close(arg3, ...)
end

function t_10._GetSettingsInfoValueParams(arg4, arg5) -- line: 90
    -- upvalues:
    --  [1] Players (copy)
    --  [2] DuelLibrary_m (copy)

    if
        arg5 == "InfinitePlayersPerTeam"
        or arg5 == "UnlimitedTime"
        or arg5 == "CanSelfQueue"
        or arg5 == "DisableOOB"
    then
        return false, nil
    end

    local v5

    if arg5 == "PlayersPerTeam" then
        v5 = arg4._client_queue_pad

        if v5 then
            v5 = arg4._client_queue_pad:Get("QueueName")
        end

        local v6 = v5

        if v6 then
            v6 = arg4._client_queue_pad:GetMatchmakingQueueInfoFromQueueName(v5)
        end

        v5 = v6 and v6.PlayersPerTeam or 1

        return v5, 1, arg4._client_queue_pad and arg4._client_queue_pad:GetMaxPlayersPerTeam() or 1, 1
    end

    if arg5 == "QueueName" then
        v5 = if arg4._client_queue_pad then arg4._client_queue_pad:GetDuelLogics(
            Players.LocalPlayer
        ) or { "???" } else { "???" }
        local v8 = arg4._client_queue_pad

        if v8 then
            v8 = arg4._client_queue_pad:Get("OriginalQueueName")
        end

        local v9 = v8 and DuelLibrary_m.MatchmakingQueues[v8]
        v8 = v9 and (v9.TitleName or v9.DisplayName)
        v9 = v8 and table.find(v5, v8) and v8 or v5[1]

        return v9, v5
    end

    if arg5 == "MapPool" then
        return "By Gamemode", { "Unrestricted", "By Gamemode", "Specific Map" }
    end

    local v10

    if arg5 == "MapPoolGamemode" then
        v10 = if arg4._client_queue_pad then arg4._client_queue_pad:GetMapPools(Players.LocalPlayer) or {
            "???"
        } else { "???" }
        local v11 = arg4._client_queue_pad

        if v11 then
            v11 = arg4._client_queue_pad:Get("QueueName")
        end

        local v12 = v11

        if v12 then
            v12 = arg4._client_queue_pad:GetMatchmakingQueueInfoFromQueueName(v11)
        end

        v11 = v12 and v12.DisplayName and table.find(v10, v12.DisplayName) and v12.DisplayName or v10[1]

        return v11, v10
    end

    if arg5 == "MapPoolSpecific" then
        v10 = if arg4._client_queue_pad then arg4._client_queue_pad:GetSortedMapNames() or { "???" } else {
            "???"
        }

        return v10[1], v10
    end

    assert(false, arg5)
end

function t_10._Setup(arg6) -- line: 125
    -- upvalues:
    --  [1] t (copy)
    --  [2] Settings (copy)
    --  [3] SettingsInfo_m (copy)
    --  [4] ReplicatedStorage (copy)

    for key_3, val_3 in pairs(t) do
        local v13, v14, v15, v16, v17 = table.unpack(val_3)
        local v18 = require(Settings[v14])

        local function regenerate_settings_info() -- line: 130
            -- upvalues:
            --  [1] SettingsInfo_m (ref)
            --  [2] v15 (copy)
            --  [3] v16 (copy)
            --  [4] v17 (copy)
            --  [5] v14 (copy)
            --  [6] arg6 (copy)
            --  [7] v13 (copy)

            return SettingsInfo_m.new(
                "",
                "",
                v15,
                v16,
                v17,
                v14,
                arg6:_GetSettingsInfoValueParams(v13)
            )
        end

        local v23 = v18.new(regenerate_settings_info())
        v23.SettingFrame.LayoutOrder = key_3
        v23.SettingFrame.Parent = arg6.Container
        v23.Replicate:Connect(function() -- line: 138
            -- upvalues:
            --  [1] arg6 (copy)
            --  [2] ReplicatedStorage (ref)
            --  [3] v13 (copy)
            --  [4] v23 (copy)

            if arg6._client_queue_pad then
                ReplicatedStorage.Remotes.PrivateServer.EditQueuePad:FireServer(
                    arg6._client_queue_pad:Get("ObjectID"),
                    v13,
                    v23.Value
                )
            end
        end)
        local t_12 = { SettingObject = v23, RegenerateSettingsInfo = nil }

        function t_12.RegenerateSettingsInfo() -- line: 146
            -- upvalues:
            --  [1] v23 (copy)
            --  [2] regenerate_settings_info (copy)

            v23:SetSettingsInfo(regenerate_settings_info())
        end

        arg6._setting_objects[v13] = t_12
    end

    arg6._setting_objects.MapPool.SettingObject:Scale(0.95)
    arg6._setting_objects.MapPoolGamemode.SettingObject:Scale(0.9)
    arg6._setting_objects.MapPoolSpecific.SettingObject:Scale(0.9)
    arg6._setting_objects.InfinitePlayersPerTeam.SettingObject:Scale(0.95)
    arg6._setting_objects.PlayersPerTeam.SettingObject:Scale(0.9)

    local function update_dependencies() -- line: 158
        -- upvalues:
        --  [1] arg6 (copy)

        arg6._setting_objects.PlayersPerTeam.SettingObject.SettingFrame.Visible = not arg6._setting_objects.InfinitePlayersPerTeam.SettingObject.Value
        local SettingFrame = arg6._setting_objects.MapPoolGamemode.SettingObject.SettingFrame
        SettingFrame.Visible = arg6._setting_objects.MapPool.SettingObject.Value == "By Gamemode"
        local SettingFrame_1 = arg6._setting_objects.MapPoolSpecific.SettingObject.SettingFrame
        SettingFrame_1.Visible = arg6._setting_objects.MapPool.SettingObject.Value == "Specific Map"
    end

    arg6._setting_objects.InfinitePlayersPerTeam.SettingObject.Changed:Connect(update_dependencies)
    arg6._setting_objects.MapPool.SettingObject.Changed:Connect(update_dependencies)
    update_dependencies()
    arg6._setting_objects.QueueName.SettingObject.Changed:Connect(function() -- line: 168
        -- upvalues:
        --  [1] arg6 (copy)

        arg6._setting_objects.PlayersPerTeam.RegenerateSettingsInfo()
        arg6._setting_objects.MapPoolGamemode.RegenerateSettingsInfo()
    end)
end

function t_10._Init(arg7) -- line: 174
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg7.CloseButton.MouseButton1Click:Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:CloseRequest()
    end)
    arg7.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 179
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.List.CanvasSize = UDim2.new(0, 0, 0, arg7.Layout.AbsoluteContentSize.Y)
        local List_1 = arg7.List
        List_1.Active = arg7.Layout.AbsoluteContentSize.Y >= arg7.List.AbsoluteSize.Y
    end)
    arg7:_Setup()
    ButtonEffect_m:Add(arg7.CloseButton)
end

return t_10._new()
