local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PermissionsLibrary_m = require(ReplicatedStorage.Modules.PermissionsLibrary)
local ModerationLibrary_m = require(ReplicatedStorage.Modules.ModerationLibrary)
local DebugLibrary_m = require(ReplicatedStorage.Modules.DebugLibrary)
local ShootingRangeController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ShootingRangeController")
)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local SettingsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SettingsController")
)
local FighterController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("FighterController")
)
local CameraController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("CameraController")
)
local PlayerList_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("PlayerList")
)
local InsetButtonsBar_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("InsetButtonsBar")
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages")
)
local UILibrary_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local t = {
    { "StopFreecam", "Turn off freecam mode", "rbxassetid://17548980857", nil, nil, nil },
    { "LeaveShootingRange", "Leave the Shooting Range", "rbxassetid://17498605048", nil, nil, nil },
    { "PlayerList", "Open the player list", "rbxassetid://108950719202626", nil, nil, nil },
    { "HUD", "Enable your HUD", "rbxassetid://126633805196326", nil, nil, nil },
    {
        "Debug",
        "Test things out using commands",
        "rbxassetid://18223601855",
        nil,
        UDim2.new(0.6, 0, 0.6, 0),
        "Debug"
    },
    {
        "Moderation",
        "Search, join, & ban cheaters",
        "rbxassetid://118920750856778",
        nil,
        nil,
        "Moderation"
    },
    {
        "Permissions",
        "Promote & demote team members",
        "rbxassetid://95626460059631",
        nil,
        UDim2.new(0.75, 0, 0.75, 0),
        "Permissions"
    }
}
local t_8 = {}
t_8.__index = t_8

function t_8.new(arg1) -- line: 30
    -- upvalues:
    --  [1] t_8 (copy)
    --  [2] InsetButtonsBar_m (copy)
    --  [3] UILibrary_m (copy)

    local t_9 = setmetatable({}, t_8)
    t_9.Inset = arg1
    t_9.Bar = InsetButtonsBar_m.new(
        UILibrary_m.BUTTON_BACKGROUND_TRANSPARENCY,
        UILibrary_m.BUTTON_BACKGROUND_COLOR,
        UILibrary_m.BUTTON_ICON_COLOR,
        true
    )
    t_9._local_fighter = nil
    t_9:_Init()

    return t_9
end

function t_8.SetVisible(arg2, arg3, arg4) -- line: 47
    arg2.Bar.Frame.Visible = arg3
    local Frame = arg2.Bar.Frame
    local v10 = arg4 or arg2.Bar.Frame.Size
    Frame.Size = v10
    arg2.Bar:Toggle(true)
end

function t_8._UpdateVisibility(arg5) -- line: 57
    -- upvalues:
    --  [1] CameraController_m (copy)
    --  [2] PlayerList_m (copy)
    --  [3] PlayerDataController_m (copy)
    --  [4] DebugLibrary_m (copy)
    --  [5] ModerationLibrary_m (copy)
    --  [6] PermissionsLibrary_m (copy)

    arg5.Bar.Buttons.StopFreecam.Frame.Visible = if CameraController_m:GetPublicState() ~= CameraController_m.CameraState.States.CustomFreecam then false else true
    local v13 = PlayerList_m.ClosedByInputs
    local Frame_2 = arg5.Bar.Buttons.PlayerList.Frame

    if v13 then
        v13 = PlayerList_m:GetBaseVisibility()
    end

    Frame_2.Visible = v13
    arg5.Bar.Buttons.HUD.Frame.Visible = PlayerDataController_m:GetSetting("Hide HUD")
    local v14 = arg5._local_fighter
    local Frame_4 = arg5.Bar.Buttons.LeaveShootingRange.Frame

    if v14 then
        v14 = arg5._local_fighter:Get("IsInShootingRange")
    end

    Frame_4.Visible = v14
    local Frame_5 = arg5.Bar.Buttons.Debug.Frame
    v14 = not PlayerDataController_m:GetSetting("Staff Team Tools Disabled")

    if v14 then
        v14 = DebugLibrary_m:CanViewDebugPage(PlayerDataController_m:Get("PermissionsRoles"))
    end

    Frame_5.Visible = v14
    local Frame_6 = arg5.Bar.Buttons.Moderation.Frame
    v14 = not PlayerDataController_m:GetSetting("Staff Team Tools Disabled")

    if v14 then
        v14 = ModerationLibrary_m:CanViewModerationPage(
            PlayerDataController_m:Get("PermissionsRoles")
        )
    end

    Frame_6.Visible = v14
    v14 = not PermissionsLibrary_m.USE_GROUP_ROLES_INSTEAD_OF_DATASTORES
    local Frame_7 = arg5.Bar.Buttons.Permissions.Frame

    if v14 then
        v14 = not PlayerDataController_m:GetSetting("Staff Team Tools Disabled Leads")

        if v14 then
            v14 = PermissionsLibrary_m:CanViewPermissionsPage(
                PlayerDataController_m:Get("PermissionsRoles")
            )
        end
    end

    Frame_7.Visible = v14
    arg5:SetVisible(arg5.Bar.Frame.Visible)
