local GuiService = game:GetService("GuiService")
local t = {}
t.__index = t

function t.new(arg1) -- line: 6
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ItemInterface = arg1
    t_1.AimingVignette = t_1.ItemInterface.Frame:WaitForChild("AimingVignette")
    t_1:_Init()

    return t_1
end

function t.Update(arg2, _, _, _) -- line: 21
    arg2.AimingVignette.ImageTransparency = 1 - arg2.ItemInterface.ClientItem.ViewModel.CurrentAimValue
end

function t.Destroy(_) -- line: 25
end

function t._Setup(arg7) -- line: 33
    -- upvalues:
    --  [1] GuiService (copy)

    arg7.AimingVignette.Size = UDim2.new(1, 0, 1, GuiService:GetGuiInset().Y)
end

function t._Init(arg8) -- line: 37
    arg8:_Setup()
end

return t
