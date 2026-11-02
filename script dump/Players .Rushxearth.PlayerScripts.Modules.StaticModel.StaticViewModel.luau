local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local StaticModel_m = require(Players.LocalPlayer.PlayerScripts.Modules.StaticModel)
local Charm_m = require(Players.LocalPlayer.PlayerScripts.Modules.Charm)
local Charms = Players.LocalPlayer.PlayerScripts.Modules.Charms
local ViewModels = Players.LocalPlayer.PlayerScripts.Assets.ViewModels
local t = setmetatable({}, StaticModel_m)
t.__index = t

function t.new(arg1, _) -- line: 18
    -- upvalues:
    --  [1] StaticModel_m (copy)
    --  [2] Utility_m (copy)
    --  [3] ViewModels (copy)
    --  [4] t (copy)
    --  [5] CosmeticLibrary_m (copy)
    --  [6] ItemLibrary_m (copy)

    local t_1 = setmetatable(StaticModel_m.new(Utility_m:LookThrough(ViewModels, arg1):Clone()), t)
    t_1.Name = arg1
    t_1.WeaponName = CosmeticLibrary_m.Cosmetics[t_1.Name] and CosmeticLibrary_m.Cosmetics[t_1.Name].ItemName or ItemLibrary_m.Items[t_1.Name] and t_1.Name or nil
    t_1.Charm = nil
    t_1.Wrap = nil
    t_1._submodel_to_grip_attachment = {}
    t_1._grip_attachment_to_limb = {}
    t_1._charm_scale_multiplier = 1
    t_1._charm_attachment_model = t_1.Model:FindFirstChild("_charm_attachment_model", true)
    local v3 = t_1._charm_attachment_model

    if v3 then
        v3 = t_1._charm_attachment_model.Parent
    end

    t_1._charm_attachment_model_parent = v3
    v3 = t_1._charm_attachment_model and t_1._charm_attachment_model:FindFirstChild(
        "_charm_pivot_attachment",
        true
    ) or t_1.Model:FindFirstChild("_charm_pivot_attachment", true)
    t_1._charm_pivot_attachment = v3
    t_1._original_wrap_properties = {}
    t_1._wrapped_only_objects = {}
    t_1._is_locked = false
    t_1._locked_original_properties = {}
    t_1._weld_data = {}
    t_1._fake_model = t_1.Model:FindFirstChild("_fake")
    t_1:_Init()

    return t_1
end

function t.GetCharmPivotAttachment(arg3) -- line: 48
    return arg3._charm_pivot_attachment
end

function t.GetPivot(arg4) -- line: 52
    return arg4.Model:GetPivot()
end

function t.GetBoundingBox(arg5) -- line: 56
    return arg5.Model:GetBoundingBox()
end

function t.IsLocked(arg6) -- line: 60
    return arg6._is_locked
end

function t.HasGripAttachment(arg7) -- line: 64
    return arg7.Model:FindFirstChild("_grip", true)
end

function t.DeleteAnimationContextSubModels(arg8, arg9) -- line: 68
    local t_2 = {}

    for key, _ in pairs(arg8._submodel_to_grip_attachment) do
        if key:GetAttribute("AnimationContexts") and (not arg9 or not key:GetAttribute(arg9)) then
            key:Destroy()
            table.insert(t_2, key)
        end
    end

    for _, val_1 in pairs(t_2) do
        arg8._submodel_to_grip_attachment[val_1] = nil
    end
end

function t.ForceCharmAttachmentModelVisible(arg10, arg11) -- line: 89
    arg10._is_charm_attachment_model_forced_visible = arg11
    arg10:_UpdateCharmAttachmentModelVisibility()
end

function t.SetParent(arg12, arg13) -- line: 94
    arg12.Model.Parent = arg13

    if arg12.Charm then
        arg12.Charm:SetParent(arg13)
    end
end

function t.SetLocked(arg14, arg15) -- line: 102
    if arg15 == arg14._is_locked then
        return
    end

    arg14._is_locked = arg15

    if arg14._is_locked then
        arg14:_Lock()
    else
        arg14:_Unlock()
    end

    arg14:_UpdateWrap()
end

