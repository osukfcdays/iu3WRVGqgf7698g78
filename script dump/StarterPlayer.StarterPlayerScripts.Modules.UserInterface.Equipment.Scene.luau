local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local EventLibrary_m = require(ReplicatedStorage.Modules.EventLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local FinisherPlayer_m = require(script:WaitForChild("FinisherPlayer"))
local EmotePlayer_m = require(script:WaitForChild("EmotePlayer"))
local UnlockModel_m = require(script:WaitForChild("UnlockModel"))
local EquipmentScenes = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "EquipmentScenes"
)
local t = { "Default", "Green Screen", "Pink Screen", "Blue Screen" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 19
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] EquipmentScenes (copy)
    --  [3] EventLibrary_m (copy)
    --  [4] FinisherPlayer_m (copy)
    --  [5] EmotePlayer_m (copy)
    --  [6] UnlockModel_m (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.Equipment = arg1
    local v4 = EquipmentScenes:FindFirstChild(EventLibrary_m.LOBBY_VISUALS_PROFILE) or EquipmentScenes:WaitForChild(
        "Default"
    )
    t_2.Model = v4:Clone()
    t_2.FinisherPlayer = FinisherPlayer_m.new(t_2)
    t_2.EmotePlayer = EmotePlayer_m.new(t_2)
    t_2.UnlockModel = UnlockModel_m.new(t_2)
    t_2._textures_deleted = false
    t_2._backgrounds_folder = t_2.Model:WaitForChild("Backgrounds")
    t_2._hide_career_folder = t_2._backgrounds_folder:WaitForChild("Default"):WaitForChild(
        "HideCareer"
    )
    t_2._backgrounds = {}
    t_2._dof = Instance.new("DepthOfFieldEffect")
    t_2:_Init()

    return t_2
end

function t_1.GetCFrame(arg2) -- line: 43
    return arg2.Model.Primary.CFrame
end

function t_1.GetHumanoidCFrame(arg3) -- line: 47
    return arg3.FinisherPlayer:GetHumanoidCFrame()
end

function t_1.OnOpen(arg4, ...) -- line: 51
    local Model = arg4.Model
    Model.Parent = arg4.Equipment.IsOpen and workspace or nil
    arg4:_UpdateDOF()
    arg4.UnlockModel:OnOpen(...)
end

function t_1.OnCustomizingStateChanged(arg5, ...) -- line: 58
    arg5.FinisherPlayer:OnCustomizingStateChanged(...)
    arg5.EmotePlayer:OnCustomizingStateChanged(...)
end

function t_1.OnStateChanged(arg6, ...) -- line: 63
    arg6.FinisherPlayer:OnStateChanged(...)
    arg6.EmotePlayer:OnStateChanged(...)
    arg6.UnlockModel:OnStateChanged(...)
end

function t_1._UpdateTextures(arg7) -- line: 73
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)

    if arg7._textures_deleted or not PlayerDataController_m:GetSetting("Textures Disabled") then
        return
    end

    arg7._textures_deleted = true
    Utility_m:DisableTextures(arg7.Model)
end

function t_1._UpdateDOF(arg8) -- line: 82
    -- upvalues:
    --  [1] Lighting (copy)

    local Dof = arg8._dof
    Dof.Parent = arg8.Equipment.IsOpen and arg8.Equipment:IsOpenEffectDone() ~= arg8.Equipment.Camera:IsClosing() and Lighting or nil
end

function t_1._UpdateCareerFolder(arg9) -- line: 86
    local v8 = arg9.Equipment:IsCareerPageOpen()
    local v9 = arg9.Equipment:GetCustomizingType()
    local v10 = v8 or v9 == "Finisher" or v9 == "Emote"
    local HideCareerFolder = arg9._hide_career_folder
    HideCareerFolder.Parent = if v10 then nil else arg9._backgrounds.Default or nil
end

function t_1._UpdateBackgroundFolder(arg10) -- line: 94
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v12 = PlayerDataController_m:GetSetting("Equipment Background")

    for key, val in pairs(arg10._backgrounds) do
        local v13 = if key ~= v12 then nil else arg10._backgrounds_folder or nil
        val.Parent = v13
    end
end

function t_1._Setup(arg11) -- line: 102
    -- upvalues:
    --  [1] t (copy)

    for _, val_1 in pairs(t) do
        arg11._backgrounds[val_1] = arg11._backgrounds_folder:WaitForChild(val_1)
    end

    arg11._dof.FarIntensity = 0.75
    arg11._dof.FocusDistance = 0.05
    arg11._dof.InFocusRadius = 15
    arg11._dof.NearIntensity = 0
    arg11._dof.Name = "Equipment"
end

function t_1._Init(arg12) -- line: 114
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg12.Equipment.CareerPageOpened:Connect(function() -- line: 115
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateCareerFolder()
    end)
    arg12.Equipment.CustomizingChanged:Connect(function() -- line: 119
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateCareerFolder()
    end)
    arg12.Equipment.FinishedOpenEffect:Connect(function() -- line: 123
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateDOF()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Equipment Background"):Connect(function() -- line: 127
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateBackgroundFolder()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Textures Disabled"):Connect(function() -- line: 131
        -- upvalues:
        --  [1] arg12 (copy)

        arg12:_UpdateTextures()
    end)
    arg12:_Setup()
    arg12:_UpdateTextures()
    arg12:_UpdateCareerFolder()
    arg12:_UpdateBackgroundFolder()
end

return t_1
