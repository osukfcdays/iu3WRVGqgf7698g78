local Parent = script.Parent
local Humanoid = Parent:WaitForChild("Humanoid")
local v1 = "Standing"
local _ = UserSettings():GetService("UserGameSettings")
local Success, Result = pcall(function() -- line: 9
    return UserSettings():IsUserFeatureEnabled("UserNoUpdateOnLoop")
end)
local _ = Success and Result
local Success_1, Result_1 = pcall(function() -- line: 12
    return UserSettings():IsUserFeatureEnabled("UserAnimateScaleRun")
end)
local v3 = Success_1 and Result_1
local ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent")
local v4 = 0
local v5 = 0
local t = { x = 0, y = 0 }
local v6 = 0
local v7 = ""
local v8 = nil
local v9 = nil
local v10 = nil
local v11 = 1
local t_1 = {}
local t_2 = {
    idle = nil,
    walk = nil,
    run = nil,
    swim = nil,
    swimidle = nil,
    jump = nil,
    fall = nil,
    climb = nil,
    sit = nil,
    toolnone = nil,
    toolslash = nil,
    toollunge = nil
}
local t_4 = {}
t_2.idle = {
    { id = "http://www.roblox.com/asset/?id=507766666", weight = 1 },
    { id = "http://www.roblox.com/asset/?id=507766951", weight = 1 },
    { id = "http://www.roblox.com/asset/?id=507766388", weight = 9 }
}
t_2.walk = { { id = "http://www.roblox.com/asset/?id=507777826", weight = 10 } }
t_2.run = { { id = "http://www.roblox.com/asset/?id=507767714", weight = 10 } }
t_2.swim = { { id = "http://www.roblox.com/asset/?id=507784897", weight = 10 } }
t_2.swimidle = { { id = "http://www.roblox.com/asset/?id=507785072", weight = 10 } }
t_2.jump = { { id = "http://www.roblox.com/asset/?id=507765000", weight = 10 } }
t_2.fall = { { id = "http://www.roblox.com/asset/?id=507767968", weight = 10 } }
t_2.climb = { { id = "http://www.roblox.com/asset/?id=507765644", weight = 10 } }
t_2.sit = { { id = "http://www.roblox.com/asset/?id=2506281703", weight = 10 } }
t_2.toolnone = { { id = "http://www.roblox.com/asset/?id=507768375", weight = 10 } }
t_2.toolslash = { { id = "http://www.roblox.com/asset/?id=522635514", weight = 10 } }
t_2.toollunge = { { id = "http://www.roblox.com/asset/?id=522638767", weight = 10 } }
local t_16 = {}
local t_17 = {}
local v12 = t_16
local t_18 = {}
math.randomseed(tick())

function findExistingAnimationInSet(arg1, arg2) -- line: 117
    if arg1 == nil or arg2 == nil then
        return 0
    end

    for index = 1, arg1.count do
        if arg1[index].anim.AnimationId == arg2.AnimationId then
            return index
        end
    end

    return 0
end

local function destroyWalkAnimations() -- line: 131
    -- upvalues:
    --  [1] t_16 (copy)
    --  [2] t_17 (copy)
    --  [3] v5 (ref)

    for _, val in pairs(t_16) do
        if val.track then
            val.track:Stop()
            val.track:Destroy()
            val.track = nil
        end
    end

    for _, val_1 in pairs(t_17) do
        if val_1.track then
            val_1.track:Stop()
            val_1.track:Destroy()
            val_1.track = nil
        end
    end

    v5 = 0
end

local v13 = nil
local v14 = nil
local v15 = nil
local v16 = nil

local _ = function(_) --[[ resetVelocityBounds ]] -- line: 152
    -- upvalues:
    --  [1] v14 (ref)
    --  [2] v13 (ref)
    --  [3] v16 (ref)
    --  [4] v15 (ref)

    v14 = 0
    v13 = 0
    v16 = 0
    v15 = 0
end

