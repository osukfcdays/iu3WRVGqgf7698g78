local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local SoundLibrary_m = require(ReplicatedStorage.Modules.SoundLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local StaticCharacterModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticCharacterModel
)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.StaticModel.StaticViewModel
)
local cframe = CFrame.new(0, 0, 30)
local v2 = CFrame.new(0, -6, -6) * CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.Angles(
    0.17453292519943295,
    0,
    0
)
local v4 = CFrame.new(0, 0, -6) * CFrame.Angles(0, 2.356194490192345, 0) * CFrame.Angles(
    0.3490658503988659,
    0,
    0
)
local v6 = CFrame.new(0, -10, -10) * CFrame.Angles(0, 2.356194490192345, 0) * CFrame.Angles(
    -0.7853981633974483,
    0,
    0
)
local t = {}
local v7 = CFrame.new(0, 0, -10) * CFrame.Angles(0, 3.490658503988659, 0)
t.__index = t

function t.new(arg1) -- line: 22
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.CharmAttachmentVisibleChanged = Signal_m.new()
    t_1.Equipment = arg1
    t_1._last_generate_state = nil
    t_1._last_offset_state = nil
    t_1._static_viewmodel = nil
    t_1._static_charactermodel = nil
    t_1._last_equip_sound = nil
    t_1._offset_alpha_spring = Spring_m.new(1, 0.875, 10)
    t_1:_Init()

    return t_1
end

function t.GetBoundingBox(arg2) -- line: 45
    if arg2._static_viewmodel then
        return arg2._static_viewmodel:GetBoundingBox()
    end
end

function t.GetCharmPivotAttachment(arg3) -- line: 51
    local v8 = arg3._static_viewmodel

    if v8 then
        v8 = arg3._static_viewmodel:GetCharmPivotAttachment()
    end

    return v8
end

function t.Update(arg4, arg5) -- line: 55
    -- upvalues:
    --  [1] v2 (copy)
    --  [2] v4 (copy)
    --  [3] v6 (copy)
    --  [4] v7 (copy)

    arg4:_UpdateStaticModel(arg5, arg4._static_viewmodel, v2, v4)
    arg4:_UpdateStaticModel(arg5, arg4._static_charactermodel, v6, v7)
end

function t.OnOpen(arg6) -- line: 60
    arg6:_Generate()
end

function t.OnCustomizingStateChanged(arg7) -- line: 64
    arg7:_Generate()
    arg7:_UpdateViewModel()
end

function t.OnStateChanged(arg8) -- line: 69
    arg8:_CheckOffsetAnimation()
    arg8:_Generate()
end

function t._GetSelectedCosmeticOverride(arg9, arg10) -- line: 78
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] Utility_m (copy)

    local v9 = arg9.Equipment:GetSelectedCosmetic()
    local v10 = CosmeticLibrary_m.Cosmetics[v9]

    if not v10 or v10.Type ~= arg10 then
        return
    end

    local CosmeticInverted = arg9.Equipment.EquipmentState.CosmeticInverted
    local v12 = PlayerDataController_m:GetWeaponData(arg9.Equipment:GetSelectedWeapon())
    local v13 = v12

    if v13 then
        v13 = v12[arg10]
    end

    local v16 = Utility_m:CloneTable(v13 or {})
    v16.Name = v9
    v16.Inverted = if arg10 == "Wrap" and CosmeticInverted ~= nil then CosmeticInverted else v16.Inverted

    return v16
end

function t._GetViewModelName(arg11) -- line: 97
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    local v17 = arg11.Equipment:GetSelectedWeapon()
    local v18 = PlayerDataController_m:GetWeaponData(v17)
    local v19 = arg11:_GetSelectedCosmeticOverride("Skin")

    return v19 and v19.Name or (if not v18 then v17 else if not v18.Skin then v17 else if v18.Skin.Name == "RANDOM_COSMETIC" then v17 else v18.Skin.Name or v17)
end

function t._CheckOffsetAnimation(arg12) -- line: 108
    local v21 = arg12.Equipment:GetStateID(true)

    if v21 == arg12._last_offset_state then
        return
    end

    arg12._last_offset_state = v21
    arg12._offset_alpha_spring.Value = 0
end

function t._UpdateStaticModel(
    arg13,
    arg14,
    arg15,
    arg16,
    arg17
) -- line: 119
    -- upvalues:
    --  [1] cframe (copy)

    if not arg15 then
        return
    end

    local v23 = arg13.Equipment.Scene:GetCFrame() * cframe * arg16:Lerp(
        arg17,
        arg13._offset_alpha_spring.Value
    )
    local v24 = arg13.Equipment:GetCustomizingType()
    v24 = if not (if v24 ~= "Finisher" then if v24 ~= "Emote" then false else true else true) then Vector3.new(0, 0, 0) else Vector3.new(0, -25, 0)
    arg15:PivotTo(
        CFrame.new(v23.Position) * arg13.Equipment.SpinControls:GetCFrame() * v23.Rotation + v24
    )
    arg15:Update(arg14)
