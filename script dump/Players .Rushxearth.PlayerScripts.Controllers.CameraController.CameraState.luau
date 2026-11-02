local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local _ = require(ReplicatedStorage.Modules.DebugLibrary)
local Signal_m = require(ReplicatedStorage.Modules.Signal)
local PrivateServerController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PrivateServerController
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local CustomFreecam = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CustomFreecam")
local t = {
    FirstPerson = "FirstPerson",
    ThirdPerson = "ThirdPerson",
    ThirdPersonMirrored = "ThirdPersonMirrored",
    ThirdPersonUnlockedMouse = "ThirdPersonUnlockedMouse",
    CustomFreecam = "CustomFreecam"
}
local t_2 = {}
t_2.__index = t_2
t_2.States = t
t_2.POVStates = { "FirstPerson", "ThirdPerson", "ThirdPersonMirrored", "ThirdPersonUnlockedMouse" }

function t_2.new(arg1) -- line: 22
    -- upvalues:
    --  [1] t_2 (copy)
    --  [2] Signal_m (copy)
    --  [3] CustomFreecam (copy)

    local t_3 = setmetatable({}, t_2)
    t_3.StateChanged = Signal_m.new()
    t_3.FreecamAccessChanged = Signal_m.new()
    t_3.CameraController = arg1
    t_3._public_state = nil
    t_3._pov_state = nil
    t_3._is_active = false
    t_3._custom_freecam_enabled = false
    t_3._custom_freecam = CustomFreecam:Clone()
    t_3._custom_freecam_script = t_3._custom_freecam:WaitForChild("LocalScript")
    t_3:_Init()

    return t_3
end

function t_2.GetPublicState(arg2) -- line: 46
    return arg2._public_state
end

function t_2.HasFreecamAccess(_) -- line: 50
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] PrivateServerController_m (copy)
    --  [3] Players (copy)
    --  [4] PermissionsLibrary_m (copy)
    --  [5] PlayerDataController_m (copy)

    local v1 = CONSTANTS_m.IS_STUDIO

    if not v1 then
        v1 = CONSTANTS_m.IS_TESTING_SERVER

        if not v1 then
            v1 = if PrivateServerController_m:Get("FreecamEnabled") ~= "Everyone" then PrivateServerController_m:Get(
                "FreecamEnabled"
            ) == "Server Owner" and CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId) or PermissionsLibrary_m:HasPermission(
                "permission_freecam",
                PlayerDataController_m:Get("PermissionsRoles")
            ) else true
        end
    end

    return v1
end

function t_2.SetActive(arg4, arg5) -- line: 57
    if arg5 == arg4._is_active then
        return
    end

    arg4._is_active = arg5
    arg4:_UpdateState()
end

function t_2.SetCustomFreecamEnabled(arg6, arg7) -- line: 66
    -- upvalues:
    --  [1] Players (copy)

    if arg7 == arg6._custom_freecam_enabled then
        return
    end

    arg6._custom_freecam_enabled = arg7
    arg6:_UpdateState()
    arg6._custom_freecam_script.Disabled = false
    arg6._custom_freecam.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    task.defer(
        arg6._custom_freecam.LocalScript.Toggle.Fire,
        arg6._custom_freecam.LocalScript.Toggle,
        arg6._custom_freecam_enabled
    )
end

function t_2.TogglePOV(arg8) -- line: 80
    local v4 = arg8.CameraController:HasThirdPersonAccess()
    local v5 = v4

    if v5 then
        v5 = arg8.CameraController:HasUnlockedMouseAccess()
    end

    if arg8._pov_state == arg8.States.FirstPerson and v4 then
        arg8:_SetPOVState(arg8.States.ThirdPerson)

        return
    end

    if arg8._pov_state == arg8.States.ThirdPerson and v4 then
        arg8:_SetPOVState(arg8.States.ThirdPersonMirrored)

        return
    end

    if arg8._pov_state == arg8.States.ThirdPersonMirrored and v5 then
        arg8:_SetPOVState(arg8.States.ThirdPersonUnlockedMouse)

        return
    end

    if arg8.CameraController:IsSubjectEmoting() then
        arg8:_SetPOVState(arg8.States.ThirdPerson)

        return
    end

    arg8:_SetPOVState(arg8.States.FirstPerson)
end

function t_2.VerifyPOV(arg9) -- line: 99
    local v6 = if arg9._pov_state ~= arg9.States.FirstPerson then not arg9.CameraController:HasThirdPersonAccess() else false

    if if arg9._pov_state == arg9.States.ThirdPersonUnlockedMouse then not arg9.CameraController:HasUnlockedMouseAccess() else false then
        if v6 then
            arg9:_SetPOVState(arg9.States.FirstPerson)

            return
        end

        arg9:_SetPOVState(arg9.States.ThirdPerson)

        return
    else
        if v6 then
            arg9:_SetPOVState(arg9.States.FirstPerson)
        end

        return
    end
end

function t_2._SetState(arg10, arg11) -- line: 118
    -- upvalues:
    --  [1] t (copy)

    assert(not arg11 or t[arg11], arg11)

    if arg11 == arg10._public_state then
        return
    end

    local PublicState = arg10._public_state
    arg10._public_state = arg11
    arg10.StateChanged:Fire(arg10._public_state, PublicState)
end

function t_2._UpdateState(arg12) -- line: 131
    local _ = arg12.CameraController:GetCurrentSubject()
    arg12:_SetState(
        if arg12._custom_freecam_enabled then arg12.States.CustomFreecam else if arg12._is_active then arg12._pov_state else nil
    )
