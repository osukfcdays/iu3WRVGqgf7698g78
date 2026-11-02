local EventLibrary_m = require(game:GetService("ReplicatedStorage").Modules.EventLibrary)
local t = { Info = {}, Order = {} }

local function add_currency(
    arg1,
    arg2,
    arg3,
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11,
    arg12,
    arg13
) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = {
        IsHidden = arg1,
        OrderIndex = #t.Order + 1,
        DataName = arg2,
        CanBePurchasedWithRobux = arg3,
        OnlyDisplayAboveZeroBalance = arg4,
        OnlyDisplayBuyButtonAboveZeroBalance = arg5,
        NeedsAreYouSurePrompt = arg6,
        DisplayName = arg7,
        DisplayNamePlural = arg8,
        Image = arg9,
        ImageFlat = arg10,
        ImageFlatOutline = arg11,
        Color = arg12 or Color3.fromRGB(255, 255, 255),
        ColorGradient = arg13 or ColorSequence.new(Color3.fromRGB(255, 255, 255))
    }
    t.Info[arg2] = t_1
    table.insert(t.Order, arg2)
end

add_currency(
    false,
    "WeaponKeys",
    true,
    false,
    false,
    false,
    "Key",
    "Keys",
    "rbxassetid://17860673529",
    "rbxassetid://17495953455",
    "rbxassetid://17495953350",
    Color3.fromRGB(255, 255, 255),
    ColorSequence.new(
        {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.464, Color3.fromRGB(251, 243, 4)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 192, 21))
        }
    )
)
add_currency(
    false,
    "UnlockTokens",
    false,
    true,
    false,
    false,
    "Unlock Token",
    "Unlock Tokens",
    "rbxassetid://140345278696055",
    "rbxassetid://17495953455",
    "rbxassetid://17495953350",
    Color3.fromRGB(255, 255, 255)
)
add_currency(
    false,
    "EventCurrency",
    true,
    false,
    false,
    false,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_NAME_PLURAL,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_IMAGE,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_IMAGE_FLAT,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_IMAGE_FLAT_OUTLINE,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_COLOR,
    EventLibrary_m.EVENT_DETAILS.CURRENCY_COLOR_GRADIENT
)
add_currency(
    false,
    "Glory",
    false,
    false,
    false,
    false,
    "Glory",
    "Glory",
    "rbxassetid://91728915485540",
    "rbxassetid://99547957275402",
    "rbxassetid://126219583943163",
    Color3.fromRGB(204, 92, 255)
)
add_currency(
    false,
    "SkinTickets",
    false,
    true,
    true,
    true,
    "Skin Ticket",
    "Skin Tickets",
    "rbxassetid://89210639622638",
    "rbxassetid://77049671345769",
    "rbxassetid://76853894340797",
    Color3.fromRGB(255, 255, 255),
    ColorSequence.new(
        {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.464, Color3.fromRGB(251, 243, 4)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 192, 21))
        }
    )
)

return t
