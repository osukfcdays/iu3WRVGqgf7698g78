local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel
)
local BundleSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules.BundleSlot)
local RankIcon_m = require(Players.LocalPlayer.PlayerScripts.Modules.RankIcon)
local FinalResultsCameraRig = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "FinalResultsCameraRig"
)
local FinalResultsPlayerSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "FinalResultsPlayerSlot"
)
local t = {}
local t_1 = { ViewModelName = "Assault Rifle" }
t.__index = t

function t.new(arg1) -- line: 28
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] BundleSlot_m (copy)

    local t_2 = setmetatable({}, t)
    t_2.Finished = Signal_m.new()
    t_2.FinalResults = arg1
    t_2.TopFrame = t_2.FinalResults.DuelInterface.Frame:WaitForChild("Top")
    t_2.Frame = t_2.FinalResults.Frame:WaitForChild("Winners")
    t_2.PlayersFrame = t_2.Frame:WaitForChild("Players")
    t_2.TeamFrame = t_2.Frame:WaitForChild("Team")
    t_2.TeamText = t_2.TeamFrame:WaitForChild("Team")
    t_2.TeamShineFrame = t_2.TeamFrame:WaitForChild("Shine"):WaitForChild("Frame")
    t_2.SuperStarterBundleFrame = t_2.Frame:WaitForChild("SuperStarterBundle")
    t_2._destroyed = false
    t_2._skipped = false
    t_2._animation_cleanup = {}
    t_2._static_viewmodels = {}
    t_2._renderstep_id = nil
    t_2._winning_dueler_ids = {}
    t_2._displayed_duelers = {}
    t_2._player_slots = {}
    t_2._final_winning_animation_hash = 0
    t_2._outro_sound = nil
    t_2._superstarterbundle_slot = BundleSlot_m.new("superstarter_bundle")
    t_2:_Init()

    return t_2
end

function t.IsFinished(arg2) -- line: 63
    return arg2._skipped
end

function t.Skip(arg3) -- line: 67
    arg3._skipped = true
    arg3.Finished:Fire()
end

function t.SetVisible(arg4, arg5) -- line: 72
    -- upvalues:
    --  [1] Utility_m (copy)

    arg4.Frame.Visible = arg5
    task.spawn(arg4._PlayFinalWinningAnimation, arg4)

    if not arg5 and arg4._outro_sound and arg4._outro_sound.Volume >= 1.25 then
        task.spawn(
            Utility_m.RenderstepForLoop,
            Utility_m,
            0,
            100,
            2,
            function(arg6) -- line: 77
                -- upvalues:
                --  [1] arg4 (copy)

                arg4._outro_sound.Volume = 1.25 + -0.75 * (arg6 / 100)
            end
        )
    end
end

