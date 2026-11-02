local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local _ = require(ReplicatedStorage.Modules.CONSTANTS)
local ComplianceController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ComplianceController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local ArcadeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ArcadeController")
)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local EliminatedEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild(
        "EliminatedEffect"
    )
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {}
t.__index = t

function t._new() -- line: 18
    -- upvalues:
    --  [1] t (copy)
    --  [2] UILibrary_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.BottomStackFrame = UILibrary_m:GetTo("MainFrame", "BottomStack")
    t_1.BufferFrame = UILibrary_m:GetTo("MainFrame", "BottomStack", "SpectateBuffer")
    t_1.Frame = UILibrary_m:GetTo("MainFrame", "BottomStack", "Spectate")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.Background = t_1.Container:WaitForChild("Background")
    t_1.NextButton = t_1.Container:WaitForChild("Next")
    t_1.LastButton = t_1.Container:WaitForChild("Last")
    t_1.ExitButton = t_1.Container:WaitForChild("Exit")
    t_1.JoinButton = t_1.Container:WaitForChild("Join")
    t_1.JoinButtonOff = t_1.JoinButton:WaitForChild("Off")
    t_1.JoinButtonOffTitle = t_1.JoinButtonOff:WaitForChild("Title")
    t_1.JoinButtonOn = t_1.JoinButton:WaitForChild("On")
    t_1.JoinBubble = t_1.JoinButtonOn:WaitForChild("Bubble")
    t_1.PlayerText = t_1.Container:WaitForChild("Player")
    t_1.UsernameText = t_1.Container:WaitForChild("Username")
    t_1.FreecamButton = t_1.Container:WaitForChild("Freecam")
    t_1.ExitFreecamButton = t_1.Container:WaitForChild("ExitFreecam")
    t_1._duel_connections = {}
    t_1._fighter_connections = {}
    t_1._join_bubble_connection = nil
    t_1._join_bubble_hash = 0
    t_1:_Init()

    return t_1
end

function t._UpdateBuffer(arg1) -- line: 59
    -- upvalues:
    --  [1] SpectateController_m (copy)

    local v10 = SpectateController_m.CurrentSubject and SpectateController_m.CurrentSubject.FighterInterface and SpectateController_m.CurrentSubject.FighterInterface.BottomCenter.Layout.AbsoluteContentSize.Y or 0
    arg1.BufferFrame.Size = UDim2.new(
        1,
        0,
        0,
        (math.max(
            v10 + arg1.BottomStackFrame.AbsoluteSize.Y * 0.03,
            arg1.BottomStackFrame.AbsoluteSize.Y * 0.2
        ))
    )
end

function t._UpdateJoinCooldown(arg2) -- line: 65
    -- upvalues:
    --  [1] ArcadeController_m (copy)

    local v11 = ArcadeController_m:GetJoinCooldown()
    local v12 = ArcadeController_m:CanJoin()
    local JoinButtonOffTitle = arg2.JoinButtonOffTitle
    JoinButtonOffTitle.Text = v11 > 0 and v11 or "Join"
    arg2.JoinButtonOff.Visible = not v12
    arg2.JoinButtonOn.Visible = v12
end