function t.SetCharm(arg16, arg17) -- line: 118
    -- upvalues:
    --  [1] Charms (copy)
    --  [2] Charm_m (copy)

    if arg16.Charm then
        arg16.Charm:Destroy()
        arg16.Charm = nil
    end

    if not arg17 or not arg16._charm_pivot_attachment then
        arg16:_UpdateCharmAttachmentModelVisibility()

        return
    end

    local v4 = Charms:FindFirstChild(arg17.Name, true)
    local v5 = v4 and require(v4) or Charm_m
    arg16.Charm = v5.new(nil, arg17, arg16._charm_pivot_attachment)
    arg16.Charm:ScaleTo(
        arg16.Model:GetScale() / arg16._original_scale * arg16._charm_scale_multiplier
    )
    arg16.Charm:SetParent(arg16.Model.Parent)
    arg16:_UpdateCharmAttachmentModelVisibility()
end

function t.SetWrap(arg18, arg19) -- line: 138
    arg18.Wrap = arg19
    arg18:_UpdateWrap()
end

function t.BreakWeld(arg20) -- line: 143
    for key_2, _ in pairs(arg20._weld_data) do
        key_2.Anchored = true
    end

    for _, val_3 in pairs(arg20._weld_data) do
        val_3:Destroy()
    end

    arg20._weld_data = {}
end

function t.WeldTo(arg21, arg22) -- line: 155
    arg21:BreakWeld()
    local v7 = pairs
    local Model = arg21.Model
    local v8 = arg21.Charm and arg21.Charm.Model or nil

    for _, val_4 in v7({ Model, v8 }) do
        for _, val_5 in pairs(val_4:GetDescendants()) do
            if val_5:IsA("BasePart") then
                local WeldConstraint = Instance.new("WeldConstraint")
                WeldConstraint.Part1 = arg22
                WeldConstraint.Part0 = val_5
                WeldConstraint.Parent = val_5
                arg21._weld_data[val_5] = WeldConstraint
            end
        end
    end

    for key_6, _ in pairs(arg21._weld_data) do
        key_6.Massless = true
        key_6.Anchored = false
    end
end

function t.ScaleTo(arg23, arg24, arg25) -- line: 180
    -- upvalues:
    --  [1] StaticModel_m (copy)

    local t_4 = {}

    for _, val_7 in pairs(arg23._submodel_to_grip_attachment) do
        t_4[val_7] = val_7.CFrame
    end

    StaticModel_m.ScaleTo(arg23, arg24)

    for _, val_8 in pairs(arg23._submodel_to_grip_attachment) do
        val_8.CFrame = t_4[val_8]
    end

    arg23._charm_scale_multiplier = arg25 or 1

    if arg23.Charm then
        arg23.Charm:ScaleTo(arg24 * arg23._charm_scale_multiplier)
    end
end

function t.PivotTo(arg26, arg27, arg28) -- line: 200
    -- upvalues:
    --  [1] StaticModel_m (copy)

    local v11 = arg28

    if v11 then
        v11 = arg26.Model:FindFirstChild(arg28, true)
    end

    local v12 = v11 and v11.WorldCFrame
    arg26:_ParentWrappedOnlyObjects(true)
    StaticModel_m.PivotTo(arg26, arg27, v12)
    arg26:_ParentWrappedOnlyObjects(arg26:_WrapExists())
end

function t.InitializeGrip(arg29) -- line: 209
    if arg29._fake_model then
        task.defer(arg29._fake_model.Destroy, arg29._fake_model)
        arg29._fake_model = nil
    end

    for _, child in pairs(arg29.Model:GetChildren()) do
        child.WorldPivot = arg29._submodel_to_grip_attachment[child].WorldCFrame
    end
end

function t.GripPivotTo(arg30, arg31) -- line: 220
    for _, child_1 in pairs(arg30.Model:GetChildren()) do
        child_1:PivotTo(
            arg31[arg30._grip_attachment_to_limb[arg30._submodel_to_grip_attachment[child_1]]].CFrame
        )
    end

    arg30:Update(0)
end

function t.Update(arg32, arg33) -- line: 233
    -- upvalues:
    --  [1] StaticModel_m (copy)

    StaticModel_m.Update(arg32, arg33)

    if arg32.Charm then
        arg32.Charm:Update(arg33)
    end
end

function t.Destroy(arg34) -- line: 241
    -- upvalues:
    --  [1] StaticModel_m (copy)

    if arg34.Charm then
        arg34.Charm:Destroy()
    end

    StaticModel_m.Destroy(arg34)
end

