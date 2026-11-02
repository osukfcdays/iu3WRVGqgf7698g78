local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ReplicatedController_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ReplicatedController
)
local t = setmetatable({}, ReplicatedController_m)
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] ReplicatedController_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)

    local t_1 = setmetatable(ReplicatedController_m.new("Duel"), t)
    t_1.LocalPlayerJoinedOrLeftDuel = Signal_m.new()
    t_1.LocalPlayerJoinedDuel = Signal_m.new()
    t_1.LocalPlayerLeftDuel = Signal_m.new()
    t_1:_Init()

    return t_1
end

function t.GetDuelByID(arg1, arg2) -- line: 29
    for key, val in pairs(arg1.Objects) do
        if val:Get("ObjectID") == arg2 then
            return val, key
        end
    end
end

function t.GetDuel(arg3, arg4) -- line: 37
    for key_1, val_1 in pairs(arg3.Objects) do
        if val_1:GetDueler(arg4) then
            return val_1, key_1
        end
    end
end

function t._SetupInputs(arg5) -- line: 49
    -- upvalues:
    --  [1] Players (copy)
    --  [2] UserInputService (copy)
    --  [3] InputLibrary_m (copy)

    local ShootingRangeController_m = require(
        Players.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController
    )
    local FighterController_m = require(
        Players.LocalPlayer.PlayerScripts.Controllers.FighterController
    )
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessedEvent: boolean) -- line: 53
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] Players (ref)
        --  [3] InputLibrary_m (ref)
        --  [4] FighterController_m (copy)
        --  [5] ShootingRangeController_m (copy)

        if gameProcessedEvent then
            return
        end

        local v2 = arg5:GetDuel(Players.LocalPlayer)

        if
            v2
            and v2.DuelInterface.Buttons:IsSwitchItemsVisible()
            and InputLibrary_m:InputIs(input, "SwitchItems")
        then
            v2.DuelInterface.Buttons:SwitchItemsRequest()

            return
        end

        if
            v2
            and v2.DuelInterface.Buttons:IsRespawnNowVisible()
            and InputLibrary_m:InputIs(input, "Jump")
        then
            v2.DuelInterface.Buttons:RespawnNowRequest()

            return
        end

        if InputLibrary_m:InputIs(input, "LeaveDuel") then
            if v2 then
                v2:LeaveDuelRequest()

                return
            end

            if
                FighterController_m.LocalFighter
                and FighterController_m.LocalFighter:Get("IsInShootingRange")
            then
                ShootingRangeController_m:Leave()
            end
        end
    end)
end

function t._Init(arg8) -- line: 74
    -- upvalues:
    --  [1] Players (copy)

    arg8.ObjectAdded:Connect(function(arg9) -- line: 75
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] Players (ref)

        local function check_local_dueler(arg10) -- line: 76
            -- upvalues:
            --  [1] arg9 (copy)
            --  [2] arg8 (ref)

            if not arg10 or not arg10.IsLocalPlayer then
                return
            end

            arg9.DuelerRemoved:Connect(function(arg11) -- line: 81
                -- upvalues:
                --  [1] arg10 (copy)
                --  [2] arg8 (ref)
                --  [3] arg9 (ref)

                if arg11 == arg10 then
                    arg8.LocalPlayerLeftDuel:Fire(arg9, arg11)
                    arg8.LocalPlayerJoinedOrLeftDuel:Fire(arg9, arg11)
                end
            end)
            arg8.LocalPlayerJoinedDuel:Fire(arg9, arg10)
            arg8.LocalPlayerJoinedOrLeftDuel:Fire(arg9, arg10)
        end

        arg9.DuelerAdded:Connect(check_local_dueler)
        check_local_dueler(arg9:GetDueler(Players.LocalPlayer))
    end)
    arg8.ObjectRemoved:Connect(function(arg12) -- line: 96
        -- upvalues:
        --  [1] Players (ref)
        --  [2] arg8 (copy)

        local v3 = arg12:GetDueler(Players.LocalPlayer)

        if not v3 then
            return
        end

        arg8.LocalPlayerLeftDuel:Fire(arg12, v3)
        arg8.LocalPlayerJoinedOrLeftDuel:Fire(arg12, v3)
    end)
    task.defer(arg8._SetupInputs, arg8)
end

return t._new()
