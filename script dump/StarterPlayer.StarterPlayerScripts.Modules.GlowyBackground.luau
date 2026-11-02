local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RenderstepForLoop_m = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utility"):WaitForChild(
        "RenderstepForLoop"
    )
)
local EventLibrary_m = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("EventLibrary")
)
local GlowyBackground = Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild(
    "UserInterface"
):WaitForChild("GlowyBackground")
local t = { "Black", "Yellow", "Purple", "Purple2" }
local color = Color3.fromRGB(255, 255, 255)
local color_1 = Color3.fromRGB(220, 220, 220)
local t_1 = {}
t_1.__index = t_1

function t_1.new(arg1) -- line: 24
    -- upvalues:
    --  [1] t_1 (copy)
    --  [2] GlowyBackground (copy)

    local t_2 = setmetatable({}, t_1)
    t_2.Frame = GlowyBackground:Clone()
    t_2._name = arg1
    t_2._backdrop_transparency = 0
    t_2._elements = {}
    t_2._blur = Instance.new("BlurEffect")
    t_2._colorcorrection = Instance.new("ColorCorrectionEffect")
    t_2._is_enabled = false
    t_2._current_hash = 0
    t_2._start = tick()
    t_2._start_transparencies = {}
    t_2._connection = nil
    t_2._fade_in_alpha = 1
    t_2:_Init()

    return t_2
end

function t_1.SetParent(arg2, arg3) -- line: 50
    arg2.Frame.Parent = arg3
end

function t_1.SetBlurEnabled(arg4, arg5) -- line: 54
    arg4._blur.Enabled = arg5

    if not arg4._blur.Enabled then
        arg4._blur.Size = 0
    end
end

function t_1.SetBackdropTransparency(arg6, arg7) -- line: 62
    arg6._backdrop_transparency = arg7
    arg6:_UpdateElementsTransparency()
end

function t_1.DisableElement(arg8, arg9, arg10) -- line: 67
    arg8._elements[arg9].IsDisabled = arg10
    arg8:_UpdateElementsTransparency()
end

function t_1.SetEnabled(arg11, arg12, arg13) -- line: 72
    if arg11._is_enabled == arg12 and not arg13 then
        return
    end

    arg11._is_enabled = arg12
    task.spawn(arg11._Update, arg11, arg13)
    arg11:_UpdateElementsTransparency()
end

function t_1.SetColor(arg14, arg15, arg16) -- line: 82
    if not arg14._elements[arg15] then
        return
    end

    local Object = arg14._elements[arg15].Object
    local v3 = arg16 or arg14._elements[arg15].OriginalColor
    Object.ImageColor3 = v3
end

function t_1.Destroy(arg17) -- line: 92
    arg17.Frame:Destroy()
    arg17._blur:Destroy()
    arg17._colorcorrection:Destroy()
    arg17._current_hash += 1
end

function t_1._GetTransparency(arg18, arg19, arg20, arg21) -- line: 103
    local v4 = arg18._start_transparencies[arg19]
    local StartTransparencies = arg18._start_transparencies
    v4 = v4 or arg19[arg20]
    StartTransparencies[arg19] = v4
    local v5 = arg18._start_transparencies[arg19]
    local v6 = 1 - (1 - arg18._fade_in_alpha) ^ 4

    if not arg18._is_enabled then
        arg21 = 1
    end

    return v5 + (arg21 - v5) * v6
end

function t_1._UpdateElementsTransparency(arg22) -- line: 115
    arg22.Frame.BackgroundTransparency = arg22:_GetTransparency(
        arg22.Frame,
        "BackgroundTransparency",
        arg22._backdrop_transparency
    )

    for _, val in pairs(arg22._elements) do
        local Object_1 = val.Object
        local Object_2 = val.Object
        local v7 = if not val.IsDisabled then val.OriginalTransparency else 1
        Object_1.ImageTransparency = arg22:_GetTransparency(Object_2, "ImageTransparency", v7)
    end
end

