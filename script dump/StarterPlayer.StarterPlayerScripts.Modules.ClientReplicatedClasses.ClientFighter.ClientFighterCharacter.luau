local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local ClientHumanoidEntity_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity
)
local ChatBubbleMover_m = require(script:WaitForChild("ChatBubbleMover"))
local CustomNametag_m = require(script:WaitForChild("CustomNametag"))
local Animations_m = require(script:WaitForChild("Animations"))
local Flashlight_m = require(script:WaitForChild("Flashlight"))
local Visibility_m = require(script:WaitForChild("Visibility"))
local Airborne_m = require(script:WaitForChild("Airborne"))
local Gameplay_m = require(script:WaitForChild("Gameplay"))
local Snowball_m = require(script:WaitForChild("Snowball"))
local Visuals_m = require(script:WaitForChild("Visuals"))
local Avatar_m = require(script:WaitForChild("Avatar"))
local Boosts_m = require(script:WaitForChild("Boosts"))
local Sounds_m = require(script:WaitForChild("Sounds"))
local Joints_m = require(script:WaitForChild("Joints"))
local State_m = require(script:WaitForChild("State"))
local Arms_m = require(script:WaitForChild("Arms"))
local t = setmetatable({}, ClientHumanoidEntity_m)
t.__index = t

function t.new(arg1, arg2) -- line: 28
    -- upvalues:
    --  [1] ClientHumanoidEntity_m (copy)
    --  [2] t (copy)
    --  [3] Signal_m (copy)
    --  [4] State_m (copy)
    --  [5] ChatBubbleMover_m (copy)
    --  [6] CustomNametag_m (copy)
    --  [7] Animations_m (copy)
    --  [8] Flashlight_m (copy)
    --  [9] Visibility_m (copy)
    --  [10] Airborne_m (copy)
    --  [11] Gameplay_m (copy)
    --  [12] Snowball_m (copy)
    --  [13] Visuals_m (copy)
    --  [14] Avatar_m (copy)
    --  [15] Boosts_m (copy)
    --  [16] Sounds_m (copy)
    --  [17] Joints_m (copy)
    --  [18] Arms_m (copy)

    local t_1 = setmetatable(ClientHumanoidEntity_m.new(arg1), t)
    t_1.EnteredWorld = Signal_m.new()
    t_1.BoostsChanged = Signal_m.new()
    t_1.AirborneChanged = Signal_m.new()
    t_1.RedirectSliding = Signal_m.new()
    t_1.ClientFighter = arg2
    t_1.Player = arg1.Player
    t_1.Head = nil
    t_1.State = State_m.new(t_1)
    t_1.ChatBubbleMover = ChatBubbleMover_m.new(t_1)
    t_1.CustomNametag = CustomNametag_m.new(t_1)
    t_1.Animations = Animations_m.new(t_1)
    t_1.Flashlight = Flashlight_m.new(t_1)
    t_1.Visibility = Visibility_m.new(t_1)
    t_1.Airborne = Airborne_m.new(t_1)
    t_1.Gameplay = Gameplay_m.new(t_1)
    t_1.Snowball = Snowball_m.new(t_1)
    t_1.Visuals = Visuals_m.new(t_1)
    t_1.Avatar = Avatar_m.new(t_1)
    t_1.Boosts = Boosts_m.new(t_1)
    t_1.Sounds = Sounds_m.new(t_1)
    t_1.Joints = Joints_m.new(t_1)
    t_1.Arms = Arms_m.new(t_1)
    t_1._destroyed = false
    t_1._is_in_world = false
    t_1:_Init()

    return t_1
end

function t.IsRendered(arg3) -- line: 67
    -- upvalues:
    --  [1] ClientHumanoidEntity_m (copy)

    local v17 = ClientHumanoidEntity_m.IsRendered(arg3)

    if v17 then
        v17 = not arg3.ClientFighter:Get("IsHiddenByEmotes")
    end

    return v17
end

function t.IsAlive(arg4, ...) -- line: 71
    return arg4.State:IsAliveCached(...)
end

function t.IsGrounded(arg5, ...) -- line: 75
    return arg5.State:IsGroundedCached(...)
end

