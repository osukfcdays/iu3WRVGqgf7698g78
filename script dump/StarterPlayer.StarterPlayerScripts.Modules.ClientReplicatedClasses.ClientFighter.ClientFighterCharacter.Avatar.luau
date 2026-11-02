local Players = game:GetService("Players")
local DebugState_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local DefaultHeadMesh = Players.LocalPlayer.PlayerScripts.Assets.Misc.DefaultHeadMesh
local t = { "rbxassetid://6686307858", "https://assetdelivery.roblox.com/v1/asset/?id=16673245747" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] DefaultHeadMesh (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.ClientFighterCharacter = arg1
    t_2._neck_rig_attachment = nil
    t_2._hat_attachment = nil
    t_2._is_head_too_big = nil
    t_2._is_custom_head_blacklisted = nil
    t_2._default_head_mesh = DefaultHeadMesh:Clone()
    t_2._default_head_face = t_2._default_head_mesh.Decal
    t_2._default_head_weld = nil
    t_2._accessory_meshes = {}
    t_2._already_checked_accessory = {}
    t_2._deleted_face_controls = false
    t_2._is_translucent = false
    t_2:_Init()

    return t_2
end

function t_1.SetTranslucent(arg2, arg3) -- line: 41
    if arg3 == arg2._is_translucent then
        return
    end

    arg2._is_translucent = arg3
    arg2:_UpdateDefaultHead()
end

function t_1.Update(_, _, _) -- line: 50
end

function t_1.Destroy(arg7) -- line: 54
    arg7._default_head_mesh:Destroy()
end

function t_1._IsLocalPlayer(arg8) -- line: 62
    return arg8.ClientFighterCharacter.ClientFighter.IsLocalPlayer
end

function t_1._IsInTransparencyContext(arg9) -- line: 70
    -- upvalues:
    --  [1] DebugState_m (copy)

    local v1 = not arg9:_IsLocalPlayer()

    if v1 then
        v1 = arg9.ClientFighterCharacter.ClientFighter:Get("IsInDuel")

        if v1 then
            v1 = not DebugState_m:Get("DisableTransparentHats")
        end
    end

    return v1
end

function t_1._IsHeadSizeDimensionTooBig(arg10, arg11) -- line: 78
    return math.abs(arg11 / (arg10.ClientFighterCharacter:Get("Scale") or 1) - 1) > 0.25 and true
end

function t_1._DeleteFaceControls(arg12) -- line: 82
    if
        arg12._deleted_face_controls
        or not arg12.ClientFighterCharacter.ClientFighter:Get("IsInDuel")
    then
        return
    end

    arg12._deleted_face_controls = true
    task.spawn(function() -- line: 89
        -- upvalues:
        --  [1] arg12 (copy)

        local FaceControls

        while true do
            FaceControls = arg12.ClientFighterCharacter.Head:FindFirstChildOfClass("FaceControls")

            if FaceControls then
                break
            end

            arg12.ClientFighterCharacter.Head.ChildAdded:Wait()
        end

        task.defer(FaceControls.Destroy, FaceControls)
    end)
end

function t_1._UpdateDefaultHead(arg13) -- line: 106
    -- upvalues:
    --  [1] DefaultHeadMesh (copy)

    if not arg13.ClientFighterCharacter:IsAlive() then
        return
    end

    if
        arg13._is_translucent
        or arg13.ClientFighterCharacter.ClientFighter:Get("IsHiddenByEmotes")
        or arg13.ClientFighterCharacter.ClientFighter:Get("IsHiddenByCutscene")
    then
        arg13._default_head_mesh.Transparency = 1
        arg13._default_head_face.Transparency = 1

        return
    end

    local v3 = arg13:_IsInTransparencyContext()

    if v3 then
        v3 = arg13._is_custom_head_blacklisted or arg13:_IsHeadSizeDimensionTooBig(
            arg13.ClientFighterCharacter.Head.Size.X
        ) or arg13:_IsHeadSizeDimensionTooBig(arg13.ClientFighterCharacter.Head.Size.Y) or arg13:_IsHeadSizeDimensionTooBig(
            arg13.ClientFighterCharacter.Head.Size.Z
        ) or arg13:_IsHeadSizeDimensionTooBig(
            (math.abs(
                arg13._hat_attachment.WorldPosition.Y - arg13._neck_rig_attachment.WorldPosition.Y
            ))
        )
    end

    local v4 = if v3 ~= arg13._is_head_too_big then false else true

    if v4 then
    end

    arg13._is_head_too_big = v3
    v3 = arg13.ClientFighterCharacter.ClientFighter:IsActuallyFirstPerson()
    arg13.ClientFighterCharacter.Head.LocalTransparencyModifier = if v3 then 1 else if not arg13._is_head_too_big then 0 else 1
    local DefaultHeadMesh_1 = arg13._default_head_mesh
    DefaultHeadMesh_1.Transparency = if not v3 then if not arg13._is_head_too_big then 1 else 0 else 1
    arg13._default_head_face.Transparency = arg13._default_head_mesh.Transparency
    arg13._default_head_weld.Enabled = false
    arg13._default_head_mesh.Size = DefaultHeadMesh.Size * (arg13.ClientFighterCharacter:Get(
        "Scale"
    ) or 1)
    arg13._default_head_mesh.CFrame = arg13._neck_rig_attachment.WorldCFrame * CFrame.new(
        0,
        arg13._default_head_mesh.Size.Y / 2,
        0
    )
    arg13._default_head_weld.Enabled = true

    if not v4 then
        arg13:_BulkUpdateAccessoryMeshes()
    end
end

function t_1._BulkUpdateAccessoryMeshes(arg14) -- line: 146
    for key, _ in pairs(arg14._accessory_meshes) do
        arg14:_UpdateAccessoryMesh(key)
    end
end

function t_1._UpdateAccessoryMesh(arg15, arg16) -- line: 152
    local v6 = arg15._accessory_meshes[arg16]

    if not v6 then
        return
    end

    local v7 = 3 * (arg15.ClientFighterCharacter:Get("Scale") or 1)
    local v8 = if not (v7 < arg16.Size.X) then v7 < arg16.Size.Y or v7 < arg16.Size.Z else true
    arg16.Transparency = v6.OriginalTransparency + (1 - v6.OriginalTransparency) * (if arg15._is_head_too_big and not arg15._is_custom_head_blacklisted then 0.875 else if v8 and arg15:_IsInTransparencyContext() then 0.875 else 0)
end

function t_1._AccessoryMeshAdded(arg17, arg18) -- line: 168
    if not arg18:IsA("BasePart") then
        return
    end

    local v9 = arg17._accessory_meshes[arg18]
    local AccessoryMeshes = arg17._accessory_meshes

    if not v9 then
        v9 = { OriginalTransparency = arg18.Transparency }
    end

    AccessoryMeshes[arg18] = v9
    arg18:GetPropertyChangedSignal("Size"):Connect(function() -- line: 175
        -- upvalues:
        --  [1] arg17 (copy)
        --  [2] arg18 (copy)

        arg17:_UpdateAccessoryMesh(arg18)
    end)
    arg17:_UpdateAccessoryMesh(arg18)
end

function t_1._AccessoryAdded(arg19, arg20) -- line: 182
    if
        not arg20:IsA("Accessory")
        or arg19._already_checked_accessory[arg20]
        or arg19:_IsLocalPlayer()
    then
        return
    end

    arg19._already_checked_accessory[arg20] = true
    arg20.ChildAdded:Connect(function(child: Instance) -- line: 193
        -- upvalues:
        --  [1] arg19 (copy)

        arg19:_AccessoryMeshAdded(child)
    end)

    for _, val_1 in pairs(arg20:GetChildren()) do
        arg19:_AccessoryMeshAdded(val_1)
    end
end

function t_1._SetupAsync(arg22) -- line: 202
    -- upvalues:
    --  [1] t (copy)
    --  [2] DebugState_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] SpectateController_m (copy)

    arg22.ClientFighterCharacter:WaitUntilIsInWorld()
    arg22._neck_rig_attachment = arg22.ClientFighterCharacter.Head:WaitForChild("NeckRigAttachment")
    arg22._hat_attachment = arg22.ClientFighterCharacter.Head:WaitForChild("HatAttachment")
    arg22._is_custom_head_blacklisted = table.find(t, arg22.ClientFighterCharacter.Head.MeshId)
    arg22._default_head_mesh.Color = arg22.ClientFighterCharacter.Head.Color
    arg22._default_head_mesh.Parent = arg22.ClientFighterCharacter.Head
    arg22._default_head_weld = Instance.new("WeldConstraint")
    arg22._default_head_weld.Part0 = arg22.ClientFighterCharacter.Head
    arg22._default_head_weld.Part1 = arg22._default_head_mesh
    arg22._default_head_weld.Parent = arg22._default_head_mesh
    arg22.ClientFighterCharacter:GetDataChangedSignal("Scale"):Connect(function() -- line: 218
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end)
    arg22.ClientFighterCharacter.Head:GetPropertyChangedSignal("Size"):Connect(function() -- line: 222
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end)
    arg22.ClientFighterCharacter.Head:GetPropertyChangedSignal("Transparency"):Connect(function() -- line: 226
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end)
    arg22.ClientFighterCharacter.Head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(
        function() -- line: 230
            -- upvalues:
            --  [1] arg22 (copy)

            arg22:_UpdateDefaultHead()
        end
    )
    arg22._default_head_mesh:GetPropertyChangedSignal("Transparency"):Connect(function() -- line: 234
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end)
    arg22._default_head_mesh:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function() -- line: 238
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end)
    arg22.ClientFighterCharacter.Model.ChildAdded:Connect(function(child_2: Instance) -- line: 242
        -- upvalues:
        --  [1] arg22 (copy)

        if not arg22.ClientFighterCharacter:IsAlive() then
            return
        end

        arg22:_AccessoryAdded(child_2)
    end)
    arg22.ClientFighterCharacter:AddConnection(DebugState_m:GetDataChangedSignal(
        "DisableTransparentHats"
    ):Connect(function() -- line: 250
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateAccessoryMeshes()
        arg22:_UpdateDefaultHead()
    end))
    arg22.ClientFighterCharacter:AddConnection(arg22.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsInDuel"
    ):Connect(function() -- line: 255
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_BulkUpdateAccessoryMeshes()
        arg22:_UpdateDefaultHead()
        arg22:_DeleteFaceControls()
    end))
    arg22.ClientFighterCharacter:AddConnection(arg22.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsSpectating"
    ):Connect(function() -- line: 261
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end))
    arg22.ClientFighterCharacter:AddConnection(arg22.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsHiddenByEmotes"
    ):Connect(function() -- line: 265
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end))
    arg22.ClientFighterCharacter:AddConnection(arg22.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsHiddenByCutscene"
    ):Connect(function() -- line: 269
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end))
    arg22.ClientFighterCharacter:AddConnection(CameraController_m.StateChanged:Connect(function() -- line: 273
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end))
    arg22.ClientFighterCharacter:AddConnection(SpectateController_m.SubjectEmoteStatusChanged:Connect(
        function() -- line: 277
            -- upvalues:
            --  [1] arg22 (copy)

            arg22:_UpdateDefaultHead()
        end
    ))
    local v11 = pairs
    local _ = SpectateController_m.SubjectEmoteStatusChanged:Connect(function() -- line: 277
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:_UpdateDefaultHead()
    end)

    for _, child_1 in v11(arg22.ClientFighterCharacter.Model:GetChildren()) do
        arg22:_AccessoryAdded(child_1)
    end

    arg22:_UpdateDefaultHead()
    arg22:_DeleteFaceControls()
end

function t_1._Init(arg24) -- line: 289
    task.spawn(arg24._SetupAsync, arg24)
end

return t_1