local _ = function(arg4) --[[ updateVelocityBounds ]] -- line: 159
    -- upvalues:
    --  [1] v13 (ref)
    --  [2] v15 (ref)
    --  [3] v14 (ref)
    --  [4] v16 (ref)

    if arg4 then
        if arg4.x > v13 then
            v13 = arg4.x
        end

        if arg4.y > v15 then
            v15 = arg4.y
        end

        if arg4.x < v14 then
            v14 = arg4.x
        end

        if arg4.y < v16 then
            v16 = arg4.y
        end
    end
end

local function checkStrafingEnabled(_) -- line: 168
    -- upvalues:
    --  [1] v13 (ref)
    --  [2] v14 (ref)
    --  [3] v15 (ref)
    --  [4] v16 (ref)
    --  [5] v12 (ref)
    --  [6] t_16 (copy)
    --  [7] t_17 (copy)

    if v13 == 0 or v14 == 0 or v15 == 0 or v16 == 0 then
        if v12 == t_16 then
            warn("Strafe blending disabled.  Not all quadrants of motion represented.")
        end

        v12 = t_17

        return
    end

    if not t_16.run or not t_16.walk then
        if v12 == t_16 then
            warn("Strafe blending disabled.  Run and walk must be strafing-friendly.")
        end

        v12 = t_17

        return
    end

    if v12 ~= t_16 then
        v12 = t_16
        warn("Strafing reenabled")
    end
end

local function setupWalkAnimations() -- line: 187
    -- upvalues:
    --  [1] v14 (ref)
    --  [2] v13 (ref)
    --  [3] v16 (ref)
    --  [4] v15 (ref)
    --  [5] t_16 (copy)
    --  [6] checkStrafingEnabled (copy)
    --  [7] v12 (ref)
    --  [8] Humanoid (copy)
    --  [9] t_1 (copy)

    v14 = 0
    v13 = 0
    v16 = 0
    v15 = 0

    for _, val_2 in pairs(t_16) do
        local Lv = val_2.lv

        if Lv then
            if Lv.x > v13 then
                v13 = Lv.x
            end

            if Lv.y > v15 then
                v15 = Lv.y
            end

            if Lv.x < v14 then
                v14 = Lv.x
            end

            if Lv.y < v16 then
                v16 = Lv.y
            end
        end
    end

    checkStrafingEnabled()

    for key_3, val_3 in pairs(v12) do
        val_3.track = Humanoid:LoadAnimation(t_1[key_3][1].anim)
        val_3.track.Priority = Enum.AnimationPriority.Core
    end
end

local function replaceLocomotionTrack(arg6, arg7) -- line: 200
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] v12 (ref)
    --  [3] destroyWalkAnimations (copy)
    --  [4] t_16 (copy)
    --  [5] t_17 (copy)
    --  [6] setupWalkAnimations (copy)
    --  [7] v6 (ref)

    local v17 = false

    if v7 == "walk" and v12[arg6] then
        destroyWalkAnimations()
        v17 = true
    end

    if arg7 then
        local t_19 = { lv = arg7, speed = arg7.Magnitude }
        t_16[arg6] = t_19
    else
        t_16[arg6] = nil
    end

    if arg6 == "run" or arg6 == "walk" then
        if arg7 then
            t_17[arg6] = t_16[arg6]
        else
            local v18 = if arg6 ~= "run" then 6.4 else 12.8
            t_17[arg6] = { lv = Vector2.new(0, v18), speed = v18 }
            t_16[arg6] = nil
        end
    end

    if v17 then
        setupWalkAnimations()
        v6 = 0
    end
end