function t._Update(arg3) -- line: 74
    -- upvalues:
    --  [1] Pages_m (copy)
    --  [2] SpectateController_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] ComplianceController_m (copy)
    --  [5] ControlsController_m (copy)
    --  [6] EliminatedEffect_m (copy)
    --  [7] Players (copy)

    local v14 = not Pages_m.PageSystem.CurrentPage

    if v14 then
        local v15 = SpectateController_m.CurrentDuelSubject

        if v15 then
            v15 = SpectateController_m.CurrentDuelSubject.LocalDueler

            if v15 then
                v15 = not SpectateController_m:IsThereValidSubject()
            end
        end

        v14 = not v15
    end

    local v15 = if CameraController_m:GetPublicState() ~= CameraController_m.CameraState.States.CustomFreecam then false else true
    local v17 = v14
    local JoinButton = arg3.JoinButton

    if v17 then
        v17 = not v15

        if v17 then
            v17 = SpectateController_m.CurrentDuelSubject

            if v17 then
                v17 = not SpectateController_m.CurrentDuelSubject.LocalDueler

                if v17 then
                    v17 = SpectateController_m.CurrentDuelSubject:Get("IsCurrentArcadeDuel")
                end
            end
        end
    end

    JoinButton.Visible = v17
    v17 = v14
    local Background = arg3.Background

    if v17 then
        v17 = not v15
    end

    Background.Visible = v17
    v17 = v14
    local LastButton = arg3.LastButton

    if v17 then
        v17 = not v15
    end

    LastButton.Visible = v17
    v17 = v14
    local NextButton = arg3.NextButton

    if v17 then
        v17 = not v15
    end

    NextButton.Visible = v17
    v17 = v14
    local PlayerText = arg3.PlayerText

    if v17 then
        v17 = not v15
    end

    PlayerText.Visible = v17
    v17 = v14 and not v15
    arg3.UsernameText.Visible = v17
    arg3.ExitFreecamButton.Visible = false
    local PlayerText_1 = arg3.PlayerText
    v17 = if v14 and not SpectateController_m.CurrentDuelSubject then "" else not SpectateController_m.CurrentSubject and arg3.PlayerText.Text or ComplianceController_m:GetName(
        SpectateController_m.CurrentSubject.Player
    )
    PlayerText_1.Text = v17
    local UsernameText_1 = arg3.UsernameText

    if v14 and not SpectateController_m.CurrentDuelSubject then
        v17 = ""
    elseif not SpectateController_m.CurrentSubject then
        v17 = arg3.UsernameText.Text

        if not v17 then
            v17 = SpectateController_m.CurrentSubject.Player.DisplayName ~= SpectateController_m.CurrentSubject.Player.Name and "@" .. SpectateController_m.CurrentSubject.Player.Name or ""
        end
    else
        v17 = SpectateController_m.CurrentSubject.Player.DisplayName ~= SpectateController_m.CurrentSubject.Player.Name and "@" .. SpectateController_m.CurrentSubject.Player.Name or ""
    end

    UsernameText_1.Text = v17
    local PlayerText_2 = arg3.PlayerText
    v17 = if not v14 then UDim2.new(0.5, 0, 0.35, 0) else if arg3.UsernameText.Text ~= "" then UDim2.new(
        0.5,
        0,
        0.35,
        0
    ) else UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.35, 0)
    PlayerText_2.Position = v17
    local FreecamButton = arg3.FreecamButton
    v17 = v14 and SpectateController_m.CurrentDuelSubject and not SpectateController_m.CurrentDuelSubject.LocalDueler and (if ControlsController_m.CurrentControls ~= "MouseKeyboard" then false else not v15)
    FreecamButton.Visible = v17
    local ExitButton = arg3.ExitButton
    v17 = v14 and SpectateController_m.CurrentDuelSubject and not SpectateController_m.CurrentDuelSubject.LocalDueler and not v15
    ExitButton.Visible = v17
    local Frame = arg3.Frame
    v17 = arg3.ExitButton.Visible and UDim2.new(0.04, 20, 0.08, 40) or UDim2.new(0.04, 20, 0.04, 20)
    Frame.Size = v17
    v17 = SpectateController_m.CurrentDuelSubject
    local Frame_1 = arg3.Frame

    if v17 then
        v17 = not (SpectateController_m.CurrentSubject and SpectateController_m.CurrentSubject.IsLocalPlayer)

        if v17 then
            v17 = not SpectateController_m.CurrentDuelSubject:Get("VoteOptions")

            if v17 then
                v17 = false

                if SpectateController_m.CurrentDuelSubject:Get("Status") ~= "GameOver" then
                    v17 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Buttons:IsAnythingVisible()

                    if v17 then
                        v17 = not SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard:IsOpen()

                        if v17 then
                            v17 = not EliminatedEffect_m:IsVisible()
                        end
                    end
                end
            end
        end
    end

    Frame_1.Visible = v17
    arg3._join_bubble_hash += 1
    local JoinBubbleHash = arg3._join_bubble_hash
    task.defer(function() -- line: 102
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] JoinBubbleHash (copy)
        --  [3] Players (ref)

        if
            not arg3.JoinButton.Visible
            or not arg3.JoinBubble.Visible
            or JoinBubbleHash ~= arg3._join_bubble_hash
        then
            return
        end

        while true do
            if arg3.JoinBubble:IsDescendantOf(Players) then
                arg3.JoinBubble:TweenPosition(
                    UDim2.new(0.5, 0, -0.6, 0),
                    "Out",
                    "Sine",
                    0.5,
                    true
                )
            end

            wait(0.5)

            if JoinBubbleHash ~= arg3._join_bubble_hash then
                return
            end

            if arg3.JoinBubble:IsDescendantOf(Players) then
                arg3.JoinBubble:TweenPosition(
                    UDim2.new(0.5, 0, -0.25, 0),
                    "In",
                    "Sine",
                    0.5,
                    true
                )
            end

            wait(0.5)

            if JoinBubbleHash == arg3._join_bubble_hash then
                continue
            end

            return
        end
    end)
