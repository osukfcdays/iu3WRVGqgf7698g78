local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 11
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 23
    arg1:_AnchorModel(0)
    wait(1)
    arg1:_AnchorModel(0, false)
    arg1:_Ragdoll()
    arg1:_AnchorModel()
end

function t.PlayClient(arg2, ...) -- line: 31
    -- upvalues:
    --  [1] RunService (copy)

    local t_2 = {}

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") and val.Transparency < 0.99 then
            t_2[val] = val.CFrame

            if val.Name == "Head" then
                val.Transparency = 1
            else
                val:SetAttribute("WrapGroup", 1)
                val:SetAttribute("IgnoreObject", true)
                val:AddTag("Wrappable")
            end
        elseif val:IsA("Texture") or val:IsA("Decal") then
            val:Destroy()
        end
    end

    local v3 = arg2._is_humanoid and arg2._subject.Parent or arg2._subject
    v3:SetAttribute("WrapName", "Encroached")
    v3:AddTag("WrapThis")
    v3 = tick()
    local RenderSteppedConnection = RunService.RenderStepped:Connect(function(_) -- line: 57
        -- upvalues:
        --  [1] v3 (copy)
        --  [2] t_2 (copy)

        local v4 = 5 * (1 - (tick() - v3) / 1) ^ 4

        for key_1, val_1 in pairs(t_2) do
            local v5 = math.random() - 0.5
            key_1.CFrame = val_1 + Vector3.new(v5, math.random() - 0.5, math.random() - 0.5) * v4
        end
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://118282338053058",
        1.75,
        1 + 0.1 * math.random(),
        nil,
        true,
        5
    )
    wait(1)
    RenderSteppedConnection:Disconnect()

    for key_2, val_2 in pairs(t_2) do
        key_2.CFrame = val_2
    end

    arg2:_AnchorModel(0, false)
end

function t._Init(_) -- line: 85
end

return t
