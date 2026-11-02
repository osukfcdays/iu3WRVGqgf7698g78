local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Finisher_m = require(ReplicatedStorage.Modules.Finisher)
local _ = require(ReplicatedStorage.Modules.Utility)
local t = setmetatable({}, Finisher_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Finisher_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Finisher_m.new(...), t)
    t_1:_Init()

    return t_1
end

function t.PlayServer(arg1) -- line: 25
    arg1:_AnchorModel(0)
    wait(2.8)
    arg1:_HideBody()
end

function t.PlayClient(arg2) -- line: 33
    -- upvalues:
    --  [1] RunService (copy)

    local RootPart = arg2._subject.RootPart
    local t_2 = {}

    local _ = function(arg3) --[[ register ]] -- line: 37
        -- upvalues:
        --  [1] t_2 (copy)

        local t_3 = { Exponent = 1 + 4 * math.random(), OriginalTransparency = nil }
        t_3.OriginalTransparency, t_2[arg3] = arg3.Transparency, t_3
    end

    for _, val in pairs(arg2:_GetObjects(true)) do
        if val:IsA("BasePart") and not (val.Transparency > 0.99) then
            local t_4 = {
                Exponent = 1 + 4 * math.random(),
                OriginalTransparency = val.Transparency
            }
            t_2[val] = t_4

            if val.Parent == RootPart.Parent then
                local SelectionBox = Instance.new("SelectionBox")
                SelectionBox.Adornee = val
                SelectionBox.Color = BrickColor.new("Toothpaste")
                SelectionBox.Parent = val
                local t_5 = {
                    Exponent = 1 + 4 * math.random(),
                    OriginalTransparency = SelectionBox.Transparency
                }
                t_2[SelectionBox] = t_5
            end
        end
    end

    local now = tick()

    local function set(arg4) -- line: 59
        -- upvalues:
        --  [1] t_2 (copy)

        for key_1, val_1 in pairs(t_2) do
            key_1.Transparency = val_1.OriginalTransparency + (1 - val_1.OriginalTransparency) * arg4 ^ val_1.Exponent
        end
    end

    local RenderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 65
        -- upvalues:
        --  [1] set (copy)
        --  [2] now (copy)

        local v4 = set
        local now_1 = tick()
        v4((math.clamp((now_1 - (now + 1.8)) / 1, 0, 1)))
    end)
    table.insert(arg2._connections, RenderSteppedConnection)
    arg2:CreateSound(
        "rbxassetid://130113415",
        1,
        1,
        RootPart,
        true,
        5
    )
    wait(2.8)
    RenderSteppedConnection:Disconnect()
    set(1)
    arg2:_HideBody()
end

function t._Init(_) -- line: 85
end

return t