end

function t._ListenFighterSubject(arg4) -- line: 135
    -- upvalues:
    --  [1] SpectateController_m (copy)

    for _, val in pairs(arg4._fighter_connections) do
        val:Disconnect()
    end

    arg4._fighter_connections = {}

    if not SpectateController_m.CurrentSubject then
        arg4:_UpdateBuffer()

        return
    end

    table.insert(arg4._fighter_connections, SpectateController_m.CurrentSubject.InterfaceRemoved:Connect(
        function(_) -- line: 147
            -- upvalues:
            --  [1] arg4 (copy)

            arg4:_UpdateBuffer()
        end
    ))

    local function interface_added(arg6) -- line: 151
        -- upvalues:
        --  [1] arg4 (copy)

        local FighterConnections_1 = arg4._fighter_connections
        local AbsoluteContentSize = arg6.BottomCenter.Layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        )
        table.insert(FighterConnections_1, AbsoluteContentSize:Connect(function() -- line: 152
            -- upvalues:
            --  [1] arg4 (ref)

            arg4:_UpdateBuffer()
        end))
        arg4:_UpdateBuffer()
    end

    table.insert(
        arg4._fighter_connections,
        SpectateController_m.CurrentSubject.InterfaceAdded:Connect(interface_added)
    )

    if SpectateController_m.CurrentSubject.FighterInterface then
        task.spawn(interface_added, SpectateController_m.CurrentSubject.FighterInterface)
    end

    arg4:_UpdateBuffer()
end

