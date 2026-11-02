local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local DropdownSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("DropdownSlot")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local PermissionsPlayersCard = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PermissionsPlayersCard"
)
local PermissionsPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PermissionsPlayerSlot"
)
local PermissionsRoleLabel = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PermissionsRoleLabel"
)
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 21
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.PageContainer = t_1.PageFrame:WaitForChild("Container")
    t_1.CloseButton = t_1.PageContainer:WaitForChild("Close")
    t_1.WaitingFrame = t_1.PageContainer:WaitForChild("Waiting")
    t_1.WaitingDotsFrame = t_1.WaitingFrame:WaitForChild("Dots")
    t_1.List = t_1.PageContainer:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.InfoButton = t_1.Container:WaitForChild("Header"):WaitForChild("Info")
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1._permissions_datas = {}
    t_1._add_role_dropdown_slot = nil
    t_1._players_cards = {}
    t_1._player_slots = {}
    t_1._generate_hash = 0
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 51
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg1, ...)
    arg1:_ClearNewPlayerBox()
    arg1:_CloseAddRoleDropdown()
    task.spawn(arg1._FetchPermissionsDatas, arg1)
end

function t.Close(arg2, ...) -- line: 58
    -- upvalues:
    --  [1] Page_m (copy)

    arg2:_CloseAddRoleDropdown()
    Page_m.Close(arg2, ...)
end

function t._CloseAddRoleDropdown(arg3) -- line: 67
    if arg3._add_role_dropdown_slot then
        arg3._add_role_dropdown_slot:Destroy()
        arg3._add_role_dropdown_slot = nil
    end
end

function t._ClearNewPlayerBox(arg4) -- line: 74
    for _, val in pairs(arg4._players_cards) do
        val.Container.PermissionsNewPlayerSlot.Container.Lookup.Box.Text = ""
    end
end

function t._GetHighestValueTeam(_, arg6) -- line: 80
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)

    local v8 = nil
    local v9 = -math.huge

    for _, val_1 in pairs(arg6) do
        local TeamName = PermissionsLibrary_m.Roles[val_1].TeamName
        local TeamValue = PermissionsLibrary_m.Teams[TeamName].TeamValue

        if v9 < TeamValue then
            v8 = TeamName
            v9 = TeamValue
        end
    end

    return v8
end

function t._GetManageableRoles(_, arg8) -- line: 97
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Utility_m (copy)

    local v11 = PermissionsLibrary_m:GetManageableRoles(
        PlayerDataController_m:Get("PermissionsRoles")
    )

    if arg8 then
        for index = #v11, 1, -1 do
            if table.find(arg8, v11[index]) then
                table.remove(v11, index)
            end
        end
    end

    table.sort(v11, function(arg9, arg10) -- line: 108
        -- upvalues:
        --  [1] PermissionsLibrary_m (ref)
        --  [2] Utility_m (ref)

        local TeamValue_1 = PermissionsLibrary_m.Teams[PermissionsLibrary_m.Roles[arg9].TeamName].TeamValue
        local TeamValue_2 = PermissionsLibrary_m.Teams[PermissionsLibrary_m.Roles[arg10].TeamName].TeamValue

        if TeamValue_1 ~= TeamValue_2 then
            return TeamValue_1 > TeamValue_2
        end

        local RoleValue = PermissionsLibrary_m.Roles[arg9].RoleValue
        local RoleValue_1 = PermissionsLibrary_m.Roles[arg10].RoleValue

        if RoleValue ~= RoleValue_1 then
            return RoleValue_1 < RoleValue
        end

        return Utility_m:StringLessThan(
            PermissionsLibrary_m.Roles[arg9].DisplayName,
            PermissionsLibrary_m.Roles[arg10].DisplayName
        )
    end)
    local t_2 = {}

    for key_2, val_2 in pairs(v11) do
        t_2[key_2] = PermissionsLibrary_m.Roles[val_2].DisplayName
    end

    return t_2
end

function t._RoleManagement(arg11, arg12, arg13) -- line: 135
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg12 or not arg13 then
        return
    end

    arg11:_SetWaitingFrameVisible(true)
    local Success, Result = pcall(function() -- line: 142
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg12 (copy)
        --  [3] arg13 (copy)

        return ReplicatedStorage.Remotes.Permissions.RoleManagement:InvokeServer(arg12, arg13)
    end)

    if not Success then
        warn("Failed to manage role, error:", Result)
    end

    arg11:_SetWaitingFrameVisible(false)
end

function t._GetNewUserID(arg14, arg15) -- line: 153
    return (tonumber(
        (string.sub(
            arg14._players_cards[arg15].Container.PermissionsNewPlayerSlot.Container.Lookup.Box.Text,
            2
        ))
    ))
end

