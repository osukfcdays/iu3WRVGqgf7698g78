local ClientViewModel_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild(
        "ClientReplicatedClasses"
    ):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel")
)
local t = setmetatable({}, ClientViewModel_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] ClientViewModel_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(ClientViewModel_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t._UpdateAnimationState(arg1) -- line: 26
    local v3 = arg1.ClientItem:Get("NumReloadsSoFar") % 2 + 1
    local v4 = if v3 == 1 then "Equip" else "State2Equip"
    local v5 = if v3 ~= 1 then "State2Idle" else "Idle"
    local v6 = if v3 ~= 1 then "State2Sprint" else "Sprint"
    local v7 = if v3 ~= 1 then "State2Inspect" else "Inspect"
    local v8 = if v3 ~= 1 then "State2Shoot" else "Shoot"
    arg1:ChangeEquipAnimation(v4)
    arg1:ChangeIdleAnimation(v5)
    arg1:ChangeSprintAnimation(v6)
    arg1:ChangeInspectAnimation(v7)
    arg1.ClientItem:ChangeShootAnimationNamePrefix(v8)
end

function t._Init(arg2) -- line: 41
    arg2.ClientItem:GetDataChangedSignal("NumReloadsSoFar"):Connect(function() -- line: 42
        -- upvalues:
        --  [1] arg2 (copy)

        arg2:_UpdateAnimationState()
    end)
    task.defer(arg2._UpdateAnimationState, arg2)
end

return t
