local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local WrapController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.WrapController)
local Custom_m = require(Players.LocalPlayer.PlayerScripts.Modules.ItemTypes.Custom)
local Projectiles = Players.LocalPlayer.PlayerScripts.Assets:WaitForChild("Projectiles")
local t = setmetatable({}, Custom_m)
t.__index = t

function t.new(...) -- line: 17
    -- upvalues:
    --  [1] Custom_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Custom_m.new(...), t)
    t_1.Data.GrapplingHookPartActive = false
    t_1._use_cooldown = 0
    t_1._use_cooldown_hash = 0
    t_1._use_animation_hash = 0
    t_1._current_hook_connections = {}
    t_1._current_hook_part = nil
    t_1._current_hook_velocity = nil
    t_1:_Init()

    return t_1
end

function t.GetAutoShootReactionTime(_) -- line: 38
    return nil
end

function t.CanQuickAttack(arg2) -- line: 42
    return if tick() > arg2._use_cooldown then not arg2:IsEquipping() else false
end

function t.StartShooting(arg3, arg4) -- line: 46
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] Utility_m (copy)

    if not arg4 and (tick() < arg3._use_cooldown or arg3:IsEquipping()) then
        return false
    end

    arg3._use_cooldown_hash += 1
    arg3._use_animation_hash += 1
    local v3 = arg3.Info.HookRange / arg3.Info.HookSpeed
    local UseCooldownHash = arg3._use_cooldown_hash
    local UseAnimationHash = arg3._use_animation_hash
    arg3._use_cooldown = tick() + v3 + arg3.Info.MissedCooldown
    arg3:CooldownEffect("rbxassetid://101933751328343", v3, "Cooldown", true)
    arg3.ViewModel:StopAnimation("Inspect", 0)
    arg3.ViewModel:StopAnimation("Equip", 0)
    arg3.ViewModel:StopAnimation("Inspect", 0)
    arg3.ViewModel:StopAnimation("Pull", 0)
    arg3.ViewModel:MuzzleFlash()
    task.spawn(function() -- line: 66
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] AnimationLibrary_m (ref)
        --  [3] UseAnimationHash (copy)

        if arg3.ViewModel.Info.Animations.ShootMissed then
            arg3.ViewModel:StopAnimation("ShootMissed", 0)
        end

        arg3.ViewModel:PlayAnimation("Shoot")

        if arg3.ViewModel.Info.Animations.ShootWaiting then
            wait(AnimationLibrary_m.Info[arg3.ViewModel.Info.Animations.Shoot].Length)

            if not arg3.IsEquipped or UseAnimationHash ~= arg3._use_animation_hash then
                return
            end

            arg3.ViewModel:PlayAnimation("ShootWaiting")
        end
    end)
    task.delay(v3, function() -- line: 85
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] UseCooldownHash (copy)

        if arg3._use_cooldown_hash ~= UseCooldownHash then
            return
        end

        arg3:CooldownEffect("rbxassetid://101933751328343", arg3.Info.MissedCooldown, "Cooldown")
    end)
    local v4 = arg3.ClientFighter:GetCameraData()

    if arg3.ClientFighter.IsLocalPlayer then
        arg3:_ShootHookEffect(Utility_m:DecodeCFrame(v4[utf8.char(0)]))
    else
        local v6 = arg3.ClientFighter.Entity and (arg3.ClientFighter.Entity.Head or arg3.ClientFighter.Entity.RootPart)

        if v6 then
            arg3:_ShootHookEffect(CFrame.new(v6.Position) * arg3.ClientFighter:GetRotationCFrame())
        end
    end

    return true, "StartShooting", v4
end

function t.Unequip(arg5, ...) -- line: 108
    -- upvalues:
    --  [1] Custom_m (copy)

    arg5._use_animation_hash += 1
    Custom_m.Unequip(arg5, ...)
end

