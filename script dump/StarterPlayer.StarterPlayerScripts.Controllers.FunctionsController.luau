local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("TeleportService")
local Players = game:GetService("Players")
local EnumLibrary_m = require(ReplicatedStorage.Modules.EnumLibrary)
local Functions = Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Functions")
local t = {}
t.__index = t

function t._new() -- line: 12
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1:_Init()

    return t_1
end

function t.FireAsync(_, arg2, ...) -- line: 24
    -- upvalues:
    --  [1] Functions (copy)
    --  [2] EnumLibrary_m (copy)

    require(Functions[EnumLibrary_m:FromEnum(arg2)])(...)
end

function t.FireSync(arg3, ...) -- line: 29
    task.spawn(arg3.FireAsync, arg3, ...)
end

function t._Init(arg4) -- line: 37
    -- upvalues:
    --  [1] ReplicatedStorage (copy)
    --  [2] EnumLibrary_m (copy)

    ReplicatedStorage.Remotes.Misc.TeleportFailed.OnClientEvent:Connect(function(arguments) -- line: 38
        -- upvalues:
        --  [1] arg4 (copy)
        --  [2] EnumLibrary_m (ref)

        local t_2 = {
            Text = "[SERVER] Teleport failed, please try again. Error: " .. tostring(arguments),
            Color = Color3.fromRGB(255, 50, 50)
        }
        arg4:FireAsync(EnumLibrary_m:ToEnum("SendChat"), t_2)
    end)
    ReplicatedStorage.Remotes.Misc.Functions.OnClientEvent:Connect(function(...) -- line: 47
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:FireAsync(...)
    end)
    ReplicatedStorage.Remotes.Misc.FunctionsUnreliable.OnClientEvent:Connect(function(...) -- line: 51
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:FireAsync(...)
    end)
end

return t._new()
