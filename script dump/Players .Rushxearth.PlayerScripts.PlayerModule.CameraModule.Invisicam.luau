local Players = game:GetService("Players")
local UserRaycastUpdateAPI2 = require(
    script.Parent.Parent:WaitForChild("CommonUtils"):WaitForChild("FlagUtil")
).getUserFlag("UserRaycastUpdateAPI2")
local t = {
    LIMBS = 2,
    MOVEMENT = 3,
    CORNERS = 4,
    CIRCLE1 = 5,
    CIRCLE2 = 6,
    LIMBMOVE = 7,
    SMART_CIRCLE = 8,
    CHAR_OUTLINE = 9
}
local t_1 = {
    Head = true,
    ["Left Arm"] = true,
    ["Right Arm"] = true,
    ["Left Leg"] = true,
    ["Right Leg"] = true,
    LeftLowerArm = true,
    RightLowerArm = true,
    LeftUpperLeg = true,
    RightUpperLeg = true
}
local t_2 = {
    Vector3.new(1, 1, -1),
    Vector3.new(1, -1, -1),
    Vector3.new(-1, -1, -1),
    Vector3.new(-1, 1, -1)
}
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local raycastParams_1 = RaycastParams.new()
raycastParams_1.FilterType = Enum.RaycastFilterType.Include

local function AssertTypes(arg1, ...) -- line: 71
    local t_3 = {}
    local v1 = ""

    for _, val in pairs({ ... }) do
        local v2
        t_3[val], v2 = true, v1
        v1 = v2 .. (if v1 ~= "" then " or " else "") .. val
    end

    local typeName = type(arg1)
    assert(t_3[typeName], v1 .. " type expected, got: " .. typeName)
end

local _ = function(
    n1: number,
    n2: number,
    n3: number,
    n4: number,
    n5: number,
    n6: number,
    n7: number,
    n8: number,
    n9: number
) --[[ Det3x3 ]] -- line: 83
    return n1 * (n5 * n9 - n6 * n8) - n2 * (n4 * n9 - n6 * n7) + n3 * (n4 * n8 - n5 * n7)
end

local function RayIntersection(vec1: Vector3, vec2: Vector3, vec3: Vector3, vec4: Vector3) -- line: 91
    local v4 = vec2:Cross(vec4)
    local v5 = vec3.X - vec1.X
    local v6 = vec3.Y - vec1.Y
    local v7 = vec3.Z - vec1.Z
    local Y = vec2.Y
    local v8 = -vec4.Y
    local Y_1 = v4.Y
    local Z = vec2.Z
    local v9 = -vec4.Z
    local Z_1 = v4.Z
    local v10 = vec2.X * (v8 * Z_1 - Y_1 * v9) - -vec4.X * (Y * Z_1 - Y_1 * Z) + v4.X * (Y * v9 - v8 * Z)

    if v10 == 0 then
        return Vector3.new(0, 0, 0)
    end

    local v11 = -vec4.Y
    local Y_2 = v4.Y
    local v12 = -vec4.Z
    local Z_2 = v4.Z
    local Y_3 = vec2.Y
    local Y_4 = v4.Y
    local Z_3 = vec2.Z
    local Z_4 = v4.Z
    local v13 = (v5 * (v11 * Z_2 - Y_2 * v12) - -vec4.X * (v6 * Z_2 - Y_2 * v7) + v4.X * (v6 * v12 - v11 * v7)) / v10 * vec2
    local v14 = vec1 + v13
    local v15 = (vec2.X * (v6 * Z_4 - Y_4 * v7) - v5 * (Y_3 * Z_4 - Y_4 * Z_3) + v4.X * (Y_3 * v7 - v6 * Z_3)) / v10 * vec4
    local v16 = vec3 + v15

    if (v16 - v14).Magnitude < 0.25 then
        return v14 + (v16 - v14) * 0.5
    end

    return Vector3.new(0, 0, 0)
end

local BaseOcclusion_m = require(script.Parent:WaitForChild("BaseOcclusion"))
local t_5 = setmetatable({}, BaseOcclusion_m)
t_5.__index = t_5

