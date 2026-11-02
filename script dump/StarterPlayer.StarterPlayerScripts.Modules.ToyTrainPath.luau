local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
local ToyTrain = Players.LocalPlayer.PlayerScripts.Assets.Misc.ToyTrain
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] ServerOsTime_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Model = arg1
    t_1._connections = {}
    t_1._num_paths = t_1.Model:GetAttribute("NumPaths")
    t_1._paths = {}
    t_1._path_to_running_total_length = {}
    t_1._length = 0
    t_1._padding = 0
    t_1._speed = 0
    t_1._progress = ServerOsTime_m:Get()
    t_1._tick = t_1._progress
    t_1._num_trains = 0
    t_1._trains = {}
    t_1._train_sizes = {}
    t_1._train_attachments = {}
    t_1._train_attachment_positions = {}
    t_1._train_attacheds = {}
    t_1._event_gifts = {}
    t_1._claim_event_gift_cooldown = 0
    t_1._sound_cooldown = tick() + 15
    t_1:_Init()

    return t_1
end

function t.GetCFrame(arg2, arg3) -- line: 49
    local v1 = arg3 % 1

    for index = 1, arg2._num_paths do
        local v2 = if index == 1 then 0 else arg2._path_to_running_total_length[index - 1]
        local v3 = arg2._path_to_running_total_length[index]

        if not (v1 < v2) and not (v1 > v3) then
            local v4 = arg2._paths[index]

            return v4.Start.WorldPosition:Lerp(v4.Finish.WorldPosition, (v1 - v2) / (v3 - v2)), CFrame.new(
                v4.Start.WorldPosition,
                v4.Finish.WorldPosition
            ).Rotation
        end
    end

    return CFrame.identity
end

function t.Update(arg4, arg5) -- line: 70
    -- upvalues:
    --  [1] Utility_m (copy)

    arg4._tick += arg5
    arg4._progress += arg4._speed * arg5

    for key, val in pairs(arg4._trains) do
        local v8, v9 = arg4:GetCFrame(arg4._progress - arg4._padding * (key - 1))
        local v12 = CFrame.new(v8) * val:GetPivot().Rotation:Lerp(v9, 0.1)
        local v13 = arg4._tick % arg4._num_trains + 1
        v8 = if key <= v13 and v13 <= key + 1 then math.sin(6.283185307179586 * arg4._tick) else 0
        v8 *= if v8 < 0 then 0.25 else 1
        local v15 = v8 * 1
        val.Size = arg4._train_sizes[key] + Vector3.new(v8 * -0.5, v15, v8 * -0.5)
        val:PivotTo(v12 + Vector3.new(0, v15 / 2, 0))

        if arg4._train_attachments[key] then
            arg4._train_attachments[key].Position = arg4._train_attachment_positions[key] + Vector3.new(
                0,
                v15,
                0
            )
            arg4._train_attacheds[key]:PivotTo(arg4._train_attachments[key].WorldCFrame)
        end

        if key == 1 and tick() > arg4._sound_cooldown then
            arg4._sound_cooldown = tick() + 20 + 20 * math.random()
            Utility_m:CreateSound(
                "rbxassetid://106675250798882",
                0.25,
                1,
                val,
                true,
                5
            )
            task.delay(
                0.4,
                Utility_m.CreateSound,
                Utility_m,
                "rbxassetid://114399683675542",
                0.25,
                1,
                val,
                true,
                5
            )
        end
    end
end

function t.Destroy(arg6) -- line: 99
    for _, val_1 in pairs(arg6._connections) do
        val_1:Disconnect()
    end

    arg6._connections = {}
    arg6.Model:Destroy()
end

function t._UpdateEventGiftEnabled(arg7) -- line: 113
    -- upvalues:
    --  [1] ServerOsTime_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] EventLibrary_m (copy)

    for key_2, val_2 in pairs(arg7._event_gifts) do
        val_2.Parent = if ServerOsTime_m:Get() < PlayerDataController_m:Get("LastEventGiftClaimed") + EventLibrary_m.EVENT_GIFT_COOLDOWN then nil else arg7._trains[key_2]
    end
end

function t._Setup(arg8) -- line: 119
    -- upvalues:
    --  [1] ToyTrain (copy)
    --  [2] Players (copy)
    --  [3] ReplicatedStorage (copy)

    for index_1 = 1, arg8._num_paths do
        local v24 = arg8.Model:WaitForChild(index_1)
        v24.Start.Position = Vector3.new(v24.Size.X / 2, 0, 0)
        v24.Finish.Position = Vector3.new(-v24.Size.X / 2, 0, 0)
        arg8._paths[index_1] = v24
        arg8._length += (arg8._paths[index_1].Finish.Position - arg8._paths[index_1].Start.Position).Magnitude
        arg8._path_to_running_total_length[index_1] = arg8._length
        v24.Transparency = 1
    end

    for key_3, val_3 in pairs(arg8._path_to_running_total_length) do
        arg8._path_to_running_total_length[key_3] = val_3 / arg8._length
    end

    arg8._padding = 8 / arg8._length
    arg8._speed = 4 / arg8._length
    local v25 = ToyTrain:Clone()
    arg8._num_trains = v25:GetAttribute("NumTrains")

    for index_2 = 1, arg8._num_trains do
        local v26 = v25:WaitForChild(index_2)
        arg8._trains[index_2] = v26
        arg8._train_sizes[index_2] = v26.Size
        local Attachment = v26:FindFirstChild("Attachment")
        local Attached = v26:FindFirstChild("Attached")

        if Attachment and Attached then
            arg8._train_attachments[index_2] = Attachment
            arg8._train_attachment_positions[index_2] = Attachment.Position
            arg8._train_attacheds[index_2] = Attached

            if Attached:GetAttribute("IsEventGift") then
                arg8._event_gifts[index_2] = Attached
                Attached.Hitbox.Touched:Connect(function(otherPart: BasePart) -- line: 160
                    -- upvalues:
                    --  [1] Players (ref)
                    --  [2] arg8 (copy)
                    --  [3] ReplicatedStorage (ref)

                    if
                        Players:GetPlayerFromCharacter(otherPart.Parent) == Players.LocalPlayer
                        and tick() > arg8._claim_event_gift_cooldown
                    then
                        arg8._claim_event_gift_cooldown = tick() + 3
                        ReplicatedStorage.Remotes.Misc.ClaimEventGift:FireServer()
                    end
                end)
            end
        end
    end

    v25.Parent = arg8.Model
end

function t._Init(arg10) -- line: 173
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local Connections = arg10._connections
    local LastEventGiftClaimed = PlayerDataController_m:GetDataChangedSignal("LastEventGiftClaimed")
    table.insert(Connections, LastEventGiftClaimed:Connect(function() -- line: 174
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateEventGiftEnabled()
    end))
    arg10:_Setup()
    task.defer(arg10._UpdateEventGiftEnabled, arg10)
end

return t
