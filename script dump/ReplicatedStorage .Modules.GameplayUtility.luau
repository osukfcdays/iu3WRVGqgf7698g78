local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ShopLibrary_m = require(ReplicatedStorage.Modules.ShopLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Maps = ReplicatedStorage.Assets.Temp.Maps
local t = {}
local AttackWarning = ReplicatedStorage.Assets.Misc.AttackWarning
t.__index = t

function t._new() -- line: 21
    -- upvalues:
    --  [1] t (copy)
    --  [2] Maps (copy)

    local t_1 = setmetatable({}, t)
    t_1.TEMP_MAPS_FOLDER = Maps
    t_1.OOB_DEFAULT_WARN_DELAY = 1
    t_1.OOB_DEFAULT_KILL_DELAY = 4
    t_1:_Init()

    return t_1
end

function t.IsThingInWorkspace(_, arg2) -- line: 37
    -- upvalues:
    --  [1] Maps (copy)

    return arg2:IsDescendantOf(workspace) or arg2:IsDescendantOf(Maps)
end

function t.IsEntity(_, arg4) -- line: 42
    -- upvalues:
    --  [1] CollectionService (copy)

    while arg4 do
        if arg4 == workspace then
            break
        end

        if CollectionService:HasTag(arg4, "Entity") then
            return arg4
        end

        arg4 = arg4.Parent
    end

    return false
end

function t.GetEnvironmentID(_, arg6) -- line: 54
    while arg6 do
        if not arg6:IsDescendantOf(workspace) then
            break
        end

        local EnvironmentID = arg6:GetAttribute("EnvironmentID")

        if EnvironmentID then
            return EnvironmentID
        end

        arg6 = arg6.Parent
    end

    return nil
end

function t.GetSmokeCloudBetweenPoints(_, arg8, arg9) -- line: 68
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] Utility_m (copy)

    for _, val in pairs(CollectionService:GetTagged("SmokeCloud")) do
        if Utility_m:SphereLineIntersection(val.Position, val.Size.X / 2, arg8, arg9) then
            return val
        end
    end
end

function t.GetSmokeCloudsInSphere(
    _,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 76
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] Utility_m (copy)

    local v4 = arg12 or 0
    local t_2 = {}

    for _, val_1 in pairs(CollectionService:GetTagged("SmokeCloud")) do
        if
            not ((arg11 - val_1.Position).Magnitude > val_1.Size.X / 2 + v4)
            and (not arg13 or not arg14 or not (arg14 < Utility_m:AngleBetweenVectors(
                arg13,
                val_1.Position - arg11
            )))
        then
            table.insert(t_2, val_1)
        end
    end

    return t_2
end

function t.GetEquippedItems(_, arg16, arg17, arg18) -- line: 95
    if not arg16 then
        return {}
    end

    local v7 = nil
    local v8 = nil

    for key_2, val_2 in pairs(arg17) do
        if val_2:Get("ObjectID") == arg16 then
            v7 = val_2
            v8 = key_2
            break
        end
    end

    if not v7 then
        return {}
    end

    v7 = {}

    for index = v8, v8 + (arg18 or 0) do
        v7[arg17[(index - 1) % #arg17 + 1]] = true
    end

    return v7
end

function t.AttackWarningEffect(
    _,
    arg20,
    arg21,
    arg22,
    arg23,
    arg24
) -- line: 125
    -- upvalues:
    --  [1] AttackWarning (copy)
    --  [2] BetterDebris_m (copy)

    local v9 = arg23 or Color3.fromRGB(255, 0, 0)
    local v10 = AttackWarning:Clone()
    v10:ScaleTo(v10:GetScale() * arg21 / 8)
    v10:PivotTo(CFrame.new(arg20) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0))
    v10.Primary.Bottom.Circle.ImageColor3 = v9
    v10.Primary.Bottom.Icon.ImageColor3 = v9
    local v13 = arg24
    local Icon = v10.Primary.Bottom.Icon

    if not v13 then
        v13 = v10.Primary.Bottom.Icon.Image
    end

    Icon.Image = v13
    v10.Primary.Top.Progress.ImageColor3 = v9
    v10.Primary.Top.Icon.ImageColor3 = v9
    local Icon_1 = v10.Primary.Top.Icon
    v13 = arg24 or v10.Primary.Top.Icon.Image
    Icon_1.Image = v13
    v10.Parent = workspace
    BetterDebris_m:AddItem(v10, arg22)
    v10.Primary.Top.Progress:TweenSize(
        UDim2.new(1, 0, 1, 0),
        "Out",
        "Linear",
        arg22,
        true
    )
end

function t.KnockbackTaggedParts(
    _,
    arg26,
    arg27,
    arg28,
    arg29,
    arg30,
    arg31,
    arg32
) -- line: 143
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] Utility_m (copy)

    local v14 = "RaycastWhitelist" .. (arg26 or "")
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Include
    overlapParams.FilterDescendantsInstances = CollectionService:GetTagged("Knockbackable")

    for _, val_3 in pairs(workspace:GetPartBoundsInRadius(arg27, arg28, overlapParams)) do
        local v16 = val_3.Position - arg27
        local v17 = v14

        if
            not val_3.Anchored
            and not val_3.Position:FuzzyEq(arg27)
            and (if not arg31 then val_3:HasTag(v17) else if not arg32 then val_3:HasTag(v17) else not (arg32 < Utility_m:AngleBetweenVectors(
                arg31,
                v16
            )) and val_3:HasTag(v17))
        then
            if val_3:HasTag("TrowelBrick") then
                val_3.CustomPhysicalProperties = PhysicalProperties.new(
                    0.1,
                    val_3.CurrentPhysicalProperties.Friction,
                    val_3.CurrentPhysicalProperties.Elasticity
                )
            end

            local v18 = arg30 or (val_3.Position - arg27).Unit * arg29 * (1 - (val_3.Position - arg27).Magnitude / arg28)
            val_3.Velocity = v18
        end
    end
