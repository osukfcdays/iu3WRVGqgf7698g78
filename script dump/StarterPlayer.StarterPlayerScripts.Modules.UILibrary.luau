local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Pages = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Pages")
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Players (copy)

    local t_1 = setmetatable({}, t)
    t_1.BUTTON_BACKGROUND_TRANSPARENCY = 0.08
    t_1.BUTTON_BACKGROUND_COLOR = Color3.fromRGB(18, 18, 21)
    t_1.BUTTON_ICON_COLOR = Color3.fromRGB(247, 247, 248)
    t_1.PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    t_1.MainGui = t_1.PlayerGui:WaitForChild("MainGui")
    t_1:_Init()

    return t_1
end

function t.GetMouseLocation(_) -- line: 33
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] GuiService (copy)

    return UserInputService:GetMouseLocation() - Vector2.new(0, GuiService.TopbarInset.Height)
end

function t.GetMouseLocationCentered(_) -- line: 38
    -- upvalues:
    --  [1] GuiService (copy)

    return workspace.CurrentCamera.ViewportSize / 2 - Vector2.new(0, GuiService.TopbarInset.Height)
end

function t.ScreenPointToPosition(arg3, arg4, arg5) -- line: 42
    local v2 = arg5 or arg3.MainGui.AbsolutePosition

    return Vector2.new(arg4.X - v2.X, arg4.Y - v2.Y)
end

function t.IsWithinBounds(
    _,
    arg7,
    arg8,
    arg9,
    arg10
) -- line: 48
    return arg7 >= arg9.X and arg7 <= arg9.X + arg10.X and arg8 >= arg9.Y and arg8 <= arg9.Y + arg10.Y
end

function t.IsMouseWithinBounds(arg11, arg12, arg13) -- line: 55
    local mouseLocation_1 = arg11:GetMouseLocation()

    return arg11:IsWithinBounds(mouseLocation_1.X, mouseLocation_1.Y, arg12, arg13)
end

function t.GetTo(arg14, ...) -- line: 61
    -- upvalues:
    --  [1] Utility_m (copy)

    return Utility_m:WaitForChild(arg14.MainGui, ...)
end

function t.GetPage(_, arg16) -- line: 65
    -- upvalues:
    --  [1] Pages (copy)

    return Pages:WaitForChild(arg16)
end

