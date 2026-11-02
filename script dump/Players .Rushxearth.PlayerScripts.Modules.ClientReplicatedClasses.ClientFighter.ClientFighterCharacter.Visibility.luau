local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local t = { "HitboxHead", "HitboxBody", "HitboxHeadSmall", "HitboxBodySmall" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.ClientFighterCharacter = arg1
    t_2._destroyed = false
    t_2._original_properties = {}
    t_2._is_translucent = false
    t_2._update_debounce = false
    t_2._hitboxes_visible = nil
    t_2._update_hitboxes_check = false
    t_2:_Init()

    return t_2
end

function t_1.SetTranslucent(arg2, arg3) -- line: 34
    if arg3 == arg2._is_translucent then
        return
    end

    arg2._is_translucent = arg3
    arg2:_BulkUpdate()
end

function t_1.SetHitboxesVisible(arg4, arg5) -- line: 43
    arg4._hitboxes_visible = arg5
    arg4:_UpdateHitboxes()
end

function t_1.CloneModel(arg6) -- line: 48
    arg6:_Verify(true, false)
    local Archivable = arg6.ClientFighterCharacter.Model.Archivable
    arg6.ClientFighterCharacter.Model.Archivable = true
    local v1 = arg6.ClientFighterCharacter.Model:Clone()
    arg6.ClientFighterCharacter.Model.Archivable = Archivable
    arg6:_Verify(true, nil)

    return v1
end

function t_1.Update(_, _, _) -- line: 61
end

function t_1.Destroy(arg10) -- line: 65
    arg10._destroyed = true
end

function t_1._GetHeight(arg11) -- line: 73
    local Model = Instance.new("Model")

    for _, child in pairs(arg11.ClientFighterCharacter.Model:GetChildren()) do
        if
            child:IsA("BasePart")
            and child.Transparency < 0.9
            and child.Material ~= Enum.Material.ForceField
        then
            local Part = Instance.new("Part")
            Part.Size = child.ExtentsSize
            Part.CFrame = child.ExtentsCFrame
            Part.Parent = Model
        end
    end

    local _, boundingSize = Model:GetBoundingBox()

    return boundingSize.Y
end

function t_1._UpdateHitboxes(arg12) -- line: 90
    -- upvalues:
    --  [1] t (copy)
    --  [2] Utility_m (copy)

    if arg12._hitboxes_visible == nil then
        return
    end

    arg12._update_hitboxes_check = true
    task.defer(function() -- line: 97
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] t (ref)
        --  [3] Utility_m (ref)

        if not arg12._update_hitboxes_check or arg12._destroyed then
            return
        end

        arg12._update_hitboxes_check = false
        local v3 = arg12._hitboxes_visible

        if v3 then
            v3 = not arg12.ClientFighterCharacter.ClientFighter:IsActuallyFirstPerson()
        end

        local v4 = if not v3 then 1 else 0

        for _, val in pairs(t) do
            Utility_m:SilentWaitForChild(arg12.ClientFighterCharacter.Model, val).Transparency = v4
        end
    end)
end

function t_1._Update(arg13, arg14) -- line: 113
    if not arg13._original_properties[arg14] and not arg13.ClientFighterCharacter:IsAlive() then
        return
    end

    local v5 = arg13.ClientFighterCharacter:IsHidden() or arg13.ClientFighterCharacter.ClientFighter:Get(
        "IsHiddenByEmotes"
    ) or arg13.ClientFighterCharacter.ClientFighter:Get("IsHiddenByCutscene")
    local v6 = arg13._is_translucent or arg13.ClientFighterCharacter:Get("IsTranslucent") and not arg13.ClientFighterCharacter.ClientFighter:Get(
        "IsSpectating"
    )

    if arg14:IsA("BasePart") or arg14:IsA("Decal") or arg14:IsA("Texture") then
        local v7 = arg13._original_properties[arg14]
        local OriginalProperties = arg13._original_properties

        if not v7 then
            v7 = { Transparency = arg14.Transparency }
        end

        OriginalProperties[arg14] = v7
        local Transparency = arg13._original_properties[arg14].Transparency
        v7 = if not v5 then if not v6 then 0 else 0.875 else 1
        arg14.Transparency = Transparency + (1 - Transparency) * v7

        return
    end

    if
        arg14:IsA("ParticleEmitter")
        or arg14:IsA("Fire")
        or arg14:IsA("Sparkles")
        or arg14:IsA("Smoke")
        or arg14:IsA("Trail")
        or arg14:IsA("Beam")
    then
        local v8 = arg13._original_properties[arg14]
        local OriginalProperties_1 = arg13._original_properties

        if not v8 then
            v8 = { Enabled = arg14.Enabled }
        end

        OriginalProperties_1[arg14] = v8
        arg14.Enabled = if v5 then false else if v6 then false else arg13._original_properties[arg14].Enabled

        if not arg14.Enabled and arg14:IsA("ParticleEmitter") then
            arg14:Clear()
        end
    end