end

function t.GetRaycastRedirection(
    arg33,
    arg34,
    arg35,
    arg36,
    arg37,
    arg38
) -- line: 167
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg38 <= 0 then
        return arg36
    end

    local t_3 = {}
    arg33:GetEntitiesWithinSphere(
        arg34,
        arg35,
        arg37,
        128,
        false,
        nil,
        nil,
        nil,
        function(arg39) -- line: 174
            -- upvalues:
            --  [1] arg37 (copy)
            --  [2] Utility_m (ref)
            --  [3] arg36 (copy)
            --  [4] t_3 (copy)

            local LookVector = CFrame.new(arg37, arg39.RootPart.Position).LookVector
            local t_4 = {
                Entity = arg39,
                LookDir = LookVector,
                Angle = Utility_m:AngleBetweenVectors(arg36, LookVector)
            }
            table.insert(t_3, t_4)
        end
    )
    table.sort(t_3, function(arg40, arg41) -- line: 185
        return arg40.Angle < arg41.Angle
    end)

    return t_3[1] and arg38 > t_3[1].Angle and t_3[1].LookDir or arg36
end

function t.SwitchingWeaponsMakesSense(arg42, arg43, arg44) -- line: 192
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] ShopLibrary_m (copy)
    --  [3] CONSTANTS_m (copy)

    local t_5 = {}

    for key_4, _ in pairs(ItemLibrary_m.Classes) do
        t_5[key_4] = {}
    end

    for _, val_5 in pairs(
        ShopLibrary_m:GetReleasedOwnableWeapons(CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET)
    ) do
        local _ = ItemLibrary_m.Items[val_5].Class

        for key_6, val_6 in pairs(ItemLibrary_m.Classes) do
            if arg42:CanUseWeapon(arg43, arg44, val_5, val_6.Slot) then
                table.insert(t_5[key_6], val_5)

                if #t_5[key_6] > 1 then
                    return true
                end
            end
        end
    end

    return false
end

