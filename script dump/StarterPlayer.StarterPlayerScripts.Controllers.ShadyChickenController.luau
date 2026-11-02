local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local PreloadController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.PreloadController)
local t = {}
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._shady_chicken_enabled = false
    t_1:_Init()

    return t_1
end

function t._UpdateChickenState(arg1, arg2) -- line: 35
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)
    --  [3] Utility_m (copy)
    --  [4] PreloadController_m (copy)

    if arg1._shady_chicken_enabled or not PlayerDataController_m:Get("ShadyChickenMissionStarted") then
        return
    end

    local v1 = CollectionService:GetTagged("LobbyShadyChicken")[1]

    if not v1 then
        return
    end

    arg1._shady_chicken_enabled = true
    task.defer(function() -- line: 48
        -- upvalues:
        --  [1] Utility_m (ref)
        --  [2] arg2 (copy)
        --  [3] v1 (copy)

        Utility_m:RenderstepForLoop(0, 100, if not arg2 then 1 else 100, function(arg3) -- line: 49
            -- upvalues:
            --  [1] v1 (ref)

            local v4 = arg3 / 100

            for index = 1, 3 do
                v1:WaitForChild("Hologram"):WaitForChild("Neon"):WaitForChild(index).LocalTransparencyModifier = v4
            end
        end)
    end)

    if not arg2 then
        Utility_m:CreateSound(
            "rbxassetid://92573395473684",
            1,
            1,
            script,
            true,
            10
        )

        for index_1 = 1, 14 do
            v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
                "LoginScreen"
            ):WaitForChild("LoginWindow"):WaitForChild("Login"):WaitForChild("Title").Text = string.rep(
                "\226\128\162",
                index_1 - 1
            ) .. string.sub("ILOVERIVALS628", index_1, index_1)
            wait(0.1847857142857143)
        end

        v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
            "LoginScreen"
        ):WaitForChild("LoginWindow").Visible = false
        v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
            "LoginScreen"
        ):WaitForChild("Dots").Visible = true
        v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
            "LoginScreen"
        ):WaitForChild("Dots"):AddTag("UILoadingDots")
        wait(4)
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )
        Utility_m:CreateSound(
            "rbxassetid://85855678277731",
            1.5,
            1,
            script,
            true,
            5
        )
    end

    v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
        "LoginScreen"
    ):WaitForChild("Dots"):RemoveTag("UILoadingDots")
    v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
        "LoginScreen"
    ).Visible = false
    v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
        "ErrorScreen"
    ).Visible = true
    v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceLight").Color = Color3.fromRGB(
        255,
        50,
        50
    )
    v1:WaitForChild("Pad"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild(
        "ImageLabel"
    ).ImageColor3 = Color3.fromRGB(255, 50, 50)

    if not arg2 then
        task.spawn(
            Utility_m.RenderstepForLoop,
            Utility_m,
            0,
            100,
            2,
            function(arg4) -- line: 86
                -- upvalues:
                --  [1] v1 (copy)

                local v6 = 40 * (1 - (arg4 / 100) ^ 2)
                v1:WaitForChild("Screen"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild(
                    "ErrorScreen"
                ):WaitForChild("LoginWindow").Position = UDim2.new(
                    0.5,
                    v6 * (math.random() - 0.5),
                    0.5,
                    v6 * 0.25 * (math.random() - 0.5)
                )
            end
        )
        wait(1.5)
    end

    pcall(function() -- line: 96
        -- upvalues:
        --  [1] v1 (copy)
        --  [2] PreloadController_m (ref)

        v1:WaitForChild("Rig"):WaitForChild("Humanoid"):LoadAnimation(
            PreloadController_m:GetPreloadedAnimation("ShadyChickenIdle")
        ):Play(0)
    end)
    v1:WaitForChild("Vent"):WaitForChild("Broken").Transparency = 0
    v1:WaitForChild("Vent"):WaitForChild("NotBroken"):Destroy()

    if not arg2 then
        Utility_m:PlayParticles(v1:WaitForChild("Vent"):WaitForChild("VFX"))
        Utility_m:CreateSound(
            "rbxassetid://73297732048740",
            2,
            1,
            script,
            true,
            10
        )
        Utility_m:CreateSound(
            "rbxassetid://122754850804619",
            1,
            1,
            script,
            true,
            10
        )
        pcall(function() -- line: 108
            -- upvalues:
            --  [1] v1 (copy)
            --  [2] PreloadController_m (ref)

            v1:WaitForChild("Rig"):WaitForChild("Humanoid"):LoadAnimation(
                PreloadController_m:GetPreloadedAnimation("ShadyChickenAppear")
            ):Play(0)
        end)
        wait(2)
        wait(5)
    end

    v1:WaitForChild("Prompt"):WaitForChild("ProximityPrompt").MaxActivationDistance = 16
end

function t._ChickenAdded(_, arg6) -- line: 122
    -- upvalues:
    --  [1] PreloadController_m (copy)

    pcall(function() -- line: 123
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] PreloadController_m (ref)

        arg6:WaitForChild("Rig"):WaitForChild("Humanoid"):LoadAnimation(
            PreloadController_m:GetPreloadedAnimation("ShadyChickenIdleVent")
        ):Play(0)
    end)
end

function t._UpdateLoginPrompts(_) -- line: 128
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] CollectionService (copy)

    local v11 = if PlayerDataController_m:Get("ShadyChickenMissionStarted") then 0 else 16

    for _, val in pairs(CollectionService:GetTagged("LobbyShadyChickenPrompt")) do
        val.MaxActivationDistance = v11
    end
end

function t._LoginPromptAdded(arg8, arg9) -- line: 136
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    arg9.Triggered:Connect(function() -- line: 137
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Misc.StartShadyChickenMission:FireServer()
    end)
    arg8:_UpdateLoginPrompts()
end

function t._Init(_) -- line: 144
end

return t._new()
