local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local t = {
    idle = "rbxassetid://17702749856",
    run = "rbxassetid://17702824140",
    walk = "rbxassetid://17702824140",
    runBack = "rbxassetid://17703291282",
    walkBack = "rbxassetid://17703291282",
    runForwardLeft = "rbxassetid://17703649282",
    walkForwardLeft = "rbxassetid://17703649282",
    runBackwardLeft = "rbxassetid://17703612699",
    walkBackwardLeft = "rbxassetid://17703612699",
    runLeft = "rbxassetid://17703296049",
    runLeft2 = "rbxassetid://17703296049",
    walkLeft = "rbxassetid://17703296049",
    walkLeft2 = "rbxassetid://17703296049",
    runForwardRight = "rbxassetid://17703652486",
    walkForwardRight = "rbxassetid://17703652486",
    runBackwardRight = "rbxassetid://17703646109",
    walkBackwardRight = "rbxassetid://17703646109",
    runRight = "rbxassetid://17703299653",
    runRight2 = "rbxassetid://17703299653",
    walkRight = "rbxassetid://17703299653",
    walkRight2 = "rbxassetid://17703299653"
}
local t_1 = {}
t_1.Start = {
    { "SlidingStartForward", "LookVector", 1 },
    { "SlidingStartRightward", "RightVector", 1 },
    { "SlidingStartBackward", "LookVector", -1 },
    { "SlidingStartLeftward", "RightVector", -1 }
}
t_1.Loop = {
    { "SlidingLoopForward", "LookVector", 1 },
    { "SlidingLoopRightward", "RightVector", 1 },
    { "SlidingLoopBackward", "LookVector", -1 },
    { "SlidingLoopLeftward", "RightVector", -1 }
}
local t_12 = {}
t_12.__index = t_12

function t_12.new(arg1) -- line: 66
    -- upvalues:
    --  [1] t_12 (copy)

    local t_13 = setmetatable({}, t_12)
    t_13.ClientFighterCharacter = arg1
    t_13._original_humanoid_animations = {}
    t_13._sliding_animation_hash = 0
    t_13._sliding_animation_track = nil
    t_13:_Init()

    return t_13
end

function t_12.PlaySlidingAnimationAsync(arg2, arg3) -- line: 84
    -- upvalues:
    --  [1] PreloadController_m (copy)
    --  [2] RunService (copy)

    arg2:StopSlidingAnimation()

    if not arg2.ClientFighterCharacter.ClientFighter.IsLocalPlayer then
        return
    end

    arg2._sliding_animation_hash += 1
    local SlidingAnimationHash = arg2._sliding_animation_hash
    local v1 = arg2:_GetSlidingAnimation("Start", arg3)
    local LoadAnimation = arg2.ClientFighterCharacter.Humanoid.LoadAnimation
    local v2 = v1
    local Humanoid = arg2.ClientFighterCharacter.Humanoid
    local v3 = PreloadController_m

    if v2 then
        v2 = v1[1]
    end

    local Success, v4 = pcall(LoadAnimation, Humanoid, v3:GetPreloadedAnimation(v2))

    if Success then
        arg2._sliding_animation_track = v4
        arg2._sliding_animation_track:Play()
        wait(0.4)
    end

    if SlidingAnimationHash ~= arg2._sliding_animation_hash then
        return
    end

    v4 = nil

    while true do
        if SlidingAnimationHash ~= arg2._sliding_animation_hash then
            break
        end

        local v5 = arg2:_GetSlidingAnimation("Loop", arg3)

        if v5 and v5[1] ~= v4 then
            v4 = v5[1]

            if arg2._sliding_animation_track then
                arg2._sliding_animation_track:Stop(0)
                arg2._sliding_animation_track:Destroy()
                arg2._sliding_animation_track = nil
            end

            local Success_1, Result = pcall(
                arg2.ClientFighterCharacter.Humanoid.LoadAnimation,
                arg2.ClientFighterCharacter.Humanoid,
                PreloadController_m:GetPreloadedAnimation(v4)
            )

            if Success_1 then
                arg2._sliding_animation_track = Result
                arg2._sliding_animation_track:Play(0)
            end
        end

        RunService.RenderStepped:Wait()
    end
end

function t_12.StopSlidingAnimation(arg4) -- line: 134
    arg4._sliding_animation_hash += 1

    if arg4._sliding_animation_track then
        arg4._sliding_animation_track:Stop(0)
        arg4._sliding_animation_track = nil
    end
end

function t_12.Update(_, _, _) -- line: 143
end

function t_12.Destroy(arg8) -- line: 147
    arg8:StopSlidingAnimation()
end

function t_12._GetSlidingAnimation(arg9, arg10, arg11) -- line: 155
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] Utility_m (copy)

    local v6 = arg11 * Vector3.new(1, 0, 1)
    local v7 = arg9.ClientFighterCharacter.ClientFighter:GetRotationCFrame()
    v7 = math.huge
    local v8 = nil

    for _, val in pairs(t_1[arg10]) do
        local v13 = Utility_m:AngleBetweenVectors(
            v6,
            arg9.ClientFighterCharacter.ClientFighter:GetRotationCFrame()[val[2]] * val[3] * Vector3.new(1, 0, 1)
        )

        if v7 > v13 then
            v7 = v13
            v8 = val
        end
    end

    return v8
end

function t_12._UpdateHumanoidAnimations(arg12) -- line: 174
    -- upvalues:
    --  [1] t (copy)

    if
        not arg12.ClientFighterCharacter.ClientFighter.IsLocalPlayer
        or not arg12.ClientFighterCharacter:IsInWorld()
    then
        return
    end

    local Animate = arg12.ClientFighterCharacter.Model:FindFirstChild("Animate")

    if not Animate then
        return
    end

    local v14 = arg12.ClientFighterCharacter.ClientFighter:Get("IsCrouching")

    for key_1, val_1 in pairs(t) do
        local v15 = Animate:FindFirstChild(key_1)

        if v15 then
            local v16 = v14 and val_1 or nil

            for _, val_2 in pairs(v15:GetChildren()) do
                local v18 = arg12._original_humanoid_animations[val_2]
                local v19 = arg12._original_humanoid_animations
                v18 = v18 or val_2.AnimationId
                v19[val_2] = v18
                v19 = v16 or arg12._original_humanoid_animations[val_2]
                val_2.AnimationId = v19
            end
        end
    end

    if Animate:FindFirstChild("Refresh") then
        Animate.Refresh:Fire()
    end
end

function t_12._Init(arg13) -- line: 207
    arg13.ClientFighterCharacter.EnteredWorld:Connect(function() -- line: 208
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateHumanoidAnimations()
    end)
    arg13.ClientFighterCharacter.Died:Connect(function() -- line: 212
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:StopSlidingAnimation()
    end)
    arg13.ClientFighterCharacter:AddConnection(arg13.ClientFighterCharacter.ClientFighter:GetDataChangedSignal(
        "IsCrouching"
    ):Connect(function() -- line: 216
        -- upvalues:
        --  [1] arg13 (copy)

        arg13:_UpdateHumanoidAnimations()
    end))
    arg13:_UpdateHumanoidAnimations()
end

return t_12
