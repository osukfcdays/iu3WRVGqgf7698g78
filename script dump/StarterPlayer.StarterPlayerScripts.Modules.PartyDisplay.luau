local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CONSTANTS_m = require(ReplicatedStorage.Modules.CONSTANTS)
local PartyController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PartyController")
)
local Matchmaking_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Lobby"):WaitForChild(
        "Matchmaking"
    )
)
local Pages_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages")
)
local ButtonEffect_m = require(
    Players.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect")
)
local PartyMemberSlot = Players.LocalPlayer.PlayerScripts.UserInterface:WaitForChild(
    "PartyMemberSlot"
)
local t = {}
t.__index = t

function t.new(arg1, arg2) -- line: 15
    -- upvalues:
    --  [1] t (copy)

    local t_1 = setmetatable({}, t)
    t_1.Frame = arg1
    t_1._connections = {}
    t_1._slots = {}
    t_1._inverted_order = arg2
    t_1:_Init()

    return t_1
end

function t.Destroy(arg3) -- line: 33
    for _, val in pairs(arg3._connections) do
        val:Disconnect()
    end

    arg3:_Clear()
end

function t._Clear(arg4) -- line: 45
    for _, val_1 in pairs(arg4._slots) do
        val_1:Destroy()
    end

    arg4._slots = {}
end

function t._Generate(arg5) -- line: 53
    -- upvalues:
    --  [1] PartyController_m (copy)
    --  [2] Players (copy)
    --  [3] PartyMemberSlot (copy)
    --  [4] CONSTANTS_m (copy)
    --  [5] Matchmaking_m (copy)
    --  [6] Pages_m (copy)
    --  [7] ButtonEffect_m (copy)

    arg5:_Clear()
    local v5 = PartyController_m.CurrentParty or { Players.LocalPlayer }

    local function generate_slot(arg6, arg7) -- line: 58
        -- upvalues:
        --  [1] PartyMemberSlot (ref)
        --  [2] CONSTANTS_m (ref)
        --  [3] PartyController_m (ref)
        --  [4] arg5 (copy)
        --  [5] Matchmaking_m (ref)
        --  [6] Pages_m (ref)
        --  [7] ButtonEffect_m (ref)

        local v6 = PartyMemberSlot:Clone()
        v6.Button.Icon.Image = if not arg7 then "" else string.format(
            CONSTANTS_m.HEADSHOT_IMAGE,
            arg7.UserId
        )
        local v7 = PartyController_m.CurrentParty
        local Leader = v6.Button.Leader
        v7 = v7 and arg6 == 1
        Leader.Visible = v7
        v6.Button.Invite.Visible = not arg7
        v6.Button.Inputs.Visible = not arg7
        local Keybind = v6.Button.Inputs.Gamepad.Keybind
        Keybind.Position = arg5._inverted_order and UDim2.new(0.5, 0, -0.25, 0) or UDim2.new(
            1.25,
            0,
            0.5,
            0
        )
        v6.Size = if arg6 ~= 1 then UDim2.new(0.75, 0, 0.75, 0) else UDim2.new(1, 0, 1, 0) or UDim2.new(
            0.75,
            0,
            0.75,
            0
        )
        local v10 = if not arg5._inverted_order then 1 else -1
        v6.LayoutOrder = arg6 * v10
        v6.Button.MouseButton1Click:Connect(function() -- line: 68
            -- upvalues:
            --  [1] Matchmaking_m (ref)
            --  [2] Pages_m (ref)

            if Matchmaking_m:IsVisible() then
                return
            end

            local v11 = Pages_m.PageSystem.CurrentPage and Pages_m.PageSystem.CurrentPage.Name
            Pages_m.PageSystem:OpenPage("Party", true)
            Pages_m.PageSystem:WaitForPage("Party"):RedirectTo(v11)
        end)
        v6.Parent = arg5.Frame
        table.insert(arg5._slots, v6)
        ButtonEffect_m:Add(v6.Button)
    end

    for key_2, val_2 in pairs(v5) do
        generate_slot(key_2, val_2)
    end

    if #v5 < CONSTANTS_m.MAX_PARTY_SIZE and PartyController_m:IsPartyLeader() then
        generate_slot(#v5 + 1, nil)
    end
end

function t._Init(arg8) -- line: 93
    -- upvalues:
    --  [1] PartyController_m (copy)

    table.insert(arg8._connections, PartyController_m.PartyChanged:Connect(function() -- line: 94
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_Generate()
    end))
    arg8:_Generate()
end

return t