function configureAnimationSet(arg8, arg9) -- line: 228
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] replaceLocomotionTrack (copy)
    --  [3] t_4 (copy)
    --  [4] Humanoid (copy)

    if t_1[arg8] ~= nil then
        for _, val_4 in pairs(t_1[arg8].connections) do
            val_4:disconnect()
        end
    end

    t_1[arg8] = {}
    t_1[arg8].count = 0
    t_1[arg8].totalWeight = 0
    t_1[arg8].connections = {}
    local v20 = script:FindFirstChild(arg8)

    if v20 ~= nil then
        table.insert(t_1[arg8].connections, v20.ChildAdded:connect(function(_) -- line: 242
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] arg9 (copy)

            configureAnimationSet(arg8, arg9)
        end))
        table.insert(t_1[arg8].connections, v20.ChildRemoved:connect(function(_) -- line: 243
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] arg9 (copy)

            configureAnimationSet(arg8, arg9)
        end))

        for _, val_5 in pairs(v20:GetChildren()) do
            if val_5:IsA("Animation") then
                local v22 = 1
                local Weight = val_5:FindFirstChild("Weight")

                if Weight ~= nil then
                    v22 = Weight.Value
                end

                t_1[arg8].count += 1
                local Count = t_1[arg8].count
                t_1[arg8][Count] = {}
                t_1[arg8][Count].anim = val_5
                t_1[arg8][Count].weight = v22
                t_1[arg8].totalWeight += t_1[arg8][Count].weight
                table.insert(t_1[arg8].connections, val_5.Changed:connect(function(_) -- line: 260
                    -- upvalues:
                    --  [1] arg8 (copy)
                    --  [2] arg9 (copy)

                    configureAnimationSet(arg8, arg9)
                end))
                table.insert(t_1[arg8].connections, val_5.ChildAdded:connect(function(_) -- line: 261
                    -- upvalues:
                    --  [1] arg8 (copy)
                    --  [2] arg9 (copy)

                    configureAnimationSet(arg8, arg9)
                end))
                table.insert(t_1[arg8].connections, val_5.ChildRemoved:connect(function(_) -- line: 262
                    -- upvalues:
                    --  [1] arg8 (copy)
                    --  [2] arg9 (copy)

                    configureAnimationSet(arg8, arg9)
                end))
                replaceLocomotionTrack(arg8, (val_5:GetAttribute("LinearVelocity")))
            end
        end
    end

    if t_1[arg8].count <= 0 then
        for key_6, val_6 in pairs(arg9) do
            t_1[arg8][key_6] = {}
            t_1[arg8][key_6].anim = Instance.new("Animation")
            t_1[arg8][key_6].anim.Name = arg8
            t_1[arg8][key_6].anim.AnimationId = val_6.id
            t_1[arg8][key_6].weight = val_6.weight
            t_1[arg8].count += 1
            t_1[arg8].totalWeight += val_6.weight
        end
    end

    for _, val_7 in pairs(t_1) do
        for index_1 = 1, val_7.count do
            if t_4[val_7[index_1].anim.AnimationId] == nil then
                Humanoid:LoadAnimation(val_7[index_1].anim)
                t_4[val_7[index_1].anim.AnimationId] = true
            end
        end
    end
end

function scriptChildModified(arg15) -- line: 295
    -- upvalues:
    --  [1] t_2 (copy)

    local v24 = t_2[arg15.Name]

    if v24 ~= nil then
        configureAnimationSet(arg15.Name, v24)

        return
    end

    if arg15:isA("StringValue") then
        t_2[arg15.Name] = {}
        configureAnimationSet(arg15.Name, t_2[arg15.Name])
    end
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)
local v25 = if Humanoid then Humanoid:FindFirstChildOfClass("Animator") else nil

if v25 then
    for _, val_8 in ipairs((v25:GetPlayingAnimationTracks())) do
        val_8:Stop(0)
        val_8:Destroy()
    end
end

local v26 = pairs

for key_9, val_9 in v26(t_2) do
    configureAnimationSet(key_9, val_9)
end

for _, child in script:GetChildren() do
    if child:isA("StringValue") then
        t_2[child.Name] = {}
        configureAnimationSet(child.Name, t_2[child.Name])
    end
end

local v27 = "None"
local v28 = 0
local v29 = 0
local v30 = false

