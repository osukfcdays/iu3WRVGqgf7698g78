local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local SoundLibrary_m = require(ReplicatedStorage.Modules.SoundLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local ClientEnemy_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy
)
local t = {
    "rbxassetid://72483809453170",
    "rbxassetid://129922197154277",
    "rbxassetid://113975047764762"
}
local SlamParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc.SlamParticles
local t_1 = setmetatable({}, ClientEnemy_m)
t_1.__index = t_1

function t_1.new(...) -- line: 21
    -- upvalues:
    --  [1] ClientEnemy_m (copy)
    --  [2] t_1 (copy)
    --  [3] SoundLibrary_m (copy)
    --  [4] t (copy)

    local t_2 = setmetatable(ClientEnemy_m.new(...), t_1)
    t_2._slam_vulnerable_animation = t_2:_CreateAnimation("rbxassetid://129758877701887")
    t_2._slam_animation = t_2:_CreateAnimation("rbxassetid://97481875605208")
    t_2._preloaded_sounds = SoundLibrary_m:PreloadSounds(t, nil, "rbxassetid://98587858115094")
    t_2:_Init()

    return t_2
end

function t_1.ReplicateFromServer(arg1, arg2, ...) -- line: 37
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CameraController_m (copy)
    --  [3] SlamParticles (copy)
    --  [4] BetterDebris_m (copy)
    --  [5] t (copy)
    --  [6] ClientEnemy_m (copy)

    if arg2 == "SlamEffect" then
        if not arg1:IsRendered() then
            return
        end

        local v2, v3, v4, v5, v6 = ...
        local Success, Result = pcall(
            arg1.Humanoid.LoadAnimation,
            arg1.Humanoid,
            if v6 then arg1._slam_vulnerable_animation else arg1._slam_animation
        )

        if Success then
            table.insert(arg1._animation_cleanup, Result)
            Result:Play()
        end

        wait(v4)
        Utility_m:CreateSound(
            "rbxassetid://98587858115094",
            0.875 + 0.25 * math.random(),
            0.9 + 0.2 * math.random(),
            arg1.RootPart,
            true,
            10,
            400,
            400
        )
        wait(v5)

        if not arg1:IsAlive() then
            return
        end

        local maximum = math.max(
            0,
            1 - (arg1.RootPart.Position - workspace.CurrentCamera.CFrame.Position).Magnitude / 400
        )
        CameraController_m:ShakeOnce(
            maximum * 50,
            maximum * 10,
            0.1,
            0.4,
            Vector3.new(1, 1, 0),
            Vector3.new(0, 0, 0)
        )
        local v13 = SlamParticles:Clone()
        v13.CFrame = CFrame.new(v2) + Vector3.new(0, 0.1, 0)
        v13.Parent = workspace
        BetterDebris_m:AddItem(v13, 10)
        Utility_m:ScaleParticleEmitter(v13, v3 / 32)
        Utility_m:PlayParticles(v13)

        for _, val in pairs(t) do
            Utility_m:CreateSound(
                val,
                0.875 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                arg1.RootPart,
                true,
                10,
                400,
                400
            )
        end

        return
    else
        ClientEnemy_m.ReplicateFromServer(arg1, arg2, ...)

        return
    end
end

function t_1.Destroy(arg3) -- line: 82
    -- upvalues:
    --  [1] ClientEnemy_m (copy)

    for _, val_1 in pairs(arg3._preloaded_sounds) do
        val_1:Destroy()
    end

    ClientEnemy_m.Destroy(arg3)
end

function t_1._Setup(arg4) -- line: 94
    -- upvalues:
    --  [1] ContentProvider (copy)

    task.spawn(
        pcall,
        ContentProvider.PreloadAsync,
        ContentProvider,
        { arg4._slam_animation, arg4._slam_vulnerable_animation }
    )
end

function t_1._Init(arg5) -- line: 98
    arg5:_Setup()
end

return t_1
