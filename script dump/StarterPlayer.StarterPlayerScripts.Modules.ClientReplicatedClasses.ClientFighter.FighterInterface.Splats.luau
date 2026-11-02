local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.EnumLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local ViewModels = Players.LocalPlayer.PlayerScripts.Modules.ViewModels
local PaintballSplatGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PaintballSplatGui"
)
local t = { "rbxassetid://17098901439", "rbxassetid://17098901515", "rbxassetid://16833617681" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.FighterInterface = arg1
    t_2._splat_guis = {}
    t_2:_Init()

    return t_2
end

function t_1.Create(
    arg2,
    arg3,
    arg4,
    arg5,
    arg6
) -- line: 33
    -- upvalues:
    --  [1] ViewModels (copy)
    --  [2] PaintballSplatGui (copy)
    --  [3] t (copy)
    --  [4] Players (copy)
    --  [5] Utility_m (copy)

    if not arg2.FighterInterface:IsActive() then
        return
    end

    local v1 = arg5

    if v1 then
        v1 = ViewModels:FindFirstChild(arg5, true)
    end

    local v2 = v1 and require(v1)
    local v5

    for _ = 1, if arg6 then 20 else 1 do
        v1 = 0.125 + 0.5 * math.random()

        if arg6 then
            v5 = Color3.fromHSV(math.random(), 0.75, 1)

            if not v5 then
                v5 = v2 and v2:GetPaintballColor() or arg4 or Color3.fromHSV(
                    tick() * 2 % 1,
                    0.75,
                    1
                )
            end
        else
            v5 = v2 and v2:GetPaintballColor() or arg4 or Color3.fromHSV(tick() * 2 % 1, 0.75, 1)
        end

        local v11 = if arg6 then UDim2.new(
            v1 * 0.25 + (1 - v1 * 0.5) * math.random(),
            0,
            v1 * 0.25 + (1 - v1 * 0.5) * math.random(),
            0
        ) else arg2:_GetScreenPosition(arg3)
        local v12 = PaintballSplatGui:Clone()
        v12.Splat.Size = UDim2.new(v1, 0, v1, 0)
        v12.Splat.Position = v11
        v12.Splat.ImageColor3 = v5
        v12.Splat.Image = t[math.random(#t)]
        v12.Splat.Rotation = 360 * math.random()
        local v14 = arg2.FighterInterface:IsActive() and Players.LocalPlayer.PlayerGui or nil
        v12.Parent = v14
        table.insert(arg2._splat_guis, v12)
        local Splat_4 = v12.Splat
        task.delay(2.5, function() -- line: 61
            -- upvalues:
            --  [1] Splat_4 (copy)
            --  [2] Utility_m (ref)
            --  [3] v12 (copy)
            --  [4] arg2 (copy)

            local ImageTransparency = Splat_4.ImageTransparency
            Utility_m:RenderstepForLoop(0, 100, 4, function(arg7) -- line: 64
                -- upvalues:
                --  [1] Splat_4 (ref)
                --  [2] ImageTransparency (copy)

                Splat_4.ImageTransparency = ImageTransparency + (1 - ImageTransparency) * (1 - (1 - arg7 / 100) ^ 5)
            end)
            v12:Destroy()
            local index_1 = table.find(arg2._splat_guis, v12)

            if index_1 then
                table.remove(arg2._splat_guis, index_1)
            end
        end)

        if v12:IsDescendantOf(Players.LocalPlayer) then
            v12.Splat:TweenSize(
                UDim2.new(v1 * 0.5, 0, v1 * 0.5, 0),
                "In",
                "Quint",
                3,
                true
            )
        end

        arg2.FighterInterface:CreateSound(
            "rbxassetid://16835701807",
            0.75,
            1 + 0.4 * math.random(),
            script,
            true,
            10
        )

        if arg6 then
            wait(0.03 * math.random())
        end
    end
end

function t_1.Destroy(arg8) -- line: 91
    for _, val in pairs(arg8._splat_guis) do
        val:Destroy()
    end

    arg8._splat_guis = {}
end

function t_1._GetScreenPosition(arg9, arg10) -- line: 103
    -- upvalues:
    --  [1] UILibrary_m (copy)

    local v17 = nil
    local v18 = nil

    if arg10 then
        local screenPoint, isOnScreen = workspace.CurrentCamera:WorldToScreenPoint(arg10)
        v17 = screenPoint
        v18 = isOnScreen
    end

    if v18 then
        local v19 = UILibrary_m:ScreenPointToPosition(
            v17,
            arg9.FighterInterface.Frame.AbsolutePosition
        )
        local New_1 = UDim2.new
        local clampedValue = math.clamp(
            v19.X,
            arg9.FighterInterface.Frame.AbsoluteSize.X * 0.125,
            arg9.FighterInterface.Frame.AbsoluteSize.X * 0.875
        )

        return New_1(
            0,
            clampedValue,
            0,
            (math.clamp(
                v19.Y,
                arg9.FighterInterface.Frame.AbsoluteSize.Y * 0.125,
                arg9.FighterInterface.Frame.AbsoluteSize.Y * 0.875
            ))
        )
    end

    local v20 = Vector2.new(
        arg9.FighterInterface.Frame.AbsoluteSize.X,
        arg9.FighterInterface.Frame.AbsoluteSize.Y
    ) * (0.8 + 0.4 * math.random()) * 0.5
    local v21 = math.random() * 3.141592653589793 * 2

    return UDim2.new(0.5, math.cos(v21) * v20.X, 0.5, math.sin(v21) * v20.Y)
end

function t_1._Init(arg11) -- line: 126
    -- upvalues:
    --  [1] Players (copy)

    arg11.FighterInterface.ActiveChanged:Connect(function() -- line: 127
        -- upvalues:
        --  [1] arg11 (copy)
        --  [2] Players (ref)

        for _, val_1 in pairs(arg11._splat_guis) do
            local v23 = arg11.FighterInterface:IsActive() and Players.LocalPlayer.PlayerGui or nil
            val_1.Parent = v23
        end
    end)
end

return t_1
