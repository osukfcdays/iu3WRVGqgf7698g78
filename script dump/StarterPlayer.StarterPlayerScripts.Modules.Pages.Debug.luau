local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DebugLibrary_m = require(ReplicatedStorage.Modules.DebugLibrary)
local PlayerDataController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController")
)
local DebugController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("DebugController")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PromptSystem_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("PromptSystem")
)
local Page_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"))
local EmptySlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("EmptySlot")
local Settings = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Settings")
local t = setmetatable({}, Page_m)
t.__index = t

function t._new() -- line: 17
    -- upvalues:
    --  [1] Page_m (copy)
    --  [2] t (copy)
    --  [3] PromptSystem_m (copy)

    local t_1 = setmetatable(Page_m.new(script.Name), t)
    t_1.CloseButton = t_1.PageFrame:WaitForChild("Close")
    t_1.PromptsFrame = t_1.PageFrame:WaitForChild("Prompts")
    t_1.List = t_1.PageFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1.DisableGlowyBackground = true
    t_1.UseDarkBlurryBackground = true
    t_1.PromptSystem = PromptSystem_m.new(t_1.PromptsFrame)
    t_1.SettingObjects = {}
    t_1.HidePartyDisplay = true
    t_1._open_animation_disabled = true
    t_1:_Init()

    return t_1
end

function t._Setup(arg1) -- line: 49
    -- upvalues:
    --  [1] Settings (copy)
    --  [2] DebugController_m (copy)
    --  [3] EmptySlot (copy)
    --  [4] DebugLibrary_m (copy)
    --  [5] PlayerDataController_m (copy)

    local v7 = 0
    local v8 = false

    local function create_command(arg2) -- line: 53
        -- upvalues:
        --  [1] Settings (ref)
        --  [2] DebugController_m (ref)
        --  [3] v7 (ref)
        --  [4] arg1 (copy)

        local v9 = require(Settings:WaitForChild(arg2.InputType)).new(arg2)
        v9.Replicate:Connect(function() -- line: 57
            -- upvalues:
            --  [1] DebugController_m (ref)
            --  [2] arg2 (copy)
            --  [3] v9 (copy)

            DebugController_m:Command(arg2.Name, v9.Value)
        end)
        v9.SettingFrame.LayoutOrder = v7
        v9.SettingFrame.Parent = arg1.Container
        arg1.SettingObjects[arg2.Name] = v9
        v7 += 1
    end

    local function create_empty_slots(arg3) -- line: 67
        -- upvalues:
        --  [1] v7 (ref)
        --  [2] EmptySlot (ref)
        --  [3] arg1 (copy)

        local v10 = arg3 or 0

        for _ = 1, math.max(0, v10 - v7) + 2 - (if v10 < v7 then (v7 - 1) % 2 + 1 else 0) do
            local v14 = EmptySlot:Clone()
            v14.LayoutOrder = v7
            v14.Parent = arg1.Container
            v7 += 1
        end
    end

    for _, val in pairs(DebugLibrary_m.Order) do
        if DebugLibrary_m:IsAuthorizedToUseCommand(
            val.Name,
            PlayerDataController_m:Get("PermissionsRoles")
        ) then
            if val.InputType == "Divider" then
                if v8 then
                    create_empty_slots()

                    for _ = 1, v7 % 2 + 2 do
                        create_command(val)
                    end
                end
            else
                v8 = true
                create_command(val)
            end
        end
    end

    create_empty_slots(16)
end

function t._Init(arg4) -- line: 100
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg4.CloseButton.MouseButton1Click:Connect(function() -- line: 101
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:CloseRequest()
    end)
    arg4.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 105
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.List.CanvasSize = UDim2.new(0, 0, 0, arg4.Layout.AbsoluteContentSize.Y)
    end)
    arg4:_Setup()
    ButtonEffect_m:Add(arg4.CloseButton)
end

return t._new()
