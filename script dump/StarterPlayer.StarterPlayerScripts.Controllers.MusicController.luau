local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "Equipment"
    )
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local v6 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.EVENT_DETAILS.LOBBY_MUSIC or "Default"
local v7 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.EVENT_DETAILS.LOBBY_MUSIC_MUFFLED or "DefaultMuffled"
local t = {}
t[""] = { "", 1 }
t.Default = { "rbxassetid://17697682466", 1 }
t.DefaultMuffled = { "rbxassetid://17733314783", 1 }
t.Spooky = { "rbxassetid://100081814360953", 1 }
t.SpookyMuffled = { "rbxassetid://86062306109271", 0.5 }
t.Festive = { "rbxassetid://82135261819112", 1 }
t.FestiveMuffled = { "rbxassetid://96771526359691", 1 }
t.Tropical = { "rbxassetid://120824068504773", 1 }
t.TropicalMuffled = { "rbxassetid://114306049661290", 1 }
t.Obby = { "rbxassetid://91718252417630", 1 }
t.Spleef = { "rbxassetid://91718252417630", 1 }
t.ZombieTower = { "rbxassetid://120087790552326", 1 }
t.GargoyleTower = { "rbxassetid://74833315667579", 1 }
local t_14 = {}
t_14.__index = t_14

function t_14._new() -- line: 35
    -- upvalues:
    --  [1] t_14 (copy)
    --  [2] t (copy)

    local t_15 = setmetatable({}, t_14)
    t_15.LocalFighter = nil
    t_15._volume = 0.5
    t_15._sound_name = ""
    t_15._sound_info = t[""]
    t_15._is_tweening = false
    t_15._sound = Instance.new("Sound")
    t_15._next_sound = Instance.new("Sound")
    t_15._volume_multiplier = 1
    t_15._duel_subject_connections = {}
    t_15:_Init()

    return t_15
end

function t_14.SetSoundID(arg1, arg2, arg3) -- line: 58
    -- upvalues:
    --  [1] t (copy)

    local v8 = not arg2 or t[arg2]
    assert(v8, "Argument 1 invalid, expected a string or nil")
    v8 = not arg3 or (if typeof(arg3) ~= "number" then false else true)
    assert(v8, "Argument 2 invalid, expected a number or nil")

    if arg2 == arg1._sound_name then
        return
    end

    arg1._sound_name = arg2 or ""
    arg1._sound_info = t[arg1._sound_name]
    arg1._volume_multiplier = arg3 or 1
    task.spawn(arg1._TweenSoundID, arg1)
end

function t_14.SetVolume(arg4, arg5) -- line: 73
    assert(
        if typeof(arg5) ~= "number" then false else true,
        "Argument 1 invalid, expected a number"
    )
    arg4._volume = arg5
    arg4:_UpdateVolume()
end

function t_14._UpdateSoundGroups(_, arg7, arg8) -- line: 84
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] SoundService (copy)

    local _ = function(arg9) --[[ get ]] -- line: 85
        -- upvalues:
        --  [1] arg7 (copy)
        --  [2] arg8 (copy)
        --  [3] PlayerDataController_m (ref)

        if arg9 == arg7 then
            return arg8
        end

        return (PlayerDataController_m:GetSetting(arg9))
    end

    SoundService.Master.Volume = if arg7 == "Master Volume" then arg8 else PlayerDataController_m:GetSetting(
        "Master Volume"
    )
    SoundService.Master.Music.Volume = if arg7 == "Music Volume" then arg8 else PlayerDataController_m:GetSetting(
        "Music Volume"
    )
    SoundService.Master.Other.Volume = if arg7 == "Other Volume" then arg8 else PlayerDataController_m:GetSetting(
        "Other Volume"
    )
    SoundService.Master.Finisher.Volume = if arg7 == "Finisher Volume" then arg8 else PlayerDataController_m:GetSetting(
        "Finisher Volume"
    )
    SoundService.Master.Emote.Volume = if arg7 == "Emote Volume" then arg8 else PlayerDataController_m:GetSetting(
        "Emote Volume"
    )
    local FinisherFromOthers = SoundService.Master.Finisher.FinisherFromOthers
    FinisherFromOthers.Volume = if not (if arg7 == "Mute Finishers From Others" then arg8 else PlayerDataController_m:GetSetting(
        "Mute Finishers From Others"
    )) then 1 else 0
    local EmoteFromOthers = SoundService.Master.Emote.EmoteFromOthers
    EmoteFromOthers.Volume = if not (if arg7 == "Mute Emotes From Others" then arg8 else PlayerDataController_m:GetSetting(
        "Mute Emotes From Others"
    )) then 1 else 0
