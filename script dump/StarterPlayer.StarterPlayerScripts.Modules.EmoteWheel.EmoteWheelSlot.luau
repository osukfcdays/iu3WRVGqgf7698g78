local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local EmoteViewportFrame_m = require(Players.LocalPlayer.PlayerScripts.Modules.EmoteViewportFrame)
local EmoteWheelSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EmoteWheelSlot"
)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tweenInfo_1 = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local t = {}
t.__index = t

function t.new(arg1) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] EmoteWheelSlot (copy)
    --  [3] EmoteViewportFrame_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EquippedData = arg1
    local v1 = t_1.EquippedData

    if v1 then
        v1 = t_1.EquippedData.Name
    end

    t_1.Name = v1
    t_1.Frame = EmoteWheelSlot:Clone()
    v1 = t_1.Name

    if v1 then
        v1 = EmoteViewportFrame_m.new(t_1.Name, 4)
    end

    t_1._emote_viewport_frame = v1
    t_1._is_highlighted = nil
    t_1._background = t_1.Frame.Background
    t_1._highlight = t_1._background.Highlight
    t_1._container = t_1.Frame.Container
    t_1._title = t_1._container.Title
    t_1._title_stroke = t_1._title.UIStroke
    t_1._highlight_tweens = {}
    t_1._equip_bounce_effect_ui_scale = Instance.new("UIScale")
    t_1:_Init()

    return t_1
end

function t.GetContainerPosition(arg2) -- line: 41
    return arg2._container.AbsolutePosition + arg2._container.AbsoluteSize / 2
end

function t.SetHighlighted(arg3, arg4) -- line: 45
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo_1 (copy)

    if arg3._is_highlighted == arg4 then
        return
    end

    for _, val in pairs(arg3._highlight_tweens) do
        val:Pause()
        val:Destroy()
    end

    arg3._highlight_tweens = {}
    arg3._is_highlighted = arg4
    arg3.Frame.ZIndex = if not arg4 then 0 else 1
    local t_2 = { Size = nil }
    local Frame_2 = arg3.Frame
    local v5 = tweenInfo_1
    local v6 = arg3._is_highlighted and UDim2.new(1.1, 0, 1.1, 0) or UDim2.new(1, 0, 1, 0)
    t_2.Size = v6
    local v3 = TweenService:Create(Frame_2, v5, t_2)
    v3:Play()
    table.insert(arg3._highlight_tweens, v3)
    local t_3 = { ImageTransparency = nil }
    local v7 = TweenService
    local Highlight = arg3._highlight
    local v8 = tweenInfo_1
    v6 = if arg3._is_highlighted then 0 else 1
    t_3.ImageTransparency = v6
    local v9 = v7:Create(Highlight, v8, t_3)
    v9:Play()
    table.insert(arg3._highlight_tweens, v9)
    local t_4 = { Size = nil, TextTransparency = nil }
    local v10 = TweenService
    local Title = arg3._title
    local v11 = tweenInfo_1
    v6 = arg3._is_highlighted and UDim2.new(3, 0, 0.25, 0) or UDim2.new(3, 0, 0.175, 0)
    t_4.Size = v6
    v6 = if not arg3._is_highlighted then 0.5 else 0
    t_4.TextTransparency = v6
    local v12 = v10:Create(Title, v11, t_4)
    v12:Play()
    table.insert(arg3._highlight_tweens, v12)
    local t_5 = { Transparency = nil }
    local v13 = TweenService
    local TitleStroke = arg3._title_stroke
    local v14 = tweenInfo_1
    v6 = if arg3._is_highlighted then 0.75 else 0.875
    t_5.Transparency = v6
    local v15 = v13:Create(TitleStroke, v14, t_5)
    v15:Play()
    table.insert(arg3._highlight_tweens, v15)

    if arg3._emote_viewport_frame then
        local t_6 = { Size = nil }
        local Frame_1 = arg3._emote_viewport_frame.Frame
        local v17 = tweenInfo_1
        t_6.Size = arg3._is_highlighted and UDim2.new(1.375, 0, 1.375, 0) or UDim2.new(1, 0, 1, 0)
        local v16 = TweenService:Create(Frame_1, v17, t_6)
        v16:Play()
        table.insert(arg3._highlight_tweens, v16)
    end
end

function t.SetRotation(arg5, arg6) -- line: 83
    arg5.Frame.Rotation = arg6
    arg5._container.Rotation = -arg6
end

function t.EquipBounceEffect(arg7) -- line: 88
    -- upvalues:
    --  [1] TweenService (copy)
    --  [2] tweenInfo (copy)

    arg7._equip_bounce_effect_ui_scale.Scale = 1.25
    TweenService:Create(arg7._equip_bounce_effect_ui_scale, tweenInfo, { Scale = 1 }):Play()
end

function t.Destroy(arg8) -- line: 93
    if arg8._emote_viewport_frame then
        arg8._emote_viewport_frame:Destroy()
    end

    arg8.Frame:Destroy()
end

function t._Setup(arg9) -- line: 105
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)

    if arg9._emote_viewport_frame then
        arg9._emote_viewport_frame:SetParent(arg9._container)
    end

    local Background = arg9._background
    Background.ImageTransparency = if not arg9.Name then 0.5 else 0.25
    arg9._title.Text = arg9.Name or ""
    local Highlight_1 = arg9._highlight
    Highlight_1.ImageColor3 = if arg9.Name then CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg9.Name].Rarity].Color else Color3.fromRGB(
        0,
        0,
        0
    ) or CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg9.Name].Rarity].Color
    arg9._equip_bounce_effect_ui_scale.Parent = arg9.Frame
end

function t._Init(arg10) -- line: 116
    arg10:_Setup()
    arg10:SetHighlighted(false)
end

return t
