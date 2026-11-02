local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _ = game:GetService("Players")
local DuelLibrary_m = require(ReplicatedStorage.Modules.DuelLibrary)
local t = {}
t.__index = t

function t.new(arg1) -- line: 9
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.DuelInterface = arg1
    t_1.Frame = t_1.DuelInterface.Frame:WaitForChild("HeadHoncho")
    t_1.Container = t_1.Frame:WaitForChild("Container")
    t_1.HeadHonchoFrame = t_1.Container:WaitForChild("HeadHoncho")
    t_1.HeadHonchoBackground = t_1.HeadHonchoFrame:WaitForChild("Background")
    t_1.BodyguardFrame = t_1.Container:WaitForChild("Bodyguard")
    t_1.BodyguardBackground = t_1.BodyguardFrame:WaitForChild("Background")
    t_1:_Init()

    return t_1
end

function t.Update(arg2) -- line: 29
    -- upvalues:
    --  [1] DuelLibrary_m (copy)

    local v1 = not arg2.DuelInterface.Scoreboard:IsOpen()

    if v1 then
        v1 = not arg2.DuelInterface.Voting:IsOpen()

        if v1 then
            v1 = not arg2.DuelInterface:IsPageOpen()

            if v1 then
                v1 = not arg2.DuelInterface.RoundResult.Frame.Visible
            end
        end
    end

    local v2 = if not arg2.DuelInterface.ClientDuel.LocalDueler then nil else arg2.DuelInterface.ClientDuel.LocalDueler:Get(
        "IsHeadHoncho"
    )
    local v3 = arg2.DuelInterface.ClientDuel.LocalDueler
    local v4 = DuelLibrary_m

    if v3 then
        v3 = arg2.DuelInterface.ClientDuel.LocalDueler:Get("TeamID")
    end

    local v5 = v4:GetTeamColor(v3)
    v3 = v1
    local Frame = arg2.Frame

    if v3 then
        v3 = if arg2.DuelInterface.ClientDuel:Get("Status") == "GameOver" then false else true
    end

    Frame.Visible = v3
    local HeadHonchoFrame = arg2.HeadHonchoFrame
    v3 = v2 == true
    HeadHonchoFrame.Visible = v3
    local BodyguardFrame = arg2.BodyguardFrame
    v3 = v2 == false
    BodyguardFrame.Visible = v3
    arg2.HeadHonchoBackground.ImageColor3 = v5
    arg2.BodyguardBackground.ImageColor3 = v5
end

function t.Destroy(_) -- line: 41
end

function t._Init(arg4) -- line: 49
    arg4.DuelInterface.RoundResult.Frame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 50
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:Update()
    end)
    arg4.DuelInterface.Scoreboard.VisibilityChanged:Connect(function() -- line: 54
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:Update()
    end)
    arg4.DuelInterface.Voting.VisibilityChanged:Connect(function() -- line: 58
        -- upvalues:
        --  [1] arg4 (copy)

        arg4:Update()
    end)
end

return t
