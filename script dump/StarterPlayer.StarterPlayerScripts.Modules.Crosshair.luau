local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Crosshair = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("Crosshair")
local t = {}
t.__index = t

function t.new() -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Crosshair (copy)

    local t_1 = setmetatable({}, t)
    t_1.Type = nil
    t_1.Info = nil
    t_1.Appearance = nil
    t_1.Frame = Crosshair:Clone()
    t_1._destroyed = false
    t_1._visible = true
    t_1._spacing = 16
    t_1._spacing_multiplier = 1
    t_1._transparency = 0
    t_1._update_queued = false
    t_1._hitmarker_color = nil
    t_1._hitmarker_color_crit = nil
    t_1._last_hitmarker_crit_set = false
    t_1:_Init()

    return t_1
end

function t.GetDisplayAppearance(arg1) -- line: 42
    return if not arg1.Info.IsSpecial then arg1.Appearance else if not arg1.Appearance then nil else if arg1.Appearance.Override then arg1.Appearance else nil
end

function t.IsStatic(arg2) -- line: 46
    local v1 = arg2:GetDisplayAppearance()

    if not v1 then
        return false
    end

    return v1.IsStatic
end

function t.IsScopedRedDotDisabled(arg3) -- line: 52
    local v2 = arg3:GetDisplayAppearance()

    if not v2 then
        return false
    end

    return v2.ScopedRedDotDisabled
end

function t.IsScopedBarsDisabled(arg4) -- line: 58
    local v3 = arg4:GetDisplayAppearance()

    if not v3 then
        return false
    end

    return v3.ScopedBarsDisabled
end

function t.GetScopedRedDotColor(arg5) -- line: 64
    local v4 = arg5:GetDisplayAppearance()
    local v5 = v4

    if v5 then
        v5 = v4.ScopedRedDotColor
    end

    return v5
end

function t.ShowWhileAiming(arg6) -- line: 70
    local v6 = arg6:GetDisplayAppearance()

    if not v6 then
        return false
    end

    return v6.ShowWhileAiming
end

function t.ShowWhileInspecting(arg7) -- line: 76
    local v7 = arg7:GetDisplayAppearance()

    if not v7 then
        return false
    end

    return v7.ShowWhileInspecting
end

function t.GetAppearanceSpacing(arg8) -- line: 82
    local v8 = arg8:GetDisplayAppearance()

    return v8 and v8.BarsSpacing or 16
end

function t.SetParent(arg9, arg10) -- line: 88
    arg9.Frame.Parent = arg10
end

function t.SetType(arg11, arg12, arg13) -- line: 92
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    arg11.Type = arg12
    local v10
    arg11.Info, v10 = ItemLibrary_m.Crosshairs[arg11.Type], arg13
    arg11:_UpdateDeferred(v10)
end

function t.SetVisible(arg14, arg15, arg16) -- line: 98
    if arg15 == arg14._visible then
        return
    end

    arg14._visible = arg15
    arg14:_UpdateDeferred(arg16)
end

function t.SetSpacing(arg17, arg18, arg19, arg20) -- line: 107
    if arg18 == arg17._spacing and arg19 == arg17._spacing_multiplier then
        return
    end

    arg17._spacing = arg18 or arg17._spacing
    arg17._spacing_multiplier = arg19 or arg17._spacing_multiplier
    arg17:_UpdateDeferred(arg20)
end

function t.SetTransparency(arg21, arg22, arg23) -- line: 117
    if arg22 == arg21._transparency then
        return
    end

    arg21._transparency = arg22
    arg21:_UpdateDeferred(arg23)
end

function t.SetAppearance(arg24, arg25, arg26) -- line: 126
    arg24.Appearance = arg25
    arg24:_UpdateDeferred(arg26)
end