function t._GetWrappedOnlyObjectByName(arg35, arg36) -- line: 253
    for key_11, _ in pairs(arg35._wrapped_only_objects) do
        if key_11.Name == arg36 then
            return key_11
        end
    end
end

function t._WrapExists(arg37) -- line: 261
    return arg37.Wrap and arg37.Wrap.Name ~= "RANDOM_COSMETIC"
end

function t._ParentWrappedOnlyObjects(arg38, arg39) -- line: 265
    for key_12, val_10 in pairs(arg38._wrapped_only_objects) do
        local v16 = arg39 and val_10 or nil
        key_12.Parent = v16
    end
end

function t._UpdateWrap(arg40) -- line: 271
    -- upvalues:
    --  [1] WrapController_m (copy)

    if arg40._is_locked then
        return
    end

    WrapController_m:ApplyWrap(arg40._original_wrap_properties, arg40.Wrap)
    arg40:_UpdateCharmAttachmentModelVisibility()

    if arg40._fake_model then
        local v17 = arg40:_WrapExists()
        local v18 = v17

        if v18 then
            v18 = arg40:_GetWrappedOnlyObjectByName("LeftArmWrapped")
        end

        local v19 = v17

        if v19 then
            v19 = arg40:_GetWrappedOnlyObjectByName("RightArmWrapped")
        end

        if arg40._fake_model:FindFirstChild("LeftArm") then
            local v20 = if not v18 then 0 else 1
            arg40._fake_model.LeftArm.Transparency = v20
            v20 = if not v18 then 0 else 1
            arg40._fake_model.LeftArm.ShirtTexture.Transparency = v20
        end

        if arg40._fake_model:FindFirstChild("RightArm") then
            arg40._fake_model.RightArm.Transparency = if not v19 then 0 else 1
            arg40._fake_model.RightArm.ShirtTexture.Transparency = if not v19 then 0 else 1
        end

        arg40:_ParentWrappedOnlyObjects(v17)
    end
end

function t._UpdateCharmAttachmentModelVisibility(arg41) -- line: 298
    local v21 = if arg41.Charm then 0 else if not arg41._is_charm_attachment_model_forced_visible then 1 else 0
    local v22 = pairs
    local v23 = arg41._charm_attachment_model and arg41._charm_attachment_model:GetDescendants() or {}

    for _, val_11 in v22(v23) do
        if val_11:IsA("BasePart") or val_11:IsA("Texture") then
            val_11.LocalTransparencyModifier = v21
        end
    end
end

function t._Unlock(arg42) -- line: 308
    for key_14, val_12 in pairs(arg42._locked_original_properties) do
        for key_15, val_13 in pairs(val_12) do
            key_14[key_15] = val_13
        end
    end

    arg42._locked_original_properties = {}
end

function t._Lock(arg43) -- line: 318
    local function check(arg44) -- line: 319
        -- upvalues:
        --  [1] arg43 (copy)

        if arg43._locked_original_properties[arg44] then
            return
        end

        local t_5 = {}

        if arg44:IsA("BasePart") then
            t_5.Color = arg44.Color
            arg44.Color = Color3.fromRGB(31, 31, 31)
            t_5.Material = arg44.Material
            arg44.Material = Enum.Material.Neon

            if arg44:IsA("MeshPart") then
                t_5.TextureID = arg44.TextureID
                arg44.TextureID = ""
            end
        elseif arg44:IsA("Beam") or arg44:IsA("Trail") or arg44:IsA("ParticleEmitter") then
            t_5.Color = arg44.Color
            arg44.Color = ColorSequence.new(Color3.fromRGB(31, 31, 31))

            if arg44:IsA("ParticleEmitter") or arg44:IsA("Beam") then
                t_5.Brightness = arg44.Brightness
                arg44.Brightness = 1
                t_5.LightEmission = arg44.LightEmission
                arg44.LightEmission = 0
                t_5.LightInfluence = arg44.LightInfluence
                arg44.LightInfluence = 0
            end
        end

        arg43._locked_original_properties[arg44] = t_5
    end

    for _, val_14 in pairs({ arg43.Model, arg43._charm_attachment_model }) do
        check(val_14)

        for _, val_15 in pairs(val_14:GetDescendants()) do
            check(val_15)
        end
    end
end