function stopAllAnimations() -- line: 347
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] t_18 (copy)
    --  [3] v30 (ref)
    --  [4] v8 (ref)
    --  [5] v10 (ref)
    --  [6] v9 (ref)
    --  [7] v12 (ref)

    local v31 = v7

    if t_18[v31] ~= nil and t_18[v31] == false then
        v31 = "idle"
    end

    if v30 then
        v31 = "idle"
        v30 = false
    end

    v7 = ""
    v8 = nil

    if v10 ~= nil then
        v10:disconnect()
    end

    if v9 ~= nil then
        v9:Stop()
        v9:Destroy()
        v9 = nil
    end

    for _, val_10 in pairs(v12) do
        if val_10.track then
            val_10.track:Stop()
            val_10.track:Destroy()
            val_10.track = nil
        end
    end

    return v31
end

function v25() --[[ getRigScale ]] -- line: 383
    -- upvalues:
    --  [1] v3 (copy)
    --  [2] Parent (copy)

    if v3 then
        return Parent:GetScale()
    end

    return 1
end

function getHeightScale() -- line: 391
    -- upvalues:
    --  [1] Humanoid (copy)
    --  [2] v25 (copy)
    --  [3] ScaleDampeningPercent (ref)

    if Humanoid then
        if not Humanoid.AutomaticScalingEnabled then
            return v25()
        end

        local v32 = Humanoid.HipHeight / 2

        if ScaleDampeningPercent == nil then
            ScaleDampeningPercent = script:FindFirstChild("ScaleDampeningPercent")
        end

        if ScaleDampeningPercent ~= nil then
            v32 = 1 + (Humanoid.HipHeight - 2) * ScaleDampeningPercent.Value / 2
        end

        return v32
    else
        return v25()
    end
end

local _ = function(arg16, arg17) --[[ signedAngle ]] -- line: 412
    return -math.atan2(arg16.x * arg17.y - arg16.y * arg17.x, arg16.x * arg17.x + arg16.y * arg17.y)
end

local function get2DWeight(
    arg18,
    arg19,
    arg20,
    arg21,
    arg22,
    arg23
) -- line: 417
    local v33 = 0.5 * (arg22 + arg23)
    local t_21 = {
        x = (arg21 - arg22) / v33,
        y = 2 * -math.atan2(
            arg19.x * arg18.y - arg19.y * arg18.x,
            arg19.x * arg18.x + arg19.y * arg18.y
        )
    }
    local t_22 = {
        x = (arg23 - arg22) / v33,
        y = 2 * -math.atan2(
            arg19.x * arg20.y - arg19.y * arg20.x,
            arg19.x * arg20.x + arg19.y * arg20.y
        )
    }
    local clampedValue = math.clamp(
        1 - (t_21.x * t_22.x + t_21.y * t_22.y) / (0.0001 + (t_22.x * t_22.x + t_22.y * t_22.y)),
        0,
        1
    )

    return clampedValue
end

local function blend2D(arg24, arg25) -- line: 428
    -- upvalues:
    --  [1] v3 (copy)
    --  [2] v12 (ref)
    --  [3] get2DWeight (copy)

    if v3 then
        local v34 = getHeightScale()
        arg24 /= v34
        arg25 /= v34
    end

    local t_23 = {}
    local v35 = 0

    for key_12, val_11 in pairs(v12) do
        if arg24.x * val_11.lv.x < 0 or arg24.y * val_11.lv.y < 0 then
            t_23[key_12] = 0
        else
            t_23[key_12] = math.huge

            for _, val_12 in pairs(v12) do
                if not (arg24.x * val_12.lv.x < 0) and not (arg24.y * val_12.lv.y < 0) then
                    t_23[key_12] = math.min(
                        t_23[key_12],
                        (get2DWeight(
                            arg24,
                            val_11.lv,
                            val_12.lv,
                            arg25,
                            val_11.speed,
                            val_12.speed
                        ))
                    )
                end
            end

            v35 += t_23[key_12]
        end
    end

    local v38 = 0
    local v39 = 0
    local v40 = 0

    for key_14, val_13 in pairs(v12) do
        if t_23[key_14] / v35 > 0.1 then
            v38 += t_23[key_14]
            v39 += t_23[key_14] * val_13.lv.x
            v40 += t_23[key_14] * val_13.lv.y
        else
            t_23[key_14] = 0
        end
    end

    v35 = v39 * v39 + v40 * v40
    local v41 = if v35 > 0.0001 then math.sqrt(arg25 * arg25 / v35) else 0

    if not v3 then
        v41 /= getHeightScale()
    end

    v40 = 0

    for _, val_14 in pairs(v12) do
        if val_14.track.IsPlaying then
            v40 = val_14.track.TimePosition
            break
        end
    end

    for key_16, val_15 in pairs(v12) do
        if t_23[key_16] > 0 then
            if not val_15.track.IsPlaying then
                val_15.track:Play(0.2)
                val_15.track.TimePosition = v40
            end

            val_15.track:AdjustWeight(math.max(0.0001, t_23[key_16] / v38), 0.2)
            val_15.track:AdjustSpeed(v41)
        else
            val_15.track:Stop(0.2)
        end
    end
