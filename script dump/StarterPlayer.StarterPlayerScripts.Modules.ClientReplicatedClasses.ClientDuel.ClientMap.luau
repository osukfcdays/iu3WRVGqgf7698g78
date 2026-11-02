local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedClass_m = require(ReplicatedStorage.Modules.ReplicatedClass)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local _ = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.Docks = { "rbxassetid://17813065011", 0.25, 0 }
t.Station = { "rbxassetid://17813065464", 0.25, 13 }
t["Big Station"] = { "rbxassetid://17813065464", 0.25, 13 }
t.Backrooms = { "rbxassetid://17813170797", 1, 0 }
t.Construction = { "rbxassetid://93752516938586", 1, 0 }
t["Big Backrooms"] = { "rbxassetid://17813170797", 1, 0 }
t.Onyx = { "rbxassetid://12099785239", 0.375, 0 }
t["Big Onyx"] = { "rbxassetid://12099785239", 0.375, 0 }
t.Splash = { "rbxassetid://18963688210", 0.75, 0 }
t["Big Splash"] = { "rbxassetid://18963688210", 0.75, 0 }
t["Zombie Tower"] = { "rbxassetid://90122406367653", 0.25, 0 }
t.Iceberg = { "rbxassetid://103004663415392", 0.25, 0 }
t.Village = { "rbxassetid://103004663415392", 0.25, 0 }
t.Studio = { "rbxassetid://90866007129930", 1, 0 }
t.Westown = { "rbxassetid://116999944271223", 1, 0 }
t["Gargoyle Tower"] = { "rbxassetid://90122406367653", 0.25, 0 }
local t_17 = setmetatable({}, ReplicatedClass_m)
t_17.__index = t_17

function t_17.new(arg1, arg2) -- line: 32
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)
    --  [2] t_17 (copy)

    local t_18 = setmetatable(ReplicatedClass_m.new(arg1), t_17)
    t_18.Name = arg1.Name
    t_18.Model = arg1.Model
    t_18.ClientDuel = arg2
    t_18.Data.IsHidden = nil
    t_18.Data.LightingProfileOverride = nil
    t_18._destroyed = false
    t_18._connections = {}
    t_18._active_connections = {}
    t_18._seed = arg1.Seed
    t_18._on_hidden_update_callback = nil
    t_18._textures_deleted = false
    t_18._shadows_deleted = false
    t_18._ambience_sound = nil
    t_18._spectate_part = nil
    t_18._lighting_objects_folder = t_18.Model:FindFirstChild("LightingObjects")
    t_18._lighting_objects_folders = t_18._lighting_objects_folder and t_18._lighting_objects_folder:GetChildren() or {}
    t_18:_Init()

    return t_18
end

function t_17.IsRendered(arg3) -- line: 63
    return arg3.ClientDuel:IsRendered()
end

function t_17.GetSpectatePart(arg4) -- line: 67
    if not arg4._spectate_part then
        arg4._spectate_part = arg4.Model:FindFirstChild("Spectate")
    end

    return arg4._spectate_part
end

function t_17.GetScoreboardDisplay(_) -- line: 75
    return nil
end

function t_17.SetHidden(arg6, arg7) -- line: 79
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] RunService (copy)

    if arg7 == arg6:Get("IsHidden") then
        return
    end

    for _, val in pairs(arg6._active_connections) do
        val:Disconnect()
    end

    arg6._active_connections = {}
    arg6:SetReplicate("IsHidden", arg7)
    local Model = arg6.Model
    Model.Parent = not arg7 and workspace or nil
    arg6:_UpdateAmbience()

    if arg7 then
        return
    end

    table.insert(arg6._active_connections, PlayerDataController_m:GetSettingChangedSignal(
        "Textures Disabled"
    ):Connect(function() -- line: 98
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateTextures()
    end))
    table.insert(arg6._active_connections, PlayerDataController_m:GetSettingChangedSignal(
        "Shadows Disabled"
    ):Connect(function() -- line: 102
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateShadows()
    end))
    table.insert(arg6._active_connections, RunService.RenderStepped:Connect(function(
        deltaTime: number
    ) -- line: 106
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:Update(deltaTime)
    end))
    arg6:_UpdateTextures()
    arg6:_UpdateShadows()
end

function t_17.CreateSound(arg9, ...) -- line: 114
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg9:Get("IsHidden") then
        return
    end

    return Utility_m:CreateSound(...)
end

function t_17.Update(_, _) -- line: 122
end

function t_17.Destroy(arg12) -- line: 126
    -- upvalues:
    --  [1] ReplicatedClass_m (copy)

    arg12._destroyed = true

    for _, val_1 in pairs(arg12._active_connections) do
        val_1:Disconnect()
    end

    for _, val_2 in pairs(arg12._connections) do
        val_2:Disconnect()
    end

    if arg12._ambience_sound then
        arg12._ambience_sound:Destroy()
    end

    ReplicatedClass_m.Destroy(arg12)
end

function t_17._UpdateLightingObjects(arg13) -- line: 148
    local v6 = arg13:Get("LightingProfileOverride") or arg13.Name

    for _, val_3 in pairs(arg13._lighting_objects_folders) do
        local v7 = if val_3.Name ~= v6 then nil else arg13._lighting_objects_folder or nil
        val_3.Parent = v7
    end
end

function t_17._UpdateHidden(arg14) -- line: 156
    local Success, Result = pcall(function() -- line: 157
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:SetHidden(not arg14.ClientDuel:Get("IsSpectating"))
    end)

    if not Success then
        warn("Failed to hide/unhide map, error:", Result)
    end
end

function t_17._UpdateAmbience(arg15) -- line: 166
    -- upvalues:
    --  [1] t (copy)
    --  [2] Utility_m (copy)

    if arg15:Get("IsHidden") and arg15._ambience_sound then
        arg15._ambience_sound:Destroy()
        arg15._ambience_sound = nil

        return
    end

    if not arg15:Get("IsHidden") and not arg15._ambience_sound then
        local v10 = t[arg15.Name]

        if v10 then
            arg15._ambience_sound = Utility_m:CreateSound(
                v10[1],
                v10[2],
                1,
                script,
                true
            )
            arg15._ambience_sound.Looped = true
            arg15._ambience_sound.TimePosition = v10[3]
        end
    end
end

function t_17._UpdateShadows(arg16) -- line: 181
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)

    if
        arg16._shadows_deleted
        or arg16:Get("IsHidden")
        or not PlayerDataController_m:GetSetting("Shadows Disabled")
    then
        return
    end

    arg16._shadows_deleted = true
    Utility_m:DisableShadows(arg16.Model)
end

function t_17._UpdateTextures(arg17) -- line: 190
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)

    if
        arg17._textures_deleted
        or arg17:Get("IsHidden")
        or not PlayerDataController_m:GetSetting("Textures Disabled")
    then
        return
    end

    arg17._textures_deleted = true
    Utility_m:DisableTextures(arg17.Model)
end

function t_17._Init(arg18) -- line: 199
    local Connections = arg18._connections
    local IsSpectating = arg18.ClientDuel:GetDataChangedSignal("IsSpectating")
    table.insert(Connections, IsSpectating:Connect(function() -- line: 200
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateHidden()
    end))
    arg18:GetDataChangedSignal("LightingProfileOverride"):Connect(function() -- line: 204
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_UpdateLightingObjects()
    end)
    arg18:_UpdateHidden()
    task.defer(arg18._UpdateLightingObjects, arg18)
end

return t_17
