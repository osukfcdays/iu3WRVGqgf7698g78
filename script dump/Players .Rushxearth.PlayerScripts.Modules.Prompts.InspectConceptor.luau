local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local ConceptsLibrary_m = require(ReplicatedStorage.Modules.ConceptsLibrary)
local CosmeticLibrary_m = require(ReplicatedStorage.Modules.CosmeticLibrary)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local RewardSlot_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("RewardSlot"))
local Prompt_m = require(Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("Prompt"))
local t = setmetatable({}, Prompt_m)
t.__index = t

function t.new(arg1, arg2) -- line: 14
    -- upvalues:
    --  [1] Prompt_m (copy)
    --  [2] t (copy)
    --  [3] ConceptsLibrary_m (copy)

    local t_1 = setmetatable(Prompt_m.new(script.Name), t)
    t_1.CloseButton = t_1.PromptFrame:WaitForChild("Close")
    t_1.Headshot = t_1.PromptFrame:WaitForChild("Headshot")
    t_1.Title = t_1.PromptFrame:WaitForChild("Title")
    t_1.Points = t_1.PromptFrame:WaitForChild("Points")
    t_1.List = t_1.PromptFrame:WaitForChild("List")
    t_1.Container = t_1.List:WaitForChild("Container")
    t_1.Layout = t_1.Container:WaitForChild("Layout")
    t_1._user_id = arg1
    t_1._username = arg2
    t_1._conceptor_info = ConceptsLibrary_m.Conceptors[tostring(t_1._user_id)]
    t_1._reward_slots = {}
    t_1:_Init()

    return t_1
end

function t.Destroy(arg3) -- line: 39
    -- upvalues:
    --  [1] Prompt_m (copy)

    for _, val in pairs(arg3._reward_slots) do
        val:Destroy()
    end

    Prompt_m.Destroy(arg3)
end

function t._Update(arg4) -- line: 51
    arg4.List.CanvasSize = UDim2.new(0, 0, 0, arg4.Layout.AbsoluteContentSize.Y)
    local List_1 = arg4.List
    List_1.ClipsDescendants = arg4.List.AbsoluteCanvasSize.Y > arg4.List.AbsoluteWindowSize.Y
end

function t._Setup(arg5) -- line: 56
    -- upvalues:
    --  [1] ConceptsLibrary_m (copy)
    --  [2] CONSTANTS_m (copy)
    --  [3] CosmeticLibrary_m (copy)
    --  [4] RewardSlot_m (copy)

    arg5.Title.Text = arg5._username
    arg5.Points.Text = string.format("%.1f", ConceptsLibrary_m:GetConceptScore(arg5._user_id)) .. " points"
    arg5.Headshot.Image = string.format(CONSTANTS_m.HEADSHOT_IMAGE, arg5._user_id)

    for _, val_1 in pairs(arg5._conceptor_info.CosmeticConcepts) do
        local v6 = RewardSlot_m.new(
            { Name = val_1, Weapon = CosmeticLibrary_m.Cosmetics[val_1].ItemName }
        )
        v6:SetParent(arg5.Container)
        table.insert(arg5._reward_slots, v6)
    end
end

function t._Init(arg6) -- line: 69
    -- upvalues:
    --  [1] ButtonEffect_m (copy)

    arg6.CloseButton.MouseButton1Click:Connect(function() -- line: 70
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:CloseRequest()
    end)
    arg6.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 74
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_Update()
    end)
    arg6.List:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 78
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_Update()
    end)
    arg6.List:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 82
        -- upvalues:
        --  [1] arg6 (copy)

        arg6:_Update()
    end)
    arg6:_Setup()
    arg6:_Update()
    ButtonEffect_m:Add(arg6.CloseButton)
end

return t
