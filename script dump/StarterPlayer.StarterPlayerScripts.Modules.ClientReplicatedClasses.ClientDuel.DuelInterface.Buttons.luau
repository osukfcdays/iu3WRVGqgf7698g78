local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ButtonEffect_m = require(Players.LocalPlayer.PlayerScripts.Modules.ButtonEffect)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Updated = Signal_m.new()
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("Buttons")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.ContentsFrame = t_1.Container:WaitForChild("Contents")
    t_1.SwitchItemsFrame = t_1.ContentsFrame:WaitForChild("SwitchItems")
    t_1.SwitchItemsButton = t_1.SwitchItemsFrame:WaitForChild("Button")
    t_1.SwitchItemsTitle = t_1.SwitchItemsButton:WaitForChild("Title")
    t_1.SwitchItemsRemaining = t_1.SwitchItemsButton:WaitForChild("Remaining")
    t_1.SwitchItemsBackgroundOn = t_1.SwitchItemsButton:WaitForChild("BackgroundOn")
    t_1.SwitchItemsBackgroundOff = t_1.SwitchItemsButton:WaitForChild("BackgroundOff")
    t_1.SwitchItemsLastPickedFrame = t_1.SwitchItemsButton:WaitForChild("LastPickedWeapons")
    t_1.LeaveDuelFrame = t_1.ContentsFrame:WaitForChild("LeaveDuel")
    t_1.LeaveDuelButton = t_1.LeaveDuelFrame:WaitForChild("Button")
    t_1.RespawnNowFrame = t_1.ContentsFrame:WaitForChild("RespawnNow")
    t_1.RespawnNowButton = t_1.RespawnNowFrame:WaitForChild("Button")
    t_1.RespawnNowVisualsFrame = t_1.RespawnNowButton:WaitForChild("Visuals")
    t_1.RespawnNowBar = t_1.RespawnNowVisualsFrame:WaitForChild("Bar"):WaitForChild("Bar")
    t_1.RespawnInputsFrame = t_1.RespawnNowVisualsFrame:WaitForChild("Inputs")
    t_1.RespawnVisualsTitle = t_1.RespawnNowVisualsFrame:WaitForChild("Title")
    t_1.RespawnNowWaitingFrame = t_1.RespawnNowButton:WaitForChild("Waiting")
    t_1.RespawnNowWaitingDotsFrame = t_1.RespawnNowWaitingFrame:WaitForChild("Dots")
    t_1.SwitchTeamFrame = t_1.ContentsFrame:WaitForChild("SwitchTeam")
    t_1.SwitchTeamButton = t_1.SwitchTeamFrame:WaitForChild("Button")
    t_1.SwitchTeamText = t_1.SwitchTeamButton:WaitForChild("Team")
    t_1.SwitchTeamBackground = t_1.SwitchTeamButton:WaitForChild("Background")
    t_1._destroyed = false
    t_1._respawn_now_animation_hash = 0
    t_1._respawn_now_visible_until = 0
    t_1._respawn_now_is_timer_only = false
    t_1._last_picked_weapon_images = {}
    t_1:_Init()

    return t_1
end

function t.IsLeaveDuelVisible(arg2) -- line: 63
    return arg2.LeaveDuelFrame.Visible
end

function t.IsSwitchItemsVisible(arg3) -- line: 67
    return arg3.SwitchItemsFrame.Visible
end

function t.IsRespawnNowVisible(arg4) -- line: 71
    return arg4.RespawnNowFrame.Visible
end

function t.IsSwitchTeamVisible(arg5) -- line: 75
    return arg5.SwitchTeamFrame.Visible
end

function t.IsAnythingVisible(arg6) -- line: 79
    return arg6:IsLeaveDuelVisible() or arg6:IsSwitchItemsVisible() or arg6:IsRespawnNowVisible() or arg6:IsSwitchTeamVisible()
end

function t.SwitchItemsRequest(arg7) -- line: 83
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] ReplicatedStorage (copy)

    if
        arg7.DuelInterface.ClientDuel.LocalDueler
        and arg7.DuelInterface.ClientDuel.LocalDueler:GetStaggeredSpawnsTurn()
    then
        Pages_m:OpenPickWeaponsPage()

        return
    end

    ReplicatedStorage.Remotes.Duels.SwitchItems:FireServer()
end

function t.RespawnNowRequest(arg8) -- line: 91
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if arg8._respawn_now_is_timer_only then
        return
    end

    arg8.RespawnNowWaitingFrame.Visible = true
    arg8.RespawnNowVisualsFrame.Visible = false
    ReplicatedStorage.Remotes.Duels.RespawnNow:FireServer()
end

