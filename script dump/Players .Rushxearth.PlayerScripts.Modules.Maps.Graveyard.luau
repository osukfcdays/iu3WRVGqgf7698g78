local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local ClientMap_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDuel.ClientMap
)
local FilmGrain = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FilmGrain")
local t = setmetatable({}, ClientMap_m)
t.__index = t

function t.new(...) -- line: 14
    -- upvalues:
    --  [1] ClientMap_m (copy)
    --  [2] t (copy)
    --  [3] FilmGrain (copy)

    local t_1 = setmetatable(ClientMap_m.new(...), t)
    t_1._film_grain = FilmGrain:Clone()
    t_1._film_grain_loop_active = false
    t_1._last_hour = t_1:_GetBellRingHour()
    t_1._arcade_status = nil
    t_1:_Init()

    return t_1
end

function t.Destroy(arg1) -- line: 31
    -- upvalues:
    --  [1] ClientMap_m (copy)

    arg1._film_grain:Destroy()
    ClientMap_m.Destroy(arg1)
end

function t._GetBellRingHour(_) -- line: 40
    -- upvalues:
    --  [1] ServerOsTime_m (copy)

    return (math.floor(ServerOsTime_m:Get() / 60 / 60))
end

function t._UpdateFilmGrainLoop(arg3) -- line: 44
    if arg3._film_grain_loop_active or arg3:Get("IsHidden") then
        return
    end

    arg3._film_grain_loop_active = true

    while true do
        if arg3._destroyed or arg3:Get("IsHidden") then
            break
        end

        arg3._film_grain.Position = UDim2.new(math.random(), 0, math.random(), 0)
        local v2 = arg3:_GetBellRingHour()

        if arg3._last_hour ~= v2 then
            arg3._last_hour = v2
            arg3:CreateSound(
                "rbxassetid://125988297033633",
                1,
                1,
                script,
                true,
                15
            )
        end

        wait(0.06666666666666667)
    end

    arg3._film_grain_loop_active = false
end

function t._UpdateLightingProfile(arg4) -- line: 67
    local v3 = if arg4.ClientDuel:Get("ArcadeMode") then arg4._arcade_status else arg4.ClientDuel:Get(
        "LastRoundStartingStatus"
    )
    arg4:SetReplicate(
        "LightingProfileOverride",
        if v3 ~= "SuddenDeath" then if v3 ~= "MatchPoint" then "Graveyard" else "Graveyard - MatchPoint" else "Graveyard - SuddenDeath"
    )

    if v3 == "SuddenDeath" and arg4.ClientDuel:Get("IsSpectating") then
        arg4:CreateSound(
            "rbxassetid://115990126225378",
            1,
            1,
            script,
            true,
            15
        )
    end

    if v3 == "MatchPoint" then
        local FilmGrain_2 = arg4._film_grain
        FilmGrain_2.Parent = if v3 ~= "MatchPoint" then nil else arg4.ClientDuel.DuelInterface.Frame or nil
    end
end

function t._UpdateLightingProfileFromTimer(arg5) -- line: 81
    local v6 = arg5.ClientDuel.DuelInterface.Timer:GetTimeRemaining()
    local v7 = v6

    if v7 then
        v7 = if arg5.ClientDuel:Get("Status") ~= "RoundStarted" then if arg5.ClientDuel:Get(
            "Status"
        ) ~= "RoundFinished" then false else true else true
    end

    local v8 = if not v7 then nil else if not (v6 < 10) then if not (v6 < 30) then nil else "MatchPoint" else "SuddenDeath"

    if v8 == arg5._arcade_status then
        return
    end

    arg5._arcade_status = v8
    arg5:_UpdateLightingProfile()
end

function t._Setup(arg6) -- line: 94
    if not arg6.ClientDuel:Get("ArcadeMode") then
        arg6.ClientDuel:GetDataChangedSignal("LastRoundStartingStatus"):Connect(function() -- line: 96
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateLightingProfile()
        end)
        arg6:_UpdateLightingProfile()

        return
    end

    arg6.ClientDuel.DuelInterface.Timer.TimerChanged:Connect(function() -- line: 102
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateLightingProfileFromTimer()
    end)
    arg6:_UpdateLightingProfileFromTimer()
end

function t._Init(arg7) -- line: 110
    arg7.ClientDuel:GetDataChangedSignal("IsHidden"):Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateFilmGrainLoop()
    end)
    arg7:_Setup()
    task.defer(arg7._UpdateFilmGrainLoop, arg7)
end

return t
