local LocalizationService = game:GetService("LocalizationService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("ServerStorage")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ServerOsTime_m = require(ReplicatedStorage.Modules.ServerOsTime)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local RenderstepForLoop_m = require(script:WaitForChild("RenderstepForLoop"))
local t = { "rbxassetid://17662038408", "rbxassetid://17662038274", "rbxassetid://17662037971" }
local t_1 = {}
local t_2 = { a = true, e = true, i = true, o = true, u = true }
t_1.__index = t_1

function t_1._new() -- line: 21
    -- upvalues:
    --  [1] t_1 (copy)

    local t_3 = setmetatable({}, t_1)
    t_3._particle_hashes = {}
    t_3._name_to_input_enum = nil
    t_3._search_translator = nil
    t_3._cached_sound_groups = {}
    t_3:_Init()

    return t_3
end

function t_1.IsUIElementVisible(arg1, arg2) -- line: 39
    -- upvalues:
    --  [1] Players (copy)

    local v2

    if not arg2:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
        v2 = arg2:IsDescendantOf(workspace)

        if v2 then
            v2 = arg1:_RecursiveIsUIElementVisible(arg2)
        end
    else
        v2 = arg1:_RecursiveIsUIElementVisible(arg2)
    end

    return v2
end

function t_1.IsTextBoxFocused(_) -- line: 44
    -- upvalues:
    --  [1] UserInputService (copy)

    local Success, Result = pcall(UserInputService.GetFocusedTextBox, UserInputService)

    return not Success or Result
end

function t_1.IsAprilFoolsRaw(_) -- line: 50
    -- upvalues:
    --  [1] ServerOsTime_m (copy)

    local v3 = DateTime.fromUnixTimestamp(ServerOsTime_m:Get()):ToUniversalTime()

    return if v3.Month == 4 then v3.Day == 1 else false
end

function t_1.IsAprilFoolsGamemodesEnabled(arg5) -- line: 56
    return arg5:IsAprilFoolsRaw()
end

function t_1.IsAprilFools(_) -- line: 60
    return false
end

function t_1.DarkenColor(_, arg8, arg9) -- line: 64
    return Color3.new(arg8.R * arg9, arg8.G * arg9, arg8.B * arg9)
end

function t_1.IsWithinRotatedShape(
    _,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 68
    if arg14 == Enum.PartType.Ball then
        return (arg11 - arg12.Position).Magnitude <= math.max(arg13.X, arg13.Y, arg13.Z) / 2 and true
    end

    local v7

    if arg14 == Enum.PartType.Cylinder then
        local v6 = arg12:PointToObjectSpace(arg11)
        v7 = if v6.X >= -arg13.X / 2 then if v6.X <= arg13.X / 2 then math.sqrt(v6.Y ^ 2 + v6.Z ^ 2) <= math.max(
            arg13.Y,
            arg13.Z
        ) / 2 and true else false else false

        return v7
    end

    local v8 = arg12:PointToObjectSpace(arg11)
    v7 = if v8.X >= -arg13.X / 2 then v8.X <= arg13.X / 2 and v8.Y >= -arg13.Y / 2 and v8.Y <= arg13.Y / 2 and v8.Z >= -arg13.Z / 2 and v8.Z <= arg13.Z / 2 else false

    return v7
end

function t_1.IsWithinPart(_, arg16, arg17, arg18) -- line: 86
    -- upvalues:
    --  [1] t_1 (copy)

    local v9 = false

    if (arg16.Position - arg17).Magnitude < math.max(arg16.Size.X, arg16.Size.Y, arg16.Size.Z) * 1.7320508075688772 then
        local v10 = arg16.Size + (arg18 or Vector3.new(0, 0, 0))
        v9 = t_1:IsWithinRotatedShape(
            arg17,
            arg16.CFrame,
            v10,
            if arg16.ClassName ~= "Part" then Enum.PartType.Block else arg16.Shape or Enum.PartType.Block
        )
    end

    return v9
end

function t_1.IsWithinTaggedParts(
    arg19,
    arg20,
    arg21,
    arg22,
    arg23
) -- line: 91
    -- upvalues:
    --  [1] CollectionService (copy)

    local t_4 = {}

    for _, val in pairs(CollectionService:GetTagged(arg20)) do
        if arg19:IsWithinPart(val, arg21, arg22) then
            if not arg23 then
                return val
            end

            table.insert(t_4, val)
        end
    end

    if not arg23 then
        return nil
    end

    return t_4
end

function t_1.LookThrough(arg24, arg25, arg26) -- line: 113
    for _, child in pairs(arg25:GetChildren()) do
        if child:IsA("Model") and child.Name == arg26 then
            return child
        end

        if child:IsA("Folder") then
            local v15 = arg24:LookThrough(child, arg26)

            if v15 then
                return v15
            end
        end
    end
end

function t_1.SilentWaitForChild(_, arg28, arg29) -- line: 127
    while true do
        if arg28:FindFirstChild(arg29) then
            return arg28[arg29]
        end

        arg28.ChildAdded:Wait()
    end
end

function t_1.WaitForChildRecursive(_, arg31, arg32, arg33) -- line: 137
    local v16 = arg31:FindFirstChild(arg32, true)

    if v16 then
        return v16
    end

    local BindableEvent = Instance.new("BindableEvent")

    if arg33 then
        task.delay(arg33, BindableEvent.Fire, BindableEvent, nil)
    end

    task.defer(function() -- line: 150
        -- upvalues:
        --  [1] arg33 (copy)
        --  [2] arg31 (copy)
        --  [3] arg32 (copy)
        --  [4] BindableEvent (copy)

        local v17

        if not arg33 then
            v17 = false
            task.delay(5, function() -- line: 154
                -- upvalues:
                --  [1] v17 (ref)
                --  [2] arg31 (ref)
                --  [3] arg32 (ref)

                if not v17 then
                    warn(
                        "Infinite yield possible for",
                        arg31:GetFullName() .. ":WaitForChildRecursive(\"" .. arg32 .. "\")"
                    )
                end
            end)
        end

        local v18

        while true do
            v18 = arg31:FindFirstChild(arg32, true)

            if v18 then
                break
            end

            arg31.DescendantAdded:Wait()
        end

        v17 = true
        BindableEvent:Fire(v18)
    end)

    return BindableEvent.Event:Wait()
end

function t_1.GetTaggedIn(_, arg35, arg36) -- line: 181
    -- upvalues:
    --  [1] CollectionService (copy)

    local t_5 = {}

    for _, val_1 in pairs(CollectionService:GetTagged(arg35)) do
        if val_1:IsDescendantOf(arg36 or workspace) then
            table.insert(t_5, val_1)
        end
    end

    return t_5
end

function t_1.GetCharacterModel(arg37, arg38) -- line: 193
    -- upvalues:
    --  [1] Players (copy)

    if not arg38 or arg38 == workspace then
        return nil
    end

    if Players:GetPlayerFromCharacter(arg38) then
        return arg38
    end

    return (arg37:GetCharacterModel(arg38.Parent))
end

function t_1.GetProperArticle(_, arg40) -- line: 199
    -- upvalues:
    --  [1] t_2 (copy)

    local v21 = t_2
    local lowerText = string.lower(arg40)

    return "a" .. (if v21[string.sub(lowerText, 1, 1)] then "n" else "")
end

function t_1.AntiBarcodeNames(_, arg42) -- line: 203
    local v23 = 0
    local v24 = ""

    for index = 1, #arg42 do
        local substring = string.sub(arg42, index, index)

        if substring == "l" or substring == "I" then
            v23 += 1
            v24 = v24 .. (if substring ~= "l" then if substring ~= "I" then substring else "i" else "L")
        else
            v24 ..= substring
        end
    end

    return v23 > 3 and v24 or arg42
end

function t_1.AntiCircleNames(_, arg44) -- line: 221
    local v29 = 0
    local v30 = ""

    for index_1 = 1, #arg44 do
        local substring_1 = string.sub(arg44, index_1, index_1)

        if substring_1 == "O" or substring_1 == "0" then
            v29 += 1
            v30 = v30 .. (if substring_1 ~= "O" then substring_1 else "o")
        else
            v30 ..= substring_1
        end
    end

    return v29 > 3 and v30 or arg44
end

function t_1.SanitizeName(arg45, arg46) -- line: 239
    return (arg45:AntiCircleNames((arg45:AntiBarcodeNames(arg46))))
end

function t_1.GetName(_, arg48, arg49, arg50) -- line: 245
    local v36 = if arg48.HasVerifiedBadge then " " .. utf8.char(57344) else if not arg50 and arg48.HasRobloxSubscription then " " .. utf8.char(
        57347
    ) else if not arg50 and arg48.MembershipType == Enum.MembershipType.Premium then " " .. utf8.char(
        57345
    ) else ""

    return arg49 .. v36
end

function t_1.GetConnectionLevelIcon(_, arg52) -- line: 254
    -- upvalues:
    --  [1] t (copy)

    return t[arg52]
end

function t_1.GetConnectionLevel(_, arg54) -- line: 258
    return if not (arg54 < 60) then if not (arg54 < 150) then 1 else 2 else 3
end

function t_1.GetLocalConnectionPing(_, arg56) -- line: 268
    -- upvalues:
    --  [1] Players (copy)

    local v37 = arg56 or Players.LocalPlayer

    return (math.floor(v37:GetNetworkPing() * 1000))
end

function t_1.DisableShadows(_, arg58) -- line: 272
    for _, descendant in pairs(arg58:GetDescendants()) do
        if not descendant:HasTag("DisabledTexturesBlacklist") then
            if descendant:IsA("Light") then
                descendant.Shadows = false
            elseif descendant:IsA("BasePart") then
                descendant.CastShadow = false
            end
        end
    end
end

function t_1.DisableTextures(_, arg60) -- line: 286
    for _, descendant_1 in pairs(arg60:GetDescendants()) do
        if not descendant_1:HasTag("DisabledTexturesBlacklist") then
            if descendant_1:IsA("BasePart") then
                for _, val_2 in pairs(Enum.NormalId:GetEnumItems()) do
                    descendant_1[val_2.Name .. "Surface"] = Enum.SurfaceType.Smooth
                end

                if
                    descendant_1.Material ~= Enum.Material.ForceField
                    and descendant_1.Material ~= Enum.Material.Neon
                then
                    local CurrentPhysicalProperties = descendant_1.CurrentPhysicalProperties
                    descendant_1.Material = Enum.Material.SmoothPlastic
                    descendant_1.MaterialVariant = ""
                    descendant_1.CustomPhysicalProperties = descendant_1.CustomPhysicalProperties or CurrentPhysicalProperties
                end
            elseif if descendant_1:IsA("Texture") then not (descendant_1.Texture == "rbxassetid://7658055825") else descendant_1:IsA(
                "Decal"
            ) and not (descendant_1.Texture == "rbxassetid://7658055825") then
                descendant_1:Destroy()
            end
        end
    end
end

function t_1.IsVisibleFromSearch(arg61, arg62, ...) -- line: 310
    if not arg62 or arg62 == "" then
        return true
    end

    local t_6 = { ... }

    for index_2 = 1, #t_6, 2 do
        local v41 = t_6[index_2]

        if v41 then
            local v42 = t_6[index_2 + 1] or game

            if arg61._search_translator then
                local Success_1, Result_1 = pcall(
                    arg61._search_translator.Translate,
                    arg61._search_translator,
                    v42,
                    v41
                )

                if Success_1 then
                    v41 = string.lower(Result_1)
                end
            end

            if string.find(string.lower(v41), arg62) then
                return true
            end
        end
    end

    return false
end

function t_1.IsValidHex(_, arg64) -- line: 342
    if typeof(arg64) ~= "string" or #arg64 ~= 7 or string.sub(arg64, 1, 1) ~= "#" then
        return false
    end

    for index_3 = 2, 7 do
        local byteValue = string.byte((string.sub(arg64, index_3, index_3)))

        if
            (not (byteValue >= 48) or not (byteValue <= 57))
            and (not (byteValue >= 97) or not (byteValue <= 102))
        then
            return false
        end
    end

    return true
end

function t_1.Color3FromHex(arg65, arg66) -- line: 360
    assert(arg65:IsValidHex(arg66), "Argument 1 invalid, expected a valid hex string")
    local num = tonumber("0x" .. string.sub(arg66, 2, 3))
    local num_1 = tonumber("0x" .. string.sub(arg66, 4, 5))
    local num_3 = tonumber("0x" .. string.sub(arg66, 6, 7))

    return Color3.fromRGB(num, num_1, num_3)
end

function t_1.HexFromColor3(_, arg68) -- line: 371
    assert(
        if typeof(arg68) ~= "Color3" then false else true,
        "Argument 1 invalid, expected a Color3"
    )
    local floorValue = math.floor(arg68.R * 255 + 0.5)
    local floorValue_1 = math.floor(arg68.G * 255 + 0.5)
    local floorValue_3 = math.floor(arg68.B * 255 + 0.5)

    return string.format("#%02x%02x%02x", floorValue, floorValue_1, floorValue_3)
end

function t_1.GetInputEnumFromName(arg69, arg70) -- line: 381
    if not arg69._name_to_input_enum then
        arg69._name_to_input_enum = {}
        local t_7 = {}

        for _, val_3 in pairs({ Enum.KeyCode, Enum.UserInputType }) do
            for _, val_4 in pairs(val_3:GetEnumItems()) do
                if t_7[val_4] == nil then
                    t_7[val_4] = true
                elseif t_7[val_4] == true then
                    t_7[val_4] = false
                end
            end
        end

        for key_8, val_5 in pairs(t_7) do
            if val_5 then
                arg69._name_to_input_enum[key_8.Name] = key_8
            end
        end
    end

    return arg69._name_to_input_enum[arg70]
end

function t_1.SphereLineIntersection(
    _,
    arg72,
    arg73,
    arg74,
    arg75
) -- line: 408
    local v54 = arg75 - arg74
    local v55 = arg74 - arg72
    local Magnitude_2 = v54.magnitude
    local v56 = v55:Dot(v54.unit)
    local v58 = v55:Dot(v55) - arg73 * arg73

    if v58 > 0 and v56 > 0 then
        return false
    end

    local v59 = v56 * v56 - v58

    if v59 < 0 then
        return false
    end

    if Magnitude_2 < -v56 - math.sqrt(v59) then
        return false
    end

    return true
end

function t_1.Knockback(_, arg77, arg78, arg79) -- line: 435
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    arg77.Velocity = Vector3.new(0, 0, 0)
    local BodyVelocity = Instance.new("BodyVelocity")
    local v61 = if math.abs(arg78.X) > 0.1 then 1 else 0
    local v62 = if math.abs(arg78.Y) > 0.1 then 1 else 0
    local v63 = if math.abs(arg78.Z) > 0.1 then 1 else 0
    BodyVelocity.MaxForce = Vector3.new(v61, v62, v63) * 100000
    BodyVelocity.Velocity = arg78
    BodyVelocity.Parent = arg77
    BetterDebris_m:AddItem(BodyVelocity, 0.2)

    if arg79 then
        BetterDebris_m:AddItem(BodyVelocity, arg79)
        task.delay(arg79, function() -- line: 447
            -- upvalues:
            --  [1] arg77 (copy)

            arg77.Velocity = Vector3.new(0, 0, 0)
        end)
    end

    return BodyVelocity
end

function t_1.GetArmsData(_, arg81) -- line: 455
    if not arg81 then
        return
    end

    local Shirt = arg81:FindFirstChildOfClass("Shirt")
    local v64 = Shirt

    if v64 then
        v64 = Shirt.ShirtTemplate
    end

    local BodyColors = arg81:FindFirstChildOfClass("BodyColors")
    local v65 = BodyColors

    if v65 then
        v65 = BodyColors.LeftArmColor3
    end

    return v64, v65, BodyColors and BodyColors.RightArmColor3
end

function t_1.TimeFormat(_, arg83) -- line: 471
    arg83 = math.floor(arg83)
    local v67 = arg83 % 60

    return math.floor(arg83 / 60) .. ":" .. (if v67 < 10 then "0" else "") .. v67
end

function t_1.TimeFormat2(_, arg85, arg86, arg87) -- line: 480
    if not arg87 and arg85 <= 0 then
        return "0s"
    end

    if arg87 and arg85 < 60 then
        return "0m"
    end

    local v69 = arg85 % 60
    arg85 -= v69
    local v70 = arg85 / 60 % 60
    arg85 -= v70 * 60
    local v71 = arg85 / 60 / 60 % 24
    arg85 -= v71 * 60 * 60
    local v72 = arg85 / 60 / 60 / 24 % 365
    local v73 = (arg85 - v72 * 24 * 60 * 60) / 60 / 60 / 24 / 365
    local v75

    if arg86 then
        local v74 = typeof(arg86) == "number" and arg86 or 1
        v75 = 0
        local v76 = ""

        for _, val_6 in pairs(
            { { v73, "y" }, { v72, "d" }, { v71, "h" }, { v70, "m" }, { v69, "s" } }
        ) do
            if val_6[1] > 0 then
                v75 += 1
                v76 = v76 .. (if not (v75 > 1) then "" else " ") .. val_6[1] .. val_6[2]

                if v74 <= v75 then
                    break
                end
            end
        end

        return v76
    end

    v75 = v73 > 0 and v73 .. "y " or ""
    local v79 = if not (v73 > 0) then v72 > 0 and v72 .. "d " or "" else v72 .. "d " or ""
    local v80 = if not (v73 > 0) then if not (v72 > 0) then v71 > 0 and v71 .. "h " or "" else v71 .. "h " or "" else v71 .. "h " or ""
    local v81 = if not (v73 > 0) then if not (v72 > 0) then if not (v71 > 0) then v70 > 0 and v70 .. "m " or "" else v70 .. "m " or "" else v70 .. "m " or "" else v70 .. "m " or ""
    local v82 = if not (v73 > 0) then if not (v72 > 0) then if not (v71 > 0) then if not (v70 > 0) then v69 > 0 and not arg87 and v69 .. "s" or "" else not arg87 and v69 .. "s" or "" else not arg87 and v69 .. "s" or "" else not arg87 and v69 .. "s" or "" else not arg87 and v69 .. "s" or ""

    return v75 .. v79 .. v80 .. v81 .. v82
end

function t_1.ScaleParticleEmitter(_, arg89, arg90) -- line: 523
    local v83 = if arg89:IsA("ParticleEmitter") then {} else arg89:GetDescendants()
    table.insert(v83, arg89)

    for _, val_7 in pairs(v83) do
        if val_7:IsA("ParticleEmitter") then
            local t_15 = {}

            for _, val_8 in pairs(val_7.Size.Keypoints) do
                table.insert(
                    t_15,
                    NumberSequenceKeypoint.new(
                        val_8.Time,
                        val_8.Value * arg90,
                        val_8.Envelope * arg90
                    )
                )
            end

            val_7.Size = NumberSequence.new(t_15)
            val_7.Speed = NumberRange.new(val_7.Speed.Min * arg90, val_7.Speed.Max * arg90)
            val_7.Acceleration *= arg90 ^ 2
        end
    end
end

function t_1.EncodeCFrame(_, arg92) -- line: 545
    local v84, v85, v86 = arg92:ToOrientation()
    local t_16 = {}
    t_16[utf8.char(0)] = arg92.X
    t_16[utf8.char(1)] = arg92.Y
    t_16[utf8.char(2)] = arg92.Z
    t_16[utf8.char(3)] = v84
    t_16[utf8.char(4)] = v85
    t_16[utf8.char(5)] = v86

    return t_16
end

function t_1.DecodeCFrame(_, arg94) -- line: 558
    local cframe = CFrame.new(arg94[utf8.char(0)], arg94[utf8.char(1)], arg94[utf8.char(2)])

    return cframe * CFrame.fromOrientation(
        arg94[utf8.char(3)],
        arg94[utf8.char(4)],
        arg94[utf8.char(5)]
    )
end

function t_1.FromXYToCameraRotation(_, arg96, arg97) -- line: 563
    return Vector2.new(arg96, arg97) * 3.141592653589793 * 2 / 256
end

function t_1.DecodeCameraRotation(arg98, arg99) -- line: 568
    local codepoint, v92 = utf8.codepoint(arg99, 1, #arg99)

    return arg98:FromXYToCameraRotation(codepoint, v92)
end

function t_1.DecodeCameraRotationBulk(_, arg101) -- line: 575
    local t_17 = { utf8.codepoint(arg101, 1, #arg101) }
    local t_18 = {}

    for index_4 = 1, #arg101, 3 do
        table.insert(t_18, { t_17[index_4], t_17[index_4 + 1], t_17[index_4 + 2] })
    end

    return t_18
end

function t_1.EncodeCameraRotation(_, arg103) -- line: 591
    if arg103 ~= arg103 then
        return utf8.char(0) .. utf8.char(0)
    end

    local clampedValue = math.clamp(
        math.floor(arg103.X % 6.283185307179586 / 3.141592653589793 / 2 * 256 + 0.5),
        0,
        255
    )
    local clampedValue_1 = math.clamp(
        math.floor(arg103.Y % 6.283185307179586 / 3.141592653589793 / 2 * 256 + 0.5),
        0,
        255
    )

    return utf8.char(clampedValue) .. utf8.char(clampedValue_1)
end

function t_1.AngleBetweenVectors(_, arg105, arg106) -- line: 602
    local v97 = arg106:Dot(arg105)

    return (math.acos(v97 / arg106.Magnitude / arg105.Magnitude))
end

function t_1.PlayParticles(arg107, arg108) -- line: 607
    if not arg108 then
        return
    end

    local v98 = true
    local v100 = typeof(arg108)

    if v100 ~= "Instance" then
        v100 = typeof(arg108)
        v98 = if v100 ~= "table" then false else true
    end

    v100 = "Argument 1 invalid, expected an Instance or table"
    assert(v98, v100)
    v100 = arg108
    local v102 = if typeof(v100) ~= "Instance" then false else true
    v98 = v102

    if v98 then
        v100 = arg108:IsDescendantOf(workspace)
        v98 = not v100
    end

    v100 = nil

    if v102 and not v98 then
        if not arg107._particle_hashes[arg108] then
            arg107._particle_hashes[arg108] = 0
            local AncestryChangedConnection = nil
            AncestryChangedConnection = arg108.AncestryChanged:Connect(function() -- line: 625
                -- upvalues:
                --  [1] arg108 (copy)
                --  [2] AncestryChangedConnection (ref)
                --  [3] arg107 (copy)

                if not arg108:IsDescendantOf(workspace) then
                    AncestryChangedConnection:Disconnect()
                    arg107._particle_hashes[arg108] = nil
                end
            end)
        end

        local ParticleHashes_1 = arg107._particle_hashes
        ParticleHashes_1[arg108] += 1
        v100 = arg107._particle_hashes[arg108]
    end

    local v105 = nil

    if v102 then
        v105 = arg108:GetDescendants()
        table.insert(v105, arg108)
    else
        v105 = {}

        for _, val_9 in pairs(arg108) do
            table.insert(v105, val_9)

            for _, val_10 in pairs(val_9:GetDescendants()) do
                table.insert(v105, val_10)
            end
        end
    end

    for _, val_11 in pairs(v105) do
        if val_11:IsA("ParticleEmitter") then
            local v107 = val_11:GetAttribute("EmitCount") or 0
            local v108 = val_11:GetAttribute("EmitDelay") or 0
            local v109 = val_11:GetAttribute("EmitDuration") or 0

            if v108 > 0 then
                task.delay(v108, val_11.Emit, val_11, v107)
            else
                task.spawn(val_11.Emit, val_11, v107)
            end

            if v109 > 0 then
                task.defer(function() -- line: 667
                    -- upvalues:
                    --  [1] val_11 (copy)
                    --  [2] v109 (copy)

                    val_11.Enabled = true
                    task.wait(v109)
                    val_11.Enabled = false
                end)
            end
        elseif val_11:IsA("Light") then
            local v110 = val_11:GetAttribute("Brightness") or 0
            local v111 = val_11:GetAttribute("DecaySpeed") or 1

            if not v98 then
                task.spawn(function() -- line: 678
                    -- upvalues:
                    --  [1] val_11 (copy)
                    --  [2] v110 (copy)
                    --  [3] arg107 (copy)
                    --  [4] v111 (copy)
                    --  [5] v102 (copy)
                    --  [6] arg108 (copy)
                    --  [7] v100 (ref)

                    val_11.Brightness = v110
                    val_11.Enabled = true
                    arg107:RenderstepForLoop(0, 100, 10 * v111, function(arg109) -- line: 682
                        -- upvalues:
                        --  [1] v102 (ref)
                        --  [2] arg107 (ref)
                        --  [3] arg108 (ref)
                        --  [4] v100 (ref)
                        --  [5] val_11 (ref)
                        --  [6] v110 (ref)

                        if v102 and arg107._particle_hashes[arg108] ~= v100 then
                            return true
                        end

                        val_11.Brightness = v110 * (1 - arg109 / 100)
                    end)

                    if not arg107._particle_hashes[arg108] then
                        val_11.Brightness = 0
                        val_11.Enabled = false
                    end
                end)
            end
        end
    end
end

function t_1.StringLessThan(_, arg111, arg112) -- line: 701
    if arg111 == arg112 then
        return false
    end

    for index_5 = 1, math.min(#arg111, #arg112) do
        local byteValue_1 = string.byte((string.sub(arg111, index_5, index_5)))
        local v113 = string.sub(arg112, index_5, index_5)
        local byteValue_2 = string.byte(v113)

        if byteValue_1 ~= byteValue_2 then
            v113 = byteValue_1 < byteValue_2

            return v113
        end
    end

    return #arg111 < #arg112
end

function t_1.CloneTable(arg113, arg114, arg115) -- line: 720
    local t_20 = {}

    for key_15, val_12 in pairs(arg114) do
        if not arg115 and typeof(val_12) == "table" then
            t_20[key_15] = arg113:CloneTable(val_12)
        else
            t_20[key_15] = val_12
        end
    end

    return t_20
end

function t_1.PrettyNumber(_, arg117) -- line: 735
    local num_4 = tonumber(arg117)

    if typeof(num_4) ~= "number" then
        assert(false, "Argument 1 invalid, expected a number or string, got " .. tostring(arg117))
    end

    if tostring(arg117) == "inf" then
        return "inf"
    end

    local v115, v116, v117 = string.match(num_4, "^([^%d]*%d)(%d*)(.-)$")

    return v115 .. v116:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. v117
end

function t_1.MakeSafeRaycastResult(
    _,
    arg119,
    arg120,
    arg121,
    arg122
) -- line: 751
    local t_21 = {}
    t_21.Position = arg119 and arg119.Position or arg120 + arg121 * arg122
    t_21.Distance = arg119 and arg119.Distance or arg122
    t_21.Instance = arg119 and arg119.Instance or nil
    t_21.Material = arg119 and arg119.Material or nil
    t_21.Normal = arg119 and arg119.Normal or nil

    return t_21
end

function t_1.Raycast(
    arg123,
    arg124,
    arg125,
    arg126,
    arg127,
    arg128,
    arg129
) -- line: 767
    -- upvalues:
    --  [1] BetterDebris_m (copy)

    assert(
        if typeof(arg124) ~= "Vector3" then false else true,
        "Argument 1 invalid, expected a Vector3"
    )
    assert(
        if typeof(arg125) ~= "Vector3" then false else true,
        "Argument 2 invalid, expected a Vector3"
    )
    assert(
        if typeof(arg126) ~= "number" then false else true,
        "Argument 3 invalid, expected a number"
    )
    local v121 = not arg127 or (if typeof(arg127) ~= "table" then false else true)
    assert(v121, "Argument 4 invalid, expected a table or nil")
    v121 = not arg128 or (if typeof(arg128) ~= "EnumItem" then false else true)
    assert(v121, "Argument 5 invalid, expected a RaycastFilterType")
    v121 = not arg129 or (if typeof(arg129) ~= "boolean" then false else true)
    assert(v121, "Argument 6 invalid, expected a boolean or nil")
    local v122 = arg127 or {}
    v121 = arg128 or Enum.RaycastFilterType.Exclude
    local v123 = (arg125 - arg124).Unit * arg126
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = v122
    raycastParams.FilterType = v121
    raycastParams.IgnoreWater = true
    local v125 = arg123:MakeSafeRaycastResult(
        workspace:Raycast(arg124, v123, raycastParams),
        arg124,
        (arg125 - arg124).Unit,
        arg126
    )

    if arg129 then
        local Magnitude_3 = (arg124 - v125.Position).Magnitude
        local Part = Instance.new("Part")
        Part.Color = Color3.fromHSV(math.random(), 1, 1)
        Part.Material = Enum.Material.Neon
        Part.Anchored = true
        Part.CanCollide = false
        Part.Size = Vector3.new(0.01, 0.01, Magnitude_3)
        Part.CFrame = CFrame.new(arg124, v125.Position) * CFrame.new(0, 0, -Magnitude_3 / 2)
        Part.Parent = workspace
        BetterDebris_m:AddItem(Part, 10)
    end

    return v125
end

function t_1.WaitForChildWhichIsA(_, arg131, arg132, arg133) -- line: 807
    assert(
        if typeof(arg131) ~= "Instance" then false else true,
        "Argument 1 invalid, expected an Instance, got " .. tostring(arg131)
    )
    assert(
        if typeof(arg132) ~= "string" then false else true,
        "Argument 2 invalid, expected a string, got " .. tostring(arg132)
    )
    assert(
        not arg133 or (if typeof(arg133) ~= "boolean" then false else true),
        "Argument 3 invalid, expected a boolean or nil, got " .. tostring(arg133)
    )

    while true do
        local v127 = arg131:FindFirstChildWhichIsA(arg132, arg133)

        if v127 then
            return v127
        end

        if arg133 then
            arg131.DescendantAdded:Wait()
            continue
        end

        arg131.ChildAdded:Wait()
    end
end

function t_1.GetSoundGroup(arg134, arg135) -- line: 827
    -- upvalues:
    --  [1] SoundService (copy)

    local v128 = arg135 or "Other"

    if not arg134._cached_sound_groups[v128] then
        arg134._cached_sound_groups[v128] = SoundService:FindFirstChild(v128, true)
    end

    return arg134._cached_sound_groups[v128]
end

function t_1.CreateSound(
    arg136,
    arg137,
    arg138,
    arg139,
    arg140,
    arg141,
    arg142,
    arg143,
    arg144,
    arg145,
    arg146
) -- line: 841
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] EnumLibrary_m (copy)
    --  [4] BetterDebris_m (copy)

    assert(if typeof(arg137) ~= "string" then false else true, arg137)
    local v129 = not arg138 or (if typeof(arg138) ~= "number" then false else true)
    assert(v129, arg138)
    v129 = not arg139 or (if typeof(arg139) ~= "number" then false else true)
    assert(v129, arg139)
    v129 = not arg140 or (if arg140 ~= "script" then if typeof(arg140) ~= "Instance" then if typeof(
        arg140
    ) ~= "Vector3" then false else true else true else true)
    assert(v129, arg140)
    v129 = not arg141 or (if typeof(arg141) ~= "boolean" then false else true)
    assert(v129, "Argument 5 invalid, expected a boolean", arg141)
    v129 = not arg142 or (if typeof(arg142) ~= "number" then false else true)
    assert(v129, "Argument 6 invalid, expected a number or nil", arg142)
    v129 = not arg143 or (if typeof(arg143) ~= "number" then false else true)
    assert(v129, "Argument 7 invalid, expected a number or nil", arg143)
    v129 = not arg144 or (if typeof(arg144) ~= "number" then false else true)
    assert(v129, "Argument 8 invalid, expected a number or nil", arg144)
    v129 = not arg145 or (if typeof(arg145) ~= "string" then false else true)
    assert(v129, "Argument 9 invalid, expected a string or nil", arg145)
    v129 = not arg146 or (if typeof(arg146) ~= "table" then false else true)
    assert(v129, "Argument 10 invalid, expected a table or nil", arg146)

    if CONSTANTS_m.IS_SERVER then
        ReplicatedStorage.Remotes.Misc.FunctionsUnreliable:FireAllClients(
            EnumLibrary_m:ToEnum("CreateSound"),
            arg137,
            arg138,
            arg139,
            arg140,
            arg141,
            arg142,
            arg143,
            arg144,
            arg145,
            arg146
        )

        return
    end

    local v131

    if typeof(arg140) == "Vector3" then
        v131 = Instance.new("Part")
        v131.CFrame = CFrame.new(arg140)
        v131.Size = Vector3.new(1, 1, 1)
        v131.Transparency = 1
        v131.CastShadow = false
        v131.CanCollide = false
        v131.CanTouch = false
        v131.CanQuery = false
        v131.Anchored = true
        v131.Parent = workspace
        BetterDebris_m:AddItem(v131, arg142 or 60)
    else
        v131 = if arg140 ~= "script" then arg140 else script
    end

    local Sound = Instance.new("Sound")
    Sound.SoundId = arg137
    Sound.Volume = arg138 or 1
    Sound.PlaybackSpeed = arg139 or 1
    Sound.RollOffMinDistance = arg143 or 50
    Sound.RollOffMaxDistance = arg144 or 400
    Sound.RollOffMode = Enum.RollOffMode.Inverse
    Sound.SoundGroup = arg136:GetSoundGroup(arg145)
    Sound:AddTag("AudioVisualizer")
    local v132 = pairs
    local v133 = arg146 or {}

    for key_16, val_13 in v132(v133) do
        Sound[key_16] = val_13
    end

    Sound.Parent = v131

    if arg141 then
        Sound:Play()
    end

    if arg142 then
        BetterDebris_m:AddItem(Sound, arg142)
    end

    return Sound
end

function t_1.WaitForChild(_, arg148, ...) -- line: 906
    assert(
        if typeof(arg148) ~= "Instance" then false else true,
        "Argument 1 invalid, expected an Instance, got " .. tostring(arg148)
    )
    local v135 = arg148

    for key_17, val_14 in pairs({ ... }) do
        assert(
            if typeof(val_14) ~= "string" then false else true,
            "Argument " .. key_17 + 1 .. " invalid, expected a string, got " .. tostring(val_14)
        )
        v135 = v135:WaitForChild(val_14)
    end

    return v135
end

function t_1.RenderstepForLoop(_, ...) -- line: 920
    -- upvalues:
    --  [1] RenderstepForLoop_m (copy)

    RenderstepForLoop_m(...)
end

function t_1._RecursiveIsUIElementVisible(arg150, arg151) -- line: 928
    if arg151:IsA("ScreenGui") or arg151:IsA("SurfaceGui") or arg151:IsA("BillboardGui") then
        return arg151.Enabled
    end

    local v138 = arg151.Visible

    if v138 then
        v138 = arg150:_RecursiveIsUIElementVisible(arg151.Parent)
    end

    return v138
end

function t_1._SetupTranslator(arg152) -- line: 932
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] LocalizationService (copy)
    --  [3] Players (copy)

    if not CONSTANTS_m.IS_CLIENT then
        return
    end

    local Success_2, Result_2 = pcall(
        LocalizationService.GetTranslatorForPlayerAsync,
        LocalizationService,
        Players.LocalPlayer
    )

    if not Success_2 then
        warn("Failed to fetch translator, error:", Result_2)

        return
    end

    arg152._search_translator = Result_2
end

function t_1._Init(arg153) -- line: 947
    task.defer(arg153._SetupTranslator, arg153)
end

return t_1._new()
