local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local SocialService = game:GetService("SocialService")
local Players = game:GetService("Players")
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 14
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._models = {}
    t_1._countdown_hash = 0
    t_1._next_event_details = nil
    t_1:_Init()

    return t_1
end

function t.Update(arg1, _) -- line: 30
    if not arg1._next_event_details then
        return
    end

    for _, val in pairs(arg1._models) do
        local vec3_1 = Vector3.new(
            workspace.CurrentCamera.CFrame.X,
            val.CountdownCFrame.Y + (workspace.CurrentCamera.CFrame.Y - val.CountdownCFrame.Y) / 2,
            workspace.CurrentCamera.CFrame.Z
        )
        val.CountdownPart.CFrame = CFrame.new(val.CountdownCFrame.Position, vec3_1) * CFrame.Angles(
            0.2617993877991494,
            0,
            0
        )
    end
end

function t._GetDateTime(_, arg4) -- line: 50
    return DateTime.fromUniversalTime(
        arg4.Year,
        arg4.Month,
        arg4.Day,
        arg4.Hour,
        arg4.Minute,
        arg4.Second,
        arg4.Millisecond
    )
end

function t._UpdateCountdown(arg5) -- line: 62
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SocialService (copy)
    --  [3] ServerOsTime_m (copy)
    --  [4] Utility_m (copy)

    for key_1, val_1 in pairs(arg5._models) do
        val_1.CountdownModel.Parent = nil
        val_1.LogoModel.Parent = key_1
    end

    arg5._next_event = nil
    arg5._countdown_hash += 1
    local CountdownHash = arg5._countdown_hash

    if PlayerDataController_m:GetStatistic("StatisticDuelsPlayed") < 10 then
        return
    end

    local v3, Result = pcall(SocialService.GetUpcomingExperienceEventsAsync, SocialService)

    if not v3 then
        warn("Failed to fetch upcoming events, error:", Result)

        return
    end

    if arg5._countdown_hash ~= CountdownHash then
        return
    end

    table.sort(Result, function(arg6, arg7) -- line: 88
        -- upvalues:
        --  [1] arg5 (copy)

        local v4 = arg5:_GetDateTime(arg6.StartTime)
        local v5 = arg5:_GetDateTime(arg7.StartTime)

        return v4.UnixTimestamp < v5.UnixTimestamp and true
    end)
    v3 = nil

    for _, val_2 in pairs(Result) do
        if
            not val_2.HasStarted
            and not val_2.HasEnded
            and val_2.Status == Enum.ExperienceEventStatus.Active
        then
            v3 = val_2
            break
        end
    end

    if not v3 then
        return
    end

    local Success, Result_1 = pcall(SocialService.GetExperienceEventAsync, SocialService, v3.Id)

    if not Success then
        warn("Failed to fetch event details, error:", Result)

        return
    end

    if arg5._countdown_hash ~= CountdownHash then
        return
    end

    arg5._next_event_details = Result_1

    for key_3, val_3 in pairs(arg5._models) do
        val_3.CountdownModel.Parent = key_3
        val_3.LogoModel.Parent = nil
        val_3.CountdownTitle.Text = string.upper(arg5._next_event_details.Title)
    end

    local ceiling = math.ceil(
        arg5:_GetDateTime(arg5._next_event_details.StartTime).UnixTimestamp - ServerOsTime_m:Get()
    )

    for _, val_4 in pairs(arg5._models) do
        val_4.CountdownText.Text = if ceiling <= 0 then "ANY SECOND NOW" else Utility_m:TimeFormat2(
            ceiling
        )
    end

    wait(1)

    if arg5._countdown_hash ~= CountdownHash then
        return
    end
end

function t._ModelAdded(arg8, arg9) -- line: 147
    -- upvalues:
    --  [1] SocialService (copy)

    arg9:WaitForChild("Countdown"):PivotTo(
        arg9:WaitForChild("Countdown"):GetPivot() + Vector3.new(0, 100, 0)
    )
    arg8._models[arg9] = {
        CountdownModel = arg9:WaitForChild("Countdown"),
        CountdownPart = arg9:WaitForChild("Countdown"):WaitForChild("Part"),
        CountdownCFrame = arg9:WaitForChild("Countdown"):WaitForChild("Part").CFrame,
        CountdownTitle = arg9:WaitForChild("Countdown"):WaitForChild("Part"):WaitForChild(
            "SurfaceGui"
        ):WaitForChild("Title"),
        CountdownText = arg9:WaitForChild("Countdown"):WaitForChild("Part"):WaitForChild(
            "SurfaceGui"
        ):WaitForChild("Countdown"),
        LogoModel = arg9:WaitForChild("Logo")
    }
    arg9:WaitForChild("Countdown"):WaitForChild("Prompt"):WaitForChild("ProximityPrompt").Triggered:Connect(
        function() -- line: 161
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] SocialService (ref)

            if arg8._next_event_details then
                local Success_1, Result_2 = pcall(
                    SocialService.PromptRsvpToEventAsync,
                    SocialService,
                    arg8._next_event_details.Id
                )

                if not Success_1 then
                    warn("Failed to prompt event RSVP, error:", Result_2)
                end
            end
        end
    )
    arg8:_UpdateCountdown()
end

function t._Init(arg10) -- line: 174
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)

    PlayerDataController_m:GetDataChangedSignal("StatisticDuelsPlayed"):Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateCountdown()
    end)
    CollectionService:GetInstanceAddedSignal("LobbyUpdateCountdown"):Connect(function(arg11) -- line: 179
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_ModelAdded(arg11)
    end)

    for _, val_5 in pairs(CollectionService:GetTagged("LobbyUpdateCountdown")) do
        task.defer(arg10._ModelAdded, arg10, val_5)
    end
end

return t._new()
