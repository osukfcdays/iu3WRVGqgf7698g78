local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local RotatingQueueLibrary_m = require(ReplicatedStorage.Modules.RotatingQueueLibrary)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local SendChat_m = require(Players.LocalPlayer.PlayerScripts.Modules.Functions.SendChat)
local t = {}
local RotatingQueueHolograms = Players.LocalPlayer.PlayerScripts.Assets.RotatingQueueHolograms
t.__index = t

function t._new() -- line: 20
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelSet = Signal_m.new()
    t_1.UpdateJoinCooldown = Signal_m.new()
    t_1.CurrentDuel = nil
    t_1._local_fighter = nil
    t_1._has_joined_arcade_duel = false
    t_1._hologram_loop_thread = nil
    t_1._rotating_queue_hologram = nil
    t_1._join_cooldown_hash = 0
    t_1:_Init()

    return t_1
end

function t.GetJoinCooldown(arg1) -- line: 43
    local v1 = arg1._local_fighter and arg1._local_fighter:GetJoinCooldown() or 0

    return (math.ceil(v1))
end

function t.CanJoin(arg2) -- line: 47
    local v2 = arg2.CurrentDuel

    if v2 then
        v2 = if arg2.CurrentDuel:Get("Status") ~= "GameOver" then arg2:GetJoinCooldown() <= 0 and true else false
    end

    return v2
end

function t.ToArcadeServer(_, arg4) -- line: 51
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    return ReplicatedStorage.Remotes.Arcade.TeleportToArcadeServer:InvokeServer(arg4)
end

function t.Join(arg5) -- line: 55
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg5._has_joined_arcade_duel = true
    ReplicatedStorage.Remotes.Arcade.Join:FireServer()
end

function t._UpdateHologram(arg6, arg7) -- line: 64
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] RotatingQueueHolograms (copy)
    --  [3] RotatingQueueLibrary_m (copy)
    --  [4] SendChat_m (copy)
    --  [5] Utility_m (copy)

    if arg6._rotating_queue_hologram then
        arg6._rotating_queue_hologram:Destroy()
        arg6._rotating_queue_hologram = nil
    end

    local v3 = CollectionService:GetTagged("LobbyRotatingQueueHologram")[1]

    if not v3 then
        return
    end

    task.defer(function() -- line: 76
        -- upvalues:
        --  [1] v3 (copy)

        local DELETEATRUNTIME = v3:WaitForChild("DELETE_AT_RUNTIME", 2)

        if DELETEATRUNTIME then
            task.defer(DELETEATRUNTIME.Destroy, DELETEATRUNTIME)
        end
    end)
    local Primary = v3:WaitForChild("Primary")
    local Particles = v3:WaitForChild("Particles")
    local Emit = Particles:WaitForChild("Emit")
    local Attachment = Particles:WaitForChild("Attachment")
    v3:WaitForChild("Prompt"):WaitForChild("ProximityPrompt").ObjectText = "Limited Time"
    local v5 = RotatingQueueHolograms:FindFirstChild(RotatingQueueLibrary_m:GetCurrent().Name) or RotatingQueueHolograms.Default
    arg6._rotating_queue_hologram = v5:Clone()
    arg6._rotating_queue_hologram:PivotTo(Primary.CFrame)
    arg6._rotating_queue_hologram.Name = "_hologram"
    arg6._rotating_queue_hologram.Parent = v3

    if arg7 then
        SendChat_m(
            {
                Text = "[SERVER] New gamemodes are here! Open the PLAY page now! \240\159\142\137",
                Color = Color3.fromRGB(100, 255, 50)
            }
        )
        Utility_m:PlayParticles(Emit)
        Utility_m:CreateSound(
            "rbxassetid://120776960987657",
            0.75,
            1,
            Particles,
            true,
            15
        )
        Utility_m:CreateSound(
            "rbxassetid://75616400922980",
            1,
            1,
            Particles,
            true,
            15
        )

        for _, val in pairs(Attachment:GetChildren()) do
            val.Enabled = true
        end

        task.delay(10, function() -- line: 110
            -- upvalues:
            --  [1] Attachment (copy)

            for _, child in pairs(Attachment:GetChildren()) do
                child.Enabled = false
            end
        end)
    end
end

function t._UpdateHologramLoop(arg8) -- line: 118
    -- upvalues:
    --  [1] RotatingQueueLibrary_m (copy)

    local v10 = arg8._local_fighter

    if v10 then
        v10 = not arg8._local_fighter:Get("IsInDuel")

        if v10 then
            v10 = not arg8._local_fighter:Get("IsInShootingRange")
        end
    end

    if not v10 then
        if arg8._hologram_loop_thread then
            task.cancel(arg8._hologram_loop_thread)
            arg8._hologram_loop_thread = nil

            return
        end
    elseif not arg8._hologram_loop_thread then
        arg8._hologram_loop_thread = task.spawn(function() -- line: 128
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] RotatingQueueLibrary_m (ref)

            arg8:_UpdateHologram()

            while true do
                wait(RotatingQueueLibrary_m:GetTimeUntilNext() + 1)
                arg8:_UpdateHologram(true)
            end
        end)
    end
