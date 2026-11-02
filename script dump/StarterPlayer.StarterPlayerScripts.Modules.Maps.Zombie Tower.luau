local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseTower_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.Maps:WaitForChild("BaseTower")
)
local ChickenTrojanExplosionEffect = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "ChickenTrojanExplosionEffect"
)
local t = {
    "rbxassetid://98587858115094",
    "rbxassetid://72483809453170",
    "rbxassetid://129922197154277",
    "rbxassetid://113975047764762",
    "rbxassetid://121368500414901"
}
local t_1 = {
    "rbxassetid://116380542394210",
    "rbxassetid://125379277208360",
    "rbxassetid://96610433230092",
    "rbxassetid://122643453923681",
    "rbxassetid://94468135009167",
    "rbxassetid://133107467882960",
    "rbxassetid://122210005572726",
    "rbxassetid://102260065267741"
}
local t_2 = {
    { 0, 24 },
    { 9.97, 24 },
    { 10.53, 17 },
    { 10.87, 17 },
    { 11.62, 30 },
    { 11.83, 30 },
    { 12.55, 17 },
    { 13.03, 30 },
    { 16.52, 30 },
    { 17.53, 10 },
    { 19.12, 30, true },
    { 22.9, 50 },
    { 23.4, 20 },
    { 24.58, 50 },
    { 26.02, 35 }
}
local t_18 = setmetatable({}, BaseTower_m)
t_18.__index = t_18

function t_18.new(...) -- line: 41
    -- upvalues:
    --  [1] BaseTower_m (copy)
    --  [2] t_18 (copy)

    local t_19 = setmetatable(BaseTower_m.new(...), t_18)
    t_19:_Init()

    return t_19
end

function t_18.ReplicateFromServer(arg1, arg2, ...) -- line: 53
    -- upvalues:
    --  [1] BaseTower_m (copy)

    if arg2 == "ChickenTrojanEffect" then
        if not arg1:IsRendered() then
            return
        end

        arg1:_ChickenTrojanEffect(...)

        return
    elseif arg2 == "GiantChombieCutscene" then
        if not arg1:IsRendered() then
            return
        end

        arg1:_PlayCutscene(...)

        return
    else
        BaseTower_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t_18._PlayCutscene(arg3, arg4, arg5, arg6) -- line: 75
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] t_2 (copy)
    --  [3] t_1 (copy)

    local function init_callback(_) -- line: 76
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] arg4 (copy)
        --  [3] Utility_m (ref)
        --  [4] arg5 (copy)

        arg3.CutsceneLogic:PlayAnimation(arg4, arg3.CutsceneLogic:GetPreloadedAnimation(
            "GiantChombieHumanoid"
        ), function(_) -- line: 77
            -- upvalues:
            --  [1] Utility_m (ref)
            --  [2] arg5 (ref)
            --  [3] arg3 (ref)

            task.delay(23.1, Utility_m.PlayParticles, Utility_m, arg5:WaitForChild("SlamParticles"))
            wait(1.25)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.35,
                0.675,
                script,
                true,
                10
            )
            wait(3.2)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.6,
                0.7,
                script,
                true,
                10
            )
            wait(2.15)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.65,
                0.725,
                script,
                true,
                10
            )
            wait(1.4)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.7,
                0.75,
                script,
                true,
                10
            )
            wait(1.5)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.75,
                0.775,
                script,
                true,
                10
            )
            wait(3.45)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                1.5,
                0.8,
                script,
                true,
                10
            )
            wait(2.3)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.3,
                0.75,
                script,
                true,
                10
            )
            wait(2)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                0.25,
                1,
                script,
                true,
                10
            )
            wait(3.85)
            arg3:CreateSound(
                "rbxassetid://98587858115094",
                1,
                1,
                script,
                true,
                10
            )
            wait(2)
            arg3:CreateSound(
                "rbxassetid://72483809453170",
                1.25 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true,
                10
            )
            arg3:CreateSound(
                "rbxassetid://129922197154277",
                1.25 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true,
                10
            )
            arg3:CreateSound(
                "rbxassetid://113975047764762",
                1.25 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true,
                10
            )
            wait(1.8)
            arg3:CreateSound(
                "rbxassetid://121368500414901",
                1.5,
                0.875,
                script,
                true,
                10
            )
        end)
    end

    local function renderstep_callback(_) -- line: 106
    end

    arg3.CutsceneLogic:PlayCutscene(
        arg6,
        init_callback,
        renderstep_callback,
        arg5:WaitForChild("CameraRig"):WaitForChild("AnimationController"),
        arg3.CutsceneLogic:GetPreloadedAnimation("GiantChombieCamera"),
        t_2,
        #t_1,
        "GiantChombiePlayer",
        true
    )
end

function t_18._ChickenTrojanEffect(arg10, arg11, arg12, arg13) -- line: 125
    -- upvalues:
    --  [1] ChickenTrojanExplosionEffect (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)

    local v15 = tick() + arg12

    while true do
        if not (v15 > tick()) then
            break
        end

        local v16 = ChickenTrojanExplosionEffect:Clone()
        local cframe = CFrame.new(arg11)
        local v17 = math.random() - 0.5
        v16.CFrame = cframe + Vector3.new(v17, math.random() - 0.5, math.random() - 0.5) * 12
        v16.Parent = workspace
        BetterDebris_m:AddItem(v16, 5)
        Utility_m:ScaleParticleEmitter(v16, 0.5 + 0.75 * math.random())
        Utility_m:PlayParticles(v16)
        arg10:CreateSound(
            "rbxassetid://97884024654711",
            0.875 + 0.25 * math.random(),
            1 + 0.25 * math.random(),
            v16,
            true,
            5
        )
        wait(arg13 or 0.2)
    end
end

function t_18._Setup(arg14) -- line: 142
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] t (copy)

    for key, val in pairs(t_1) do
        arg14.CutsceneLogic:PreloadAnimation("GiantChombiePlayer" .. key, val)
    end

    arg14.CutsceneLogic:PreloadAnimation("GiantChombieHumanoid", "rbxassetid://80790358034810")
    arg14.CutsceneLogic:PreloadAnimation("GiantChombieCamera", "rbxassetid://85660296117721")
    arg14.CutsceneLogic:PreloadCutsceneSoundIDs(t)
end

function t_18._Init(arg15) -- line: 152
    arg15:_Setup()
    arg15.ClientDuel:SetReplicate("DuelMusic", "ZombieTower")
end

return t_18
