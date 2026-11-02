local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.MonetizationLibrary)
local Spring_m = require(ReplicatedStorage.Modules.Spring)
local StaticViewModel_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("StaticModel"):WaitForChild(
        "StaticViewModel"
    )
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local LooseWeaponDisplayParticles = Players.LocalPlayer.PlayerScripts.Assets.Misc:WaitForChild(
    "LooseWeaponDisplayParticles"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 16
    -- upvalues:
    --  [1] t (copy)
    --  [2] Spring_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.Model = arg1
    t_1.CurrentWeapon = nil
    t_1._primary = t_1.Model:WaitForChild("Primary")
    t_1._owned_model = t_1.Model:WaitForChild("Owned")
    t_1._origin = t_1._primary.CFrame
    t_1._static_viewmodel = nil
    t_1._proximity_prompt = Instance.new("ProximityPrompt")
    t_1._is_animating = nil
    t_1._animation_tick = 0
    t_1._spin_spring = Spring_m.new(1, 1, 5)
    t_1._return_to_normal_progress = 1
    t_1._return_to_normal_start = t_1._origin
    t_1._scale = 1
    t_1._proximity_prompt_object_text = nil
    t_1._proximity_prompt_action_text = nil
    t_1._proximity_prompt_next_update = 0
    t_1._is_locked = false
    t_1:_Init()

    return t_1
end

function t.SetScale(arg2, arg3) -- line: 47
    arg2._scale = arg3

    if arg2._static_viewmodel then
        arg2._static_viewmodel:ScaleTo(3 * arg2._scale)
    end
end

function t.SetProximityPromptData(arg4, arg5, arg6) -- line: 55
    arg4._proximity_prompt_object_text = arg5
    arg4._proximity_prompt_action_text = arg6
    arg4:_UpdateProximityPrompt()
end

function t.SetLocked(arg7, arg8) -- line: 61
    if arg8 == arg7._is_locked then
        return
    end

    arg7._is_locked = arg8

    if arg7._static_viewmodel then
        arg7._static_viewmodel:SetLocked(arg7._is_locked)
    end
end

function t.ChangeWeapon(arg9, arg10) -- line: 73
    -- upvalues:
    --  [1] StaticViewModel_m (copy)

    arg9.CurrentWeapon = arg9.Model:GetAttribute("PriorityWeapon") or arg10 or nil

    if arg9._static_viewmodel then
        arg9._static_viewmodel:Destroy()
        arg9._static_viewmodel = nil
    end

    arg9._owned_model.Parent = arg9.Model
    arg9._proximity_prompt.Parent = nil
    arg9._proximity_prompt:RemoveTag("LobbyOpenPagePrompt")
    arg9._proximity_prompt:SetAttribute("PageName", nil)
    arg9._proximity_prompt:SetAttribute("ShopViewBundleName", nil)

    if not arg9.CurrentWeapon then
        arg9:_SetAnimating(false)

        return
    end

    arg9._owned_model.Parent = nil
    arg9._static_viewmodel = StaticViewModel_m.new(arg9.CurrentWeapon)
    arg9._static_viewmodel:DeleteAnimationContextSubModels("ShowInEquipment")
    arg9._static_viewmodel:ScaleTo(3 * arg9._scale)
    arg9._static_viewmodel:SetLocked(arg9._is_locked)
    arg9._static_viewmodel:PivotTo(arg9._origin)
    arg9._static_viewmodel:SetParent(arg9.Model)
    arg9:_SetAnimating(false)
    arg9._proximity_prompt.Parent = arg9._primary
    arg9:_UpdateProximityPrompt()
end

function t.Update(arg11, arg12) -- line: 107
    -- upvalues:
    --  [1] TweenService (copy)

    if not arg11._is_animating then
        if arg11._static_viewmodel and arg11._return_to_normal_progress < 1 then
            arg11._return_to_normal_progress = math.min(
                1,
                arg11._return_to_normal_progress + arg12 * 0.25
            )
            arg11._static_viewmodel:PivotTo(
                arg11._return_to_normal_start:Lerp(
                    arg11._origin,
                    TweenService:GetValue(
                        arg11._return_to_normal_progress,
                        Enum.EasingStyle.Quint,
                        Enum.EasingDirection.Out
                    )
                )
            )
        end

        return
    end

    arg11._animation_tick += arg12 * 0.5
    local cframe = CFrame.Angles(
        0,
        arg11._spin_spring.Value * 3.141592653589793 * 2 + arg11._animation_tick % 6.283185307179586,
        0
    )
    local vec3 = Vector3.new(0, arg11._spin_spring.Value, 0)
    arg11._static_viewmodel:PivotTo(
        arg11._origin * arg11._primary.CFrame.Rotation:Inverse() * cframe * arg11._primary.CFrame.Rotation + vec3
    )

    if arg11._static_viewmodel then
        arg11._static_viewmodel:Update(arg12)
    end

    if tick() > arg11._proximity_prompt_next_update then
        arg11._proximity_prompt_next_update = tick() + 1
        arg11:_UpdateProximityPrompt()
    end
end

function t._UpdateProximityPrompt(arg13) -- line: 138
    local ProximityPrompt = arg13._proximity_prompt
    ProximityPrompt.ObjectText = typeof(arg13._proximity_prompt_object_text) == "function" and arg13._proximity_prompt_object_text() or arg13._proximity_prompt_object_text or arg13.CurrentWeapon or ""
    local ProximityPrompt_1 = arg13._proximity_prompt
    ProximityPrompt_1.ActionText = typeof(arg13._proximity_prompt_action_text) == "function" and arg13._proximity_prompt_action_text() or arg13._proximity_prompt_action_text or "View"
end

function t._SetAnimating(arg14, arg15) -- line: 143
    arg14._is_animating = arg15

    if arg15 then
        arg14._spin_spring.Value = 0
        arg14._animation_tick = 0
    else
        arg14._return_to_normal_progress = 0
        arg14._return_to_normal_start = arg14._static_viewmodel and arg14._static_viewmodel:GetPivot() or CFrame.identity
    end

    for _, descendant in pairs(arg14._primary:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = arg15
        end
    end

    arg14:_UpdateProximityPrompt()
end

function t._Setup(arg16) -- line: 163
    -- upvalues:
    --  [1] LooseWeaponDisplayParticles (copy)

    arg16._proximity_prompt.ClickablePrompt = true
    arg16._proximity_prompt.Exclusivity = Enum.ProximityPromptExclusivity.OnePerButton
    arg16._proximity_prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    arg16._proximity_prompt.HoldDuration = 0
    arg16._proximity_prompt.MaxActivationDistance = 10
    arg16._proximity_prompt.KeyboardKeyCode = Enum.KeyCode.Q
    arg16._proximity_prompt.RequiresLineOfSight = false
    arg16._proximity_prompt.Style = Enum.ProximityPromptStyle.Custom
    local Primary = arg16._primary
    Primary.CFrame += Vector3.new(0, 2.5, 0)

    for _, child in pairs(LooseWeaponDisplayParticles:GetChildren()) do
        child:Clone().Parent = arg16._primary
    end
end

function t._Init(arg17) -- line: 180
    -- upvalues:
    --  [1] Equipment_m (copy)

    arg17._proximity_prompt.Triggered:Connect(function() -- line: 181
        -- upvalues:
        --  [1] Equipment_m (ref)
        --  [2] arg17 (copy)

        Equipment_m:Open()
        Equipment_m:SelectWeapon(arg17.CurrentWeapon)
    end)
    arg17._proximity_prompt.PromptShown:Connect(function() -- line: 186
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_SetAnimating(true)
    end)
    arg17._proximity_prompt.PromptHidden:Connect(function() -- line: 190
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:_SetAnimating(false)
    end)
    arg17:_Setup()
    arg17:_UpdateProximityPrompt()
    arg17:ChangeWeapon(nil)
end

return t
