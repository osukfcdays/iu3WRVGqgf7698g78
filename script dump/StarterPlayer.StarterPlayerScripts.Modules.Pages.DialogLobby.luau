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
    t_1._npc_name = nil
    t_1:_Init()

    return t_1
end

function t.SetNPCName(arg1, arg2) -- line: 23
    arg1._npc_name = arg2
    arg1:_UpdateFetch()
end

function t._UpdateFetch(arg3) -- line: 32
    -- upvalues:
    --  [1] ReplicatedStorage (copy)

    if not arg3._npc_name then
        return
    end

    task.defer(
        arg3._FetchDialog,
        arg3,
        ReplicatedStorage.Remotes.Misc.FetchDialogLobby,
        arg3._npc_name
    )
end

function t._Init(arg4) -- line: 40
    arg4:HookDialogActionKey("OpenCreditsPage", function() -- line: 41
        -- upvalues:
        --  [1] arg4 (copy)

        arg4.OpenPage:Fire("Credits")
    end)
end

return t._new()
