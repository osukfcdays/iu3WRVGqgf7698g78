local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local _ = require(ReplicatedStorage.Modules.PermissionsLibrary)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local SettingsInfo_m = require(ReplicatedStorage.Modules.SettingsInfo)
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local t_1 = {
    "Shoot",
    "Aim",
    "Reload",
    "Inspect",
    "QuickMelee",
    "QuickUtility",
    "Divider",
    "WalkForward",
    "WalkBackward",
    "WalkLeftward",
    "WalkRightward",
    "Jump",
    "Sprint",
    "Crouch",
    "Slide",
    "Divider",
    "EquipPrimary",
    "EquipSecondary",
    "EquipMelee",
    "EquipUtility",
    "EquipNext",
    "EquipLast",
    "Divider",
    "UseEmote",
    "Divider",
    "SwitchCameraPOV",
    "Ping",
    "OpenPlayerList",
    "SwitchItems",
    "LeaveDuel",
    "SpectateExit",
    "SpectateNext",
    "SpectateLast",
    "HideHUD"
}
local t_2 = {}
t_2["Camera Sensitivity X"] = { "Camera Sensitivity", "any" }
t_2["Camera Sensitivity Y"] = { "Camera Sensitivity", "any" }
t_2["Camera Sensitivity ADS"] = { "Camera Sensitivity", "any" }
t_2["Camera Sensitivity Scoped"] = { "Camera Sensitivity", "any" }
t_2["Camera Inverted X"] = { "Camera Sensitivity", "any" }
t_2["Camera Inverted Y"] = { "Camera Sensitivity", "any" }
t_2["Camera FOV Effects"] = { "Camera FOV", "any" }
t_2["Camera Zoom Effects"] = { "Camera FOV", "any" }
t_2["Camera Zoom Effects Scoped"] = { "Camera FOV", "any" }
t_2["Auto Shoot Reaction Time"] = { "Auto Shoot", "Custom" }
t_2["Aim Assist Strength"] = { "Aim Assist", "Custom" }
t_2["Music Volume"] = { "Master Volume", "any" }
t_2["Other Volume"] = { "Master Volume", "any" }
t_2["Finisher Volume"] = { "Master Volume", "any" }
t_2["Emote Volume"] = { "Master Volume", "any" }
t_2["Mute Finishers From Others"] = { "Finisher Volume", "any" }
t_2["Mute Emotes From Others"] = { "Emote Volume", "any" }
t_2["Keep Quick Attack Window"] = { "Keep Quick Attack Enabled", true }
t_2["Double Tap Shoot Window"] = { "Double Tap Shoot", true }
t_2["Damage Numbers Color"] = { "Damage Numbers", true }
t_2["Damage Numbers Critical Color"] = { "Damage Numbers", true }
t_2["Hotbar Display"] = { "Gameplay HUD Preset", "Custom" }
t_2["Equipped Weapon Display"] = { "Gameplay HUD Preset", "Custom" }
t_2["Keybinds Interface"] = { "Gameplay HUD Preset", "Custom" }
t_2["Health Bar Display"] = { "Gameplay HUD Preset", "Custom" }
t_2["Spectators Display"] = { "Gameplay HUD Preset", "Custom" }
t_2["Equipped Weapon Icon"] = { "Equipped Weapon Display", "Disabled", nil, true }
t_2["Equipped Weapon Ammo"] = { "Equipped Weapon Display", "Disabled", nil, true }
t_2["Hotbar Slot Ammo"] = { "Hotbar Display", "Disabled", nil, true }
t_2["Damage Flashing Color Base"] = { "Damage Flashing", "Disabled", nil, true }
t_2["Damage Flashing Color Flash"] = { "Damage Flashing", "Disabled", nil, true }
local t_34 = {
    HOTKEYS_GUIDE = t_1,
    DEPENDENCIES = t_2,
    STAFF_SETTINGS = {
        "Staff Team Visuals",
        "Staff Team Tools Disabled",
        "Staff Team Server Logs",
        "Staff Team Hidden Spectator",
        "Staff Team Tools Disabled Leads"
    },
    NUM_PROFILES = 3,
    Info = {},
    Order = {},
    OrderBySections = {}
}

function t_34.DoesExist(_, arg2) -- line: 47
    -- upvalues:
    --  [1] t_34 (copy)

    return t_34.Info[arg2] or arg2 == "Audio Visualizers" or arg2 == "Player Hitboxes" or arg2 == "ViewModel Shaking"
end