function t.SetHitmarkerColor(arg27, arg28) -- line: 131
    -- upvalues:
    --  [1] Utility_m (copy)

    arg27._last_hitmarker_crit_set = arg28
    local v12 = Utility_m:Color3FromHex(
        if not arg27._last_hitmarker_crit_set then arg27._hitmarker_color or "#ffffff" else arg27._hitmarker_color_crit or "#ff3232"
    )
    arg27.Frame.Hitmarker.TL.ImageColor3 = v12
    arg27.Frame.Hitmarker.TR.ImageColor3 = v12
    arg27.Frame.Hitmarker.BR.ImageColor3 = v12
    arg27.Frame.Hitmarker.BL.ImageColor3 = v12
end

function t.SetHitmarkerVisuals(
    arg29,
    arg30,
    arg31,
    arg32,
    _
) -- line: 141
    local Appearance = arg29.Appearance
    local v14 = arg29._last_hitmarker_crit_set and Appearance and Appearance.HitmarkerTransparencyCrit or Appearance and Appearance.HitmarkerTransparency or 0
    local v15 = v14 + (1 - v14) * arg32
    arg29.Frame.Hitmarker.TL.Position = UDim2.new(0.5, -arg30, 0.5, -arg30)
    arg29.Frame.Hitmarker.TR.Position = UDim2.new(0.5, arg30, 0.5, -arg30)
    arg29.Frame.Hitmarker.BR.Position = UDim2.new(0.5, arg30, 0.5, arg30)
    arg29.Frame.Hitmarker.BL.Position = UDim2.new(0.5, -arg30, 0.5, arg30)
    arg29.Frame.Hitmarker.TL.Size = arg31
    arg29.Frame.Hitmarker.TR.Size = arg31
    arg29.Frame.Hitmarker.BR.Size = arg31
    arg29.Frame.Hitmarker.BL.Size = arg31
    arg29.Frame.Hitmarker.TL.ImageTransparency = v15
    arg29.Frame.Hitmarker.TR.ImageTransparency = v15
    arg29.Frame.Hitmarker.BR.ImageTransparency = v15
    arg29.Frame.Hitmarker.BL.ImageTransparency = v15
end

function t.Destroy(arg34) -- line: 164
    if arg34._destroyed then
        return
    end

    arg34._destroyed = true
    pcall(arg34.Frame.Destroy, arg34.Frame)
end

function t._UpdateDeferred(arg35, ...) -- line: 177
    if arg35._update_queued then
        task.cancel(arg35._update_queued)
        arg35._update_queued = nil
    end

    arg35._update_queued = task.defer(function(...) -- line: 183
        -- upvalues:
        --  [1] arg35 (copy)

        arg35._update_queued = nil
        arg35:_Update(...)
    end, ...)
end

