local CosmeticSlot_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules.CosmeticSlot
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Customize = arg1
    t_1.Frame = t_1.Customize.TopFrame:WaitForChild("NameDisplay")
    t_1.Background = t_1.Frame:WaitForChild("Background")
    t_1.ElementsFrame = t_1.Frame:WaitForChild("Elements")
    t_1.Layout = t_1.ElementsFrame:WaitForChild("Layout")
    t_1.SlotContainer = t_1.ElementsFrame:WaitForChild("Slot"):WaitForChild("Container")
    t_1.TitleContainer = t_1.ElementsFrame:WaitForChild("TitleContainer")
    t_1.Title = t_1.TitleContainer:WaitForChild("Title")
    t_1._cosmetic_slot = nil
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2) -- line: 31
    arg2:_Update()
end

function t._Update(arg3) -- line: 39
    -- upvalues:
    --  [1] CosmeticSlot_m (copy)

    if arg3._cosmetic_slot then
        arg3._cosmetic_slot:Destroy()
        arg3._cosmetic_slot = nil
    end

    local v1 = arg3.Customize.Interface.Equipment:GetSelectedCosmetic()
    arg3.Frame.Visible = if v1 == nil then false else true
    local Title = arg3.Title
    Title.Text = if v1 ~= "RANDOM_COSMETIC" then v1 or "" else "Random"

    if v1 then
        arg3._cosmetic_slot = CosmeticSlot_m.new(v1)
        arg3._cosmetic_slot:SetWeapon(nil)
        arg3._cosmetic_slot:OverrideNameText("")
        arg3._cosmetic_slot:SetInteractable(false)
        arg3._cosmetic_slot.Frame.Parent = arg3.SlotContainer
    end
end

function t._UpdateLayout(arg4) -- line: 59
    arg4.TitleContainer.Size = UDim2.new(0, arg4.Title.TextBounds.X, 0.75, 0)
    arg4.Background.Size = UDim2.new(
        0,
        arg4.Layout.AbsoluteContentSize.X + arg4.TitleContainer.AbsoluteSize.Y * 0.5,
        1,
        0
    )
end

function t._Init(arg5) -- line: 64
    arg5.Title:GetPropertyChangedSignal("TextBounds"):Connect(function() -- line: 65
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateLayout()
    end)
    arg5.TitleContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 69
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateLayout()
    end)
    arg5.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 73
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_UpdateLayout()
    end)
    arg5:_UpdateLayout()
end

return t