function t_34.GenerateCrosshairAppearance(_, arg4, arg5, arg6) -- line: 56
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    local v2 = {}

    local _ = function(arg7) --[[ get ]] -- line: 59
        -- upvalues:
        --  [1] arg5 (copy)
        --  [2] arg4 (copy)

        if arg5 and arg5[arg7] ~= nil then
            return arg5[arg7]
        end

        return (arg4:GetSetting(arg7))
    end

    if if arg5 and arg5["Crosshair Disabled"] ~= nil then arg5["Crosshair Disabled"] else arg4:GetSetting(
        "Crosshair Disabled"
    ) then
        v2.IsDisabled = true
    else
        local v5 = not (if arg5 and arg5["Crosshair Bars Enabled"] ~= nil then arg5["Crosshair Bars Enabled"] else arg4:GetSetting(
            "Crosshair Bars Enabled"
        ))
        local v4 = not (if arg5 and arg5["Crosshair Dot Enabled"] ~= nil then arg5["Crosshair Dot Enabled"] else arg4:GetSetting(
            "Crosshair Dot Enabled"
        ))
        local v6 = not (if arg5 and arg5["Crosshair Circle Enabled"] ~= nil then arg5["Crosshair Circle Enabled"] else arg4:GetSetting(
            "Crosshair Circle Enabled"
        ))
        local v7 = not (if arg5 and arg5["Crosshair Outline Enabled"] ~= nil then arg5["Crosshair Outline Enabled"] else arg4:GetSetting(
            "Crosshair Outline Enabled"
        ))
        local _ = not (if arg5 and arg5["Crosshair Scoped Red Dot"] ~= nil then arg5["Crosshair Scoped Red Dot"] else arg4:GetSetting(
            "Crosshair Scoped Red Dot"
        ))
        v2.IsDisabled = nil
        v2.IsStatic = (if arg5 and arg5["Crosshair Static"] ~= nil then arg5["Crosshair Static"] else arg4:GetSetting(
            "Crosshair Static"
        )) or nil
        v2.Rotation = if arg5 and arg5["Crosshair Rotation"] ~= nil then arg5["Crosshair Rotation"] else arg4:GetSetting(
            "Crosshair Rotation"
        )
        v2.Scale = if arg5 and arg5["Crosshair Scale"] ~= nil then arg5["Crosshair Scale"] else arg4:GetSetting(
            "Crosshair Scale"
        )
        v2.ShowWhileAiming = (if arg5 and arg5["Crosshair Show While Aiming"] ~= nil then arg5["Crosshair Show While Aiming"] else arg4:GetSetting(
            "Crosshair Show While Aiming"
        )) or nil
        v2.ShowWhileInspecting = (if arg5 and arg5["Crosshair Show While Inspecting"] ~= nil then arg5["Crosshair Show While Inspecting"] else arg4:GetSetting(
            "Crosshair Show While Inspecting"
        )) or nil
        v2.Override = (if arg5 and arg5["Crosshair Override Shotgun"] ~= nil then arg5["Crosshair Override Shotgun"] else arg4:GetSetting(
            "Crosshair Override Shotgun"
        )) or nil
        v2.BarsDisabled = v5 or nil
        local v13, v14

        if not v5 then
            v13 = if arg5 and arg5["Crosshair Bars Top Enabled"] ~= nil then arg5["Crosshair Bars Top Enabled"] else arg4:GetSetting(
                "Crosshair Bars Top Enabled"
            )
            v14 = not v13 or nil
        else
            v14 = nil
        end

        v2.BarsTopDisabled = v14

        if not v5 then
            v13 = if arg5 and arg5["Crosshair Bars Bottom Enabled"] ~= nil then arg5["Crosshair Bars Bottom Enabled"] else arg4:GetSetting(
                "Crosshair Bars Bottom Enabled"
            )
            v14 = not v13 or nil
        else
            v14 = nil
        end

        v2.BarsBottomDisabled = v14
        v2.BarsRightDisabled = not v5 and not (if arg5 and arg5["Crosshair Bars Right Enabled"] ~= nil then arg5["Crosshair Bars Right Enabled"] else arg4:GetSetting(
            "Crosshair Bars Right Enabled"
        )) or nil
        v2.BarsLeftDisabled = not v5 and not (if arg5 and arg5["Crosshair Bars Left Enabled"] ~= nil then arg5["Crosshair Bars Left Enabled"] else arg4:GetSetting(
            "Crosshair Bars Left Enabled"
        )) or nil
        v2.BarsSpacing = if not v5 then if arg5 and arg5["Crosshair Bars Spacing"] ~= nil then arg5["Crosshair Bars Spacing"] else arg4:GetSetting(
            "Crosshair Bars Spacing"
        ) else nil
        v2.BarsLength = if not v5 then if arg5 and arg5["Crosshair Bars Length"] ~= nil then arg5["Crosshair Bars Length"] else arg4:GetSetting(
            "Crosshair Bars Length"
        ) else nil
        v2.BarsThickness = if not v5 then if arg5 and arg5["Crosshair Bars Thickness"] ~= nil then arg5["Crosshair Bars Thickness"] else arg4:GetSetting(
            "Crosshair Bars Thickness"
        ) else nil
        v2.BarsTransparency = if not v5 then if arg5 and arg5["Crosshair Bars Transparency"] ~= nil then arg5["Crosshair Bars Transparency"] else arg4:GetSetting(
            "Crosshair Bars Transparency"
        ) else nil
        v2.BarsColor = if not v5 then if arg5 and arg5["Crosshair Bars Color"] ~= nil then arg5["Crosshair Bars Color"] else arg4:GetSetting(
            "Crosshair Bars Color"
        ) else nil
        v2.BarsShape = if not v5 then if arg5 and arg5["Crosshair Bars Shape"] ~= nil then arg5["Crosshair Bars Shape"] else arg4:GetSetting(
            "Crosshair Bars Shape"
        ) else nil
        v2.DotDisabled = v4 or nil
        v2.DotThickness = if not v4 then if arg5 and arg5["Crosshair Dot Thickness"] ~= nil then arg5["Crosshair Dot Thickness"] else arg4:GetSetting(
            "Crosshair Dot Thickness"
        ) else nil
        v2.DotTransparency = if not v4 then if arg5 and arg5["Crosshair Dot Transparency"] ~= nil then arg5["Crosshair Dot Transparency"] else arg4:GetSetting(
            "Crosshair Dot Transparency"
        ) else nil
        v2.DotColor = if not v4 then if arg5 and arg5["Crosshair Dot Color"] ~= nil then arg5["Crosshair Dot Color"] else arg4:GetSetting(
            "Crosshair Dot Color"
        ) else nil
        v2.DotShape = if not v4 then if arg5 and arg5["Crosshair Dot Shape"] ~= nil then arg5["Crosshair Dot Shape"] else arg4:GetSetting(
            "Crosshair Dot Shape"
        ) else nil
        v2.CircleDisabled = v6 or nil
        v2.CircleColor = if not v6 then if arg5 and arg5["Crosshair Circle Color"] ~= nil then arg5["Crosshair Circle Color"] else arg4:GetSetting(
            "Crosshair Circle Color"
        ) else nil
        v2.CircleSize = if not v6 then if arg5 and arg5["Crosshair Circle Size"] ~= nil then arg5["Crosshair Circle Size"] else arg4:GetSetting(
            "Crosshair Circle Size"
        ) else nil
        v2.CircleThickness = if not v6 then if arg5 and arg5["Crosshair Circle Thickness"] ~= nil then arg5["Crosshair Circle Thickness"] else arg4:GetSetting(
            "Crosshair Circle Thickness"
        ) else nil
        v2.CircleTransparency = if not v6 then if arg5 and arg5["Crosshair Circle Transparency"] ~= nil then arg5["Crosshair Circle Transparency"] else arg4:GetSetting(
            "Crosshair Circle Transparency"
        ) else nil
        v2.CircleShape = if not v6 then if arg5 and arg5["Crosshair Circle Shape"] ~= nil then arg5["Crosshair Circle Shape"] else arg4:GetSetting(
            "Crosshair Circle Shape"
        ) else nil
        v2.OutlineDisabled = v7 or nil
        v2.OutlineThickness = if not v7 then if arg5 and arg5["Crosshair Outline Thickness"] ~= nil then arg5["Crosshair Outline Thickness"] else arg4:GetSetting(
            "Crosshair Outline Thickness"
        ) else nil
        v2.OutlineTransparency = if not v7 then if arg5 and arg5["Crosshair Outline Transparency"] ~= nil then arg5["Crosshair Outline Transparency"] else arg4:GetSetting(
            "Crosshair Outline Transparency"
        ) else nil
        v2.OutlineColor = if not v7 then if arg5 and arg5["Crosshair Outline Color"] ~= nil then arg5["Crosshair Outline Color"] else arg4:GetSetting(
            "Crosshair Outline Color"
        ) else nil
        v2.OutlineType = if not v7 then if arg5 and arg5["Crosshair Outline Type"] ~= nil then arg5["Crosshair Outline Type"] else arg4:GetSetting(
            "Crosshair Outline Type"
        ) else nil
    end

    if not (if arg5 and arg5["Crosshair Hitmarker Enabled"] ~= nil then arg5["Crosshair Hitmarker Enabled"] else arg4:GetSetting(
        "Crosshair Hitmarker Enabled"
    )) then
        v2.HitmarkerDisabled = true
    else
        v2.HitmarkerDisabled = nil
        v2.HitmarkerScale = if arg5 and arg5["Crosshair Hitmarker Scale"] ~= nil then arg5["Crosshair Hitmarker Scale"] else arg4:GetSetting(
            "Crosshair Hitmarker Scale"
        )
        v2.HitmarkerRotation = if arg5 and arg5["Crosshair Hitmarker Rotation"] ~= nil then arg5["Crosshair Hitmarker Rotation"] else arg4:GetSetting(
            "Crosshair Hitmarker Rotation"
        )
        v2.HitmarkerTransparency = if arg5 and arg5["Crosshair Hitmarker Transparency"] ~= nil then arg5["Crosshair Hitmarker Transparency"] else arg4:GetSetting(
            "Crosshair Hitmarker Transparency"
        )
        v2.HitmarkerColor = if arg5 and arg5["Crosshair Hitmarker Color"] ~= nil then arg5["Crosshair Hitmarker Color"] else arg4:GetSetting(
            "Crosshair Hitmarker Color"
        )
        v2.HitmarkerTransparencyCrit = if arg5 and arg5["Crosshair Hitmarker Transparency Crit"] ~= nil then arg5["Crosshair Hitmarker Transparency Crit"] else arg4:GetSetting(
            "Crosshair Hitmarker Transparency Crit"
        )
        v2.HitmarkerColorCrit = if arg5 and arg5["Crosshair Hitmarker Color Crit"] ~= nil then arg5["Crosshair Hitmarker Color Crit"] else arg4:GetSetting(
            "Crosshair Hitmarker Color Crit"
        )
    end

    local v15 = not (if arg5 and arg5["Crosshair Scoped Bars"] ~= nil then arg5["Crosshair Scoped Bars"] else arg4:GetSetting(
        "Crosshair Scoped Bars"
    ))
    local v17 = if arg5 and arg5["Crosshair Scoped Red Dot"] ~= nil then arg5["Crosshair Scoped Red Dot"] else arg4:GetSetting(
        "Crosshair Scoped Red Dot"
    )
    v2.ScopedDisabled = nil
    v2.ScopedBarsDisabled = v15 or nil
    v2.ScopedRedDotDisabled = not v17 or nil
    v2.ScopedRedDotColor = if arg5 and arg5["Crosshair Scoped Red Dot Color"] ~= nil then arg5["Crosshair Scoped Red Dot Color"] else arg4:GetSetting(
        "Crosshair Scoped Red Dot Color"
    )

    if arg6 then
        local t_35 = {}

        for key, val in pairs(v2) do
            t_35[EnumLibrary_m:ToEnum(key)] = val
        end

        v2 = t_35
    end

    return v2
