local _ = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local ConnectionUtil_m = require(CommonUtils:WaitForChild("ConnectionUtil"))
local CharacterUtil_m = require(CommonUtils:WaitForChild("CharacterUtil"))
local UserAllowAbilityControls = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag(
    "UserAllowAbilityControls"
)
local AvatarAbilitiesInterface_m = nil

if UserAllowAbilityControls then
    AvatarAbilitiesInterface_m = require(script.Parent:WaitForChild("AvatarAbilitiesInterface"))
end

local t = {
    "rbxasset://textures/ui/Input/JumpButtonRegular.png",
    "rbxasset://textures/ui/Input/JumpButtonPressed.png"
}
local _ = {
    HUMANOID_STATE_ENABLED_CHANGED = "HUMANOID_STATE_ENABLED_CHANGED",
    HUMANOID_JUMP_POWER = "HUMANOID_JUMP_POWER",
    HUMANOID_JUMP_HEIGHT = "HUMANOID_JUMP_HEIGHT",
    HUMANOID = "HUMANOID",
    JUMP_INPUT_ENDED = "JUMP_INPUT_ENDED",
    MENU_OPENED = "MENU_OPENED"
}
local BaseCharacterController_m = require(script.Parent:WaitForChild("BaseCharacterController"))
local t_2 = setmetatable({}, BaseCharacterController_m)
t_2.__index = t_2

function t_2.new() -- line: 61
    -- upvalues:
    --  [1] BaseCharacterController_m (copy)
    --  [2] t_2 (copy)
    --  [3] ConnectionUtil_m (copy)

    local t_3 = setmetatable(BaseCharacterController_m.new(), t_2)
    t_3.parentUIFrame = nil
    t_3.jumpButton = nil
    t_3.externallyEnabled = false
    t_3.isJumping = false
    t_3._active = false
    t_3._connectionUtil = ConnectionUtil_m.new()

    return t_3
end

function t_2._reset(arg1) -- line: 75
    -- upvalues:
    --  [1] UserAllowAbilityControls (copy)
    --  [2] AvatarAbilitiesInterface_m (ref)
    --  [3] t (copy)

    arg1.isJumping = false
    arg1.touchObject = nil

    if arg1.jumpButton then
        if UserAllowAbilityControls and AvatarAbilitiesInterface_m.isEnabled() then
            arg1.jumpButton.Image = t[1]

            return
        end

        arg1.jumpButton.ImageRectOffset = Vector2.new(1, 146)
    end
end

function t_2.EnableButton(arg2, arg3) -- line: 90
    -- upvalues:
    --  [1] GuiService (copy)

    if arg3 == arg2._active then
        return
    end

    if arg3 then
        if not arg2.jumpButton then
            arg2:Create()
        end

        arg2.jumpButton.Visible = true
        arg2._connectionUtil:trackConnection("JUMP_INPUT_ENDED", arg2.jumpButton.InputEnded:Connect(
            function(input: InputObject) -- line: 105
                -- upvalues:
                --  [1] arg2 (copy)

                if input == arg2.touchObject then
                    arg2:_reset()
                end
            end
        ))
        arg2._connectionUtil:trackConnection("MENU_OPENED", GuiService.MenuOpened:Connect(function() -- line: 115
            -- upvalues:
            --  [1] arg2 (copy)

            if arg2.touchObject then
                arg2:_reset()
            end
        end))
    else
        if arg2.jumpButton then
            arg2.jumpButton.Visible = false
        end

        arg2._connectionUtil:disconnect("JUMP_INPUT_ENDED")
        arg2._connectionUtil:disconnect("MENU_OPENED")
    end

    arg2:_reset()
    arg2._active = arg3
end

function t_2.UpdateEnabled(arg5) -- line: 132
    -- upvalues:
    --  [1] CharacterUtil_m (copy)

    local Humanoid = CharacterUtil_m.getChild("Humanoid", "Humanoid")

    if
        Humanoid
        and arg5.externallyEnabled
        and (if not Humanoid.UseJumpPower then not Humanoid.UseJumpPower and Humanoid.JumpHeight > 0 and Humanoid:GetStateEnabled(
            Enum.HumanoidStateType.Jumping
        ) else if Humanoid.JumpPower > 0 then Humanoid:GetStateEnabled(
            Enum.HumanoidStateType.Jumping
        ) else not Humanoid.UseJumpPower and Humanoid.JumpHeight > 0 and Humanoid:GetStateEnabled(
            Enum.HumanoidStateType.Jumping
        ))
    then
        arg5:EnableButton(true)

        return
    end

    arg5:EnableButton(false)
end

function t_2._setupConfigurations(arg6) -- line: 141
    -- upvalues:
    --  [1] CharacterUtil_m (copy)

    local function update() -- line: 142
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:UpdateEnabled()
    end

    local v7 = CharacterUtil_m.onChild("Humanoid", "Humanoid", function(arg7) -- line: 147
        -- upvalues:
        --  [1] arg6 (copy)
        --  [2] update (copy)

        arg6:UpdateEnabled()
        arg6:_reset()
        arg6._connectionUtil:trackConnection(
            "HUMANOID_JUMP_POWER",
            arg7:GetPropertyChangedSignal("JumpPower"):Connect(update)
        )
        arg6._connectionUtil:trackConnection(
            "HUMANOID_JUMP_HEIGHT",
            arg7:GetPropertyChangedSignal("JumpHeight"):Connect(update)
        )
        arg6._connectionUtil:trackConnection("HUMANOID_STATE_ENABLED_CHANGED", arg7.StateEnabledChanged:Connect(
            function(state: HumanoidStateType, isEnabled: boolean) -- line: 160
                -- upvalues:
                --  [1] arg6 (ref)

                if state == Enum.HumanoidStateType.Jumping and isEnabled ~= arg6._active then
                    arg6:UpdateEnabled()
                end
            end
        ))
    end)
    arg6._connectionUtil:trackConnection("HUMANOID", v7)
