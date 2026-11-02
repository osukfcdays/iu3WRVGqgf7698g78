local _ = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local GameComponents = game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
    "GameComponents"
)
local t = {
    "FlickeringLights",
    "SmokeClouds",
    "FireHitboxes",
    "CustomKnockbackParts",
    "UISparkleEffects",
    "UILoadingDots",
    "UIBackgrounds",
    "UIInputFrames",
    "UIKeybinds",
    "OpenPagePrompts",
    "SnowballPrompts",
    "OutOfBoundsParts",
    "UserIDsFilter",
    "JumpPads",
    "SubspaceTripmines",
    "UIShinyTexts",
    "UIGlitchEffects",
    "PortalModels",
    "Vortexes",
    "OneWayFloors",
    "SoundTriggers"
}
local t_1 = {}
t_1.__index = t_1

function t_1._new() -- line: 18
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.Components = {}
    t_2:_Init()

    return t_2
end

function t_1._Setup(arg1) -- line: 38
    -- upvalues:
    --  [1] t (copy)
    --  [2] GameComponents (copy)

    for _, val in pairs(t) do
        task.spawn(function() -- line: 40
            -- upvalues:
            --  [1] arg1 (copy)
            --  [2] val (copy)
            --  [3] GameComponents (ref)

            arg1.Components[val] = require(GameComponents:WaitForChild(val))
        end)
    end
end

function t_1._Init(arg2) -- line: 46
    -- upvalues:
    --  [1] RunService (copy)

    RunService.Heartbeat:Connect(function(deltaTime: number) -- line: 47
        -- upvalues:
        --  [1] arg2 (copy)

        for _, val_1 in pairs(arg2.Components) do
            if val_1.Update then
                val_1:Update(deltaTime)
            end
        end
    end)
    arg2:_Setup()
end

return t_1._new()
