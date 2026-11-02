local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local _ = require(ReplicatedStorage.Modules.Utility)
local StatusTextOverlay = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "StatusTextOverlay"
)
local t = { "Text", "RichText", "FontFace", "TextXAlignment", "TextYAlignment", "TextTransparency" }
local t_1 = { "ImageTransparency", "ScaleType", "Image" }
local gradient = ColorSequence.new(
    {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(253, 255, 114)),
        ColorSequenceKeypoint.new(0.384, Color3.fromRGB(252, 251, 108)),
        ColorSequenceKeypoint.new(0.768, Color3.fromRGB(237, 186, 14)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 177, 2))
    }
)
local gradient_1 = ColorSequence.new(
    {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(154, 114, 255)),
        ColorSequenceKeypoint.new(0.384, Color3.fromRGB(149, 108, 252)),
        ColorSequenceKeypoint.new(0.768, Color3.fromRGB(77, 14, 237)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 2, 235))
    }
)
local color = Color3.fromRGB(64, 64, 64)
local color_1 = Color3.fromRGB(127, 127, 127)
local t_4 = {}
t_4.__index = t_4

function t_4._new() -- line: 29
    -- upvalues:
    --  [1] t_4 (copy)

    local t_5 = setmetatable({}, t_4)
    t_5._connections = {}
    t_5:_Init()

    return t_5
end

function t_4.ApplyItemStatusToText(arg1, arg2, arg3) -- line: 43
    -- upvalues:
    --  [1] gradient (copy)
    --  [2] gradient_1 (copy)

    if arg3 == "Prime" then
        local v9 = arg1:_CreateTextOverlay(arg2, gradient)
        v9.Cover:Destroy()
        v9.Shine:AddTag("UISparkleEffect")
        v9.Shine:AddTag("UIShinyText")

        return
    end

    if arg3 == "Contraband" then
        local v10 = arg1:_CreateTextOverlay(arg2, gradient_1)
        v10.Highlight:AddTag("UIGlitchEffect")
        v10.Shine.TextColor3 = Color3.fromRGB(0, 0, 0)
        v10.Shine:SetAttribute("IsDoubleFlash", true)
        v10.Shine:AddTag("UIShinyText")
    end
end

function t_4.ApplyItemStatusToBackground(arg4, arg5, arg6, arg7) -- line: 58
    arg4:_RecolorBackground(arg5, arg6, arg7)

    if arg7 == "Prime" then
        arg5:AddTag("UISparkleEffect")

        return
    end

    if arg7 == "Contraband" then
        arg5:AddTag("UIGlitchEffect")
    end
end

function t_4.ApplyItemStatusToImage(arg8, arg9, arg10) -- line: 68
    -- upvalues:
    --  [1] gradient (copy)
    --  [2] gradient_1 (copy)

    if arg10 == "Prime" then
        arg8:_CreateImageOverlay(arg9, gradient):AddTag("UISparkleEffect")

        return
    end

    if arg10 == "Contraband" then
        arg8:_CreateImageOverlay(arg9, gradient_1):AddTag("UIGlitchEffect")
    end
end

function t_4.ClearStatusElements(_, arg12) -- line: 78
    for _, child in pairs(arg12:GetChildren()) do
        if child:HasTag("WeaponStatusElement") then
            child:Destroy()
        end
    end
end

function t_4._CreateTextOverlay(arg13, arg14, arg15) -- line: 90
    -- upvalues:
    --  [1] StatusTextOverlay (copy)
    --  [2] t (copy)
    --  [3] color_1 (copy)
    --  [4] color (copy)

    local v12 = StatusTextOverlay:Clone()
    v12.Highlight.UIGradient.Color = arg15
    arg13:_CopyElement(v12.Cover, arg14, t)
    arg13:_CopyElement(v12.Highlight, arg14, t)
    arg13:_CopyElement(v12.Shine, arg14, t)
    arg13:_TagStatusElement(v12)
    v12.Parent = arg14
    local Highlight = v12.Highlight
    local UIStroke = Highlight.UIStroke

    local function update() -- line: 102
        -- upvalues:
        --  [1] UIStroke (copy)
        --  [2] Highlight (copy)
        --  [3] color_1 (ref)
        --  [4] color (ref)

        UIStroke.Transparency = Highlight.TextTransparency
        UIStroke.Color = color_1:Lerp(color, (math.clamp(Highlight.TextTransparency / 0.25, 0, 1)))
    end

    Highlight:GetPropertyChangedSignal("TextTransparency"):Connect(update)
    UIStroke.Transparency = Highlight.TextTransparency
    local v16 = color_1
    local v17 = color
    local clampedValue_1 = math.clamp(Highlight.TextTransparency / 0.25, 0, 1)
    UIStroke.Color = v16:Lerp(v17, clampedValue_1)

    return v12