end

local function getWalkDirection() -- line: 504
    -- upvalues:
    --  [1] Humanoid (copy)

    local WalkToPoint = Humanoid.WalkToPoint
    local WalkToPart = Humanoid.WalkToPart

    if Humanoid.MoveDirection ~= Vector3.new(0, 0, 0) then
        return Humanoid.MoveDirection
    end

    if WalkToPart or WalkToPoint ~= Vector3.new(0, 0, 0) then
        local v43 = if WalkToPart then WalkToPart.CFrame:PointToWorldSpace(WalkToPoint) else WalkToPoint
        local v44 = Vector3.new(0, 0, 0)

        if Humanoid.RootPart then
            v44 = v43 - Humanoid.RootPart.CFrame.Position
            v44 = Vector3.new(v44.x, 0, v44.z)
            local Magnitude = v44.Magnitude

            if Magnitude > 0.01 then
                v44 /= Magnitude
            end
        end

        return v44
    end

    return Humanoid.MoveDirection
end

local function updateVelocity(arg26) -- line: 531
    -- upvalues:
    --  [1] v12 (ref)
    --  [2] t_16 (copy)
    --  [3] getWalkDirection (copy)
    --  [4] Humanoid (copy)
    --  [5] v1 (ref)
    --  [6] v4 (ref)
    --  [7] t (ref)
    --  [8] v5 (ref)
    --  [9] v6 (ref)
    --  [10] blend2D (copy)

    if v12 == t_16 then
        local v45 = getWalkDirection()

        if not Humanoid.RootPart then
            return
        end

        local v46 = Humanoid.RootPart.CFrame

        if math.abs(v46.UpVector.Y) < 0.0001 or v1 ~= "Running" or v4 < 0.001 then
            for _, val_16 in pairs(v12) do
                if val_16.track then
                    val_16.track:AdjustWeight(0.0001, 0.2)
                end
            end

            return
        end

        local LookVector = v46.LookVector
        local vec3 = Vector3.new(LookVector.X, 0, LookVector.Z)
        vec3 /= vec3.Magnitude
        local v47 = v45:Dot(vec3)

        if v47 <= 0 and v47 > -0.05 then
            v47 = 0.0001
        end

        local vec2 = Vector2.new(vec3.X * v45.Z - vec3.Z * v45.X, v47)
        local vec2_1 = Vector2.new(vec2.x - t.x, vec2.y - t.y)

        if not (vec2_1:Dot(vec2_1) > 0.001) then
            if not (math.abs(v4 - v5) > 0.01) then
                if arg26 - v6 > 1 then
                    t = vec2
                    v5 = v4
                    v6 = arg26
                    blend2D(t, v5)

                    return
                end
            else
                t = vec2
                v5 = v4
                v6 = arg26
                blend2D(t, v5)

                return
            end
        else
            t = vec2
            v5 = v4
            v6 = arg26
            blend2D(t, v5)

            return
        end
    elseif math.abs(v4 - v5) > 0.01 or arg26 - v6 > 1 then
        v5 = v4
        v6 = arg26
        blend2D(Vector2.yAxis, v5)
    end
end