function t.ScrollingTextLabel(arg17, arg18, arg19, arg20) -- line: 69
    -- upvalues:
    --  [1] Players (copy)

    local v4 = nil
    local v5 = 0
    local v6 = 0

    local function check_tween(arg21) -- line: 74
        -- upvalues:
        --  [1] v5 (ref)
        --  [2] arg18 (copy)
        --  [3] Players (ref)
        --  [4] v4 (ref)
        --  [5] arg19 (copy)
        --  [6] v6 (ref)
        --  [7] arg17 (copy)
        --  [8] check_tween (copy)

        task.defer(function() -- line: 75
            -- upvalues:
            --  [1] v5 (ref)
            --  [2] arg18 (ref)
            --  [3] Players (ref)
            --  [4] v4 (ref)
            --  [5] arg19 (ref)
            --  [6] v6 (ref)
            --  [7] arg17 (ref)
            --  [8] arg21 (copy)
            --  [9] check_tween (ref)

            if tick() < v5 then
                return
            end

            if not arg18:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
                v4 = nil

                return
            end

            local v7 = arg19.TextBounds.X - arg18.AbsoluteSize.X

            if v7 <= 0 or v4 and math.abs(v7 - v4) < 0.1 then
                return
            end

            v6 += 1
            local v8 = v6
            local v9 = v7 / arg17.MainGui.AbsoluteSize.X * 50
            local udim2 = UDim2.new(0, 0, 0.5, 0)
            local udim2_1 = UDim2.new(0, -v7, 0.5, 0)
            v5 = tick() + 1
            v4 = v7
            local v10 = arg19
            v10.Position = arg21 and udim2_1 or udim2
            arg19:TweenPosition(
                arg21 and udim2 or udim2_1,
                "InOut",
                "Linear",
                v9,
                true,
                function() -- line: 100
                    -- upvalues:
                    --  [1] v6 (ref)
                    --  [2] v8 (copy)
                    --  [3] v4 (ref)
                    --  [4] check_tween (ref)
                    --  [5] arg21 (ref)

                    if v6 ~= v8 then
                        return
                    end

                    v4 = nil
                    task.delay(1, check_tween, not arg21)
                end
            )
        end)
    end

    arg18.AncestryChanged:Connect(check_tween)
    arg18:GetPropertyChangedSignal("AbsoluteSize"):Connect(check_tween)
    arg19:GetPropertyChangedSignal("TextBounds"):Connect(check_tween)
    local v15 = nil
    task.defer(function() -- line: 75
        -- upvalues:
        --  [1] v5 (ref)
        --  [2] arg18 (copy)
        --  [3] Players (ref)
        --  [4] v4 (ref)
        --  [5] arg19 (copy)
        --  [6] v6 (ref)
        --  [7] arg17 (copy)
        --  [8] v15 (copy)
        --  [9] check_tween (copy)

        if tick() < v5 then
            return
        end

        if not arg18:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
            v4 = nil

            return
        end

        local v16 = arg19.TextBounds.X - arg18.AbsoluteSize.X

        if v16 <= 0 or v4 and math.abs(v16 - v4) < 0.1 then
            return
        end

        v6 += 1
        local v17 = v6
        local v18 = v16 / arg17.MainGui.AbsoluteSize.X * 50
        local udim2_2 = UDim2.new(0, 0, 0.5, 0)
        local udim2_3 = UDim2.new(0, -v16, 0.5, 0)
        v5 = tick() + 1
        v4 = v16
        local v19 = arg19
        v19.Position = v15 and udim2_3 or udim2_2
        arg19:TweenPosition(
            v15 and udim2_2 or udim2_3,
            "InOut",
            "Linear",
            v18,
            true,
            function() -- line: 100
                -- upvalues:
                --  [1] v6 (ref)
                --  [2] v17 (copy)
                --  [3] v4 (ref)
                --  [4] check_tween (ref)
                --  [5] v15 (ref)

                if v6 ~= v17 then
                    return
                end

                v4 = nil
                task.delay(1, check_tween, not v15)
            end
        )
    end)

    if arg20 then
        local function update() -- line: 117
            -- upvalues:
            --  [1] arg20 (copy)
            --  [2] arg18 (copy)
            --  [3] v5 (ref)
            --  [4] Players (ref)
            --  [5] v4 (ref)
            --  [6] arg19 (copy)
            --  [7] v6 (ref)
            --  [8] arg17 (copy)
            --  [9] check_tween (copy)

            local v24 = if arg20.Visible then arg20.TextBounds.X else 0
            local v25 = if not v24 then 0 else arg20.AbsoluteSize.Y * 0.5 + arg18.AbsolutePosition.X
            arg18.Size = UDim2.new(
                0,
                arg20.AbsolutePosition.X + arg20.AbsoluteSize.X - v24 - v25,
                arg18.Size.Y.Scale,
                arg18.Size.Y.Offset
            )
            v5 = 0
            local v27 = nil
            task.defer(function() -- line: 75
                -- upvalues:
                --  [1] v5 (ref)
                --  [2] arg18 (ref)
                --  [3] Players (ref)
                --  [4] v4 (ref)
                --  [5] arg19 (ref)
                --  [6] v6 (ref)
                --  [7] arg17 (ref)
                --  [8] v27 (copy)
                --  [9] check_tween (ref)

                if tick() < v5 then
                    return
                end

                if not arg18:IsDescendantOf(Players.LocalPlayer.PlayerGui) then
                    v4 = nil

                    return
                end

                local v28 = arg19.TextBounds.X - arg18.AbsoluteSize.X

                if v28 <= 0 or v4 and math.abs(v28 - v4) < 0.1 then
                    return
                end

                v6 += 1
                local v29 = v6
                local v30 = v28 / arg17.MainGui.AbsoluteSize.X * 50
                local udim2_4 = UDim2.new(0, 0, 0.5, 0)
                local udim2_5 = UDim2.new(0, -v28, 0.5, 0)
                v5 = tick() + 1
                v4 = v28
                local v31 = arg19
                v31.Position = v27 and udim2_5 or udim2_4
                arg19:TweenPosition(
                    v27 and udim2_4 or udim2_5,
                    "InOut",
                    "Linear",
                    v30,
                    true,
                    function() -- line: 100
                        -- upvalues:
                        --  [1] v6 (ref)
                        --  [2] v29 (copy)
                        --  [3] v4 (ref)
                        --  [4] check_tween (ref)
                        --  [5] v27 (ref)

                        if v6 ~= v29 then
                            return
                        end

                        v4 = nil
                        task.delay(1, check_tween, not v27)
                    end
                )
            end)
        end

        arg18:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
        arg18:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
        arg20:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
        arg20:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
        arg20:GetPropertyChangedSignal("TextBounds"):Connect(update)
        arg20:GetPropertyChangedSignal("Visible"):Connect(update)
        update()
    end
end

function t._Init(_) -- line: 146
end

return t._new()
