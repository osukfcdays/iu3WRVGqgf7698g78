local CollectionService = game:GetService("CollectionService")
local v1 = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local CosmeticLibrary_m = require(v1.Modules.CosmeticLibrary)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = CONSTANTS_m.IS_RUNNING

    if v1 then
        v1 = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("WrapTextures")
    end
end

local WrapGroupObjects = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WrapGroupObjects")
local t = {}
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._wrap_group_callbacks = {}
    t_1._wrap_group_classes = {}
    t_1._wrap_group_objects = {}
    t_1._wrap_group_objects_count = {}
    t_1._preloaded_wrap_group_objects = {}
    t_1._preload_screen_gui = Instance.new("ScreenGui")
    t_1:_Init()

    return t_1
end

function t.RecordOriginalWrapProperties(_, arg2) -- line: 36
    local t_2 = {}
    local v2

    if typeof(arg2) == "table" then
        v2 = arg2
    else
        v2 = arg2:GetDescendants()
        table.insert(v2, arg2)
    end

    for _, val in pairs(v2) do
        if val:HasTag("Wrappable") then
            local t_11 = nil

            if val:IsA("BasePart") then
                t_11 = {
                    Material = val.Material,
                    MaterialVariant = val.MaterialVariant,
                    Color = val.Color,
                    Transparency = val.Transparency,
                    Reflectance = val.Reflectance
                }

                if val:IsA("MeshPart") then
                    t_11.TextureID = val.TextureID
                end
            elseif val:IsA("Decal") or val:IsA("Texture") then
                t_11 = { Color3 = val.Color3, Transparency = val.Transparency }
            elseif val:IsA("Beam") or val:IsA("Trail") or val:IsA("ParticleEmitter") then
                t_11 = {
                    Color = val.Color,
                    Transparency = val.Transparency,
                    LightEmission = val.LightEmission
                }
            elseif val:IsA("Frame") then
                t_11 = {
                    BackgroundColor3 = val.BackgroundColor3,
                    BackgroundTransparency = val.BackgroundTransparency
                }
            elseif val:IsA("ImageLabel") then
                t_11 = { ImageColor3 = val.ImageColor3, ImageTransparency = val.ImageTransparency }
            elseif val:IsA("Light") then
                t_11 = { Color = val.Color, Brightness = val.Brightness }
            elseif val:IsA("RopeConstraint") or val:IsA("SpringConstraint") then
                t_11 = { Color = val.Color }
            end

            if t_11 then
                t_2[val] = {
                    WrapGroup = val:GetAttribute("WrapGroup"),
                    IgnoreTransparency = val:GetAttribute("IgnoreTransparency"),
                    IgnoreMaterial = val:GetAttribute("IgnoreMaterial"),
                    IgnoreObject = val:GetAttribute("IgnoreObject"),
                    OriginalProperties = t_11,
                    OriginalChildren = {},
                    Cleanup = {}
                }

                for _, val_1 in pairs(val:GetChildren()) do
                    if val_1:IsA("SurfaceAppearance") then
                        table.insert(t_2[val].OriginalChildren, val_1)
                    end
                end

                local v5 = t_2[val].WrapGroup

                if v5 then
                    v5 = if typeof(t_2[val].WrapGroup) ~= "number" then false else true
                end

                assert(v5, val:GetFullName())
            end
        end
    end

    return t_2
end

function t.ResetWrap(_, arg4) -- line: 122
    if not arg4 then
        return
    end

    for key_2, val_2 in pairs(arg4) do
        for key_3, val_3 in pairs(val_2.OriginalProperties) do
            key_2[key_3] = val_3
        end

        for _, val_4 in pairs(val_2.OriginalChildren) do
            pcall(function() -- line: 133
                -- upvalues:
                --  [1] val_4 (copy)
                --  [2] key_2 (copy)

                val_4.Parent = key_2
            end)
        end

        for _, val_5 in pairs(val_2.Cleanup) do
            val_5:Destroy()
        end

        val_2.Cleanup = {}
    end
end