function t._ListenDuelSubject(arg7) -- line: 168
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] ControlsController_m (copy)
    --  [3] Pages_m (copy)
    --  [4] ArcadeController_m (copy)

    for _, val_1 in pairs(arg7._duel_connections) do
        val_1:Disconnect()
    end

    arg7._duel_connections = {}

    if not SpectateController_m.CurrentDuelSubject then
        arg7:_Update()
        arg7:_UpdateBuffer()

        return
    end

    table.insert(arg7._duel_connections, SpectateController_m.CurrentDuelSubject:GetDataChangedSignal(
        "VoteOptions"
    ):Connect(function() -- line: 181
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end))
    table.insert(arg7._duel_connections, SpectateController_m.CurrentDuelSubject:GetDataChangedSignal(
        "Status"
    ):Connect(function() -- line: 185
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end))
    table.insert(arg7._duel_connections, SpectateController_m.CurrentDuelSubject:GetDataChangedSignal(
        "IsCurrentArcadeDuel"
    ):Connect(function() -- line: 189
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end))
    table.insert(arg7._duel_connections, SpectateController_m.CurrentDuelSubject.DuelInterface.Scoreboard.VisibilityChanged:Connect(
        function() -- line: 193
            -- upvalues:
            --  [1] arg7 (copy)

            arg7:_Update()
        end
    ))
    table.insert(arg7._duel_connections, SpectateController_m.CurrentDuelSubject.DuelInterface.Buttons.Updated:Connect(
        function() -- line: 197
            -- upvalues:
            --  [1] arg7 (copy)

            arg7:_Update()
        end
    ))
    table.insert(arg7._duel_connections, SpectateController_m.SubjectChanged:Connect(function() -- line: 201
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end))
    table.insert(arg7._duel_connections, ControlsController_m.ControlsChanged:Connect(function() -- line: 205
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end))
    table.insert(arg7._duel_connections, Pages_m.PageSystem.PagesActivity:Connect(function() -- line: 209
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_Update()
    end))
    table.insert(arg7._duel_connections, ArcadeController_m.UpdateJoinCooldown:Connect(function() -- line: 213
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:_UpdateJoinCooldown()
    end))
    arg7:_Update()
    arg7:_UpdateBuffer()
    arg7:_UpdateJoinCooldown()
end

function t._Init(arg8) -- line: 222
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] CameraController_m (copy)
    --  [3] ArcadeController_m (copy)
    --  [4] EliminatedEffect_m (copy)
    --  [5] ButtonEffect_m (copy)

    arg8.NextButton.MouseButton1Click:Connect(function() -- line: 223
        -- upvalues:
        --  [1] SpectateController_m (ref)

        SpectateController_m:Next()
    end)
    arg8.LastButton.MouseButton1Click:Connect(function() -- line: 227
        -- upvalues:
        --  [1] SpectateController_m (ref)

        SpectateController_m:Last()
    end)
    arg8.ExitButton.MouseButton1Click:Connect(function() -- line: 231
        -- upvalues:
        --  [1] SpectateController_m (ref)

        SpectateController_m:Exit()
    end)
    arg8.FreecamButton.MouseButton1Click:Connect(function() -- line: 235
        -- upvalues:
        --  [1] CameraController_m (ref)

        CameraController_m.CameraState:SetCustomFreecamEnabled(true)
    end)
    arg8.ExitFreecamButton.MouseButton1Click:Connect(function() -- line: 239
        -- upvalues:
        --  [1] CameraController_m (ref)

        CameraController_m.CameraState:SetCustomFreecamEnabled(false)
    end)
    arg8.JoinButton.MouseButton1Click:Connect(function() -- line: 243
        -- upvalues:
        --  [1] ArcadeController_m (ref)
        --  [2] arg8 (copy)

        ArcadeController_m:Join()
        arg8.JoinBubble.Visible = false
        arg8:_Update()
    end)
    arg8.BottomStackFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 249
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateBuffer()
    end)
    CameraController_m.CustomFreecamStateChanged:Connect(function() -- line: 253
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end)
    EliminatedEffect_m.VisibilityChanged:Connect(function() -- line: 257
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Update()
    end)
    SpectateController_m.SubjectChanged:Connect(function() -- line: 261
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_ListenFighterSubject()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 265
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_ListenDuelSubject()
    end)
    arg8:_UpdateBuffer()
    task.spawn(arg8._ListenDuelSubject, arg8)
    task.spawn(arg8._ListenFighterSubject, arg8)
    ButtonEffect_m:Add(arg8.NextButton)
    ButtonEffect_m:Add(arg8.LastButton)
    ButtonEffect_m:Add(arg8.ExitButton)
    ButtonEffect_m:Add(arg8.JoinButton)
    ButtonEffect_m:Add(arg8.FreecamButton)
    ButtonEffect_m:Add(arg8.ExitFreecamButton)
end

return t._new()