end

function t_34.DecodeCrosshairAppearance(_, arg9) -- line: 154
    -- upvalues:
    --  [1] EnumLibrary_m (copy)

    local t_36 = {}

    for key_1, val_1 in pairs(arg9) do
        t_36[EnumLibrary_m:FromEnum(key_1)] = val_1
    end

    return t_36
end

local function add_setting(...) -- line: 164
    -- upvalues:
    --  [1] SettingsInfo_m (copy)
    --  [2] t_34 (copy)

    local v19 = SettingsInfo_m.new(...)
    t_34.Info[v19.Name] = if v19.Type == "Divider" then nil else v19
    table.insert(t_34.Order, v19)
    local v20 = t_34.OrderBySections[v19.Section]
    local OrderBySections = t_34.OrderBySections
    local Section = v19.Section

    if not v20 then
        v20 = {}
    end

    OrderBySections[Section] = v20
    table.insert(t_34.OrderBySections[v19.Section], v19)
end

local function add_hotkey_setting(arg10, _) -- line: 173
    -- upvalues:
    --  [1] InputLibrary_m (copy)
    --  [2] add_setting (copy)

    local v21 = InputLibrary_m.Inputs[arg10]

    for key_2, val_2 in pairs(InputLibrary_m.HOTKEY_FORMATS) do
        for key_3, val_3 in pairs(val_2) do
            local v22 = v21.InputEnums[key_2]

            if v22 then
                v22 = v21.InputEnums[key_2][key_3]
            end

            local v23 = add_setting
            local formattedText = string.format(val_3, arg10)
            v23(
                "Hotkeys",
                formattedText,
                v21.DisplayName,
                "",
                "",
                "Hotkey",
                v22 and v22.Name or "nil"
            )
        end
    end
end

local _ = function(arg12, arg13, arg14) --[[ add_divider ]] -- line: 185
    -- upvalues:
    --  [1] add_setting (copy)

    add_setting(
        arg12,
        arg12 .. " - " .. arg13,
        arg13,
        arg14 or "",
        "",
        "Divider"
    )
end