function t.RespawnNowAnimation(arg9, arg10) -- line: 102
    local v2 = arg9.DuelInterface.ClientDuel:Get("RespawnDelay") or 0
    arg9._respawn_now_visible_until = tick() + v2
    arg9._respawn_now_is_timer_only = arg10
    arg9._respawn_now_animation_hash += 1
    local RespawnNowAnimationHash = arg9._respawn_now_animation_hash
    arg9.RespawnInputsFrame.Visible = not arg9._respawn_now_is_timer_only
    arg9.RespawnVisualsTitle.Text = if arg9._respawn_now_is_timer_only then "Respawning" else "Respawn"
    local RespawnVisualsTitle_1 = arg9.RespawnVisualsTitle
    RespawnVisualsTitle_1.Size = arg9._respawn_now_is_timer_only and UDim2.new(0.9, 0, 0.5, 0) or UDim2.new(
        0.9,
        0,
        0.575,
        0
    )
    arg9.RespawnNowWaitingFrame.Visible = false
    arg9.RespawnNowVisualsFrame.Visible = true
    arg9.RespawnNowBar.Size = UDim2.new(0, 0, 1, 0)
    arg9.RespawnNowBar:TweenSize(
        UDim2.new(1, 0, 1, 0),
        "Out",
        "Linear",
        v2,
        true,
        function() -- line: 117
            -- upvalues:
            --  [1] RespawnNowAnimationHash (copy)
            --  [2] arg9 (copy)

            wait(1)

            if RespawnNowAnimationHash ~= arg9._respawn_now_animation_hash then
                return
            end

            arg9.RespawnNowBar.Size = UDim2.new(0, 0, 1, 0)
        end
    )
    arg9:Update()
end