function t_5.new() -- line: 124
    -- upvalues:
    --  [1] BaseOcclusion_m (copy)
    --  [2] t_5 (copy)
    --  [3] t (copy)

    local t_6 = setmetatable(BaseOcclusion_m.new(), t_5)
    t_6.char = nil
    t_6.humanoidRootPart = nil
    t_6.torsoPart = nil
    t_6.headPart = nil
    t_6.childAddedConn = nil
    t_6.childRemovedConn = nil
    t_6.behaviors = {}
    t_6.behaviors[t.LIMBS] = t_6.LimbBehavior
    t_6.behaviors[t.MOVEMENT] = t_6.MoveBehavior
    t_6.behaviors[t.CORNERS] = t_6.CornerBehavior
    t_6.behaviors[t.CIRCLE1] = t_6.CircleBehavior
    t_6.behaviors[t.CIRCLE2] = t_6.CircleBehavior
    t_6.behaviors[t.LIMBMOVE] = t_6.LimbMoveBehavior
    t_6.behaviors[t.SMART_CIRCLE] = t_6.SmartCircleBehavior
    t_6.behaviors[t.CHAR_OUTLINE] = t_6.CharacterOutlineBehavior
    t_6.mode = t.SMART_CIRCLE
    t_6.behaviorFunction = t_6.SmartCircleBehavior
    t_6.savedHits = {}
    t_6.trackedLimbs = {}
    t_6.camera = game.Workspace.CurrentCamera
    t_6.enabled = false

    return t_6
end

function t_5.Enable(arg2, arg3) -- line: 157
    arg2.enabled = arg3

    if not arg3 then
        arg2:Cleanup()
    end
end

function t_5.GetOcclusionMode(_) -- line: 165
    return Enum.DevCameraOcclusionMode.Invisicam
end

function t_5.LimbBehavior(arg5, arg6) -- line: 170
    for key_1, _ in pairs(arg5.trackedLimbs) do
        arg6[#arg6 + 1] = key_1.Position
    end
end

function t_5.MoveBehavior(arg7, arg8) -- line: 176
    for index = 1, 3 do
        local Velocity = arg7.humanoidRootPart.Velocity
        arg8[#arg8 + 1] = arg7.humanoidRootPart.Position + (index - 1) * arg7.humanoidRootPart.CFrame.lookVector * (Vector3.new(
            Velocity.X,
            0,
            Velocity.Z
        ).Magnitude / 2)
    end
end

