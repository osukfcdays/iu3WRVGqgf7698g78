local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local ClientViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild(
        "ClientFighter"
    ):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 17
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1.IsChargingMinigun = false
    t_1.IsWindingMinigun = false
    t_1._active_shooting_finish = 0
    t_1._last_winding_sounds = nil
    t_1._last_shooting_sounds = nil
    t_1._last_ammo_belt_count = 20
    t_1._ammo_belt_models = {}
    t_1:_Init()

    return t_1
end

function t.StartChargingMinigun(arg1) -- line: 38
    -- upvalues:
    --  [1] CameraController_m (copy)

    arg1._active_shooting_finish = tick() + math.max(
        0.1,
        CameraController_m:GetLastHeartbeatDeltaTime() * 3
    )
    arg1:_ChargeLoop(true)
end

function t.Unequip(arg2, ...) -- line: 43
    -- upvalues:
    --  [1] ClientViewModel_m (copy)

    arg2:StopAnimation("ChargeStart")
    arg2:StopAnimation("ChargeLoop")
    arg2:StopAnimation("ChargeFinish", nil, 0)
    ClientViewModel_m.Unequip(arg2, ...)
end

function t._CreateMinigunShootingSounds(arg3) -- line: 54
    local v4 = arg3:CreateSound("rbxassetid://17246880027", 8.75, 1, true)
    v4.TimePosition = 0.25 + 0.25 * math.random()
    v4.Looped = true

    return { v4 }
end

function t._CreateMinigunWindingSounds(arg4) -- line: 62
    local v5 = arg4:CreateSound("rbxassetid://17251084003", 0.5, 1, true)
    v5.TimePosition = 2
    v5.Looped = true

    return { v5 }
end

function t._UpdateAmmoBelt(arg5) -- line: 70
    local v6 = arg5.ClientItem:Get("Ammo")

    if arg5._last_ammo_belt_count == v6 then
        return
    end

    arg5._last_ammo_belt_count = v6

    for key, val in pairs(arg5._ammo_belt_models) do
        for _, val_1 in pairs(val) do
            arg5:_LocalTransparencyModifier(
                val_1,
                "AmmoVisual",
                if not (key > arg5._last_ammo_belt_count) then 0 else 1
            )
        end
    end
end