function t.Play(arg7, arg8, arg9, arg10) -- line: 85
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] StaticViewModel_m (copy)
    --  [3] PreloadController_m (copy)
    --  [4] FinalResultsCameraRig (copy)
    --  [5] TweenService (copy)
    --  [6] RunService (copy)
    --  [7] HttpService (copy)
    --  [8] CameraController_m (copy)
    --  [9] UserInputService (copy)
    --  [10] DuelLibrary_m (copy)
    --  [11] Utility_m (copy)
    --  [12] FinalResultsPlayerSlot (copy)
    --  [13] ComplianceController_m (copy)
    --  [14] CONSTANTS_m (copy)
    --  [15] RankIcon_m (copy)

    arg7.TopFrame.Visible = false
    arg7._winning_dueler_ids = arg9
    local rng = Random.new(arg8)
    local v1

    if #arg9 == 0 then
        v1 = "Tie"
    elseif not arg7.FinalResults.DuelInterface.ClientDuel.LocalDueler then
        v1 = "Win"
    else
        local table_find = table.find
        v1 = if arg7.FinalResults.DuelInterface.ClientDuel.LocalDueler and table_find(
            arg9,
            arg7.FinalResults.DuelInterface.ClientDuel.LocalDueler:Get("DuelerID")
        ) then "Win" else "Lose"
    end

    for _, val in pairs({ arg9, arg10 }) do
        for _, val_1 in pairs(val) do
            for key_2, _ in pairs(arg7.FinalResults.DuelInterface:GetLoggedClientDuelers()) do
                if key_2:Get("DuelerID") == val_1 then
                    table.insert(arg7._displayed_duelers, key_2)
                    break
                end
            end

            if #arg7._displayed_duelers >= 5 then
                break
            end
        end

        if #arg7._displayed_duelers >= 5 then
            break
        end
    end

    local v3, v4 = arg7:_GetWinnersLocation()
    local t_4 = {}

    for key_3, val_3 in pairs(arg7._displayed_duelers) do
        local v6 = val_3:GetCharacterModelForCutscene()
        v6.Name = "Dueler" .. key_3
        v6:SetPrimaryPartCFrame(v4)
        v6.Parent = v3
        table.insert(arg7._animation_cleanup, v6)
        local v8 = val_3:GetRandomPlayedViewModelDetails(rng) or t_1
        local v9 = StaticViewModel_m.new(v8.ViewModelName)

        if v9:HasGripAttachment() then
            v9:DeleteAnimationContextSubModels()
            v9:SetWrap(v8.Wrap)
            v9:SetCharm(v8.Charm)
            v9:ScaleTo(if key_3 == 1 then 1.5 else 1.25)
            v9:InitializeGrip()
            v9:SetParent(v6)
            arg7._static_viewmodels[v9] = v6
        else
            v9:Destroy()
        end

        local Success, Result = pcall(function() -- line: 141
            -- upvalues:
            --  [1] v6 (copy)
            --  [2] PreloadController_m (ref)
            --  [3] key_3 (copy)
            --  [4] t_4 (copy)
            --  [5] arg7 (copy)

            local animationTrack = v6.Humanoid:LoadAnimation(
                PreloadController_m:GetPreloadedAnimation("FinalResultsPlayer" .. key_3)
            )
            animationTrack:Play(0)
            table.insert(t_4, animationTrack)
            table.insert(arg7._animation_cleanup, animationTrack)
        end)

        if not Success then
            warn("Player " .. key_3 .. " failed to animate, error:", Result)
            v6.Parent = nil
        end
    end

    local v13 = FinalResultsCameraRig:Clone()
    v13:PivotTo(v4)
    v13.Parent = arg7.FinalResults.DuelInterface.ClientDuel.Map.Model:FindFirstChild("Winners")
    local animationTrack_1 = nil
    local Success_1, Result_1 = pcall(function() -- line: 160
        -- upvalues:
        --  [1] animationTrack_1 (ref)
        --  [2] v13 (copy)
        --  [3] PreloadController_m (ref)
        --  [4] arg7 (copy)

        animationTrack_1 = v13.AnimationController:LoadAnimation(
            PreloadController_m:GetPreloadedAnimation("FinalResultsCamera")
        )
        animationTrack_1:Play(0)
        table.insert(arg7._animation_cleanup, animationTrack_1)
    end)
    local v15 = 40
    local v16 = false

    local function tween_camera_fov(
        arg11,
        _,
        arg13,
        arg14,
        arg15
    ) -- line: 169
        -- upvalues:
        --  [1] v16 (ref)
        --  [2] v15 (ref)
        --  [3] TweenService (ref)
        --  [4] RunService (ref)

        if v16 then
            return
        end

        local now = tick()

        while true do
            if not (tick() < now + arg11) then
                break
            end

            v15 = 40 + 30 * TweenService:GetValue((tick() - now) / arg11, arg14, arg15)
            RunService.RenderStepped:Wait()

            if not v16 then
                continue
            end

            return
        end

        v15 = arg13
    end

    if not Success_1 then
        warn("Camera failed to animate, error:", Result_1)
    elseif animationTrack_1 then
        animationTrack_1:GetMarkerReachedSignal("Start Sine-Out 70"):Connect(function() -- line: 192
            -- upvalues:
            --  [1] tween_camera_fov (copy)

            tween_camera_fov(
                0.9666666666666667,
                40,
                70,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.Out
            )
        end)
        animationTrack_1:GetMarkerReachedSignal("Start Quad-Out 120"):Connect(function() -- line: 196
            -- upvalues:
            --  [1] tween_camera_fov (copy)

            tween_camera_fov(
                0.75,
                70,
                120,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )
        end)
    end

    arg7._renderstep_id = "FinalResults" .. HttpService:GenerateGUID(false)
    RunService:BindToRenderStep(arg7._renderstep_id, CameraController_m:GetRenderstepPriority() + 1, function(
        _
    ) -- line: 203
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] UserInputService (ref)
        --  [3] v15 (ref)
        --  [4] v13 (copy)

        if not arg7.FinalResults.DuelInterface.ClientDuel:Get("IsSpectating") then
            return
        end

        local Angles = CFrame.Angles
        local v24 = math.sin(tick() * 0.23983 % 6.283185307179586) * 0.017453292519943295
        local v26 = Angles(
            v24,
            math.sin(tick() * 0.372721 % 6.283185307179586) * 0.017453292519943295,
            math.sin(tick() * 0.43123 % 6.283185307179586) * 0.017453292519943295
        )
        UserInputService.MouseIconEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        workspace.CurrentCamera.FieldOfView = v15
        workspace.CurrentCamera.CFrame = v13.Cam.CFrame * v26

        for key_4, val_4 in pairs(arg7._static_viewmodels) do
            key_4:GripPivotTo(val_4)
        end
    end)
    task.delay(12, function() -- line: 226
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] animationTrack_1 (ref)
        --  [3] t_4 (copy)

        if arg7._destroyed then
            return
        end

        if animationTrack_1 then
            animationTrack_1:AdjustSpeed(0)
        end

        for _, val_5 in pairs(t_4) do
            val_5:AdjustSpeed(0)
        end
    end)
    local v27 = arg7.FinalResults.DuelInterface:CreateSound(
        "rbxassetid://18221897857",
        0,
        1,
        script,
        true,
        60
    )

    if v27 then
        v27.Looped = true
    end

    local DuelInterface = arg7.FinalResults.DuelInterface
    local v28 = if v1 ~= "Win" then if not (math.random() < 0.5) then "rbxassetid://18221726246" else "rbxassetid://18239670367" else if not (math.random() < 0.5) then "rbxassetid://18221725850" else "rbxassetid://18239670056"
    arg7._outro_sound = DuelInterface:RawCreateSound(
        v28,
        1.25,
        1,
        script,
        true,
        15,
        nil,
        nil,
        "Music"
    )
    arg7:_WaitWhileNotSkipped(1)

    if arg7._destroyed then
        return
    end

    arg7:_WaitWhileNotSkipped(5)

    if arg7._destroyed then
        return
    end

    if not arg7:IsFinished() then
        arg7.FinalResults.DuelInterface:CreateSound(
            "rbxassetid://18129776757",
            1.25,
            1,
            script,
            true,
            15
        )
    end

    arg7:_WaitWhileNotSkipped(0.45)

    if arg7._destroyed then
        return
    end

    if not arg7:IsFinished() then
        arg7.FinalResults.DuelInterface:CreateSound(
            "rbxassetid://18221897857",
            1.25,
            1,
            script,
            true,
            15
        )
    end

    arg7:_WaitWhileNotSkipped(3.6)

    if arg7._destroyed then
        return
    end

    if arg7:IsFinished() then
        local _ = true
        local _ = 120

        if animationTrack_1 then
            animationTrack_1.TimePosition = 12
            animationTrack_1:AdjustSpeed(0)
        end

        for _, val_6 in pairs(t_4) do
            val_6.TimePosition = 12
            val_6:AdjustSpeed(0)
        end
    end

    local v31 = arg7.FinalResults.DuelInterface.ClientDuel:Get("ScoresBehavior")
    local v32 = arg7.FinalResults.DuelInterface.ClientDuel:Get("ArcadeMode")
    v1 = not v32 or v31 == "Teams"
    local v33 = not v32
    local v34

    for key_7, val_7 in pairs(arg7._displayed_duelers) do
        if not arg7.FinalResults.DuelInterface.ClientDuel.IsRanked then
            v34 = val_7.Player:GetAttribute("StatisticDuelsWinStreak") or 0
        end

        v34 = if arg7.FinalResults.DuelInterface.ClientDuel.IsRanked then nil else val_7.Player:GetAttribute(
            "Level"
        ) or 0
        local v36 = DuelLibrary_m:GetTeamColor(val_7:Get("TeamID"))
        local v37 = Utility_m:SanitizeName(val_7.Player.Name)
        local v38 = FinalResultsPlayerSlot:Clone()
        local v39 = v32
        local Placement = v38.Placement

        if v39 then
            v39 = v31 == "Duelers"
        end

        Placement.Visible = v39
        v38.Placement.Title.Text = "#" .. key_7
        v39 = false
        local MVP = v38.MVP

        if key_7 == 1 then
            v39 = #arg9 > 1 and not v38.Placement.Visible
        end

        MVP.Visible = v39
        v38.Background.ImageColor3 = v36
        local Username = v38.Player.Username
        v39 = if val_7.Player.DisplayName == v37 then "" else "@" .. v37
        Username.Text = v39
        v38.Player.Text = ComplianceController_m:GetName(val_7.Player)
        local Player_1 = v38.Player
        v39 = v38.Player.Username.Text == "" and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(
            0.5,
            0,
            0.4,
            0
        )
        Player_1.Position = v39
        v38.Controls.Image = CONSTANTS_m.CONTROLS_IMAGES_CENTERED[val_7.ClientFighter:Get(
            "Controls"
        )] or ""
        v39 = v34
        local Level = v38.Level

        if v39 then
            v39 = v34 > 0
        end

        Level.Visible = v39
        local Value = v38.Level.Value
        v39 = v34 and Utility_m:PrettyNumber(v34) or ""
        Value.Text = v39
        v38.Performance.Eliminations.Value.Text = Utility_m:PrettyNumber(val_7:Get("Eliminations"))
        v38.Performance.Deaths.Value.Text = Utility_m:PrettyNumber(val_7:Get("Deaths"))
        v38.Performance.Assists.Value.Text = Utility_m:PrettyNumber(val_7:Get("Assists"))
        local DamageDealt = v38.Performance.DamageDealt
        v39 = v33 and UDim2.new(0.333, 0, 3.25, 0) or UDim2.new(0.5, 0, 3.25, 0)
        DamageDealt.Position = v39
        v39 = if not v1 then "Points" else "Damage Dealt"
        v38.Performance.DamageDealt.Title.Text = v39
        local Value_4 = v38.Performance.DamageDealt.Value

        if v1 then
            v39 = Utility_m:PrettyNumber((math.floor(val_7:Get("Damage") + 0.5)))

            if not v39 then
                v39 = v31 == "Duelers" and Utility_m:PrettyNumber(
                    arg7.FinalResults.DuelInterface.ClientDuel:Get("Scores")[val_7:Get("DuelerID")] or 0
                ) or "???"
            end
        else
            v39 = v31 == "Duelers" and Utility_m:PrettyNumber(
                arg7.FinalResults.DuelInterface.ClientDuel:Get("Scores")[val_7:Get("DuelerID")] or 0
            ) or "???"
        end

        Value_4.Text = v39
        v38.Performance.DamageTaken.Visible = v33
        v38.Performance.DamageTaken.Value.Text = Utility_m:PrettyNumber(
            (math.floor(val_7:Get("DamageTaken") + 0.5))
        )
        table.insert(arg7._player_slots, v38)

        if arg7.FinalResults.DuelInterface.ClientDuel.IsRanked then
            RankIcon_m.new(
                if val_7.IsLocalPlayer then arg7.FinalResults.Summary:GetLocalPlayerPreviousELO() else val_7.Player:GetAttribute(
                    "DisplayELO"
                ),
                val_7.Player.UserId
            ):SetParent(v38.Rank)
        end

        local v34 = v38.Player
        local Username_1 = v34.Username
        local Controls_1 = v38.Controls
        local Streak = v38.Streak
        local Level_1 = v38.Level
        local Rank = v38.Rank

        local function update() -- line: 353
            -- upvalues:
            --  [1] v34 (copy)
            --  [2] Username_1 (copy)
            --  [3] Controls_1 (copy)
            --  [4] Streak (copy)
            --  [5] Level_1 (copy)
            --  [6] Rank (copy)

            local maximum = math.max(v34.TextBounds.X, Username_1.TextBounds.X)
            Controls_1.Position = UDim2.new(0.5, maximum / 2, 0.5, 0)
            Streak.Position = UDim2.new(0.5, -maximum / 2, 0.5, 0)
            Level_1.Position = UDim2.new(0.5, -maximum / 2, 0.5, 0)
            Rank.Position = UDim2.new(0.5, -maximum / 2, 0.5, 0)
        end

        v34:GetPropertyChangedSignal("TextBounds"):Connect(update)
        Username_1:GetPropertyChangedSignal("TextBounds"):Connect(update)
        v34.AncestryChanged:Connect(update)
        Username_1.AncestryChanged:Connect(update)
        update()
    end

    arg7:Skip()
