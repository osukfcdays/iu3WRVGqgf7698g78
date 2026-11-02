local SettingSlot_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("SettingSlot")
)
local t = setmetatable({}, SettingSlot_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] SettingSlot_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(SettingSlot_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.SetDividerSpacing(arg1, arg2) -- line: 20
    arg1:ResizeYSize(arg2)
    arg1.Background.Size = UDim2.new(1, 0, 1 / arg2, 0)
end

function t._Setup(arg3) -- line: 29
    arg3.Background.ImageTransparency = 0.25
    arg3.BackgroundGradient.Enabled = false
    arg3.DetailsDisplayTitleText.FontFace = Font.fromId(12187365977, Enum.FontWeight.ExtraBold)
    arg3.Container.Position = UDim2.new(0, 0, 1, 0)
    arg3.Container.AnchorPoint = Vector2.new(0, 1)
    arg3.DetailsDisplayTitleContainer.Size = UDim2.new(
        arg3.DetailsDisplayTitleContainer.Size.X.Scale,
        arg3.DetailsDisplayTitleContainer.Size.X.Offset,
        arg3.DetailsDisplayTitleContainer.Size.Y.Scale * 1.5,
        arg3.DetailsDisplayTitleContainer.Size.Y.Offset * 1.5
    )
    arg3.SettingFrame.Size = UDim2.new(
        arg3.SettingFrame.Size.X.Scale,
        arg3.SettingFrame.Size.X.Offset,
        arg3.SettingFrame.Size.Y.Scale * 0.84,
        arg3.SettingFrame.Size.Y.Offset * 0.84
    )
    arg3.DetailsDisplayTitleContainer.Position = UDim2.new(0.0125, 0, 0.5, 0)
end

function t._Init(arg4) -- line: 40
    arg4:_Setup()
end

return t
