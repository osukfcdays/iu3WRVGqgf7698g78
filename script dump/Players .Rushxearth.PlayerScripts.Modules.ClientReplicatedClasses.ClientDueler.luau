local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local _ = require(Players.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local HeadHoncho_m = require(script:WaitForChild("HeadHoncho"))
local TeammateLabel = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("TeammateLabel")
local DefaultDueler = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("DefaultDueler")
local ISMATCHMAKINGSERVER = CONSTANTS_m.IS_MATCHMAKING_SERVER
local t = setmetatable({}, ReplicatedClass_m)
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 22
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] HeadHoncho_m (copy)

    local t_1 = setmetatable(ReplicatedClass_m.new(arg1), t)
    t_1.Died = Signal_m.new()
    t_1.EntityAdded = Signal_m.new()
    t_1.HealthChanged = Signal_m.new()
    t_1.Eliminated = Signal_m.new()
    t_1.ItemAdded = Signal_m.new()
    t_1.ItemRemoved = Signal_m.new()
    local v3 = arg1.Player

    if not v3 then
        v3 = arg2 and arg2.Player
    end

    t_1.Player = v3
    t_1.ClientFighter = arg2
    t_1.ClientDuel = arg3
    t_1.IsLocalPlayer = t_1.ClientFighter.IsLocalPlayer
    t_1.HeadHoncho = HeadHoncho_m.new(t_1)
    t_1._destroyed = false
    t_1._connections = {}
    t_1._is_ally = false
    t_1._ally_highlight = nil
    t_1._ally_label = nil
    t_1._preloaded_character_model = nil
    t_1._is_preloading_character_model = false
    t_1._recorded_viewmodel_details = {}
    t_1._viewmodel_detail_check = {}
    t_1:_Init()

    return t_1
end

function t.IsAlive(arg4) -- line: 57
    local v4 = arg4.ClientFighter

    if v4 then
        v4 = arg4.ClientFighter:IsAlive()
    end

    return v4
end

function t.IsRendered(arg5) -- line: 61
    return arg5.ClientDuel:IsRendered()
end

function t.CanShowRankToLocalPlayer(arg6) -- line: 65
    -- upvalues:
    --  [1] ISMATCHMAKINGSERVER (copy)

    local v5 = not ISMATCHMAKINGSERVER or arg6.IsLocalPlayer or not arg6.ClientDuel.LocalDueler or arg6.ClientDuel.LocalDueler:Get(
        "TeamID"
    ) and (if arg6.ClientDuel.LocalDueler:Get("TeamID") ~= arg6:Get("TeamID") then false else true)

    return v5
end

function t.GetHealth(arg7) -- line: 69
    return arg7.ClientFighter and arg7.ClientFighter:GetHealth() or 0
end

function t.GetMaxHealth(arg8) -- line: 73
    return arg8.ClientFighter and arg8.ClientFighter:GetMaxHealth() or 100
end

function t.GetCharacterModel(arg9) -- line: 77
    -- upvalues:
    --  [1] DefaultDueler (copy)

    return (arg9._preloaded_character_model or DefaultDueler):Clone()
end