function t.IsAirborne(arg6, ...) -- line: 79
    return arg6.Airborne:IsActive(...)
end

function t.GetBoostByName(arg7, ...) -- line: 83
    return arg7.Boosts:GetBoostByName(...)
end

function t.GetBoost(arg8, ...) -- line: 87
    return arg8.Boosts:GetBoost(...)
end

function t.GetFOVOffset(arg9, ...) -- line: 91
    return arg9.Gameplay:GetFOVOffset(...)
end

function t.IsInWorld(arg10) -- line: 95
    return arg10._is_in_world
end

function t.GetClampedVelocity(arg11) -- line: 99
    -- upvalues:
    --  [1] CONSTANTS_m (copy)

    if not arg11.RootPart then
        return Vector3.new(0, 0, 0)
    end

    return arg11.RootPart.Velocity.Magnitude <= 0.01 and arg11.RootPart.Velocity or arg11.RootPart.Velocity.Unit * math.clamp(
        arg11.RootPart.Velocity.Magnitude,
        0,
        CONSTANTS_m.BASE_WALKSPEED * 2.5
    )
end

function t.GetFloor(arg12, arg13) -- line: 105
    -- upvalues:
    --  [1] Utility_m (copy)

    local v19 = arg13 or 3.5 * arg12.RootPart.Size.Z
    local raycastResult = Utility_m:Raycast(
        arg12.RootPart.Position,
        arg12.RootPart.Position - Vector3.new(0, 1, 0),
        v19,
        arg12.ClientFighter:GetRaycastWhitelist(),
        Enum.RaycastFilterType.Include
    )

    return raycastResult.Instance, raycastResult
end

function t.GetArmsData(arg14) -- line: 112
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:GetArmsData(arg14.Model)
end

function t.WaitUntilIsInWorld(arg15) -- line: 116
    if not arg15._is_in_world then
        arg15.EnteredWorld:Wait()
    end
end

function t.HardDash(arg16, ...) -- line: 122
    return arg16.Gameplay:HardDash(...)
end

function t.WarpTo(arg17, ...) -- line: 126
    return arg17.Gameplay:WarpTo(...)
end

function t.SetRedFigureMode(arg18, ...) -- line: 130
    return arg18.Visuals:SetRedFigureMode(...)
end

function t.AirborneRedirect(arg19, ...) -- line: 134
    return arg19.Airborne:Redirect(...)
end

function t.AirborneTrigger(arg20, ...) -- line: 138
    return arg20.Airborne:Trigger(...)
end

function t.AirborneCancel(arg21, ...) -- line: 142
    return arg21.Airborne:Cancel(...)
end

function t.SetHitboxesVisible(arg22, ...) -- line: 146
    return arg22.Visibility:SetHitboxesVisible(...)
end

function t.CloneModel(arg23, ...) -- line: 150
    return arg23.Visibility:CloneModel(...)
end

function t.SetTranslucent(arg24, ...) -- line: 154
    arg24.Visibility:SetTranslucent(...)
    arg24.Avatar:SetTranslucent(...)
end

function t.SetBoost(arg25, ...) -- line: 159
    return arg25.Boosts:SetBoost(...)
end

function t.RemoveBoost(arg26, ...) -- line: 163
    return arg26.Boosts:RemoveBoost(...)
end

function t.SetIKControlTargetItem(arg27, ...) -- line: 167
    return arg27.Arms:SetIKControlTargetItem(...)
end

function t.DisableIKArms(arg28, ...) -- line: 171
    return arg28.Arms:DisableIKArms(...)
end

function t.PlaySlidingAnimationAsync(arg29, ...) -- line: 175
    return arg29.Animations:PlaySlidingAnimationAsync(...)
end

function t.StopSlidingAnimation(arg30, ...) -- line: 179
    return arg30.Animations:StopSlidingAnimation(...)
end

function t.AddConnection(arg31, arg32) -- line: 183
    table.insert(arg31._connections, arg32)
end

