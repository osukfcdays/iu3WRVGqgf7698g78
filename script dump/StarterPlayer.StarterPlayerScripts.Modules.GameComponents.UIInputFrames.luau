local CollectionService = game:GetService("CollectionService")
local ControlsController_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Controllers:WaitForChild(
        "ControlsController"
    )
)
local t = {}
t.__index = t

function t._new() -- line: 9
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t._UpdateElement(_, arg2) -- line: 27
    -- upvalues:
    --  [1] ControlsController_m (copy)

    arg2:WaitForChild("MouseKeyboard").Visible = if ControlsController_m.CurrentControls ~= "MouseKeyboard" then false else true
    arg2:WaitForChild("Gamepad").Visible = if ControlsController_m.CurrentControls ~= "Gamepad" then false else true
    arg2:WaitForChild("Touch").Visible = if ControlsController_m.CurrentControls ~= "Touch" then false else true
end

function t._UpdateAllElements(arg3) -- line: 33
    -- upvalues:
    --  [1] CollectionService (copy)

    for _, val in pairs(CollectionService:GetTagged("UIInputFrame")) do
        arg3:_UpdateElement(val)
    end
end

function t._Init(arg4) -- line: 39
    -- upvalues:
    --  [1] CollectionService (copy)
    --  [2] ControlsController_m (copy)

    CollectionService:GetInstanceAddedSignal("UIInputFrame"):Connect(function(arg5) -- line: 40
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateElement(arg5)
    end)
    ControlsController_m.ControlsChanged:Connect(function() -- line: 44
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:_UpdateAllElements()
    end)
    task.spawn(arg4._UpdateAllElements, arg4)
end

return t._new()