function t_5.CornerBehavior(arg9, arg10) -- line: 185
    -- upvalues:
    --  [1] t_2 (copy)

    local v19 = arg9.humanoidRootPart.CFrame
    local Position_1 = v19.Position
    local v20 = v19 - Position_1
    local v21 = arg9.char:GetExtentsSize() / 2
    arg10[#arg10 + 1] = Position_1

    for index_1 = 1, #t_2 do
        arg10[#arg10 + 1] = Position_1 + v20 * (v21 * t_2[index_1])
    end
end

function t_5.CircleBehavior(arg11, arg12) -- line: 196
    -- upvalues:
    --  [1] t (copy)

    local v22 = if arg11.mode ~= t.CIRCLE1 then arg11.camera.CoordinateFrame - arg11.camera.CoordinateFrame.Position + arg11.humanoidRootPart.Position else arg11.humanoidRootPart.CFrame
    arg12[#arg12 + 1] = v22.Position

    for index_2 = 0, 9 do
        local v23 = 0.6283185307179586 * index_2
        local cosine = math.cos(v23)
        arg12[#arg12 + 1] = v22 * (Vector3.new(cosine, math.sin(v23), 0) * 3)
    end
end

function t_5.LimbMoveBehavior(arg13, arg14) -- line: 212
    arg13:LimbBehavior(arg14)
    arg13:MoveBehavior(arg14)
end

function t_5.CharacterOutlineBehavior(arg15, arg16) -- line: 217
    -- upvalues:
    --  [1] UserRaycastUpdateAPI2 (copy)
    --  [2] raycastParams_1 (copy)

    local Unit = arg15.torsoPart.CFrame.upVector.unit
    local Unit_1 = arg15.torsoPart.CFrame.rightVector.unit
    arg16[#arg16 + 1] = arg15.torsoPart.CFrame.p
    arg16[#arg16 + 1] = arg15.torsoPart.CFrame.p + Unit
    arg16[#arg16 + 1] = arg15.torsoPart.CFrame.p - Unit
    arg16[#arg16 + 1] = arg15.torsoPart.CFrame.p + Unit_1
    arg16[#arg16 + 1] = arg15.torsoPart.CFrame.p - Unit_1

    if arg15.headPart then
        arg16[#arg16 + 1] = arg15.headPart.CFrame.p
    end

    local cframe = CFrame.new(
        Vector3.new(0, 0, 0),
        (Vector3.new(
            arg15.camera.CoordinateFrame.lookVector.X,
            0,
            arg15.camera.CoordinateFrame.lookVector.Z
        ))
    )
    local v25 = arg15.torsoPart and arg15.torsoPart.Position or arg15.humanoidRootPart.Position
    local t_7 = { arg15.torsoPart }

    if arg15.headPart then
        t_7[#t_7 + 1] = arg15.headPart
    end

    for index_3 = 1, 24 do
        local v26 = 6.283185307179586 * index_3 / 24
        local cosine_1 = math.cos(v26)
        local v27 = cframe * (Vector3.new(cosine_1, math.sin(v26), 0) * 3)
        local vec3_1 = Vector3.new(v27.X, math.max(v27.Y, -2.25), v27.Z)

        if UserRaycastUpdateAPI2 then
            raycastParams_1.FilterDescendantsInstances = t_7
            local raycastResult = game.Workspace:Raycast(v25 + vec3_1, -3 * vec3_1, raycastParams_1)

            if raycastResult then
                local Position_2 = raycastResult.Position
                arg16[#arg16 + 1] = Position_2 + 0.2 * (v25 - Position_2).unit
            end
        else
            local v31, v32 = game.Workspace:FindPartOnRayWithWhitelist(
                Ray.new(v25 + vec3_1, -3 * vec3_1),
                t_7,
                false
            )

            if v31 then
                arg16[#arg16 + 1] = v32 + 0.2 * (v25 - v32).unit
            end
        end
    end
end

function t_5.SmartCircleBehavior(arg17, arg18) -- line: 268
    -- upvalues:
    --  [1] UserRaycastUpdateAPI2 (copy)
    --  [2] raycastParams (copy)
    --  [3] RayIntersection (copy)

    local Unit_2 = arg17.torsoPart.CFrame.upVector.unit
    local Unit_3 = arg17.torsoPart.CFrame.rightVector.unit
    arg18[#arg18 + 1] = arg17.torsoPart.CFrame.p
    arg18[#arg18 + 1] = arg17.torsoPart.CFrame.p + Unit_2
    arg18[#arg18 + 1] = arg17.torsoPart.CFrame.p - Unit_2
    arg18[#arg18 + 1] = arg17.torsoPart.CFrame.p + Unit_3
    arg18[#arg18 + 1] = arg17.torsoPart.CFrame.p - Unit_3

    if arg17.headPart then
        arg18[#arg18 + 1] = arg17.headPart.CFrame.p
    end

    local v33 = arg17.camera.CFrame - arg17.camera.CFrame.p
    local v36 = Vector3.new(0, 0.5, 0) + (arg17.torsoPart and arg17.torsoPart.Position or arg17.humanoidRootPart.Position)

    for index_4 = 1, 24 do
        local v37 = 0.2617993877991494 * index_4 - 1.5707963267948966
        local cosine_2 = math.cos(v37)
        local v38 = v36 + v33 * (Vector3.new(cosine_2, math.sin(v37), 0) * 2.5)
        local v39 = v38 - arg17.camera.CFrame.p

        if UserRaycastUpdateAPI2 then
            raycastParams.FilterDescendantsInstances = { arg17.char }
            local raycastResult_1 = game.Workspace:Raycast(v36, v38 - v36, raycastParams)
            local v41 = v38

            if raycastResult_1 then
                local Normal = raycastResult_1.Normal
                local v42 = raycastResult_1.Position + 0.1 * Normal.unit
                local v43 = v42 - v36
                local Unit_4 = v43:Cross(v39).unit:Cross(Normal).unit
                local v44 = -Unit_4
                local Unit_5 = (v42 - arg17.camera.CFrame.p).unit

                if v43.unit:Dot(v44) < v43.unit:Dot(Unit_5) then
                    v41 = RayIntersection(v42, Unit_4, v38, v39)

                    if v41.Magnitude > 0 then
                        local raycastResult_2 = game.Workspace:Raycast(
                            v42,
                            v41 - v42,
                            raycastParams
                        )

                        if raycastResult_2 then
                            v41 = raycastResult_2.Position + 0.1 * raycastResult_2.Normal.Unit
                        end
                    else
                        v41 = v42
                    end
                else
                    v41 = v42
                end

                local raycastResult_3 = game.Workspace:Raycast(v36, v41 - v36, raycastParams)

                if raycastResult_3 then
                    v41 = raycastResult_3.Position - 0.1 * (v41 - v36).unit
                end
            end

            arg18[#arg18 + 1] = v41
        else
            local ray_3 = Ray.new(v36, v38 - v36)
            local v50, v51
            v50, v51, ray_3 = game.Workspace:FindPartOnRayWithIgnoreList(
                ray_3,
                { arg17.char },
                false,
                false
            )
            local v48 = v38

            if v50 then
                local v52 = v51 + 0.1 * ray_3.unit
                local v53 = v52 - v36
                local Unit_6 = v53:Cross(v39).unit:Cross(ray_3).unit
                local v54 = -Unit_6
                local Unit_7 = (v52 - arg17.camera.CFrame.p).unit

                if v53.unit:Dot(v54) < v53.unit:Dot(Unit_7) then
                    v48 = RayIntersection(v52, Unit_6, v38, v39)

                    if v48.Magnitude > 0 then
                        local ray_4 = Ray.new(v52, v48 - v52)
                        local v57, v58
                        v57, v58, ray_4 = game.Workspace:FindPartOnRayWithIgnoreList(
                            ray_4,
                            { arg17.char },
                            false,
                            false
                        )

                        if v57 then
                            v48 = v58 + 0.1 * ray_4.unit
                        end
                    else
                        v48 = v52
                    end
                else
                    v48 = v52
                end

                local ray_5 = Ray.new(v36, v48 - v36)
                local v60, v61
                v60, v61, ray_5 = game.Workspace:FindPartOnRayWithIgnoreList(
                    ray_5,
                    { arg17.char },
                    false,
                    false
                )

                if v60 then
                    v48 = v61 - 0.1 * (v48 - v36).unit
                end
            end

            arg18[#arg18 + 1] = v48
        end
    end
end

function t_5.CheckTorsoReference(arg19) -- line: 403
    if arg19.char then
        arg19.torsoPart = arg19.char:FindFirstChild("Torso")

        if not arg19.torsoPart then
            arg19.torsoPart = arg19.char:FindFirstChild("UpperTorso")

            if not arg19.torsoPart then
                arg19.torsoPart = arg19.char:FindFirstChild("HumanoidRootPart")
            end
        end

        arg19.headPart = arg19.char:FindFirstChild("Head")
    end
end

function t_5.CharacterAdded(t1: table, u1: userdata, u2: userdata) -- line: 417
    -- upvalues:
    --  [1] Players (copy)
    --  [2] t_1 (copy)

    if u2 ~= Players.LocalPlayer then
        return
    end

    if t1.childAddedConn then
        t1.childAddedConn:Disconnect()
        t1.childAddedConn = nil
    end

    if t1.childRemovedConn then
        t1.childRemovedConn:Disconnect()
        t1.childRemovedConn = nil
    end

    t1.char = u1
    t1.trackedLimbs = {}

    local function childAdded(arg20) -- line: 433
        -- upvalues:
        --  [1] t_1 (ref)
        --  [2] t1 (copy)

        if arg20:IsA("BasePart") then
            if t_1[arg20.Name] then
                t1.trackedLimbs[arg20] = true
            end

            if arg20.Name == "Torso" or arg20.Name == "UpperTorso" then
                t1.torsoPart = arg20
            end

            if arg20.Name == "Head" then
                t1.headPart = arg20
            end
        end
    end

    local function childRemoved(arg21) -- line: 449
        -- upvalues:
        --  [1] t1 (copy)

        t1.trackedLimbs[arg21] = nil
        t1:CheckTorsoReference()
    end

    t1.childAddedConn = u1.ChildAdded:Connect(childAdded)
    t1.childRemovedConn = u1.ChildRemoved:Connect(childRemoved)

    for _, val_2 in pairs(t1.char:GetChildren()) do
        if val_2:IsA("BasePart") then
            if t_1[val_2.Name] then
                t1.trackedLimbs[val_2] = true
            end

            if val_2.Name == "Torso" or val_2.Name == "UpperTorso" then
                t1.torsoPart = val_2
            end

            if val_2.Name == "Head" then
                t1.headPart = val_2
            end
        end
    end
end

function t_5.SetMode(t2: table, n10: number) -- line: 463
    -- upvalues:
    --  [1] AssertTypes (copy)
    --  [2] t (copy)

    AssertTypes(n10, "number")

    for _, val_3 in pairs(t) do
        if val_3 == n10 then
            t2.mode = n10
            t2.behaviorFunction = t2.behaviors[t2.mode]

            return
        end
    end

    error("Invalid mode number")
end

function t_5.GetObscuredParts(arg22) -- line: 475
    return arg22.savedHits
end

function t_5.Cleanup(arg23) -- line: 480
    for key_4, val_4 in pairs(arg23.savedHits) do
        key_4.LocalTransparencyModifier = val_4
    end
end

function t_5.Update(t3: table, _: number, u3: CFrame, u4: CFrame) -- line: 486
    if not t3.enabled or not t3.char then
        return u3, u4
    end

    t3.camera = game.Workspace.CurrentCamera

    if not t3.humanoidRootPart then
        local Humanoid = t3.char:FindFirstChildOfClass("Humanoid")
        local Char
        local v63

        if Humanoid then
            if Humanoid.RootPart then
                t3.humanoidRootPart = Humanoid.RootPart
            else
                Char = t3.char:FindFirstChild("HumanoidRootPart")
                t3.humanoidRootPart = Char

                if not t3.humanoidRootPart then
                    return u3, u4
                end
            end

            v63 = nil
            v63 = t3.humanoidRootPart.AncestryChanged:Connect(function(
                child: Instance,
                parent: Instance
            ) -- line: 511
                -- upvalues:
                --  [1] t3 (copy)
                --  [2] v63 (ref)

                if child == t3.humanoidRootPart and not parent then
                    t3.humanoidRootPart = nil

                    if v63 and v63.Connected then
                        v63:Disconnect()
                        v63 = nil
                    end
                end
            end)
        else
            Char = t3.char:FindFirstChild("HumanoidRootPart")
            t3.humanoidRootPart = Char

            if not t3.humanoidRootPart then
                return u3, u4
            end

            v63 = nil
            v63 = t3.humanoidRootPart.AncestryChanged:Connect(function(
                child_1: Instance,
                parent_1: Instance
            ) -- line: 511
                -- upvalues:
                --  [1] t3 (copy)
                --  [2] v63 (ref)

                if child_1 == t3.humanoidRootPart and not parent_1 then
                    t3.humanoidRootPart = nil

                    if v63 and v63.Connected then
                        v63:Disconnect()
                        v63 = nil
                    end
                end
            end)
        end
    end

    if not t3.torsoPart then
        t3:CheckTorsoReference()

        if not t3.torsoPart then
            return u3, u4
        end
    end

    local t_12 = {}
    t3.behaviorFunction(t3, t_12)
    local t_13 = {}
    local t_14 = { t3.char }

    local _ = function(arg28) --[[ add ]] -- line: 537
        -- upvalues:
        --  [1] t_13 (copy)
        --  [2] t3 (copy)

        t_13[arg28] = true

        if not t3.savedHits[arg28] then
            t3.savedHits[arg28] = arg28.LocalTransparencyModifier
        end
    end

    local v64 = 0
    local t_15 = {}
    local v65 = 0.75
    local v66 = 0.75
    local v67 = t3.headPart and t3.headPart.CFrame.p or t_12[1]
    local v68 = t3.torsoPart and t3.torsoPart.CFrame.p or t_12[2]
    local parts = t3.camera:GetPartsObscuringTarget({ v67, v68 }, t_14)

    for index_5 = 1, #parts do
        v68 = parts[index_5]
        v64 += 1
        t_15[v68] = true

        for _, val_5 in pairs(v68:GetChildren()) do
            if val_5:IsA("Decal") or val_5:IsA("Texture") then
                v64 += 1
                break
            end
        end
    end

    if v64 > 0 then
        v65 = math.pow(0.375 / v64 + 0.375, 1 / v64)
        v66 = math.pow(0.25 / v64 + 0.25, 1 / v64)
    end

    local parts_1 = t3.camera:GetPartsObscuringTarget(t_12, t_14)
    v64 = {}

    for index_6 = 1, #parts_1 do
        local v70 = parts_1[index_6]
        local v71 = t_15[v70] and v65 or v66
        v64[v70] = v71

        if v70.Transparency < v64[v70] then
            t_13[v70] = true

            if not t3.savedHits[v70] then
                t3.savedHits[v70] = v70.LocalTransparencyModifier
            end
        end

        for _, val_6 in pairs(v70:GetChildren()) do
            if if val_6:IsA("Decal") then val_6.Transparency < v64[v70] else val_6:IsA("Texture") and val_6.Transparency < v64[v70] then
                v64[val_6] = v64[v70]
                t_13[val_6] = true

                if not t3.savedHits[val_6] then
                    t3.savedHits[val_6] = val_6.LocalTransparencyModifier
                end
            end
        end
    end

    for key_7, val_7 in pairs(t3.savedHits) do
        if t_13[key_7] then
            local v73 = key_7.Transparency < 1 and (v64[key_7] - key_7.Transparency) / (1 - key_7.Transparency) or 0
            key_7.LocalTransparencyModifier = v73
        else
            key_7.LocalTransparencyModifier = val_7
            t3.savedHits[key_7] = nil
        end
    end

    return u3, u4
end

return t_5