function t.GetCharacterModelForCutscene(arg10) -- line: 81
    -- upvalues:
    --  [1] DefaultDueler (copy)

    local v10 = (arg10._preloaded_character_model or DefaultDueler):Clone()

    for _, descendant in pairs(v10:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
        end
    end

    if v10:FindFirstChild("HumanoidRootPart") then
        v10.HumanoidRootPart.Anchored = true
    end

    return v10
end

function t.GetRandomPlayedViewModelDetails(arg11, arg12) -- line: 103
    -- upvalues:
    --  [1] Utility_m (copy)

    table.sort(arg11._recorded_viewmodel_details, function(arg13, arg14) -- line: 104
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:StringLessThan(arg13.ViewModelName, arg14.ViewModelName)
    end)
    local v12 = false

    if #arg11._recorded_viewmodel_details > 0 then
        v12 = arg11._recorded_viewmodel_details[(arg12 or Random.new()):NextInteger(
            1,
            #arg11._recorded_viewmodel_details
        )]
    end

    return v12
end

function t.GetStaggeredSpawnsTurn(arg15) -- line: 111
    return table.find(
        arg15.ClientDuel:Get("StaggeredSpawnsOrder") and arg15.ClientDuel:Get(
            "StaggeredSpawnsOrder"
        )[arg15:Get("TeamID")] or {},
        arg15.Player.UserId
    )
end

function t.SetAlly(arg16, arg17) -- line: 115
    arg16._is_ally = arg17
    arg16:_UpdateAllyVisuals()
end

function t.ReplicateFromServer(arg18, arg19, ...) -- line: 120
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    if arg19 == "EliminationFeed" then
        if not arg18:IsRendered() then
            return
        end

        arg18.ClientDuel.DuelInterface.EliminationFeed:Play(arg18.Player, ...)

        return
    elseif arg19 == "SummaryDetails" then
        if not arg18.IsLocalPlayer then
            return
        end

        arg18.ClientDuel.DuelInterface.FinalResults.Summary:SetDetails(...)

        return
    else
        ReplicatedClass_m.ReplicateFromServer(arg18, arg19, ...)

        return
    end
end

function t.Destroy(arg20) -- line: 138
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    arg20._destroyed = true

    for _, val in pairs(arg20._connections) do
        val:Disconnect()
    end

    if arg20._ally_highlight then
        arg20._ally_highlight:Destroy()
    end

    if arg20._ally_label then
        arg20._ally_label:Destroy()
    end

    arg20.HeadHoncho:Destroy()
    arg20.Died:Destroy()
    arg20.EntityAdded:Destroy()
    arg20.HealthChanged:Destroy()
    arg20.Eliminated:Destroy()
    arg20.ItemAdded:Destroy()
    arg20.ItemRemoved:Destroy()

    if arg20._preloaded_character_model then
        arg20._preloaded_character_model:Destroy()
        arg20._preloaded_character_model = nil
    end

    if arg20.ClientFighter then
        arg20.ClientFighter:ClearInterface()

        if arg20.ClientFighter.Entity then
            arg20.ClientFighter.Entity:SetTranslucent(false)
        end
    end

    ReplicatedClass_m.Destroy(arg20)
end

function t._UpdateTranslucence(arg21) -- line: 182
    if
        arg21.IsLocalPlayer
        or not arg21.ClientFighter
        or not arg21.ClientFighter.Entity
        or not arg21.ClientDuel:Get("IsSpectating")
    then
        return
    end

    arg21.ClientFighter.Entity:SetTranslucent(
        if arg21.ClientDuel:Get("Status") ~= "RoundStarting" then false else true
    )
end

function t._RecordEquippedViewModelDetails(arg22) -- line: 190
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    local ViewmodelDetailCheck = arg22._viewmodel_detail_check

    if
        not arg22.ClientFighter
        or not arg22.ClientFighter.EquippedItem
        or ViewmodelDetailCheck[arg22.ClientFighter.EquippedItem:Get("ObjectID")]
    then
        return
    end

    arg22._viewmodel_detail_check[arg22.ClientFighter.EquippedItem:Get("ObjectID")] = true
    local v18 = arg22.ClientFighter.EquippedItem:GetViewModelDetails()

    if not v18 or ItemLibrary_m.THIRD_PERSON_VIEWMODEL_BLACKLIST[v18.ViewModelName] then
        return
    end

    table.insert(arg22._recorded_viewmodel_details, v18)
end

function t._PreloadCharacterModel(arg23) -- line: 206
    -- upvalues:
    --  [1] Players (copy)

    if arg23._is_preloading_character_model or not arg23.ClientDuel:Get("IsSpectating") then
        return
    end

    arg23._is_preloading_character_model = true

    for _ = 1, 3 do
        wait(1)

        if arg23._destroyed then
            return
        end

        local Success, Result = pcall(
            Players.GetHumanoidDescriptionFromUserIdAsync,
            Players,
            arg23.Player.UserId
        )

        if not Success then
            warn("Failed to fetch humanoid description:", Result)
        else
            if arg23._destroyed then
                return
            end

            Result.Torso = 15365012259
            Result.LeftArm = 15365010034
            Result.RightArm = 15365012263
            Result.LeftLeg = 15365010038
            Result.RightLeg = 15365010030
            local Success_1, Result_1 = pcall(
                Players.CreateHumanoidModelFromDescriptionAsync,
                Players,
                Result,
                Enum.HumanoidRigType.R15
            )

            if not Success_1 then
                warn("Failed to create humanoid model:", Result_1)
            else
                if arg23._destroyed then
                    Result_1:Destroy()

                    return
                end

                arg23._preloaded_character_model = Result_1
            end
        end
    end
end

function t._ClearAllyVisuals(arg24) -- line: 254
    if arg24._ally_highlight then
        arg24._ally_highlight:Destroy()
        arg24._ally_highlight = nil
    end

    if arg24._ally_label then
        arg24._ally_label:Destroy()
        arg24._ally_label = nil
    end
end

function t._UpdateAllyVisuals(arg25) -- line: 266
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] DuelLibrary_m (copy)
    --  [3] TeammateLabel (copy)
    --  [4] CONSTANTS_m (copy)

    arg25:_ClearAllyVisuals()

    if
        arg25.ClientDuel.LocalDueler and (not arg25._is_ally or not arg25:IsAlive())
        or arg25.ClientFighter and (arg25.ClientFighter:Get("IsSpectating") or arg25.ClientFighter:Get(
            "IsHiddenByEmotes"
        ) or arg25.ClientFighter:Get("IsHiddenByCutscene"))
        or PlayerDataController_m:GetSetting("Hide Teammate Icons")
    then
        return
    end

    local v20 = DuelLibrary_m:GetTeamColor(arg25.ClientFighter:Get("TeamID"))
    local v22 = arg25.ClientFighter.Entity and arg25.ClientFighter.Entity:GetHealth() / arg25.ClientFighter.Entity:GetMaxHealth() or 0
    local color = Color3.fromRGB(255, 50, 50):Lerp(
        Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), v22),
        v22
    )
    local color_3 = Color3.new(color.R / 2, color.G / 2, color.B / 2)
    arg25._ally_label = TeammateLabel:Clone()
    arg25._ally_label.Player.BackgroundColor3 = v20
    arg25._ally_label.Player.Headshot.Image = string.format(
        CONSTANTS_m.HEADSHOT_IMAGE,
        arg25.ClientFighter.Player.UserId
    )
    arg25._ally_label.Health.Bar.Visible = v22 > 0 and true
    arg25._ally_label.Health.Bar.Size = UDim2.new(v22, 0, 1, 0)
    arg25._ally_label.Health.BackgroundColor3 = color_3
    arg25._ally_label.Health.UIStroke.Color = Color3.new(
        color.R * 0.25,
        color.G * 0.25,
        color.B * 0.25
    )
    arg25._ally_label.Health.Bar.BackgroundColor3 = color
    arg25._ally_label.Health.Bar.UIStroke.Color = color
    local AllyLabel = arg25._ally_label
    AllyLabel.Parent = arg25.ClientFighter and arg25.ClientFighter.Entity and arg25.ClientFighter.Entity.RootPart or nil