function t.Update(arg11) -- line: 130
    -- upvalues:
    --  [1] GameplayUtility_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] ItemLibrary_m (copy)
    --  [4] DuelLibrary_m (copy)

    for _, val in pairs(arg11._last_picked_weapon_images) do
        val:Destroy()
    end

    arg11._last_picked_weapon_images = {}
    local Visible = arg11.LeaveDuelFrame.Visible
    local Visible_1 = arg11.SwitchItemsFrame.Visible
    local Visible_5 = arg11.SwitchItemsBackgroundOn.Visible
    local Visible_2 = arg11.SwitchItemsBackgroundOff.Visible
    local Visible_3 = arg11.RespawnNowFrame.Visible
    local Visible_4 = arg11.SwitchTeamFrame.Visible
    local v5 = arg11.DuelInterface.ClientDuel.LocalDueler

    if v5 then
        v5 = not arg11.DuelInterface:IsPageOpen()

        if v5 then
            v5 = not arg11.DuelInterface.Voting:IsOpen()
        end
    end

    local v6 = arg11.DuelInterface.ClientDuel.LocalDueler

    if v6 then
        v6 = arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter

        if v6 then
            v6 = arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter:IsAlive()
        end
    end

    local v7 = not v6 or arg11.DuelInterface.ClientDuel:Get("WasSelfQueued") or arg11.DuelInterface.ClientDuel:Get(
        "IsCurrentArcadeDuel"
    ) and arg11.DuelInterface.Scoreboard:IsOpen()
    local v8 = v5

    if v8 then
        v8 = v7

        if v8 then
            v8 = arg11.DuelInterface.ClientDuel:CanLeave()

            if v8 then
                v8 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then arg11.DuelInterface.Scoreboard:IsOpen() else false
            end
        end
    end

    arg11.LeaveDuelFrame.Visible, v8 = v8, v5
    v8 = v8 and not v6 and tick() < arg11._respawn_now_visible_until
    arg11.RespawnNowFrame.Visible = v8
    v8 = if not v5 then 0 else (arg11.DuelInterface.ClientDuel.LocalDueler:Get("SwitchItemsMax") or math.huge) - arg11.DuelInterface.ClientDuel.LocalDueler:Get(
        "SwitchItemsCount"
    )
    v7 = if arg11.DuelInterface.ClientDuel:Get("CanSwitchItems") == "WhileInvincible" then if v6 then arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter.Entity:Get(
        "IsInvincible"
    ) or (if arg11.DuelInterface.ClientDuel:Get("CanSwitchItems") ~= true then false else true) else if arg11.DuelInterface.ClientDuel:Get(
        "CanSwitchItems"
    ) ~= true then false else true else if arg11.DuelInterface.ClientDuel:Get("CanSwitchItems") ~= true then false else true
    local v10 = v5

    if v10 then
        v10 = arg11.DuelInterface.ClientDuel.LocalDueler

        if v10 then
            v10 = arg11.DuelInterface.ClientDuel.LocalDueler:GetStaggeredSpawnsTurn()
        end
    end

    local v11 = v5

    if v11 then
        if v6 then
            if not v7 then
                v11 = v10

                if v11 then
                    v11 = not arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter:Get(
                        "CanPickWeapons"
                    )

                    if v11 then
                        if not arg11.DuelInterface.ClientDuel:Get("ArcadeMode") then
                            if not (arg11.DuelInterface.ClientDuel:Get("RoundNum") > 1) then
                                v11 = v10

                                if v11 then
                                    v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                        arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                        PlayerDataController_m
                                    ) else false
                                end
                            else
                                v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                    arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                    PlayerDataController_m
                                ) else false
                            end
                        else
                            v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                PlayerDataController_m
                            ) else false
                        end
                    end
                end
            else
                v11 = not arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter:Get(
                    "CanPickWeapons"
                )

                if v11 then
                    if not arg11.DuelInterface.ClientDuel:Get("ArcadeMode") then
                        if not (arg11.DuelInterface.ClientDuel:Get("RoundNum") > 1) then
                            v11 = v10

                            if v11 then
                                v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                    arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                    PlayerDataController_m
                                ) else false
                            end
                        else
                            v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                PlayerDataController_m
                            ) else false
                        end
                    else
                        v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                            arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                            PlayerDataController_m
                        ) else false
                    end
                end
            end
        else
            v11 = v10

            if v11 then
                v11 = not arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter:Get(
                    "CanPickWeapons"
                )

                if v11 then
                    if not arg11.DuelInterface.ClientDuel:Get("ArcadeMode") then
                        if not (arg11.DuelInterface.ClientDuel:Get("RoundNum") > 1) then
                            v11 = v10

                            if v11 then
                                v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                    arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                    PlayerDataController_m
                                ) else false
                            end
                        else
                            v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                                arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                                PlayerDataController_m
                            ) else false
                        end
                    else
                        v11 = if arg11.DuelInterface.ClientDuel:Get("Status") ~= "GameOver" then GameplayUtility_m:SwitchingWeaponsMakesSense(
                            arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter,
                            PlayerDataController_m
                        ) else false
                    end
                end
            end
        end
    end

    v7 = if not (v8 < math.huge) then v10 else true
    arg11.SwitchItemsFrame.Visible = v11
    local SwitchItemsTitle = arg11.SwitchItemsTitle
    local v12 = v7 and UDim2.new(0.5, 0, 0.375, 0) or UDim2.new(0.5, 0, 0.5, 0)
    SwitchItemsTitle.Position = v12
    v12 = if not v10 then "Switch Weapons" else "Pick Weapons"
    arg11.SwitchItemsTitle.Text = v12
    local SwitchItemsRemaining = arg11.SwitchItemsRemaining

    if v10 then
        v12 = "before you spawn"
    elseif v7 then
        v12 = string.format("%s switch%s remaining", v8, if v8 ~= 1 then "es" else "")
    else
        v12 = ""
    end

    SwitchItemsRemaining.Text = v12
    local SwitchItemsBackgroundOn = arg11.SwitchItemsBackgroundOn
    v12 = v10 or v8 > 0
    SwitchItemsBackgroundOn.Visible = v12
    arg11.SwitchItemsBackgroundOff.Visible = not arg11.SwitchItemsBackgroundOn.Visible

    if v10 then
        local v16 = pairs
        v12 = arg11.DuelInterface.ClientDuel.LocalDueler.ClientFighter:Get("LastPickedWeapons") or {}

        for key_1, val_1 in v16(v12) do
            v8 = PlayerDataController_m:GetWeaponData(val_1)
            v7 = Instance.new("ImageLabel")
            v7.AnchorPoint = Vector2.new(0.5, 0.5)
            v7.Size = UDim2.new(3, 0, 3, 0)
            v7.BackgroundTransparency = 1
            v7.LayoutOrder = key_1
            v7.ZIndex = key_1
            local v17 = v8 and ItemLibrary_m:GetViewModelImageFromWeaponData(v8) or ItemLibrary_m:GetViewModelImage(
                val_1
            ) or ""
            v7.Image = v17
            v7.Parent = arg11.SwitchItemsLastPickedFrame
            table.insert(arg11._last_picked_weapon_images, v7)
        end
    end

    v10 = arg11:_GetNextTeamID()
    v6 = arg11.DuelInterface.ClientDuel.LocalDueler

    if v6 then
        v6 = arg11.DuelInterface.ClientDuel:CountTeam(
            arg11.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
        )
    end

    local v18 = v10

    if v18 then
        v18 = arg11.DuelInterface.ClientDuel:CountTeam(v10)
    end

    local v19 = v5

    if v19 then
        v19 = v11

        if v19 then
            v19 = v10

            if v19 then
                v19 = arg11.DuelInterface.ClientDuel:Get("ArcadeMode")

                if v19 then
                    v19 = arg11.DuelInterface.ClientDuel.LocalDueler

                    if v19 then
                        v19 = not arg11.DuelInterface.ClientDuel.LocalDueler:Get("JustSwitchedTeam")

                        if v19 then
                            v19 = arg11.DuelInterface.Scoreboard:IsOpen()
                        end
                    end
                end
            end
        end
    end

    v11 = v19 and v6 and v18 and v6 > 1 and v6 > v18
    arg11.SwitchTeamFrame.Visible = v19
    local SwitchTeamText = arg11.SwitchTeamText
    SwitchTeamText.Text = if not v10 then "" else "to " .. DuelLibrary_m.TeamsByID[v10].TeamName
    local SwitchTeamBackground = arg11.SwitchTeamBackground
    SwitchTeamBackground.ImageColor3 = v11 and DuelLibrary_m:GetTeamColor(v10) or DuelLibrary_m.EMPTY_TEAM_COLOR
    v19 = arg11.LeaveDuelFrame.Visible ~= Visible or arg11.SwitchItemsFrame.Visible ~= Visible_1 or arg11.SwitchItemsBackgroundOn.Visible ~= Visible_5 or arg11.SwitchItemsBackgroundOff.Visible ~= Visible_2 or arg11.RespawnNowFrame.Visible ~= Visible_3 or arg11.SwitchTeamFrame.Visible ~= Visible_4

    if v19 then
        arg11.Updated:Fire()
    end
