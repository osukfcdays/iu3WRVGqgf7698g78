local RunService = game:GetService("RunService")
local BowCharge = game:GetService("Players").LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "BowCharge"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)
    --  [2] BowCharge (copy)

    local t_1 = setmetatable({}, t)
    t_1.ItemInterface = arg1
    t_1.Frame = BowCharge:Clone()
    t_1.DamageText = t_1.Frame:WaitForChild("Damage")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.BackgroundDivider2 = t_1.Background:WaitForChild("Divider2")
    t_1.BackgroundDivider3 = t_1.Background:WaitForChild("Divider3")
    t_1.BackgroundBar = t_1.Background:WaitForChild("Bar")
    t_1.BackgroundEffect = t_1.Background:WaitForChild("Effect")
    t_1.BackgroundEffectUIStroke = t_1.BackgroundEffect:WaitForChild("UIStroke")
    t_1.KeyWhiteFrame = t_1.Background:WaitForChild("KeyWhite")
    t_1.KeyColorFrame = t_1.Background:WaitForChild("KeyColor")
    t_1.KeyColorCircleStroke = t_1.KeyColorFrame:WaitForChild("Circle"):WaitForChild("UIStroke")
    t_1._destroyed = false
    t_1._start_time = nil
    t_1._charge_hash = 0
    t_1._max_charge_connection = nil
    t_1:_Init()

    return t_1
end

function t.Set(arg2, arg3) -- line: 40
    -- upvalues:
    --  [1] RunService (copy)

    if arg2._destroyed then
        return
    end

    if arg2._max_charge_connection then
        arg2._max_charge_connection:Disconnect()
        arg2._max_charge_connection = nil
    end

    local v1 = arg2.ItemInterface.ClientItem.ViewModel:GetChargeColor(arg3)
    local ChargeLevelDamageMultipliers = arg2.ItemInterface.ClientItem.Info.ChargeLevelDamageMultipliers
    arg2.Frame.Position = UDim2.new(0.5, 24, 0.5, 24)
    arg2.DamageText.Text = "<font family=\"12187365977\"><stroke color=\"rgb(255,255,255)\" joins=\"miter\" thickness=\"3\">" .. math.floor(
        ChargeLevelDamageMultipliers[arg3] * 100
    ) .. "%</stroke></font>"
    arg2.DamageText.TextColor3 = v1
    arg2.DamageText.Size = UDim2.new(1, 0, if arg3 == 1 then 0.5 else 0.75, 0)
    arg2.DamageText:TweenSize(
        UDim2.new(1, 0, 0.5, 0),
        "Out",
        "Quint",
        0.5,
        true
    )
    arg2.BackgroundEffectUIStroke.Color = v1
    arg2.BackgroundBar.BackgroundColor3 = v1
    arg2.KeyColorCircleStroke.Color = v1

    if arg3 >= #ChargeLevelDamageMultipliers then
        arg2._max_charge_connection = RunService.RenderStepped:Connect(function(_) -- line: 63
            -- upvalues:
            --  [1] arg2 (copy)

            arg2.Frame.Position = UDim2.new(
                0.5,
                24 + 8 * (math.random() - 0.5),
                0.5,
                24 + 8 * (math.random() - 0.5)
            )
        end)
    end
end

function t.Start(arg5, arg6) -- line: 69
    if arg5._destroyed then
        return
    end

    assert(if typeof(arg6) ~= "table" then false else true, "Argument 1 invalid, expected a table")
    arg5._charge_hash += 1
    arg5._start_time = tick()
    arg5.Frame.Visible = true
    arg5.BackgroundBar.Size = UDim2.new(0, 8, 1, 0)
    arg5.BackgroundBar:TweenSize(
        UDim2.new(1, 0, 1, 0),
        "Out",
        "Linear",
        arg6[#arg6],
        true
    )
    arg5.BackgroundEffect.Size = UDim2.new(1, 0, 1, 0)
    arg5.BackgroundEffect.Visible = false
    local t_2 = {}

    for key, val in pairs(arg6) do
        local v5 = val / arg6[#arg6]
        local v6 = arg5.ItemInterface.ClientItem.ViewModel:GetChargeColor(key)
        table.insert(t_2, ColorSequenceKeypoint.new(v5, v6))

        if key ~= 1 and key ~= #arg6 then
            arg5["BackgroundDivider" .. key].Position = UDim2.new(val / arg6[#arg6], 0, 0, 0)
        end
    end
end

function t.Play(arg7) -- line: 99
    if arg7._destroyed then
        return
    end

    arg7.Background.Size = UDim2.new(1, 0, 0.375, 0)
    arg7.Background:TweenSize(
        UDim2.new(1, 0, 0.25, 0),
        "Out",
        "Quint",
        0.5,
        true
    )
end

function t.Stop(arg8, arg9) -- line: 108
    if arg8._destroyed then
        return
    end

    if arg8._max_charge_connection then
        arg8._max_charge_connection:Disconnect()
        arg8._max_charge_connection = nil
    end

    if arg9 then
        arg8.Frame.Visible = false
    else
        local ChargeHash = arg8._charge_hash
        arg8.BackgroundBar:TweenSize(
            arg8.BackgroundBar.Size,
            "Out",
            "Linear",
            0,
            true
        )
        arg8.BackgroundEffect.Visible = true
        arg8.BackgroundEffect:TweenSize(
            UDim2.new(1, 8, 1, 8),
            "Out",
            "Linear",
            0.5,
            true,
            function() -- line: 125
                -- upvalues:
                --  [1] arg8 (copy)
                --  [2] ChargeHash (copy)

                wait(0.5)

                if arg8._charge_hash ~= ChargeHash then
                    return
                end

                arg8.Frame.Visible = false
            end
        )
    end

    if not arg8._start_time then
        return
    end

    arg8._start_time = nil
end

function t.Destroy(arg10) -- line: 143
    arg10._destroyed = true
    arg10.Frame:Destroy()

    if arg10._max_charge_connection then
        arg10._max_charge_connection:Disconnect()
        arg10._max_charge_connection = nil
    end
end

function t._Setup(arg11) -- line: 158
    local v10 = if arg11.ItemInterface.ClientItem.ViewModel.Name ~= "Key Bow" then false else true
    local Frame_2 = arg11.Frame
    local Position = Frame_2.Position
    local v11 = v10 and UDim2.new(0, 18, 0, 0) or UDim2.new(0, 0, 0, 0)
    Frame_2.Position = Position + v11
    arg11.KeyWhiteFrame.Visible = v10
    arg11.KeyColorFrame.Visible = v10
    arg11.Frame.Parent = arg11.ItemInterface.Mouse.Frame
end

function t._Init(arg12) -- line: 168
    arg12.BackgroundEffect:GetPropertyChangedSignal("Size"):Connect(function() -- line: 169
        -- upvalues:
        --  [1] arg12 (copy)

        arg12.BackgroundEffectUIStroke.Thickness = 4 - arg12.BackgroundEffect.Size.X.Offset / 2
    end)
    arg12:_Setup()
    arg12:Set(1)
end

return t