end

function t.Destroy(arg17) -- line: 373
    -- upvalues:
    --  [1] RunService (copy)

    arg17._destroyed = true
    arg17._final_winning_animation_hash += 1

    for _, val_8 in pairs(arg17._animation_cleanup) do
        val_8:Destroy()
    end

    for _, val_9 in pairs(arg17._static_viewmodels) do
        val_9:Destroy()
    end

    if arg17._renderstep_id then
        RunService:UnbindFromRenderStep(arg17._renderstep_id)
        arg17._renderstep_id = nil
    end

    arg17.Finished:Destroy()
    arg17._superstarterbundle_slot:Destroy()
end

function t._PlayFinalWinningAnimation(arg18) -- line: 398
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    if not arg18:IsFinished() then
        return
    end

    arg18._final_winning_animation_hash += 1
    local FinalWinningAnimationHash = arg18._final_winning_animation_hash
    local v60 = false

    if #arg18._winning_dueler_ids > 0 then
        v60 = false

        if arg18.FinalResults.DuelInterface.ClientDuel:Get("ScoresBehavior") == "Teams" then
            v60 = arg18._displayed_duelers[1]

            if v60 then
                v60 = arg18._displayed_duelers[1]:Get("TeamID")
            end
        end
    end

    local v61 = DuelLibrary_m:GetTeamColor(v60)
    arg18.SuperStarterBundleFrame.Visible = false
    arg18.TeamFrame.Background.ImageColor3 = v61
    arg18.TeamFrame.Visible = v60 and true
    arg18.TeamFrame.Position = UDim2.new(0.5, 0, 0.16, 40)
    arg18.TeamFrame:TweenPosition(
        UDim2.new(0.5, 0, 0.125, 30),
        "Out",
        "Quint",
        0.25,
        true
    )
    local TeamText = arg18.TeamText
    TeamText.Text = v60 and DuelLibrary_m.TeamsByID[v60].TeamName or ""
    arg18.TeamShineFrame.Position = UDim2.new(-0.5, 0, 0.5, 0)
    arg18.TeamShineFrame:TweenPosition(
        UDim2.new(1.5, 0, 0.5, 0),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Quart,
        1,
        true
    )
    local _ = UDim2.new(1.5, 0, 0.5, 0)

    for key_10, val_10 in pairs(arg18._player_slots) do
        if arg18._final_winning_animation_hash ~= FinalWinningAnimationHash then
            return
        end

        val_10.Parent = arg18.PlayersFrame:FindFirstChild(key_10)
        val_10.Size = UDim2.new(0.45, 0, 0.075, 0)
        val_10.Position = UDim2.new(0.5, 0, 0.4, 0)
        val_10:TweenSizeAndPosition(
            UDim2.new(0.75, 0, 0.125, 0),
            UDim2.new(0.5, 0, 0.5, 0),
            "Out",
            "Quint",
            0.25 * key_10,
            true
        )
        wait(0.125)
    end
end

function t._GetWinnersLocation(arg19) -- line: 436
    local Winners = arg19.FinalResults.DuelInterface.ClientDuel.Map.Model:FindFirstChild("Winners")

    return Winners, Winners and Winners:FindFirstChild("Primary") and Winners.Primary.CFrame or CFrame.identity
end

function t._WaitWhileNotSkipped(arg20, arg21) -- line: 443
    -- upvalues:
    --  [1] RunService (copy)

    local v65 = tick() + arg21

    while true do
        if not (v65 > tick()) or arg20:IsFinished() then
            break
        end

        RunService.RenderStepped:Wait()
    end
end

function t._Setup(arg22) -- line: 451
    arg22.SuperStarterBundleFrame.Visible = false
    arg22._superstarterbundle_slot:SetParent(arg22.SuperStarterBundleFrame)
end

function t._Init(arg23) -- line: 456
    arg23.Finished:Connect(function() -- line: 457
        -- upvalues:
        --  [1] arg23 (copy)

        arg23:_PlayFinalWinningAnimation()
    end)
    arg23:_Setup()
end

return t
