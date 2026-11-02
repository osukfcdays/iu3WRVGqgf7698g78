local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local Pages_m = require(Players.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages)
local t = {}
t.__index = t

function t.new(arg1) -- line: 10
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.ClientQueuePad = arg1
    t_1._model = t_1.ClientQueuePad:Get("Model"):WaitForChild("Visuals"):WaitForChild("Terminal")
    t_1._proximity_prompt = t_1._model:WaitForChild("Prompt"):WaitForChild("ProximityPrompt")
    t_1:_Init()

    return t_1
end

function t.Destroy(_) -- line: 27
end

function t._Setup(arg3) -- line: 35
    -- upvalues:
    --  [1] CONSTANTS_m (copy)
    --  [2] Players (copy)

    arg3._proximity_prompt.ObjectText = arg3.ClientQueuePad:Get("Model").Name
    arg3._proximity_prompt.MaxActivationDistance = 8

    if not CONSTANTS_m.IS_PRIVATE_SERVER_OWNER(Players.LocalPlayer.UserId) then
        task.defer(arg3._model.Destroy, arg3._model)
    end
end

function t._Init(arg4) -- line: 44
    -- upvalues:
    --  [1] Pages_m (copy)

    arg4._proximity_prompt.Triggered:Connect(function() -- line: 45
        -- upvalues:
        --  [1] Pages_m (ref)
        --  [2] arg4 (copy)

        Pages_m.PageSystem:OpenPage("EditQueuePad", true)
        Pages_m.PageSystem:WaitForPage("EditQueuePad"):SetQueuePad(arg4.ClientQueuePad)
    end)
    arg4:_Setup()
end

return t