end

function t_1._BulkUpdate(arg15) -- line: 142
    -- upvalues:
    --  [1] t (copy)

    for _, descendant in pairs(arg15.ClientFighterCharacter.Model:GetDescendants()) do
        if not table.find(t, descendant.Name) and not descendant:GetAttribute(
            "IgnoreVisibilityCheck"
        ) then
            arg15:_Update(descendant)
        end
    end
end

function t_1._Verify(arg16, arg17, arg18) -- line: 152
    local v11 = arg16.ClientFighterCharacter.ClientFighter:IsActuallyFirstPerson()

    if v11 then
        v11 = arg16.ClientFighterCharacter.ClientFighter:IsActive()
    end

    if not arg17 and v11 == arg16.ClientFighterCharacter:IsHidden() then
        return
    end

    arg16.ClientFighterCharacter:SetHidden(if arg18 == nil then v11 else arg18)
    arg16:_BulkUpdate()
end

function t_1._Init(arg19) -- line: 163
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] PlayerDataController_m (copy)

    arg19.ClientFighterCharacter.EnteredWorld:Connect(function() -- line: 164
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify(true)
        arg19:_UpdateHitboxes()
    end)
    arg19.ClientFighterCharacter.BurnEffectPlaying:Connect(function(arg20) -- line: 169
        -- upvalues:
        --  [1] arg19 (copy)

        for _, val_1 in pairs(arg20) do
            arg19:_Update(val_1)
        end
    end)
    arg19.ClientFighterCharacter.Model.ChildAdded:Connect(function(_) -- line: 175
        -- upvalues:
        --  [1] arg19 (copy)

        if arg19._update_debounce or not arg19.ClientFighterCharacter:IsAlive() then
            return
        end

        arg19._update_debounce = true
        task.defer(function() -- line: 182
            -- upvalues:
            --  [1] arg19 (ref)

            arg19._update_debounce = false
            arg19:_Verify(true)
            arg19:_UpdateHitboxes()
        end)
    end)
    arg19.ClientFighterCharacter:GetDataChangedSignal("IsTranslucent"):Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify()
    end)
    arg19.ClientFighterCharacter:AddConnection(arg19.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsSpectating"
    ):Connect(function() -- line: 193
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify()
        arg19:_UpdateHitboxes()
    end))
    arg19.ClientFighterCharacter:AddConnection(arg19.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsInDuel"
    ):Connect(function() -- line: 198
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify()
    end))
    arg19.ClientFighterCharacter:AddConnection(arg19.ClientFighterCharacter.ClientFighter.ItemAdded:Connect(
        function() -- line: 202
            -- upvalues:
            --  [1] arg19 (copy)

            arg19:_Verify()
            arg19:_UpdateHitboxes()
        end
    ))
    arg19.ClientFighterCharacter:AddConnection(arg19.ClientFighterCharacter.ClientFighter.ItemRemoved:Connect(
        function() -- line: 207
            -- upvalues:
            --  [1] arg19 (copy)

            arg19:_Verify()
            arg19:_UpdateHitboxes()
        end
    ))
    arg19.ClientFighterCharacter:AddConnection(arg19.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsHiddenByEmotes"
    ):Connect(function() -- line: 212
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify(true)
    end))
    arg19.ClientFighterCharacter:AddConnection(arg19.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsHiddenByCutscene"
    ):Connect(function() -- line: 216
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify(true)
    end))
    arg19.ClientFighterCharacter:AddConnection(CameraController_m.StateChanged:Connect(function() -- line: 220
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_Verify()
        arg19:_UpdateHitboxes()
    end))
    arg19.ClientFighterCharacter:AddConnection(PlayerDataController_m:GetSettingChangedSignal(
        "Player Hitboxes"
    ):Connect(function() -- line: 225
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_UpdateHitboxes()
    end))
    arg19:_Verify(true)
    arg19:_UpdateHitboxes()
end

return t_1