function t_1._Update(arg23, arg24) -- line: 123
    -- upvalues:
    --  [1] RunService (copy)
    --  [2] RenderstepForLoop_m (copy)
    --  [3] color_1 (copy)
    --  [4] color (copy)

    for _, val_1 in pairs(arg23._elements) do
        val_1.Direction = Vector2.new(math.random() - 0.5, math.random() - 0.5).Unit
        val_1.Speed = 0.0125 + 0.025 * math.random()
    end

    arg23._start_transparencies = {}
    arg23._current_hash += 1
    local CurrentHash = arg23._current_hash
    local t_3 = {}

    for _, val_2 in pairs(arg23._elements) do
        t_3[val_2.Object] = val_2.Object.ImageTransparency
    end

    if arg23._is_enabled and not arg23._connection then
        arg23._connection = RunService.RenderStepped:Connect(function() -- line: 142
            -- upvalues:
            --  [1] arg23 (copy)

            local v9 = tick() - arg23._start

            for _, val_3 in pairs(arg23._elements) do
                local v10 = val_3.Direction * v9
                local Object_3 = val_3.Object
                local udim2 = UDim2.new(
                    0.5,
                    val_3.Object.TileSize.X.Offset * v10.X * val_3.Speed % val_3.Object.TileSize.X.Offset,
                    0.5,
                    val_3.Object.TileSize.Y.Offset * v10.Y % 1 * val_3.Speed % val_3.Object.TileSize.Y.Offset
                )
                Object_3.Position = udim2
            end
        end)
    elseif not arg23._is_enabled and arg23._connection then
        arg23._connection:Disconnect()
        arg23._connection = nil
    end

    local v13

    if arg24 then
        arg23._fade_in_alpha = 1
        arg23:_UpdateElementsTransparency()
    else
        local task_spawn = task.spawn
        local v11 = RenderstepForLoop_m
        local v12 = (1 - arg23._fade_in_alpha) * 100
        v13 = if not arg23._is_enabled then 1 else 0.5
        task_spawn(
            v11,
            v12,
            100,
            v13,
            function(arg25) -- line: 165
                -- upvalues:
                --  [1] CurrentHash (copy)
                --  [2] arg23 (copy)

                if CurrentHash ~= arg23._current_hash then
                    return true
                end

                arg23._fade_in_alpha = arg25 / 100
                arg23:_UpdateElementsTransparency()
            end
        )
    end

    local TintColor = arg23._colorcorrection.TintColor
    local Contrast = arg23._colorcorrection.Contrast
    local Brightness = arg23._colorcorrection.Brightness
    local Size = arg23._blur.Size
    local v14 = arg23._is_enabled and color_1 or color
    v13 = if not arg23._is_enabled then 0 else -0.3
    local v15 = if not arg23._is_enabled then 0 else 0
    local v16 = if not arg23._is_enabled then 0 else 24

    local function set(arg26) -- line: 186
        -- upvalues:
        --  [1] arg23 (copy)
        --  [2] Size (copy)
        --  [3] v16 (copy)
        --  [4] Brightness (copy)
        --  [5] v13 (copy)
        --  [6] Contrast (copy)
        --  [7] v15 (copy)
        --  [8] TintColor (copy)
        --  [9] v14 (copy)

        local clampedValue = math.clamp(1 - (1 - arg26) ^ 5, 0, 1)
        arg23._blur.Size = if not arg23._blur.Enabled then 0 else Size + (v16 - Size) * clampedValue
        arg23._colorcorrection.Brightness = Brightness + (v13 - Brightness) * clampedValue
        arg23._colorcorrection.Contrast = Contrast + (v15 - Contrast) * clampedValue
        arg23._colorcorrection.TintColor = TintColor:Lerp(v14, clampedValue)
    end

    if arg24 then
        local Blur_1 = arg23._blur
        Blur_1.Size = if arg23._blur.Enabled then Size + (v16 - Size) * 1 else 0
        arg23._colorcorrection.Brightness = Brightness + (v13 - Brightness) * 1
        arg23._colorcorrection.Contrast = Contrast + (v15 - Contrast) * 1
        arg23._colorcorrection.TintColor = TintColor:Lerp(v14, 1)

        return
    end

    task.spawn(
        RenderstepForLoop_m,
        0,
        100,
        2,
        function(arg27) -- line: 198
            -- upvalues:
            --  [1] CurrentHash (copy)
            --  [2] arg23 (copy)
            --  [3] set (copy)

            if CurrentHash ~= arg23._current_hash then
                return true
            end

            set(arg27 / 100)
        end
    )
end

function t_1._Setup(arg28) -- line: 208
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] t (copy)
    --  [3] EventLibrary_m (copy)

    arg28._blur.Size = 0
    arg28._blur.Name = "GlowyBackgroundBlur - " .. arg28._name
    arg28._blur.Parent = Lighting
    arg28._colorcorrection.Name = "GlowyBackgroundColorCorrection - " .. arg28._name
    arg28._colorcorrection.Parent = Lighting
    arg28.Frame.BackgroundTransparency = 1

    for _, val_4 in pairs(t) do
        local v19 = arg28.Frame:WaitForChild(val_4)
        arg28._elements[val_4] = {
            Object = v19,
            OriginalColor = v19.ImageColor3,
            OriginalTransparency = v19.ImageTransparency,
            Direction = nil,
            Speed = nil,
            IsDisabled = false
        }
        v19.ImageTransparency = 1
    end

    local v20 = pairs
    local v21 = EventLibrary_m.IS_ACTIVE and EventLibrary_m.EVENT_DETAILS.GLOWY_BACKGROUND_COLOR_OVERRIDES or {}

    for key_5, val_5 in v20(v21) do
        arg28:SetColor(key_5, val_5)
    end
end

function t_1._Init(arg29) -- line: 238
    arg29:_Setup()
    arg29:_UpdateElementsTransparency()
    arg29:SetEnabled(false, true)
    arg29:SetBackdropTransparency(0)
end

return t_1
