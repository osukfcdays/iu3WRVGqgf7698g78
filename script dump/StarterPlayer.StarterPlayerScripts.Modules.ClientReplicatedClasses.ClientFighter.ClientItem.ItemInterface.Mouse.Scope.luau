local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)
    --  [3] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.ActiveChanged = Signal_m.new()
    t_1.Mouse = arg1
    t_1.Frame = t_1.Mouse.Frame:WaitForChild("Scope")
    t_1.BlurFrame = t_1.Frame:WaitForChild("Blur")
    t_1.BlurImage = t_1.BlurFrame:WaitForChild("ImageLabel")
    t_1.ReticleFrame = t_1.Frame:WaitForChild("Reticle")
    t_1.ReticleContainer = t_1.ReticleFrame:WaitForChild("Container")
    t_1.ReticleContainerHorizontal = t_1.ReticleContainer:WaitForChild("Horizontal")
    t_1.ReticleContainerVertical = t_1.ReticleContainer:WaitForChild("Vertical")
    t_1.ReticleContainerBottom = t_1.ReticleContainer:WaitForChild("Bottom")
    t_1.ReticleContainerTop = t_1.ReticleContainer:WaitForChild("Top")
    t_1.ReticleContainerLeft = t_1.ReticleContainer:WaitForChild("Left")
    t_1.ReticleContainerRight = t_1.ReticleContainer:WaitForChild("Right")
    t_1.ReticleContainerDot = t_1.ReticleContainer:WaitForChild("Dot")
    t_1.ReticleContainerDotUICorner = t_1.ReticleContainerDot:WaitForChild("UICorner")
    t_1.CircleFrame = t_1.Frame:WaitForChild("Circle")
    t_1.CircleImage = t_1.CircleFrame:WaitForChild("ImageLabel")
    t_1.CircleImageBottom = t_1.CircleImage:WaitForChild("Bottom")
    t_1.CircleImageTop = t_1.CircleImage:WaitForChild("Top")
    t_1.CircleImageLeft = t_1.CircleImage:WaitForChild("Left")
    t_1.CircleImageRight = t_1.CircleImage:WaitForChild("Right")
    t_1._destroyed = false
    t_1._is_scope_active = false
    t_1._dont_rotate_scope_while_sliding = false
    t_1._scope_dot_spring = Spring_m.new(1, 1, 50)
    t_1:_Init()

    return t_1
end

function t.IsActive(arg2) -- line: 53
    return arg2._is_scope_active
end

function t.SetActive(arg3, arg4) -- line: 58
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Utility_m (copy)

    if arg3._destroyed then
        return
    end

    assert(
        if typeof(arg4) ~= "boolean" then false else true,
        "Argument 1 invalid, expected a boolean"
    )
    arg3._is_scope_active = arg4
    arg3.ActiveChanged:Fire()
    local v1 = arg3._is_scope_active
    local Frame = arg3.Frame

    if v1 then
        v1 = CONSTANTS_m.DEVICE ~= "VR"
    end

    Frame.Visible = v1
    local v2 = arg3.Mouse.MouseCrosshair.Crosshair:GetScopedRedDotColor() or "#ff3232"
    local v3 = not arg3.Mouse.MouseCrosshair.Crosshair:IsScopedRedDotDisabled()
    local v4 = not arg3.Mouse.MouseCrosshair.Crosshair:IsScopedBarsDisabled()
    arg3.ReticleContainerDot.BackgroundColor3 = Utility_m:Color3FromHex(v2)
    arg3.ReticleContainerDot.Visible = v3
    arg3.ReticleContainerBottom.Visible = v4
    arg3.ReticleContainerTop.Visible = v4
    arg3.ReticleContainerLeft.Visible = v4
    arg3.ReticleContainerRight.Visible = v4
    arg3.ReticleContainerVertical.Visible = v4
    arg3.ReticleContainerHorizontal.Visible = v4

    if not arg3._is_scope_active then
        return
    end

    arg3.BlurFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    arg3.BlurFrame:TweenSize(
        UDim2.new(1, 0, 1, 0),
        "Out",
        "Quint",
        0.5 / (arg3.Mouse.ItemInterface.ClientItem.Info.AimSpeed or 1),
        true
    )
    arg3.BlurFrame.Position = UDim2.new(0.75, 0, 0.75, 0)
    arg3.BlurFrame:TweenPosition(
        UDim2.new(0.5, 0, 0.5, 0),
        "Out",
        "Quint",
        0.375,
        true
    )
end

function t.Update(arg5, _, _, _) -- line: 97
    if not arg5._is_scope_active then
        return
    end

    if arg5._dont_rotate_scope_while_sliding then
        arg5.Frame.Rotation = -arg5.Mouse.Frame.Rotation
        arg5.ReticleFrame.Rotation = arg5.Mouse.Frame.Rotation
    end

    arg5.BlurImage.Position = UDim2.new(
        0.5,
        0,
        0.5 + (arg5.Mouse.ItemInterface.ClientItem.ViewModel.CurrentJumpValue * 0.0025 - arg5.Mouse.ItemInterface.ClientItem.ViewModel.CurrentLandingValue * 0.125),
        0
    )
    local v8 = arg5.Mouse.ItemInterface.ClientItem.ClientFighter:GetCameraData(
        arg5.Mouse.ItemInterface.ClientItem.ClientFighter:GetRaycastWhitelist(
            true,
            nil,
            nil,
            arg5.Mouse.ItemInterface.ClientItem.Info.RaycastGrabSmallHitboxes
        ),
        nil,
        true
    )
    local v9 = v8[utf8.char(2)]
    local v6 = if not v9 then math.huge else (workspace.CurrentCamera.CFrame.Position - (v9.CFrame * v8[utf8.char(
        3
    )]).Position).Magnitude
    arg5._scope_dot_spring.Target = 12 / math.max(1, v6 / 50)
    local v10 = arg5._scope_dot_spring.Value / 8
    arg5.ReticleContainerDot.Size = UDim2.new(0.008 * v10, 0, 0.008 * v10, 0)
end

function t.Destroy(arg9) -- line: 129
    arg9._destroyed = true
    arg9.ActiveChanged:Destroy()
end

function t._Setup(arg10) -- line: 138
    if arg10.Mouse.ItemInterface.ClientItem.ViewModel.Name == "Pixel Sniper" then
        arg10.BlurImage.Image = "rbxassetid://18171031143"
        arg10.BlurImage.ResampleMode = Enum.ResamplerMode.Pixelated
        arg10.CircleImage.Image = "rbxassetid://18171045114"
        arg10.CircleImage.ResampleMode = Enum.ResamplerMode.Pixelated
        arg10.ReticleContainerDotUICorner:Destroy()

        return
    end

    if arg10.Mouse.ItemInterface.ClientItem.ViewModel.Name == "Keyper" then
        arg10.BlurImage.Image = "rbxassetid://129335242148588"
        arg10.BlurImage.Size = UDim2.new(1.25, 0, 1.25, 0)
        arg10.CircleImage.Image = "rbxassetid://81498448678518"
        arg10.CircleImage.Size = UDim2.new(1.25, 0, 1.25, 0)
        arg10._dont_rotate_scope_while_sliding = true

        return
    end

    if arg10.Mouse.ItemInterface.ClientItem.ViewModel.Name == "Pixel Crossbow" then
        arg10.CircleImage.Image = "rbxassetid://97622703342015"
        arg10.CircleImage.ResampleMode = Enum.ResamplerMode.Pixelated
        arg10.ReticleContainerDotUICorner:Destroy()
    end
end

function t._Init(arg11) -- line: 158
    arg11:_Setup()
end

return t
