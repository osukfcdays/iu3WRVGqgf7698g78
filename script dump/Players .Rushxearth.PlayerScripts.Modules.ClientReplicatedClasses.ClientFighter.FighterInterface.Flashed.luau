local _ = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local GameplayUtility_m = require(ReplicatedStorage.Modules.GameplayUtility)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules.UILibrary)
local FlashbangGui = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("FlashbangGui")
local _ = { "", "rbxassetid://18983794775", "rbxassetid://18983794942", "rbxassetid://18983795108" }
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 21
    -- upvalues:
    --  [1] t_1 (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.FighterInterface = arg1
    t_2._default_flash_sound_callback = nil
    t_2._default_ringing_sound_callback = nil
    t_2._flash_objects = {}
    t_2:_Init()

    return t_2
end

function t_1.AttemptToFlash(
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8
) -- line: 39
    if arg2:_IsOccluded(arg3, arg4) then
        return
    end

    arg2:Flash(
        arg4,
        arg5,
        arg6,
        arg7,
        arg8
    )
end

function t_1.Flash(
    arg9,
    arg10,
    arg11,
    arg12,
    arg13,
    arg14
) -- line: 47
    -- upvalues:
    --  [1] UILibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] FlashbangGui (copy)
    --  [4] Players (copy)
    --  [5] BetterDebris_m (copy)
    --  [6] Lighting (copy)
    --  [7] ReplicatedStorage (copy)
    --  [8] RunService (copy)

    local screenPoint, isOnScreen = workspace.CurrentCamera:WorldToScreenPoint(arg10)
    local v2 = UILibrary_m:ScreenPointToPosition(
        Vector2.new(screenPoint.X, screenPoint.Y),
        arg9.FighterInterface.Frame.AbsolutePosition
    )
    local New = UDim2.new
    local clampedValue = math.clamp(
        v2.X,
        -arg9.FighterInterface.Frame.AbsoluteSize.X * 0.5,
        arg9.FighterInterface.Frame.AbsoluteSize.X * 1.5
    )
    local v3 = New(
        0,
        clampedValue,
        0,
        (math.clamp(
            v2.Y,
            -arg9.FighterInterface.Frame.AbsoluteSize.Y * 0.5,
            arg9.FighterInterface.Frame.AbsoluteSize.Y * 1.5
        ))
    )
    local v4 = PlayerDataController_m:GetSetting("Accessible Flashes")
    local v5 = if v4 then -2 else 2
    local v6 = v4 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
    local v7 = if arg13 ~= "Shining Star" then if arg13 ~= "Sol" then v4 and Color3.fromRGB(
        60,
        60,
        60
    ) or Color3.fromRGB(220, 215, 204) else Color3.fromRGB(255, 251, 133) or v4 and Color3.fromRGB(
        60,
        60,
        60
    ) or Color3.fromRGB(220, 215, 204) else Color3.fromRGB(255, 215, 0) or (if arg13 ~= "Sol" then v4 and Color3.fromRGB(
        60,
        60,
        60
    ) or Color3.fromRGB(220, 215, 204) else Color3.fromRGB(255, 251, 133) or v4 and Color3.fromRGB(
        60,
        60,
        60
    ) or Color3.fromRGB(220, 215, 204))
    v4 = if arg13 ~= "Pixel Flashbang" then "rbxassetid://14796588510" else "rbxassetid://123806439184095"
    local v8 = if arg13 ~= "Pixel Flashbang" then 1 else 0.75
    local v9 = if arg13 ~= "Pixel Flashbang" then Enum.ResamplerMode.Default else Enum.ResamplerMode.Pixelated or Enum.ResamplerMode.Default
    local v10 = FlashbangGui:Clone()
    v10.Background.BackgroundColor3 = v6
    v10.Center.Skullbang.Visible = false
    v10.Center.Position = v3
    v10.Rays1.Position = v3 + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30))
    v10.Rays2.Position = v3 + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30))
    v10.Rays3.Position = v3 + UDim2.new(0, math.random(-30, 30), 0, math.random(-30, 30))
    v10.Rays1.ResampleMode = v9
    v10.Rays2.ResampleMode = v9
    v10.Rays3.ResampleMode = v9
    v10.Rays1.Image = v4
    v10.Rays2.Image = v4
    v10.Rays3.Image = v4
    v10.Rays1.Size = UDim2.new(
        v10.Rays1.Size.X.Scale * v8,
        v10.Rays1.Size.X.Offset * v8,
        v10.Rays1.Size.Y.Scale * v8,
        v10.Rays1.Size.Y.Offset * v8
    )
    v10.Rays2.Size = UDim2.new(
        v10.Rays2.Size.X.Scale * v8,
        v10.Rays2.Size.X.Offset * v8,
        v10.Rays2.Size.Y.Scale * v8,
        v10.Rays2.Size.Y.Offset * v8
    )
    v10.Rays3.Size = UDim2.new(
        v10.Rays3.Size.X.Scale * v8,
        v10.Rays3.Size.X.Offset * v8,
        v10.Rays3.Size.Y.Scale * v8,
        v10.Rays3.Size.Y.Offset * v8
    )
    v10.Parent = Players.LocalPlayer.PlayerGui
    BetterDebris_m:AddItem(v10, arg11 + 5)
    v9 = Instance.new("ColorCorrectionEffect")
    v9.Name = "Flashbang"
    v9.Parent = Lighting
    BetterDebris_m:AddItem(v9, 10)
    v4 = Instance.new("Part")
    v4.Size = Vector3.new(10, 10, 0)
    v4.Anchored = true
    v4.CanCollide = false
    v4.CanTouch = false
    v4.CanQuery = false
    v4.Color = v6
    v4.Material = Enum.Material.Neon
    local v12 = isOnScreen and workspace or nil
    v4.Parent = v12
    BetterDebris_m:AddItem(v4, 10)
    v12 = (arg14 or arg9._default_ringing_sound_callback)()
    local v13 = if not isOnScreen then if not (screenPoint.Z > 0) then 0 else 0.125 else 1
    local v14 = arg11 * v13
    v13 = math.max(0.5, v14)
    local now = tick()
    local v15 = 0

    if v14 > 0 then
        ReplicatedStorage.Remotes.Replication.Fighter.BlindedEffect:FireServer(arg12, v14)
    end

    local v16 = arg9:_RegisterFlashObjects(
        v14,
        v10,
        v9,
        v4,
        v12
    )

    if arg13 == "Camera" and isOnScreen then
        local Success, Result = pcall(
            arg9._CameraSnapshot,
            arg9,
            arg10,
            v3,
            v10,
            v16
        )

        if not Success then
            warn("Camera Flashbang snapshot failed, error:", Result)
        end
    end

    arg9:_UpdateVisibility()

    while true do
        if not (tick() < now + v13) then
            break
        end

        local minimum = math.min(1, (tick() - now) / v13)
        local v19 = v14 > 0 and minimum or minimum * 0.25 + 0.75
        local v20 = 0.5 + 0.5 * v19
        local v21 = if arg13 == "Disco Ball" then Color3.fromHSV(tick() * 0.5 % 1, 0.75, 1) else v7
        local v22 = v21:Lerp(v6, v19)

        if v12 then
            v12.Volume = 1 - v19
        end

        v9.Brightness = v5 + (0 - v5) * v19
        v10.Rays1.ImageTransparency = v20
        v10.Rays2.ImageTransparency = v20
        v10.Rays3.ImageTransparency = v20
        v10.Rays1.ImageColor3 = v22
        v10.Rays2.ImageColor3 = v22
        v10.Rays3.ImageColor3 = v22
        local Background = v10.Background
        local v23 = if isOnScreen then v19 ^ 5 else 1
        Background.Transparency = v23
        v10.Polaroid.GroupTransparency = 0.25 + 0.75 * v19 ^ 2
        v4.Transparency = math.max(0, v19 - 0.25) / 0.75
        v4.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -1)

        if arg13 == "Pixel Flashbang" then
            v10.Rays1.Position = v3 + UDim2.new(
                0,
                math.random(-30, 30) * v8,
                0,
                math.random(-30, 30) * v8
            )
            v10.Rays2.Position = v3 + UDim2.new(
                0,
                math.random(-30, 30) * v8,
                0,
                math.random(-30, 30) * v8
            )
            v10.Rays3.Position = v3 + UDim2.new(
                0,
                math.random(-30, 30) * v8,
                0,
                math.random(-30, 30) * v8
            )
        else
            local Rays1_3 = v10.Rays1
            Rays1_3.Rotation += v15 * 0.5 * 60
            local Rays2_3 = v10.Rays2
            Rays2_3.Rotation -= v15 * 0.25 * 60
            local Rays3_3 = v10.Rays3
            Rays3_3.Rotation += v15 * 0.37237 * 60
        end

        v15 = RunService.RenderStepped:Wait()
    end

    v4:Destroy()
    v9:Destroy()
    v10:Destroy()