function setAnimationSpeed(arg27) -- line: 579
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] v11 (ref)
    --  [3] v9 (ref)

    if v7 ~= "walk" and arg27 ~= v11 then
        v11 = arg27
        v9:AdjustSpeed(v11)
    end
end

function keyFrameReachedFunc(arg28) -- line: 588
    -- upvalues:
    --  [1] v7 (ref)
    --  [2] t_18 (copy)
    --  [3] v30 (ref)
    --  [4] v9 (ref)
    --  [5] v11 (ref)
    --  [6] Humanoid (copy)

    if arg28 == "End" then
        local v48 = v7

        if t_18[v48] ~= nil and t_18[v48] == false then
            v48 = "idle"
        end

        if v30 then
            if v9.Looped then
                return
            end

            v48 = "idle"
            v30 = false
        end

        local v49 = v11
        playAnimation(v48, 0.15, Humanoid)
        setAnimationSpeed(v49)
    end
end

function rollAnimation(arg29) -- line: 612
    -- upvalues:
    --  [1] t_1 (copy)

    local v50 = math.random(1, t_1[arg29].totalWeight)
    local v51 = 1

    while true do
        if not (v50 > t_1[arg29][v51].weight) then
            break
        end

        v50 -= t_1[arg29][v51].weight
        v51 += 1
    end

    return v51
end

local function switchToAnim(
    arg30,
    arg31,
    arg32,
    arg33,
    arg34
) -- line: 623
    -- upvalues:
    --  [1] v8 (ref)
    --  [2] v9 (ref)
    --  [3] v10 (ref)
    --  [4] v11 (ref)
    --  [5] v7 (ref)
    --  [6] setupWalkAnimations (copy)
    --  [7] destroyWalkAnimations (copy)

    if arg30 ~= v8 or arg34 then
        if v9 ~= nil then
            v9:Stop(arg32)
            v9:Destroy()
        end

        if v10 ~= nil then
            v10:disconnect()
            v10 = nil
        end

        v11 = 1
        v7 = arg31
        v8 = arg30

        if arg31 == "walk" then
            setupWalkAnimations()

            return
        end

        destroyWalkAnimations()
        v9 = arg33:LoadAnimation(arg30)
        v9.Priority = Enum.AnimationPriority.Core
        v9:Play(arg32)
        v10 = v9.KeyframeReached:connect(keyFrameReachedFunc)
    end
end

local t_25 = nil

function playAnimation(arg35, arg36, arg37, ...) -- line: 660
    -- upvalues:
    --  [1] t_25 (ref)
    --  [2] t_1 (copy)
    --  [3] switchToAnim (copy)
    --  [4] v30 (ref)

    t_25 = { arg35, arg36, arg37 }
    local v53 = rollAnimation(arg35)
    switchToAnim(
        t_1[arg35][v53].anim,
        arg35,
        arg36,
        arg37,
        ...
    )
    v30 = false
end

script:WaitForChild("Refresh").Event:Connect(function(...) -- line: 670
    -- upvalues:
    --  [1] t_25 (ref)

    if not t_25 then
        return
    end

    for _, val_17 in pairs(script.Parent.Humanoid:GetPlayingAnimationTracks()) do
        val_17:Stop()
        val_17:Destroy()
    end

    script.RefreshServer:FireServer()
    playAnimation(
        t_25[1],
        t_25[2],
        t_25[3],
        true,
        ...
    )
end)

function playEmote(arg38, arg39, arg40) -- line: 684
    -- upvalues:
    --  [1] switchToAnim (copy)
    --  [2] v30 (ref)

    switchToAnim(arg38, arg38.Name, arg39, arg40)
    v30 = true
end

local v55 = ""
local v56 = nil
local v57 = nil
local v58 = nil

function toolKeyFrameReachedFunc(arg41) -- line: 697
    -- upvalues:
    --  [1] v55 (ref)
    --  [2] Humanoid (copy)

    if arg41 == "End" then
        playToolAnimation(v55, 0, Humanoid)
    end
end