function t.ReplicateFromServer(arg6, arg7, ...) -- line: 113
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] RunService (copy)
    --  [3] Custom_m (copy)

    local v10, v8

    if arg7 == "GrapplerPull" then
        if not arg6:IsRendered() then
            return
        end

        arg6._use_animation_hash += 1

        if arg6.ViewModel.Info.Animations.ShootWaiting then
            arg6.ViewModel:StopAnimation("ShootWaiting", 0)
        end

        if not arg6.IsEquipped then
            return
        end

        local _
        v8, _ = ...
        v10 = arg6.ClientFighter.Entity

        if v10 then
            v10 = arg6.ClientFighter.Entity:IsAlive()

            if v10 then
                v10 = arg6.ClientFighter.Entity.RootPart.Position
            end
        end

        arg6:_Shake("GrapplerPull")
        arg6.ViewModel:StopAnimation("Equip", 0)
        arg6.ViewModel:StopAnimation("Inspect", 0)
        arg6.ViewModel:StopAnimation("Shoot", 0)
        arg6.ViewModel:PlayAnimation("Pull", 0.5)
        arg6.ViewModel:PlayPullSounds()

        if not v8 or not v10 or v8:FuzzyEq(v10) then
            arg6:_DeleteHookPart()

            return
        end

        local v11 = (v8 - v10).Unit * arg6.Info.SelfPullForce
        local v12 = math.min(arg6.Info.HookRange, (v8 - v10).Magnitude) / arg6.Info.SelfPullForce
        arg6.ViewModel:HideHookSubModel(v12)

        if arg6._current_hook_part and arg6._current_hook_part:IsDescendantOf(workspace) then
            arg6._current_hook_part.Anchored = true
            arg6._current_hook_part.CFrame = CFrame.new(v8, v10) * CFrame.Angles(
                0,
                3.141592653589793,
                0
            )
            BetterDebris_m:AddItem(arg6._current_hook_part, v12)

            for _, val in pairs(arg6._current_hook_part:GetDescendants()) do
                if val:IsA("SpringConstraint") then
                    val.Radius = 0
                end
            end
        end

        if arg6.ItemInterface then
            arg6.ItemInterface:PlaySpeedLines(v12)
        end

        if arg6.ClientFighter.IsLocalPlayer then
            arg6.ClientFighter.Entity:HardDash(
                v11,
                v12,
                nil,
                nil,
                "GrapplerPull"
            )

            return
        end
    elseif arg7 == "GrapplerTrackPart" then
        if not arg6:IsRendered() then
            return
        end

        v8, v10 = ...

        if not v8 or not arg6._current_hook_part or not arg6._current_hook_velocity or arg6._destroyed then
            return
        end

        table.insert(arg6._current_hook_connections, RunService.Heartbeat:Connect(function(_) -- line: 182
            -- upvalues:
            --  [1] arg6 (copy)
            --  [2] v8 (copy)
            --  [3] v10 (copy)

            if not arg6._current_hook_part or not arg6._current_hook_velocity then
                return
            end

            local v15 = v8.Position + v10

            if not arg6._current_hook_part.Position:FuzzyEq(v15) then
                arg6._current_hook_velocity.Velocity = CFrame.new(
                    arg6._current_hook_part.Position,
                    v15
                ).LookVector * arg6._current_hook_velocity.Velocity.Magnitude
            end
        end))

        return
    elseif arg7 == "GrapplerCooldown" then
        if not arg6:IsRendered() then
            return
        end

        arg6._use_cooldown_hash += 1
        arg6._use_cooldown = tick() + ...
        arg6:CooldownEffect("rbxassetid://101933751328343", arg6.Info.Cooldown, "Cooldown")

        return
    elseif arg7 == "GrapplerMiss" then
        if not arg6:IsRendered() then
            return
        end

        local v16 = arg6.Info.HookRange / arg6.Info.HookSpeed

        if arg6._current_hook_part then
            BetterDebris_m:AddItem(arg6._current_hook_part, v16)
        end

        task.spawn(function() -- line: 214
            -- upvalues:
            --  [1] arg6 (copy)
            --  [2] v16 (copy)

            local UseAnimationHash_1 = arg6._use_animation_hash
            wait(v16)

            if UseAnimationHash_1 ~= arg6._use_animation_hash then
                return
            end

            local v17 = arg6
            v17._use_animation_hash += 1
            local v18 = if not arg6.ViewModel.Info.Animations.ShootMissed then nil else 0
            arg6.ViewModel:StopAnimation("Shoot", v18)

            if arg6.ViewModel.Info.Animations.ShootWaiting then
                arg6.ViewModel:StopAnimation("ShootWaiting", v18)
            end

            if arg6.ViewModel.Info.Animations.ShootMissed then
                arg6.ViewModel:PlayAnimation("ShootMissed")
            end
        end)

        return
    else
        Custom_m.ReplicateFromServer(arg6, arg7, ...)
    end
end

