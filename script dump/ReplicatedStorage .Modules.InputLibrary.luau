local v1 = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local _ = game:GetService("HttpService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local Utility_m = require(v1.Modules.Utility)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
end

local v2 = CONSTANTS_m.IS_CLIENT and require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local t = { "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero" }
local t_1 = {}
local t_3 = {
    MouseWheel = "MouseWheel",
    MouseButton1 = "MB1",
    MouseButton2 = "MB2",
    MouseButton3 = "MB3",
    LeftControl = "LCtrl",
    RightControl = "RCtrl",
    LeftShift = "LShift",
    RightShift = "RShift",
    Zero = "0",
    Tab = "Tab",
    LeftAlt = "LAlt",
    RAlt = "RAlt",
    Space = "Space",
    Up = "\226\172\134",
    Down = "\226\172\135",
    Left = "\226\172\133",
    Right = "\226\158\161"
}
t_1.MouseKeyboard = { "Hotkey MouseKeyboard%s1", "Hotkey MouseKeyboard%s2" }
t_1.Gamepad = { "Hotkey Gamepad%s1", "Hotkey Gamepad%s2" }
local t_5 = {
    Short = {
        Base = "rbxassetid://16491694294",
        Pressed = "rbxassetid://16491693602",
        DisplayString = nil
    },
    Long = {
        Base = "rbxassetid://16491693870",
        Pressed = "rbxassetid://16491693385",
        DisplayString = nil
    },
    MB1 = {
        Base = "rbxassetid://13194849055",
        Pressed = "rbxassetid://13194848851",
        DisplayString = ""
    },
    MB2 = {
        Base = "rbxassetid://13194848725",
        Pressed = "rbxassetid://13194848539",
        DisplayString = ""
    },
    MB3 = {
        Base = "rbxassetid://115443077181302",
        Pressed = "rbxassetid://121057755614364",
        DisplayString = ""
    }
}
local t_6 = {
    HOTKEY_FORMATS = t_1,
    Inputs = {},
    ItemInputs = {},
    ItemInputTypeToName = {},
    MobileButtons = {},
    MobileInputNameToItemIndex = {}
}

function t_6.GetInputName(arg1, arg2) -- line: 42
    -- upvalues:
    --  [1] t_6 (copy)

    for key, _ in pairs(t_6.Inputs) do
        if arg1:InputIs(key, arg2) then
            return key
        end
    end
end

function t_6.GetInputs(_, arg4, arg5) -- line: 52
    -- upvalues:
    --  [1] t_6 (copy)
    --  [2] t_1 (copy)
    --  [3] v2 (copy)
    --  [4] Utility_m (copy)
    --  [5] v1 (copy)

    local v3 = t_6.Inputs[arg4]

    if not v3 then
        return
    end

    local v7

    if v3.IsHotkey then
        local t_7 = {}
        local v4 = pairs
        v7 = t_1[arg5 or v2.CurrentControls] or {}

        for _, val_1 in v4(v7) do
            local formattedText = string.format(val_1, arg4)
            table.insert(t_7, Utility_m:GetInputEnumFromName(v1:GetSetting(formattedText)))
        end

        return t_7
    end

    local InputEnums = v3.InputEnums
    v7 = arg5 or v2.CurrentControls

    return InputEnums[v7]
end

function t_6.GetInputIcons(arg6, arg7, arg8) -- line: 75
    -- upvalues:
    --  [1] UserInputService (copy)
    --  [2] t_5 (copy)

    local v9, Result = pcall(function() -- line: 76
        -- upvalues:
        --  [1] UserInputService (ref)
        --  [2] arg7 (copy)
        --  [3] arg8 (copy)

        return UserInputService:GetImageForKeyCode(Enum[arg7][arg8])
    end)

    if v9 and Result ~= "" then
        return Result, Result, ""
    end

    local v10 = arg6:GetInputString(arg7, arg8)
    v9 = t_5[v10]

    if not v9 then
        v9 = t_5[if utf8.len(v10) ~= 1 then "Long" else "Short"]
    end

    return v9.Base, v9.Pressed, v9.DisplayString or v10
end

function t_6.GetInputString(_, arg10, arg11) -- line: 91
    -- upvalues:
    --  [1] t_3 (copy)
    --  [2] t (copy)
    --  [3] UserInputService (copy)

    local v13 = t_3[arg11]

    if v13 then
        return v13
    end

    local index = table.find(t, arg11)

    if index then
        return (tostring(index))
    end

    local Success, Result_1 = pcall(
        UserInputService.GetStringForKeyCode,
        UserInputService,
        Enum[arg10][arg11]
    )

    if not Success or utf8.len(Result_1) == 0 then
        return arg11
    end

    if #Result_1 > 6 and string.sub(Result_1, 1, 6) == "Button" then
        return (string.sub(Result_1, 7))
    end

    if #Result_1 > 4 and string.sub(Result_1, 1, 4) == "DPad" then
        return (string.sub(Result_1, 5))
    end

    return Result_1
end

function t_6.GetInputIconsByInputName(arg12, arg13, arg14) -- line: 116
    -- upvalues:
    --  [1] t_5 (copy)

    local v14 = arg12:FindFirstEnum(arg13, arg14)

    if not v14 then
        return t_5.Short.Base, t_5.Short.Pressed, ""
    end

    return arg12:GetInputIcons(tostring(v14.EnumType), v14.Name)
end

function t_6.FindFirstEnum(arg15, arg16, arg17) -- line: 127
    local v15 = arg15:GetInputs(arg16, arg17)
    local v16 = v15

    if v16 then
        v16 = v15[1]
    end

    return v16
end

function t_6.InputIs(arg18, arg19, arg20) -- line: 134
    -- upvalues:
    --  [1] t_6 (copy)

    local v17 = t_6.Inputs[arg20]
    local v18 = arg18:GetInputs(arg20)

    return if arg19 ~= arg20 then v17 and v17.MobileInputName == arg19 or v18 and (table.find(
        v18,
        arg19.KeyCode
    ) or table.find(v18, arg19.UserInputType)) else true
end

function t_6.IsInputDown(arg21, arg22, arg23) -- line: 142
    -- upvalues:
    --  [1] v2 (copy)

    if v2:IsInputDown(arg22) then
        return true
    end

    local v20 = pairs
    local v21 = arg21:GetInputs(arg22) or {}

    for _, val_2 in v20(v21) do
        if if not arg23 then v2:IsInputDown(val_2) else not table.find(arg23, val_2) and v2:IsInputDown(
            val_2
        ) then
            return true
        end
    end
end

local function add_input(
    arg24,
    arg25,
    arg26,
    arg27,
    arg28,
    arg29,
    arg30,
    arg31
) -- line: 158
    -- upvalues:
    --  [1] t_6 (copy)

    local t_8 = {
        IsItemInput = arg24 or false,
        IsHotkey = arg25 or false,
        InputName = arg26,
        StartName = "Start" .. arg26 .. "ing",
        FinishName = "Finish" .. arg26 .. "ing",
        MobileInputName = nil,
        DisplayName = arg27,
        Image = arg28,
        InputEnums = nil
    }
    local t_9 = { MouseKeyboard = arg29 or {}, Gamepad = arg30 or {}, Touch = {}, VR = arg31 or {} }
    t_8.InputEnums = t_9
    t_6.Inputs[arg26] = t_8

    if arg24 then
        table.insert(t_6.ItemInputs, arg26)
        t_6.ItemInputTypeToName[t_8.StartName] = arg26
        t_6.ItemInputTypeToName[t_8.FinishName] = arg26
    end
end

add_input(
    true,
    true,
    "Inspect",
    "Inspect",
    "rbxassetid://17513805400",
    { Enum.KeyCode.V },
    { Enum.KeyCode.DPadDown },
    nil
)
add_input(
    true,
    true,
    "Shoot",
    "Attack",
    "rbxassetid://17513805027",
    { Enum.UserInputType.MouseButton1 },
    { Enum.KeyCode.ButtonR2 },
    { Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2 }
)
add_input(
    true,
    true,
    "Aim",
    "Ability",
    "rbxassetid://17513805525",
    { Enum.UserInputType.MouseButton2, Enum.KeyCode.E },
    { Enum.KeyCode.ButtonL2 },
    { Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL1 }
)
add_input(
    true,
    true,
    "Reload",
    "Reload",
    "rbxassetid://17513813485",
    { Enum.KeyCode.R },
    { Enum.KeyCode.ButtonX },
    { Enum.KeyCode.ButtonY }
)
add_input(
    true,
    true,
    "Sprint",
    "Sprint",
    "rbxassetid://17513821002",
    { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift },
    { Enum.KeyCode.ButtonL3 },
    { Enum.KeyCode.ButtonL3 }
)
add_input(
    nil,
    true,
    "Crouch",
    "Crouch",
    "rbxassetid://17513805623",
    { Enum.KeyCode.LeftControl, Enum.KeyCode.C },
    { Enum.KeyCode.ButtonB },
    { Enum.KeyCode.ButtonB }
)
add_input(
    nil,
    true,
    "Slide",
    "Slide",
    "rbxassetid://17524267716",
    nil,
    nil,
    nil
)
add_input(
    nil,
    true,
    "SwitchCameraPOV",
    "Camera",
    "rbxassetid://17548980857",
    { Enum.KeyCode.B },
    { Enum.KeyCode.DPadUp },
    nil
)
add_input(
    nil,
    true,
    "EquipPrimary",
    "Equip Primary",
    "rbxassetid://17539215512",
    { Enum.KeyCode.One },
    nil,
    nil
)
add_input(
    nil,
    true,
    "EquipSecondary",
    "Equip Secondary",
    "rbxassetid://17539215639",
    { Enum.KeyCode.Two },
    nil,
    nil
)
add_input(
    nil,
    true,
    "EquipMelee",
    "Equip Melee",
    "rbxassetid://17539235478",
    { Enum.KeyCode.Three },
    nil,
    nil
)
add_input(
    nil,
    true,
    "EquipUtility",
    "Equip Utility",
    "rbxassetid://17539235638",
    { Enum.KeyCode.Four },
    nil,
    nil
)
add_input(
    nil,
    true,
    "EquipLast",
    "Equip Previous Weapon",
    "rbxassetid://17513804864",
    nil,
    { Enum.KeyCode.ButtonL1 },
    nil
)
add_input(
    nil,
    true,
    "EquipNext",
    "Equip Next Weapon",
    "rbxassetid://17513804705",
    nil,
    { Enum.KeyCode.ButtonR1 },
    { Enum.KeyCode.ButtonX }
)
add_input(
    nil,
    true,
    "Jump",
    "Jump",
    "rbxassetid://17513836637",
    { Enum.KeyCode.Space },
    { Enum.KeyCode.ButtonA },
    { Enum.KeyCode.ButtonA }
)
add_input(
    nil,
    true,
    "QuickMelee",
    "Quick Melee",
    "rbxassetid://17506296977",
    { Enum.KeyCode.F },
    { Enum.KeyCode.ButtonR3 },
    nil
)
add_input(
    nil,
    true,
    "QuickUtility",
    "Quick Utility",
    "rbxassetid://17513805716",
    { Enum.KeyCode.G },
    { Enum.KeyCode.ButtonY },
    nil
)
add_input(
    nil,
    true,
    "Ping",
    "Signal",
    "rbxassetid://17269776216",
    { Enum.UserInputType.MouseButton3 },
    nil,
    nil
)
add_input(
    nil,
    true,
    "OpenPlayerList",
    "Open Scoreboard",
    "rbxassetid://17513827700",
    { Enum.KeyCode.Tab, Enum.KeyCode.LeftAlt },
    { Enum.KeyCode.DPadLeft },
    nil
)
add_input(
    nil,
    true,
    "SpectateLast",
    "Spectate Previous Player",
    "rbxassetid://77908042044589",
    { Enum.UserInputType.MouseButton1 },
    nil,
    nil
)
add_input(
    nil,
    true,
    "SpectateNext",
    "Spectate Next Player",
    "rbxassetid://77908042044589",
    { Enum.UserInputType.MouseButton2 },
    { Enum.KeyCode.DPadRight },
    nil
)
add_input(
    nil,
    true,
    "SpectateExit",
    "Stop Spectating",
    "rbxassetid://77908042044589",
    { Enum.KeyCode.M },
    { Enum.KeyCode.DPadDown },
    nil
)
add_input(
    nil,
    true,
    "SwitchItems",
    "Switch Weapons",
    "rbxassetid://13667080363",
    { Enum.KeyCode.M },
    { Enum.KeyCode.DPadDown },
    nil
)
add_input(
    nil,
    true,
    "LeaveDuel",
    "Leave Duel",
    "rbxassetid://17498605048",
    { Enum.KeyCode.M },
    { Enum.KeyCode.DPadDown },
    nil
)
add_input(
    nil,
    true,
    "UseEmote",
    "Emote",
    "rbxassetid://82983645557125",
    { Enum.KeyCode.T },
    { Enum.KeyCode.DPadRight },
    nil
)
add_input(
    nil,
    true,
    "HideHUD",
    "Hide HUD",
    "rbxassetid://126633805196326",
    nil,
    nil,
    nil
)
add_input(
    nil,
    true,
    "WalkForward",
    "Walk Forward",
    "rbxassetid://102807333252186",
    { Enum.KeyCode.W, Enum.KeyCode.Up },
    nil,
    nil
)
add_input(
    nil,
    true,
    "WalkBackward",
    "Walk Backward",
    "rbxassetid://92032489827936",
    { Enum.KeyCode.S, Enum.KeyCode.Down },
    nil,
    nil
)
add_input(
    nil,
    true,
    "WalkLeftward",
    "Strafe Left",
    "rbxassetid://107466029361522",
    { Enum.KeyCode.A },
    nil,
    nil
)
add_input(
    nil,
    true,
    "WalkRightward",
    "Strafe Right",
    "rbxassetid://118121732524898",
    { Enum.KeyCode.D },
    nil,
    nil
)

for index_1 = 1, CONSTANTS_m.MAX_EQUIPPABLE_EMOTES do
    add_input(
        nil,
        true,
        "UseEmote" .. index_1,
        "Quick Emote " .. index_1,
        "rbxassetid://82983645557125",
        nil,
        nil,
        nil
    )
end

add_input(
    nil,
    nil,
    "LeanLeft",
    "Lean Left",
    "rbxassetid://17513844569",
    nil,
    nil,
    nil
)
add_input(
    nil,
    nil,
    "LeanRight",
    "Lean Right",
    "rbxassetid://17513844569",
    nil,
    nil,
    nil
)
add_input(
    nil,
    nil,
    "UICancelAction",
    "UI Cancel Action",
    "rbxassetid://17136633629",
    { Enum.KeyCode.Backspace, Enum.KeyCode.Escape },
    { Enum.KeyCode.ButtonB },
    nil
)
add_input(
    nil,
    nil,
    "UIPrimaryAction",
    "UI Primary Action",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.ButtonX },
    nil
)
add_input(
    nil,
    nil,
    "UISecondaryAction",
    "UI Secondary Action",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.ButtonY },
    nil
)
add_input(
    nil,
    nil,
    "UITertiaryAction",
    "UI Tertiary Action",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.ButtonL1 },
    nil
)
add_input(
    nil,
    nil,
    "UIQuaternaryAction",
    "UI Quaternary Action",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.ButtonR1 },
    nil
)
add_input(
    nil,
    nil,
    "UIOpenPage1",
    "UI Open Page 1",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.DPadLeft },
    nil
)
add_input(
    nil,
    nil,
    "UIOpenPage2",
    "UI Open Page 2",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.DPadDown },
    nil
)
add_input(
    nil,
    nil,
    "UIOpenPage3",
    "UI Open Page 3",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.DPadRight },
    nil
)
add_input(
    nil,
    nil,
    "UIOpenPage4",
    "UI Open Page 4",
    "rbxassetid://17136633629",
    nil,
    { Enum.KeyCode.DPadUp },
    nil
)