function t._AddRoleDropdown(arg16, arg17, arg18, arg19) -- line: 157
    -- upvalues:
    --  [1] DropdownSlot_m (copy)
    --  [2] PermissionsLibrary_m (copy)

    arg16:_CloseAddRoleDropdown()
    arg16._add_role_dropdown_slot = DropdownSlot_m.new(arg17, arg16:_GetManageableRoles(arg19))
    arg16._add_role_dropdown_slot.Selected:Connect(function(mouse: Instance) -- line: 162
        -- upvalues:
        --  [1] PermissionsLibrary_m (ref)
        --  [2] arg18 (copy)
        --  [3] arg16 (copy)

        local v15 = PermissionsLibrary_m:GetPermissionsRoleNameFromDisplayName(mouse)
        local v16 = tonumber(arg18) or arg16:_GetNewUserID(arg18)
        arg16:_RoleManagement(v16, v15)
    end)
end

function t._Generate(arg21) -- line: 170
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] ComplianceController_m (copy)
    --  [3] PermissionsPlayerSlot (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] ButtonEffect_m (copy)
    --  [6] Utility_m (copy)
    --  [7] PermissionsRoleLabel (copy)
    --  [8] PlayerDataController_m (copy)

    arg21:_CloseAddRoleDropdown()
    arg21:_ClearNewPlayerBox()

    for _, val_3 in pairs(arg21._player_slots) do
        val_3:Destroy()
    end

    arg21._player_slots = {}
    arg21._generate_hash += 1
    local GenerateHash = arg21._generate_hash
    local v19 = {}
    local t_4 = {}

    local function get_highest_team_name(arg22) -- line: 185
        -- upvalues:
        --  [1] PermissionsLibrary_m (ref)

        local v21 = nil
        local v22 = -math.huge

        for _, val_4 in pairs(arg22) do
            local TeamName_1 = PermissionsLibrary_m.Roles[val_4].TeamName
            local TeamValue_3 = PermissionsLibrary_m.Teams[TeamName_1].TeamValue

            if v22 < TeamValue_3 then
                v21 = TeamName_1
                v22 = TeamValue_3
            end
        end

        return v21
    end

    local function get_highest_role_name(arg23) -- line: 202
        -- upvalues:
        --  [1] PermissionsLibrary_m (ref)

        local v23 = nil
        local v24 = -math.huge

        for _, val_5 in pairs(arg23) do
            local v25 = PermissionsLibrary_m.Roles[val_5]

            if v24 < v25.RoleValue then
                v23 = val_5
                v24 = v25.RoleValue
            end
        end

        return v23
    end

    local v26 = pairs
    local v27 = arg21._permissions_datas and arg21._permissions_datas.Players or {}
    local num

    for key_6, val_6 in v26(v27) do
        num = tonumber(key_6)
        local _ = {}
        table.insert(
            t_4,
            { num, get_highest_team_name(val_6.Roles), get_highest_role_name(val_6.Roles), val_6 }
        )
        table.insert(v19, num)
    end

    local v30 = ComplianceController_m:GetUserInfos(v19)

    if arg21._generate_hash ~= GenerateHash then
        return
    end

    table.sort(t_4, function(arg24, arg25) -- line: 230
        -- upvalues:
        --  [1] PermissionsLibrary_m (ref)

        local v31 = arg24[2] and PermissionsLibrary_m.Teams[arg24[2]].TeamValue or -1
        local v32 = arg25[2] and PermissionsLibrary_m.Teams[arg25[2]].TeamValue or -1

        if v31 ~= v32 then
            return v31 > v32
        end

        v32 = arg24[3] and PermissionsLibrary_m.Roles[arg24[3]].RoleValue or -1
        v31 = arg25[3] and PermissionsLibrary_m.Roles[arg25[3]].RoleValue or -1

        return if v32 == v31 then (arg25[4].AddedTimestamp or math.huge) > (arg24[4].AddedTimestamp or math.huge) else v31 < v32
    end)
    local v34, v35

    for _, val_7 in pairs(t_4) do
        local num, v34, v35, v36 = table.unpack(val_7)

        if #v36.Roles ~= 0 then
            v35 = v30[tostring(num)]
            get_highest_team_name = v35 and v35.DisplayName and v35.DisplayName or "\226\128\162 \226\128\162 \226\128\162"
            v19 = v35 and v35.Username and "@" .. v35.Username or "\226\128\162 \226\128\162 \226\128\162"
            local v35 = PermissionsPlayerSlot:Clone()
            v35.Container.DisplayName.Text = get_highest_team_name
            v35.Container.Username.Text = v19
            v35.Container.UserId.Text = "#" .. num
            v35.Container.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, num)
            v35.Parent = arg21._players_cards[v34].Container
            table.insert(arg21._player_slots, v35)
            ButtonEffect_m:Add(v35.Container.Roles.Add, true)
            v35.Container.Roles.Add.MouseButton1Click:Connect(function() -- line: 271
                -- upvalues:
                --  [1] arg21 (copy)
                --  [2] v36 (copy)
                --  [3] Utility_m (ref)
                --  [4] v35 (copy)
                --  [5] num (copy)

                if #arg21:_GetManageableRoles(v36.Roles) == 0 then
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

                arg21:_AddRoleDropdown(v35.Container.Roles.Add.DropdownContainer, num, v36.Roles)
            end)

            for _, val_8 in pairs(v36.Roles) do
                v34 = PermissionsLibrary_m.Roles[val_8]
                local get_highest_team_name = PermissionsRoleLabel:Clone()
                get_highest_team_name.Display.Title.Text = v34.DisplayName
                local v37 = v34.Color
                local Background = get_highest_team_name.Background

                if not v37 then
                    v37 = Color3.fromRGB(255, 255, 255)
                end

                Background.ImageColor3 = v37
                get_highest_team_name.LayoutOrder = -(PermissionsLibrary_m.Teams[v34.TeamName].TeamValue * 10000 + v34.RoleValue)
                get_highest_team_name.Parent = v35.Container.Roles
                ButtonEffect_m:Add(get_highest_team_name, true)
                get_highest_team_name.MouseButton1Click:Connect(function() -- line: 290
                    -- upvalues:
                    --  [1] PermissionsLibrary_m (ref)
                    --  [2] val_8 (copy)
                    --  [3] PlayerDataController_m (ref)
                    --  [4] Utility_m (ref)
                    --  [5] arg21 (copy)
                    --  [6] num (copy)

                    if not PermissionsLibrary_m:CanManageRole(
                        val_8,
                        PlayerDataController_m:Get("PermissionsRoles")
                    ) then
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

                    arg21:_RoleManagement(num, val_8)
                end)
                local Title = get_highest_team_name.Display.Title
                Title:GetPropertyChangedSignal("TextBounds"):Connect(function() --[[ update ]] -- line: 301
                    -- upvalues:
                    --  [1] get_highest_team_name (copy)
                    --  [2] Title (copy)

                    get_highest_team_name.Size = UDim2.new(0.1, Title.TextBounds.X, 0.1, 0)
                end)
                get_highest_team_name.Size = UDim2.new(0.1, Title.TextBounds.X, 0.1, 0)
            end

            local GenerateHash = v35.Container.Roles.Layout
            GenerateHash:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() --[[ update ]] -- line: 311
                -- upvalues:
                --  [1] v35 (copy)
                --  [2] GenerateHash (copy)

                v35.Size = UDim2.new(0.24, 0, 0.085, GenerateHash.AbsoluteContentSize.Y)
            end)
            v35.Size = UDim2.new(0.24, 0, 0.085, GenerateHash.AbsoluteContentSize.Y)
        end
    end
