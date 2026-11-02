local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local MatchmakingCountdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.MatchmakingCountdown
)
local Notifications_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Notifications
)
local LooseWeaponDisplay_m = require(Players.LocalPlayer.PlayerScripts.Modules.LooseWeaponDisplay)
local SendChat_m = require(Players.LocalPlayer.PlayerScripts.Modules.Functions.SendChat)
local LobbyElement_m = require(Players.LocalPlayer.PlayerScripts.Modules.LobbyElement)
local t = setmetatable({}, LobbyElement_m)
t.__index = t

function t._new(...) -- line: 21
    -- upvalues:
    --  [1] LobbyElement_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(LobbyElement_m.new(...), t)
    t_1._loose_weapon_displays = {}
    t_1._celebration_hash = 0
    t_1._celebration_queued = false
    t_1:_Init()

    return t_1
end

function t.GetLastReleasedWeapon(_) -- line: 37
    -- upvalues:
    --  [1] ShopLibrary_m (copy)

    local v2, v3 = ShopLibrary_m:GetUpcomingWeapon()
    v2 = v3 and v3 - 1 or #ShopLibrary_m.OwnableWeaponReleaseSchedule

    return ShopLibrary_m.OwnableWeaponReleaseSchedule[v2], v2
end

function t.Refresh(arg2, arg3) -- line: 44
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] Utility_m (copy)

    local v4 = ShopLibrary_m:GetUpcomingWeapon()
    local v5 = arg2:GetLastReleasedWeapon()
    local v6 = not v4 or ShopLibrary_m:GetTimeUntilWeaponRelease(v5) > -259200 and true
    local v7 = v6 and v5 or v4 or v5

    for _, val in pairs(arg2._loose_weapon_displays) do
        val:SetLocked(not v6)

        if val.CurrentWeapon ~= v7 then
            val:ChangeWeapon(v7)
        end

        if v6 then
            val:SetProximityPromptData("NEW WEAPON", "View")
        else
            val:SetProximityPromptData("COMING SOON", function() -- line: 60
                -- upvalues:
                --  [1] val (copy)
                --  [2] Utility_m (ref)
                --  [3] ShopLibrary_m (ref)

                if not val.CurrentWeapon then
                    return ""
                end

                return (Utility_m:TimeFormat2(
                    ShopLibrary_m:GetTimeUntilWeaponRelease(val.CurrentWeapon)
                ))
            end)
        end
    end

    if arg3 and v6 then
        task.delay(3, arg2._PlayCelebration, arg2)
    end
end

function t.Update(arg4, arg5) -- line: 71
    for _, val_1 in pairs(arg4._loose_weapon_displays) do
        val_1:Update(arg5)
    end
end

function t._EnableParticles(arg6, arg7) -- line: 81
    -- upvalues:
    --  [1] Utility_m (copy)

    for key_2, _ in pairs(arg6._loose_weapon_displays) do
        if arg7 then
            Utility_m:PlayParticles(key_2.Particles.Emit)
            Utility_m:CreateSound(
                "rbxassetid://120776960987657",
                0.75,
                1,
                key_2.Particles,
                true,
                15
            )
            Utility_m:CreateSound(
                "rbxassetid://75616400922980",
                1,
                1,
                key_2.Particles,
                true,
                15
            )
        end

        for _, val_3 in pairs(key_2.Particles.Attachment:GetChildren()) do
            val_3.Enabled = arg7
        end
    end
end

function t._PlayCelebration(arg8) -- line: 95
    -- upvalues:
    --  [1] TeleportService (copy)
    --  [2] FighterController_m (copy)
    --  [3] MatchmakingCountdown_m (copy)

    if TeleportService:GetTeleportSetting("PlayedWeaponReleaseCelebration") then
        return
    end

    local v10 = FighterController_m.LocalFighter

    if v10 then
        v10 = not FighterController_m.LocalFighter:Get("IsInDuel")

        if v10 then
            v10 = not FighterController_m.LocalFighter:Get("IsInShootingRange")
        end
    end

    if not v10 or MatchmakingCountdown_m:IsVisible() then
        arg8._celebration_queued = true

        return
    end

    TeleportService:SetTeleportSetting("PlayedWeaponReleaseCelebration", true)
    arg8._celebration_queued = false
    arg8._celebration_hash += 1
    local CelebrationHash = arg8._celebration_hash
    arg8:_EnableParticles(true)
    task.delay(10, function() -- line: 115
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] CelebrationHash (copy)

        if arg8._celebration_hash ~= CelebrationHash then
            return
        end

        arg8:_EnableParticles(false)
    end)

    return true
end

function t._RefreshLoop(arg9) -- line: 126
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] SendChat_m (copy)
    --  [3] Notifications_m (copy)

    while true do
        local v12 = ShopLibrary_m:GetUpcomingWeapon()

        if not v12 then
            return
        end

        wait(ShopLibrary_m:GetTimeUntilWeaponRelease(v12))
        arg9:Refresh()
        arg9:_PlayCelebration()
        local t_2 = {
            Text = "[SERVER] A new weapon has been officially released - The <font weight=\"900\">" .. v12 .. "</font>! Check out the Weapons page to learn more!",
            Color = Color3.fromRGB(100, 255, 50)
        }
        task.defer(SendChat_m, t_2)
        task.defer(
            Notifications_m.Play,
            Notifications_m,
            "New Weapon",
            "The " .. v12 .. " has released!",
            { Name = v12 },
            nil,
            nil,
            "rbxassetid://128960987577700"
        )
        wait(259200)
        arg9:Refresh()
    end
end

function t._ModelAdded(arg10, arg11) -- line: 147
    -- upvalues:
    --  [1] LooseWeaponDisplay_m (copy)

    arg10._loose_weapon_displays[arg11] = LooseWeaponDisplay_m.new(
        arg11:WaitForChild("LooseWeaponDisplay")
    )
    arg10:Refresh()
end

function t._HookLocalFighter(arg12) -- line: 152
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] MatchmakingCountdown_m (copy)

    local v14 = FighterController_m:WaitForLocalFighter()

    local function play_queued_celebration() -- line: 155
        -- upvalues:
        --  [1] arg12 (copy)

        if arg12._celebration_queued then
            arg12:_PlayCelebration()
        end
    end

    MatchmakingCountdown_m.VisibilityChanged:Connect(play_queued_celebration)
    v14:GetDataChangedSignal("IsInShootingRange"):Connect(play_queued_celebration)
    v14:GetDataChangedSignal("IsInDuel"):Connect(play_queued_celebration)

    if arg12._celebration_queued then
        arg12:_PlayCelebration()
    end
end

function t._Init(arg13) -- line: 167
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("LobbyWeaponReleaseSchedule"):Connect(function(arg14) -- line: 168
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_ModelAdded(arg14)
    end)

    for _, val_4 in pairs(CollectionService:GetTagged("LobbyWeaponReleaseSchedule")) do
        task.defer(arg13._ModelAdded, arg13, val_4)
    end

    arg13:Refresh(true)
    task.defer(arg13._HookLocalFighter, arg13)
    task.defer(arg13._RefreshLoop, arg13)
end

return t._new()