function t.ApplyWrap(
    arg5,
    arg6,
    arg7,
    arg8,
    arg9
) -- line: 146
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] v1 (copy)

    arg5:ResetWrap(arg6)

    if not arg7 or arg7.Name == "RANDOM_COSMETIC" then
        return
    end

    local v6 = CosmeticLibrary_m.Cosmetics[arg7.Name]
    local Inverted = arg7.Inverted
    local v14

    for key_6, val_6 in pairs(arg6) do
        if not arg9 or not arg9[key_6] then
            local v7 = if Inverted then if val_6.WrapGroup ~= 1 then if val_6.WrapGroup ~= 2 then val_6.WrapGroup else 1 else 2 else val_6.WrapGroup
            local v8 = v6.WrapGroups[v7] or {}
            v7 = arg8 or val_6.IgnoreTransparency
            local IgnoreMaterial = val_6.IgnoreMaterial
            local IgnoreObject = val_6.IgnoreObject
            local t_12 = {}

            if key_6:IsA("BasePart") then
                local v9 = v8.Color or key_6.Color
                key_6.Color = v9
                v9 = if v7 then key_6.Transparency else v8.Transparency or key_6.Transparency
                key_6.Transparency = v9
                v9 = v8.Reflectance or key_6.Reflectance
                key_6.Reflectance = v9
                v9 = if IgnoreMaterial then key_6.Material else if not v7 then v8.Material or key_6.Material else if v8.Material == Enum.Material.ForceField then key_6.Material else v8.Material or key_6.Material
                key_6.Material = v9
                v9 = if IgnoreMaterial then key_6.MaterialVariant else v8.MaterialVariant or key_6.MaterialVariant
                key_6.MaterialVariant = v9

                if key_6:IsA("MeshPart") then
                    key_6.TextureID = ""
                end

                if not IgnoreMaterial then
                    local v10 = pairs
                    local v11 = v8.Textures and v1[v8.Textures]:GetChildren() or {}

                    for _, val_7 in v10(v11) do
                        local v12 = val_7:Clone()
                        v12.LocalTransparencyModifier = key_6.LocalTransparencyModifier
                        v12.Parent = key_6
                        table.insert(val_6.Cleanup, v12)
                        table.insert(t_12, v12)
                    end
                end
            elseif key_6:IsA("Decal") or key_6:IsA("Texture") then
                local v13 = v8.Color3 or key_6.Color3
                key_6.Color3 = v13
                v13 = if v7 then key_6.Transparency else v8.Transparency or key_6.Transparency
                key_6.Transparency = v13
            elseif key_6:IsA("Beam") or key_6:IsA("Trail") or key_6:IsA("ParticleEmitter") then
                v14 = v8.Color and ColorSequence.new(v8.Color) or key_6.Color
                key_6.Color = v14
            elseif key_6:IsA("Frame") then
                v14 = v8.Color or key_6.BackgroundColor3
                key_6.BackgroundColor3 = v14
                v14 = if v7 then key_6.BackgroundTransparency else v8.Transparency or key_6.BackgroundTransparency
                key_6.BackgroundTransparency = v14
            elseif key_6:IsA("ImageLabel") then
                v14 = v8.Color or key_6.ImageColor3
                key_6.ImageColor3 = v14
                v14 = if v7 then key_6.ImageTransparency else v8.Transparency or key_6.ImageTransparency
                key_6.ImageTransparency = v14
            elseif key_6:IsA("Light") then
                v14 = v8.Color or key_6.Color
                key_6.Color = v14
                local Brightness = key_6.Brightness
                local v15 = 0 - key_6.Brightness
                local v16 = if v7 then 0 else v8.Transparency or 0
                key_6.Brightness = Brightness + v15 * v16
            elseif key_6:IsA("RopeConstraint") or key_6:IsA("SpringConstraint") then
                local v17 = v8.Color and BrickColor.new(v8.Color) or key_6.Color
                key_6.Color = v17
            end

            for _, val_8 in pairs(val_6.OriginalChildren) do
                pcall(function() -- line: 225
                    -- upvalues:
                    --  [1] val_8 (copy)

                    val_8.Parent = nil
                end)
            end

            if not IgnoreObject then
                local v18 = arg5:_GetWrapGroupObject(v8)

                if v18 then
                    v7 = v18.new(v8.ObjectName, key_6, t_12)
                    table.insert(arg5._wrap_group_objects, v7)
                    table.insert(val_6.Cleanup, v7)
                    arg5:_IncrementWrapGroupObjectsCount(v7.Name, 1, v7)
                end
            end
        end
    end
