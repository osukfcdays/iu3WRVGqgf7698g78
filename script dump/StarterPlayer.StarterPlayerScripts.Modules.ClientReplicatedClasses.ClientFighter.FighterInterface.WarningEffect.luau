local TweenService = game:GetService("TweenService")
local _ = game:GetService("Players")
local t = {}
t.__index = t

function t.new(arg1) -- line: 7
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.WarningVignette = t_1.FighterInterface.Frame:WaitForChild("WarningVignette")
    t_1.WarningVignetteTexture = t_1.WarningVignette:WaitForChild("Texture")
    t_1.WarningVignetteContainer = t_1.WarningVignette:WaitForChild("Container")
    t_1.WarningVignetteContainerBackground = t_1.WarningVignetteContainer:WaitForChild("Frame"):WaitForChild(
        "Container"
    ):WaitForChild("Background")
    t_1._connections = {}
    t_1._warning_effect_tweens = {}
    t_1:_Init()

    return t_1
end

function t.SetEnabled(arg2, arg3, arg4) -- line: 28
    -- upvalues:
    --  [1] TweenService (copy)

    arg2:_Cleanup()
    arg2.WarningVignette.ImageTransparency = 1
    arg2.WarningVignette.ImageColor3 = Color3.fromRGB(255, 215, 0)
    arg2.WarningVignetteTexture.ImageTransparency = 1
    arg2.WarningVignetteContainer.Visible = false
    arg2.WarningVignetteContainerBackground.ImageColor3 = Color3.fromRGB(255, 215, 0)

    if not arg3 or arg4 >= math.huge then
        return
    end

    local tweenInfo = TweenInfo.new(arg4 / 2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tweenInfo_1 = TweenInfo.new(arg4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local v1 = TweenService:Create(arg2.WarningVignette, tweenInfo, { ImageTransparency = 0 })
    v1:Play()
    table.insert(arg2._warning_effect_tweens, v1)
    local t_2 = { ImageColor3 = Color3.fromRGB(255, 50, 50) }
    local v3 = TweenService:Create(arg2.WarningVignette, tweenInfo_1, t_2)
    v3:Play()
    table.insert(arg2._warning_effect_tweens, v3)
    local v4 = TweenService:Create(
        arg2.WarningVignetteTexture,
        tweenInfo,
        { ImageTransparency = 0 }
    )
    v4:Play()
    table.insert(arg2._warning_effect_tweens, v4)
    local t_3 = { ImageColor3 = Color3.fromRGB(255, 50, 50) }
    local v6 = TweenService:Create(arg2.WarningVignetteContainerBackground, tweenInfo_1, t_3)
    v6:Play()
    table.insert(arg2._warning_effect_tweens, v6)
    local thread = task.spawn(function() -- line: 60
        -- upvalues:
        --  [1] arg2 (copy)

        local _ = tick()

        while true do
            arg2.FighterInterface:CreateSound(
                "rbxassetid://114467311328776",
                0.5,
                1,
                script,
                true,
                10
            )
            arg2.WarningVignette.Container.Visible = true
            wait(0.4)
            arg2.WarningVignette.Container.Visible = false
            wait(0.15)
        end
    end)
    local t_4 = { Cancel = nil }

    function t_4.Cancel() -- line: 72
        -- upvalues:
        --  [1] thread (copy)

        task.cancel(thread)
    end

    table.insert(arg2._warning_effect_tweens, t_4)
end

function t.Destroy(arg5) -- line: 75
    for _, val in pairs(arg5._connections) do
        val:Disconnect()
    end

    arg5._connections = {}
    arg5:_Cleanup()
end

function t._Cleanup(arg6) -- line: 89
    for _, val_1 in pairs(arg6._warning_effect_tweens) do
        val_1:Cancel()
    end

    arg6._warning_effect_tweens = {}
end

function t._Init(_) -- line: 97
end

return t
