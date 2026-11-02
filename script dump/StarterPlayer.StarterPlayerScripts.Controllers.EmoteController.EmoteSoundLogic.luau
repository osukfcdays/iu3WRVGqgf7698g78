local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.EmoteController = arg1
    t_1._emotes_order = {}
    t_1:_Init()

    return t_1
end

function t._GetDistance(_, arg3) -- line: 35
    local v1 = arg3.Entity
    local Position = workspace.CurrentCamera.CFrame.Position
    v1 = v1 and arg3.Entity.RootPart and arg3.Entity.RootPart.Position

    if not v1 then
        return nil
    end

    return (Position - v1).Magnitude
end

function t._IsValidFighter(arg4, arg5) -- line: 46
    -- upvalues:
    --  [1] SpectateController_m (copy)

    if (if SpectateController_m.CurrentSubject then SpectateController_m.CurrentSubject:Get(
        "EnvironmentID"
    ) else if SpectateController_m.CurrentDuelSubject then SpectateController_m.CurrentDuelSubject:Get(
        "EnvironmentID"
    ) else nil) ~= arg5:Get("EnvironmentID") then
        return false
    end

    local v3 = arg4:_GetDistance(arg5)

    if not v3 or v3 > 128 then
        return false
    end

    return true
end

function t._VerifyEmotesOrder(arg6) -- line: 65
    -- upvalues:
    --  [1] FighterController_m (copy)
    --  [2] CosmeticLibrary_m (copy)

    local t_2 = {}

    for index = #arg6._emotes_order, 1, -1 do
        local v4 = arg6._emotes_order[index]
        t_2[v4.ClientFighter] = true

        if v4.Emote:IsDestroyed() or not arg6:_IsValidFighter(v4.ClientFighter) then
            v4.Emote:HideSounds(false)
            table.remove(arg6._emotes_order, index)
        end
    end

    for _, val in pairs(FighterController_m.Objects) do
        if not t_2[val] then
            local v5 = val.Entity

            if v5 then
                v5 = val.Entity:IsEmoting()

                if v5 then
                    v5 = val.Entity:GetCurrentEmote()
                end
            end

            if v5 and CosmeticLibrary_m.Cosmetics[v5.Name].IsAudioIntrusive and arg6:_IsValidFighter(
                val
            ) then
                table.insert(arg6._emotes_order, { Emote = v5, ClientFighter = val })
            end
        end
    end

    table.clear(t_2)
    table.sort(arg6._emotes_order, function(arg7, arg8) -- line: 100
        -- upvalues:
        --  [1] arg6 (copy)

        return arg6:_GetDistance(arg7.ClientFighter) < arg6:_GetDistance(arg8.ClientFighter) and true
    end)
end

function t._Check(arg9) -- line: 105
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] CosmeticLibrary_m (copy)

    arg9:_VerifyEmotesOrder()
    local v8 = SpectateController_m:IsSubjectEmoting()

    if v8 then
        v8 = CosmeticLibrary_m.Cosmetics[SpectateController_m.CurrentSubject.Entity:GetCurrentEmote().Name].IsAudioIntrusive
    end

    local v9

    for key_1, val_1 in pairs(arg9._emotes_order) do
        if v8 then
            local Emote = val_1.Emote
            v9 = val_1.ClientFighter ~= SpectateController_m.CurrentSubject
            Emote:HideSounds(v9)
        else
            local Emote_1 = val_1.Emote
            v9 = key_1 > 1
            Emote_1:HideSounds(v9)
        end
    end
end

function t._CheckLoop(arg10) -- line: 121
    while true do
        arg10:_Check()
        wait(1)
    end
end

function t._FighterAdded(arg11, arg12, arg13) -- line: 128
    local function entity_added(arg14) -- line: 129
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] arg13 (copy)

        arg14.EmoteStatusChanged:Connect(function() -- line: 130
            -- upvalues:
            --  [1] arg11 (ref)

            arg11:_Check()
        end)

        if not arg13 then
            arg11:_Check()
        end
    end

    arg12.EntityAdded:Connect(entity_added)

    if arg12.Entity then
        task.spawn(entity_added, arg12.Entity)
    end

    if not arg13 then
        arg11:_Check()
    end
end

function t._Init(arg15) -- line: 150
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] FighterController_m (copy)

    SpectateController_m.SubjectEmoteStatusChanged:Connect(function() -- line: 151
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_Check()
    end)
    FighterController_m.ObjectAdded:Connect(function(arg16) -- line: 155
        -- upvalues:
        --  [1] arg15 (copy)

        arg15:_FighterAdded(arg16)
    end)

    for _, val_2 in pairs(FighterController_m.Objects) do
        task.spawn(arg15._FighterAdded, arg15, val_2, true)
    end

    task.defer(arg15._CheckLoop, arg15)
end

return t