function playToolAnimation(arg42, arg43, arg44, arg45) -- line: 704
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] v57 (ref)
    --  [3] v56 (ref)
    --  [4] v55 (ref)
    --  [5] v58 (ref)

    local v59 = rollAnimation(arg42)
    local Anim = t_1[arg42][v59].anim

    if v57 ~= Anim then
        if v56 ~= nil then
            v56:Stop()
            v56:Destroy()
            arg43 = 0
        end

        v56 = arg44:LoadAnimation(Anim)

        if arg45 then
            v56.Priority = arg45
        end

        v56:Play(arg43)
        v55 = arg42
        v57 = Anim
        v58 = v56.KeyframeReached:connect(toolKeyFrameReachedFunc)
    end
end

function stopToolAnimations() -- line: 731
    -- upvalues:
    --  [1] v55 (ref)
    --  [2] v58 (ref)
    --  [3] v57 (ref)
    --  [4] v56 (ref)

    local v60 = v55

    if v58 ~= nil then
        v58:disconnect()
    end

    v55 = ""
    v57 = nil

    if v56 ~= nil then
        v56:Stop()
        v56:Destroy()
        v56 = nil
    end

    return v60
end

function onRunning(arg46) -- line: 753
    -- upvalues:
    --  [1] v3 (copy)
    --  [2] v30 (ref)
    --  [3] Humanoid (copy)
    --  [4] v4 (ref)
    --  [5] v1 (ref)
    --  [6] updateVelocity (copy)
    --  [7] t_18 (copy)
    --  [8] v7 (ref)

    local v61 = if not v3 then 1 else getHeightScale()
    local v63 = v30 and Humanoid.MoveDirection == Vector3.new(0, 0, 0) and Humanoid.WalkSpeed / v61 or 0.75
    v4 = arg46

    if arg46 > v63 * v61 then
        playAnimation("walk", 0.2, Humanoid)

        if v1 ~= "Running" then
            v1 = "Running"
            updateVelocity(0)

            return
        end
    elseif t_18[v7] == nil and not v30 then
        playAnimation("idle", 0.2, Humanoid)
        v1 = "Standing"
    end
end

function onDied() -- line: 776
    -- upvalues:
    --  [1] v1 (ref)

    v1 = "Dead"
end

function onJumping() -- line: 780
    -- upvalues:
    --  [1] Humanoid (copy)
    --  [2] v29 (ref)
    --  [3] v1 (ref)

    playAnimation("jump", 0.1, Humanoid)
    v29 = 0.31
    v1 = "Jumping"
end

function onClimbing(arg47) -- line: 786
    -- upvalues:
    --  [1] v3 (copy)
    --  [2] Humanoid (copy)
    --  [3] v1 (ref)

    if v3 then
        arg47 /= getHeightScale()
    end

    playAnimation("climb", 0.1, Humanoid)
    setAnimationSpeed(arg47 / 5)
    v1 = "Climbing"
end

function onGettingUp() -- line: 796
    -- upvalues:
    --  [1] v1 (ref)

    v1 = "GettingUp"
end

function onFreeFall() -- line: 800
    -- upvalues:
    --  [1] v29 (ref)
    --  [2] Humanoid (copy)
    --  [3] v1 (ref)

    if v29 <= 0 then
        playAnimation("fall", 0.2, Humanoid)
    end

    v1 = "FreeFall"
end

function onFallingDown() -- line: 807
    -- upvalues:
    --  [1] v1 (ref)

    v1 = "FallingDown"
end

function onSeated() -- line: 811
    -- upvalues:
    --  [1] v1 (ref)

    v1 = "Seated"
end

function onPlatformStanding() -- line: 815
    -- upvalues:
    --  [1] v1 (ref)

    v1 = "PlatformStanding"
end

function onSwimming(arg48) -- line: 822
    -- upvalues:
    --  [1] v3 (copy)
    --  [2] Humanoid (copy)
    --  [3] v1 (ref)

    if v3 then
        arg48 /= getHeightScale()
    end

    if arg48 > 1 then
        playAnimation("swim", 0.4, Humanoid)
        setAnimationSpeed(arg48 / 10)
        v1 = "Swimming"

        return
    end

    playAnimation("swimidle", 0.4, Humanoid)
    v1 = "Standing"
