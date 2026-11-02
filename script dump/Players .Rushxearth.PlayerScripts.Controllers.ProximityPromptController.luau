local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local BetterDebris_m = require(ReplicatedStorage.Modules.BetterDebris)
local ItemLibrary_m = require(ReplicatedStorage.Modules.ItemLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController")
)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local MobileInputs_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local Equipment_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment")
)
local Shutdown_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Shutdown")
)
local Queue_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local WeaponStatusHandler_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local ProximityPrompts = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "ProximityPrompts"
)
local t = {}
t.__index = t

function t._new() -- line: 26
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._custom_prompt = nil
    t_1._custom_prompt_hash = 0
    t_1._custom_prompt_connections = {}
    t_1:_Init()

    return t_1
end

function t._Update(arg1) -- line: 48
    -- upvalues:
    --  [1] ProximityPromptService (copy)
    --  [2] MobileInputs_m (copy)
    --  [3] Pages_m (copy)
    --  [4] Teleporting_m (copy)
    --  [5] Shutdown_m (copy)
    --  [6] Queue_m (copy)
    --  [7] GuiService (copy)
    --  [8] Equipment_m (copy)
    --  [9] PlayerDataController_m (copy)
    --  [10] ControlsController_m (copy)
    --  [11] CameraController_m (copy)

    local v13 = not MobileInputs_m.EditorEnabled
    local v14 = ProximityPromptService

    if v13 then
        v13 = not Pages_m.PageSystem.CurrentPage

        if v13 then
            v13 = not Teleporting_m.Enabled

            if v13 then
                v13 = not Shutdown_m.Enabled

                if v13 then
                    v13 = not Queue_m:IsVisible()

                    if v13 then
                        v13 = not GuiService.MenuIsOpen

                        if v13 then
                            v13 = not Equipment_m.IsOpen

                            if v13 then
                                v13 = not PlayerDataController_m:GetSetting("Hide HUD")
                            end
                        end
                    end
                end
            end
        end
    end

    v14.Enabled = v13

    if arg1._custom_prompt then
        v13 = true
        local CustomPrompt = arg1._custom_prompt

        if ControlsController_m.CurrentControls ~= "Touch" then
            v13 = not CameraController_m.CameraState:GetPublicState()
        end

        CustomPrompt.Active = v13
    end
end

function t._Cleanup(arg2) -- line: 64
    -- upvalues:
    --  [1] BetterDebris_m (copy)
    --  [2] Players (copy)

    arg2._custom_prompt_hash += 1

    for _, val in pairs(arg2._custom_prompt_connections) do
        val:Disconnect()
    end

    arg2._custom_prompt_connections = {}

    if arg2._custom_prompt then
        BetterDebris_m:AddItem(arg2._custom_prompt, 0.15)

        if arg2._custom_prompt:FindFirstChild("Button") and arg2._custom_prompt:IsDescendantOf(
            Players
        ) then
            arg2._custom_prompt.Button:TweenSize(
                UDim2.new(0, 0, 0, 0),
                "Out",
                "Quint",
                0.25,
                true
            )
        end

        arg2._custom_prompt = nil
    end
end