function t._Setup(arg45) -- line: 365
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] WrapController_m (copy)
    --  [3] Utility_m (copy)
    --  [4] Players (copy)

    if CosmeticLibrary_m.IGNORE_TRANSPARENCY_WHITELIST[arg45.WeaponName] then
        for _, val_16 in pairs(arg45.Model:GetDescendants()) do
            if val_16:IsA("BasePart") then
                val_16:SetAttribute("IgnoreTransparency", true)
            end
        end
    end

    local v26 = nil

    for _, child_2 in pairs(arg45.Model:GetChildren()) do
        child_2.PrimaryPart = nil

        for _, val_17 in pairs(child_2:GetDescendants()) do
            if val_17:IsA("BasePart") then
                val_17.CastShadow = true
                val_17.CanCollide = false
                val_17.CanTouch = false
                val_17.CanQuery = false
                val_17.Massless = true
                val_17.Anchored = true
                val_17.AudioCanCollide = false
            end
        end

        local Grip = child_2:FindFirstChild("_grip", true)
        local v29 = if not Grip then nil else Grip:GetAttribute("GripTarget") or "RightHand"

        if Grip then
            Grip:SetAttribute("GripTarget", v29)
            arg45._grip_attachment_to_limb[Grip] = v29
            arg45._submodel_to_grip_attachment[child_2] = Grip

            if v29 == "RightHand" then
                v26 = Grip
            end
        end
    end

    for _, child_3 in pairs(arg45.Model:GetChildren()) do
        arg45._submodel_to_grip_attachment[child_3] = arg45._submodel_to_grip_attachment[child_3] or v26
    end

    arg45.Model.PrimaryPart = nil
    arg45.Model.WorldPivot = arg45.Model:FindFirstChild("_center", true).WorldCFrame
    arg45._original_wrap_properties = WrapController_m:RecordOriginalWrapProperties(arg45.Model)

    if arg45._fake_model then
        v26 = arg45._fake_model:FindFirstChild("RightArmWrapped")
        local LeftArmWrapped = arg45._fake_model:FindFirstChild("LeftArmWrapped")
        local v31, v32, v33 = Utility_m:GetArmsData(Players.LocalPlayer.Character)

        if v26 then
            arg45._wrapped_only_objects[v26] = arg45._fake_model
        end

        if LeftArmWrapped then
            arg45._wrapped_only_objects[LeftArmWrapped] = arg45._fake_model
        end

        if v31 and v32 and v33 then
            if arg45.Model._fake:FindFirstChild("LeftArm") then
                arg45._fake_model.LeftArm.ShirtTexture.Texture = v31
                arg45._fake_model.LeftArm.Color = v32
            end

            if arg45.Model._fake:FindFirstChild("RightArm") then
                arg45._fake_model.RightArm.ShirtTexture.Texture = v31
                arg45._fake_model.RightArm.Color = v33
            end

            if v26 then
                v26.Color = v33
            end

            if LeftArmWrapped then
                LeftArmWrapped.Color = v32
            end

            for _, val_18 in pairs(arg45.Model:GetDescendants()) do
                if val_18:GetAttribute("IsRightHand") then
                    val_18.Color = v33
                elseif val_18:GetAttribute("IsLeftHand") then
                    val_18.Color = v32
                end
            end

            arg45._original_wrap_properties = WrapController_m:RecordOriginalWrapProperties(
                arg45.Model
            )
        end
    end

    if arg45.Name == "Chainsaw" or arg45.Name == "Blobsaw" then
        arg45.Model.Body.Spikes2:Destroy()

        return
    end

    if arg45.Name == "Handsaws" then
        arg45.Model.RightBlade.Spikes2:Destroy()
        arg45.Model.LeftBlade.Spikes2:Destroy()

        return
    end

    if arg45.Name == "Street Sign" then
        local randomValue = math.random(1, 3)

        if randomValue ~= 1 then
            arg45.Model.Body["Sign" .. 1]:Destroy()
        end

        if randomValue ~= 2 then
            arg45.Model.Body["Sign" .. 2]:Destroy()
        end

        if randomValue ~= 3 then
            arg45.Model.Body["Sign" .. 3]:Destroy()

            return
        end
    elseif arg45.Name == "Jeremiah" then
        arg45.Model.Body.Eyelids:Destroy()
    end
end

function t._Init(arg46) -- line: 482
    arg46:_Setup()
    arg46:SetLocked(false)
    arg46:SetCharm(nil)
    arg46:SetWrap(nil)
end

return t