end

function t._UpdateJoinCooldown(arg9) -- line: 140
    arg9._join_cooldown_hash += 1
    local JoinCooldownHash = arg9._join_cooldown_hash
    local v11 = arg9._local_fighter:GetJoinCooldown()
    local v12 = tick() + v11
    arg9.UpdateJoinCooldown:Fire()

    for _ = 1, v11 do
        wait(1)
        arg9.UpdateJoinCooldown:Fire()

        if arg9._join_cooldown_hash ~= JoinCooldownHash then
            return
        end
    end

    wait(v12 - tick())

    if arg9._join_cooldown_hash ~= JoinCooldownHash then
        return
    end

    arg9.UpdateJoinCooldown:Fire()
end

function t._HookLocalFighter(arg10) -- line: 167
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg10._local_fighter = FighterController_m:WaitForLocalFighter()
    arg10._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 170
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateHologramLoop()
    end)
    arg10._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 174
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateHologramLoop()
    end)
    arg10._local_fighter:GetDataChangedSignal("JoinCooldown"):Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateJoinCooldown()
    end)
    task.defer(arg10._UpdateHologramLoop, arg10)
    task.defer(arg10._UpdateJoinCooldown, arg10)
end

function t._DuelRemoved(arg11, arg12) -- line: 186
    if arg11.CurrentDuel == arg12 then
        arg11.CurrentDuel = nil
        arg11.DuelSet:Fire(arg12)
    end
end

function t._DuelAdded(arg13, arg14) -- line: 193
    local function check_is_arcade_duel() -- line: 194
        -- upvalues:
        --  [1] arg14 (copy)
        --  [2] arg13 (copy)

        if arg14:Get("IsCurrentArcadeDuel") then
            arg13.CurrentDuel = arg14
            arg13.DuelSet:Fire(arg14)
        end
    end

    arg14:GetDataChangedSignal("IsCurrentArcadeDuel"):Connect(check_is_arcade_duel)

    if arg14:Get("IsCurrentArcadeDuel") then
        arg13.CurrentDuel = arg14
        arg13.DuelSet:Fire(arg14)
    end
end

function t._PromptAdded(_, arg16) -- line: 205
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] DuelLibrary_m (copy)

    if not CONSTANTS_m.IS_ARCADE_SERVER then
        return
    end

    arg16:RemoveTag("LobbyOpenPagePrompt")
    arg16.Triggered:Connect(function() -- line: 212
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Matchmaking.BackToHub:FireServer()
    end)
    arg16.ObjectText = DuelLibrary_m.ArcadeModeByPlaceID[tostring(CONSTANTS_m.PLACE_ID)].DisplayName
    arg16.ActionText = "Leave"
end

function t._Init(arg17) -- line: 220
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] SpectateController_m (copy)
    --  [4] DuelController_m (copy)
    --  [5] CollectionService (copy)

    arg17.DuelSet:Connect(function(arg18) -- line: 221
        -- upvalues:
        --  [1] arg17 (copy)
        --  [2] FighterController_m (ref)
        --  [3] CONSTANTS_m (ref)
        --  [4] SpectateController_m (ref)

        arg18:GetDataChangedSignal("Status"):Connect(function() -- line: 222
            -- upvalues:
            --  [1] arg17 (ref)

            arg17.UpdateJoinCooldown:Fire()
        end)
        arg17.UpdateJoinCooldown:Fire()

        if
            not FighterController_m.LocalFighter
            or FighterController_m.LocalFighter:Get("IsInDuel")
            or FighterController_m.LocalFighter:Get("IsInShootingRange")
        then
            return
        end

        if
            CONSTANTS_m.IS_ARCADE_SERVER
            and not arg17._has_joined_arcade_duel
            and #arg18.Duelers >= 3
            and arg18:Get("Status") ~= "Voting"
        then
            SpectateController_m:SpectateDuelRequest(arg18)

            return
        end

        arg17:Join()
    end)
    DuelController_m.ObjectAdded:Connect(function(arg19) -- line: 239
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_DuelAdded(arg19)
    end)
    DuelController_m.ObjectRemoved:Connect(function(arg20) -- line: 243
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_DuelRemoved(arg20)
    end)
    CollectionService:GetInstanceAddedSignal("LobbyRotatingQueueHologram"):Connect(function(arg21) -- line: 247
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateHologram(arg21)
    end)
    CollectionService:GetInstanceAddedSignal("LobbyArcadePrompt"):Connect(function(arg22) -- line: 251
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_PromptAdded(arg22)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyArcadePrompt")) do
        task.defer(arg17._PromptAdded, arg17, val_1)
    end

    for _, val_2 in pairs(DuelController_m.Objects) do
        task.defer(arg17._DuelAdded, arg17, val_2)
    end

    task.defer(arg17._HookLocalFighter, arg17)
end

return t._new()
