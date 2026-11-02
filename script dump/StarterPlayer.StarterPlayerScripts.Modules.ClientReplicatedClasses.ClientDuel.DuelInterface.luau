local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local EliminatedEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect
)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local Inset_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Inset)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local EliminationFeed_m = require(script:WaitForChild("EliminationFeed"))
local HardcoreParkour_m = require(script:WaitForChild("HardcoreParkour"))
local FinalResults_m = require(script:WaitForChild("FinalResults"))
local RoundResult_m = require(script:WaitForChild("RoundResult"))
local StoryDialog_m = require(script:WaitForChild("StoryDialog"))
local MatchPoint_m = require(script:WaitForChild("MatchPoint"))
local Scoreboard_m = require(script:WaitForChild("Scoreboard"))
local HeadHoncho_m = require(script:WaitForChild("HeadHoncho"))
local Buttons_m = require(script:WaitForChild("Buttons"))
local Scores_m = require(script:WaitForChild("Scores"))
local Voting_m = require(script:WaitForChild("Voting"))
local UpNext_m = require(script:WaitForChild("UpNext"))
local Timer_m = require(script:WaitForChild("Timer"))
local DuelInterface = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("DuelInterface")
local t = {}
t.__index = t

function t.new(arg1) -- line: 30
    -- upvalues:
    --  [1] t (copy)
    --  [2] DuelInterface (copy)
    --  [3] FinalResults_m (copy)
    --  [4] Voting_m (copy)
    --  [5] EliminationFeed_m (copy)
    --  [6] Scoreboard_m (copy)
    --  [7] RoundResult_m (copy)
    --  [8] MatchPoint_m (copy)
    --  [9] Scores_m (copy)
    --  [10] Timer_m (copy)
    --  [11] UpNext_m (copy)
    --  [12] HeadHoncho_m (copy)
    --  [13] HardcoreParkour_m (copy)
    --  [14] StoryDialog_m (copy)
    --  [15] Buttons_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientDuel = arg1
    t_1.Frame = DuelInterface:Clone()
    t_1.FinalResults = FinalResults_m.new(t_1)
    t_1.Voting = Voting_m.new(t_1)
    t_1.EliminationFeed = EliminationFeed_m.new(t_1)
    t_1.Scoreboard = Scoreboard_m.new(t_1)
    t_1.RoundResult = RoundResult_m.new(t_1)
    t_1.MatchPoint = MatchPoint_m.new(t_1)
    t_1.Scores = Scores_m.new(t_1)
    t_1.Timer = Timer_m.new(t_1)
    t_1.UpNext = UpNext_m.new(t_1)
    t_1.HeadHoncho = HeadHoncho_m.new(t_1)
    t_1.HardcoreParkour = HardcoreParkour_m.new(t_1)
    t_1.StoryDialog = StoryDialog_m.new(t_1)
    t_1.Buttons = Buttons_m.new(t_1)
    t_1._destroyed = false
    t_1._connections = {}
    t_1._sounds = {}
    t_1._client_duelers = {}
    t_1:_Init()

    return t_1
end

function t.IsActive(arg2) -- line: 63
    return arg2.Frame.Visible
end

function t.IsPageOpen(_) -- line: 67
    -- upvalues:
    --  [1] Pages_m (copy)

    return Pages_m.PageSystem.CurrentPage ~= nil
end

function t.GetLoggedClientDuelers(arg4, arg5) -- line: 71
    if arg4.ClientDuel:Get("ArcadeMode") then
        local t_2 = {}

        for key, _ in pairs(arg4._client_duelers) do
            if not table.find(arg4.ClientDuel.Duelers, key) then
                t_2[key] = true
            end
        end

        for key_1, _ in pairs(t_2) do
            arg4._client_duelers[key_1] = nil
        end
    end

    if not arg5 then
        return arg4._client_duelers
    end

    local t_3 = {}

    for key_2, _ in pairs(arg4._client_duelers) do
        local t_4 = { ClientDueler = key_2, Score = nil, Damage = nil, DamageTaken = nil }
        local v15 = if not arg4.ClientDuel:Get("ArcadeMode") then -1 else if arg4.ClientDuel:Get(
            "ScoresBehavior"
        ) == "Duelers" then arg4.ClientDuel:Get("Scores")[key_2:Get("DuelerID")] or -1 else if arg4.ClientDuel:Get(
            "ScoresBehavior"
        ) == "Teams" then arg4.ClientDuel:Get("Scores")[key_2:Get("TeamID")] or -1 else false
        t_4.Score = v15
        t_4.Damage = key_2:Get("Damage") or -1
        t_4.DamageTaken = key_2:Get("DamageTaken") or -1
        table.insert(t_3, t_4)
    end

    table.sort(t_3, function(arg6, arg7) -- line: 104
        local v18 = arg6.Score or -1
        local v19 = arg7.Score or -1

        if math.abs(v18 - v19) > 0.01 then
            return v18 > v19
        end

        local v21 = arg6.Damage or -1
        local v22 = arg7.Damage or -1

        if math.abs(v21 - v22) > 0.01 then
            return v22 < v21
        end

        return (arg7.DamageTaken or -1) > (arg6.DamageTaken or -1)
    end)
    local t_5 = {}

    for _, val_3 in pairs(t_3) do
        table.insert(t_5, val_3.ClientDueler)
    end

    return t_5
