local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "Spotlight")
    t_1._spotlight_hash = 0
    t_1._spotlight_connection = nil
    t_1._spotlight_reference = nil
    t_1._spotlight_transparency = 1
    t_1:_Init()

    return t_1
end

function t.GetCurrentReference(arg1) -- line: 32
    return arg1._spotlight_reference
end

function t.ChangeSubject(arg2, arg3, arg4) -- line: 36
    -- upvalues:
    --  [1] Spring_m (copy)
    --  [2] RunService (copy)

    if arg4 and arg2:GetCurrentReference() ~= arg4 then
        return
    end

    arg2._spotlight_hash += 1

    if arg2._spotlight_connection then
        arg2._spotlight_connection:Disconnect()
        arg2._spotlight_connection = nil
    end

    if arg2._spotlight_reference then
        local SpotlightReference = arg2._spotlight_reference
        SpotlightReference.ZIndex -= 1
    end

    arg2._spotlight_reference = arg3

    if not arg2._spotlight_reference then
        arg2:_SetTransparency(1)

        return
    end

    local SpotlightReference_1 = arg2._spotlight_reference
    SpotlightReference_1.ZIndex += 1
    arg2:_SetTransparency(0.75)
    local v2 = Spring_m.new(arg2.Frame.AbsolutePosition, 0.875, 25)
    local v3 = Spring_m.new(arg2.Frame.AbsoluteSize, 0.875, 25)
    arg2._spotlight_connection = RunService.RenderStepped:Connect(function() -- line: 65
        -- upvalues:
        --  [1] v2 (copy)
        --  [2] arg2 (copy)
        --  [3] v3 (copy)

        v2.Target = arg2._spotlight_reference.AbsolutePosition
        v3.Target = arg2._spotlight_reference.AbsoluteSize
        local v4 = v2.Value - arg2.Frame.Parent.AbsolutePosition
        arg2.Frame.Position = UDim2.new(0, v4.X - 8, 0, v4.Y - 8)
        arg2.Frame.Size = UDim2.new(0, v3.Value.X + 16, 0, v3.Value.Y + 16)
    end)
end

function t._UpdateVisibility(arg5) -- line: 80
    -- upvalues:
    --  [1] GuiService (copy)

    arg5.Frame.Visible = not GuiService.MenuIsOpen
end

function t._SetTransparency(arg6, arg7) -- line: 84
    -- upvalues:
    --  [1] Utility_m (copy)

    local SpotlightHash = arg6._spotlight_hash
    task.spawn(function() -- line: 87
        -- upvalues:
        --  [1] Utility_m (ref)
        --  [2] SpotlightHash (copy)
        --  [3] arg6 (copy)
        --  [4] arg7 (copy)

        Utility_m:RenderstepForLoop(0, 100, 4, function(arg8) -- line: 88
            -- upvalues:
            --  [1] SpotlightHash (ref)
            --  [2] arg6 (ref)
            --  [3] arg7 (ref)

            if SpotlightHash ~= arg6._spotlight_hash then
                return true
            end

            arg6._spotlight_transparency += (arg7 - arg6._spotlight_transparency) * (1 - (1 - arg8 / 100) ^ 2)

            for _, val in pairs(arg6.Frame:GetChildren()) do
                if val:IsA("ImageLabel") then
                    val.ImageTransparency = arg6._spotlight_transparency
                else
                    val.BackgroundTransparency = arg6._spotlight_transparency
                end
            end
        end)

        if SpotlightHash ~= arg6._spotlight_hash then
            return
        end

        if arg7 >= 1 then
            arg6.Frame.Size = UDim2.new(3, 0, 3, 0)
            arg6.Frame.Position = UDim2.new(-1, 0, -1, 0)
        end
    end)
end

function t._Init(arg9) -- line: 115
    -- upvalues:
    --  [1] GuiService (copy)

    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 116
        -- upvalues:
        --  [1] arg9 (copy)

        arg9:_UpdateVisibility()
    end)
    arg9:_UpdateVisibility()
    arg9:ChangeSubject(nil)
end

return t._new()