add_setting(
    "Video",
    "Video - Performance",
    "Performance",
    "",
    "",
    "Divider"
)
add_setting(
    "Video",
    "Shadows Disabled",
    "Optimized Lighting",
    "rbxassetid://17521723349",
    "Disables shadows which may increase performance but causes the game to look brighter. If you turn this off, you will need to restart your game",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Textures Disabled",
    "Optimized Textures",
    "rbxassetid://17521723467",
    "Deletes most textures & materials which may increase performance but causes the game to lack detail. If you turn this off, you will need to restart your game",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Wraps Disabled",
    "Optimized Wraps",
    "rbxassetid://17593458822",
    "Hides weapon wraps which may increase performance. You'll still be able to see your own wraps",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Video - Camera",
    "Camera",
    "",
    "",
    "Divider"
)
add_setting(
    "Video",
    "Camera Sensitivity",
    "Sensitivity",
    "rbxassetid://17548980857",
    "Change how fast your camera rotates",
    "Slider",
    1,
    0.05,
    4,
    20,
    true
)
add_setting(
    "Video",
    "Camera Sensitivity ADS",
    "While Aiming",
    "rbxassetid://17516823433",
    "Multiplies your camera sensitivity while aiming with non-scoped weapons",
    "Slider",
    0.5,
    0.05,
    2,
    20,
    true
)
add_setting(
    "Video",
    "Camera Sensitivity Scoped",
    "While Scoped",
    "rbxassetid://87834608236137",
    "Multiplies your camera sensitivity while aiming with scoped weapons specifically",
    "Slider",
    0.5,
    0.05,
    2,
    20,
    true
)
add_setting(
    "Video",
    "Camera Sensitivity X",
    "Horizontal",
    "rbxassetid://85286504432350",
    "[Advanced] Specifically change your left & right sensitivity",
    "Slider",
    1,
    0.05,
    4,
    20,
    true
)
add_setting(
    "Video",
    "Camera Sensitivity Y",
    "Vertical",
    "rbxassetid://72795034348521",
    "[Advanced] Specifically change your up & down sensitivity",
    "Slider",
    1,
    0.05,
    4,
    20,
    true
)
add_setting(
    "Video",
    "Camera Inverted X",
    "Inverted X",
    "rbxassetid://85286504432350",
    "[Advanced] Inverts your camera's left & right movements",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Camera Inverted Y",
    "Inverted Y",
    "rbxassetid://72795034348521",
    "[Advanced] Inverts your camera's up & down movements",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Camera FOV",
    "Field Of View",
    "rbxassetid://130564359100743",
    "Changes how much of the world your camera is able to see",
    "Slider",
    80,
    30,
    120,
    1
)
add_setting(
    "Video",
    "Camera FOV Effects",
    "Gameplay Effects",
    "rbxassetid://17513821002",
    "Enables gameplay-related field of view effects from things such as sprinting",
    "Toggle",
    true
)
add_setting(
    "Video",
    "Camera Zoom Effects",
    "Non-Scoped Weapons",
    "rbxassetid://17516823433",
    "Changes the strength of field of view effects from things like aiming & charging for non-scoped weapons",
    "Slider",
    1,
    0,
    1,
    20,
    true
)
add_setting(
    "Video",
    "Camera Zoom Effects Scoped",
    "Scoped Weapons",
    "rbxassetid://87834608236137",
    "Changes the strength of field of view effects for aiming with scoped weapons specifically",
    "Slider",
    1,
    0,
    1,
    20,
    true
)
add_setting(
    "Video",
    "Camera Shake",
    "Camera Shake",
    "rbxassetid://18404346057",
    "Enables effects such as recoil, explosions, etc",
    "Toggle",
    true
)
add_setting(
    "Video",
    "Video - Interface",
    "Interface",
    "",
    "",
    "Divider"
)
add_setting(
    "Video",
    "Hide HUD",
    "Hide HUD",
    "rbxassetid://126633805196326",
    "Turns off most user interface elements, possibly allowing you to get cleaner footage. This setting can also be bound to a hotkey for Controller and Mouse & Keyboard",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Hide Tasks In Duels",
    "Hide Side Tasks",
    "rbxassetid://17632205556",
    "Hides your tasks interface on the left side of your screen once the duel's round begins",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Padded HUD",
    "Padded HUD",
    "rbxassetid://118715309480493",
    "Shrinks the HUD to add more space around the edges of your screen. Great for playing on a TV or large monitor",
    "Dropdown",
    "Using Controller",
    { "Always On", "Using Controller", "Disabled" }
)
add_setting(
    "Video",
    "PlayerList Leaderstat",
    "Lobby Data",
    "rbxassetid://17898066959",
    "Change what kind of data the player list & player nametags display. This setting can also be changed by clicking on the icon in the top right of the player list",
    "Dropdown",
    "Win Streak",
    { "Win Streak", "Level", "Current ELO" }
)
add_setting(
    "Video",
    "Video - Graphics",
    "Graphics",
    "",
    "",
    "Divider"
)
add_setting(
    "Video",
    "ViewModel Highlight",
    "Weapon Inking",
    "rbxassetid://17611932430",
    "Adds a subtle outline around your weapons. This effect may cause weird artifacts for transparent weapons and/or wraps that have a glass look to them",
    "Toggle",
    true
)
add_setting(
    "Video",
    "Aiming Hides Muzzle Flashes",
    "Hide Muzzle Flashes",
    "rbxassetid://125628882498996",
    "Hides muzzle flash effects while aiming with a weapon. Helps reduce visual obstructions with certain weapon skins",
    "Toggle",
    false
)
add_setting(
    "Video",
    "Equipment Background",
    "Weapons Background",
    "rbxassetid://17898066959",
    "Changes the 3D background of the Weapons page. Great for making thumbnails of certain weapons, skins, wraps, etc",
    "Dropdown",
    "Default",
    { "Default", "Green Screen", "Blue Screen", "Pink Screen" }
)
add_setting(
    "Video",
    "Video - Accessibility",
    "Accessibility",
    "",
    "",
    "Divider"
)
add_setting(
    "Video",
    "Damage Flashing",
    "Damage Flashing",
    "rbxassetid://107944065079684",
    "Plays a bright flashing effect every time something takes damage. Turn this off if you are sensitive to flashing lights",
    "Dropdown",
    "Enabled",
    { "Enabled", "Outline", "Disabled" }
)
add_setting(
    "Video",
    "Damage Flashing Color Base",
    "Base Color",
    "rbxassetid://107944065079684",
    "Change the base color of the damage flashing effect",
    "Color",
    "#ff3232"
)
add_setting(
    "Video",
    "Damage Flashing Color Flash",
    "Flash Color",
    "rbxassetid://107944065079684",
    "Change the flash color of the damage flashing effect",
    "Color",
    "#ffffff"
)
add_setting(
    "Video",
    "Accessible Flashes",
    "Dark Blinds",
    "rbxassetid://17814211801",
    "Makes flashbang blinds dark instead of bright. Turn this on if you are sensitive to flashing lights",
    "Toggle",
    false
)
add_setting(
    "Audio",
    "Master Volume",
    "Master Volume",
    "rbxassetid://17506383011",
    "Changes the volume of everything",
    "Slider",
    0.5,
    0,
    2,
    20,
    true
)
add_setting(
    "Audio",
    "Music Volume",
    "Music Volume",
    "rbxassetid://136271678394092",
    "Changes the volume of just the music. Music made by @BSlickMusic",
    "Slider",
    1,
    0,
    2,
    20,
    true
)
add_setting(
    "Audio",
    "Finisher Volume",
    "Finisher Volume",
    "rbxassetid://77965589200390",
    "Changes the volume of just finishers, which are effects that play on elimination",
    "Slider",
    1,
    0,
    2,
    20,
    true
)
add_setting(
    "Audio",
    "Mute Finishers From Others",
    "Mute Other Finishers",
    "rbxassetid://138903494625319",
    "Mutes finishers that are from other players unless you're currently spectating them",
    "Toggle",
    false
)
add_setting(
    "Audio",
    "Emote Volume",
    "Emote Volume",
    "rbxassetid://130882808226687",
    "Changes the volume of just emotes",
    "Slider",
    1,
    0,
    2,
    20,
    true
)
add_setting(
    "Audio",
    "Mute Emotes From Others",
    "Mute Other Emotes",
    "rbxassetid://138903494625319",
    "Mutes emotes that are from other players unless you're currently spectating them",
    "Toggle",
    false
)
add_setting(
    "Audio",
    "Other Volume",
    "SFX Volume",
    "rbxassetid://125628882498996",
    "Changes the volume of basically everything else",
    "Slider",
    1,
    0,
    2,
    20,
    true
)
add_setting(
    "Game",
    "Game - Gameplay",
    "Gameplay",
    "",
    "",
    "Divider"
)
add_setting(
    "Game",
    "Damage Numbers",
    "Damage Numbers",
    "rbxassetid://18404346057",
    "Displays the damage you deal to others",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Damage Numbers Color",
    "Color",
    "rbxassetid://18404346057",
    "Change the color of normal damage",
    "Color",
    "#ffffff"
)
add_setting(
    "Game",
    "Damage Numbers Critical Color",
    "Critical Color",
    "rbxassetid://18404346057",
    "Change the color of critical damage",
    "Color",
    "#ff3232"
)
add_setting(
    "Game",
    "Pings",
    "Signals",
    "rbxassetid://17269776216",
    "Allows you to see signal callouts from teammates. You can signal your teammates using a Controller or Mouse & Keyboard by pressing a specific hotkey. This hotkey can be changed at any time",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Hide Teammate Icons",
    "Hide Teammate Display",
    "rbxassetid://17704137194",
    "Hides teammate icons & health bars in duels",
    "Toggle",
    false
)
add_setting(
    "Game",
    "ViewModel Aiming",
    "Aiming Animation",
    "rbxassetid://17516823433",
    "[Advanced] Turn this off to disable your aiming animations for all non-scoped weapons. This should help remove any negative impact on gameplay from using larger skins",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Projectile Smoothing",
    "Smooth Projectiles",
    "rbxassetid://111780605198345",
    "[Advanced] Smoothens the motion of projectiles to provide a more visually appealing experience. Turn this off for a snappier & more visually accurate experience with projectile weapons",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Game - Interface",
    "Interface",
    "",
    "",
    "Divider"
)
add_setting(
    "Game",
    "Pick Weapons List",
    "Weapon Picker",
    "rbxassetid://17539215512",
    "Changes the look of the weapon picker interface in duels & the shooting range",
    "Dropdown",
    "Grid",
    { "Grid", "List" }
)
add_setting(
    "Game",
    "Gameplay HUD Preset",
    "Gameplay HUD",
    "rbxassetid://17898066959",
    "An easy way of trying out a new gameplay HUD format! Choose between the default look, a left handed mode, the classic RIVALS layout, or a centered version that works great for vertical content creation",
    "Dropdown",
    "Default",
    { "Default", "Left Handed", "Legacy", "Centered", "Custom", "Disabled" }
)
add_setting(
    "Game",
    "Hotbar Display",
    "Hotbar Display",
    "rbxassetid://13188242287",
    "[Advanced] Choose whether you want all of your weapons to be displayed on the bottom right, where they usually go, or in the bottom left, where the health bar usually sits. Not available for touch controls",
    "Dropdown",
    "Bottom Right",
    { "Bottom Left", "Bottom Right", "Bottom Center", "Disabled" }
)
add_setting(
    "Game",
    "Hotbar Slot Ammo",
    "Show Weapon Ammo",
    "rbxassetid://16539130428",
    "Displays your weapon's ammo on the hotbar to see from a quick glance. Does not affect touch buttons",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Equipped Weapon Display",
    "Equipped Display",
    "rbxassetid://116467133898357",
    "[Advanced] Choose whether you want your equipped weapon's ammo & information to be displayed on the bottom left, where the health bar usually sits, or in the bottom right, where the hotbar usually sits",
    "Dropdown",
    "Bottom Right",
    { "Bottom Left", "Bottom Right", "Legacy", "Disabled" }
)
add_setting(
    "Game",
    "Equipped Weapon Icon",
    "Show Weapon Icon",
    "rbxassetid://17611932430",
    "[Advanced] Choose whether or not your Equipped Display shows the icon of your weapon. This should probably be turned off if you put your Equipped Display next to your Hotbar",
    "Toggle",
    false
)
add_setting(
    "Game",
    "Equipped Weapon Ammo",
    "Show Weapon Ammo",
    "rbxassetid://16539130428",
    "[Advanced] Choose whether or not your Equipped Display shows the ammo of your weapon",
    "Toggle",
    false
)
add_setting(
    "Game",
    "Keybinds Interface",
    "Keybinds Display",
    "rbxassetid://133555125764102",
    "[Advanced] Choose whether you want situational keybinds to appear on the bottom left, where the health bar usually sits, or in the bottom right, where the hotbar usually sits",
    "Dropdown",
    "Bottom Right",
    { "Bottom Left", "Bottom Right", "Disabled" }
)
add_setting(
    "Game",
    "Health Bar Display",
    "Health Display",
    "rbxassetid://102193196101741",
    "[Advanced] Choose whether you want your health bar to appear on the bottom left, where it usually goes, or in the bottom right, where the hotbar usually sits",
    "Dropdown",
    "Bottom Left",
    { "Bottom Left", "Bottom Right", "Bottom Center", "Disabled" }
)
add_setting(
    "Game",
    "Spectators Display",
    "Spectators Display",
    "rbxassetid://77908042044589",
    "[Advanced] Choose whether you want the spectators visual to appear on the bottom left, where it usually goes, or in the bottom right, where the hotbar usually sits",
    "Dropdown",
    "Bottom Left",
    { "Bottom Left", "Bottom Right", "Bottom Center", "Disabled" }
)
add_setting(
    "Game",
    "Game - Controls",
    "Controls",
    "",
    "",
    "Divider"
)
add_setting(
    "Game",
    "Toggle Aim",
    "Toggle Aim",
    "rbxassetid://17513805525",
    "Doesn't affect Touch Controls",
    "Toggle",
    false
)
add_setting(
    "Game",
    "Toggle Crouch",
    "Toggle Crouch",
    "rbxassetid://17513805623",
    "Doesn't affect Touch Controls",
    "Toggle",
    false
)
add_setting(
    "Game",
    "Toggle Sprint",
    "Toggle Sprint",
    "rbxassetid://17513821002",
    "Doesn't affect Touch Controls",
    "Toggle",
    false
)
add_setting(
    "Game",
    "Auto Sprint",
    "Auto Sprint",
    "rbxassetid://17513821002",
    "Automatically sprint while moving instead of having to use the sprint button. Doesn't affect Touch Controls",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Easy Slide",
    "Easy Slide",
    "rbxassetid://17524267716",
    "While turned on, you can easily slide by sprinting & then crouching. If you turn this off, you should bind a hotkey to your dedicated Slide button. Doesn't affect Touch Controls",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Easy Quick Attack",
    "Easy Quick Attack",
    "rbxassetid://16828140099",
    "Quick melee & quick utility will automatically use abilities if necessary, such as automatically dashing with the Scythe",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Keep Quick Attack Enabled",
    "Quick Attack Keeping",
    "rbxassetid://17225650859",
    "[Advanced] Allows you to keep your weapon after quick attacking by holding down the Quick Attack button",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Keep Quick Attack Window",
    "Keep Window",
    "rbxassetid://17225650859",
    "[Advanced] How long, in seconds, you need to hold the Quick Attack button for you to keep your weapon out. If you set this to 0 seconds, you will always keep your weapon after quick attacking",
    "Slider",
    0.25,
    0,
    1,
    20
)
add_setting(
    "Game",
    "Scroll Equip",
    "Scroll Equip",
    "rbxassetid://88012714630436",
    "Allows you to scroll up & down with your mouse wheel to switch weapons. Only available for Mouse & Keyboard",
    "Toggle",
    true
)
add_setting(
    "Game",
    "Game - Handicaps",
    "Handicaps",
    "",
    "",
    "Divider"
)
add_setting(
    "Game",
    "Aim Assist",
    "Aim Assist",
    "rbxassetid://139269442808394",
    "While aiming with a weapon, your camera will be pulled in the direction of nearby enemies. Only available for Touch Controls & Controller",
    "Dropdown",
    "Custom",
    { "Custom", "Disabled" }
)
add_setting(
    "Game",
    "Aim Assist Strength",
    "Pull Strength",
    "rbxassetid://139269442808394",
    "Change how strong your aim assist pulls your camera",
    "Slider",
    0.5,
    0,
    1,
    20,
    true
)
add_setting(
    "Game",
    "Auto Shoot",
    "Auto Shoot",
    "rbxassetid://122696559841523",
    "Weapons will automatically attack enemies if your crosshair lines up with their body. In competitive modes, such as Ranked, this setting is forced to be Dynamic. Dynamic mode makes it so that your Auto Shoot's reaction time changes based on the weapon you use to ensure fair gameplay. Only available for Touch Controls & Controller",
    "Dropdown",
    "Custom",
    { "Custom", "Dynamic", "Disabled" }
)
add_setting(
    "Game",
    "Auto Shoot Reaction Time",
    "Reaction Time",
    "rbxassetid://122696559841523",
    "The delay, in milliseconds, that your auto shoot will trigger after your crosshair lines up with an enemy",
    "Slider",
    25,
    25,
    125,
    1
)
add_setting(
    "Game",
    "Third Person Access",
    "Third Person Camera",
    "rbxassetid://138606382770333",
    "Allows you to change your camera's point of view from first person to third person. Only available for Touch Controls",
    "Dropdown",
    "Touch Controls",
    { "Touch Controls" }
)
add_setting(
    "Game",
    "Game - Accessibility",
    "Accessibility",
    "",
    "",
    "Divider"
)
add_setting(
    "Game",
    "Gamepad Deadzone",
    "Joystick Deadzone",
    "rbxassetid://110291144710849",
    "[Advanced] Helps fix joystick drifting while playing with a Controller. Gradually increase this number until you no longer experience stick drift",
    "Slider",
    0.25,
    0,
    0.95,
    20,
    true
)
add_setting(
    "Game",
    "Control Scheme",
    "Control Scheme",
    "rbxassetid://81276179444570",
    "[Advanced] Use this setting to force the game to respect your desired control scheme",
    "Dropdown",
    "Automatic",
    { "Automatic", "Mouse & Keyboard", "Touch Buttons", "Controller" }
)
add_setting(
    "Crosshair",
    "Crosshair - Crosshair",
    "Crosshair",
    "",
    "",
    "Divider"
)
add_setting(
    "Crosshair",
    "Crosshair Disabled",
    "Disabled",
    "rbxassetid://139575687490912",
    "Makes the crosshair invisible",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Scale",
    "Scale",
    "rbxassetid://115388073389430",
    "Make your crosshair big or small",
    "Slider",
    1,
    0,
    4,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Rotation",
    "Rotation",
    "rbxassetid://103847676236765",
    "0 or 45 recommended",
    "Slider",
    0,
    0,
    360,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Static",
    "Static",
    "rbxassetid://17516823433",
    "Turns off all crosshair effects",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Show While Aiming",
    "Show While Aiming",
    "rbxassetid://122558543480189",
    "Keeps your crosshair visible while aiming",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Show While Inspecting",
    "Show While Inspecting",
    "rbxassetid://17513805400",
    "Keeps your crosshair visible while inspecting",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Override Shotgun",
    "Override Specials",
    "rbxassetid://119489313346738",
    "Allows you to use your custom crosshair for Shotgun, Shorty, etc",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Bars Enabled",
    "Bars Enabled",
    "rbxassetid://17516823503",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Bars Color",
    "Color",
    "rbxassetid://17516823503",
    "",
    "Color",
    "#ffffff"
)
add_setting(
    "Crosshair",
    "Crosshair Bars Spacing",
    "Spacing",
    "rbxassetid://17516823503",
    "",
    "Slider",
    16,
    0,
    64,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Bars Length",
    "Length",
    "rbxassetid://17516823503",
    "",
    "Slider",
    6,
    0,
    32,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Bars Thickness",
    "Thickness",
    "rbxassetid://17516823503",
    "",
    "Slider",
    2,
    0,
    32,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Bars Transparency",
    "Transparency",
    "rbxassetid://17516823503",
    "",
    "Slider",
    0,
    0,
    1,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Bars Shape",
    "Shape",
    "rbxassetid://17516823503",
    "",
    "Dropdown",
    "Sharp",
    { "Sharp", "Round" }
)
add_setting(
    "Crosshair",
    "Crosshair Bars Top Enabled",
    "Top Enabled",
    "rbxassetid://17564352694",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Bars Bottom Enabled",
    "Bottom Enabled",
    "rbxassetid://17564352775",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Bars Right Enabled",
    "Right Enabled",
    "rbxassetid://17564352879",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Bars Left Enabled",
    "Left Enabled",
    "rbxassetid://17564353047",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Dot Enabled",
    "Dot Enabled",
    "rbxassetid://17516823599",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Dot Color",
    "Color",
    "rbxassetid://17516823599",
    "",
    "Color",
    "#ffffff"
)
add_setting(
    "Crosshair",
    "Crosshair Dot Thickness",
    "Thickness",
    "rbxassetid://17516823599",
    "",
    "Slider",
    2,
    0,
    16,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Dot Transparency",
    "Transparency",
    "rbxassetid://17516823599",
    "",
    "Slider",
    0,
    0,
    1,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Dot Shape",
    "Shape",
    "rbxassetid://17516823599",
    "",
    "Dropdown",
    "Sharp",
    { "Sharp", "Round" }
)
add_setting(
    "Crosshair",
    "Crosshair Circle Enabled",
    "Circle Enabled",
    "rbxassetid://96264839713061",
    "",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Circle Color",
    "Color",
    "rbxassetid://96264839713061",
    "",
    "Color",
    "#ffffff"
)
add_setting(
    "Crosshair",
    "Crosshair Circle Size",
    "Size",
    "rbxassetid://96264839713061",
    "",
    "Slider",
    16,
    0,
    64,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Circle Thickness",
    "Thickness",
    "rbxassetid://96264839713061",
    "",
    "Slider",
    2,
    0,
    16,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Circle Transparency",
    "Transparency",
    "rbxassetid://96264839713061",
    "",
    "Slider",
    0,
    0,
    1,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Circle Shape",
    "Shape",
    "rbxassetid://96264839713061",
    "",
    "Dropdown",
    "Circle",
    { "Circle", "Round", "Sharp" }
)
add_setting(
    "Crosshair",
    "Crosshair Outline Enabled",
    "Outline Enabled",
    "rbxassetid://17516823683",
    "",
    "Toggle",
    false
)
add_setting(
    "Crosshair",
    "Crosshair Outline Color",
    "Color",
    "rbxassetid://17516823683",
    "",
    "Color",
    "#000000"
)
add_setting(
    "Crosshair",
    "Crosshair Outline Thickness",
    "Thickness",
    "rbxassetid://17516823683",
    "",
    "Slider",
    1,
    0,
    16,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Outline Transparency",
    "Transparency",
    "rbxassetid://17516823683",
    "",
    "Slider",
    0,
    0,
    1,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Outline Type",
    "Type",
    "rbxassetid://17516823683",
    "",
    "Dropdown",
    "Miter",
    { "Miter", "Round", "Bevel" }
)
add_setting(
    "Crosshair",
    "Crosshair - Hitmarker",
    "Hitmarker",
    "",
    "",
    "Divider"
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Enabled",
    "Enabled",
    "rbxassetid://93990674888427",
    "",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Scale",
    "Scale",
    "rbxassetid://115388073389430",
    "Make your hitmarker big or small",
    "Slider",
    1,
    0,
    4,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Rotation",
    "Rotation",
    "rbxassetid://103847676236765",
    "0 or 45 recommended",
    "Slider",
    0,
    0,
    360,
    1
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Transparency",
    "Transparency",
    "rbxassetid://91180498372634",
    "",
    "Slider",
    0,
    0,
    1,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Color",
    "Color",
    "rbxassetid://93990674888427",
    "",
    "Color",
    "#ffffff"
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Transparency Crit",
    "Critical Transparency",
    "rbxassetid://91180498372634",
    "",
    "Slider",
    0,
    0,
    1,
    20,
    true
)
add_setting(
    "Crosshair",
    "Crosshair Hitmarker Color Crit",
    "Critical Color",
    "rbxassetid://93990674888427",
    "",
    "Color",
    "#ff3232"
)
add_setting(
    "Crosshair",
    "Crosshair - Scoped",
    "Scoped",
    "",
    "",
    "Divider"
)
add_setting(
    "Crosshair",
    "Crosshair Scoped Bars",
    "Bars Enabled",
    "rbxassetid://87834608236137",
    "Turn this off to hide the bars while aiming with a scoped weapon",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Scoped Red Dot",
    "Dot Enabled",
    "rbxassetid://87834608236137",
    "Turn this off to hide the red dot while aiming with a scoped weapon",
    "Toggle",
    true
)
add_setting(
    "Crosshair",
    "Crosshair Scoped Red Dot Color",
    "Color",
    "rbxassetid://93990674888427",
    "Change the color of the red dot that scoped weapons display",
    "Color",
    "#ff3232"
)
add_setting(
    "Account",
    "Bounty Rewards Disabled",
    "Disable Bounty Rewards",
    "rbxassetid://133391928250838",
    "Prevents players from farming your charm, wrap, etc. We recommend keeping this setting off as much as possible",
    "Toggle",
    false
)
add_setting(
    "Account",
    "Staff Team Visuals",
    "Hide Team Visuals",
    "rbxassetid://95626460059631",
    "Hides your NG logo from showing up next to your name in the player list",
    "Toggle",
    false
)
add_setting(
    "Account",
    "Staff Team Tools Disabled",
    "Hide Team Tools",
    "rbxassetid://95626460059631",
    "Hides certain team tools that may be available to you from showing up in the topbar UI so that you can screenshare & record your gameplay without leaking anything",
    "Toggle",
    false
)
add_setting(
    "Account",
    "Staff Team Tools Disabled Leads",
    "Hide Team Lead Tools",
    "rbxassetid://95626460059631",
    "Hides team tools that only team leads can see. If you're not a team lead, this setting won't do anything",
    "Toggle",
    false
)
add_setting(
    "Account",
    "Staff Team Server Logs",
    "Hide Error Logs",
    "rbxassetid://95626460059631",
    "Prevents server error logs from showing up in the chat window",
    "Toggle",
    false
)
add_setting(
    "Account",
    "Staff Team Hidden Spectator",
    "Secret Spectator",
    "rbxassetid://95626460059631",
    "Hides you from the total spectators counter while spectating a duel that you're not a part of",
    "Toggle",
    false
)
add_setting(
    "Account",
    "Account - Notifications",
    "Notifications",
    "",
    "",
    "Divider"
)
add_setting(
    "Account",
    "Notifications Delivery",
    "Delivery Mode",
    "rbxassetid://96509180790493",
    "Change the way you receive notifications. Change this to \"Lobby\" if you prefer notifications to wait until you finish a duel. Change this to \"Muted\" if you want notifications to go straight into your Inbox",
    "Dropdown",
    "Instant",
    { "Instant", "Lobby", "Muted" }
)
add_setting(
    "Account",
    "Account - Privacy",
    "Privacy",
    "",
    "",
    "Divider"
)
add_setting(
    "Account",
    "Challenge Requests",
    "Challenge Requests",
    "rbxassetid://18525954682",
    "Allows players to send you 1v1 requests",
    "Dropdown",
    "Everyone",
    { "Everyone", "Friends", "Nobody" }
)
add_setting(
    "Account",
    "Party Invites",
    "Party Invites",
    "rbxassetid://118031781381166",
    "Allows players to send you invites to their party",
    "Dropdown",
    "Everyone",
    { "Everyone", "Friends", "Nobody" }
)
add_setting(
    "Account",
    "Receive Gifts",
    "Receive Gifts",
    "rbxassetid://127400882945494",
    "Allows you to receive gifts from other players",
    "Toggle",
    true
)
add_setting(
    "Touch",
    "Left Handed Touch Controls",
    "Left Handed Mode",
    "rbxassetid://98211826458757",
    "[Advanced] Mirrors the \"Joystick\" & the \"Double Tap To Attack\" hitboxes to better suit left handed players. Does not affect touch buttons",
    "Toggle",
    false
)
add_setting(
    "Touch",
    "Opaque Buttons While Scoped",
    "Opaque Buttons",
    "rbxassetid://87834608236137",
    "Turning this on makes all of your touch buttons opaque while scoped to help with visibility",
    "Toggle",
    true
)
add_setting(
    "Touch",
    "Mobile Buttons Transparency",
    "Buttons Transparency",
    "rbxassetid://129678163029799",
    "Changes the transparency of all of your touch buttons",
    "Slider",
    0.5,
    0,
    1,
    20,
    true
)
add_setting(
    "Touch",
    "Camera Mobile Button Sinking",
    "Buttons Camera Sinking",
    "rbxassetid://96518177763762",
    "[Advanced] While turned on, you can use a touch button and pan your camera at the same time",
    "Toggle",
    true
)
add_setting(
    "Touch",
    "Touch Button Ammo",
    "Show Weapon Ammo",
    "rbxassetid://16539130428",
    "Displays your weapon's ammo on the respective touch buttons to see from a quick glance",
    "Toggle",
    true
)

