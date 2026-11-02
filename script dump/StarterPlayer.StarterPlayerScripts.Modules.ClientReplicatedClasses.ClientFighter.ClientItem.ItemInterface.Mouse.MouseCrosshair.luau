local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local Crosshair_m = require(Players.LocalPlayer.PlayerScripts.Modules.Crosshair)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Crosshair_m (copy)
    --  [3] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Mouse = arg1
    t_1.Crosshair = Crosshair_m.new()
    t_1._crouch_spring = Spring_m.new(0, 0.875, 20)
    t_1._speed_spring = Spring_m.new(0, 0.875, 20)
    t_1._jump_spring = Spring_m.new(0, 0.875, 20)
    t_1._hitmarker_spring = Spring_m.new(1, 1, 20)
    t_1._hitmarker_rotation = 0
    t_1._last_damage_dealt_time = 0
    t_1:_Init()

    return t_1
end

function t.Refresh(arg2) -- line: 35
    -- upvalues:
    --  [1] SettingsLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)

    if arg2.Mouse.ItemInterface.ClientItem.ClientFighter.IsLocalPlayer then
        arg2.Crosshair:SetAppearance(
            SettingsLibrary_m:GenerateCrosshairAppearance(PlayerDataController_m)
        )
        arg2.Mouse:Refresh()

        return
    end

    local v1 = arg2.Mouse.ItemInterface.ClientItem.ClientFighter:Get(
        "CompressedCrosshairAppearance"
    )

    if v1 then
        arg2.Crosshair:SetAppearance(SettingsLibrary_m:DecodeCrosshairAppearance(v1))
        arg2.Mouse:Refresh()
    end
end

function t.DamageEffect(arg3, arg4, arg5) -- line: 50
    if arg4[utf8.char(0)] == 0 then
        return
    end

    arg3._hitmarker_rotation = math.sign(math.random() - 0.5) * 15
    arg3._hitmarker_spring.Value = 0
    arg3._last_damage_dealt_time = tick()
    arg3.Crosshair:SetHitmarkerColor(arg4[utf8.char(1)])
    arg3.Mouse.ItemInterface.ClientItem.ViewModel:PlayHitmarkerSound(arg4[utf8.char(1)], arg5)
end

function t.Update(arg6, _, arg8, _) -- line: 63
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    local v7

    if arg6.Crosshair.Info.DotEnabled or arg6.Crosshair.Info.BarsEnabled then
        local CurrentAimValue = arg6.Mouse.ItemInterface.ClientItem.ViewModel.CurrentAimValue
        local CurrentRecoilValue = arg6.Mouse.ItemInterface.ClientItem.ViewModel.CurrentRecoilValue
        local CurrentInspectValue = arg6.Mouse.ItemInterface.ClientItem.ViewModel.CurrentInspectValue
        local v2 = arg6.Mouse.ItemInterface.ClientItem.Info.ShootAccuracy or 1
        local v3 = arg6.Mouse.ItemInterface.ClientItem.ViewModel:IsAimingAnimationEnabled()
        local SpeedSpring = arg6._speed_spring
        SpeedSpring.Target = arg8.MoveSpeed > 4 and arg8.MoveSpeed or 0
        local JumpSpring = arg6._jump_spring
        JumpSpring.Target = if arg8.IsGrounded then 0 else 1
        local CrouchSpring = arg6._crouch_spring
        CrouchSpring.Target = if arg8.IsCrouching then 0.25 else 1

        for _, val in pairs({ arg6._speed_spring, arg6._jump_spring, arg6._crouch_spring }) do
            local v5 = val.Target > val.Value and val.Target or val.Value
            val.Value = v5
        end

        local v6 = arg6._speed_spring.Value * 0.75
        local Value = arg6._crouch_spring.Value
        local Value_1 = arg6._jump_spring.Value
        v7 = if not arg6.Mouse.Scope:IsActive() and arg6.Crosshair:ShowWhileAiming() then 1 else 1 - CurrentAimValue
        local v8 = arg6.Crosshair:GetAppearanceSpacing()
        local v9 = (v8 + 8 * (v6 / CONSTANTS_m.BASE_WALKSPEED) ^ 2 + 32 * Value_1 + 100 * CurrentRecoilValue.Magnitude / v2) * Value / v2
        local v10 = if arg8.IsFirstPerson then if arg6.Mouse.ItemInterface.ClientItem.Name == "Minigun" then 0 else v3 and 1 - v7 or 0 else 0
        v10 += (1 - v10) * (if arg6.Crosshair:ShowWhileInspecting() then 0 else CurrentInspectValue)
        arg6.Crosshair:SetSpacing(v9, v7)
        arg6.Crosshair:SetTransparency(v10)
    end

    local Value_2 = arg6._hitmarker_spring.Value
    local v14 = 32 + -26 * Value_2
    local v15 = 16 + -8 * Value_2
    local udim2 = UDim2.new(0, v15, 0, v15)
    v7 = tick()
    local v18 = math.min(1, (v7 - arg6._last_damage_dealt_time) / 2) ^ 10
    arg6.Crosshair:SetHitmarkerVisuals(v14, udim2, v18, (1 - Value_2) * arg6._hitmarker_rotation)
end

function t.Destroy(arg10) -- line: 105
    arg10.Crosshair:Destroy()
end

function t._Setup(arg11) -- line: 113
    arg11.Crosshair:SetType(arg11.Mouse.ItemInterface.ClientItem.Info.CrosshairType)
    arg11.Crosshair:SetParent(arg11.Mouse.Frame)
end

function t._Init(arg12) -- line: 118
    arg12:_Setup()
end

return t