function t.CanUseWeapon(
    arg45,
    arg46,
    arg47,
    arg48,
    arg49
) -- line: 216
    -- upvalues:
    --  [1] ShopLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] ItemLibrary_m (copy)

    if not arg48 or not arg46 or not arg47 then
        return false
    end

    local v22 = arg46:Get("WeaponPool")
    local v23 = arg46:Get("WeaponPoolFilterType")
    local v24 = v22

    if v24 then
        v24 = if v23 ~= "Whitelist" then false else table.find(v22, arg48)
    end

    if
        not table.find(
            ShopLibrary_m:GetReleasedOwnableWeapons(CONSTANTS_m.WEAPON_EARLY_ACCESS_TIME_OFFSET),
            arg48
        )
        and not v24
    then
        return false
    end

    v24 = arg47:GetWeaponData(arg48)

    if not v24 then
        v24 = arg46:Get("IsInShootingRange")

        if not v24 then
            v24 = arg46:Get("CanUseLockedWeapons")

            if not v24 then
                v24 = arg45:_CanUseWeaponFromFFlag(arg48)

                if not v24 then
                    v24 = table.find(arg46:Get("FreeWeaponTrials") or {}, arg48)
                end
            end
        end
    end

    if not v24 then
        return false
    end

    if v22 then
        if
            v23 == "Whitelist" and not table.find(v22, arg48)
            or v23 == "Blacklist" and table.find(v22, arg48)
        then
            return false
        end
    end

    if
        arg49
        and ItemLibrary_m.SlotToClass[arg49].Name ~= ItemLibrary_m.Items[arg48].Class
        and not arg46:Get("WeaponClassRestrictionDisabled")
    then
        return false
    end

    return true
end

function t.GetSpread(
    _,
    arg51,
    arg52,
    arg53,
    arg54,
    arg55,
    arg56,
    arg57
) -- line: 260
    local v26 = arg53 and arg52 or 1
    local v27 = if not arg54 then 1 else 0.75
    local minimum = math.min(v26, v27)
    v26 = math.rad(arg51) * minimum

    if arg57 and arg56 and arg56 > 1 and arg55 == 1 then
        return CFrame.identity
    end

    if arg57 and arg56 and arg56 > 1 and arg55 ~= nil then
        v26 /= 0.75

        if arg55 % 2 == 0 then
            return CFrame.Angles(0, 0, 6.283185307179586 / (arg56 - 1) * arg55) * CFrame.Angles(
                v26 / 2 / 2,
                0,
                0
            )
        end

        return CFrame.Angles(0, 0, 6.283185307179586 / (arg56 - 1) * arg55) * CFrame.Angles(
            v26 / 2,
            0,
            0
        )
    end

    return CFrame.Angles(0, 0, 6.283185307179586 * math.random()) * CFrame.Angles(
        v26 * math.random(),
        0,
        0
    )
end

function t.IsInWhitelist(_, arg59, arg60) -- line: 284
    for _, val_7 in pairs(arg60) do
        if arg59 == val_7 or val_7:IsA("Instance") and arg59:IsDescendantOf(val_7) then
            return true
        end
    end

    return false
end

function t.GetMousePositionFromCameraData(
    arg61,
    arg62,
    arg63,
    _,
    arg65,
    arg66,
    arg67,
    arg68
) -- line: 294
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    local v33
    local v29 = arg66
    local v30

    if v29 then
        local v31 = arg66.CFrame
        v30 = arg67 or CFrame.identity
        v29 = v31 * v30
    end

    local v32 = v29 and CFrame.new(arg65.Position, v29.Position) or arg65
    v30 = arg68 or CFrame.identity
    v29 = v32 * v30
    v30, v33 = arg61:GetEntitiesFromRaycast(
        arg62,
        arg63,
        v29.Position,
        v29.LookVector,
        CONSTANTS_m.MAX_RAYCAST_DISTANCE
    )

    return v33.Position
end

function t.GetMouseLocationFromCameraData(
    _,
    arg70,
    arg71,
    arg72,
    arg73,
    arg74,
    arg75,
    arg76
) -- line: 303
    -- upvalues:
    --  [1] t (copy)
    --  [2] Utility_m (copy)

    local v34 = t:GetRaycastWhitelist(arg74, arg76)
    local v35 = arg72

    if v35 then
        v35 = arg72.CFrame * (arg73 or CFrame.identity)
    end

    local v38 = v35 and CFrame.new(arg71.Position, v35.Position) or arg71
    v35 = nil

    for _ = 1, 10 do
        v35 = Utility_m:Raycast(
            arg70.Position,
            Utility_m:Raycast(
                v38.Position,
                v38.Position + v38.LookVector,
                arg75,
                v34,
                Enum.RaycastFilterType.Include
            ).Position,
            arg75,
            v34,
            Enum.RaycastFilterType.Include
        )

        if not v35.Instance or v35.Instance.Transparency < 0.99 then
            break
        end

        table.insert(v34, v35.Instance)
    end

    return v35
end

