local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local BaseTower_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.Maps:WaitForChild("BaseTower")
)
local t = {
    CameraAnimationID = "rbxassetid://91304936355794",
    PlayersAnimationIDs = {
        "rbxassetid://72779372805547",
        "rbxassetid://85372225938107",
        "rbxassetid://76166033125093",
        "rbxassetid://72705430483246"
    },
    MinibossAnimationID = "rbxassetid://110702524889355",
    FOVMarkers = { { 0, 27, true } }
}
local t_4 = {
    CameraAnimationID = "rbxassetid://140630537896995",
    PlayersAnimationIDs = {
        "rbxassetid://73765092682746",
        "rbxassetid://128251419280478",
        "rbxassetid://87644263623750",
        "rbxassetid://81457379942058"
    },
    MinibossAnimationID = "rbxassetid://119161985796057",
    FOVMarkers = {
        { 0, 30, true },
        { 3.117, 30, true },
        { 5.217, 60 },
        { 9.342, 60, nil, Enum.EasingStyle.Linear },
        { 14.333, 40 }
    }
}
local t_12 = { Solo = nil, Team = nil }
local t_13 = {
    CameraAnimationID = "rbxassetid://76004085070158",
    PlayersAnimationIDs = { "rbxassetid://128423516380583" },
    FOVMarkers = { { 0, 30 } }
}
t_12.Solo = t_13
local t_17 = {
    CameraAnimationID = "rbxassetid://74541276024086",
    PlayersAnimationIDs = {
        "rbxassetid://87817454386868",
        "rbxassetid://85214705237146",
        "rbxassetid://85463328453593",
        "rbxassetid://83557814004483"
    },
    FOVMarkers = { { 0, 30 } }
}
t_12.Team = t_17
local t_21 = {
    CameraAnimationID = "rbxassetid://82721596198038",
    PlayersAnimationIDs = {
        "rbxassetid://132478476724070",
        "rbxassetid://87448134299264",
        "rbxassetid://125622174653361",
        "rbxassetid://115710864051370"
    },
    BossAnimationID = "rbxassetid://82940353328327",
    DestructionAnimationID = "rbxassetid://108906257884198",
    FOVMarkers = {
        { 0, 50, true },
        { 4.017, 65, true },
        { 19.333, 20, true },
        { 20.7, 20, true },
        { 21.533, 20 },
        { 22.367, 20, true },
        { 23.567, 50 },
        { 24.533, 45, true }
    }
}
local t_32 = {
    CameraAnimationID = "rbxassetid://124109678261806",
    PlayersAnimationIDs = {
        "rbxassetid://73225171387600",
        "rbxassetid://93554947024541",
        "rbxassetid://124961338872440",
        "rbxassetid://106248403628647"
    },
    BossAnimationID = "rbxassetid://137814878872905",
    FOVMarkers = { { 0, 60 } }
}
local t_36 = {
    "rbxassetid://105037817494559",
    "rbxassetid://85895097625020",
    "rbxassetid://107999335264095",
    "rbxassetid://72483809453170",
    "rbxassetid://129922197154277",
    "rbxassetid://113975047764762",
    "rbxassetid://119857994193720",
    "rbxassetid://128361063555965",
    "rbxassetid://79367345974451",
    "rbxassetid://130623066255489",
    "rbxassetid://89602387965260",
    "rbxassetid://134885608230805",
    "rbxassetid://104718122128210",
    "rbxassetid://134852748577803",
    "rbxassetid://85095991853139"
}
local t_37 = setmetatable({}, BaseTower_m)
t_37.__index = t_37

