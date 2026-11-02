local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local Utility_m = require(ReplicatedStorage.Modules.Utility)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local CameraController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.CameraController)
local t = {}
t.__index = t

function t.new(arg1) -- line: 13
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.EnabledChanged = Signal_m.new()
    t_1.MobileInputs = arg1
    t_1.ModalFrame = t_1.MobileInputs.Frame:WaitForChild("Modal")
    t_1.Enabled = false
    t_1._edits_pending = false
    t_1:_Init()

    return t_1
end

function t.SetEnabled(arg2, arg3) -- line: 33
    arg3 = not (not arg3)

    if arg3 == arg2.Enabled then
        return
    end

    arg2.Enabled = arg3 or false
    arg2.EnabledChanged:Fire()

    if not arg2.Enabled then
        arg2:ApplyEdits()
    end
end

function t.ResetLayout(arg4) -- line: 48
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] PlayerDataController_m (copy)

    for _, val in pairs(arg4.MobileInputs.Buttons.Buttons) do
        val:ResetPositionAndSize()
    end

    arg4._edits_pending = false
    ReplicatedStorage.Remotes.Data.UpdateMobileButtonSettings:FireServer(
        PlayerDataController_m:Get("SettingsProfile"),
        nil
    )
end

function t.ApplyEdits(arg5) -- line: 57
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] PlayerDataController_m (copy)

    if not arg5._edits_pending then
        return
    end

    arg5._edits_pending = false
    ReplicatedStorage.Remotes.Data.UpdateMobileButtonSettings:FireServer(
        PlayerDataController_m:Get("SettingsProfile"),
        arg5.MobileInputs.Buttons:GetCurrentProfile()
    )
end

function t.PendEdits(arg6) -- line: 66
    arg6._edits_pending = true
end

function t.ImportProfile(arg7, arg8) -- line: 70
    -- upvalues:
    --  [1] EnumLibrary_m (copy)
    --  [2] Utility_m (copy)

    local v3, v4 = EnumLibrary_m:DecryptTable(arg8)

    if not v3 then
        Utility_m:CreateSound(
            "rbxassetid://17153811469",
            2,
            1,
            script,
            true,
            5
        )

        return
    end

    arg7._edits_pending = true
    arg7.MobileInputs.Buttons:UpdatePositionsAndSizes(v4)
end

function t._UpdateModal(arg9) -- line: 86
    arg9.ModalFrame.Visible = arg9.Enabled
end

function t._Init(arg10) -- line: 90
    -- upvalues:
    --  [1] CameraController_m (copy)

    arg10.EnabledChanged:Connect(function() -- line: 91
        -- upvalues:
        --  [1] arg10 (copy)
        --  [2] CameraController_m (ref)

        arg10:_UpdateModal()
        CameraController_m:SetIsEditingMobileButtons(arg10.Enabled)
    end)
    arg10:_UpdateModal()
end

return t