function t.GetRaycastWhitelist(
    arg77,
    arg78,
    arg79,
    arg80,
    arg81
) -- line: 325
    -- upvalues:
    --  [1] CollectionService (copy)

    local v40 = arg81 and {} or CollectionService:GetTagged("RaycastWhitelist" .. (arg78 or ""))

    if not arg79 then
        return v40
    end

    local v42 = arg80 or {}
    local t_6 = {}

    for _, val_8 in pairs(CollectionService:GetTagged("Entity")) do
        local v44 = arg77:GetEntityFromModel(val_8)

        if not v42[v44] and arg79:IsValidTarget(v44) and v44:Get("EnvironmentID") == arg78 then
            for _, val_9 in pairs(v44:GetHitboxes(arg79.GrabSmallHitboxes)) do
                table.insert(v40, val_9)
                t_6[val_9] = v44
            end
        end
    end

    return v40, t_6
end

function t.GetEntityFromModel(_, arg83) -- line: 351
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ServerStorage (copy)
    --  [3] Players (copy)

    local v47

    if CONSTANTS_m.IS_SERVER then
        local FighterService_m = require(ServerStorage.Services.FighterService)
        local EnemyService_m = require(ServerStorage.Services.EnemyService)
        local v46 = FighterService_m:GetFighter(arg83)
        v47 = v46 and v46.Entity or EnemyService_m:GetEnemy(arg83)

        return v47
    end

    if CONSTANTS_m.IS_CLIENT then
        local FighterController_m = require(
            Players.LocalPlayer.PlayerScripts.Controllers.FighterController
        )
        local EnemyController_m = require(
            Players.LocalPlayer.PlayerScripts.Controllers.EnemyController
        )
        local v48 = FighterController_m:GetFighter(arg83)
        v47 = v48 and v48.Entity or EnemyController_m:GetEnemy(arg83)

        return v47
    end
end

function t.GetEntityFromTouch(arg84, arg85, arg86, arg87) -- line: 368
    local v50 = arg84:GetEntityFromModel((arg84:IsEntity(arg87)))

    if v50 and v50:Get("EnvironmentID") == arg85 and arg86:IsValidTarget(v50) then
        return v50
    end
end

function t.GetEntitiesWithinSphere(
    arg88,
    arg89,
    arg90,
    arg91,
    arg92,
    arg93,
    arg94,
    arg95,
    arg96,
    arg97,
    arg98
) -- line: 383
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Utility_m (copy)

    local v51

    if arg98 then
        v51 = tonumber(arg98) or tonumber(false) or 30
        local Part = Instance.new("Part")
        Part.Color = Color3.fromRGB(255, 0, 0)
        Part.Material = Enum.Material.ForceField
        Part.CanTouch = false
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CastShadow = false
        Part.Anchored = true
        Part.Shape = Enum.PartType.Ball
        Part.Size = Vector3.new(1, 1, 1) * arg92 * 2
        Part.CFrame = CFrame.new(arg91)
        Part.Parent = workspace
        BetterDebris_m:AddItem(Part, v51)
        local Part_1 = Instance.new("Part")
        Part_1.Color = Color3.fromRGB(255, 0, 0)
        Part_1.Material = Enum.Material.Neon
        Part_1.CanTouch = false
        Part_1.CanCollide = false
        Part_1.CanQuery = false
        Part_1.CastShadow = false
        Part_1.Anchored = true
        Part_1.Shape = Enum.PartType.Ball
        Part_1.Size = Vector3.new(0.1, 0.1, 0.1)
        Part_1.CFrame = CFrame.new(arg91)
        Part_1.Parent = workspace
        BetterDebris_m:AddItem(Part_1, v51)
    end

    v51 = OverlapParams.new()
    v51.FilterType = Enum.RaycastFilterType.Include
    v51.FilterDescendantsInstances = arg88:GetRaycastWhitelist(arg89, arg90, nil, true)
    local v52 = not arg93

    if v52 then
        v52 = arg88:GetRaycastWhitelist(arg89)
    end

    local v53 = not arg93 and Enum.RaycastFilterType.Include
    local t_7 = {}

    for _, val_10 in pairs(workspace:GetPartBoundsInRadius(arg91, arg92, v51)) do
        local v55 = val_10:GetAttribute("IsAssemblyRootPart") and val_10 or val_10.AssemblyRootPart or val_10
        local v56 = val_10.Position - arg91

        if
            not t_7[v55]
            and (not arg94 or not arg95 or not ((val_10.Position - arg91).Magnitude > (arg96 or 3)) or not (arg95 < Utility_m:AngleBetweenVectors(
                arg94,
                v56
            )))
        then
            local v57 = arg88:GetEntityFromTouch(arg89, arg90, val_10)

            if
                v57
                and not t_7[v57]
                and v57:IsAlive()
                and (arg93 or not Utility_m:Raycast(
                    arg91,
                    val_10.Position,
                    (arg91 - val_10.Position).Magnitude,
                    v52,
                    v53
                ).Instance)
            then
                t_7[v57] = true
                t_7[v55] = true
                task.spawn(arg97, v57, val_10)
            end
        end
    end
