local _ = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local _ = game:GetService("Lighting")
local _ = CFrame.new(0, 0, -1.1) * CFrame.Angles(0, 1.5707963267948966, 0)
local t = {}
t.__index = t

function t.new(arg1) -- line: 11
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ItemInterface = arg1
    t_1.CanvasGroup = Instance.new("CanvasGroup")
    t_1.CanvasGroupUICorner = Instance.new("UICorner")
    t_1.CanvasGroupImage = t_1.ItemInterface.Mouse.Scope.BlurImage:Clone()
    t_1._glass = Instance.new("Part")
    t_1._dof = Instance.new("DepthOfFieldEffect")
    t_1._glass_renderstep_id = nil
    t_1:_Init()

    return t_1
end

function t.SetShape(arg2, arg3) -- line: 32
    arg2._glass.Shape = arg3
    local Frame = arg2.ItemInterface.Mouse.Scope.Frame
    Frame.Size = if arg3 ~= Enum.PartType.Block then UDim2.new(1, 0, 1, 0) else UDim2.new(
        0.875,
        0,
        0.875,
        0
    ) or UDim2.new(1, 0, 1, 0)
    local CircleImage = arg2.ItemInterface.Mouse.Scope.CircleImage
    CircleImage.Image = if arg3 ~= Enum.PartType.Block then "rbxassetid://128819262942122" else "rbxassetid://85501091107884"
    local CanvasGroupUICorner = arg2.CanvasGroupUICorner
    CanvasGroupUICorner.CornerRadius = if arg3 ~= Enum.PartType.Block then UDim.new(1, 0) else UDim.new(
        0,
        0
    ) or UDim.new(1, 0)
    local CanvasGroupImage = arg2.CanvasGroupImage
    CanvasGroupImage.Image = if arg3 ~= Enum.PartType.Block then "rbxassetid://13466088854" else "rbxassetid://102865472475647"
end

function t.Refresh(arg4) -- line: 40
    -- upvalues:
    --  [1] RunService (copy)

    if arg4._glass_renderstep_id then
        RunService:UnbindFromRenderStep(arg4._glass_renderstep_id)
        arg4._glass_renderstep_id = nil
    end

    arg4._glass.Parent = nil
    arg4._dof.Parent = nil
end

function t.Destroy(arg5) -- line: 66
    -- upvalues:
    --  [1] RunService (copy)

    if arg5._glass_renderstep_id then
        RunService:UnbindFromRenderStep(arg5._glass_renderstep_id)
        arg5._glass_renderstep_id = nil
    end

    arg5._glass:Destroy()
    arg5._dof:Destroy()
end

function t._Setup(arg6) -- line: 80
    arg6._glass.Color = Color3.fromRGB(255, 255, 255)
    arg6._glass.Material = Enum.Material.Glass
    arg6._glass.Transparency = 0.999
    arg6._glass.Anchored = true
    arg6._glass.CanCollide = false
    arg6._glass.CanQuery = false
    arg6._glass.CanTouch = false
    arg6._glass.CastShadow = false
    arg6._glass.Name = "CrossbowScope"
    arg6._dof.FarIntensity = 1
    arg6._dof.FocusDistance = 0
    arg6._dof.InFocusRadius = 0.2
    arg6._dof.NearIntensity = 0
    arg6._dof.Name = "CrossbowScope"
    arg6.ItemInterface.Mouse.Scope.CircleImageBottom.Visible = false
    arg6.ItemInterface.Mouse.Scope.CircleImageTop.Visible = false
    arg6.ItemInterface.Mouse.Scope.CircleImageLeft.Visible = false
    arg6.ItemInterface.Mouse.Scope.CircleImageRight.Visible = false
    arg6.ItemInterface.Mouse.Scope.BlurImage.Visible = false
    arg6.ItemInterface.Mouse.Scope.ReticleContainerBottom.Size = UDim2.new(0, 4, 0.25, 0)
    arg6.ItemInterface.Mouse.Scope.ReticleContainerTop.Size = UDim2.new(0, 4, 0.25, 0)
    arg6.ItemInterface.Mouse.Scope.ReticleContainerLeft.Size = UDim2.new(0.25, 0, 0, 4)
    arg6.ItemInterface.Mouse.Scope.ReticleContainerRight.Size = UDim2.new(0.25, 0, 0, 4)
    arg6.CanvasGroup.BackgroundTransparency = 1
    arg6.CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
    arg6.CanvasGroup.Parent = arg6.ItemInterface.Mouse.Scope.Frame
    arg6.CanvasGroupUICorner.Parent = arg6.CanvasGroup
    arg6.CanvasGroupImage.Parent = arg6.CanvasGroup
    arg6:SetShape(Enum.PartType.Cylinder)

    if arg6.ItemInterface.ClientItem.ViewModel.Name == "Pixel Crossbow" then
        arg6.CanvasGroupImage.Image = "rbxassetid://18171031143"
        arg6.CanvasGroupImage.ResampleMode = Enum.ResamplerMode.Pixelated
    end
end

function t._Init(arg7) -- line: 121
    arg7.ItemInterface.Mouse.Scope.ActiveChanged:Connect(function() -- line: 122
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Refresh()
    end)
    arg7.ItemInterface.ActiveChanged:Connect(function() -- line: 126
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Refresh()
    end)
    arg7.ItemInterface.Mouse.Scope.BlurFrame:GetPropertyChangedSignal("Position"):Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.CanvasGroupImage.Position = arg7.ItemInterface.Mouse.Scope.BlurFrame.Position
    end)
    arg7.ItemInterface.Mouse.Scope.BlurFrame:GetPropertyChangedSignal("Size"):Connect(function() -- line: 134
        -- upvalues:
        --  [1] arg7 (copy)

        arg7.CanvasGroupImage.Size = arg7.ItemInterface.Mouse.Scope.BlurFrame.Size
    end)
    arg7:_Setup()
    arg7:Refresh()
end

return t
