local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local MushroomCloud = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild(
    "MushroomCloud"
)

local function get_rotation(arg1) -- line: 17
    -- upvalues:
    --  [1] Utility_m (copy)

    local Unit = (arg1 - workspace.CurrentCamera.CFrame.Position).Unit
    local v1 = arg1 - Unit
    local v2 = arg1 + Unit * 8
    local raycastResult = Utility_m:Raycast(v1, v2, (v1 - v2).Magnitude)

    if raycastResult.Normal then
        return CFrame.new(Vector3.new(0, 0, 0), raycastResult.Normal) * CFrame.Angles(
            -1.5707963267948966,
            0,
            0
        )
    end

    return CFrame.identity
end

return function(
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 26
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Utility_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] get_rotation (copy)
    --  [5] MushroomCloud (copy)
    --  [6] BetterDebris_m (copy)

    local v3 = 5 * (arg4 or 1)
    local v4 = arg6 or 64
    local Magnitude = (workspace.CurrentCamera.CFrame.Position - arg2).Magnitude

    if Magnitude > CONSTANTS_m.RENDER_DISTANCE then
        return
    end

    Utility_m:CreateSound(
        "rbxassetid://13455969017",
        0.5,
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10,
        arg7,
        arg8
    )
    Utility_m:CreateSound(
        "rbxassetid://17641561917",
        1.5,
        0.9 + 0.2 * math.random(),
        arg2,
        true,
        10,
        arg7,
        arg8
    )

    if v4 >= Magnitude then
        local maximum = math.max(0, 1 - Magnitude / v4)
        CameraController_m:ShakeOnce(
            maximum * 50,
            maximum * 10 / v3,
            0.1 / v3,
            0.4 / v3,
            Vector3.new(0.25, 0.25, 0),
            Vector3.new(0, 0, 0)
        )
    end

    local v13 = arg3 / 40
    local v15 = CFrame.new(arg2) * (if not arg5 then CFrame.identity else get_rotation(arg2))
    local v16 = -5 * v13
    local v17 = MushroomCloud:Clone()
    local v10
    v17.Parent, v10 = workspace, v15
    v17:SetPrimaryPartCFrame(v10)
    BetterDebris_m:AddItem(v17, 25 / v3)
    v17.Fire.PointLight.Range = arg3 * 3
    Utility_m:PlayParticles(v17.Fire)

    local _ = function(arg9) --[[ shake ]] -- line: 56
        local v19 = math.random() - 0.5
        local v20 = math.random() - 0.5

        return Vector3.new(v19, v20, math.random() - 0.5) * 0.25 * (arg9 or 1)
    end

    local v21 = (math.random(1, 2) - 1.5) * 2

    local _ = function() --[[ spin ]] -- line: 62
        -- upvalues:
        --  [1] v21 (copy)

        return CFrame.Angles(0, tick() * 0.25 * v21 % 6.283185307179586, 0)
    end

    Utility_m:RenderstepForLoop(0, 100, 0.5 * v3, function(arg10) -- line: 66
        -- upvalues:
        --  [1] v17 (copy)
        --  [2] v13 (copy)
        --  [3] v15 (copy)
        --  [4] v16 (copy)
        --  [5] v21 (copy)

        local v23 = 1 - (1 - arg10 / 100) ^ 5
        local v24 = v23 * 3
        local v25 = 1 + (1 - v23)
        v17.Cloud.Size = Vector3.new(14.711, 14.091, 13.818) * v24 * v13
        v17.Fire.Size = Vector3.new(14.007, 14.026, 13.543) * v24 * v13
        v17.Ring.Size = Vector3.new(14.9445, 2.697, 14.778) * (arg10 / 100 * 3) * v13
        local Cloud = v17.Cloud
        local v28 = v15 * CFrame.new(0, v17.Cloud.Size.Y / 2 + v16, 0) * CFrame.Angles(
            0,
            tick() * 0.25 * v21 % 6.283185307179586,
            0
        )
        local v29 = math.random() - 0.5
        local v30 = math.random() - 0.5
        Cloud.CFrame = v28 + Vector3.new(v29, v30, math.random() - 0.5) * 0.25 * (v25 or 1)
        local Fire = v17.Fire
        local v31 = v17.Cloud.CFrame
        local v32 = math.random() - 0.5
        local v33 = math.random() - 0.5
        Fire.CFrame = v31 + Vector3.new(v32, v33, math.random() - 0.5) * 0.25 * (v25 or 1)
        local Ring = v17.Ring
        local v35 = v17.Cloud.CFrame * CFrame.new(0, -1.815, 0)
        local v36 = math.random() - 0.5
        local v37 = math.random() - 0.5
        Ring.CFrame = v35 + Vector3.new(v36, v37, math.random() - 0.5) * 0.25 * (v25 or 1)
    end)
    Utility_m:RenderstepForLoop(0, 100, 0.5 * v3, function(arg11) -- line: 82
        -- upvalues:
        --  [1] v17 (copy)
        --  [2] v13 (copy)
        --  [3] v15 (copy)
        --  [4] v16 (copy)
        --  [5] v21 (copy)

        local v39 = arg11 / 100
        v17.Fire.Transparency = v39
        v17.Ring.Transparency = v39 / 2
        v17.Ring.Size = Vector3.new(14.9445, 2.697, 14.778) * ((1 + v39 / 2) * 3) * v13
        local Cloud_1 = v17.Cloud
        local v42 = v15 * CFrame.new(0, v17.Cloud.Size.Y / 2 + v16, 0) * CFrame.Angles(
            0,
            tick() * 0.25 * v21 % 6.283185307179586,
            0
        )
        local v43 = math.random() - 0.5
        local v44 = math.random() - 0.5
        Cloud_1.CFrame = v42 + Vector3.new(v43, v44, math.random() - 0.5) * 0.25 * 1
        local Fire_1 = v17.Fire
        local v45 = v17.Cloud.CFrame
        local v46 = math.random() - 0.5
        local v47 = math.random() - 0.5
        Fire_1.CFrame = v45 + Vector3.new(v46, v47, math.random() - 0.5) * 0.25 * 1
        local Ring_1 = v17.Ring
        local v49 = v17.Cloud.CFrame * CFrame.new(0, -1.815, 0)
        local v50 = math.random() - 0.5
        local v51 = math.random() - 0.5
        Ring_1.CFrame = v49 + Vector3.new(v50, v51, math.random() - 0.5) * 0.25 * 1
    end)
    Utility_m:RenderstepForLoop(0, 100, 1 * v3, function(arg12) -- line: 95
        -- upvalues:
        --  [1] v17 (copy)
        --  [2] v13 (copy)
        --  [3] v15 (copy)
        --  [4] v16 (copy)
        --  [5] v21 (copy)

        local v53 = arg12 / 100
        v17.Cloud.Transparency = v53
        v17.Ring.Transparency = 0.5 + v53 / 2
        v17.Ring.Size = Vector3.new(14.9445, 2.697, 14.778) * ((1.5 + v53 / 2) * 3) * v13
        local Cloud_2 = v17.Cloud
        local v56 = v15 * CFrame.new(0, v17.Cloud.Size.Y / 2 + v16, 0) * CFrame.Angles(
            0,
            tick() * 0.25 * v21 % 6.283185307179586,
            0
        )
        local v57 = math.random() - 0.5
        local v58 = math.random() - 0.5
        Cloud_2.CFrame = v56 + Vector3.new(v57, v58, math.random() - 0.5) * 0.25 * 1
        local Ring_2 = v17.Ring
        local v60 = v17.Cloud.CFrame * CFrame.new(0, -1.815, 0)
        local v61 = math.random() - 0.5
        local v62 = math.random() - 0.5
        Ring_2.CFrame = v60 + Vector3.new(v61, v62, math.random() - 0.5) * 0.25 * 1
    end)
    v17:Destroy()
end