end

function t._SetWaitingFrameVisible(arg26, arg27) -- line: 320
    arg26.WaitingFrame.Visible = arg27

    if arg26.WaitingFrame then
        arg26.WaitingDotsFrame:AddTag("UILoadingDots")

        return
    end

    arg26.WaitingDotsFrame:RemoveTag("UILoadingDots")
end

function t._SetPermissionsDatas(arg28, arg29) -- line: 330
    local v43 = arg29 or {}
    arg28._permissions_datas = v43
    arg28:_Generate()
end

function t._FetchPermissionsDatas(arg30) -- line: 335
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg30:_CloseAddRoleDropdown()
    arg30:_ClearNewPlayerBox()
    arg30:_SetWaitingFrameVisible(true)
    local Success_1, Result_1 = pcall(function() -- line: 340
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        return ReplicatedStorage.Remotes.Permissions.FetchPermissions:InvokeServer()
    end)

    if not Success_1 then
        warn("Failed to fetch permissions, error:", Result_1)
    elseif not Result_1 then
        warn("Fetching permissions returned nothing!")
    end

    arg30:_SetPermissionsDatas(Success_1 and Result_1)
    arg30:_SetWaitingFrameVisible(false)
end

function t._UpdateLayouts(arg31) -- line: 354
    arg31.CloseButton.Position = UDim2.new(0.975, 0, 0.0225, arg31.PageFrame.AbsoluteSize.Y * 0.125)
    arg31.List.Position = UDim2.new(0.5, 9, 0, arg31.PageFrame.AbsoluteSize.Y * 0.125)
    arg31.List.Size = UDim2.new(0.85, 0, 0, arg31.PageFrame.AbsoluteSize.Y * 0.75)
    arg31.List.CanvasSize = UDim2.new(0, 0, 0, arg31.Layout.AbsoluteContentSize.Y)
end