end

function t.CreateSound(arg8, ...) -- line: 134
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg8:IsActive() then
        return
    end

    local v25 = Utility_m:CreateSound(...)
    table.insert(arg8._sounds, v25)

    return v25
end

function t.RawCreateSound(arg9, ...) -- line: 146
    local v26 = arg9:CreateSound(...)
    local v27 = v26

    if v27 then
        v27 = table.find(arg9._sounds, v26)
    end

    if v27 then
        table.remove(arg9._sounds, v27)
    end

    return v26
end

function t.Destroy(arg10) -- line: 157
    arg10._destroyed = true

    for _, val_4 in pairs(arg10._connections) do
        val_4:Disconnect()
    end

    for _, val_5 in pairs(arg10._sounds) do
        val_5:Destroy()
    end

    arg10._client_duelers = {}
    arg10.EliminationFeed:Destroy()
    arg10.HardcoreParkour:Destroy()
    arg10.FinalResults:Destroy()
    arg10.StoryDialog:Destroy()
    arg10.RoundResult:Destroy()
    arg10.MatchPoint:Destroy()
    arg10.Scoreboard:Destroy()
    arg10.HeadHoncho:Destroy()
    arg10.Buttons:Destroy()
    arg10.Scores:Destroy()
    arg10.Voting:Destroy()
    arg10.UpNext:Destroy()
    arg10.Timer:Destroy()
    arg10.Frame:Destroy()
end