local function setup_hotkeys() -- line: 342
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] t_34 (copy)
    --  [3] add_hotkey_setting (copy)

    for index = CONSTANTS_m.MAX_EQUIPPABLE_EMOTES, 1, -1 do
        table.insert(
            t_34.HOTKEYS_GUIDE,
            table.find(t_34.HOTKEYS_GUIDE, "UseEmote") + 1,
            "UseEmote" .. index
        )
    end

    for _, val_4 in pairs(t_34.HOTKEYS_GUIDE) do
        if val_4 ~= "Divider" then
            add_hotkey_setting(val_4)
        end
    end
end

setup_hotkeys()

local function setup_touch() -- line: 358
    -- upvalues:
    --  [1] InputLibrary_m (copy)
    --  [2] t_1 (copy)
    --  [3] add_setting (copy)

    local t_59 = {}

    for key_5, _ in pairs(InputLibrary_m.MobileButtons) do
        table.insert(t_59, key_5)
    end

    table.sort(t_59, function(arg15, arg16) -- line: 367
        -- upvalues:
        --  [1] t_1 (ref)
        --  [2] InputLibrary_m (ref)

        return (table.find(t_1, InputLibrary_m.MobileButtons[arg15].InputName) or math.huge) < (table.find(
            t_1,
            InputLibrary_m.MobileButtons[arg16].InputName
        ) or math.huge) and true
    end)

    for _, val_6 in pairs(t_59) do
        local v27 = InputLibrary_m.MobileButtons[val_6]
        local DisplayName_1 = InputLibrary_m.Inputs[v27.InputName].DisplayName
        local v28 = "MobileButton " .. val_6
        add_setting(
            "Touch",
            "Touch" .. " - " .. DisplayName_1,
            DisplayName_1,
            v27.Image or "",
            "",
            "Divider"
        )

        if val_6 == "mobile_crouch" then
            add_setting(
                "Touch",
                "Easy Slide Mobile",
                "Easy Slide",
                "rbxassetid://17674207175",
                "[Advanced] While turned on, your Crouch button turns into a Slide button while sprinting. If you turn this off, you should enable the dedicated Slide button in your settings. Only available for Touch Controls",
                "Toggle",
                true
            )
        elseif val_6 == "mobile_jump" then
            add_setting(
                "Touch",
                "Auto Jump",
                "Auto Jump",
                "rbxassetid://18436038478",
                "Automatically jump near ledges & walls. Only available for Touch Controls",
                "Toggle",
                true
            )
        elseif val_6 == "mobile_shoot" then
            add_setting(
                "Touch",
                "Double Tap Shoot",
                "Double Tap To Attack",
                "rbxassetid://101488932151631",
                "While turned on, you can double tap the right half of your screen to attack",
                "Toggle",
                true
            )
            add_setting(
                "Touch",
                "Double Tap Shoot Window",
                "Double Tap Window",
                "rbxassetid://101488932151631",
                "[Advanced] How much time, in seconds, you have to tap again to start shooting",
                "Slider",
                0.25,
                0,
                1,
                20
            )
        end

        add_setting(
            "Touch",
            v28 .. " Enabled",
            "Enabled",
            "rbxassetid://77908042044589",
            "Allows you to turn this specific button on/off" .. (if val_6 == "mobile_slide" then ". Enabling this dedicated Slide button will override your Crouch button's Easy Slide setting" else ""),
            "Toggle",
            v27.DefaultVisibility
        )
        add_setting(
            "Touch",
            v28 .. " Override",
            "Custom",
            "rbxassetid://14641612286",
            "[Advanced] Turn this on to enable custom settings for this button specifically. This will override any global setting from above",
            "Toggle",
            false
        )
        add_setting(
            "Touch",
            v28 .. " Transparency",
            "Transparency",
            "rbxassetid://129678163029799",
            "[Advanced] Change the transparency of this button specifically",
            "Slider",
            0.5,
            0,
            1,
            20,
            true
        )
        add_setting(
            "Touch",
            v28 .. " Camera Sinking",
            "Camera Sinking",
            "rbxassetid://96518177763762",
            "[Advanced] While turned on, you can use pan your camera while using this button specifically at the same time",
            "Toggle",
            true
        )
    end
