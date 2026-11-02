local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local MonetizationController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("MonetizationController")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("PurchasePrompt")
    t_1._started = false
    t_1._blur = Instance.new("BlurEffect")
    t_1:_Init()

    return t_1
end

function t.Start(arg1) -- line: 32
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg1._started then
        return
    end

    arg1._started = true
    Utility_m:CreateSound(
        "rbxassetid://17900058344",
        1,
        1,
        script,
        true,
        10
    )
    Utility_m:RenderstepForLoop(0, 100, 2, function(arg2) -- line: 40
        -- upvalues:
        --  [1] arg1 (copy)

        if not arg1._started then
            return true
        end

        local v3 = 1 - (1 - arg2 / 100) ^ 4
        arg1.Frame.BackgroundTransparency = 1 + -0.5 * v3
        arg1._blur.Size = 56 * v3
    end)
end

function t.Finish(arg3, arg4) -- line: 54
    -- upvalues:
    --  [1] Utility_m (copy)

    assert(
        not arg4 or (if typeof(arg4) ~= "boolean" then false else true),
        "Argument 1 invalid, expected a boolean or nil, got " .. tostring(arg4)
    )

    if not arg3._started then
        return
    end

    arg3._started = false

    if arg4 then
        Utility_m:CreateSound(
            "rbxassetid://7819009374",
            1,
            1,
            script,
            true,
            10
        )
    end

    Utility_m:RenderstepForLoop(0, 100, 2, function(arg5) -- line: 67
        -- upvalues:
        --  [1] arg3 (copy)

        if arg3._started then
            return true
        end

        local v5 = 1 - (1 - arg5 / 100) ^ 4
        arg3.Frame.BackgroundTransparency = 0.5 + 0.5 * v5
        arg3._blur.Size = 56 * (1 - v5)
    end)
end

function t._Setup(arg6) -- line: 83
    -- upvalues:
    --  [1] Lighting (copy)

    arg6._blur.Size = 0
    arg6._blur.Name = "PurchasePrompt"
    arg6._blur.Parent = Lighting
end

function t._Init(arg7) -- line: 89
    -- upvalues:
    --  [1] MonetizationController_m (copy)

    MonetizationController_m.PurchaseStarted:Connect(function(...) -- line: 90
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Start(...)
    end)
    MonetizationController_m.PurchaseFinished:Connect(function(...) -- line: 94
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Finish(...)
    end)
    arg7:_Setup()
end

return t._new()
