local CollectionService = game:GetService("CollectionService")
local v1 = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(v1.Modules.CONSTANTS)
local GameplayUtility_m = require(v1.Modules.GameplayUtility)
local Signal_m = require(v1.Modules.Signal)
v1 = CONSTANTS_m.IS_CLIENT

if v1 then
    v1 = require(Players.LocalPlayer.PlayerScripts.Controllers.SpectateController)
end

local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 15
    -- upvalues:
    --  [1] t (copy)
    --  [2] Signal_m (copy)

    local t_1 = setmetatable({}, t)
    t_1.SteppedOut = Signal_m.new()
    t_1.Warning = Signal_m.new()
    t_1.Kill = Signal_m.new()
    t_1._fighter_subject = arg1
    t_1._update_frequency = arg2 or 0.1
    t_1._next_update = 0
    t_1._oob_details = nil
    t_1._connections = {}
    t_1._object_connections = {}
    t_1._is_visible = false
    t_1:_Init()

    return t_1
end

function t.GetSubject(arg3) -- line: 39
    -- upvalues:
    --  [1] v1 (copy)

    return if not arg3._fighter_subject then v1 and v1.CurrentSubject and v1.CurrentSubject.IsLocalPlayer and v1.CurrentSubject.Entity else arg3._fighter_subject.Entity
end

function t.IsOutOfBounds(arg4) -- line: 44
    -- upvalues:
    --  [1] GameplayUtility_m (copy)

    local v2 = arg4:GetSubject()

    if not v2 or not v2:IsAlive() or not v2.RootPart then
        return
    end

    return GameplayUtility_m:IsWithinOOBPart(v2.RootPart.Position)
end

function t.SetVisible(arg5, arg6) -- line: 54
    -- upvalues:
    --  [1] CollectionService (copy)

    arg5._is_visible = arg6

    if arg5._is_visible then
        return
    end

    for _, val in pairs(CollectionService:GetTagged("OutOfBoundsSafePart")) do
        arg5:_UpdateVisibilityForPart(val)
    end

    for _, val_1 in pairs(CollectionService:GetTagged("OutOfBoundsPart")) do
        arg5:_UpdateVisibilityForPart(val_1)
    end
end

function t.Update(arg7, _) -- line: 70
    -- upvalues:
    --  [1] GameplayUtility_m (copy)

    if tick() < arg7._next_update then
        return
    end

    arg7._next_update = tick() + arg7._update_frequency

    if arg7:_CheckKill() then
        return
    end

    local v5 = arg7:IsOutOfBounds()

    if not v5 then
        if arg7._oob_details then
            arg7._oob_details = nil
            arg7.SteppedOut:Fire()
        end
    elseif not arg7._oob_details or v5 ~= arg7._oob_details.Part then
        local v7 = GameplayUtility_m:GetOOBWarnDelay(v5:GetAttribute("WarnDelay"))
        local v9 = GameplayUtility_m:GetOOBKillDelay(v5:GetAttribute("KillDelay"))
        local v10 = v7 + v9

        if not arg7._oob_details or v10 < arg7._oob_details.KillTime - tick() then
            arg7._oob_details = { Part = v5, WarnTime = tick() + v7, KillTime = tick() + v7 + v9 }
            arg7.Warning:Fire(v7 + v9)
        end
    end

    arg7:_CheckKill()
end

function t.Destroy(arg9) -- line: 107
    arg9.SteppedOut:Destroy()
    arg9.Warning:Destroy()
    arg9.Kill:Destroy()

    for _, val_2 in pairs(arg9._connections) do
        val_2:Disconnect()
    end

    for _, val_3 in pairs(arg9._object_connections) do
        for _, val_4 in pairs(val_3) do
            val_4:Disconnect()
        end
    end
end

function t._CheckKill(arg10) -- line: 127
    if arg10._oob_details and tick() >= arg10._oob_details.KillTime then
        arg10.Kill:Fire(arg10._oob_details.Part, arg10:GetSubject() or nil)
        arg10._oob_details = nil
        arg10.SteppedOut:Fire()

        return true
    end
end

function t._UpdateVisibilityForPart(arg11, arg12) -- line: 136
    if arg11._is_visible then
        arg12.Transparency = 0
        arg12.Material = Enum.Material.ForceField
        arg12.Color = Color3.fromRGB(255, 215, 0)

        return
    end

    task.defer(arg12.ClearAllChildren, arg12)
    arg12.Transparency = 1
end

function t._ObjectAdded(arg13, arg14) -- line: 147
    arg13:_ObjectRemoved(arg14)
    arg13._object_connections[arg14] = {}
    table.insert(arg13._object_connections[arg14], arg14.ChildAdded:Connect(function(
        child: Instance
    ) -- line: 152
        task.defer(child.Destroy, child)
    end))
    arg13:_UpdateVisibilityForPart(arg14)
end

function t._ObjectRemoved(arg16, arg17) -- line: 159
    local v13 = pairs
    local v14 = arg16._object_connections[arg17] or {}

    for _, val_5 in v13(v14) do
        val_5:Disconnect()
    end

    arg16._object_connections[arg17] = nil
end

function t._Init(arg18) -- line: 167
    -- upvalues:
    --  [1] CollectionService (copy)

    local Connections = arg18._connections
    local OutOfBoundsPart = CollectionService:GetInstanceAddedSignal("OutOfBoundsPart")
    table.insert(Connections, OutOfBoundsPart:Connect(function(arg19) -- line: 168
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_ObjectAdded(arg19)
    end))
    local Connections_1 = arg18._connections
    local OutOfBoundsSafePart = CollectionService:GetInstanceAddedSignal("OutOfBoundsSafePart")
    table.insert(Connections_1, OutOfBoundsSafePart:Connect(function(arg20) -- line: 172
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_ObjectAdded(arg20)
    end))
    local v15 = pairs
    local _ = OutOfBoundsSafePart:Connect(function(arg20) -- line: 172
        -- upvalues:
        --  [1] arg18 (copy)

        arg18:_ObjectAdded(arg20)
    end)

    for _, val_6 in v15(CollectionService:GetTagged("OutOfBoundsPart")) do
        task.defer(arg18._ObjectAdded, arg18, val_6)
    end

    for _, val_7 in pairs(CollectionService:GetTagged("OutOfBoundsSafePart")) do
        task.defer(arg18._ObjectAdded, arg18, val_7)
    end
end

return t