end

function t_2.Enable(arg10, arg11, arg12) -- line: 172
    if arg12 then
        arg10.parentUIFrame = arg12
    end

    if arg10.externallyEnabled == arg11 then
        return
    end

    arg10.externallyEnabled = arg11
    arg10:UpdateEnabled()

    if arg11 then
        arg10:_setupConfigurations()

        return
    end

    arg10._connectionUtil:disconnectAll()
end

function t_2.Create(arg13) -- line: 189
    -- upvalues:
    --  [1] UserAllowAbilityControls (copy)
    --  [2] AvatarAbilitiesInterface_m (ref)
    --  [3] t (copy)

    if not arg13.parentUIFrame then
        return
    end

    if arg13.jumpButton then
        arg13.jumpButton:Destroy()
        arg13.jumpButton = nil
    end

    if arg13.absoluteSizeChangedConn then
        arg13.absoluteSizeChangedConn:Disconnect()
        arg13.absoluteSizeChangedConn = nil
    end

    if UserAllowAbilityControls and arg13.avatarAbilitiesEnabledChangedConn then
        arg13.avatarAbilitiesEnabledChangedConn:Disconnect()
        arg13.avatarAbilitiesEnabledChangedConn = nil
    end

    arg13.jumpButton = Instance.new("ImageButton")
    arg13.jumpButton.Name = "JumpButton"
    arg13.jumpButton.Visible = false
    arg13.jumpButton.BackgroundTransparency = 1

    if UserAllowAbilityControls and AvatarAbilitiesInterface_m.isEnabled() then
        arg13.jumpButton.Image = t[1]
    else
        arg13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
        arg13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
        arg13.jumpButton.ImageRectSize = Vector2.new(144, 144)
    end

    local function ResizeJumpButton() -- line: 224
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] UserAllowAbilityControls (ref)
        --  [3] AvatarAbilitiesInterface_m (ref)
        --  [4] t (ref)

        local v8 = math.min(arg13.parentUIFrame.AbsoluteSize.x, arg13.parentUIFrame.AbsoluteSize.y) <= 500 and true
        local v10

        if UserAllowAbilityControls and AvatarAbilitiesInterface_m.isEnabled() then
            local v9 = if not v8 then 120 else 72
            v10 = if not v8 then 100 else 64
            local v11 = if not v8 then 112 else 64
            local v12 = -v9 - v10
            v10 = -v9 - v11
            arg13.jumpButton.Image = t[1]
            arg13.jumpButton.ImageRectOffset = Vector2.new(0, 0)
            arg13.jumpButton.ImageRectSize = Vector2.new(0, 0)
            arg13.jumpButton.Size = UDim2.new(0, v9, 0, v9)
            arg13.jumpButton.Position = UDim2.new(1, v12, 1, v10)

            return
        end

        v10 = if not v8 then 120 else 70

        if UserAllowAbilityControls then
            arg13.jumpButton.Image = "rbxasset://textures/ui/Input/TouchControlsSheetV2.png"
            arg13.jumpButton.ImageRectOffset = Vector2.new(1, 146)
            arg13.jumpButton.ImageRectSize = Vector2.new(144, 144)
        end

        arg13.jumpButton.Size = UDim2.new(0, v10, 0, v10)
        local JumpButton_10 = arg13.jumpButton
        JumpButton_10.Position = v8 and UDim2.new(1, -(v10 * 1.5 - 10), 1, -v10 - 20) or UDim2.new(
            1,
            -(v10 * 1.5 - 10),
            1,
            -v10 * 1.75
        )
    end

    ResizeJumpButton()
    arg13.absoluteSizeChangedConn = arg13.parentUIFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(
        ResizeJumpButton
    )

    if UserAllowAbilityControls then
        arg13.avatarAbilitiesEnabledChangedConn = AvatarAbilitiesInterface_m.GetEnabledChangedSignal():Connect(
            ResizeJumpButton
        )
    end

    arg13.touchObject = nil
    arg13.jumpButton.InputBegan:connect(function(input_1: InputObject) -- line: 262
        -- upvalues:
        --  [1] arg13 (copy)
        --  [2] UserAllowAbilityControls (ref)
        --  [3] AvatarAbilitiesInterface_m (ref)
        --  [4] t (ref)

        if
            arg13.touchObject
            or input_1.UserInputType ~= Enum.UserInputType.Touch
            or input_1.UserInputState ~= Enum.UserInputState.Begin
        then
            return
        end

        arg13.touchObject = input_1

        if UserAllowAbilityControls and AvatarAbilitiesInterface_m.isEnabled() then
            arg13.jumpButton.Image = t[2]
        else
            arg13.jumpButton.ImageRectOffset = Vector2.new(146, 146)
        end

        arg13.isJumping = true
    end)
    arg13.jumpButton.Parent = arg13.parentUIFrame
end

return t_2