end

function t_8._HookFighter(arg6) -- line: 69
    -- upvalues:
    --  [1] FighterController_m (copy)

    arg6._local_fighter = FighterController_m:WaitForLocalFighter()
    arg6._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function() -- line: 72
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_UpdateVisibility()
    end)
    arg6:_UpdateVisibility()
end

function t_8._Setup(arg7) -- line: 79
    -- upvalues:
    --  [1] t (copy)
    --  [2] Pages_m (copy)
    --  [3] CameraController_m (copy)
    --  [4] ShootingRangeController_m (copy)
    --  [5] PlayerList_m (copy)
    --  [6] SettingsController_m (copy)

    local v23

    for key, val in pairs(t) do
        local v18, v19, v20, v21, v22
        v18, v19, v20, v21, v22, v23 = table.unpack(val)
        arg7.Bar:CreateButton(
            key,
            v18,
            v19,
            v20,
            v21,
            v22
        ).Clicked:Connect(function() -- line: 84
            -- upvalues:
            --  [1] v23 (copy)
            --  [2] Pages_m (ref)

            if v23 then
                Pages_m.PageSystem:OpenPage(v23)
            end
        end)
    end

    arg7.Bar.Buttons.StopFreecam.Clicked:Connect(function() -- line: 91
        -- upvalues:
        --  [1] CameraController_m (ref)

        CameraController_m.CameraState:SetCustomFreecamEnabled(false)
    end)
    arg7.Bar.Buttons.LeaveShootingRange.Clicked:Connect(function() -- line: 95
        -- upvalues:
        --  [1] ShootingRangeController_m (ref)

        ShootingRangeController_m:Leave()
    end)
    arg7.Bar.Buttons.PlayerList.Clicked:Connect(function() -- line: 99
        -- upvalues:
        --  [1] PlayerList_m (ref)

        PlayerList_m:SetClosedByInputs(not PlayerList_m.ClosedByInputs)
    end)
    arg7.Bar.Buttons.HUD.Clicked:Connect(function() -- line: 103
        -- upvalues:
        --  [1] SettingsController_m (ref)

        SettingsController_m:ChangeSetting("Hide HUD", false)
    end)
    arg7.Bar.Frame.Parent = arg7.Inset.RightButtonsFrame
end

function t_8._Init(arg8) -- line: 110
    -- upvalues:
    --  [1] PlayerDataController_m (copy)
    --  [2] PlayerList_m (copy)
    --  [3] CameraController_m (copy)

    PlayerDataController_m:GetSettingChangedSignal("Staff Team Tools Disabled"):Connect(function() -- line: 111
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Staff Team Tools Disabled Leads"):Connect(function() -- line: 115
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    PlayerDataController_m:GetSettingChangedSignal("Hide HUD"):Connect(function() -- line: 119
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    PlayerDataController_m:GetDataChangedSignal("PermissionsRoles"):Connect(function() -- line: 123
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    PlayerList_m.ClosedByInputsChanged:Connect(function() -- line: 127
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    PlayerList_m.BaseVisibilityChanged:Connect(function() -- line: 131
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    CameraController_m.CustomFreecamStateChanged:Connect(function() -- line: 135
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    CameraController_m.CameraState.FreecamAccessChanged:Connect(function() -- line: 139
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateVisibility()
    end)
    arg8:_Setup()
    arg8:_UpdateVisibility()
    task.defer(arg8._HookFighter, arg8)
end

return t_8
