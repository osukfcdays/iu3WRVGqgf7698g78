local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.GameplayUtility)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local FighterController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local EnemyController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.EnemyController)
local t = {}
t.__index = t

function t._new() -- line: 14
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._hurt_effect_enabled = false
    t_1._hurt_effect_outline_only = false
    t_1._hurt_effect_color_fill = Color3.fromRGB(255, 50, 50)
    t_1._hurt_effect_color_outline = Color3.fromRGB(255, 255, 255)
    t_1:_Init()

    return t_1
end

function t.GetScreenPoints(_, arg2, arg3) -- line: 31
    -- upvalues:
    --  [1] EnemyController_m (copy)
    --  [2] FighterController_m (copy)
    --  [3] CONSTANTS_m (copy)

    local t_2 = {}

    for _, val in pairs({ EnemyController_m.Objects, FighterController_m:GetEntities() }) do
        for _, val_1 in pairs(val) do
            if (not arg3 or not val_1.AimAssistBlacklist) and arg2:IsValidTarget(val_1) then
                local v2, v3 = val_1:GetScreenPoint()

                if v3 and v2.Z < CONSTANTS_m.RENDER_DISTANCE then
                    t_2[val_1] = v2
                end
            end
        end
    end

    return t_2
end

function t._UpdateSettings(arg4) -- line: 55
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Utility_m (copy)

    local v4 = PlayerDataController_m:GetSetting("Damage Flashing")
    arg4._hurt_effect_enabled = if v4 == "Disabled" then false else true
    arg4._hurt_effect_outline_only = v4 == "Outline"
    arg4._hurt_effect_color_fill = Utility_m:Color3FromHex(
        PlayerDataController_m:GetSetting("Damage Flashing Color Base")
    )
    arg4._hurt_effect_color_outline = Utility_m:Color3FromHex(
        PlayerDataController_m:GetSetting("Damage Flashing Color Flash")
    )
end

function t._SetupHurtEffect(arg5, arg6) -- line: 65
    -- upvalues:
    --  [1] Utility_m (copy)

    assert(
        if typeof(arg6) == "Instance" then arg6:IsA("Model") else false,
        "Argument 1 invalid, expected a Model"
    )
    arg6:SetAttribute("PlayHurtEffect", 0)
    local v9 = nil
    arg6:GetAttributeChangedSignal("PlayHurtEffect"):Connect(function() -- line: 72
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] v9 (ref)
        --  [3] arg6 (copy)
        --  [4] Utility_m (ref)

        if not arg5._hurt_effect_enabled then
            return
        end

        if v9 then
            v9:Destroy()
            v9 = nil
        end

        local HurtEffect_Highlight = Instance.new("Highlight")
        HurtEffect_Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        HurtEffect_Highlight.Name = "HurtEffect"
        HurtEffect_Highlight.Adornee = arg6
        HurtEffect_Highlight.Parent = arg6
        v9 = HurtEffect_Highlight
        Utility_m:RenderstepForLoop(0, 100, 1, function(arg7) -- line: 90
            -- upvalues:
            --  [1] HurtEffect_Highlight (copy)
            --  [2] v9 (ref)
            --  [3] arg5 (ref)

            if HurtEffect_Highlight ~= v9 then
                return true
            end

            local v10 = 1 - (1 - arg7 / 100) ^ 5
            local v11 = arg5._hurt_effect_color_outline:Lerp(
                arg5._hurt_effect_color_fill,
                (math.min(1, arg7 / 5))
            )
            HurtEffect_Highlight.FillColor = v11
            HurtEffect_Highlight.FillTransparency = if arg5._hurt_effect_outline_only then 1 else v10
            HurtEffect_Highlight.OutlineTransparency = v10
            local v14 = HurtEffect_Highlight
            v14.OutlineColor = if not arg5._hurt_effect_outline_only then arg5._hurt_effect_color_fill else v11
        end)
        HurtEffect_Highlight:Destroy()
    end)
end

function t._SetupHurtEffects(arg8) -- line: 108
    local HurtEffect_Model = Instance.new("Model")
    HurtEffect_Model.Name = "HurtEffect"
    HurtEffect_Model.Parent = workspace
    arg8:_SetupHurtEffect(HurtEffect_Model)
    arg8:_SetupHurtEffect(workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson"))
end

function t._Init(arg9) -- line: 117
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    PlayerDataController_m:GetSettingChangedSignal("Damage Flashing"):Connect(function() -- line: 118
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Damage Flashing Color Base"):Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateSettings()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Damage Flashing Color Flash"):Connect(function() -- line: 126
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateSettings()
    end)
    task.spawn(arg9._SetupHurtEffects, arg9)
    arg9:_UpdateSettings()
end

return t._new()
