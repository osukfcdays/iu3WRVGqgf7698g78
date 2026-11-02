local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 12
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.FighterInterface = arg1
    t_1.DamageVignette = t_1.FighterInterface.Frame:WaitForChild("DamageVignette")
    t_1.DamageVignettePermanent = t_1.DamageVignette:WaitForChild("Permanent")
    t_1.HealVignette = t_1.FighterInterface.Frame:WaitForChild("HealVignette")
    t_1.Frame = t_1.FighterInterface.BottomRight.Container:WaitForChild("Health")
    t_1.ContainerFrame = t_1.Frame:WaitForChild("Container")
    t_1.ContainerBackground = t_1.ContainerFrame:WaitForChild("Background")
    t_1.ContainerBar = t_1.ContainerFrame:WaitForChild("Bar")
    t_1.ContainerBarText = t_1.ContainerBar:WaitForChild("Value"):WaitForChild("Title")
    t_1._last_health_tween = nil
    t_1._last_health_alpha = nil
    t_1._hurt_effect_hash = 0
    t_1._heal_effect_hash = 0
    t_1:_Init()

    return t_1
end

function t.HurtEffect(arg2, arg3) -- line: 40
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg2.FighterInterface:IsActive() then
        return
    end

    local v1 = arg3[utf8.char(0)] / arg2.FighterInterface.ClientFighter.Entity.Humanoid.Health

    if v1 == 0 then
        return
    end

    task.spawn(function() -- line: 51
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] arg3 (copy)

        arg2.FighterInterface.DamageIndicators:Create(arg3)
    end)
    arg2._hurt_effect_hash += 1
    local HurtEffectHash = arg2._hurt_effect_hash
    local v2 = 0.5 - 0.5 * v1
    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        4,
        function(arg4) -- line: 61
            -- upvalues:
            --  [1] HurtEffectHash (copy)
            --  [2] arg2 (copy)
            --  [3] v2 (copy)

            if HurtEffectHash ~= arg2._hurt_effect_hash then
                return true
            end

            arg2.DamageVignette.ImageTransparency = v2 + (1 - v2) * (arg4 / 100)
        end
    )
end

function t.HealEffect(arg5, arg6) -- line: 72
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg5.FighterInterface:IsActive() then
        return
    end

    arg5._heal_effect_hash += 1
    local HealEffectHash = arg5._heal_effect_hash
    local clampedValue = math.clamp(arg6 / 10, 0, 1)
    arg5.FighterInterface:CreateSound(
        "rbxassetid://17138490999",
        clampedValue * 0.5,
        1,
        script,
        true,
        10
    )
    local v4 = 1 - clampedValue * 1
    task.spawn(
        Utility_m.RenderstepForLoop,
        Utility_m,
        0,
        100,
        4,
        function(arg7) -- line: 86
            -- upvalues:
            --  [1] HealEffectHash (copy)
            --  [2] arg5 (copy)
            --  [3] v4 (copy)

            if HealEffectHash ~= arg5._heal_effect_hash then
                return true
            end

            arg5.HealVignette.ImageTransparency = v4 + (1 - v4) * (arg7 / 100)
        end
    )
end

function t.UpdateParent(arg8) -- line: 97
    -- upvalues:
    --  [1] PlayerDataController_m (copy)

    task.defer(pcall, function() -- line: 98
        -- upvalues:
        --  [1] arg8 (copy)
        --  [2] PlayerDataController_m (ref)

        local Frame = arg8.Frame
        local v5 = if PlayerDataController_m:GetSetting("Health Bar Display") == "Disabled" then false else true
        Frame.Visible = v5
        local Frame_1 = arg8.Frame

        if PlayerDataController_m:GetSetting("Health Bar Display") == "Bottom Center" then
            v5 = arg8.FighterInterface.BottomCenter.Container

            if not v5 then
                v5 = PlayerDataController_m:GetSetting("Health Bar Display") == "Bottom Left" and arg8.FighterInterface.BottomLeft.Container or arg8.FighterInterface.BottomRight.Container
            end
        else
            v5 = PlayerDataController_m:GetSetting("Health Bar Display") == "Bottom Left" and arg8.FighterInterface.BottomLeft.Container or arg8.FighterInterface.BottomRight.Container
        end

        Frame_1.Parent = v5
    end)
end

function t.Refresh(arg9) -- line: 106
    if not arg9.FighterInterface.BottomLeft.Frame.Visible then
        arg9.DamageVignettePermanent.ImageTransparency = 1

        return
    end

    arg9:_Update()
end

function t.Destroy(arg10) -- line: 115
    arg10._hurt_effect_hash += 1
    arg10._heal_effect_hash += 1
end

function t._Update(arg11, arg12) -- line: 124
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] TweenService (copy)

    if arg11._last_health_tween then
        arg11._last_health_tween:Pause()
        arg11._last_health_tween = nil
    end

    local v6 = arg11.FighterInterface.ClientFighter:Get("IsAprilFools")
    local v7 = arg11.FighterInterface.ClientFighter:GetMaxHealth()
    local v8 = if v6 then math.max(math.min(1, v7), v7 * math.random()) else arg11.FighterInterface.ClientFighter:GetHealth()
    local clampedValue_1 = math.clamp(v8 / v7, 0, 1)
    local v9 = Color3.fromRGB(255, 50, 50):Lerp(
        Color3.fromRGB(255, 215, 0):Lerp(Color3.fromRGB(100, 255, 50), clampedValue_1),
        clampedValue_1
    )
    local v10 = Color3.new(v9.R / 2, v9.G / 2, v9.B / 2)
    local color_3 = Color3.new(v9.R / 3, v9.G / 3, v9.B / 3)
    arg11.DamageVignettePermanent.ImageTransparency = if clampedValue_1 > 0.5 then 1 else clampedValue_1 * 2
    arg11.ContainerFrame.BackgroundColor3 = v10
    arg11.ContainerBackground.BackgroundColor3 = color_3
    arg11.ContainerBar.BackgroundColor3 = v9
    local ContainerBar = arg11.ContainerBar
    ContainerBar.Visible = clampedValue_1 > 0
    local ContainerBarText = arg11.ContainerBarText
    ContainerBarText.Text = v8 >= 1 and Utility_m:PrettyNumber((math.ceil(v8))) or ""
    local udim2 = UDim2.new(math.max(0.073, clampedValue_1), 0, 1, 0)

    if arg12 then
        arg11.ContainerBar.Size = udim2
    else
        v10 = if not arg11._last_health_alpha then 1 else if not (clampedValue_1 < arg11._last_health_alpha) then 0.5 else 1
        arg11._last_health_tween = TweenService:Create(
            arg11.ContainerBar,
            TweenInfo.new(0.5 / v10, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            { Size = udim2 }
        )
        arg11._last_health_tween:Play()
    end

    arg11._last_health_alpha = clampedValue_1
end

function t._Setup(arg13) -- line: 159
    -- upvalues:
    --  [1] GuiService (copy)

    local udim2_1 = UDim2.new(1, 0, 1, GuiService:GetGuiInset().Y)
    arg13.HealVignette.Size = udim2_1
    arg13.DamageVignette.Size = udim2_1
end

function t._Init(arg14) -- line: 166
    arg14.FighterInterface.BottomLeft.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 167
        -- upvalues:
        --  [1] arg14 (copy)

        arg14:Refresh()
    end)
    arg14:_Setup()
    arg14:_Update(true)
    arg14:UpdateParent()
end

return t
