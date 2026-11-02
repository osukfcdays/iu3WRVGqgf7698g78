local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local SeasonLibrary_m = require(ReplicatedStorage.Modules.SeasonLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MatchmakingQueueSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.BaseMatchmakingQueueSlot.MatchmakingQueueSlot
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Page = arg1
    t_1.Frame = t_1.Page.Container:WaitForChild("Queues")
    t_1:_Init()

    return t_1
end

function t.Open(_) -- line: 26
end

function t.Close(_) -- line: 30
end

function t._Generate(arg4, arg5) -- line: 38
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] MatchmakingQueueSlot_m (copy)

    local v1 = Utility_m:WaitForChildRecursive(arg4.Frame, arg5, 3)

    if not v1 then
        return
    end

    MatchmakingQueueSlot_m.new(arg5, v1).QueueStatus:Connect(function(arg6) -- line: 47
        -- upvalues:
        --  [1] arg4 (copy)

        if arg6 == "Success" then
            arg4.Page.Closed:Fire()

            return
        end

        arg4.Page.PromptSystem:Open(
            "ErrorMessage",
            "Whoops!",
            arg6 or "Server failed to respond, please try again"
        )
    end)
end

function t._Setup(arg7) -- line: 56
    -- upvalues:
    --  [1] SeasonLibrary_m (copy)

    for _, val in pairs(SeasonLibrary_m.CurrentSeason.RankedQueues) do
        task.defer(arg7._Generate, arg7, val[1])
    end
end

function t._Init(arg8) -- line: 62
    arg8:_Setup()
end

return t
