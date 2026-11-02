local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local GamepadService = game:GetService("GamepadService")
local Players = game:GetService("Players")
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
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
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 19
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] EmoteWheel_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.EmoteWheelSlotsFrame = t_1.PageFrame:WaitForChild("EmoteWheelSlots")
    t_1.EmoteWheelSlotsButton = t_1.EmoteWheelSlotsFrame:WaitForChild("AllEmotes")
    t_1.EmoteWheelSlotsButtonMouseKeyboardKeybindFrame = t_1.EmoteWheelSlotsButton:WaitForChild(
        "Inputs"
    ):WaitForChild("MouseKeyboard"):WaitForChild("Keybind")
    t_1.EmoteWheelSlotsButtonGamepadKeybindFrame = t_1.EmoteWheelSlotsButton:WaitForChild("Inputs"):WaitForChild(
        "Gamepad"
    ):WaitForChild("Keybind")
    t_1.AllEmotesFrame = t_1.PageFrame:WaitForChild("AllEmotes")
    t_1.AllEmotesList = t_1.AllEmotesFrame:WaitForChild("List")
    t_1.AllEmotesContainer = t_1.AllEmotesList:WaitForChild("Container")
    t_1.AllEmotesLayout = t_1.AllEmotesContainer:WaitForChild("Layout")
    t_1.AllEmotesCentererFrame = t_1.AllEmotesContainer:WaitForChild("Centerer")
    t_1.AllEmotesHeaderFrame = t_1.AllEmotesContainer:WaitForChild("Header")
    t_1.AllEmotesHeaderIcon = t_1.AllEmotesHeaderFrame:WaitForChild("Icon")
    t_1.AllEmotesHeaderCloseButton = t_1.AllEmotesHeaderFrame:WaitForChild("Close")
    t_1.AllEmotesSlotsFrame = t_1.AllEmotesContainer:WaitForChild("Slots")
    t_1.AllEmotesSlotsContainer = t_1.AllEmotesSlotsFrame:WaitForChild("Container")
    t_1.AllEmotesSlotsLayout = t_1.AllEmotesSlotsContainer:WaitForChild("Layout")
    t_1.HidePartyDisplay = true
    t_1.EmoteWheel = EmoteWheel_m.new()
    t_1._all_emotes_open = false
    t_1._cosmetic_slots = {}
    t_1:_Init()

    return t_1
end

function t.GetDefaultElement(_) -- line: 53
    return nil
end

function t.SetAllEmotesOpen(arg2, arg3) -- line: 57
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] GamepadService (copy)

    arg2._all_emotes_open = arg2._is_open and arg3
    arg2.AllEmotesFrame.Visible = arg2._all_emotes_open
    arg2.EmoteWheelSlotsFrame.Visible = not arg2._all_emotes_open
    arg2:_VerifyEmoteWheel()
    arg2:_VerifyAllEmotes()

    if arg2._all_emotes_open and ControlsController_m.CurrentControls == "Gamepad" then
        GamepadService:EnableGamepadCursor(arg2.AllEmotesSlotsFrame)
    end
end

function t.PickEarly(arg4) -- line: 70
    -- upvalues:
    --  [1] ControlsController_m (copy)

    if arg4._all_emotes_open then
        if ControlsController_m.CurrentControls == "MouseKeyboard" then
            arg4:_PickHoveredCosmeticSlot()

            return
        end
    else
        arg4.EmoteWheel:FinishInputs()
    end
end

function t.Open(arg5, ...) -- line: 82
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] UserInputService (copy)
    --  [3] ControlsController_m (copy)

    Page_m.Open(arg5, ...)
    arg5.EmoteWheelSlotsButtonMouseKeyboardKeybindFrame:AddTag("UIKeybindContainer")
    arg5.EmoteWheelSlotsButtonGamepadKeybindFrame:AddTag("UIKeybindContainer")
    arg5:SetAllEmotesOpen(false)
    local v10 = 0
    table.insert(arg5._open_connections, UserInputService.InputChanged:Connect(function(arg6, _) -- line: 91
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] ControlsController_m (ref)
        --  [3] v10 (ref)

        if arg5._all_emotes_open or ControlsController_m.CurrentControls ~= "MouseKeyboard" then
            return
        end

        v10 += arg6.Position.Z

        if math.abs(v10) >= 1 then
            arg5:SetAllEmotesOpen(true)
        end
    end))
end

function t._UpdateCenterer(_) -- line: 108
end

function t._Update(arg9) -- line: 122
    arg9.AllEmotesList.CanvasSize = UDim2.new(0, 0, 0, arg9.AllEmotesLayout.AbsoluteContentSize.Y)
    arg9.AllEmotesSlotsFrame.Size = UDim2.new(
        1,
        0,
        0,
        arg9.AllEmotesSlotsLayout.AbsoluteContentSize.Y
    )
end

function t._PickByKey(arg10, arg11) -- line: 127
    -- upvalues:
    --  [1] EmoteController_m (copy)

    if not arg10._is_open then
        return
    end

    EmoteController_m:UseEmote(arg11)
    arg10:CloseRequest()
