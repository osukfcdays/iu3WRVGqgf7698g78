local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local TracerEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild("TracerEffect")
local gradient = ColorSequence.new(Color3.fromRGB(255, 81, 0))
local gradient_1 = ColorSequence.new(Color3.fromRGB(255, 8, 0))

return {
    VerifyTracerData = function(_, arg2, arg3, arg4) --[[ VerifyTracerData ]] -- line: 16
        -- upvalues:
        --  [1] gradient (copy)

        local v3 = arg2 or {}
        local v4 = v3.RaycastResults or {}
        v3.RaycastResults = v4
        v3.IsLocal = v3.IsLocal or false
        v3.IsEnemy, v4 = v3.IsEnemy or false, arg3
        local v5 = v4 or {}
        v5.EnemyColor = v5.EnemyColor or nil
        v5.Color = v5.Color or nil
        v5.BeamProperties = v5.BeamProperties or nil
        v5.MaxLengthFirstPerson = v5.MaxLengthFirstPerson or nil
        v5.MaxLength = v5.MaxLength or nil
        v5.NoDistanceDelay = v5.NoDistanceDelay or nil
        v5.Template = v5.Template or nil
        v5.InitCallback = v5.InitCallback or nil
        v5.UpdateSpeed = v5.UpdateSpeed or nil
        v5.CustomUpdate = v5.CustomUpdate or nil
        v5.PlayFlyBySound = v5.PlayFlyBySound or nil
        local v6 = arg4 or {}
        local v7 = v6.FriendlyTracerColor or gradient
        v6.FriendlyTracerColor = v7
        v6.ActuallyFirstPerson = v6.ActuallyFirstPerson or false
        v6.MuzzlePosition = v6.MuzzlePosition or nil

        return v3, v5, v6
    end,
    Play = function(arg5, arg6, arg7, arg8) --[[ Play ]] -- line: 43
        -- upvalues:
        --  [1] CONSTANTS_m (copy)
        --  [2] Utility_m (copy)
        --  [3] TracerEffect (copy)
        --  [4] BetterDebris_m (copy)
        --  [5] gradient_1 (copy)
        --  [6] WrapController_m (copy)

        local v8, v9, v10 = arg5:VerifyTracerData(arg6, arg7, arg8)

        if not v10.MuzzlePosition then
            return
        end

        local v11 = {}
        local v12, v13

        for _, val in pairs(v8.RaycastResults) do
            if not v8.IsLocal then
                v12 = val

                while v12.LastRaycastResult do
                    v12 = v12.LastRaycastResult
                end

                v13 = v11[v12] or {}
                v11[v12] = v13
                table.insert(v11[v12], val)
            end
        end

        for _, val_1 in pairs(v11) do
            v12 = nil
            v13 = nil

            for _, val_2 in pairs(val_1) do
                local v14 = val_2.StartPosition or v10.MuzzlePosition
                local v15 = Ray.new(v14, (val_2.Position - v14).Unit):ClosestPoint(
                    workspace.CurrentCamera.CFrame.Position
                )

                if
                    not v12
                    or (v15 - workspace.CurrentCamera.CFrame.Position).Magnitude < (v12 - workspace.CurrentCamera.CFrame.Position).Magnitude
                then
                    v12 = v15
                    v13 = v14
                end
            end

            if v12 then
                local Magnitude = (v12 - v13).Magnitude

                if Magnitude > 1 and Magnitude < CONSTANTS_m.RENDER_DISTANCE then
                    v13 = 1 - ((v12 - workspace.CurrentCamera.CFrame.Position).Magnitude / 50) ^ 3

                    if v9.PlayFlyBySound then
                        v9.PlayFlyBySound(v12, v13, 50)
                    else
                        Utility_m:CreateSound(
                            "rbxassetid://14767954026",
                            1 * v13,
                            1.4 + 0.2 * math.random(),
                            v12,
                            true,
                            10,
                            50,
                            50
                        )
                    end
                end
            end
        end

        v11 = if not v10.ActuallyFirstPerson then v9.MaxLength or 15 else v9.MaxLengthFirstPerson or 75

        for key_3, val_3 in pairs(v8.RaycastResults) do
            task.defer(function() -- line: 103
                -- upvalues:
                --  [1] val_3 (copy)
                --  [2] v9 (copy)
                --  [3] v10 (copy)
                --  [4] TracerEffect (ref)
                --  [5] BetterDebris_m (ref)
                --  [6] key_3 (copy)
                --  [7] v8 (copy)
                --  [8] gradient_1 (ref)
                --  [9] WrapController_m (ref)
                --  [10] Utility_m (ref)
                --  [11] v11 (copy)

                local v19 = 0
                local v20 = val_3

                while v20 do
                    if not v20.LastRaycastResult or v9.NoDistanceDelay then
                        break
                    end

                    local v21 = v20.StartPosition or v10.MuzzlePosition
                    v19 += (v21 - val_3.Position).Magnitude
                    v20 = v20.LastRaycastResult
                end

                if v19 > 0 then
                    wait(1.6666666666666667 / (800 / v19))
                end

                v20 = val_3.StartPosition or v10.MuzzlePosition
                v19 = (v20 - val_3.Position).Magnitude
                local v22 = (v9.Template or TracerEffect):Clone()
                v22.CFrame = CFrame.identity
                v22.Parent = workspace
                BetterDebris_m:AddItem(v22, 10)

                if v9.InitCallback then
                    v9.InitCallback(v22, key_3)
                else
                    local Beam = v22.Beam
                    Beam.Color = if not v8.IsEnemy then v9.Color or v10.FriendlyTracerColor else v9.EnemyColor or gradient_1
                    v22.Attachment1.PointLight.Color = v22.Beam.Color.Keypoints[1].Value
                    local v24 = pairs
                    local v25 = v9.BeamProperties or {}

                    for key_4, val_4 in v24(v25) do
                        v22.Beam[key_4] = val_4
                    end
                end

                if v9.TemplateWrap then
                    WrapController_m:ApplyWrap(
                        WrapController_m:RecordOriginalWrapProperties(v9.Template),
                        v9.TemplateWrap,
                        true
                    )
                end

                local v28 = v9.UpdateSpeed
                local Attachment0 = v22.Attachment0
                local Attachment1 = v22.Attachment1
                local v29 = Utility_m
                v28 = v28 or 800 / v19
                v29:RenderstepForLoop(0, 100, v28, function(arg9) -- line: 142
                    -- upvalues:
                    --  [1] v9 (ref)
                    --  [2] v22 (copy)
                    --  [3] Attachment0 (copy)
                    --  [4] Attachment1 (copy)
                    --  [5] v20 (copy)
                    --  [6] val_3 (ref)
                    --  [7] v11 (ref)

                    local v30 = arg9 / 100

                    if v9.CustomUpdate then
                        v9.CustomUpdate(
                            v22,
                            Attachment0,
                            Attachment1,
                            v30,
                            v20,
                            val_3.Position
                        )

                        return
                    end

                    Attachment1.WorldPosition = v20:Lerp(val_3.Position, v30)
                    Attachment0.WorldPosition = Attachment1.WorldPosition + (val_3.Position - v20).Unit * math.min(
                        (Attachment1.WorldPosition - val_3.Position).Magnitude,
                        v11
                    )
                end)
                v22:Destroy()
            end)
        end
    end
}
