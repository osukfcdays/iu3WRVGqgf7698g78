local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController")
)
local Teleporting_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting")
)
local t = {}
t.__index = t

function t._new() -- line: 13
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._models = {}
    t_1:_Init()

    return t_1
end

function t._FixPermanentKeyboardBug(_) -- line: 33
    -- upvalues:
    --  [1] Utility_m (copy)
    --  [2] Players (copy)

    if not Utility_m:IsTextBoxFocused() then
        return
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    local TextBox = Instance.new("TextBox")
    TextBox.BackgroundTransparency = 1
    TextBox.Text = ""
    TextBox.PlaceholderText = ""
    TextBox.TextTransparency = 1
    TextBox.Parent = ScreenGui
    task.defer(function() -- line: 48
        -- upvalues:
        --  [1] TextBox (copy)
        --  [2] ScreenGui (copy)

        TextBox:CaptureFocus()
        task.defer(function() -- line: 51
            -- upvalues:
            --  [1] TextBox (ref)
            --  [2] ScreenGui (ref)

            TextBox:ReleaseFocus()
            TextBox:Destroy()
            ScreenGui:Destroy()
        end)
    end)
end

function t._UpdatePrompts(arg2) -- line: 59
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] ControlsController_m (copy)

    for key, val in pairs(arg2._models) do
        local v3 = if CONSTANTS_m.IS_MOBILE_SERVER then key else if ControlsController_m.CurrentControls ~= "Touch" then nil else key
        val.Parent = v3
    end
end

function t._PromptAdded(arg3, arg4) -- line: 65
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] CONSTANTS_m (copy)

    local Model = arg4:WaitForChild("Model")
    local ProximityPrompt = Model:WaitForChild("Prompt"):WaitForChild("ProximityPrompt")
    ProximityPrompt.Triggered:Connect(function() -- line: 69
        -- upvalues:
        --  [1] ReplicatedStorage (ref)

        ReplicatedStorage.Remotes.Misc.MobileDuelsTeleport:FireServer()
    end)
    ProximityPrompt.ActionText = if CONSTANTS_m.IS_MOBILE_SERVER then "Leave" else "Teleport"
    arg3._models[arg4] = Model
    task.defer(arg3._UpdatePrompts, arg3)
end

function t._Init(arg5) -- line: 80
    -- upvalues:
    --  [1] Teleporting_m (copy)
    --  [2] CollectionService (copy)

    Teleporting_m.EnabledChanged:Connect(function() -- line: 81
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_FixPermanentKeyboardBug()
    end)
    CollectionService:GetInstanceAddedSignal("LobbyMobileDuelsPrompt"):Connect(function(arg6) -- line: 85
        -- upvalues:
        --  [1] arg5 (copy)

        arg5:_PromptAdded(arg6)
    end)

    for _, val_1 in pairs(CollectionService:GetTagged("LobbyMobileDuelsPrompt")) do
        task.defer(arg5._PromptAdded, arg5, val_1)
    end

    task.defer(arg5._UpdatePrompts, arg5)
    task.defer(arg5._FixPermanentKeyboardBug, arg5)
end

return t._new()
