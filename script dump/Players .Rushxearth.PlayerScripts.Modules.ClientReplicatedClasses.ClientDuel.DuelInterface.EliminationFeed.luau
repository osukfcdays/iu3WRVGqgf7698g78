local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ComplianceController
)
local Inset_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Inset)
local EliminationFeedSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "EliminationFeedSlot"
)
local t = {}
t.__index = t

function t.new(arg1) -- line: 17
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("EliminationFeed")
    t_1.List = t_1.Frame:WaitForChild("List")
    t_1._destroyed = false
    t_1._connections = {}
    t_1:_Init()

    return t_1
end

function t.PlayRaw(arg2, arg3) -- line: 36
    -- upvalues:
    --  [1] DuelLibrary_m (copy)
    --  [2] ItemLibrary_m (copy)
    --  [3] EliminationFeedSlot (copy)
    --  [4] BetterDebris_m (copy)
    --  [5] Players (copy)

    local v1 = arg3 or {}
    v1.State = v1.State or "Default"
    v1.VictimText = v1.VictimText or "???"
    v1.VictimTeamColor = v1.VictimTeamColor or DuelLibrary_m.EMPTY_TEAM_COLOR
    v1.EliminatorText = v1.EliminatorText or "???"
    v1.EliminatorTeamColor = v1.EliminatorTeamColor or DuelLibrary_m.EMPTY_TEAM_COLOR
    v1.ViewModelName = v1.ViewModelName or nil
    v1.IsCritical = v1.IsCritical or false
    v1.IsBlinded = v1.IsBlinded or false
    v1.IsNoscope = v1.IsNoscope or false
    local v3 = v1.ViewModelName

    if v3 then
        v3 = ItemLibrary_m.ViewModels[v1.ViewModelName]
    end

    local v4 = v3 and v3.EliminationFeedImage or "rbxassetid://91284037292220"
    local v5 = v3 and v3.EliminationFeedImageScale or 1.5
    v3 = EliminationFeedSlot:Clone()
    v3.Container.Container.Eliminator.TextLabel.Text = v1.EliminatorText or ""
    v3.Container.Container.Eliminator.Visible = if v3.Container.Container.Eliminator.TextLabel.Text == "" then false else true
    v3.Container.Container.Victim.TextLabel.Text = v1.VictimText or "???"
    v3.Container.Container.Weapon.ImageLabel.Image = v4
    v3.Container.Container.Weapon.Size = UDim2.new(v5, 0, 1, 0)
    v3.Container.Container.Critical.Visible = v1.IsCritical
    v3.Container.Container.Blinded.Visible = v1.IsBlinded
    v3.Container.Container.Noscope.Visible = v1.IsNoscope
    local Outline = v3.Container.Background.Outline
    Outline.Visible = v1.State == "LocalElimination"
    local Container = v3.Container.Background.Background
    Container.ImageColor3 = if v1.State ~= "LocalDeath" then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(
        255,
        50,
        50
    ) or Color3.fromRGB(255, 255, 255)
    v3.Parent = arg2.List
    local v8 = BetterDebris_m
    v8:AddItem(v3, 10)
    v5 = v3.Container.Container.Weapon.ImageLabel
    v8 = false

    function v4() --[[ update ]] -- line: 71
        -- upvalues:
        --  [1] arg2 (copy)
        --  [2] v8 (ref)
        --  [3] v3 (copy)
        --  [4] v5 (copy)
        --  [5] v1 (copy)

        if arg2._destroyed or v8 then
            return
        end

        v8 = true
        task.defer(function() -- line: 82
            -- upvalues:
            --  [1] arg2 (ref)
            --  [2] v8 (ref)
            --  [3] v3 (ref)
            --  [4] v5 (ref)
            --  [5] v1 (ref)

            if arg2._destroyed then
                return
            end

            v8 = false
            v3.Container.Container.Eliminator.Size = UDim2.new(
                0,
                v3.Container.Container.Eliminator.TextLabel.TextBounds.X,
                0.625,
                0
            )
            v3.Container.Container.Victim.Size = UDim2.new(
                0,
                v3.Container.Container.Victim.TextLabel.TextBounds.X,
                0.625,
                0
            )
            v3.Size = UDim2.new(
                0,
                v3.Container.Container.Layout.AbsoluteContentSize.X,
                v3.Size.Y.Scale,
                0
            )
            local clampedValue = math.clamp(
                (v5.AbsolutePosition.X + v5.AbsoluteSize.X / 2 - v3.AbsolutePosition.X) / v3.AbsoluteSize.X,
                0.001,
                0.999
            )
            local UIGradient = v3.Container.Background.Background.UIGradient
            UIGradient.Color = if v1.State == "LocalDeath" then ColorSequence.new(
                Color3.fromRGB(255, 255, 255)
            ) or ColorSequence.new(
                {
                    ColorSequenceKeypoint.new(0, v1.EliminatorTeamColor),
                    ColorSequenceKeypoint.new(clampedValue, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, v1.VictimTeamColor)
                }
            ) else ColorSequence.new(
                {
                    ColorSequenceKeypoint.new(0, v1.EliminatorTeamColor),
                    ColorSequenceKeypoint.new(clampedValue, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, v1.VictimTeamColor)
                }
            )
            local UIGradient_1 = v3.Container.Background.Background.UIGradient
            UIGradient_1.Transparency = if v1.State == "LocalDeath" then NumberSequence.new(0) or NumberSequence.new(
                {
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(clampedValue, 0.25),
                    NumberSequenceKeypoint.new(1, 0)
                }
            ) else NumberSequence.new(
                {
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(clampedValue, 0.25),
                    NumberSequenceKeypoint.new(1, 0)
                }
            )
        end)
    end

    v3:GetPropertyChangedSignal("AbsoluteSize"):Connect(v4)
    v5:GetPropertyChangedSignal("AbsolutePosition"):Connect(v4)
    v5:GetPropertyChangedSignal("AbsoluteSize"):Connect(v4)
    v3.Container.Container.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v4)
    v3.Container.Container.Eliminator.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(v4)
    v3.Container.Container.Victim.TextLabel:GetPropertyChangedSignal("TextBounds"):Connect(v4)

    if not arg2._destroyed and not v8 then
        v8 = true
        task.defer(function() -- line: 82
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] v8 (ref)
            --  [3] v3 (copy)
            --  [4] v5 (copy)
            --  [5] v1 (copy)

            if arg2._destroyed then
                return
            end

            v8 = false
            v3.Container.Container.Eliminator.Size = UDim2.new(
                0,
                v3.Container.Container.Eliminator.TextLabel.TextBounds.X,
                0.625,
                0
            )
            v3.Container.Container.Victim.Size = UDim2.new(
                0,
                v3.Container.Container.Victim.TextLabel.TextBounds.X,
                0.625,
                0
            )
            v3.Size = UDim2.new(
                0,
                v3.Container.Container.Layout.AbsoluteContentSize.X,
                v3.Size.Y.Scale,
                0
            )
            local clampedValue_1 = math.clamp(
                (v5.AbsolutePosition.X + v5.AbsoluteSize.X / 2 - v3.AbsolutePosition.X) / v3.AbsoluteSize.X,
                0.001,
                0.999
            )
            local UIGradient_2 = v3.Container.Background.Background.UIGradient
            UIGradient_2.Color = if v1.State == "LocalDeath" then ColorSequence.new(
                Color3.fromRGB(255, 255, 255)
            ) or ColorSequence.new(
                {
                    ColorSequenceKeypoint.new(0, v1.EliminatorTeamColor),
                    ColorSequenceKeypoint.new(clampedValue_1, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, v1.VictimTeamColor)
                }
            ) else ColorSequence.new(
                {
                    ColorSequenceKeypoint.new(0, v1.EliminatorTeamColor),
                    ColorSequenceKeypoint.new(clampedValue_1, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, v1.VictimTeamColor)
                }
            )
            local UIGradient_3 = v3.Container.Background.Background.UIGradient
            UIGradient_3.Transparency = if v1.State == "LocalDeath" then NumberSequence.new(0) or NumberSequence.new(
                {
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(clampedValue_1, 0.25),
                    NumberSequenceKeypoint.new(1, 0)
                }
            ) else NumberSequence.new(
                {
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(clampedValue_1, 0.25),
                    NumberSequenceKeypoint.new(1, 0)
                }
            )
        end)
    end

    if v3:IsDescendantOf(Players.LocalPlayer) then
        v3.Container.Position = UDim2.new(1, 20, 0, 0)
        v3.Container:TweenPosition(
            UDim2.new(0, 0, 0, 0),
            "Out",
            "Quint",
            0.25,
            true
        )
    end

    task.delay(
        7,
        pcall,
        v3.Container.TweenPosition,
        v3.Container,
        UDim2.new(1, 20, 0, 0),
        "In",
        "Quint",
        0.25,
        true,
        function() -- line: 124
            -- upvalues:
            --  [1] arg2 (copy)
            --  [2] v3 (copy)

            if arg2._destroyed then
                return
            end

            v3:TweenSize(
                UDim2.new(),
                "Out",
                "Quint",
                0.25,
                true,
                function() -- line: 129
                    -- upvalues:
                    --  [1] arg2 (ref)
                    --  [2] v3 (ref)

                    if arg2._destroyed then
                        return
                    end

                    v3:Destroy()
                end
            )
        end
    )
