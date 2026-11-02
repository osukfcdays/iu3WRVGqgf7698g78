local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local AnimationLibrary_m = require(ReplicatedStorage.Modules.AnimationLibrary)
local Medkit_m = require(Players.LocalPlayer.PlayerScripts.Modules.ViewModels.Medkit)
local _ = {
    "rbxassetid://74022970304005",
    "rbxassetid://111187699136127",
    "rbxassetid://112954097793399",
    "rbxassetid://130172392204108",
    "rbxassetid://77908437197378",
    "rbxassetid://74137744110473",
    "rbxassetid://107310976599084",
    "rbxassetid://81382682259697",
    "rbxassetid://96751920594258",
    "rbxassetid://106881280278820",
    "rbxassetid://128246615590458",
    "rbxassetid://113969192009519",
    "rbxassetid://136604786024861",
    "rbxassetid://107331047330856"
}
local t_1 = setmetatable({}, Medkit_m)
t_1.__index = t_1

function t_1.new(...) -- line: 22
    -- upvalues:
    --  [1] Medkit_m (copy)
    --  [2] t_1 (copy)

    local t_2 = setmetatable(Medkit_m.new(...), t_1)
    t_2._play_cat_gif_hash = 0
    t_2._cat_surface_gui = t_2.ItemModel:WaitForChild("MedkitTop"):WaitForChild("Screen"):WaitForChild(
        "CatGui"
    )
    t_2._cat_image_label = t_2._cat_surface_gui:WaitForChild("Frame"):WaitForChild("ImageLabel"):WaitForChild(
        "Picture"
    ):WaitForChild("ImageLabel")
    t_2._use_surface_gui = t_2.ItemModel:WaitForChild("MedkitTop"):WaitForChild("Screen"):WaitForChild(
        "UseGui"
    )
    t_2._use_bar = t_2._use_surface_gui:WaitForChild("Frame"):WaitForChild("Frame"):WaitForChild(
        "Bar"
    )
    t_2._use_text = t_2._use_surface_gui:WaitForChild("Frame"):WaitForChild("Progress")
    t_2._use_background = t_2._use_surface_gui:WaitForChild("Frame"):WaitForChild("ImageLabel")
    t_2._use_effect_hash = 0
    t_2._use_tween = nil
    t_2:_Init()

    return t_2
end

function t_1._CancelTween(arg1) -- line: 50
    if arg1._use_tween then
        arg1._use_tween:Pause()
        arg1._use_tween = nil
    end
end

function t_1._UpdateUseBar(arg2) -- line: 57
    arg2._use_text.Text = if arg2._use_bar.AbsoluteSize.X <= 1 then "\226\128\162 \226\128\162 \226\128\162" else math.floor(
        arg2._use_bar.AbsoluteSize.X / arg2._use_bar.Parent.AbsoluteSize.X * 100
    ) .. "%"
end

function t_1._UpdateUseGui(arg3) -- line: 61
    -- upvalues:
    --  [1] AnimationLibrary_m (copy)
    --  [2] TweenService (copy)

    arg3:_CancelTween()
    arg3._use_effect_hash += 1
    local UseEffectHash = arg3._use_effect_hash
    local v3 = arg3:IsAnimationPlaying("Use")
    local v4 = not v3 or arg3:IsAnimationPlaying("UseQuick")
    arg3._use_surface_gui.Enabled = v3 or v4

    if not arg3._use_surface_gui.Enabled then
        return
    end

    task.spawn(function() -- line: 74
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] UseEffectHash (copy)

        while true do
            if arg3._destroyed or arg3._use_effect_hash ~= UseEffectHash then
                break
            end

            arg3._use_background.Image = "rbxassetid://134936596399147"
            wait(0.1)

            if arg3._destroyed or arg3._use_effect_hash ~= UseEffectHash then
                return
            end

            arg3._use_background.Image = "rbxassetid://115756225131937"
            wait(0.1)
        end
    end)
    arg3._use_bar.Size = UDim2.new(0, 0, 1, 0)

    if v3 then
        local v5 = AnimationLibrary_m.Info[arg3.Info.Animations.Use]
        local v6 = 2.07765 / v5.Speed
        wait(v6)

        if arg3._destroyed or arg3._use_effect_hash ~= UseEffectHash then
            return
        end

        local v7 = TweenService
        local UseBar_1 = arg3._use_bar
        local tweenInfo = TweenInfo.new(
            v5.ActionTimestamp - v6,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )
        arg3._use_tween = v7:Create(UseBar_1, tweenInfo, { Size = UDim2.new(1, 0, 1, 0) })
        arg3._use_tween:Play()

        return
    end

    if v4 then
        wait(AnimationLibrary_m.Info[arg3.Info.Animations.UseQuick].ActionTimestamp)

        if arg3._destroyed or arg3._use_effect_hash ~= UseEffectHash then
            return
        end

        arg3._use_bar.Size = UDim2.new(1, 0, 1, 0)
    end
end

function t_1._UpdateCatGui(arg4) -- line: 117
    arg4._play_cat_gif_hash += 1
    local PlayCatGifHash = arg4._play_cat_gif_hash
    arg4._cat_surface_gui.Enabled = arg4:IsAnimationPlaying("RareInspect")

    if not arg4._cat_surface_gui.Enabled then
        return
    end

    local v8 = 1

    while true do
        if
            arg4._destroyed
            or not arg4:IsAnimationPlaying("RareInspect")
            or arg4._play_cat_gif_hash ~= PlayCatGifHash
        then
            break
        end

        local v9 = (v8 - 1) % 4
        local floorValue = math.floor((v8 - 1) / 4)
        arg4._cat_image_label.Position = UDim2.new(v9 * -1, 0, floorValue * -1, 0)
        v8 = v8 % 14 + 1
        wait(0.1)
    end
end

function t_1._Setup(arg5) -- line: 145
    arg5._cat_image_label.Image = "rbxassetid://120426879154579"
    arg5._cat_image_label.Size = UDim2.new(
        arg5._cat_image_label.Size.X.Scale * 4,
        arg5._cat_image_label.Size.X.Offset * 4,
        arg5._cat_image_label.Size.Y.Scale * 4,
        arg5._cat_image_label.Size.Y.Offset * 4
    )
end

function t_1._Init(arg6) -- line: 157
    arg6.AnimationPlayed:Connect(function(animationTrack: AnimationTrack) -- line: 158
        -- upvalues:
        --  [1] arg6 (copy)

        if animationTrack == "RareInspect" then
            arg6:_UpdateCatGui()

            return
        end

        if animationTrack == "Use" or animationTrack == "UseQuick" then
            arg6:_UpdateUseGui()
        end
    end)
    arg6.AnimationStopped:Connect(function(arg8) -- line: 166
        -- upvalues:
        --  [1] arg6 (copy)

        if arg8 == "RareInspect" then
            arg6:_UpdateCatGui()

            return
        end

        if arg8 == "Use" or arg8 == "UseQuick" then
            arg6:_UpdateUseGui()
        end
    end)
    arg6.Equipped:Connect(function() -- line: 174
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_CancelTween()
    end)
    arg6._use_bar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 178
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateUseBar()
    end)
    arg6:_Setup()
end

return t_1
