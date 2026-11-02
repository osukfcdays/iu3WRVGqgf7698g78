local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
local UnlockParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.UnlockParticles
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.UnlockingChanged = Signal_m.new()
    t_1.Scene = arg1
    t_1.Model = t_1.Scene.Model:WaitForChild("UnlockEffect")
    t_1.IsUnlocking = false
    t_1._animation_controller = t_1.Model:WaitForChild("AnimationController")
    t_1._original_cframe = t_1.Model:GetPivot()
    t_1._idle_animation_loaded = false
    t_1._animation_track = nil
    t_1._animation_hash = 0
    t_1:_Init()

    return t_1
end

function t.StopAnimation(arg2, _) -- line: 40
    arg2:_SetIsUnlocking(false)
    arg2._animation_hash += 1

    if arg2._animation_track then
        arg2._animation_track:Stop(0)
    end
end

function t.PlayAnimation(arg4) -- line: 49
    arg4:StopAnimation(true)
    arg4:_SetIsUnlocking(true)
    local Success, Result = pcall(arg4._PlayAnimationAsync, arg4)

    if not Success then
        warn("Unlock animation failed, error:", Result)
    end

    arg4:_SetIsUnlocking(false)
end

function t.OnStateChanged(arg5) -- line: 62
    arg5:_PlayIdleAnimation()
    arg5:_UpdateCFrame()
    arg5:StopAnimation()
end

function t.OnOpen(arg6) -- line: 68
    arg6:_PlayIdleAnimation()
end

function t._PlayAnimationAsync(arg7) -- line: 76
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] PreloadController_m (copy)
    --  [3] BetterDebris_m (copy)
    --  [4] UnlockParticles (copy)

    arg7._animation_hash += 1
    local AnimationHash = arg7._animation_hash
    arg7.Model.Key.a1.Trail.Enabled = true
    Utility_m:CreateSound(
        "rbxassetid://17662575024",
        1.5,
        1,
        script,
        true,
        5
    )

    if not arg7._animation_track then
        arg7._animation_track = arg7._animation_controller:LoadAnimation(
            PreloadController_m:GetPreloadedAnimation("WeaponUnlockPlay")
        )
    end

    arg7._animation_track:Play(0)
    wait(2.25)

    if AnimationHash ~= arg7._animation_hash then
        return
    end

    Utility_m:CreateSound(
        "rbxassetid://17662574898",
        1.5,
        1,
        script,
        true,
        5
    )
    wait(0.25)

    if AnimationHash ~= arg7._animation_hash then
        return
    end

    arg7.Model.Key.a1.Trail.Enabled = false
    Utility_m:CreateSound(
        "rbxassetid://17662575175",
        1,
        1,
        script,
        true,
        5
    )
    Utility_m:PlayParticles(arg7.Model.ChainsHolder.Attachment)
    wait(1)

    if AnimationHash ~= arg7._animation_hash then
        return
    end

    Utility_m:CreateSound(
        "rbxassetid://17662623697",
        1.5,
        1,
        script,
        true,
        5
    )
    local boundingCFrame, boundingSize = arg7.Scene.Equipment.FloatingModel:GetBoundingBox()
    local Part = Instance.new("Part")
    Part.CFrame = boundingCFrame
    Part.Size = boundingSize
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Parent = workspace
    BetterDebris_m:AddItem(Part, 10)

    for _, val in pairs(UnlockParticles:GetChildren()) do
        local v3 = val:Clone()
        v3.Parent = Part
        task.delay(val:GetAttribute("EmitDelay") or 0, v3.Emit, v3, val:GetAttribute("EmitCount"))
    end
end

function t._PlayIdleAnimation(arg8) -- line: 135
    -- upvalues:
    --  [1] PreloadController_m (copy)

    arg8._idle_animation_loaded = false

    for _ = 1, 3 do
        local Success_1, Result_1 = pcall(function() -- line: 139
            -- upvalues:
            --  [1] arg8 (copy)
            --  [2] PreloadController_m (ref)

            arg8._animation_controller:LoadAnimation(
                PreloadController_m:GetPreloadedAnimation("WeaponUnlockIdle")
            ):Play(0)
        end)

        if Success_1 then
            arg8._idle_animation_loaded = true

            return
        end

        warn("Failed to load unlock model idle, error", Result_1)
    end
end

function t._UpdateCFrame(arg9) -- line: 152
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Pages_m (copy)

    local v5 = arg9.Scene.Equipment:GetSelectedWeapon()
    local v6 = v5

    if v6 then
        v6 = not PlayerDataController_m:GetWeaponData(v5)
    end

    v5 = if not v6 then CFrame.identity else if Pages_m.PageSystem.CurrentPage then CFrame.identity else arg9._idle_animation_loaded and arg9._original_cframe or CFrame.identity
    arg9.Model:PivotTo(v5)
end

function t._UpdateKey(arg10) -- line: 160
    local v7 = if not arg10.IsUnlocking then 1 else 0
    arg10.Model.Key.LocalTransparencyModifier = v7
    arg10.Model.Key.a1.Trail.LocalTransparencyModifier = v7
    arg10.Model.Key.sparkle.LocalTransparencyModifier = v7
end

function t._SetIsUnlocking(arg11, arg12) -- line: 168
    if arg11.IsUnlocking == arg12 then
        return
    end

    arg11.IsUnlocking = arg12
    arg11.UnlockingChanged:Fire()
end

function t._Init(arg13) -- line: 177
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] Pages_m (copy)

    arg13.UnlockingChanged:Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateKey()
    end)
    PlayerDataController_m:GetDataChangedSignal("WeaponInventory"):Connect(function() -- line: 182
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateCFrame()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 186
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateCFrame()
    end)
    arg13:_UpdateKey()
end

return t
