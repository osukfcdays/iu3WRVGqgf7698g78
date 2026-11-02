local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local Equipment_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Equipment)
local LightingProfiles = Players.LocalPlayer.PlayerScripts.Modules.LightingProfiles
local LightingProfiles_1 = Players.LocalPlayer.PlayerScripts.Assets.LightingProfiles
local v1 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.EVENT_DETAILS.LOBBY_LIGHTING_PROFILE or "Lobby"
local v2 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.EVENT_DETAILS.EQUIPMENT_LIGHTING_PROFILE or "Lobby"
local t = {}
t.__index = t

function t._new() -- line: 19
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.LocalFighter = nil
    t_1._connections = {}
    t_1._assets = {}
    t_1._current_lighting_name = nil
    t_1:_Init()

    return t_1
end

function t.SetLighting(arg1, arg2) -- line: 37
    if arg2 == arg1._current_lighting_name then
        return
    end

    arg1:_LoadMapLightingAssets("Default")
    arg1:_LoadMapLightingModule("Default")

    if arg2 == "Default" then
        return
    end

    arg1:_LoadMapLightingAssets(arg2)
    arg1:_LoadMapLightingModule(arg2)
end

function t._LoadMapLightingAssets(arg3, arg4) -- line: 57
    -- upvalues:
    --  [1] LightingProfiles_1 (copy)
    --  [2] Lighting (copy)

    local v3 = LightingProfiles_1:FindFirstChild(arg4)

    if not v3 then
        return
    end

    for _, val in pairs(arg3._assets) do
        val:Destroy()
    end

    arg3._assets = {}

    for _, val_1 in pairs(v3:GetChildren()) do
        local v5 = val_1:Clone()
        v5.Name = "LightingController"
        local v6 = val_1:IsA("Clouds") and workspace.Terrain or Lighting
        v5.Parent = v6
        table.insert(arg3._assets, v5)
    end
end

function t._LoadMapLightingModule(_, arg6) -- line: 78
    -- upvalues:
    --  [1] LightingProfiles (copy)
    --  [2] Lighting (copy)
    --  [3] SoundService (copy)

    local v7 = LightingProfiles:FindFirstChild(arg6)

    if v7 then
        v7 = require(LightingProfiles[arg6])
    end

    if not v7 then
        return
    end

    local v8 = pairs
    local v9 = v7.TerrainMaterials or {}

    for key_2, val_2 in v8(v9) do
        workspace.Terrain:SetMaterialColor(key_2, val_2)
    end

    local v10 = pairs
    v9 = v7.TerrainProperties or {}

    for key_3, val_3 in v10(v9) do
        workspace.Terrain[key_3] = val_3
    end

    local v11 = pairs
    v9 = v7.LightingProperties or {}

    for key_4, val_4 in v11(v9) do
        Lighting[key_4] = val_4
    end

    local v12 = pairs
    v9 = v7.SoundServiceProperties or {}

    for key_5, val_5 in v12(v9) do
        SoundService[key_5] = val_5
    end
end

function t._UpdateLighting(arg7) -- line: 102
    -- upvalues:
    --  [1] Equipment_m (copy)
    --  [2] v2 (copy)
    --  [3] SpectateController_m (copy)
    --  [4] v1 (copy)

    for _, val_6 in pairs(arg7._connections) do
        val_6:Disconnect()
    end

    arg7._connections = {}

    if Equipment_m.IsOpen then
        arg7:SetLighting(v2)

        return
    end

    if SpectateController_m.CurrentDuelSubject then
        local function update() -- line: 112
            -- upvalues:
            --  [1] SpectateController_m (ref)
            --  [2] arg7 (copy)

            local v13 = SpectateController_m.CurrentDuelSubject

            if v13 then
                v13 = SpectateController_m.CurrentDuelSubject.Map
            end

            arg7:SetLighting(
                if v13 then v13:Get("LightingProfileOverride") or v13.Name or "Default" else "Default"
            )
        end

        local function map_added(arg8) -- line: 118
            -- upvalues:
            --  [1] arg7 (copy)
            --  [2] update (copy)
            --  [3] SpectateController_m (ref)

            table.insert(
                arg7._connections,
                arg8:GetDataChangedSignal("LightingProfileOverride"):Connect(update)
            )
            local v16 = SpectateController_m.CurrentDuelSubject

            if v16 then
                v16 = SpectateController_m.CurrentDuelSubject.Map
            end

            arg7:SetLighting(
                if v16 then v16:Get("LightingProfileOverride") or v16.Name or "Default" else "Default"
            )
        end

        table.insert(
            arg7._connections,
            SpectateController_m.CurrentDuelSubject.MapAdded:Connect(map_added)
        )

        if SpectateController_m.CurrentDuelSubject.Map then
            table.insert(
                arg7._connections,
                SpectateController_m.CurrentDuelSubject.Map:GetDataChangedSignal(
                    "LightingProfileOverride"
                ):Connect(update)
            )
            local v19 = SpectateController_m.CurrentDuelSubject

            if v19 then
                v19 = SpectateController_m.CurrentDuelSubject.Map
            end

            arg7:SetLighting(
                if v19 then v19:Get("LightingProfileOverride") or v19.Name or "Default" else "Default"
            )
        end

        local v21 = SpectateController_m.CurrentDuelSubject

        if v21 then
            v21 = SpectateController_m.CurrentDuelSubject.Map
        end

        arg7:SetLighting(
            if v21 then v21:Get("LightingProfileOverride") or v21.Name or "Default" else "Default"
        )

        return
    end

    if arg7.LocalFighter and arg7.LocalFighter:Get("IsInShootingRange") then
        arg7:SetLighting("Shooting Range")

        return
    end

    arg7:SetLighting(v1)
end

function t._HookLocalFighter(arg9) -- line: 137
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg9.LocalFighter = FighterController_m:WaitForLocalFighter()
    arg9.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 140
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateLighting()
    end)
    arg9:_UpdateLighting()
end

function t._Setup(_) -- line: 147
    -- upvalues:
    --  [1] Lighting (copy)

    workspace.Terrain:ClearAllChildren()

    for _, child in pairs(Lighting:GetChildren()) do
        if child.Name == "REMOVE_AT_RUNTIME" then
            child:Destroy()
        end
    end
end

function t._Init(arg11) -- line: 157
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] Equipment_m (copy)

    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 158
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateLighting()
    end)
    Equipment_m.Opened:Connect(function() -- line: 162
        -- upvalues:
        --  [1] arg11 (copy)

        arg11:_UpdateLighting()
    end)
    arg11:_Setup()
    arg11:_UpdateLighting()
    task.spawn(arg11._HookLocalFighter, arg11)
end

return t._new()