function t._VerifyOpen(arg32) -- line: 361
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    if not PermissionsLibrary_m:CanViewPermissionsPage(
        PlayerDataController_m:Get("PermissionsRoles")
    ) then
        task.defer(function() -- line: 363
            -- upvalues:
            --  [1] arg32 (copy)

            arg32.Closed:Fire()
        end)
    end
end

function t._Setup(arg33) -- line: 369
    -- upvalues:
    --  [1] PermissionsLibrary_m (copy)
    --  [2] PermissionsPlayersCard (copy)
    --  [3] CONSTANTS_m (copy)
    --  [4] Utility_m (copy)
    --  [5] ButtonEffect_m (copy)

    local update_1

    for key_9, val_9 in pairs(PermissionsLibrary_m.Teams) do
        local v45 = PermissionsPlayersCard:Clone()
        v45.Container.Header.Title.Text = val_9.DisplayName
        v45.Container.Header.Background.ImageColor3 = val_9.Color
        v45.Container.Header.Icon.Image = val_9.Icon
        v45.LayoutOrder = -val_9.TeamValue
        v45.Parent = arg33.Container
        arg33._players_cards[key_9] = v45
        local Layout = v45.Container.Layout
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() --[[ update ]] -- line: 381
            -- upvalues:
            --  [1] v45 (copy)
            --  [2] Layout (copy)

            v45.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)
        end)
        v45.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y)

        local function update_1() --[[ update_headshot ]] -- line: 388
            -- upvalues:
            --  [1] arg33 (copy)
            --  [2] key_9 (copy)
            --  [3] v45 (copy)
            --  [4] CONSTANTS_m (ref)

            local v48 = arg33:_GetNewUserID(key_9)
            v45.Container.PermissionsNewPlayerSlot.Container.Headshot.ImageColor3 = Color3.fromRGB(
                255,
                255,
                255
            )
            v45.Container.PermissionsNewPlayerSlot.Container.Headshot.ImageTransparency = if v48 then 0 else 0.75
            local Headshot_3 = v45.Container.PermissionsNewPlayerSlot.Container.Headshot
            Headshot_3.Image = if not v48 then "rbxassetid://93178222051105" else string.format(
                CONSTANTS_m.HEADSHOT_IMAGE,
                v48
            )
        end

        v45.Container.PermissionsNewPlayerSlot.Container.Lookup.Box.FocusLost:Connect(update_1)
        update_1()
        v45.Container.PermissionsNewPlayerSlot.Container.Lookup.Box:GetPropertyChangedSignal("Text"):Connect(
            function() -- line: 399
                -- upvalues:
                --  [1] v45 (copy)
                --  [2] update_1 (copy)

                if not v45.Container.PermissionsNewPlayerSlot.Container.Lookup.Box:IsFocused() then
                    update_1()
                end
            end
        )
        v45.Container.PermissionsNewPlayerSlot.Container.Roles.Add.MouseButton1Click:Connect(function() -- line: 405
            -- upvalues:
            --  [1] arg33 (copy)
            --  [2] key_9 (copy)
            --  [3] Utility_m (ref)
            --  [4] v45 (copy)

            if not (arg33:_GetNewUserID(key_9) and #arg33:_GetManageableRoles() ~= 0) then
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

            arg33:_AddRoleDropdown(
                v45.Container.PermissionsNewPlayerSlot.Container.Roles.Add.DropdownContainer,
                key_9
            )
        end)
        ButtonEffect_m:Add(v45.Container.PermissionsNewPlayerSlot.Container.Roles.Add, true)
    end
end

function t._Init(arg34) -- line: 421
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] ButtonEffect_m (copy)

    arg34.CloseButton.MouseButton1Click:Connect(function() -- line: 422
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:CloseRequest()
    end)
    arg34.PageFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 426
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:_UpdateLayouts()
    end)
    arg34.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 430
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:_UpdateLayouts()
    end)
    arg34.InfoButton.MouseButton1Click:Connect(function() -- line: 434
        -- upvalues:
        --  [1] arg34 (copy)

        arg34.PromptSystem:Open("ViewPermissionsRoles")
    end)
    PlayerDataController_m:GetDataChangedSignal("PermissionsRoles"):Connect(function() -- line: 438
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:_VerifyOpen()
    end)
    ReplicatedStorage.Remotes.Permissions.UpdatePermissions.OnClientEvent:Connect(function(
        arguments
    ) -- line: 442
        -- upvalues:
        --  [1] arg34 (copy)

        arg34:_SetPermissionsDatas(arguments)
    end)
    arg34:_Setup()
    arg34:_Generate()
    arg34:_UpdateLayouts()
    arg34:_VerifyOpen()
    ButtonEffect_m:Add(arg34.InfoButton)
    ButtonEffect_m:Add(arg34.CloseButton)
end

return t._new()