function t_37.new(...) -- line: 79
    -- upvalues:
    --  [1] BaseTower_m (copy)
    --  [2] t_37 (copy)

    local t_38 = setmetatable(BaseTower_m.new(...), t_37)
    t_38._cutscenes_folder = t_38.Model:WaitForChild("Cutscenes")
    t_38._cutscene_floor10_folder = t_38._cutscenes_folder:WaitForChild("Floor10")
    t_38._cutscene_floor10_camera_rig_animation_controller = t_38._cutscene_floor10_folder:WaitForChild(
        "CameraRig"
    ):WaitForChild("AnimationController")
    t_38._cutscene_floor17_folder = t_38._cutscenes_folder:WaitForChild("Floor17")
    t_38._cutscene_floor17_camera_rig_animation_controller = t_38._cutscene_floor17_folder:WaitForChild(
        "CameraRig"
    ):WaitForChild("AnimationController")
    t_38._cutscene_floor17_destruction_rig_animation_controller = t_38._cutscene_floor17_folder:WaitForChild(
        "DestructionRig"
    ):WaitForChild("AnimationController")
    t_38._use_custom_scoreboard_display = false
    t_38._triggers_found = {}
    t_38:_Init()

    return t_38
end

function t_37.GetScoreboardDisplay(arg1, ...) -- line: 100
    -- upvalues:
    --  [1] BaseTower_m (copy)

    if arg1._use_custom_scoreboard_display then
        return arg1.Name .. "   \226\128\162   Floor 0"
    end

    return BaseTower_m.GetScoreboardDisplay(arg1, ...)
end

function t_37.Update(arg2, _) -- line: 108
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] CollectionService (copy)

    local clampedValue = math.clamp(
        Utility_m:AngleBetweenVectors(
            workspace.CurrentCamera.CFrame.LookVector,
            Vector3.new(0, 1, 0)
        ) / 1.5707963267948966,
        0,
        1
    )

    for _, val in pairs(CollectionService:GetTagged("GargoyleTowerRain")) do
        if val:IsDescendantOf(arg2.Model) then
            local Lines = val:FindFirstChild("Lines")
            local Dots = val:FindFirstChild("Dots")

            if Lines then
                Lines.LocalTransparencyModifier = 1 - clampedValue
            end

            if Dots then
                Dots.LocalTransparencyModifier = clampedValue
            end
        end
    end
end

function t_37.ReplicateFromServer(arg4, arg5, ...) -- line: 129
    -- upvalues:
    --  [1] BaseTower_m (copy)

    if arg5 == "GargoyleTowerPlayCutsceneFloor10MinibossReveal" then
        if not arg4:IsRendered() then
            return
        end

        arg4:_PlayCutsceneFloor10MinibossReveal(...)

        return
    elseif arg5 == "GargoyleTowerPlayCutsceneFloor10MinibossDeath" then
        if not arg4:IsRendered() then
            return
        end

        arg4:_PlayCutsceneFloor10MinibossDeath(...)

        return
    elseif arg5 == "GargoyleTowerPlayCutsceneFloor17Intro" then
        if not arg4:IsRendered() then
            return
        end

        arg4:_PlayCutsceneFloor17Intro(...)

        return
    elseif arg5 == "GargoyleTowerPlayCutsceneFloor17BossReveal" then
        if not arg4:IsRendered() then
            return
        end

        arg4:_PlayCutsceneFloor17BossReveal(...)

        return
    elseif arg5 == "GargoyleTowerPlayCutsceneFloor17Falling" then
        if not arg4:IsRendered() then
            return
        end

        arg4:_PlayCutsceneFloor17Falling(...)

        return
    else
        BaseTower_m.ReplicateFromServer(arg4, arg5, ...)

        return
    end
end