end

function animateTool() -- line: 837
    -- upvalues:
    --  [1] v27 (ref)
    --  [2] Humanoid (copy)

    if v27 == "None" then
        playToolAnimation("toolnone", 0.1, Humanoid, Enum.AnimationPriority.Idle)

        return
    end

    if v27 == "Slash" then
        playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)

        return
    end

    if v27 == "Lunge" then
        playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)

        return
    end
end

function getToolAnim(arg49) -- line: 854
    for _, child_1 in ipairs(arg49:GetChildren()) do
        if child_1.Name == "toolanim" and child_1.className == "StringValue" then
            return child_1
        end
    end

    return nil
end

local v65 = 0

function stepAnimate(arg50) -- line: 865
    -- upvalues:
    --  [1] v65 (ref)
    --  [2] v29 (ref)
    --  [3] v1 (ref)
    --  [4] Humanoid (copy)
    --  [5] updateVelocity (copy)
    --  [6] Parent (copy)
    --  [7] v27 (ref)
    --  [8] v28 (ref)
    --  [9] v57 (ref)

    local v66 = arg50 - v65
    v65 = arg50

    if v29 > 0 then
        v29 -= v66
    end

    if v1 == "FreeFall" and v29 <= 0 then
        playAnimation("fall", 0.2, Humanoid)
    else
        if v1 == "Seated" then
            playAnimation("sit", 0.5, Humanoid)

            return
        end

        if v1 == "Running" then
            playAnimation("walk", 0.2, Humanoid)
            updateVelocity(arg50)
        elseif
            v1 == "Dead"
            or v1 == "GettingUp"
            or v1 == "FallingDown"
            or v1 == "Seated"
            or v1 == "PlatformStanding"
        then
            stopAllAnimations()
        end
    end

    local Tool = Parent:FindFirstChildOfClass("Tool")

    if Tool and Tool:FindFirstChild("Handle") then
        local v67 = getToolAnim(Tool)

        if v67 then
            v27 = v67.Value
            v67.Parent = nil
            v28 = arg50 + 0.3
        end

        if arg50 > v28 then
            v28 = 0
            v27 = "None"
        end

        animateTool()

        return
    end

    stopToolAnimations()
    v27 = "None"
    v57 = nil
    v28 = 0
end

Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)
Humanoid.PlatformStanding:connect(onPlatformStanding)
Humanoid.Swimming:connect(onSwimming)
game:GetService("Players").LocalPlayer.Chatted:connect(function(arg51) -- line: 933
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] t_18 (copy)
    --  [3] Humanoid (copy)

    local v68 = ""

    if string.sub(arg51, 1, 3) == "/e " then
        v68 = string.sub(arg51, 4)
    elseif string.sub(arg51, 1, 7) == "/emote " then
        v68 = string.sub(arg51, 8)
    end

    if v1 == "Standing" and t_18[v68] ~= nil then
        playAnimation(v68, 0.1, Humanoid)
    end
end)

script:WaitForChild("PlayEmote").OnInvoke = function(arg52) -- line: 947
    -- upvalues:
    --  [1] v1 (ref)
    --  [2] t_18 (copy)
    --  [3] Humanoid (copy)
    --  [4] v9 (ref)

    if v1 ~= "Standing" then
        return
    end

    if t_18[arg52] ~= nil then
        playAnimation(arg52, 0.1, Humanoid)

        return true, v9
    end

    if typeof(arg52) == "Instance" and arg52:IsA("Animation") then
        playEmote(arg52, 0.1, Humanoid)

        return true, v9
    end

    return false
end

if Parent.Parent ~= nil then
    playAnimation("idle", 0.1, Humanoid)
    v1 = "Standing"
end

while true do
    if Parent.Parent == nil then
        break
    end

    local _, v70 = wait(0.1)
    stepAnimate(v70)
end