end

function t_1.Destroy(arg15) -- line: 165
    for _, val in pairs(arg15._flash_objects) do
        for _, val_1 in pairs(val) do
            val_1[1]:Destroy()
        end
    end

    arg15._flash_objects = {}
end

function t_1._CameraSnapshot(
    arg16,
    arg17,
    arg18,
    arg19,
    arg20
) -- line: 179
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] TweenService (copy)

    local v28 = SpectateController_m.CurrentSubject

    if v28 then
        v28 = SpectateController_m.CurrentSubject.Entity

        if v28 then
            v28 = SpectateController_m.CurrentSubject:CloneFighterModel()
        end
    end

    if not v28 then
        return
    end

    local Face = v28:FindFirstChild("face", true)

    if Face and Face:IsA("Decal") then
        Face.Texture = "rbxassetid://18983839334"
    end

    local Camera = Instance.new("Camera")
    Camera.CFrame = CFrame.new(
        v28.Head.Position + (arg17 - v28.Head.Position).Unit * 8,
        v28.Head.Position
    )
    Camera.FieldOfView = 35
    arg19.Polaroid.Visible = true
    arg19.Polaroid.Picture.BackgroundColor3 = Color3.fromHSV(math.random(), 0.756, 0.56)
    arg19.Polaroid.Picture.ViewportFrame.LightDirection = Camera.CFrame.LookVector
    arg19.Polaroid.Picture.ViewportFrame.CurrentCamera = Camera
    arg19.Polaroid.Rotation = 180
    arg19.Polaroid.Position = UDim2.new(math.random(), 0, 1.5, 0)
    arg19.Polaroid:TweenPosition(
        arg18,
        "Out",
        "Quint",
        1,
        true
    )
    TweenService:Create(
        arg19.Polaroid,
        TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Rotation = 1080 + 45 * (math.random() - 0.5) }
    ):Play()
    Camera.Parent = arg19.Polaroid.Picture.ViewportFrame
    v28.Parent = arg19.Polaroid.Picture.ViewportFrame.WorldModel

    for _, val_2 in pairs(v28:GetDescendants()) do
        if val_2:IsA("BasePart") then
            val_2.Anchored = true
        end
    end

    arg16:_RegisterFlashObject(arg20, v28)
    arg16:_RegisterFlashObject(arg20, Camera)

    return v28, Camera