function t_37._PlayCutsceneFloor10MinibossDeath(arg6, arg7, arg8) -- line: 169
    -- upvalues:
    --  [1] t_4 (copy)

    for _, val_1 in pairs(arg8:GetPlayingAnimationTracks()) do
        val_1:Stop(0)
    end

    local function init_callback(_) -- line: 174
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] arg8 (copy)

        arg6.CutsceneLogic:PlayAnimation(arg8, arg6.CutsceneLogic:GetPreloadedAnimation(
            "GargoyleTowerFloor10MinibossDeathMiniboss"
        ), function(_) -- line: 175
            -- upvalues:
            --  [1] arg6 (ref)

            wait(2)
            arg6:CreateSound(
                "rbxassetid://85095991853139",
                2 + 0.25 * math.random(),
                0.7 + 0.1 * math.random(),
                script,
                true
            )
            arg6:CreateSound(
                "rbxassetid://85095991853139",
                3 + 0.25 * math.random(),
                1.25 + 0.1 * math.random(),
                script,
                true
            )
            wait(2)
            arg6:CreateSound(
                "rbxassetid://104718122128210",
                1 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(0.825)
            arg6:CreateSound(
                "rbxassetid://104718122128210",
                1.25 + 0.25 * math.random(),
                1.5 + 0.2 * math.random(),
                script,
                true
            )
        end)
    end

    local function renderstep_callback(_) -- line: 186
    end

    arg6.CutsceneLogic:PlayCutscene(
        arg7,
        init_callback,
        renderstep_callback,
        arg6._cutscene_floor10_camera_rig_animation_controller,
        arg6.CutsceneLogic:GetPreloadedAnimation("GargoyleTowerFloor10MinibossDeathCamera"),
        t_4.FOVMarkers,
        #t_4.PlayersAnimationIDs,
        "GargoyleTowerFloor10MinibossDeathPlayer",
        false
    )
end

function t_37._PlayCutsceneFloor10MinibossReveal(arg12, arg13, arg14) -- line: 205
    -- upvalues:
    --  [1] t (copy)

    task.spawn(function() -- line: 206
        -- upvalues:
        --  [1] arg12 (copy)

        arg12.Model.Cutscenes.Floor10["Giant Gargoyle Statue"]:Destroy()
    end)

    local function init_callback_1(_) --[[ init_callback ]] -- line: 210
        -- upvalues:
        --  [1] arg12 (copy)
        --  [2] arg14 (copy)

        arg12.CutsceneLogic:PlayAnimation(arg14, arg12.CutsceneLogic:GetPreloadedAnimation(
            "GargoyleTowerFloor10MinibossRevealMiniboss"
        ), function(_) -- line: 211
            -- upvalues:
            --  [1] arg12 (ref)

            wait(6.8)
            arg12:CreateSound(
                "rbxassetid://134852748577803",
                3 + 0.2 * math.random(),
                0.3 + 0.05 * math.random(),
                script,
                true
            )
            wait(8.5)
            arg12:CreateSound(
                "rbxassetid://79367345974451",
                0.6 + 0.2 * math.random(),
                1.25 + 0.2 * math.random(),
                script,
                true
            )
            arg12:CreateSound(
                "rbxassetid://130623066255489",
                0.6 + 0.2 * math.random(),
                1.25 + 0.2 * math.random(),
                script,
                true
            )
            arg12:CreateSound(
                "rbxassetid://89602387965260",
                0.6 + 0.2 * math.random(),
                1.25 + 0.2 * math.random(),
                script,
                true
            )
            wait(3.42)
            arg12:CreateSound(
                "rbxassetid://72483809453170",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(1.4)
            arg12:CreateSound(
                "rbxassetid://104718122128210",
                0.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(1)
            arg12:CreateSound(
                "rbxassetid://85095991853139",
                2.5 + 0.25 * math.random(),
                0.7 + 0.1 * math.random(),
                script,
                true
            )
        end)
    end

    local function renderstep_callback_1(_) --[[ renderstep_callback ]] -- line: 227
    end

    arg12.CutsceneLogic:PlayCutscene(
        arg13,
        init_callback_1,
        renderstep_callback_1,
        arg12._cutscene_floor10_camera_rig_animation_controller,
        arg12.CutsceneLogic:GetPreloadedAnimation("GargoyleTowerFloor10MinibossRevealCamera"),
        t.FOVMarkers,
        #t.PlayersAnimationIDs,
        "GargoyleTowerFloor10MinibossRevealPlayer",
        false
    )
end

function t_37._ShouldUseSoloCutsceneAnimations(arg18) -- line: 246
    local v42 = 0

    for _, val_2 in pairs(arg18.ClientDuel:GetFighters()) do
        v42 += if val_2:IsAlive() then 1 else 0
    end

    return v42 <= 1
end

function t_37._PlayCutsceneFloor17Intro(arg19, arg20) -- line: 256
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] t_12 (copy)

    local v46 = if arg19:_ShouldUseSoloCutsceneAnimations() then "Solo" else "Team"

    local function init_callback_2(_) --[[ init_callback ]] -- line: 259
        -- upvalues:
        --  [1] Lighting (ref)
        --  [2] BetterDebris_m (ref)
        --  [3] arg20 (copy)
        --  [4] Utility_m (ref)

        task.delay(25, function() -- line: 260
            -- upvalues:
            --  [1] Lighting (ref)
            --  [2] BetterDebris_m (ref)
            --  [3] arg20 (ref)
            --  [4] Utility_m (ref)

            local GargoyleTowerCutsceneFloor17Intro_ColorCorrectionEffect = Instance.new(
                "ColorCorrectionEffect"
            )
            GargoyleTowerCutsceneFloor17Intro_ColorCorrectionEffect.Name = "GargoyleTowerCutsceneFloor17Intro"
            GargoyleTowerCutsceneFloor17Intro_ColorCorrectionEffect.Parent = Lighting
            BetterDebris_m:AddItem(
                GargoyleTowerCutsceneFloor17Intro_ColorCorrectionEffect,
                arg20 - 25
            )
            Utility_m:RenderstepForLoop(0, 100, 2, function(arg22) -- line: 266
                -- upvalues:
                --  [1] GargoyleTowerCutsceneFloor17Intro_ColorCorrectionEffect (copy)

                GargoyleTowerCutsceneFloor17Intro_ColorCorrectionEffect.Brightness = 0 + -1 * (arg22 / 100) ^ 4
            end)
        end)
    end

    local function renderstep_callback_2(_) --[[ renderstep_callback ]] -- line: 274
    end

    local v48 = "GargoyleTowerFloor17Intro" .. v46 .. "Camera"
    local CutsceneLogic_4 = arg19.CutsceneLogic
    local CutsceneFloor17CameraRigAnimationController = arg19._cutscene_floor17_camera_rig_animation_controller
    local v49 = arg19.CutsceneLogic:GetPreloadedAnimation(v48)
    CutsceneLogic_4:PlayCutscene(
        arg20,
        init_callback_2,
        renderstep_callback_2,
        CutsceneFloor17CameraRigAnimationController,
        v49,
        t_12[v46].FOVMarkers,
        #t_12[v46].PlayersAnimationIDs,
        "GargoyleTowerFloor17Intro" .. v46 .. "Player",
        false
    )
end

function t_37._PlayCutsceneFloor17BossReveal(arg24, arg25, arg26) -- line: 293
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] t_21 (copy)

    task.spawn(function() -- line: 294
        -- upvalues:
        --  [1] arg24 (copy)

        arg24.Model.Cutscenes.Floor17["Giant Acidic Gargoyle Statue"]:Destroy()
    end)

    local function init_callback_3(arg27) --[[ init_callback ]] -- line: 298
        -- upvalues:
        --  [1] arg24 (copy)
        --  [2] arg26 (copy)
        --  [3] arg25 (copy)
        --  [4] Lighting (ref)
        --  [5] BetterDebris_m (ref)
        --  [6] Utility_m (ref)

        arg24.CutsceneLogic:PlayAnimation(arg26, arg24.CutsceneLogic:GetPreloadedAnimation(
            "GargoyleTowerFloor17BossRevealBoss"
        ), function(_) -- line: 299
            -- upvalues:
            --  [1] arg24 (ref)

            wait(8.5)
            arg24:CreateSound(
                "rbxassetid://79367345974451",
                0.8 + 0.2 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            arg24:CreateSound(
                "rbxassetid://130623066255489",
                0.8 + 0.2 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            arg24:CreateSound(
                "rbxassetid://89602387965260",
                0.8 + 0.2 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(9.75)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(0.75)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(0.33)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(0.42)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(0.5)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(1.25)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(0.83)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(1.33)
            arg24:CreateSound(
                "rbxassetid://128361063555965",
                2.25 + 0.25 * math.random(),
                1.25 + 0.2 * math.random(),
                script,
                true
            )
        end)
        arg24.CutsceneLogic:PlayAnimation(arg24._cutscene_floor17_destruction_rig_animation_controller, arg24.CutsceneLogic:GetPreloadedAnimation(
            "GargoyleTowerFloor17BossRevealDestruction"
        ), function(_) -- line: 322
            -- upvalues:
            --  [1] arg24 (ref)

            wait(13.65)
            arg24:CreateSound(
                "rbxassetid://105037817494559",
                1,
                1,
                script,
                true
            )
            arg24:CreateSound(
                "rbxassetid://85895097625020",
                1,
                0.75,
                script,
                true
            )
            wait(11.35)
            arg24:CreateSound(
                "rbxassetid://107999335264095",
                0.75,
                1,
                script,
                true
            )
            arg24:CreateSound(
                "rbxassetid://107999335264095",
                1,
                0.75,
                script,
                true
            )
        end)
        task.delay(13.65, function() -- line: 331
            -- upvalues:
            --  [1] arg27 (copy)
            --  [2] arg24 (ref)

            if arg27 ~= arg24.CutsceneLogic:GetCutsceneHash() then
                return
            end

            arg24._cutscene_floor17_folder.Roof.Broken.Transparency = arg24._cutscene_floor17_folder.Roof.Unbroken.Transparency
            arg24._cutscene_floor17_folder.Roof.Unbroken.Transparency = 1
            local t_39 = {}

            for _, val_3 in pairs(arg24.Model.Extra:GetDescendants()) do
                if val_3:IsA("ParticleEmitter") then
                    t_39[val_3] = { "TimeScale", val_3.TimeScale }
                    val_3.TimeScale *= 0.1
                elseif val_3:IsA("Beam") then
                    t_39[val_3] = { "TextureSpeed", val_3.TextureSpeed }
                    val_3.TextureSpeed *= 0.1
                end
            end

            wait(4.35)

            for key_4, val_4 in pairs(t_39) do
                key_4[val_4[1]] = val_4[2]
            end
        end)
        task.delay(arg25 - 2, function() -- line: 359
            -- upvalues:
            --  [1] Lighting (ref)
            --  [2] BetterDebris_m (ref)
            --  [3] Utility_m (ref)

            local ColorCorrectionEffect_1 = Instance.new("ColorCorrectionEffect")
            ColorCorrectionEffect_1.Name = "GargoyleTowerCutsceneFloor17BossReveal"
            ColorCorrectionEffect_1.Parent = Lighting
            BetterDebris_m:AddItem(ColorCorrectionEffect_1, 10)
            Utility_m:RenderstepForLoop(0, 100, 2, function(arg30) -- line: 365
                -- upvalues:
                --  [1] ColorCorrectionEffect_1 (copy)

                ColorCorrectionEffect_1.Brightness = 0 + -1 * (arg30 / 100) ^ 4
            end)
            wait(2)
            Utility_m:RenderstepForLoop(0, 100, 2, function(arg31) -- line: 373
                -- upvalues:
                --  [1] ColorCorrectionEffect_1 (copy)

                ColorCorrectionEffect_1.Brightness = -1 + 1 * (1 - (1 - arg31 / 100) ^ 4)
            end)
            ColorCorrectionEffect_1:Destroy()
        end)
    end

    local function renderstep_callback_3(_) --[[ renderstep_callback ]] -- line: 383
    end

    local CutsceneLogic_7 = arg24.CutsceneLogic
    local CutsceneFloor17CameraRigAnimationController_1 = arg24._cutscene_floor17_camera_rig_animation_controller
    local GargoyleTowerFloor17BossRevealCamera = arg24.CutsceneLogic:GetPreloadedAnimation(
        "GargoyleTowerFloor17BossRevealCamera"
    )
    CutsceneLogic_7:PlayCutscene(
        arg25,
        init_callback_3,
        renderstep_callback_3,
        CutsceneFloor17CameraRigAnimationController_1,
        GargoyleTowerFloor17BossRevealCamera,
        t_21.FOVMarkers,
        #t_21.PlayersAnimationIDs,
        "GargoyleTowerFloor17BossRevealPlayer",
        false
    )
end

function t_37._PlayCutsceneFloor17Falling(arg33, arg34, arg35) -- line: 402
    -- upvalues:
    --  [1] Lighting (copy)
    --  [2] BetterDebris_m (copy)
    --  [3] Utility_m (copy)
    --  [4] t_32 (copy)

    arg33._use_custom_scoreboard_display = true

    local function init_callback_4(_) --[[ init_callback ]] -- line: 405
        -- upvalues:
        --  [1] arg33 (copy)
        --  [2] arg35 (copy)
        --  [3] arg34 (copy)
        --  [4] Lighting (ref)
        --  [5] BetterDebris_m (ref)
        --  [6] Utility_m (ref)

        arg33.CutsceneLogic:PlayAnimation(arg35, arg33.CutsceneLogic:GetPreloadedAnimation(
            "GargoyleTowerFloor17FallingBoss"
        ), function(_) -- line: 406
            -- upvalues:
            --  [1] arg33 (ref)

            local t_42 = {
                0.55,
                1.3,
                1.9,
                2.45,
                2.95,
                3.45,
                3.95,
                4.3,
                4.7,
                5.1,
                5.5,
                5.9,
                6.3,
                6.7,
                7.1
            }

            for key_5, val_5 in pairs(t_42) do
                wait(val_5 - (t_42[key_5 - 1] or 0))
                arg33:CreateSound(
                    "rbxassetid://72483809453170",
                    1.5 - 1 * key_5 / 18,
                    0.9 + 0.2 * math.random(),
                    script,
                    true
                )
            end
        end)
        task.delay(arg34 - 0.75, function() -- line: 415
            -- upvalues:
            --  [1] Lighting (ref)
            --  [2] BetterDebris_m (ref)
            --  [3] arg33 (ref)
            --  [4] Utility_m (ref)

            local ColorCorrectionEffect_2 = Instance.new("ColorCorrectionEffect")
            ColorCorrectionEffect_2.Name = "GargoyleTowerCutsceneFloor17Falling"
            ColorCorrectionEffect_2.Brightness = -1
            ColorCorrectionEffect_2.Parent = Lighting
            BetterDebris_m:AddItem(ColorCorrectionEffect_2, 10)
            arg33:CreateSound(
                "rbxassetid://72483809453170",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            arg33:CreateSound(
                "rbxassetid://129922197154277",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            arg33:CreateSound(
                "rbxassetid://113975047764762",
                1.5 + 0.25 * math.random(),
                0.9 + 0.2 * math.random(),
                script,
                true
            )
            wait(1)
            Utility_m:RenderstepForLoop(0, 100, 0.5, function(arg38) -- line: 428
                -- upvalues:
                --  [1] ColorCorrectionEffect_2 (copy)

                local v102 = arg38 / 100
                ColorCorrectionEffect_2.Brightness = -1 + 1 * (math.sin(12.566370614359172 * v102) * 0.125 + v102)
            end)
            ColorCorrectionEffect_2:Destroy()
        end)
    end

    local function renderstep_callback_4(_) --[[ renderstep_callback ]] -- line: 439
    end

    local CutsceneLogic_9 = arg33.CutsceneLogic
    local CutsceneFloor17CameraRigAnimationController_2 = arg33._cutscene_floor17_camera_rig_animation_controller
    local GargoyleTowerFloor17FallingCamera = arg33.CutsceneLogic:GetPreloadedAnimation(
        "GargoyleTowerFloor17FallingCamera"
    )
    CutsceneLogic_9:PlayCutscene(
        arg34,
        init_callback_4,
        renderstep_callback_4,
        CutsceneFloor17CameraRigAnimationController_2,
        GargoyleTowerFloor17FallingCamera,
        t_32.FOVMarkers,
        #t_32.PlayersAnimationIDs,
        "GargoyleTowerFloor17FallingPlayer",
        false
    )
end

function t_37._Floor17LeverTriggerAdded(arg40, arg41) -- line: 458
    -- upvalues:
    --  [1] Utility_m (copy)

    if arg40._triggers_found[arg41] or not arg41:IsDescendantOf(arg40.Model) then
        return
    end

    arg40._triggers_found[arg41] = true
    local v104 = false

    local function check() -- line: 467
        -- upvalues:
        --  [1] v104 (ref)
        --  [2] arg41 (copy)
        --  [3] arg40 (copy)
        --  [4] Utility_m (ref)

        if v104 or not arg41:GetAttribute("Triggered") then
            return
        end

        v104 = true
        arg40.Model.Cutscenes.Floor17.Lever:PivotTo(
            arg40.Model.Cutscenes.Floor17.Lever:GetPivot() * CFrame.Angles(
                -1.1344640137963142,
                0,
                0
            )
        )
        arg40.Model.Cutscenes.Floor17.Lever.Particles:Destroy()
        arg40:CreateSound(
            "rbxassetid://119857994193720",
            1.25,
            1,
            script,
            true
        )
        local t_43 = {}

        for _, child in pairs(arg40.Model.Cutscenes.Floor17.AcidTubes:GetChildren()) do
            table.insert(t_43, { child, child.Size, child.CFrame })
        end

        Utility_m:RenderstepForLoop(0, 100, 0.1, function(arg42) -- line: 484
            -- upvalues:
            --  [1] t_43 (copy)

            local v107 = 1 - arg42 / 100

            for _, val_6 in pairs(t_43) do
                val_6[1].Size = val_6[2] * Vector3.new(v107, 1, 1)
                val_6[1].CFrame = val_6[3] * CFrame.new(val_6[2].X / 2 - val_6[1].Size.X / 2, 0, 0)
            end
        end)

        for _, val_7 in pairs(t_43) do
            val_7[1].Transparency = 1
        end
    end

    arg41:GetAttributeChangedSignal("Triggered"):Connect(check)
    check()
end

function t_37._Floor15GateTriggerAdded(arg43, arg44) -- line: 502
    if arg43._triggers_found[arg44] or not arg44:IsDescendantOf(arg43.Model) then
        return
    end

    arg43._triggers_found[arg44] = true
    local v113 = false

    local function check_1() --[[ check ]] -- line: 511
        -- upvalues:
        --  [1] v113 (ref)
        --  [2] arg44 (copy)
        --  [3] arg43 (copy)

        if v113 or not arg44:GetAttribute("Triggered") then
            return
        end

        v113 = true
        arg43.Model.Floors["15"].Important.Gates:PivotTo(
            arg43.Model.Floors["15"].Important.Gates:GetPivot() + Vector3.new(0, 20, 0)
        )
        arg43:CreateSound(
            "rbxassetid://134885608230805",
            2,
            1,
            script,
            true
        )
    end

    arg44:GetAttributeChangedSignal("Triggered"):Connect(check_1)
    check_1()
end

function t_37._Floor11EntranceParticlesAdded(arg45, arg46) -- line: 526
    -- upvalues:
    --  [1] Utility_m (copy)

    if not arg46:IsDescendantOf(arg45.Model) then
        return
    end

    task.delay(0, Utility_m.PlayParticles, Utility_m, arg46)
    arg45:CreateSound(
        "rbxassetid://72483809453170",
        1.5,
        0.9 + 0.2 * math.random(),
        script,
        true
    )
end

function t_37._Setup(arg47) -- line: 535
    -- upvalues:
    --  [1] t (copy)
    --  [2] t_4 (copy)
    --  [3] t_12 (copy)
    --  [4] t_21 (copy)
    --  [5] t_32 (copy)
    --  [6] t_36 (copy)

    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor10MinibossRevealCamera",
        t.CameraAnimationID
    )
    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor10MinibossRevealMiniboss",
        t.MinibossAnimationID
    )

    for key_9, val_8 in pairs(t.PlayersAnimationIDs) do
        arg47.CutsceneLogic:PreloadAnimation(
            "GargoyleTowerFloor10MinibossRevealPlayer" .. key_9,
            val_8
        )
    end

    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor10MinibossDeathCamera",
        t_4.CameraAnimationID
    )
    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor10MinibossDeathMiniboss",
        t_4.MinibossAnimationID
    )

    for key_10, val_9 in pairs(t_4.PlayersAnimationIDs) do
        arg47.CutsceneLogic:PreloadAnimation(
            "GargoyleTowerFloor10MinibossDeathPlayer" .. key_10,
            val_9
        )
    end

    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor17IntroSoloCamera",
        t_12.Solo.CameraAnimationID
    )

    for key_11, val_10 in pairs(t_12.Solo.PlayersAnimationIDs) do
        arg47.CutsceneLogic:PreloadAnimation(
            "GargoyleTowerFloor17IntroSoloPlayer" .. key_11,
            val_10
        )
    end

    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor17IntroTeamCamera",
        t_12.Team.CameraAnimationID
    )

    for key_12, val_11 in pairs(t_12.Team.PlayersAnimationIDs) do
        arg47.CutsceneLogic:PreloadAnimation(
            "GargoyleTowerFloor17IntroTeamPlayer" .. key_12,
            val_11
        )
    end

    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor17BossRevealCamera",
        t_21.CameraAnimationID
    )
    arg47.CutsceneLogic:PreloadAnimation("GargoyleTowerFloor17BossRevealBoss", t_21.BossAnimationID)
    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor17BossRevealDestruction",
        t_21.DestructionAnimationID
    )

    for key_13, val_12 in pairs(t_21.PlayersAnimationIDs) do
        arg47.CutsceneLogic:PreloadAnimation(
            "GargoyleTowerFloor17BossRevealPlayer" .. key_13,
            val_12
        )
    end

    arg47.CutsceneLogic:PreloadAnimation(
        "GargoyleTowerFloor17FallingCamera",
        t_32.CameraAnimationID
    )
    arg47.CutsceneLogic:PreloadAnimation("GargoyleTowerFloor17FallingBoss", t_32.BossAnimationID)

    for key_14, val_13 in pairs(t_32.PlayersAnimationIDs) do
        arg47.CutsceneLogic:PreloadAnimation("GargoyleTowerFloor17FallingPlayer" .. key_14, val_13)
    end

    arg47.CutsceneLogic:PreloadCutsceneSoundIDs(t_36)