end

function t.GetEntitiesFromPoint(
    arg99,
    arg100,
    arg101,
    arg102,
    arg103
) -- line: 454
    local t_8 = {}
    arg99:GetEntitiesWithinSphere(
        arg100,
        arg101,
        arg102,
        arg103 or 0,
        nil,
        nil,
        nil,
        nil,
        function(arg104, arg105) -- line: 457
            -- upvalues:
            --  [1] t_8 (copy)

            table.insert(t_8, { Entity = arg104, Hitbox = arg105 })
        end
    )

    return t_8
end

function t.GetEntitiesFromRaycast(
    arg106,
    arg107,
    arg108,
    arg109,
    arg110,
    arg111,
    arg112,
    arg113,
    arg114,
    arg115
) -- line: 468
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] BetterDebris_m (copy)

    local v58 = arg112 or 0
    local v59 = arg113 or 0
    local v60 = arg114 and Utility_m:CloneTable(arg114, true) or {}
    local t_10 = {}
    local v61 = nil
    local v62 = nil
    local v63 = 1

    while true do
        if not (v63 <= 1 + v59) then
            break
        end

        local v64, v65 = arg106:GetRaycastWhitelist(arg107, arg108, v60)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = v64
        raycastParams.FilterType = Enum.RaycastFilterType.Include
        raycastParams.IgnoreWater = true
        v64 = if v58 > 0 then workspace:Spherecast(arg109, v58, arg110 * arg111, raycastParams) else workspace:Raycast(
            arg109,
            arg110 * arg111,
            raycastParams
        )
        local v68 = Utility_m:MakeSafeRaycastResult(v64, arg109, arg110, arg111)
        v64 = v65[v68.Instance]
        v61 = v61 or v68

        if v64 then
            local t_11 = { Entity = v64, Hitbox = nil, RaycastResult = nil, IsFromPoint = nil }
            t_11.Hitbox, t_11.RaycastResult = v68.Instance, v68
            table.insert(t_10, t_11)
            v60[v64], v62 = true, v68

            if v64.Model:GetAttribute("PierceThrough") then
                v59 += 1
            end
        else
            v62 = v68
            break
        end

        v63 += 1
    end

    arg106:GetEntitiesWithinSphere(
        arg107,
        arg108,
        arg109,
        v58,
        nil,
        nil,
        nil,
        nil,
        function(arg116, arg117) -- line: 517
            -- upvalues:
            --  [1] t_10 (copy)
            --  [2] v61 (ref)

            table.insert(
                t_10,
                { Entity = arg116, Hitbox = arg117, RaycastResult = v61, IsFromPoint = true }
            )
        end
    )

    if v62 and arg115 then
        v63 = (v62.Position - arg109).Magnitude
        v60 = Instance.new("Part")
        v60.Color = Color3.fromRGB(255, 0, 0)
        v60.Material = Enum.Material.ForceField
        v60.CanTouch = false
        v60.CanCollide = false
        v60.CanQuery = false
        v60.CastShadow = false
        v60.Anchored = true
        v60.Size = Vector3.new(0.1, 0.1, v63)
        v60.CFrame = CFrame.new(arg109, v62.Position) * CFrame.new(0, 0, -v63 / 2)
        v60.Parent = workspace
        BetterDebris_m:AddItem(v60, 10)
    end

    return t_10, v62
end