function t._Update(arg36, arg37) -- line: 189
    -- upvalues:
    --  [1] ItemLibrary_m (copy)
    --  [2] Utility_m (copy)

    if arg36._destroyed or arg37 then
        return
    end

    local v16 = arg36.Appearance
    local v17 = arg36._visible and (if v16 then not v16.IsDisabled else true)
    arg36.Frame.Foreground.Visible = v17
    arg36.Frame.Background.Visible = v17
    local v18 = if v16 then not v16.HitmarkerDisabled else true
    local v19 = v16

    if v19 then
        v19 = v16.HitmarkerColor
    end

    arg36._hitmarker_color = v19
    v19 = v16 and v16.HitmarkerColorCrit
    arg36._hitmarker_color_crit = v19
    arg36.Frame.Hitmarker.Visible = v18

    if not v17 then
        return
    end

    v18 = arg36:GetDisplayAppearance()
    v17 = v18 and v18.Scale or 1
    v16 = v18 and v18.Rotation or 0
    local v20 = v18 and v18.HitmarkerScale or 1
    local v21 = v18 and v18.HitmarkerRotation or 0
    arg36.Frame.UIScale.Scale = v17
    arg36.Frame.Rotation = v16
    arg36.Frame.Hitmarker.UIScale.Scale = v20 / v17
    arg36.Frame.Hitmarker.Rotation = -v16 + v21
    v21 = arg36.Info.IsSpecial and arg36.Appearance and arg36.Appearance.Override and ItemLibrary_m.Crosshairs.Default or arg36.Info
    arg36.Frame.Foreground.Dot.Image = v21.DotImage
    arg36.Frame.Foreground.Right.Image = v21.RightBarImage
    arg36.Frame.Foreground.Left.Image = v21.LeftBarImage
    arg36.Frame.Foreground.Down.Image = v21.BottomBarImage
    arg36.Frame.Foreground.Up.Image = v21.TopBarImage
    arg36.Frame.Background.Dot.Image = arg36.Frame.Foreground.Dot.Image
    arg36.Frame.Background.Right.Image = arg36.Frame.Foreground.Right.Image
    arg36.Frame.Background.Left.Image = arg36.Frame.Foreground.Left.Image
    arg36.Frame.Background.Down.Image = arg36.Frame.Foreground.Down.Image
    arg36.Frame.Background.Up.Image = arg36.Frame.Foreground.Up.Image
    v20 = if v18 then not v18.DotDisabled else true
    v17 = if v18 then not v18.BarsDisabled else true
    v16 = if v18 then not v18.BarsTopDisabled else true
    local v22 = if v18 then not v18.BarsBottomDisabled else true
    local v23 = if v18 then not v18.BarsRightDisabled else true
    local v24 = if v18 then not v18.BarsLeftDisabled else true
    local v25 = if v18 then not v18.CircleDisabled else true
    arg36.Frame.Foreground.Dot.Visible = v21.DotEnabled and v20
    local v26 = v21.BarsEnabled and v17 and v23
    arg36.Frame.Foreground.Right.Visible = v26
    v26 = v21.BarsEnabled and v17 and v24
    arg36.Frame.Foreground.Left.Visible = v26
    v26 = v21.BarsEnabled and v17 and v22
    arg36.Frame.Foreground.Down.Visible = v26
    v26 = v21.BarsEnabled and v17 and v16
    arg36.Frame.Foreground.Up.Visible = v26
    arg36.Frame.Foreground.Circle.Visible = v21.CircleEnabled and v25
    arg36.Frame.Background.Dot.Visible = arg36.Frame.Foreground.Dot.Visible
    arg36.Frame.Background.Right.Visible = arg36.Frame.Foreground.Right.Visible
    arg36.Frame.Background.Left.Visible = arg36.Frame.Foreground.Left.Visible
    arg36.Frame.Background.Down.Visible = arg36.Frame.Foreground.Down.Visible
    arg36.Frame.Background.Up.Visible = arg36.Frame.Foreground.Up.Visible
    arg36.Frame.Background.Circle.Visible = arg36.Frame.Foreground.Circle.Visible
    v24 = ((if not v18 then false else v18.IsStatic) and arg36:GetAppearanceSpacing() or arg36._spacing) * arg36._spacing_multiplier
    arg36.Frame.Foreground.Right.Position = UDim2.new(0.5, v24, 0.5, 0)
    arg36.Frame.Foreground.Left.Position = UDim2.new(0.5, -v24, 0.5, 0)
    arg36.Frame.Foreground.Down.Position = UDim2.new(0.5, 0, 0.5, v24)
    arg36.Frame.Foreground.Up.Position = UDim2.new(0.5, 0, 0.5, -v24)
    arg36.Frame.Background.Right.Position = arg36.Frame.Foreground.Right.Position
    arg36.Frame.Background.Left.Position = arg36.Frame.Foreground.Left.Position
    arg36.Frame.Background.Down.Position = arg36.Frame.Foreground.Down.Position
    arg36.Frame.Background.Up.Position = arg36.Frame.Foreground.Up.Position
    v25 = v18 and v18.DotTransparency or 0
    local v28 = v25 + (1 - v25) * arg36._transparency
    v25 = v18 and v18.BarsTransparency or 0
    v23 = v25 + (1 - v25) * arg36._transparency
    v25 = v18 and v18.CircleTransparency or 0
    local v29 = v25 + (1 - v25) * arg36._transparency
    arg36.Frame.Foreground.Dot.ImageTransparency = v28
    arg36.Frame.Foreground.Right.ImageTransparency = v23
    arg36.Frame.Foreground.Left.ImageTransparency = v23
    arg36.Frame.Foreground.Down.ImageTransparency = v23
    arg36.Frame.Foreground.Up.ImageTransparency = v23
    arg36.Frame.Foreground.Circle.UIStroke.Transparency = v29
    arg36.Frame.Background.Dot.ImageTransparency = arg36.Frame.Foreground.Dot.ImageTransparency
    arg36.Frame.Background.Right.ImageTransparency = arg36.Frame.Foreground.Right.ImageTransparency
    arg36.Frame.Background.Left.ImageTransparency = arg36.Frame.Foreground.Left.ImageTransparency
    arg36.Frame.Background.Down.ImageTransparency = arg36.Frame.Foreground.Down.ImageTransparency
    arg36.Frame.Background.Up.ImageTransparency = arg36.Frame.Foreground.Up.ImageTransparency
    v25 = v18 and v18.DotThickness or 2
    v28 = v18 and v18.BarsLength or 6
    v23 = v18 and v18.BarsThickness or 2
    v22 = v18 and v18.CircleSize or 16
    v20 = v18 and v18.CircleThickness or 2
    local v30 = v21.DotSize
    local Dot = arg36.Frame.Foreground.Dot

    if not v30 then
        v30 = UDim2.new(0, v25, 0, v25)
    end

    Dot.Size = v30
    v30 = v21.RightBarSize
    local Right_2 = arg36.Frame.Foreground.Right

    if not v30 then
        v30 = UDim2.new(0, v28, 0, v23)
    end

    Right_2.Size = v30
    v30 = v21.LeftBarSize
    local Left_2 = arg36.Frame.Foreground.Left

    if not v30 then
        v30 = UDim2.new(0, v28, 0, v23)
    end

    Left_2.Size = v30
    v30 = v21.BottomBarSize
    local Down_2 = arg36.Frame.Foreground.Down

    if not v30 then
        v30 = UDim2.new(0, v23, 0, v28)
    end

    Down_2.Size = v30
    v30 = v21.TopBarSize
    local Up_2 = arg36.Frame.Foreground.Up

    if not v30 then
        v30 = UDim2.new(0, v23, 0, v28)
    end

    Up_2.Size = v30
    v30 = v21.CircleSize
    local Circle = arg36.Frame.Foreground.Circle
    v30 = v30 or UDim2.new(0, v22, 0, v22)
    Circle.Size = v30
    arg36.Frame.Foreground.Circle.UIStroke.Thickness = v21.CircleThickness or v20
    arg36.Frame.Background.Dot.Size = arg36.Frame.Foreground.Dot.Size
    arg36.Frame.Background.Right.Size = arg36.Frame.Foreground.Right.Size
    arg36.Frame.Background.Left.Size = arg36.Frame.Foreground.Left.Size
    arg36.Frame.Background.Down.Size = arg36.Frame.Foreground.Down.Size
    arg36.Frame.Background.Up.Size = arg36.Frame.Foreground.Up.Size
    v25 = not v18 or not v18.OutlineDisabled
    arg36.Frame.Background.Circle.UIStroke.Enabled = v25
    arg36.Frame.Background.Dot.UIStroke.Enabled = v25
    arg36.Frame.Background.Right.UIStroke.Enabled = v25
    arg36.Frame.Background.Left.UIStroke.Enabled = v25
    arg36.Frame.Background.Down.UIStroke.Enabled = v25
    arg36.Frame.Background.Up.UIStroke.Enabled = v25
    local v32

    if v25 then
        v28 = v18 and v18.OutlineTransparency or 0
        v23 = v28 + (1 - v28) * arg36._transparency
        arg36.Frame.Background.Dot.UIStroke.Transparency = v23
        arg36.Frame.Background.Right.UIStroke.Transparency = v23
        arg36.Frame.Background.Left.UIStroke.Transparency = v23
        arg36.Frame.Background.Down.UIStroke.Transparency = v23
        arg36.Frame.Background.Up.UIStroke.Transparency = v23
        arg36.Frame.Background.Circle.UIStroke.Transparency = v23
        v28 = v18 and v18.OutlineThickness or 0
        local _ = v28 * 2 + v20
        arg36.Frame.Background.Dot.UIStroke.Thickness = v28
        arg36.Frame.Background.Right.UIStroke.Thickness = v28
        arg36.Frame.Background.Left.UIStroke.Thickness = v28
        arg36.Frame.Background.Down.UIStroke.Thickness = v28
        arg36.Frame.Background.Up.UIStroke.Thickness = v28
        arg36.Frame.Background.Circle.UIStroke.Thickness = v28 * 2 + v20
        local Circle_1 = arg36.Frame.Background.Circle
        local New = UDim2.new
        local maximum = math.max(0, arg36.Frame.Foreground.Circle.Size.X.Offset - v28 * 2)
        Circle_1.Size = New(
            0,
            maximum,
            0,
            (math.max(0, arg36.Frame.Foreground.Circle.Size.Y.Offset - v28 * 2))
        )
        local LineJoinMode = Enum.LineJoinMode
        v32 = v18 and v18.OutlineType or "Miter"
        v28 = LineJoinMode[v32]
        arg36.Frame.Background.Dot.UIStroke.LineJoinMode = v28
        arg36.Frame.Background.Right.UIStroke.LineJoinMode = v28
        arg36.Frame.Background.Left.UIStroke.LineJoinMode = v28
        arg36.Frame.Background.Down.UIStroke.LineJoinMode = v28
        arg36.Frame.Background.Up.UIStroke.LineJoinMode = v28
    end

    v32 = v18 and v18.DotColor or "#ffffff"
    v25 = Utility_m:Color3FromHex(v32)
    local v33 = Utility_m
    local v34 = v18 and v18.BarsColor or "#ffffff"
    v22 = v33:Color3FromHex(v34)
    local v35 = Utility_m
    v34 = v18 and v18.CircleColor or "#ffffff"
    v21 = v35:Color3FromHex(v34)
    arg36.Frame.Foreground.Dot.ImageColor3 = v25
    arg36.Frame.Foreground.Right.ImageColor3 = v22
    arg36.Frame.Foreground.Left.ImageColor3 = v22
    arg36.Frame.Foreground.Down.ImageColor3 = v22
    arg36.Frame.Foreground.Up.ImageColor3 = v22
    arg36.Frame.Foreground.Circle.UIStroke.Color = v21
    arg36.Frame.Background.Dot.ImageColor3 = arg36.Frame.Foreground.Dot.ImageColor3
    arg36.Frame.Background.Right.ImageColor3 = arg36.Frame.Foreground.Right.ImageColor3
    arg36.Frame.Background.Left.ImageColor3 = arg36.Frame.Foreground.Left.ImageColor3
    arg36.Frame.Background.Down.ImageColor3 = arg36.Frame.Foreground.Down.ImageColor3
    arg36.Frame.Background.Up.ImageColor3 = arg36.Frame.Foreground.Up.ImageColor3
    local v36 = Utility_m
    local v37 = v18 and v18.OutlineColor or "#000000"
    local v38 = v36:Color3FromHex(v37)
    arg36.Frame.Background.Dot.UIStroke.Color = v38
    arg36.Frame.Background.Right.UIStroke.Color = v38
    arg36.Frame.Background.Left.UIStroke.Color = v38
    arg36.Frame.Background.Down.UIStroke.Color = v38
    arg36.Frame.Background.Up.UIStroke.Color = v38
    arg36.Frame.Background.Circle.UIStroke.Color = v38
    v38 = v18 and v18.BarsShape or "Sharp"
    v22 = v18 and v18.DotShape or "Sharp"
    v21 = v18 and v18.CircleShape or "Circle"
    local UICorner = arg36.Frame.Foreground.Dot.UICorner
    v37 = if v22 ~= "Round" then UDim.new(0, 0) else UDim.new(1, 0) or UDim.new(0, 0)
    UICorner.CornerRadius = v37
    local UICorner_1 = arg36.Frame.Foreground.Right.UICorner
    v37 = if v38 ~= "Round" then UDim.new(0, 0) else UDim.new(1, 0) or UDim.new(0, 0)
    UICorner_1.CornerRadius = v37
    local UICorner_2 = arg36.Frame.Foreground.Left.UICorner
    v37 = if v38 ~= "Round" then UDim.new(0, 0) else UDim.new(1, 0) or UDim.new(0, 0)
    UICorner_2.CornerRadius = v37
    local UICorner_3 = arg36.Frame.Foreground.Down.UICorner
    v37 = if v38 ~= "Round" then UDim.new(0, 0) else UDim.new(1, 0) or UDim.new(0, 0)
    UICorner_3.CornerRadius = v37
    local UICorner_4 = arg36.Frame.Foreground.Up.UICorner
    v37 = if v38 ~= "Round" then UDim.new(0, 0) else UDim.new(1, 0) or UDim.new(0, 0)
    UICorner_4.CornerRadius = v37
    local UICorner_5 = arg36.Frame.Foreground.Circle.UICorner
    v37 = if v21 ~= "Circle" then if v21 ~= "Round" then UDim.new(0, 0) else UDim.new(0.25, 0) or UDim.new(
        0,
        0
    ) else UDim.new(1, 0) or (if v21 ~= "Round" then UDim.new(0, 0) else UDim.new(0.25, 0) or UDim.new(
        0,
        0
    ))
    UICorner_5.CornerRadius = v37
    arg36.Frame.Background.Dot.UICorner.CornerRadius = arg36.Frame.Foreground.Dot.UICorner.CornerRadius
    arg36.Frame.Background.Right.UICorner.CornerRadius = arg36.Frame.Foreground.Right.UICorner.CornerRadius
    arg36.Frame.Background.Left.UICorner.CornerRadius = arg36.Frame.Foreground.Left.UICorner.CornerRadius
    arg36.Frame.Background.Down.UICorner.CornerRadius = arg36.Frame.Foreground.Down.UICorner.CornerRadius
    arg36.Frame.Background.Up.UICorner.CornerRadius = arg36.Frame.Foreground.Up.UICorner.CornerRadius
    arg36.Frame.Background.Circle.UICorner.CornerRadius = arg36.Frame.Foreground.Circle.UICorner.CornerRadius
end

function t._Setup(arg38) -- line: 398
    arg38.Frame.Visible = true
end

function t._Init(arg39) -- line: 402
    arg39.Frame.Destroying:Connect(function() -- line: 403
        -- upvalues:
        --  [1] arg39 (copy)

        arg39:Destroy()
    end)
    arg39:_Setup()
    arg39:SetType("Default", true)
    arg39:SetSpacing(16, 1, true)
    arg39:SetTransparency(0, true)
    local udim2 = UDim2.new(0, 0, 0)
    arg39:SetHitmarkerVisuals(0, udim2, 1, 0)
    arg39:SetVisible(true, true)
    arg39:SetAppearance(nil, true)
    arg39:_Update()
end

return t