end

function t_1._IsOccluded(arg21, arg22, arg23) -- line: 223
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] GameplayUtility_m (copy)

    local v31 = arg22 or {}

    if arg21.FighterInterface.ClientFighter.Entity then
        table.insert(v31, arg21.FighterInterface.ClientFighter.Entity.Model)
    end

    while true do
        local raycastResult = Utility_m:Raycast(
            workspace.CurrentCamera.CFrame.Position,
            arg23,
            (workspace.CurrentCamera.CFrame.Position - arg23).Magnitude,
            v31,
            Enum.RaycastFilterType.Exclude
        )

        if
            raycastResult.Instance
            and not raycastResult.Instance.CanCollide
            and not raycastResult.Instance:HasTag("SmokeCloud")
        then
            table.insert(v31, raycastResult.Instance)
            continue
        end

        if not raycastResult.Instance then
            break
        end

        return true
    end

    if #GameplayUtility_m:GetSmokeCloudsInSphere(arg23) > 0 then
        return true
    end

    return false
end

function t_1._RegisterFlashObject(_, arg25, arg26) -- line: 251
    table.insert(arg25, { arg26, arg26.Parent })
end

function t_1._RegisterFlashObjects(arg27, arg28, ...) -- line: 255
    local t_5 = {}

    for _, val_3 in pairs({ ... }) do
        arg27:_RegisterFlashObject(t_5, val_3)
    end

    table.insert(arg27._flash_objects, t_5)
    task.delay(arg28, function() -- line: 264
        -- upvalues:
        --  [1] arg27 (copy)
        --  [2] t_5 (copy)

        local index = table.find(arg27._flash_objects, t_5)

        if index then
            table.remove(arg27._flash_objects, index)
        end
    end)

    return t_5
end

function t_1._UpdateVisibility(arg29) -- line: 275
    for _, val_4 in pairs(arg29._flash_objects) do
        for _, val_5 in pairs(val_4) do
            pcall(function() -- line: 278
                -- upvalues:
                --  [1] val_5 (copy)
                --  [2] arg29 (copy)

                local v32 = val_5[1]
                v32.Parent = arg29.FighterInterface:IsActive() and val_5[2] or nil
            end)
        end
    end
end

function t_1._Setup(arg30) -- line: 285
    -- upvalues:
    --  [1] Utility_m (copy)

    function arg30._default_ringing_sound_callback() -- line: 286
        -- upvalues:
        --  [1] Utility_m (ref)

        return Utility_m:CreateSound(
            "rbxassetid://14778230632",
            1,
            1,
            script,
            true,
            10
        )
    end
end

function t_1._Init(arg31) -- line: 291
    arg31.FighterInterface.ActiveChanged:Connect(function() -- line: 292
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_UpdateVisibility()
    end)
    arg31:_Setup()
end

return t_1