function t.GetJumpPadPlacement(
    arg118,
    arg119,
    arg120,
    arg121,
    arg122,
    arg123,
    arg124
) -- line: 540
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] t (copy)

    local v69 = arg118:GetRaycastWhitelist(arg119)
    local v70 = arg123

    if v70 then
        v70 = arg123.CFrame * (arg124 or CFrame.identity)
    end

    local v73 = v70 and CFrame.new(arg122.Position, v70.Position) or arg122

    if v73 ~= v73 then
        v73 = CFrame.new(arg122.Position)
    end

    local v74 = v73.Position + v73.LookVector * CONSTANTS_m.MAX_RAYCAST_DISTANCE
    local v75 = arg121.Position + (Utility_m:Raycast(
        v73.Position,
        v74,
        CONSTANTS_m.MAX_RAYCAST_DISTANCE,
        v69,
        Enum.RaycastFilterType.Include
    ).Position - arg121.Position).Unit * arg120
    v73 = Utility_m:Raycast(
        arg121.Position,
        v75,
        arg120,
        v69,
        Enum.RaycastFilterType.Include
    )

    if
        not v73.Instance
        or v73.Instance:HasTag("Barrier")
        or Utility_m:IsWithinTaggedParts("Barrier", v73.Position)
        or t:IsWithinOOBPart(v73.Position)
    then
        return v73, nil
    end

    local v77 = CFrame.new(v73.Position, v73.Position + v73.Normal) * CFrame.Angles(
        -1.5707963267948966,
        0,
        0
    ) * CFrame.new(arg121.Position * Vector3.new(1, 0, 1), v73.Position * Vector3.new(1, 0, 1)).Rotation

    return v73, v77 * CFrame.Angles(1.5707963267948966, 0, 0)
end

function t.GetSubspaceTripminePlacement(_, arg126, arg127, arg128) -- line: 563
    local v78 = arg127:FuzzyEq(arg128) and arg127 or arg128 + (arg127 - arg128).Unit * math.min(
        arg126,
        (arg127 - arg128).Magnitude
    )
    local v79 = v78:FuzzyEq(arg128) and CFrame.identity or CFrame.new(
        v78 * Vector3.new(1, 0, 1),
        arg128 * Vector3.new(1, 0, 1)
    )

    return CFrame.new(v78) * v79.Rotation
end

function t.GetOOBWarnDelay(arg129, arg130) -- line: 571
    local v80 = arg130 or arg129.OOB_DEFAULT_WARN_DELAY

    if v80 == -1 then
        return math.huge
    end

    return v80
end

function t.GetOOBKillDelay(arg131, arg132) -- line: 576
    local v81 = arg132 or arg131.OOB_DEFAULT_KILL_DELAY

    if v81 == -1 then
        return math.huge
    end

    return v81
end

function t.IsWithinOOBPart(arg133, arg134, arg135) -- line: 581
    -- upvalues:
    --  [1] Utility_m (copy)

    if Utility_m:IsWithinTaggedParts("OutOfBoundsSafePart", arg134) then
        return nil
    end

    local v82 = Utility_m:IsWithinTaggedParts("OutOfBoundsPart", arg134, arg135, true)
    table.sort(v82, function(arg136, arg137) -- line: 590
        -- upvalues:
        --  [1] arg133 (copy)

        local v86 = arg133:GetOOBWarnDelay(arg136:GetAttribute("WarnDelay")) + arg133:GetOOBKillDelay(
            arg136:GetAttribute("KillDelay")
        )
        local v88 = arg133:GetOOBWarnDelay(arg137:GetAttribute("WarnDelay"))

        if not (v86 < v88 + arg133:GetOOBKillDelay(arg137:GetAttribute("KillDelay"))) then
            v88 = false
        else
            v88 = true
        end

        return v88
    end)

    return v82[1]
end

function t._CanUseWeaponFromFFlag(_, arg139) -- line: 604
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ServerStorage (copy)
    --  [3] Players (copy)
    --  [4] ItemLibrary_m (copy)

    local Success, Result = pcall(function() -- line: 606
        -- upvalues:
        --  [1] CONSTANTS_m (ref)
        --  [2] ServerStorage (ref)
        --  [3] Players (ref)
        --  [4] ItemLibrary_m (ref)
        --  [5] arg139 (copy)

        return (if not CONSTANTS_m.IS_SERVER then require(
            Players.LocalPlayer.PlayerScripts.Controllers.FFlagController
        ) else require(ServerStorage.Services.FFlagService)):GetFFlag(
            "FreeToUse" .. ItemLibrary_m.Items[arg139].Status .. "Weapons"
        )
    end)

    if not Success then
        warn("Failed to fetch FreeWeapons FFlag")
    end

    return Success and Result
end

function t._Init(_) -- line: 620
end

return t._new()