end

function t.Destroy(arg12) -- line: 240
    arg12._destroyed = true
    arg12.Updated:Destroy()
end

function t._GetNextTeamID(arg13) -- line: 249
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    local v21 = arg13.DuelInterface.ClientDuel.LocalDueler

    if v21 then
        v21 = arg13.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
    end

    local v22 = arg13.DuelInterface.ClientDuel:Get("NumTeams")

    if not v21 or not v22 or v22 <= 1 then
        return
    end

    return DuelLibrary_m.Teams[DuelLibrary_m.TeamsByID[v21].TeamIndex % v22 + 1].TeamID
end

function t._UpdateRespawnNowDots(arg14) -- line: 260
    if arg14.RespawnNowWaitingFrame.Visible then
        arg14.RespawnNowWaitingDotsFrame:AddTag("UILoadingDots")

        return
    end

    arg14.RespawnNowWaitingDotsFrame:RemoveTag("UILoadingDots")
end

function t._UpdateVisibility(arg15) -- line: 268
    arg15.Frame.Visible = not arg15.DuelInterface.FinalResults:IsActive()
end

function t._UpdateParent(arg16) -- line: 272
    if arg16._destroyed then
        return
    end

    pcall(function() -- line: 277
        -- upvalues:
        --  [1] arg16 (copy)

        local ContentsFrame = arg16.ContentsFrame
        ContentsFrame.Parent = arg16.DuelInterface.Scoreboard:IsOpen() and arg16.DuelInterface.Scoreboard.ButtonsContainer or arg16.Container
    end)
end

function t._Init(arg17) -- line: 282
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] Utility_m (copy)
    --  [3] ButtonEffect_m (copy)

    arg17.SwitchItemsButton.MouseButton1Click:Connect(function() -- line: 283
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:SwitchItemsRequest()
    end)
    arg17.RespawnNowButton.MouseButton1Click:Connect(function() -- line: 287
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:RespawnNowRequest()
    end)
    arg17.LeaveDuelButton.MouseButton1Click:Connect(function() -- line: 291
        -- upvalues:
        --  [1] arg17 (copy)

        arg17.DuelInterface.ClientDuel:LeaveDuelRequest()
    end)
    arg17.SwitchTeamButton.MouseButton1Click:Connect(function() -- line: 295
        -- upvalues:
        --  [1] ReplicatedStorage (ref)
        --  [2] arg17 (copy)
        --  [3] Utility_m (ref)

        if not ReplicatedStorage.Remotes.Duels.SwitchTeam:InvokeServer(arg17:_GetNextTeamID()) then
            Utility_m:CreateSound(
                "rbxassetid://17153811469",
                2,
                1,
                script,
                true,
                5
            )
        end
    end)
    arg17.DuelInterface.FinalResults.Activated:Connect(function() -- line: 303
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateVisibility()
    end)
    arg17.DuelInterface.Scoreboard.VisibilityChanged:Connect(function() -- line: 307
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:Update()
        arg17:_UpdateParent()
    end)
    arg17.DuelInterface.Voting.VisibilityChanged:Connect(function() -- line: 312
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:Update()
    end)
    arg17.RespawnNowWaitingFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 316
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateRespawnNowDots()
    end)
    arg17:_UpdateVisibility()
    task.defer(arg17._UpdateParent, arg17)
    ButtonEffect_m:Add(arg17.LeaveDuelButton)
    ButtonEffect_m:Add(arg17.RespawnNowButton)
    ButtonEffect_m:Add(arg17.SwitchItemsButton)
    ButtonEffect_m:Add(arg17.SwitchTeamButton)
end

return t