function t._Create(arg3, arg4) -- line: 84
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] ProximityPrompts (copy)
    --  [3] Players (copy)
    --  [4] WeaponStatusHandler_m (copy)
    --  [5] ItemLibrary_m (copy)
    --  [6] ButtonEffect_m (copy)

    arg3:_Cleanup()
    arg4:SetAttribute("ClickablePrompt", arg4.ClickablePrompt)
    arg4.ClickablePrompt = if ControlsController_m.CurrentControls ~= "Touch" then arg4:GetAttribute(
        "ClickablePrompt"
    ) else true
    arg3._custom_prompt_hash += 1
    local CustomPromptHash = arg3._custom_prompt_hash
    local v17 = ProximityPrompts[arg4:GetAttribute("Style") or "Default"]
    arg3._custom_prompt = v17:Clone()
    arg3._custom_prompt.Name = "ProximityPrompt - " .. v17.Name
    arg3._custom_prompt.Button.Inputs.MouseKeyboard.KeyText.Text = arg4.KeyboardKeyCode.Name
    arg3._custom_prompt.Button.Inputs.Gamepad.Container:SetAttribute("EnumType", "KeyCode")
    arg3._custom_prompt.Button.Inputs.Gamepad.Container:SetAttribute(
        "EnumName",
        arg4.GamepadKeyCode.Name
    )
    arg3._custom_prompt.Button.Inputs.Gamepad.Container:AddTag("UIKeybindContainer")
    arg3._custom_prompt.Button.Interactable = arg4.ClickablePrompt
    arg3._custom_prompt.Adornee = arg4.Parent
    arg3._custom_prompt.Parent = Players.LocalPlayer.PlayerGui

    local function update() -- line: 104
        -- upvalues:
        --  [1] arg3 (copy)
        --  [2] arg4 (copy)
        --  [3] WeaponStatusHandler_m (ref)
        --  [4] ItemLibrary_m (ref)

        arg3._custom_prompt.Button.ObjectText.Text = arg4.ObjectText
        arg3._custom_prompt.Button.ActionText.Text = arg4.ActionText
        WeaponStatusHandler_m:ClearStatusElements(arg3._custom_prompt.Button.ObjectText)
        local v18 = ItemLibrary_m.Items[arg4.ObjectText]
        local v19 = WeaponStatusHandler_m
        local ObjectText = arg3._custom_prompt.Button.ObjectText

        if v18 then
            v18 = ItemLibrary_m.Items[arg4.ObjectText].Status
        end

        v19:ApplyItemStatusToText(ObjectText, v18)
    end

    table.insert(
        arg3._custom_prompt_connections,
        arg4:GetPropertyChangedSignal("ObjectText"):Connect(update)
    )
    table.insert(
        arg3._custom_prompt_connections,
        arg4:GetPropertyChangedSignal("ActionText"):Connect(update)
    )
    update()
    local Button_1 = arg3._custom_prompt.Button
    Button_1.Size = UDim2.new(
        arg3._custom_prompt.Button.Size.X.Scale * 0.5,
        arg3._custom_prompt.Button.Size.X.Offset * 0.5,
        arg3._custom_prompt.Button.Size.Y.Scale * 0.5,
        arg3._custom_prompt.Button.Size.Y.Offset * 0.5
    )
    arg3._custom_prompt.Button:TweenSize(
        v17.Button.Size,
        "Out",
        "Quint",
        0.25,
        true,
        function() -- line: 116
            -- upvalues:
            --  [1] arg3 (copy)
            --  [2] CustomPromptHash (copy)
            --  [3] arg4 (copy)
            --  [4] ButtonEffect_m (ref)

            if arg3._custom_prompt_hash ~= CustomPromptHash or not arg4.ClickablePrompt then
                return
            end

            arg3._custom_prompt.Button.MouseButton1Down:Connect(function() -- line: 121
                -- upvalues:
                --  [1] arg4 (ref)

                arg4:InputHoldBegin()
            end)
            arg3._custom_prompt.Button.MouseButton1Up:Connect(function() -- line: 125
                -- upvalues:
                --  [1] arg4 (ref)

                arg4:InputHoldEnd()
            end)
            arg3._custom_prompt.Button.MouseLeave:Connect(function() -- line: 129
                -- upvalues:
                --  [1] arg4 (ref)

                arg4:InputHoldEnd()
            end)
            ButtonEffect_m:Add(arg3._custom_prompt.Button, nil, { DontReposition = true })
        end
    )
    arg3:_Update()
end

function t._Init(arg5) -- line: 139
    -- upvalues:
    --  [1] ProximityPromptService (copy)
    --  [2] Pages_m (copy)
    --  [3] Teleporting_m (copy)
    --  [4] Shutdown_m (copy)
    --  [5] Queue_m (copy)
    --  [6] SpectateController_m (copy)
    --  [7] MobileInputs_m (copy)
    --  [8] ControlsController_m (copy)
    --  [9] CameraController_m (copy)
    --  [10] GuiService (copy)
    --  [11] Equipment_m (copy)
    --  [12] PlayerDataController_m (copy)

    ProximityPromptService.PromptShown:Connect(function(inputType: ProximityPromptInputType) -- line: 140
        -- upvalues:
        --  [1] arg5 (copy)

        if inputType.Style ~= Enum.ProximityPromptStyle.Custom then
            return
        end

        arg5:_Create(inputType)
    end)
    ProximityPromptService.PromptHidden:Connect(function(prompt: ProximityPrompt) -- line: 148
        -- upvalues:
        --  [1] arg5 (copy)

        if prompt.Style ~= Enum.ProximityPromptStyle.Custom then
            return
        end

        arg5:_Cleanup()
    end)
    Pages_m.PageSystem.PageOpened:Connect(function() -- line: 156
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    Pages_m.PageSystem.PageClosed:Connect(function() -- line: 160
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    Teleporting_m.EnabledChanged:Connect(function() -- line: 164
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    Shutdown_m.EnabledChanged:Connect(function() -- line: 168
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    Queue_m.VisibilityChanged:Connect(function() -- line: 172
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 176
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    MobileInputs_m.EditorEnabledChanged:Connect(function() -- line: 180
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 184
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    CameraController_m.StateChanged:Connect(function() -- line: 188
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(function() -- line: 192
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    Equipment_m.Opened:Connect(function() -- line: 196
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Hide HUD"):Connect(function() -- line: 200
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_Update()
    end)
    arg5:_Update()
end

return t._new()