end

function t_14._GetCurrentEmoteInfo(_) -- line: 98
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] CosmeticLibrary_m (copy)

    local v12 = SpectateController_m.CurrentSubject

    if v12 then
        v12 = SpectateController_m.CurrentSubject.Entity

        if v12 then
            v12 = SpectateController_m.CurrentSubject.Entity:GetCurrentEmote()
        end
    end

    if v12 then
        return v12.Info
    end

    v12 = Equipment_m.IsOpen and Equipment_m.EquipmentState.SelectedCosmetic
    local v13 = CosmeticLibrary_m.Cosmetics[v12]

    if v13 and v13.Type == "Emote" then
        return v13
    end
end

function t_14._GetVolume(arg11) -- line: 113
    local v14 = arg11._sound_info[2]
    local v15 = arg11:_GetCurrentEmoteInfo()

    return v14 * arg11._volume_multiplier * arg11._volume * (if v15 then if not v15.IsAudioIntrusive then 1 else 0 else 1)
end

function t_14._TweenSoundID(arg12) -- line: 122
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg12._is_tweening then
        return
    end

    arg12._is_tweening = true

    while true do
        if arg12._sound.SoundId == arg12._sound_info[1] then
            break
        end

        local v17 = if arg12._sound_name == "" then 0.25 else if arg12._sound.SoundId ~= "" then 2 else 0.25
        arg12._next_sound.SoundId = arg12._sound_info[1]

        if arg12._sound_name ~= "" then
            arg12._next_sound:Play()
            arg12._next_sound.TimePosition = arg12._sound.TimePosition
        end

        local Volume = arg12._sound.Volume
        Utility_m:RenderstepForLoop(0, 100, v17, function(arg13) -- line: 141
            -- upvalues:
            --  [1] arg12 (copy)
            --  [2] Volume (copy)

            local v19 = arg13 / 100
            arg12._sound.Volume = (1 - v19) * Volume
            arg12._next_sound.Volume = v19 * arg12:_GetVolume()
        end)
        arg12._sound:Stop()
        arg12._next_sound, arg12._sound = arg12._sound, arg12._next_sound
    end

    arg12._is_tweening = false
end

function t_14._UpdateVolume(arg14) -- line: 159
    if not arg14._is_tweening then
        arg14._sound.Volume = arg14:_GetVolume()
    end
end

function t_14._UpdateSoundID(arg15) -- line: 165
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] v7 (copy)
    --  [4] Pages_m (copy)
    --  [5] v6 (copy)

    local v20

    if not Equipment_m.IsOpen then
        if SpectateController_m.CurrentDuelSubject then
            if SpectateController_m.CurrentDuelSubject:Get("Status") == "GameOver" then
                v20 = v7

                if not v20 then
                    if not SpectateController_m.CurrentDuelSubject then
                        if arg15.LocalFighter then
                            if not arg15.LocalFighter:Get("IsInShootingRange") then
                                if Pages_m.PageSystem.CurrentPage then
                                    v20 = v7

                                    if not v20 then
                                        v20 = v6

                                        if not v20 then
                                            v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                                "DuelMusic"
                                            ) or nil
                                        end
                                    end
                                else
                                    v20 = v6

                                    if not v20 then
                                        v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                            "DuelMusic"
                                        ) or nil
                                    end
                                end
                            else
                                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                    "DuelMusic"
                                ) or nil
                            end
                        else
                            v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                "DuelMusic"
                            ) or nil
                        end
                    else
                        v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                            "DuelMusic"
                        ) or nil
                    end
                end
            elseif not SpectateController_m.CurrentDuelSubject then
                if arg15.LocalFighter then
                    if not arg15.LocalFighter:Get("IsInShootingRange") then
                        if Pages_m.PageSystem.CurrentPage then
                            v20 = v7

                            if not v20 then
                                v20 = v6

                                if not v20 then
                                    v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                        "DuelMusic"
                                    ) or nil
                                end
                            end
                        else
                            v20 = v6

                            if not v20 then
                                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                    "DuelMusic"
                                ) or nil
                            end
                        end
                    else
                        v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                            "DuelMusic"
                        ) or nil
                    end
                else
                    v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                        "DuelMusic"
                    ) or nil
                end
            else
                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                    "DuelMusic"
                ) or nil
            end
        elseif not SpectateController_m.CurrentDuelSubject then
            if arg15.LocalFighter then
                if not arg15.LocalFighter:Get("IsInShootingRange") then
                    if Pages_m.PageSystem.CurrentPage then
                        v20 = v7

                        if not v20 then
                            v20 = v6

                            if not v20 then
                                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                    "DuelMusic"
                                ) or nil
                            end
                        end
                    else
                        v20 = v6

                        if not v20 then
                            v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                "DuelMusic"
                            ) or nil
                        end
                    end
                else
                    v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                        "DuelMusic"
                    ) or nil
                end
            else
                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                    "DuelMusic"
                ) or nil
            end
        else
            v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                "DuelMusic"
            ) or nil
        end
    else
        v20 = v7

        if not v20 then
            if not SpectateController_m.CurrentDuelSubject then
                if arg15.LocalFighter then
                    if not arg15.LocalFighter:Get("IsInShootingRange") then
                        if Pages_m.PageSystem.CurrentPage then
                            v20 = v7

                            if not v20 then
                                v20 = v6

                                if not v20 then
                                    v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                        "DuelMusic"
                                    ) or nil
                                end
                            end
                        else
                            v20 = v6

                            if not v20 then
                                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                                    "DuelMusic"
                                ) or nil
                            end
                        end
                    else
                        v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                            "DuelMusic"
                        ) or nil
                    end
                else
                    v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                        "DuelMusic"
                    ) or nil
                end
            else
                v20 = SpectateController_m.CurrentDuelSubject and SpectateController_m.CurrentDuelSubject:Get(
                    "DuelMusic"
                ) or nil
            end
        end
    end

    arg15:SetSoundID(v20)
