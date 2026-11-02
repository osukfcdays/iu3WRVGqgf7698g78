local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local NotificationSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("NotificationSlot")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.NotificationSent = Signal_m.new()
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Notifications")
    t_1._queue = {}
    t_1._is_playing_queue = false
    t_1:_Init()

    return t_1
end

function t.Play(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 37
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] NotificationSlot_m (copy)
    --  [3] BetterDebris_m (copy)

    arg1.NotificationSent:Fire(arg2, arg3, arg4, arg5)

    if arg8 or PlayerDataController_m:GetSetting("Notifications Delivery") == "Muted" then
        return
    end

    local v5 = NotificationSlot_m.new(arg2, arg3, arg4, arg5)
    v5:SetParent(arg1.Frame.Container)
    v5:PlaySize(arg6, 5)
    v5:PlaySound(arg7)
    v5:PlayGlow()
    BetterDebris_m:AddItem(v5, 10)
end

function t.Queue(arg9, ...) -- line: 52
    table.insert(arg9._queue, { ... })
    arg9:_PlayQueue()
end

function t._PlayQueue(arg10) -- line: 61
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if
        arg10._is_playing_queue
        or PlayerDataController_m:GetSetting("Notifications Delivery") == "Lobby" and arg10._local_fighter and arg10._local_fighter:Get(
            "IsInDuel"
        )
    then
        return
    end

    arg10._is_playing_queue = true
    local v6 = true

    while true do
        if not (#arg10._queue > 0) then
            break
        end

        if v6 then
            v6 = false
            wait(0.25)
        end

        local v7 = 1 - (math.min(5, #arg10._queue) - 1) * 0.1
        local v8 = 1

        while true do
            if not (v8 <= 5) then
                break
            end

            local removedValue = table.remove(arg10._queue, 1)

            if not removedValue then
                break
            end

            local v9, v10, v11, v12, v13, v14 = table.unpack(removedValue)
            task.spawn(
                arg10.Play,
                arg10,
                v9,
                v10,
                v11,
                v12,
                (v13 or 1) * v7,
                nil,
                v14
            )

            if v14 then
                continue
            end

            wait(0.1)
            v8 += 1
        end

        wait(5)
    end

    arg10._is_playing_queue = false
end

function t._HookFighter(arg11) -- line: 106
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg11._local_fighter = FighterController_m:WaitForLocalFighter()
    arg11._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 109
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_PlayQueue()
    end)
    arg11:_PlayQueue()
end

function t._Init(arg12) -- line: 116
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    ReplicatedStorage.Remotes.Data.PlayNotification.OnClientEvent:Connect(function(...) -- line: 117
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:Queue(...)
    end)
    task.defer(arg12._HookFighter, arg12)
end

return t._new()
