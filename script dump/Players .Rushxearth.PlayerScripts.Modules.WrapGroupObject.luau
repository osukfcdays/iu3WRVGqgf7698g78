local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local t = {}
t.__index = t

function t.new(arg1, arg2, arg3) -- line: 8
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Name = arg1
    t_1.Object = arg2
    t_1.ExtraObjects = arg3
    t_1.IsDestroyed = nil
    t_1._cleanup = {}
    t_1._connections = {}
    t_1._tweens = {}
    t_1._threads = {}
    t_1:_Init()

    return t_1
end

function t.IsActive(arg4) -- line: 33
    return arg4:_IsAncestryVisible()
end

function t.Destroy(arg5) -- line: 37
    if arg5.IsDestroyed then
        return
    end

    arg5.IsDestroyed = true

    for _, val in pairs(arg5._connections) do
        val:Disconnect()
    end

    for _, val_1 in pairs(arg5._cleanup) do
        val_1:Destroy()
    end

    for _, val_2 in pairs(arg5._tweens) do
        val_2:Cancel()
        val_2:Destroy()
    end

    for _, val_3 in pairs(arg5._threads) do
        pcall(task.cancel, val_3)
    end

    arg5._connections = {}
    arg5._cleanup = {}
    arg5._tweens = {}
    arg5._threads = {}
end

function t._IsAncestryVisible(arg6) -- line: 71
    -- upvalues:
    --  [1] PlayerGui (copy)

    if arg6.Object:IsDescendantOf(workspace) then
        return true
    end

    if not arg6.Object:IsDescendantOf(PlayerGui) then
        return false
    end

    local Parent = arg6.Object.Parent

    while true do
        if not Parent or Parent == game then
            return false
        end

        if Parent:IsA("LayerCollector") then
            return Parent.Enabled
        end

        if Parent:IsA("GuiBase2d") and not Parent.Visible then
            return false
        end

        Parent = Parent.Parent
    end
end

function t._Init(arg7) -- line: 95
    arg7.Object.Destroying:Connect(function() -- line: 96
        -- upvalues:
        --  [1] arg7 (copy)

        arg7:Destroy()
    end)
end

return t
