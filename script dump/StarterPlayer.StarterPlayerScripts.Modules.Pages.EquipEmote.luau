local Players = game:GetService("Players")
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local EmoteController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("EmoteController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local CosmeticSlot_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("CosmeticSlot")
)
local EmoteWheel_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("EmoteWheel"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 15
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] EmoteWheel_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.EmoteWheelSlotsFrame = t_1.PageFrame:WaitForChild("EmoteWheelSlots")
    t_1.EmoteSlotContainer = t_1.PageFrame:WaitForChild("EmoteSlotContainer")
    t_1.HidePartyDisplay = true
    t_1.EmoteWheel = EmoteWheel_m.new()
    t_1._emote_name = nil
    t_1._emote_slot = nil
    t_1._just_picked = nil
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(_) -- line: 38
    return nil
end

function t.SetEmoteName(arg2, arg3) -- line: 42
    -- upvalues:
    --  [1] CosmeticSlot_m (copy)

    if arg2._emote_slot then
        arg2._emote_slot:Destroy()
        arg2._emote_slot = nil
    end

    arg2._emote_name = arg3

    if arg2._emote_name then
        arg2._emote_slot = CosmeticSlot_m.new(arg2._emote_name)
        arg2._emote_slot:SetInteractable(false)
        arg2._emote_slot.Frame.Parent = arg2.EmoteSlotContainer
        arg2:_UpdateEmoteSlotPosition()
    end
end

function t.PickEmoteKey(arg4, arg5) -- line: 58
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] EmoteController_m (copy)

    if not arg4._is_open or arg4._just_picked then
        return
    end

    if not arg5 or not arg4._emote_name then
        arg4:CloseRequest()

        return
    end

    local v8 = PlayerDataController_m:Get("EquippedEmotes")[arg5]
    EmoteController_m:EquipEmote(
        arg5,
        if v8 and v8.Name == arg4._emote_name then nil else arg4._emote_name
    )
end

function t.Open(arg6, ...) -- line: 95
    -- upvalues:
    --  [1] Page_m (copy)

    Page_m.Open(arg6, ...)
    arg6.EmoteWheel:SetEnabled(true)
    arg6.EmoteWheel:StartInputs(true)
    arg6._just_picked = nil
end

function t.Close(arg7, ...) -- line: 102
    -- upvalues:
    --  [1] Page_m (copy)

    arg7._just_picked = nil
    arg7.EmoteWheel:StopInputs()
    arg7.EmoteWheel:SetEnabled(false)
    Page_m.Close(arg7, ...)
end

function t._UpdateEmoteSlotPosition(arg8) -- line: 113
    if not arg8._emote_slot then
        return
    end

    local v11 = arg8.EmoteWheel:GetLastHighlightedSlot()
    local v12 = if not v11 then Vector2.zero else (v11:GetContainerPosition() - (arg8.EmoteSlotContainer.AbsolutePosition + arg8.EmoteSlotContainer.AbsoluteSize / 2)).Unit
    arg8._emote_slot.Frame:TweenPosition(
        UDim2.new(0.5 + v12.X, 0, 0.5 + v12.Y, 0),
        "Out",
        "Quint",
        0.25,
        true
    )
end

function t._Setup(arg9) -- line: 125
    arg9.EmoteWheel.Frame.Parent = arg9.EmoteWheelSlotsFrame
end

function t._Init(arg10) -- line: 129
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg10.CloseButton.MouseButton1Click:Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:CloseRequest()
    end)
    arg10.EmoteWheel.EmoteKeyPicked:Connect(function(arg11) -- line: 134
        -- upvalues:
        --  [1] ButtonEffect_m (ref)
        --  [2] arg10 (copy)

        ButtonEffect_m:ClickSound()
        arg10:PickEmoteKey(arg11)
    end)
    arg10.EmoteWheel.EmoteWheelSlotHighlighted:Connect(function(_) -- line: 139
        -- upvalues:
        --  [1] arg10 (copy)

        arg10:_UpdateEmoteSlotPosition()
    end)
    arg10:_Setup()
    arg10:_UpdateEmoteSlotPosition()
    ButtonEffect_m:Add(arg10.CloseButton)
end

return t._new()