function t._UpdateSpectating(arg11) -- line: 191
    -- upvalues:
    --  [1] GuiService (copy)
    --  [2] EliminatedEffect_m (copy)
    --  [3] Pages_m (copy)
    --  [4] Inset_m (copy)

    for _, val_6 in pairs(arg11._connections) do
        val_6:Disconnect()
    end

    arg11._connections = {}
    arg11.Frame.Visible = arg11.ClientDuel:Get("IsSpectating")
    arg11.HardcoreParkour:Update()

    if not arg11.Frame.Visible then
        return
    end

    table.insert(arg11._connections, arg11.ClientDuel.DuelerRemoved:Connect(function(arg12) -- line: 205
        -- upvalues:
        --  [1] arg11 (copy)

        if arg11.ClientDuel:Get("ArcadeMode") then
            arg11._client_duelers[arg12] = nil
        end

        arg11.Scoreboard:Generate()
    end))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("MaxMapBansPerTeam"):Connect(
        function() -- line: 213
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Voting:Generate()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("VoteBansRemaining"):Connect(
        function() -- line: 217
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Voting:Generate()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("VoteOptions"):Connect(
        function() -- line: 221
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Voting:Generate()
            arg11.Timer:UpdateSizeAndPosition()
            arg11.Scores:Generate()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("ScoreNeededToWin"):Connect(
        function() -- line: 227
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Scores:Generate()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("ScoresBehavior"):Connect(
        function() -- line: 231
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Scores:Generate()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("Status"):Connect(function() -- line: 235
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.Buttons:Update()
        arg11.Scoreboard:Open()
        arg11.HeadHoncho:Update()
        arg11.HardcoreParkour:Update()
        arg11.StoryDialog:Update()
        arg11.UpNext:Update()

        if arg11.ClientDuel:Get("ArcadeMode") and arg11.ClientDuel:Get("Status") == "GameOver" then
            arg11:CreateSound(
                "rbxassetid://99135525400251",
                2,
                1,
                script,
                true,
                5
            )
        end
    end))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("CanSwitchItems"):Connect(
        function() -- line: 249
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("RoundNum"):Connect(function() -- line: 253
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.Buttons:Update()
    end))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("CanTrackStatistics"):Connect(
        function() -- line: 257
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("RematchCount"):Connect(
        function() -- line: 261
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.FinalResults.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("RematchGoal"):Connect(
        function() -- line: 265
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.FinalResults.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("RematchAvailable"):Connect(
        function() -- line: 269
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.FinalResults.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("RematchSuccess"):Connect(
        function() -- line: 273
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.FinalResults.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal("StaggeredSpawnsOrder"):Connect(
        function() -- line: 277
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Scoreboard:Generate()
            arg11.UpNext:Update()
            arg11.Buttons:Update()
        end
    ))
    table.insert(arg11._connections, arg11.ClientDuel:GetDataChangedSignal(
        "HideMostDuelInterfaceElements"
    ):Connect(function() -- line: 283
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.Timer:Update()
        arg11.Scores:UpdateVisibility()
    end))
    table.insert(arg11._connections, GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(
        function() -- line: 288
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.Scoreboard:UpdatePreferredTransparency()
        end
    ))
    table.insert(arg11._connections, EliminatedEffect_m.VisibilityChanged:Connect(function() -- line: 292
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.UpNext:Update()
    end))
    table.insert(arg11._connections, Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 296
        -- upvalues:
        --  [1] arg11 (copy)

        arg11.Buttons:Update()
        arg11.Scores:UpdateVisibility()
        arg11.EliminationFeed:Update()
        arg11.Timer:Update()
        arg11.Scoreboard:Open()
        arg11.Voting:Generate()
        arg11.RoundResult:UpdateVisibility()
        arg11.FinalResults:UpdateVisibility()
        arg11.HeadHoncho:Update()
        arg11.HardcoreParkour:Update()
        arg11.StoryDialog:Update()
    end))
    table.insert(arg11._connections, Inset_m.MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(
        function() -- line: 310
            -- upvalues:
            --  [1] arg11 (copy)

            arg11.EliminationFeed:UpdatePosition()
        end
    ))

    local function map_added(arg13, _) -- line: 314
        -- upvalues:
        --  [1] arg11 (copy)

        local Connections_20 = arg11._connections
        local ObbyStartPosition = arg13:GetDataChangedSignal("ObbyStartPosition")
        table.insert(Connections_20, ObbyStartPosition:Connect(function() -- line: 315
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.HardcoreParkour:Update()
        end))
        local Connections_21 = arg11._connections
        local ObbyFinishPosition = arg13:GetDataChangedSignal("ObbyFinishPosition")
        table.insert(Connections_21, ObbyFinishPosition:Connect(function() -- line: 319
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.HardcoreParkour:Update()
        end))
        arg11.HardcoreParkour:Update()
    end

    table.insert(arg11._connections, arg11.ClientDuel.MapAdded:Connect(map_added))

    if arg11.ClientDuel.Map then
        task.spawn(map_added, arg11.ClientDuel.Map, true)
    end

    local function dueler_added(arg15, arg16) -- line: 332
        -- upvalues:
        --  [1] arg11 (copy)

        local Connections_23 = arg11._connections
        local LastVote = arg15:GetDataChangedSignal("LastVote")
        table.insert(Connections_23, LastVote:Connect(function() -- line: 333
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Voting:Generate()
        end))
        local Connections_24 = arg11._connections
        local IsHeadHoncho = arg15:GetDataChangedSignal("IsHeadHoncho")
        table.insert(Connections_24, IsHeadHoncho:Connect(function() -- line: 337
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.HeadHoncho:Update()
        end))
        local Connections_25 = arg11._connections
        local Eliminations = arg15:GetDataChangedSignal("Eliminations")
        table.insert(Connections_25, Eliminations:Connect(function() -- line: 341
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))
        local Connections_26 = arg11._connections
        local Deaths = arg15:GetDataChangedSignal("Deaths")
        table.insert(Connections_26, Deaths:Connect(function() -- line: 345
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))
        local Connections_27 = arg11._connections
        local Assists = arg15:GetDataChangedSignal("Assists")
        table.insert(Connections_27, Assists:Connect(function() -- line: 349
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))
        local Connections_28 = arg11._connections
        local Damage = arg15:GetDataChangedSignal("Damage")
        table.insert(Connections_28, Damage:Connect(function() -- line: 353
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))
        table.insert(arg11._connections, arg15.ItemAdded:Connect(function() -- line: 357
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))
        table.insert(arg11._connections, arg15.ItemRemoved:Connect(function() -- line: 361
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))
        table.insert(arg11._connections, arg15.Died:Connect(function() -- line: 365
            -- upvalues:
            --  [1] arg11 (ref)
            --  [2] arg15 (copy)

            arg11.UpNext:Update()

            if arg15.IsLocalPlayer then
                arg11.Buttons:Update()
            end
        end))
        table.insert(arg11._connections, arg15.EntityAdded:Connect(function() -- line: 373
            -- upvalues:
            --  [1] arg11 (ref)
            --  [2] arg15 (copy)

            arg11.UpNext:Update()

            if arg15.IsLocalPlayer then
                arg11.Buttons:Update()
            end
        end))
        table.insert(arg11._connections, arg15.HealthChanged:Connect(function() -- line: 381
            -- upvalues:
            --  [1] arg11 (ref)
            --  [2] arg15 (copy)

            arg11.Scoreboard:Generate()
            arg11.UpNext:Update()

            if arg15.IsLocalPlayer then
                arg11.Buttons:Update()
            end
        end))
        local Connections_34 = arg11._connections
        local ConnectionLevel = arg15.ClientFighter:GetDataChangedSignal("ConnectionLevel")
        table.insert(Connections_34, ConnectionLevel:Connect(function() -- line: 390
            -- upvalues:
            --  [1] arg11 (ref)

            arg11.Scoreboard:Generate()
        end))

        if arg15.IsLocalPlayer then
            table.insert(arg11._connections, arg15:GetDataChangedSignal("SwitchItemsCount"):Connect(
                function() -- line: 395
                    -- upvalues:
                    --  [1] arg11 (ref)

                    arg11.Buttons:Update()
                end
            ))
            table.insert(arg11._connections, arg15:GetDataChangedSignal("SwitchItemsMax"):Connect(
                function() -- line: 399
                    -- upvalues:
                    --  [1] arg11 (ref)

                    arg11.Buttons:Update()
                end
            ))
            table.insert(arg11._connections, arg15:GetDataChangedSignal("TeamID"):Connect(function() -- line: 403
                -- upvalues:
                --  [1] arg11 (ref)

                arg11.Scores:Generate()
            end))
            table.insert(arg11._connections, arg15.ClientFighter:GetDataChangedSignal(
                "CanPickWeapons"
            ):Connect(function() -- line: 407
                -- upvalues:
                --  [1] arg11 (ref)

                arg11.Buttons:Update()
            end))
            table.insert(arg11._connections, arg15.ClientFighter:GetDataChangedSignal(
                "LastPickedWeapons"
            ):Connect(function() -- line: 411
                -- upvalues:
                --  [1] arg11 (ref)

                arg11.Buttons:Update()
            end))
            table.insert(arg11._connections, arg15.ClientFighter.InvincibilityChanged:Connect(function() -- line: 415
                -- upvalues:
                --  [1] arg11 (ref)

                arg11.Buttons:Update()
            end))
        end

        arg11._client_duelers[arg15] = true

        if not arg16 then
            arg11.Buttons:Update()
            arg11.Scoreboard:Generate()
            arg11.StoryDialog:Update()

            if arg15.IsLocalPlayer then
                arg11.Scores:Generate()
            end
        end
    end

    table.insert(arg11._connections, arg11.ClientDuel.DuelerAdded:Connect(dueler_added))
    local _ = arg11.ClientDuel.DuelerAdded:Connect(dueler_added)

    for _, val_7 in pairs(arg11.ClientDuel.Duelers) do
        task.spawn(dueler_added, val_7, true)
    end

    arg11.Buttons:Update()
    arg11.Scores:UpdateVisibility()
    arg11.Scores:Generate()
    arg11.Voting:Generate()
    arg11.Timer:UpdateSizeAndPosition()
    arg11.Timer:Update()
    arg11.Scoreboard:Generate()
    arg11.Scoreboard:UpdatePreferredTransparency()
    arg11.Scoreboard:Open(false)
    arg11.EliminationFeed:Update()
    arg11.RoundResult:UpdateVisibility()
    arg11.FinalResults:UpdateVisibility()
    arg11.UpNext:Update()
    arg11.HeadHoncho:Update()
    arg11.HardcoreParkour:Update()
    arg11.StoryDialog:Update()
end

function t._Setup(arg17) -- line: 464
    -- upvalues:
    --  [1] UILibrary_m (copy)

    arg17.Frame.Visible = false
    arg17.Frame.Parent = UILibrary_m:GetTo("MainFrame", "DuelInterfaces")
end

function t._Init(arg18) -- line: 469
    arg18.ClientDuel:GetDataChangedSignal("IsSpectating"):Connect(function() -- line: 470
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateSpectating()
    end)
    arg18:_Setup()
    task.spawn(arg18._UpdateSpectating, arg18)
end

return t
