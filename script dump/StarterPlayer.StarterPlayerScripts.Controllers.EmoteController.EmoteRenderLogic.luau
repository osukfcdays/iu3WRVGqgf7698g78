local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local t = {}
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EmoteController = arg1
    t_1._subject_enemies = {}
    t_1._subject_enemies_changed = Signal_m.new()
    t_1._subject_enemy_added = Signal_m.new()
    t_1._subject_enemy_removed = Signal_m.new()
    t_1._update_visibility_thread = nil
    t_1._dont_render_until = 0
    t_1._last_is_emoting_check = nil
    t_1:_Init()

    return t_1
end

function t._IsSystemActive(arg2) -- line: 44
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] CameraController_m (copy)

    return (SpectateController_m:IsSubjectEmoting() or tick() < arg2._dont_render_until) and not CameraController_m:HasThirdPersonAccess(
        true
    )
end

function t._GetPosition(_, arg4) -- line: 51
    local v2 = arg4

    if v2 then
        v2 = arg4:IsAlive()

        if v2 then
            v2 = arg4.Entity and arg4.Entity.RootPart and arg4.Entity.RootPart.Position
        end
    end

    return v2
end

function t._IsHidden(arg5, arg6) -- line: 59
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] Utility_m (copy)
    --  [3] GameplayUtility_m (copy)

    if arg6 == SpectateController_m.CurrentSubject then
        return false
    end

    if tick() > arg5._dont_render_until and not SpectateController_m:IsSubjectEmoting() then
        return false
    end

    local v3 = arg5:_GetPosition(SpectateController_m.CurrentSubject)
    local v4 = v3

    if v4 then
        v4 = arg5:_GetPosition(arg6)
    end

    if not v3 or not v4 then
        return false
    end

    if
        Utility_m:Raycast(
            v3,
            v4,
            (v3 - v4).Magnitude,
            SpectateController_m.CurrentSubject:GetRaycastWhitelist(),
            Enum.RaycastFilterType.Include
        ).Instance
        or GameplayUtility_m:GetSmokeCloudBetweenPoints(v3, v4)
        or #GameplayUtility_m:GetSmokeCloudsInSphere(v4) > 0
        or #GameplayUtility_m:GetSmokeCloudsInSphere(v3) > 0
    then
        return true
    end

    return false
end

function t._UpdateVisibility(arg7) -- line: 88
    -- upvalues:
    --  [1] SpectateController_m (copy)

    local v7 = SpectateController_m:IsSubjectEmoting()

    if arg7._last_is_emoting_check and not v7 then
        arg7._dont_render_until = tick() + 0.25
        task.delay(0.25, arg7._CheckSubjectEmoteStatus, arg7)
    end

    arg7._last_is_emoting_check = v7

    for _, val in pairs(arg7._subject_enemies) do
        local v8 = arg7:_IsHidden(val) or nil

        if v8 ~= val:Get("IsHiddenByEmotes") then
            val:SetReplicate("IsHiddenByEmotes", v8)
        end
    end
end

function t._CheckSubjectEmoteStatus(arg8) -- line: 114
    if arg8._update_visibility_thread then
        task.cancel(arg8._update_visibility_thread)
        arg8._update_visibility_thread = nil
    end

    arg8:_UpdateVisibility()
    arg8:_UpdateList()

    if not arg8:_IsSystemActive() then
        return
    end

    arg8._update_visibility_thread = task.spawn(function() -- line: 127
        -- upvalues:
        --  [1] arg8 (copy)

        while true do
            wait(0.1)
            arg8:_UpdateVisibility()
        end
    end)
end

function t._GetList(arg9) -- line: 135
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] FighterController_m (copy)

    local CurrentSubject = SpectateController_m.CurrentSubject

    if
        not CurrentSubject
        or not CurrentSubject:Get("IsInDuel")
        or not arg9:_IsSystemActive()
        or not SpectateController_m.CurrentDuelSubject
        or not SpectateController_m.CurrentDuelSubject.LocalDueler
    then
        return {}
    end

    local t_2 = {}

    for _, val_1 in pairs(FighterController_m.Objects) do
        local v9 = val_1:Get("EnvironmentID")

        if
            val_1 ~= CurrentSubject
            and v9 == CurrentSubject:Get("EnvironmentID")
            and (not val_1:Get("TeamID") or val_1:Get("TeamID") ~= CurrentSubject:Get("TeamID"))
        then
            table.insert(t_2, val_1)
        end
    end

    return t_2
end

function t._UpdateList(arg10) -- line: 165
    local v11 = arg10:_GetList()
    local v12 = false

    for index = #arg10._subject_enemies, 1, -1 do
        local v13 = arg10._subject_enemies[index]

        if not table.find(v11, v13) then
            table.remove(arg10._subject_enemies, index)
            arg10._subject_enemy_removed:Fire(v13)
            v12 = true
        end
    end

    for _, val_2 in pairs(v11) do
        if not table.find(arg10._subject_enemies, val_2) then
            table.insert(arg10._subject_enemies, val_2)
            arg10._subject_enemy_added:Fire(val_2)
            v12 = true
        end
    end

    if v12 then
        arg10._subject_enemies_changed:Fire()
    end
end

function t._FighterAdded(arg11, arg12, arg13) -- line: 194
    arg12:GetDataChangedSignal("EnvironmentID"):Connect(function() -- line: 195
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateList()
    end)
    arg12:GetDataChangedSignal("TeamID"):Connect(function() -- line: 199
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateList()
    end)

    if not arg13 then
        arg11:_UpdateList()
    end
end

function t._Init(arg14) -- line: 208
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] FighterController_m (copy)

    arg14._subject_enemy_added:Connect(function(arg15) -- line: 209
        arg15:SetReplicate("IsHiddenByEmotes", nil)
    end)
    arg14._subject_enemy_removed:Connect(function(arg16) -- line: 213
        arg16:SetReplicate("IsHiddenByEmotes", nil)
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 217
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_CheckSubjectEmoteStatus()
    end)
    SpectateController_m.SubjectEmoteStatusChanged:Connect(function() -- line: 221
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_CheckSubjectEmoteStatus()
    end)
    FighterController_m.ObjectAdded:Connect(function(arg17) -- line: 225
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_FighterAdded(arg17)
    end)

    for _, val_3 in pairs(FighterController_m.Objects) do
        task.spawn(arg14._FighterAdded, arg14, val_3, true)
    end

    task.defer(arg14._CheckSubjectEmoteStatus, arg14)
end

return t
