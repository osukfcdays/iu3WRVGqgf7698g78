local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogPage_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("Page"):WaitForChild(
        "DialogPage"
    )
)
local t = setmetatable({}, DialogPage_m)
t.__index = t

function t._new() -- line: 9
    -- upvalues:
    --  [1] DialogPage_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(DialogPage_m.new(script.Name), t)
    t_1:_Init()

    return t_1
end

function t.Open(arg1, ...) -- line: 21
    -- upvalues:
    --  [1] DialogPage_m (copy)
    --  [2] ReplicatedStorage (copy)

    DialogPage_m.Open(arg1, ...)
    task.defer(arg1._FetchDialog, arg1, ReplicatedStorage.Remotes.Misc.FetchDialogAprilFools)
end

function t._Init(_) -- line: 30
end

return t._new()
