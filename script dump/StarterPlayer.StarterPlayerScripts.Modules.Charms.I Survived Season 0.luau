local Charm_m = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.Charm)
local t = setmetatable({}, Charm_m)
t.__index = t

function t.new(...) -- line: 8
    -- upvalues:
    --  [1] Charm_m (copy)
    --  [2] t (copy)

    local t_1 = setmetatable(Charm_m.new(...), t)
    t_1._textlabel = t_1.Model:WaitForChild("Extra"):WaitForChild("Part"):WaitForChild("SurfaceGui"):WaitForChild(
        "TextLabel"
    )
    t_1._textlabel2 = t_1.Model:WaitForChild("Extra"):WaitForChild("Part"):WaitForChild(
        "SurfaceGui2"
    ):WaitForChild("TextLabel")
    t_1:_Init()

    return t_1
end

function t._Setup(arg1) -- line: 29
    local v2 = arg1.EquippedData.Metadata and arg1.EquippedData.Metadata.BeforeSeason0ELOResetLeaderboardRank and "RANK #" .. arg1.EquippedData.Metadata.BeforeSeason0ELOResetLeaderboardRank or ""
    arg1._textlabel.Text = v2
    arg1._textlabel2.Text = v2
end

function t._Init(arg2) -- line: 36
    arg2:_Setup()
end

return t