end

function t_14._DuelSubjectChanged(arg16) -- line: 174
    -- upvalues:
    --  [1] SpectateController_m (copy)

    arg16:_UpdateSoundID()

    if not SpectateController_m.CurrentDuelSubject then
        return
    end

    table.insert(arg16._duel_subject_connections, SpectateController_m.CurrentDuelSubject:GetDataChangedSignal(
        "DuelMusic"
    ):Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg16 (copy)

        arg16:_UpdateSoundID()
    end))
end

function t_14._HookLocalFighter(arg17) -- line: 186
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg17.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg17.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateSoundID()
    end)
    arg17.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function() -- line: 193
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_UpdateSoundID()
    end)
    arg17:_UpdateSoundID()
end

function t_14._Setup(arg18) -- line: 200
    -- upvalues:
    --  [1] SoundService (copy)

    arg18._sound.Name = "Music"
    arg18._sound.Looped = true
    arg18._sound.SoundGroup = SoundService.Master.Music
    arg18._sound.Parent = script
    arg18._next_sound.Name = "NextMusic"
    arg18._next_sound.Looped = true
    arg18._next_sound.SoundGroup = SoundService.Master.Music
    arg18._next_sound.Parent = script
end

function t_14._Init(arg19) -- line: 212
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] Equipment_m (copy)
    --  [3] Pages_m (copy)
    --  [4] PlayerDataController_m (copy)

    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 213
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_DuelSubjectChanged()
    end)
    SpectateController_m.DuelSubjectStatusChanged:Connect(function() -- line: 217
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundID()
    end)
    SpectateController_m.SubjectEmoteStatusChanged:Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVolume()
    end)
    Equipment_m.Opened:Connect(function() -- line: 225
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundID()
        arg19:_UpdateVolume()
    end)
    Equipment_m.CustomizingStateChanged:Connect(function() -- line: 230
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateVolume()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 234
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundID()
        arg19:_UpdateVolume()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Master Volume"):Connect(function() -- line: 239
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Music Volume"):Connect(function() -- line: 243
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Other Volume"):Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Finisher Volume"):Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Emote Volume"):Connect(function() -- line: 255
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Mute Finishers From Others"):Connect(function() -- line: 259
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Mute Emotes From Others"):Connect(function() -- line: 263
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateSoundGroups()
    end)
    PlayerDataController_m.SettingsSliderChanged:Connect(function(arg20, arg21) -- line: 267
        -- upvalues:
        --  [1] arg19 (copy)

        if arg20 == "Master Volume" or arg20 == "Music Volume" then
            arg19:_UpdateSoundGroups(arg20, arg21)
        end
    end)
    arg19:_Setup()
    arg19:_UpdateVolume()
    arg19:_DuelSubjectChanged()
    task.spawn(arg19._HookLocalFighter, arg19)
    task.defer(arg19._UpdateSoundGroups, arg19)
end

return t_14._new()
