local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local SettingsLibrary_m = require(ReplicatedStorage.Modules.SettingsLibrary)
local InputLibrary_m = require(ReplicatedStorage.Modules.InputLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController
)
local ControlsController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.ControlsController
)
local KeybindSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("KeybindSlot")
local t = {}
t.__index = t

function t._new() -- line: 16
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1._objects = {}
    t_1._generate_hashes = {}
    t_1:_Init()

    return t_1
end

function t._ObjectRemoved(arg1, arg2) -- line: 37
    arg1._generate_hashes[arg2] = (arg1._generate_hashes[arg2] or 0) + 1

    if arg1._objects[arg2] then
        arg1._objects[arg2].Slot:Destroy()
        arg1._objects[arg2] = nil
    end
end

function t._ObjectAdded(arg3, arg4) -- line: 46
    -- upvalues:
    --  [1] Players (copy)
    --  [2] ReplicatedStorage (copy)
    --  [3] InputLibrary_m (copy)
    --  [4] KeybindSlot (copy)

    arg3:_ObjectRemoved(arg4)
    local v1 = arg4:IsDescendantOf(Players.LocalPlayer.PlayerGui) or arg4:IsDescendantOf(workspace) or arg4:IsDescendantOf(
        ReplicatedStorage
    ) or arg4:IsDescendantOf(Players.LocalPlayer.PlayerScripts.Assets.Temp)

    if not v1 then
        return
    end

    v1 = arg3._generate_hashes[arg4]
    local InputName = arg4:GetAttribute("InputName")
    local EnumType = arg4:GetAttribute("EnumType")
    local EnumName = arg4:GetAttribute("EnumName")
    local v5, v6, v7, v8

    if EnumType and EnumType ~= "" and EnumName and EnumName ~= "" then
        local v2, v3, v4 = InputLibrary_m:GetInputIcons(EnumType, EnumName)
        v5 = v2
        v6 = v3
        v7 = v4
        v8 = Enum[EnumType][EnumName]
    elseif InputName and InputName ~= "" then
        local v9, v10, v11 = InputLibrary_m:GetInputIconsByInputName(InputName)
        v5 = v9
        v6 = v10
        v7 = v11
        v8 = InputLibrary_m:FindFirstEnum(InputName)
    else
        return
    end

    if not v8 or v1 ~= arg3._generate_hashes[arg4] then
        return
    end

    local v12 = KeybindSlot:Clone()
    v12.Icon.Image = v5
    v12.Icon.Title.Text = v7
    v12.Name = v1
    v12.Parent = arg4
    arg3._objects[arg4] = { Enum = v8, Icon = v5, PressedIcon = v6, InputString = v7, Slot = v12 }
end

function t._AddAllObjects(arg5) -- line: 97
    -- upvalues:
    --  [1] CollectionService (copy)

    for _, val in pairs(CollectionService:GetTagged("UIKeybindContainer")) do
        arg5:_ObjectAdded(val)
    end
end

function t._Init(arg6) -- line: 103
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] UserInputService (copy)
    --  [3] ControlsController_m (copy)
    --  [4] SettingsLibrary_m (copy)
    --  [5] PlayerDataController_m (copy)

    CollectionService:GetInstanceRemovedSignal("UIKeybindContainer"):Connect(function(arg7) -- line: 104
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_ObjectRemoved(arg7)
    end)
    CollectionService:GetInstanceAddedSignal("UIKeybindContainer"):Connect(function(arg8) -- line: 108
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_ObjectAdded(arg8)
    end)
    UserInputService.InputBegan:Connect(function(input: InputObject) -- line: 112
        -- upvalues:
        --  [1] arg6 (copy)

        for _, val_1 in pairs(arg6._objects) do
            if val_1.Enum == input.KeyCode or val_1.Enum == input.UserInputType then
                val_1.Slot.Icon.Image = val_1.PressedIcon
                val_1.Slot.Icon.Title.Position = UDim2.new(0.5, 0, 0.525, 0)
            end
        end
    end)
    UserInputService.InputEnded:Connect(function(input_1: InputObject) -- line: 121
        -- upvalues:
        --  [1] arg6 (copy)

        for _, val_2 in pairs(arg6._objects) do
            if val_2.Enum == input_1.KeyCode or val_2.Enum == input_1.UserInputType then
                val_2.Slot.Icon.Image = val_2.Icon
                val_2.Slot.Icon.Title.Position = UDim2.new(0.5, 0, 0.45, 0)
            end
        end
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 130
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_AddAllObjects()
    end)

    for key_3, val_3 in pairs(SettingsLibrary_m.Info) do
        if val_3.InputType == "Hotkey" then
            PlayerDataController_m:GetSettingChangedSignal(key_3):Connect(function() -- line: 136
                -- upvalues:
                --  [1] arg6 (copy)

                arg6:_AddAllObjects()
            end)
        end
    end

    task.spawn(arg6._AddAllObjects, arg6)
end

return t._new()