local function add_mobile_button(
    arg32,
    arg33,
    arg34,
    arg35,
    arg36,
    arg37,
    arg38,
    arg39,
    arg40,
    arg41,
    arg42,
    arg43
) -- line: 233
    -- upvalues:
    --  [1] t_6 (copy)

    local t_71 = {
        IsCoreInput = arg32 or false,
        InputName = arg35,
        Image = arg36 or "rbxassetid://13695061446",
        DefaultVisibility = not arg33,
        DefaultPosition = arg37,
        DefaultSize = arg38,
        AlwaysVisible = arg39,
        AlwaysToggle = arg40,
        VisibleWhileSpectatingForeignDuel = arg42,
        HideIfDead = not arg41
    }
    local v24 = arg43 or {}

    for key_3, val_3 in pairs(v24) do
        t_71[key_3] = val_3
    end

    t_6.MobileButtons[arg34] = t_71
    t_6.Inputs[arg35].MobileInputName = arg34

    if t_71.ItemIndex then
        t_6.MobileInputNameToItemIndex[arg34] = t_71.ItemIndex
    end
end

add_mobile_button(
    nil,
    nil,
    "mobile_aim",
    "Aim",
    "rbxassetid://13774376480",
    UDim2.new(1, -90, 1, -185),
    UDim2.new(0, 70, 0, 70)
)
add_mobile_button(
    nil,
    nil,
    "mobile_shoot",
    "Shoot",
    "rbxassetid://13774376715",
    UDim2.new(1, -160, 1, -150),
    UDim2.new(0, 70, 0, 70)
)
add_mobile_button(
    nil,
    nil,
    "mobile_reload",
    "Reload",
    "rbxassetid://13774376638",
    UDim2.new(1, -230, 1, -130),
    UDim2.new(0, 50, 0, 50)
)
add_mobile_button(
    nil,
    nil,
    "mobile_inspect",
    "Inspect",
    "rbxassetid://13774376564",
    UDim2.new(0, 90, 0, 80),
    UDim2.new(0, 40, 0, 40)
)
add_mobile_button(
    nil,
    nil,
    "mobile_quickmelee",
    "QuickMelee",
    "rbxassetid://13814923695",
    UDim2.new(1, -85, 0, 100),
    UDim2.new(0, 30, 0, 30),
    true,
    nil,
    nil,
    nil,
    { QuickAttackType = "Melee" }
)
add_mobile_button(
    nil,
    nil,
    "mobile_quickutility",
    "QuickUtility",
    "rbxassetid://16600936252",
    UDim2.new(1, -40, 0, 100),
    UDim2.new(0, 30, 0, 30),
    true,
    nil,
    nil,
    nil,
    { QuickAttackType = "Utility" }
)
add_mobile_button(
    true,
    nil,
    "mobile_crouch",
    "Crouch",
    "rbxassetid://13814923555",
    UDim2.new(1, -185, 1, -75),
    UDim2.new(0, 70, 0, 70),
    true,
    true
)
add_mobile_button(
    true,
    true,
    "mobile_slide",
    "Slide",
    "rbxassetid://17674207175",
    UDim2.new(1, -270, 1, -75),
    UDim2.new(0, 70, 0, 70),
    true
)
add_mobile_button(
    true,
    nil,
    "mobile_jump",
    "Jump",
    "rbxassetid://13774392305",
    UDim2.new(1, -90, 1, -90),
    UDim2.new(0, 80, 0, 80),
    true
)
add_mobile_button(
    true,
    nil,
    "mobile_switchcamerapov",
    "SwitchCameraPOV",
    "rbxassetid://137766393325923",
    UDim2.new(0, 40, 0, 80),
    UDim2.new(0, 40, 0, 40),
    true,
    nil,
    true,
    true
)
add_mobile_button(
    nil,
    nil,
    "mobile_openplayerlist",
    "OpenPlayerList",
    "rbxassetid://17319839617",
    UDim2.new(0, 140, 0, 80),
    UDim2.new(0, 40, 0, 40),
    true,
    nil,
    true,
    true
)
add_mobile_button(
    nil,
    nil,
    "mobile_equipprimary",
    "EquipPrimary",
    "rbxassetid://124117259408457",
    UDim2.new(1, -175, 0, 60),
    UDim2.new(0, 40, 0, 40),
    true,
    nil,
    nil,
    nil,
    { ItemIndex = 1 }
)
add_mobile_button(
    nil,
    nil,
    "mobile_equipsecondary",
    "EquipSecondary",
    "rbxassetid://87384533585497",
    UDim2.new(1, -130, 0, 60),
    UDim2.new(0, 40, 0, 40),
    true,
    nil,
    nil,
    nil,
    { ItemIndex = 2 }
)
add_mobile_button(
    nil,
    nil,
    "mobile_equipmelee",
    "EquipMelee",
    "rbxassetid://124237418792068",
    UDim2.new(1, -85, 0, 60),
    UDim2.new(0, 40, 0, 40),
    true,
    nil,
    nil,
    nil,
    { ItemIndex = 3 }
)
add_mobile_button(
    nil,
    nil,
    "mobile_equiputility",
    "EquipUtility",
    "rbxassetid://112565014737738",
    UDim2.new(1, -40, 0, 60),
    UDim2.new(0, 40, 0, 40),
    true,
    nil,
    nil,
    nil,
    { ItemIndex = 4 }
)
add_mobile_button(
    nil,
    nil,
    "mobile_useemote",
    "UseEmote",
    "rbxassetid://137981590006803",
    UDim2.new(0, 190, 0, 80),
    UDim2.new(0, 40, 0, 40),
    true
)

return t_6