function t.Destroy(arg9) -- line: 242
    -- upvalues:
    --  [1] Custom_m (copy)

    arg9:_DeleteHookPart()
    Custom_m.Destroy(arg9)
end

function t._UpdateHookPartExistence(arg10) -- line: 251
    if arg10._current_hook_part then
        arg10.ViewModel.Animator:SetInspectCooldown(math.huge)

        return
    end

    arg10.ViewModel.Animator:SetInspectCooldown(0)
end

function t._CheckCancelHooking(arg11) -- line: 259
    if arg11.IsEquipped then
        return
    end

    arg11:_DeleteHookPart()

    if arg11.ItemInterface then
        arg11.ItemInterface:PlaySpeedLines(0)
    end

    arg11.ClientFighter.Entity.Gameplay:CancelHardDash("GrapplerPull")
end

function t._DeleteHookPart(arg12) -- line: 273
    for _, val_1 in pairs(arg12._current_hook_connections) do
        val_1:Disconnect()
    end

    arg12._current_hook_connections = {}
    arg12._current_hook_velocity = nil

    if arg12._current_hook_part then
        arg12._current_hook_part:Destroy()
        arg12._current_hook_part = nil
        arg12:SetReplicate("GrapplingHookPartActive", false)
    end

    arg12.ViewModel:HideHookSubModel(0)
end