end

function t._PickByName(arg12, arg13) -- line: 136
    -- upvalues:
    --  [1] EmoteController_m (copy)

    if not arg12._is_open then
        return
    end

    EmoteController_m:UseEmoteByName(arg13)
    arg12:CloseRequest()
end

function t._PickHoveredCosmeticSlot(arg14) -- line: 145
    -- upvalues:
    --  [1] UILibrary_m (copy)

    for _, val in pairs(arg14._cosmetic_slots) do
        if UILibrary_m:IsMouseWithinBounds(val.Frame.AbsolutePosition, val.Frame.AbsoluteSize) then
            arg14:_PickByName(val.Name)

            return
        end
    end
end

function t._VerifyAllEmotes(arg15) -- line: 154
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)
    --  [2] PlayerDataController_m (copy)
    --  [3] CosmeticSlot_m (copy)

    for _, val_1 in pairs(arg15._cosmetic_slots) do
        val_1:Destroy()
    end

    arg15._cosmetic_slots = {}
    local v11 = arg15._is_open

    if v11 then
        v11 = arg15._all_emotes_open
    end

    if not v11 then
        return
    end

    v11 = {}

    for key_2, val_2 in pairs(CosmeticLibrary_m.CosmeticsAlphabetized) do
        table.insert(v11, { Name = val_2, AlphabeticalValue = key_2 })
    end

    table.sort(v11, function(arg16, arg17) -- line: 176
        -- upvalues:
        --  [1] CosmeticLibrary_m (ref)

        local Value = CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg16.Name].Rarity].Value
        local Value_1 = CosmeticLibrary_m.Rarities[CosmeticLibrary_m.Cosmetics[arg17.Name].Rarity].Value

        return if Value == Value_1 then arg16.AlphabeticalValue < arg17.AlphabeticalValue else Value > Value_1
    end)

    for key_3, val_3 in pairs(v11) do
        local Name = val_3.Name
        local v13 = CosmeticLibrary_m

        if
            CosmeticLibrary_m.Cosmetics[Name].Type == "Emote"
            and v13:OwnsCosmetic(PlayerDataController_m:Get("CosmeticInventory"), Name)
        then
            local v15 = CosmeticSlot_m.new(Name)
            v15.Frame.LayoutOrder = key_3
            v15.Frame.Parent = arg15.AllEmotesSlotsContainer
            table.insert(arg15._cosmetic_slots, v15)
            v15.Frame.Button.MouseButton1Click:Connect(function() -- line: 200
                -- upvalues:
                --  [1] arg15 (copy)
                --  [2] Name (copy)

                arg15:_PickByName(Name)
            end)
        end
    end
end

function t._VerifyEmoteWheel(arg18) -- line: 206
    local v16 = arg18._is_open

    if v16 then
        v16 = not arg18._all_emotes_open
    end

    arg18.EmoteWheel:SetEnabled(v16)

    if v16 then
        arg18.EmoteWheel:StartInputs()

        return
    end

    arg18.EmoteWheel:StopInputs()
end

function t._Setup(arg19) -- line: 218
    -- upvalues:
    --  [1] CosmeticLibrary_m (copy)

    arg19.AllEmotesHeaderIcon.Image = CosmeticLibrary_m.Types.Emote.Image
    arg19.EmoteWheel.Frame.Parent = arg19.EmoteWheelSlotsFrame
end

function t._Init(arg20) -- line: 223
    -- upvalues:
    --  [1] EmoteController_m (copy)
    --  [2] ButtonEffect_m (copy)

    arg20.AllEmotesHeaderCloseButton.MouseButton1Click:Connect(function() -- line: 224
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:CloseRequest()
    end)
    arg20.EmoteWheelSlotsButton.MouseButton1Click:Connect(function() -- line: 228
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:SetAllEmotesOpen(true)
    end)
    arg20.AllEmotesList:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 232
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_Update()
    end)
    arg20.AllEmotesSlotsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 236
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_Update()
    end)
    arg20.AllEmotesLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 240
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_Update()
    end)
    arg20.AllEmotesList:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 244
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateCenterer()
    end)
    arg20.AllEmotesList:GetPropertyChangedSignal("CanvasSize"):Connect(function() -- line: 248
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_UpdateCenterer()
    end)
    arg20.OpenChanged:Connect(function() -- line: 252
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_VerifyEmoteWheel()
    end)
    arg20.EmoteWheel.EmoteKeyPicked:Connect(function(arg21) -- line: 256
        -- upvalues:
        --  [1] arg20 (copy)

        arg20:_PickByKey(arg21)
    end)
    EmoteController_m.CanEmoteChanged:Connect(function() -- line: 260
        -- upvalues:
        --  [1] EmoteController_m (ref)
        --  [2] arg20 (copy)

        if not EmoteController_m:CanEmote(true) then
            arg20:CloseRequest()
        end
    end)
    arg20:_Setup()
    arg20:_Update()
    ButtonEffect_m:Add(arg20.EmoteWheelSlotsButton)
    ButtonEffect_m:Add(arg20.AllEmotesHeaderCloseButton)
end

return t._new()