end

function t_4._CreateImageOverlay(arg16, arg17, arg18) -- line: 113
    -- upvalues:
    --  [1] t_1 (copy)

    local v18 = Instance.fromExisting(arg17)
    v18.Size = UDim2.new(1, 0, 1, 0)
    v18.AnchorPoint = Vector2.new(0.5, 0.5)
    v18.Position = UDim2.new(0.5, 0, 0.5, 0)
    v18.Active = false
    v18.Interactable = false
    v18.Selectable = false
    v18.SizeConstraint = Enum.SizeConstraint.RelativeXY
    v18.ImageColor3 = Color3.fromRGB(255, 255, 255)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Rotation = 90
    UIGradient.Color = arg18
    UIGradient.Parent = v18
    arg16:_CopyElement(v18, arg17, t_1)
    arg16:_TagStatusElement(v18)
    v18.Parent = arg17

    return v18
end

function t_4._RecolorBackground(_, arg20, arg21, arg22) -- line: 137
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    local v19 = ItemLibrary_m.Statuses[arg22]

    if not v19 then
        return
    end

    if arg20:IsA("ImageLabel") then
        arg20.ImageColor3 = v19.Color
    end

    arg20.BackgroundColor3 = v19.Color
    arg21.Color = v19.Color
end

function t_4._TagStatusElement(_, arg24) -- line: 152
    arg24:AddTag("WeaponStatusElement")
    arg24.Name = "_ITEMSTATUSCLONE"
end

function t_4._CopyElement(arg25, arg26, arg27, arg28) -- line: 157
    if not arg25._connections[arg26] then
        arg25._connections[arg26] = {}
        table.insert(arg25._connections[arg26], arg26.Destroying:Connect(function() -- line: 161
            -- upvalues:
            --  [1] arg25 (copy)
            --  [2] arg26 (copy)

            local v20 = pairs
            local v21 = arg25._connections[arg26] or {}

            for _, val in v20(v21) do
                val:Disconnect()
            end

            arg25._connections[arg26] = nil
        end))
    end

    local _ = arg26.Destroying:Connect(function() -- line: 161
        -- upvalues:
        --  [1] arg25 (copy)
        --  [2] arg26 (copy)

        local v20 = pairs
        local v21 = arg25._connections[arg26] or {}

        for _, val in v20(v21) do
            val:Disconnect()
        end

        arg25._connections[arg26] = nil
    end)

    for _, val_1 in pairs(arg28) do
        local function update_1() --[[ update ]] -- line: 171
            -- upvalues:
            --  [1] arg26 (copy)
            --  [2] val_1 (copy)
            --  [3] arg27 (copy)

            arg26[val_1] = arg27[val_1]
        end

        table.insert(
            arg25._connections[arg26],
            arg27:GetPropertyChangedSignal(val_1):Connect(update_1)
        )
        arg26[val_1] = arg27[val_1]
    end
end

function t_4._ObjectAdded(arg29, arg30) -- line: 180
    -- upvalues:
    --  [1] ItemLibrary_m (copy)

    local Status = arg30:GetAttribute("Status")
    assert(if ItemLibrary_m.Statuses[Status] == nil then false else true, arg30:GetFullName())
    arg29:ClearStatusElements(arg30)

    if arg30:IsA("TextLabel") then
        arg29:ApplyItemStatusToText(arg30, Status)

        return
    end

    assert(false, arg30:GetFullName())
end

function t_4._Init(arg31) -- line: 194
    -- upvalues:
    --  [1] CollectionService (copy)

    CollectionService:GetInstanceAddedSignal("ApplyWeaponStatus"):Connect(function(arg32) -- line: 195
        -- upvalues:
        --  [1] arg31 (copy)

        arg31:_ObjectAdded(arg32)
    end)

    for _, val_2 in pairs(CollectionService:GetTagged("ApplyWeaponStatus")) do
        task.defer(arg31._ObjectAdded, arg31, val_2)
    end
end

return t_4._new()