end

function t._Setup(arg26) -- line: 306
    arg26:_RecordEquippedViewModelDetails()
    arg26:_UpdateAllyVisuals()

    if not arg26.ClientFighter then
        return
    end

    table.insert(arg26._connections, arg26.ClientFighter.Died:Connect(function(...) -- line: 314
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.Died:Fire(...)
    end))
    table.insert(arg26._connections, arg26.ClientFighter.EntityAdded:Connect(function(...) -- line: 318
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.EntityAdded:Fire(...)
    end))
    table.insert(arg26._connections, arg26.ClientFighter.HealthChanged:Connect(function(...) -- line: 322
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.HealthChanged:Fire(...)
    end))
    table.insert(arg26._connections, arg26.ClientFighter.Eliminated:Connect(function(...) -- line: 326
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.Eliminated:Fire(...)
    end))
    table.insert(arg26._connections, arg26.ClientFighter.ItemAdded:Connect(function(...) -- line: 330
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.ItemAdded:Fire(...)
    end))
    table.insert(arg26._connections, arg26.ClientFighter.ItemRemoved:Connect(function(...) -- line: 334
        -- upvalues:
        --  [1] arg26 (copy)

        arg26.ItemRemoved:Fire(...)
    end))
    table.insert(arg26._connections, arg26.ClientFighter:GetDataChangedSignal("IsSpectating"):Connect(
        function(...) -- line: 338
            -- upvalues:
            --  [1] arg26 (copy)

            arg26:_UpdateAllyVisuals()
        end
    ))
    table.insert(arg26._connections, arg26.ClientFighter:GetDataChangedSignal("IsHiddenByEmotes"):Connect(
        function(...) -- line: 342
            -- upvalues:
            --  [1] arg26 (copy)

            arg26:_UpdateAllyVisuals()
        end
    ))
    table.insert(arg26._connections, arg26.ClientFighter:GetDataChangedSignal("IsHiddenByCutscene"):Connect(
        function(...) -- line: 346
            -- upvalues:
            --  [1] arg26 (copy)

            arg26:_UpdateAllyVisuals()
        end
    ))
    table.insert(arg26._connections, arg26.ClientFighter.EquippedItemChanged:Connect(function() -- line: 350
        -- upvalues:
        --  [1] arg26 (copy)

        arg26:_RecordEquippedViewModelDetails()
    end))
end

function t._Init(arg27) -- line: 355
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg27.Died:Connect(function() -- line: 356
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateAllyVisuals()
    end)
    arg27.EntityAdded:Connect(function() -- line: 360
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:SetAlly(arg27._is_ally)
    end)
    arg27.HealthChanged:Connect(function() -- line: 364
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateAllyVisuals()
        arg27:_UpdateTranslucence()
    end)
    local Connections_10 = arg27._connections
    local IsSpectating_1 = arg27.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(Connections_10, IsSpectating_1:Connect(function(...) -- line: 369
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateTranslucence()
        arg27:_PreloadCharacterModel()
    end))
    local Connections_11 = arg27._connections
    local Status = arg27.ClientDuel:GetDataChangedSignal("Status")
    table.insert(Connections_11, Status:Connect(function(...) -- line: 374
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateTranslucence()
    end))
    local Connections_12 = arg27._connections
    local v25 = PlayerDataController_m:GetSettingChangedSignal("Hide Teammate Icons")
    table.insert(Connections_12, v25:Connect(function(...) -- line: 378
        -- upvalues:
        --  [1] arg27 (copy)

        arg27:_UpdateAllyVisuals()
    end))
    arg27:_Setup()
    task.spawn(arg27._PreloadCharacterModel, arg27)
end

return t
