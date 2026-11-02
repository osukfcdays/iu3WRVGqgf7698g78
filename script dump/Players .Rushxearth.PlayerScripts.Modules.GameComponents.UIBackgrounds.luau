local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local UILibrary_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.UILibrary)
local t = {}
t.__index = t

function t._new() -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t._UpdateCoreGuiBackground(_, arg2) -- line: 28
    -- upvalues:
    --  [1] UILibrary_m (copy)

    if arg2:IsA("Frame") then
        arg2.BackgroundColor3 = UILibrary_m.BUTTON_BACKGROUND_COLOR
        arg2.BackgroundTransparency = UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY

        return
    end

    if arg2:IsA("ImageLabel") then
        arg2.ImageColor3 = UILibrary_m.BUTTON_BACKGROUND_COLOR
        arg2.ImageTransparency = UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY

        return
    end

    if arg2:IsA("UIStroke") then
        arg2.Color = UILibrary_m.BUTTON_BACKGROUND_COLOR
        arg2.Transparency = UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY
    end
end

function t._UpdateElementSimple(_, arg4) -- line: 41
    -- upvalues:
    --  [1] GuiService (copy)

    local PreferredTransparency = GuiService.PreferredTransparency
    local v1 = arg4:GetAttribute("BaseTransparency") or 1
    arg4[if arg4:IsA("Frame") then "BackgroundTransparency" else "ImageTransparency"] = 0 + (v1 - 0) * PreferredTransparency
    local TransparentColor = arg4:GetAttribute("TransparentColor")
    local OpaqueColor = arg4:GetAttribute("OpaqueColor")

    if TransparentColor and OpaqueColor then
        arg4[if arg4:IsA("Frame") then "BackgroundColor3" else "ImageColor3"] = OpaqueColor:Lerp(
            TransparentColor,
            PreferredTransparency
        )
    end
end

function t._UpdateElement(_, arg6) -- line: 55
    -- upvalues:
    --  [1] GuiService (copy)

    local UIGradient = arg6:WaitForChild("UIGradient")
    local PreferredTransparency_1 = GuiService.PreferredTransparency
    arg6.ImageTransparency = 0 + 0.25 * PreferredTransparency_1
    arg6.ImageColor3 = Color3.fromRGB(31, 31, 31):Lerp(
        Color3.fromRGB(0, 0, 0),
        PreferredTransparency_1
    )
    UIGradient.Transparency = NumberSequence.new(0, 0 + 0.5 * PreferredTransparency_1)
    local New = ColorSequence.new
    local color_2 = Color3.fromRGB(127, 127, 127):Lerp(
        Color3.fromRGB(255, 255, 255),
        PreferredTransparency_1
    )
    UIGradient.Color = New(color_2, Color3.fromRGB(255, 255, 255))
end

function t._UpdateAllElements(arg7) -- line: 65
    -- upvalues:
    --  [1] CollectionService (copy)

    for _, val in pairs(CollectionService:GetTagged("UIBackground")) do
        arg7:_UpdateElement(val)
    end

    for _, val_1 in pairs(CollectionService:GetTagged("UIBackgroundSimple")) do
        arg7:_UpdateElementSimple(val_1)
    end
end

function t._Init(arg8) -- line: 75
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] GuiService (copy)

    CollectionService:GetInstanceAddedSignal("UIBackground"):Connect(function(arg9) -- line: 76
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateElement(arg9)
    end)
    CollectionService:GetInstanceAddedSignal("UIBackgroundSimple"):Connect(function(arg10) -- line: 80
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateElementSimple(arg10)
    end)
    CollectionService:GetInstanceAddedSignal("CoreGuiBackground"):Connect(function(arg11) -- line: 84
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateCoreGuiBackground(arg11)
    end)
    GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function() -- line: 88
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateAllElements()
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("CoreGuiBackground")) do
        arg8:_UpdateCoreGuiBackground(val_2)
    end

    task.defer(arg8._UpdateAllElements, arg8)
end

return t._new()