function t._ChargeLoop(arg6, arg7) -- line: 86
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] RunService (copy)
    --  [3] Utility_m (copy)

    if arg6.IsChargingMinigun then
        return
    end

    arg6.IsChargingMinigun = true
    arg6:StopAnimation("ChargeFinish")
    local v9 = arg6:_CreateMinigunWindingSounds()
    local t_4 = {}

    for _, val_2 in pairs(v9) do
        t_4[val_2] = { Volume = val_2.Volume, PlaybackSpeed = val_2.PlaybackSpeed }
        val_2.Volume = 0
    end

    if arg6._last_winding_sounds then
        for _, val_3 in pairs(arg6._last_winding_sounds) do
            val_3:Destroy()
        end
    end

    arg6._last_winding_sounds = v9

    if arg7 then
        local ChargingWindUpLength = arg6.ClientItem.Info.ChargingWindUpLength
        local v10 = tick() + ChargingWindUpLength
        arg6:PlayAnimation(
            "ChargeStart",
            AnimationLibrary_m.Info[arg6.Info.Animations.ChargeStart].Length
        )
        arg6.IsWindingMinigun = true

        while true do
            if arg6._destroyed or not arg6._is_equipped or not (v10 > tick()) then
                break
            end

            if not (tick() < arg6._active_shooting_finish) and not arg6.ClientItem:Get("IsAiming") then
                break
            end

            local clampedValue = math.clamp(
                (ChargingWindUpLength - (v10 - tick())) / ChargingWindUpLength,
                0,
                1
            )

            for _, val_4 in pairs(v9) do
                val_4.Volume = t_4[val_4].Volume * clampedValue
                val_4.PlaybackSpeed = t_4[val_4].PlaybackSpeed * (clampedValue * 1.5 + 1)
            end

            RunService.RenderStepped:Wait()
        end

        arg6.IsWindingMinigun = false
    end

    for index = 1, math.huge do
        if arg6._destroyed or not arg6._is_equipped then
            break
        end

        if tick() > arg6._active_shooting_finish and not arg6.ClientItem:Get("IsAiming") then
            break
        end

        if index == 1 then
            arg6:PlayAnimation("ChargeLoop", math.huge)

            for _, val_5 in pairs(v9) do
                val_5.Volume = t_4[val_5].Volume
                val_5.PlaybackSpeed = t_4[val_5].PlaybackSpeed * 2.5
            end
        end

        RunService.RenderStepped:Wait()
    end

    arg6.IsChargingMinigun = false
    arg6:StopAnimation("ChargeStart")
    arg6:StopAnimation("ChargeLoop")

    if arg6._is_equipped then
        arg6:PlayAnimation(
            "ChargeFinish",
            AnimationLibrary_m.Info[arg6.Info.Animations.ChargeFinish].Length
        )
    end

    local t_6 = {}

    for _, val_6 in pairs(v9) do
        t_6[val_6] = { Volume = val_6.Volume, PlaybackSpeed = val_6.PlaybackSpeed }
    end

    Utility_m:RenderstepForLoop(0, 100, 1.5, function(arg8) -- line: 170
        -- upvalues:
        --  [1] v9 (copy)
        --  [2] t_6 (copy)

        local v11 = arg8 / 100

        for _, val_7 in pairs(v9) do
            val_7.Volume = t_6[val_7].Volume + (0 - t_6[val_7].Volume) * (1 - (1 - v11) ^ 4)
            val_7.PlaybackSpeed = t_6[val_7].PlaybackSpeed + (1 - t_6[val_7].PlaybackSpeed) * v11
        end
    end)

    for _, val_8 in pairs(v9) do
        val_8:Destroy()
    end
end

function t._Setup(arg9) -- line: 184
    -- upvalues:
    --  [1] RunService (copy)

    local AmmoBelt = arg9.ItemModel:FindFirstChild("_ammo_belt", true)

    if AmmoBelt then
        for index_1 = 1, 20 do
            local v12 = AmmoBelt:WaitForChild(index_1)
            arg9._ammo_belt_models[index_1] = {
                v12:FindFirstChild("Shell"),
                v12:FindFirstChild("Strap")
            }
        end
    end

    task.defer(function() -- line: 196
        -- upvalues:
        --  [1] arg9 (copy)
        --  [2] RunService (ref)

        arg9.ClientItem.Shot:Connect(function() -- line: 197
            -- upvalues:
            --  [1] arg9 (ref)
            --  [2] RunService (ref)

            arg9._active_shooting_finish = tick() + 0.1

            if not arg9._last_shooting_sounds then
                arg9._last_shooting_sounds = arg9:_CreateMinigunShootingSounds()
                task.spawn(function() -- line: 203
                    -- upvalues:
                    --  [1] arg9 (ref)
                    --  [2] RunService (ref)

                    while true do
                        if arg9._destroyed then
                            break
                        end

                        if not (tick() < arg9._active_shooting_finish) then
                            break
                        end

                        RunService.RenderStepped:Wait()
                    end

                    for _, val_9 in pairs(arg9._last_shooting_sounds) do
                        val_9:Destroy()
                    end

                    arg9._last_shooting_sounds = nil
                end)
            end

            arg9:_ChargeLoop()
        end)
    end)
end

function t._Init(arg10) -- line: 221
    arg10.ClientItem:GetDataChangedSignal("IsAiming"):Connect(function(arg11) -- line: 222
        -- upvalues:
        --  [1] arg10 (copy)

        if arg11 then
            arg10:_ChargeLoop(true)
        end
    end)
    arg10.ClientItem:GetDataChangedSignal("Ammo"):Connect(function() -- line: 228
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateAmmoBelt()
    end)
    arg10:_Setup()
    arg10:_UpdateAmmoBelt()
end

return t
