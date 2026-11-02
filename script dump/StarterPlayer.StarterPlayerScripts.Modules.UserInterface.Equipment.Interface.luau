local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local Customize_m = require(script:WaitForChild("Customize"))
local Right_m = require(script:WaitForChild("Right"))
local Left_m = require(script:WaitForChild("Left"))
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)
    --  [3] Customize_m (copy)
    --  [4] Right_m (copy)
    --  [5] Left_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Equipment = arg1
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Equipment")
    t_1.Customize = Customize_m.new(t_1)
    t_1.Right = Right_m.new(t_1)
    t_1.Left = Left_m.new(t_1)
    t_1:_Init()

    return t_1
end

function t.OnCustomizingStateChanged(arg2, ...) -- line: 31
    arg2.Customize:OnCustomizingStateChanged(...)
end

function t.OnStateChanged(arg3, ...) -- line: 35
    arg3.Right:OnStateChanged(...)
    arg3.Left:OnStateChanged(...)
    arg3.Customize:OnStateChanged(...)
end

function t.OnOpen(arg4, ...) -- line: 41
    arg4.Right:OnOpen(...)
    arg4.Left:OnOpen(...)
    arg4:_UpdateComponentsVisibility()
end

function t.Update(arg5, ...) -- line: 47
    arg5.Left:Update(...)
end

function t._UpdateComponentsVisibility(arg6) -- line: 55
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] GuiService (copy)

    local IsOpen = arg6.Equipment.IsOpen
    local v4 = arg6.Equipment:IsOpenEffectDone()
    local v5 = arg6.Equipment:IsUnlocking()
    local v6 = IsOpen

    if v6 then
        v6 = v4 and not v5 and not Pages_m.PageSystem.CurrentPage and not GuiService.MenuIsOpen
    end

    local v7 = arg6.Equipment:IsCustomizing()
    local v8 = v6
    local Right = arg6.Right

    if v8 then
        v8 = not v7

        if v8 then
            v8 = true
        end
    end

    Right:SetVisible(v8)
    v8 = v6
    local Left = arg6.Left

    if v8 then
        v8 = not v7

        if v8 then
            v8 = true
        end
    end

    Left:SetVisible(v8)
    v8 = v6
    local Customize = arg6.Customize

    if v8 then
        v8 = v7 and true
    end

    Customize:SetVisible(v8)
end

function t._Init(arg7) -- line: 69
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] GuiService (copy)

    arg7.Equipment.CustomizingChanged:Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateComponentsVisibility()
    end)
    arg7.Equipment.UnlockingChanged:Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateComponentsVisibility()
    end)
    arg7.Equipment.FinishedOpenEffect:Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateComponentsVisibility()
    end)
    arg7.Equipment.SpinControls.MouseDownChanged:Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateComponentsVisibility()
    end)
    Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 86
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateComponentsVisibility()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 90
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateComponentsVisibility()
    end)
    arg7:_UpdateComponentsVisibility()
end

return t