function t._ShootHookEffect(arg13) -- line: 290
    -- upvalues:
    --  [1] GameplayUtility_m (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Projectiles (copy)
    --  [4] RunService (copy)
    --  [5] WrapController_m (copy)

    arg13:_DeleteHookPart()
    local v19 = nil
    local v20 = nil

    if arg13.ClientFighter.IsLocalPlayer then
        local v21 = arg13.ClientFighter:GetCameraData(nil, nil, true)
        v19 = (v21[utf8.char(0)] * CFrame.new(0.5, -0.75, -1)).Position
        v20 = GameplayUtility_m:GetMousePositionFromCameraData(
            arg13.ClientFighter:Get("EnvironmentID"),
            arg13.ClientFighter:GetEntityLookupParams(),
            v21[utf8.char(0)],
            v21[utf8.char(1)],
            v21[utf8.char(2)],
            v21[utf8.char(3)]
        )
    else
        local v29 = arg13.ClientFighter.Entity and (arg13.ClientFighter.Entity.Head or arg13.ClientFighter.Entity.RootPart)

        if v29 then
            local v30 = CFrame.new(v29.Position) * arg13.ClientFighter:GetRotationCFrame()
            v19 = v30.Position
            v20 = GameplayUtility_m:GetMousePositionFromCameraData(
                arg13.ClientFighter:Get("EnvironmentID"),
                arg13.ClientFighter:GetEntityLookupParams(),
                v30,
                v30
            )
        end
    end

    if not v19 or not v20 or v19:FuzzyEq(v20) then
        return
    end

    local cframe_3 = CFrame.new(v19, v20)
    v20 = arg13.Info.HookRange / arg13.Info.HookSpeed + 1
    arg13.ViewModel:HideHookSubModel(v20)
    arg13._current_hook_part = Instance.new("Part")
    arg13._current_hook_part.Name = "Hook"
    arg13._current_hook_part.Size = Vector3.new(1, 1, 1)
    arg13._current_hook_part.Transparency = 1
    arg13._current_hook_part.CFrame = cframe_3
    arg13._current_hook_part.CanCollide = false
    arg13._current_hook_part.CanTouch = false
    arg13._current_hook_part.CanQuery = false
    arg13._current_hook_part.Parent = workspace
    BetterDebris_m:AddItem(arg13._current_hook_part, v20)
    arg13:SetReplicate("GrapplingHookPartActive", true)
    arg13._current_hook_part.Destroying:Connect(function() -- line: 333
        -- upvalues:
        --  [1] arg13 (copy)

        task.defer(arg13._DeleteHookPart, arg13)
    end)
    arg13._current_hook_velocity = Instance.new("BodyVelocity")
    arg13._current_hook_velocity.Velocity = arg13._current_hook_part.CFrame.LookVector * arg13.Info.HookSpeed
    arg13._current_hook_velocity.MaxForce = Vector3.new(100000, 100000, 100000)
    arg13._current_hook_velocity.Parent = arg13._current_hook_part
    local v34 = Projectiles:FindFirstChild(arg13.ViewModel.Name) or Projectiles[arg13.Name]
    v19 = v34:Clone()
    v19.PrimaryPart = v19.Primary
    v19:PivotTo(arg13._current_hook_part.CFrame)

    for _, descendant in pairs(v19:GetDescendants()) do
        if descendant:IsA("BasePart") then
            v34 = Instance.new("WeldConstraint")
            v34.Part0 = arg13._current_hook_part
            v34.Part1 = descendant
            v34.Parent = descendant
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Massless = true
            descendant.Anchored = false
        end
    end

    local v36 = arg13.ViewModel:GetMuzzleAttachment()
    local ToMuzzle = v19:FindFirstChild("_to_muzzle", true)
    local v37 = arg13.ClientFighter.Entity

    if v37 then
        v37 = arg13.ClientFighter.Entity.RootPart
    end

    if v36 and ToMuzzle and v37 then
        BetterDebris_m:AddItem(ToMuzzle, v20)

        local function update_parent() -- line: 369
            -- upvalues:
            --  [1] v36 (copy)
            --  [2] arg13 (copy)
            --  [3] v37 (copy)
            --  [4] ToMuzzle (copy)

            task.spawn(pcall, function() -- line: 370
                -- upvalues:
                --  [1] v36 (ref)
                --  [2] arg13 (ref)
                --  [3] v37 (ref)
                --  [4] ToMuzzle (ref)

                local v38 = v36:IsDescendantOf(workspace)

                if v38 then
                    v38 = arg13.IsEquipped and (v36.WorldPosition - v37.Position).Magnitude < 32
                end

                if v38 then
                    ToMuzzle.Parent = v36
                    ToMuzzle.WorldCFrame = v36.WorldCFrame

                    return
                end

                ToMuzzle.Parent = v37
                ToMuzzle.WorldCFrame = v37.CFrame
            end)
        end

        local v39 = 0
        table.insert(arg13._current_hook_connections, RunService.RenderStepped:Connect(function() -- line: 385
            -- upvalues:
            --  [1] v39 (ref)
            --  [2] v36 (copy)
            --  [3] arg13 (copy)
            --  [4] v37 (copy)
            --  [5] ToMuzzle (copy)

            if tick() < v39 then
                return
            end

            v39 = tick() + 0.1
            task.spawn(pcall, function() -- line: 370
                -- upvalues:
                --  [1] v36 (ref)
                --  [2] arg13 (ref)
                --  [3] v37 (ref)
                --  [4] ToMuzzle (ref)

                local v40 = v36:IsDescendantOf(workspace)

                if v40 then
                    v40 = arg13.IsEquipped and (v36.WorldPosition - v37.Position).Magnitude < 32
                end

                if v40 then
                    ToMuzzle.Parent = v36
                    ToMuzzle.WorldCFrame = v36.WorldCFrame

                    return
                end

                ToMuzzle.Parent = v37
                ToMuzzle.WorldCFrame = v37.CFrame
            end)
        end))
        table.insert(
            arg13._current_hook_connections,
            arg13.ClientFighter.EquippedItemChanged:Connect(update_parent)
        )
        table.insert(arg13._current_hook_connections, v36.AncestryChanged:Connect(update_parent))
        task.spawn(pcall, function() -- line: 370
            -- upvalues:
            --  [1] v36 (copy)
            --  [2] arg13 (copy)
            --  [3] v37 (copy)
            --  [4] ToMuzzle (copy)

            local v41 = v36:IsDescendantOf(workspace)

            if v41 then
                v41 = arg13.IsEquipped and (v36.WorldPosition - v37.Position).Magnitude < 32
            end

            if v41 then
                ToMuzzle.Parent = v36
                ToMuzzle.WorldCFrame = v36.WorldCFrame

                return
            end

            ToMuzzle.Parent = v37
            ToMuzzle.WorldCFrame = v37.CFrame
        end)
    end

    v19.Parent = arg13._current_hook_part
    WrapController_m:ApplyWrap(
        WrapController_m:RecordOriginalWrapProperties(v19),
        arg13:GetWrap(),
        true
    )
    arg13.ViewModel:PlayShootSounds()
end

function t._Init(arg14) -- line: 404
    arg14:GetDataChangedSignal("GrapplingHookPartActive"):Connect(function() -- line: 405
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_UpdateHookPartExistence()
    end)
    arg14.EquippedChanged:Connect(function() -- line: 409
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:_CheckCancelHooking()
    end)
    arg14:_UpdateHookPartExistence()
end

return t