end

function t_2._SetPOVState(arg13, arg14) -- line: 140
    -- upvalues:
    --  [1] t (copy)

    assert(not arg14 or t[arg14], arg14)

    if arg14 == arg13._pov_state then
        return
    end

    arg13._pov_state = arg14
    arg13:_UpdateState()
end

function t_2._SetupEmoteLogic(arg15) -- line: 151
    local v12 = nil

    local function check() -- line: 155
        -- upvalues:
        --  [1] arg15 (copy)
        --  [2] v12 (ref)

        task.defer(function() -- line: 156
            -- upvalues:
            --  [1] arg15 (ref)
            --  [2] v12 (ref)

            if arg15.CameraController:IsSubjectEmoting() then
                local v13 = v12 or arg15._pov_state
                v12 = v13
                arg15:_SetPOVState(arg15.States.ThirdPersonUnlockedMouse)

                return
            end

            if v12 then
                arg15:_SetPOVState(v12)
                v12 = nil
            end

            arg15:VerifyPOV()
        end)
    end

    local t_4 = {}

    local function subject_changed() -- line: 171
        -- upvalues:
        --  [1] t_4 (ref)
        --  [2] arg15 (copy)
        --  [3] check (copy)
        --  [4] v12 (ref)

        for _, val in pairs(t_4) do
            val:Disconnect()
        end

        t_4 = {}
        local v14 = arg15.CameraController:GetCurrentSubject()

        if not v14 then
            return
        end

        table.insert(t_4, v14.EntityRemoved:Connect(check))

        local function entity_added(arg16) -- line: 186
            -- upvalues:
            --  [1] t_4 (ref)
            --  [2] check (ref)
            --  [3] arg15 (ref)
            --  [4] v12 (ref)

            table.insert(t_4, arg16.EmoteStatusChanged:Connect(check))
            task.defer(function() -- line: 156
                -- upvalues:
                --  [1] arg15 (ref)
                --  [2] v12 (ref)

                if arg15.CameraController:IsSubjectEmoting() then
                    local v17 = v12 or arg15._pov_state
                    v12 = v17
                    arg15:_SetPOVState(arg15.States.ThirdPersonUnlockedMouse)

                    return
                end

                if v12 then
                    arg15:_SetPOVState(v12)
                    v12 = nil
                end

                arg15:VerifyPOV()
            end)
        end

        table.insert(t_4, v14.EntityAdded:Connect(entity_added))

        if v14.Entity then
            table.insert(t_4, v14.Entity.EmoteStatusChanged:Connect(check))
            task.defer(function() -- line: 156
                -- upvalues:
                --  [1] arg15 (ref)
                --  [2] v12 (ref)

                if arg15.CameraController:IsSubjectEmoting() then
                    local v20 = v12 or arg15._pov_state
                    v12 = v20
                    arg15:_SetPOVState(arg15.States.ThirdPersonUnlockedMouse)

                    return
                end

                if v12 then
                    arg15:_SetPOVState(v12)
                    v12 = nil
                end

                arg15:VerifyPOV()
            end)
        end
    end

    arg15.CameraController.SubjectChanged:Connect(subject_changed)
    subject_changed()
end

function t_2._SetupFreecam(arg17) -- line: 202
    -- upvalues:
    --  [1] Players (copy)
    --  [2] UserInputService (copy)

    task.spawn(function() -- line: 204
        -- upvalues:
        --  [1] Players (ref)

        local function child_added(arg18) -- line: 205
            if arg18:IsA("ScreenGui") and arg18.Name == "Freecam" then
                task.defer(arg18.Destroy, arg18)
            end
        end

        Players.LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(child_added)

        for _, child in pairs(Players.LocalPlayer.PlayerGui:GetChildren()) do
            if child:IsA("ScreenGui") and child.Name == "Freecam" then
                task.defer(child.Destroy, child)
            end
        end
    end)
    UserInputService.InputBegan:Connect(function(arg19, _) -- line: 218
        -- upvalues:
        --  [1] UserInputService (ref)
        --  [2] arg17 (copy)

        if
            arg19.KeyCode == Enum.KeyCode.P
            and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            and arg17:HasFreecamAccess()
        then
            arg17:SetCustomFreecamEnabled(not arg17._custom_freecam_enabled)
        end
    end)
end

function t_2._Setup(arg21) -- line: 227
    if arg21.CameraController:HasThirdPersonAccess() then
        arg21:_SetPOVState(arg21.States.FirstPerson)
    end
end

function t_2._Init(arg22) -- line: 233
    -- upvalues:
    --  [1] ControlsController_m (copy)
    --  [2] PrivateServerController_m (copy)
    --  [3] PlayerDataController_m (copy)

    ControlsController_m.ControlsChanged:Connect(function() -- line: 234
        -- upvalues:
        --  [1] arg22 (copy)

        arg22:VerifyPOV()
    end)
    PrivateServerController_m:GetDataChangedSignal("FreecamEnabled"):Connect(function() -- line: 238
        -- upvalues:
        --  [1] arg22 (copy)

        arg22.FreecamAccessChanged:Fire()
    end)
    PlayerDataController_m:GetDataChangedSignal("PermissionsRoles"):Connect(function() -- line: 242
        -- upvalues:
        --  [1] arg22 (copy)

        arg22.FreecamAccessChanged:Fire()
    end)
    arg22:_Setup()
    arg22:_UpdateState()
    task.defer(arg22._SetupFreecam, arg22)
    task.defer(arg22._SetupEmoteLogic, arg22)
end

return t_2