end

function t._PlayEquipSound(arg18) -- line: 140
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] SoundLibrary_m (copy)

    task.defer(function() -- line: 142
        -- upvalues:
        --  [1] arg18 (copy)
        --  [2] Utility_m (ref)
        --  [3] SoundLibrary_m (ref)

        if not arg18.Equipment.IsOpen or not arg18.Equipment.Camera:IsOpenEffectDone() then
            return
        end

        if arg18._last_equip_sound then
            arg18._last_equip_sound:Destroy()
            arg18._last_equip_sound = nil
        end

        arg18._last_equip_sound = Utility_m:CreateSound(
            SoundLibrary_m.EquipSounds[math.random(#SoundLibrary_m.EquipSounds)],
            0.5,
            0.9 + 0.2 * math.random(),
            script,
            true,
            5
        )
    end)
end

function t._UpdateViewModel(arg19) -- line: 156
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    if not arg19._static_viewmodel or not arg19.Equipment.IsOpen then
        return
    end

    local v31 = PlayerDataController_m:GetWeaponData(arg19._static_viewmodel.WeaponName)
    local v32 = arg19:_GetSelectedCosmeticOverride("Charm")
    local v33 = arg19:_GetSelectedCosmeticOverride("Wrap")
    arg19._static_viewmodel:SetLocked(not v31)
    local v34 = v32
    local StaticViewmodel = arg19._static_viewmodel

    if not v34 then
        v34 = if not v31 then nil else if not v31.Charm then nil else if v31.Charm.Name == "RANDOM_COSMETIC" then nil else v31.Charm or nil
    end

    StaticViewmodel:SetCharm(v34)
    v34 = v33
    local StaticViewmodel_1 = arg19._static_viewmodel

    if not v34 then
        v34 = if not v31 then nil else if not v31.Wrap then nil else if v31.Wrap.Name == "RANDOM_COSMETIC" then nil else v31.Wrap or nil
    end

    StaticViewmodel_1:SetWrap(v34)
end

function t._GenerateViewModel(arg20) -- line: 170
    -- upvalues:
    --  [1] StaticViewModel_m (copy)

    if arg20._static_viewmodel then
        arg20._static_viewmodel:Destroy()
        arg20._static_viewmodel = nil
    end

    local v35 = arg20:_GetViewModelName()

    if not v35 or not arg20.Equipment.IsOpen then
        return
    end

    arg20._static_viewmodel = StaticViewModel_m.new(v35)
    arg20._static_viewmodel:DeleteAnimationContextSubModels("ShowInEquipment")
    arg20._static_viewmodel:SetParent(workspace)
    arg20:_UpdateForcedVisibleCharmAttachment()
    arg20:_UpdateViewModel()
    arg20:_PlayEquipSound()
end

function t._GenerateCharacterModel(arg21) -- line: 191
    -- upvalues:
    --  [1] StaticCharacterModel_m (copy)
    --  [2] Players (copy)

    if arg21._static_charactermodel then
        arg21._static_charactermodel:Destroy()
        arg21._static_charactermodel = nil
    end

    if not arg21.Equipment:IsCareerPageOpen() or not arg21.Equipment.IsOpen then
        return
    end

    arg21._static_charactermodel = StaticCharacterModel_m.new(Players.LocalPlayer.UserId)
    arg21._static_charactermodel:SetParent(workspace)
    arg21:_PlayEquipSound()
end

function t._Generate(arg22) -- line: 207
    if not arg22.Equipment.IsOpen then
        if arg22._static_viewmodel then
            arg22._static_viewmodel:Destroy()
            arg22._static_viewmodel = nil
        end

        if arg22._static_charactermodel then
            arg22._static_charactermodel:Destroy()
            arg22._static_charactermodel = nil
        end

        arg22._last_generate_state = nil

        return
    end

    local v36 = arg22:_GetViewModelName()
    local v39 = arg22.Equipment:GetStateID(true) .. tostring(v36)

    if v39 == arg22._last_generate_state then
        return
    end

    arg22._last_generate_state = v39
    arg22:_GenerateViewModel()
    arg22:_GenerateCharacterModel()
    arg22:Update(0)
end

function t._UpdateForcedVisibleCharmAttachment(arg23) -- line: 237
    if not arg23._static_viewmodel then
        return
    end

    arg23._static_viewmodel:ForceCharmAttachmentModelVisible(
        if arg23.Equipment:GetCustomizingType() ~= "Charm" then false else true
    )
    arg23.CharmAttachmentVisibleChanged:Fire()
end

function t._Init(arg24) -- line: 246
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    arg24.Equipment.CustomizingChanged:Connect(function() -- line: 247
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_UpdateForcedVisibleCharmAttachment()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 251
        -- upvalues:
        --  [1] arg24 (copy)

        arg24:_Generate()
        arg24:_UpdateViewModel()
    end)
    arg24:_Generate()
    arg24:_UpdateForcedVisibleCharmAttachment()
end

return t