end

function t_37._Init(arg48) -- line: 587
    -- upvalues:
    --  [1] CollectionService (copy)

    local Connections = arg48._connections
    local GargoyleTowerFloor17LeverTrigger = CollectionService:GetInstanceAddedSignal(
        "GargoyleTowerFloor17LeverTrigger"
    )
    table.insert(Connections, GargoyleTowerFloor17LeverTrigger:Connect(function(arg49) -- line: 588
        -- upvalues:
        --  [1] arg48 (copy)

        arg48:_Floor17LeverTriggerAdded(arg49)
    end))
    local Connections_1 = arg48._connections
    local GargoyleTowerFloor15GateTrigger = CollectionService:GetInstanceAddedSignal(
        "GargoyleTowerFloor15GateTrigger"
    )
    table.insert(Connections_1, GargoyleTowerFloor15GateTrigger:Connect(function(arg50) -- line: 592
        -- upvalues:
        --  [1] arg48 (copy)

        arg48:_Floor15GateTriggerAdded(arg50)
    end))
    local Connections_2 = arg48._connections
    local GargoyleTowerFloor11EntranceParticles = CollectionService:GetInstanceAddedSignal(
        "GargoyleTowerFloor11EntranceParticles"
    )
    table.insert(Connections_2, GargoyleTowerFloor11EntranceParticles:Connect(function(arg51) -- line: 596
        -- upvalues:
        --  [1] arg48 (copy)

        arg48:_Floor11EntranceParticlesAdded(arg51)
    end))
    local v122 = pairs
    local _ = GargoyleTowerFloor11EntranceParticles:Connect(function(arg51) -- line: 596
        -- upvalues:
        --  [1] arg48 (copy)

        arg48:_Floor11EntranceParticlesAdded(arg51)
    end)

    for _, val_14 in v122(CollectionService:GetTagged("GargoyleTowerFloor17LeverTrigger")) do
        task.defer(arg48._Floor17LeverTriggerAdded, arg48, val_14)
    end

    for _, val_15 in pairs(CollectionService:GetTagged("GargoyleTowerFloor15GateTrigger")) do
        task.defer(arg48._Floor15GateTriggerAdded, arg48, val_15)
    end

    for _, val_16 in pairs(CollectionService:GetTagged("GargoyleTowerFloor11EntranceParticles")) do
        task.defer(arg48._Floor11EntranceParticlesAdded, arg48, val_16)
    end

    arg48:_Setup()
    arg48.ClientDuel:SetReplicate("DuelMusic", "GargoyleTower")
end

return t_37
