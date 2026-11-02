local CosmeticLibrary_m = require(game:GetService("ReplicatedStorage").Modules.CosmeticLibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Customize = arg1
    t_1.Frame = t_1.Customize.TopFrame:WaitForChild("Description")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.Arrow = t_1.Frame:WaitForChild("Arrow")
    t_1.Title = t_1.Frame:WaitForChild("Title")
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2) -- line: 26
    arg2:_Update()
end

function t._UpdateArrow(arg3) -- line: 34
    local v1 = arg3.Background.AbsolutePosition.X + arg3.Background.AbsoluteSize.X / 2 - (arg3.Customize.NameDisplay.SlotContainer.AbsolutePosition.X + arg3.Customize.NameDisplay.SlotContainer.AbsoluteSize.X / 2)
    local absoluteValue = math.abs(v1)
    local minimum = math.min(
        absoluteValue,
        arg3.Background.AbsoluteSize.X / 2 - arg3.Arrow.AbsoluteSize.X - 8
    )
    arg3.Arrow.Position = UDim2.new(0.5, -(minimum * math.sign(v1)), 0, 2)
end

function t._Update(arg4) -- line: 41
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)

    local v2 = arg4.Customize.Interface.Equipment:GetSelectedCosmetic()
    local v3 = CosmeticLibrary_m.Cosmetics[v2]
    local v4 = if v2 == "RANDOM_COSMETIC" then "Equips a random cosmetic every time you spawn" else v3 and v3.GetDescription(
        true
    ) or nil
    local Frame = arg4.Frame
    Frame.Visible = v4 ~= nil
    arg4.Title.Text = v4 or ""

    if arg4.Frame.Visible then
        arg4.Frame.Size = UDim2.new(0.5, 0.03125, 0)
        arg4.Frame:TweenSize(
            UDim2.new(1, 0, 0.0625, 0),
            "Out",
            "Back",
            0.25,
            true
        )
    end
end

function t._UpdateBackground(arg5) -- line: 57
    arg5.Background.Size = UDim2.new(0, arg5.Title.TextBounds.X + arg5.Frame.AbsoluteSize.Y, 1, 0)
end

function t._Init(arg6) -- line: 61
    arg6.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 62
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateBackground()
    end)
    arg6.Background:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 66
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateArrow()
    end)
    arg6.Background:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateArrow()
    end)
    arg6.Arrow:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateArrow()
    end)
    arg6.Customize.NameDisplay.SlotContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(
        function() -- line: 78
            -- upvalues:
            --  [1] arg6 (copy)

            arg6:_UpdateArrow()
        end
    )
    arg6.Customize.NameDisplay.SlotContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateArrow()
    end)
    arg6:_UpdateBackground()
    arg6:_UpdateArrow()
end

return t