end

function t.Play(
    arg4,
    arg5,
    arg6,
    arg7,
    arg8,
    arg9,
    arg10,
    arg11
) -- line: 139
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ComplianceController_m (copy)
    --  [3] DuelLibrary_m (copy)

    local t_6 = {}
    local v16 = if arg5 ~= Players.LocalPlayer then if arg6 == Players.LocalPlayer then "LocalElimination" else if arg7 ~= Players.LocalPlayer then "Default" else "LocalElimination" else "LocalDeath"
    t_6.State = v16
    v16 = arg5

    if v16 then
        v16 = ComplianceController_m:GetName(arg5)
    end

    t_6.VictimText = v16
    t_6.VictimTeamColor = DuelLibrary_m:GetTeamColor(arg5:GetAttribute("TeamID"))
    local v18 = arg6 and arg6 ~= arg5 and ComplianceController_m:GetName(arg6) or ""
    local v19 = arg7 and arg7 ~= arg6 and arg7 ~= arg5 and " + " .. ComplianceController_m:GetName(
        arg7
    ) or ""
    t_6.EliminatorText = v18 .. v19
    t_6.EliminatorTeamColor = DuelLibrary_m:GetTeamColor(arg6:GetAttribute("TeamID"))
    t_6.ViewModelName = arg8
    t_6.IsCritical = arg9
    t_6.IsBlinded = arg10
    t_6.IsNoscope = arg11
    arg4:PlayRaw(t_6)
end

function t.Update(arg12) -- line: 154
    local Frame = arg12.Frame
    local v21 = not arg12.DuelInterface:IsPageOpen()

    if v21 then
        v21 = not arg12.DuelInterface.FinalResults:IsActive()
    end

    Frame.Visible = v21
end

function t.UpdatePosition(arg13) -- line: 158
    -- upvalues:
    --  [1] Inset_m (copy)

    arg13.Frame.Position = UDim2.new(1, 0, 0, Inset_m.MainFrame.AbsoluteSize.Y)
end

function t.Destroy(arg14) -- line: 162
    arg14._destroyed = true

    for _, val in pairs(arg14._connections) do
        val:Disconnect()
    end

    arg14._connections = {}
end

function t._Debug(_) -- line: 176
end

function t._UpdatePosition(_) -- line: 203
end

function t._Init(arg17) -- line: 206
    arg17.DuelInterface.FinalResults.Activated:Connect(function() -- line: 207
        -- upvalues:
        --  [1] arg17 (copy)

        arg17:Update()
    end)
    arg17:UpdatePosition()
    task.defer(arg17._Debug, arg17)
end

return t