end

setup_touch()

local function setup_dependencies() -- line: 399
    -- upvalues:
    --  [1] InputLibrary_m (copy)
    --  [2] t_34 (copy)

    for key_7, _ in pairs(InputLibrary_m.MobileButtons) do
        local v31 = "MobileButton " .. key_7
        local _ = v31 .. " Enabled"
        local v33 = v31 .. " Override"

        for _, val_8 in pairs({ "Transparency", "Camera Sinking" }) do
            t_34.DEPENDENCIES[v31 .. " " .. val_8] = { v33, true }
        end
    end

    for _, val_9 in pairs({ "Bars", "Dot", "Circle", "Outline", "Hitmarker" }) do
        local v35 = "Crosshair " .. val_9
        local v36 = v35 .. " Enabled"
        local v37 = #val_9 + 10

        for _, val_10 in pairs(t_34.Order) do
            if val_10.Name ~= v36 and string.sub(val_10.Name, 1, v37) == v35 then
                t_34.DEPENDENCIES[val_10.Name] = { v36, true }
            end
        end
    end

    t_34.DEPENDENCIES["Crosshair Scoped Red Dot Color"] = { "Crosshair Scoped Red Dot", true }

    for _, val_11 in pairs(t_34.Order) do
        if
            not t_34.DEPENDENCIES[val_11.Name]
            and val_11.Name ~= "Crosshair Disabled"
            and val_11.Name ~= "Crosshair - Crosshair"
            and val_11.Name ~= "Crosshair - Hitmarker"
            and val_11.Name ~= "Crosshair - Scoped"
            and string.sub(val_11.Name, 1, 20) ~= "Crosshair Hitmarker "
            and string.sub(val_11.Name, 1, 17) ~= "Crosshair Scoped "
            and string.sub(val_11.Name, 1, 10) == "Crosshair "
        then
            t_34.DEPENDENCIES[val_11.Name] = { "Crosshair Disabled", false }
        end
    end
end

setup_dependencies()

return t_34
