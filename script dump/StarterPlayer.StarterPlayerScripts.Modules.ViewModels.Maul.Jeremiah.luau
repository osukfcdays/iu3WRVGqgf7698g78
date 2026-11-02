local RunService = game:GetService("RunService")
local Maul_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild(
        "Maul"
    )
)
local t = setmetatable({}, Maul_m)
t.__index = t

function t.new(...) -- line: 13
    -- upvalues:
    --  [1] Maul_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Maul_m.new(...), t)
    t_1._eyelids = {}
    t_1:_Init()

    return t_1
end

function t._SetupEyelids(arg1) -- line: 33
    -- upvalues:
    --  [1] RunService (copy)

    local Eyelids = arg1.ItemModel:WaitForChild("Body"):WaitForChild("Eyelids")
    local t_2 = {}

    local _ = function() --[[ get_blink_cooldown ]] -- line: 37
        return 0.5 + 3.5 * math.random()
    end

    local function eyelid_added(arg2) -- line: 41
        -- upvalues:
        --  [1] t_2 (copy)
        --  [2] arg1 (copy)

        local t_3 = { Object = arg2, NextBlink = nil }
        local v3 = t_2
        t_3.NextBlink = tick() + (0.5 + 3.5 * math.random())
        table.insert(v3, t_3)
        arg1:_LocalTransparencyModifier(arg2, "Blink", 1)
    end

    Eyelids.ChildAdded:Connect(eyelid_added)

    for _, child in pairs(Eyelids:GetChildren()) do
        eyelid_added(child)
    end

    while true do
        if arg1._destroyed then
            break
        end

        for _, val in pairs(t_2) do
            if not (tick() < val.NextBlink) then
                val.NextBlink = tick() + (0.5 + 3.5 * math.random())
                arg1:_LocalTransparencyModifier(val.Object, "Blink", 0)
                task.delay(
                    0.1,
                    arg1._LocalTransparencyModifier,
                    arg1,
                    val.Object,
                    "Blink",
                    1
                )
            end
        end

        RunService.RenderStepped:Wait()
    end
end

function t._Init(arg3) -- line: 68
    task.spawn(arg3._SetupEyelids, arg3)
end

return t