function t.Update(arg33, arg34, arg35) -- line: 187
    arg33.State:Update(arg34, arg35)
    arg33.Sounds:Update(arg34, arg35)
    arg33.ChatBubbleMover:Update(arg34, arg35)
    arg33.CustomNametag:Update(arg34, arg35)
    arg33.Animations:Update(arg34, arg35)
    arg33.Flashlight:Update(arg34, arg35)
    arg33.Airborne:Update(arg34, arg35)
    arg33.Snowball:Update(arg34, arg35)
    arg33.Visuals:Update(arg34, arg35)
    arg33.Boosts:Update(arg34, arg35)
    arg33.Joints:Update(arg34, arg35)
    arg33.Arms:Update(arg34, arg35)
end

function t.ReplicateFromServer(arg36, arg37, ...) -- line: 202
    -- upvalues:
    --  [1] ClientHumanoidEntity_m (copy)

    if arg37 == "HurtEffect" then
        if not arg36:IsRendered() then
            return
        end

        arg36.Visuals:HurtEffect(...)
        arg36:_HurtEffect(...)

        return
    else
        if arg37 == "HealEffect" then
            if not arg36:IsRendered() then
                return
            end

            if arg36.ClientFighter.FighterInterface then
                arg36.ClientFighter.FighterInterface:HealEffect(...)

                return
            end
        else
            if arg37 == "BlindedEffect" then
                if not arg36:IsRendered() or arg36.ClientFighter:Get("IsSpectating") then
                    return
                end

                arg36.Visuals:BlindedEffect(...)

                return
            end

            if arg37 == "KnockbackEffect" then
                arg36.Airborne:FromServer(...)

                return
            end

            if arg37 == "CancelKnockbackEffect" then
                arg36.Airborne:Cancel(...)
                arg36.ClientFighter.StopSliding:Fire()

                return
            end

            if arg37 == "SetBoost" then
                arg36:SetBoost(...)

                return
            end

            if arg37 == "ThrowSnowball" then
                arg36.Snowball:ThrowSnowball(...)

                return
            end

            if arg37 == "WarpTo" then
                arg36:WarpTo(...)

                return
            end

            ClientHumanoidEntity_m.ReplicateFromServer(arg36, arg37, ...)
        end

        return
    end
end

function t.Destroy(arg38) -- line: 240
    -- upvalues:
    --  [1] ClientHumanoidEntity_m (copy)

    arg38._destroyed = true
    arg38.EnteredWorld:Destroy()
    arg38.BoostsChanged:Destroy()
    arg38.AirborneChanged:Destroy()
    arg38.RedirectSliding:Destroy()
    arg38.State:Destroy()
    arg38.ChatBubbleMover:Destroy()
    arg38.CustomNametag:Destroy()
    arg38.Animations:Destroy()
    arg38.Flashlight:Destroy()
    arg38.Visibility:Destroy()
    arg38.Airborne:Destroy()
    arg38.Gameplay:Destroy()
    arg38.Snowball:Destroy()
    arg38.Visuals:Destroy()
    arg38.Avatar:Destroy()
    arg38.Boosts:Destroy()
    arg38.Sounds:Destroy()
    arg38.Joints:Destroy()
    arg38.Arms:Destroy()
    ClientHumanoidEntity_m.Destroy(arg38)
end

function t._SetupAsync(arg39) -- line: 271
    while true do
        if arg39.Model:IsDescendantOf(workspace) then
            break
        end

        arg39.Model.AncestryChanged:Wait()
    end

    if arg39._destroyed then
        return
    end

    arg39.Head = arg39.Model:WaitForChild("Head")

    if arg39._destroyed then
        return
    end

    arg39._is_in_world = true
    arg39.EnteredWorld:Fire()
end

function t._Init(arg40) -- line: 290
    arg40.Boosts.BoostsChanged:Connect(function(...) -- line: 291
        -- upvalues:
        --  [1] arg40 (copy)

        arg40.BoostsChanged:Fire(...)
    end)
    arg40.Airborne.AirborneChanged:Connect(function(...) -- line: 295
        -- upvalues:
        --  [1] arg40 (copy)

        arg40.AirborneChanged:Fire(...)
    end)
    arg40.Gameplay.RedirectSliding:Connect(function(...) -- line: 299
        -- upvalues:
        --  [1] arg40 (copy)

        arg40.RedirectSliding:Fire(...)
    end)
    task.spawn(arg40._SetupAsync, arg40)
end

return t