end

function t.Update(arg10, arg11) -- line: 243
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    for index = #arg10._wrap_group_objects, 1, -1 do
        local v19 = arg10._wrap_group_objects[index]

        if v19.IsDestroyed then
            table.remove(arg10._wrap_group_objects, index)
            arg10:_IncrementWrapGroupObjectsCount(v19.Name, -1, v19)
        elseif v19.Update and v19:IsActive() then
            if CONSTANTS_m.IS_STUDIO then
                v19:Update(arg11)
            else
                pcall(v19.Update, v19, arg11)
            end
        end
    end
end

function t._IncrementWrapGroupObjectsCount(arg12, arg13, arg14, arg15) -- line: 264
    local v20 = (arg12._wrap_group_objects_count[arg13] or 0) + arg14
    local v21 = arg12._wrap_group_objects_count
    v21[arg13] = if not (v20 <= 0) then v20 else nil

    if v20 == 1 then
        v21 = arg15.GetPreloadedImageIDs

        if v21 then
            v21 = arg15:GetPreloadedImageIDs()
        end

        if not v21 or #v21 == 0 then
            return
        end

        local PreloadedWrapGroupObjects = arg12._preloaded_wrap_group_objects
        PreloadedWrapGroupObjects[arg13] = arg12._preloaded_wrap_group_objects[arg13] or {}
        local v24 = arg12._preloaded_wrap_group_objects[arg13]
        local v25 = arg12._preloaded_wrap_group_objects[arg13].Textures or {}
        v24.Textures = v25

        for key_9, val_9 in pairs(v21) do
            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Active = false
            ImageLabel.Size = UDim2.new(0, 1, 0, 1)
            ImageLabel.ImageTransparency = 0.99
            ImageLabel.Image = val_9
            ImageLabel.Name = arg13 .. " - " .. key_9
            ImageLabel.Parent = arg12._preload_screen_gui
            table.insert(arg12._preloaded_wrap_group_objects[arg13].Textures, ImageLabel)
        end

        return
    end

    if not v20 then
        v21 = pairs
        local v26 = arg12._preloaded_wrap_group_objects[arg13] and arg12._preloaded_wrap_group_objects[arg13].Textures or {}

        for _, val_10 in v21(v26) do
            task.defer(val_10.Destroy, val_10)
        end

        arg12._preloaded_wrap_group_objects[arg13] = nil
    end
end

function t._GetWrapGroupObject(arg16, arg17) -- line: 299
    -- upvalues:
    --  [1] WrapGroupObjects (copy)

    if not arg17.ObjectName then
        return
    end

    if not arg16._wrap_group_classes[arg17.ObjectName] then
        arg16._wrap_group_classes[arg17.ObjectName] = require(
            WrapGroupObjects:WaitForChild(arg17.ObjectName)
        )
    end

    return arg16._wrap_group_classes[arg17.ObjectName]
end

function t._WrapThis(arg18, arg19) -- line: 311
    arg18:ApplyWrap(
        arg18:RecordOriginalWrapProperties(arg19),
        { Name = arg19:GetAttribute("WrapName") }
    )
end

function t._Setup(arg20) -- line: 315
    -- upvalues:
    --  [1] Players (copy)

    arg20._preload_screen_gui.Name = "PreloadedWrapTextures"
    arg20._preload_screen_gui.ResetOnSpawn = false
    arg20._preload_screen_gui.Parent = Players.LocalPlayer.PlayerGui
end

function t._Init(arg21) -- line: 321
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] CollectionService (copy)

    RunService:BindToRenderStep("WrapController", Enum.RenderPriority.Camera.Value + 1, function(
        arg22
    ) -- line: 322
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:Update(arg22)
    end)
    CollectionService:GetInstanceAddedSignal("WrapThis"):Connect(function(arg23) -- line: 326
        -- upvalues:
        --  [1] arg21 (copy)

        arg21:_WrapThis(arg23)
    end)

    for _, val_11 in pairs(CollectionService:GetTagged("WrapThis")) do
        task.defer(arg21._WrapThis, arg21, val_11)
    end

    arg21:_Setup()
end

return t._new()
