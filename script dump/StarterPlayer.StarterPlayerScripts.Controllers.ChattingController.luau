local _ = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local SpectateController_m = require(
    Players.LocalPlayer.PlayerScripts.Controllers.SpectateController
)
local DuelController_m = require(Players.LocalPlayer.PlayerScripts.Controllers.DuelController)
local t_1 = { Result = "GG \226\157\164\239\184\143", Words = { "ggez" }, Messages = {} }
local t_3 = {
    Result = "you played well",
    Words = { "ur bad", "ur so bad", "you are so bad", "you are bad", "horrible" },
    Messages = {}
}
local t_5 = { Result = "W update \226\157\164\239\184\143", Words = { "l update" }, Messages = {} }
local t_7 = { Result = "well played \240\159\145\141", Words = { "gg ez" }, Messages = { "ez" } }
local t_10 = {
    Result = "nice loadout",
    Words = { "p2w", "pay to win", "pay 2 win" },
    Messages = {}
}
local t = { t_1, t_3, t_5, t_7, t_10 }
local t_12 = {}
t_12.__index = t_12

function t_12._new() -- line: 45
    -- upvalues:
    --  [1] t_12 (copy)

    local t_13 = setmetatable({}, t_12)
    t_13._muted_user_ids = {}
    t_13:_Init()

    return t_13
end

function t_12._UpdateChatBubblesEnabled(_) -- line: 65
    -- upvalues:
    --  [1] TextChatService (copy)
    --  [2] SpectateController_m (copy)

    local BubbleChatConfiguration = TextChatService:WaitForChild("BubbleChatConfiguration")
    BubbleChatConfiguration.Enabled = not SpectateController_m.CurrentDuelSubject or not SpectateController_m.CurrentDuelSubject.IsRanked
end

function t_12._DuelInterfaceBubble(arg2, arg3, arg4) -- line: 69
    -- upvalues:
    --  [1] DuelController_m (copy)

    if not arg3 or table.find(arg2._muted_user_ids, arg3.UserId) then
        return
    end

    local t_14 = {}

    for _, val in pairs(DuelController_m.Objects) do
        if val:GetDueler(arg3) then
            table.insert(t_14, val)
        end
    end

    if #t_14 == 0 then
        return
    end

    for _, val_1 in pairs(t_14) do
        val_1.DuelInterface.Scores:NewChatMessage(arg3, arg4)
    end
end

function t_12._SetupOnIncomingMessage(arg5) -- line: 98
    -- upvalues:
    --  [1] t (copy)
    --  [2] TextChatService (copy)
    --  [3] Players (copy)

    local function get_text_chat_message_properties(arg6) -- line: 99
        -- upvalues:
        --  [1] t (ref)

        if not arg6.TextSource then
            return
        end

        local v2 = false
        local v3 = arg6.Text

        for _, val_2 in pairs(t) do
            if table.find(val_2.Messages, string.lower(v3)) then
                v2 = true
                v3 = val_2.Result
                break
            end
        end

        if not v2 then
            local v4 = false

            for _, val_3 in pairs(t) do
                for _, val_4 in pairs(val_3.Words) do
                    local startIndex = string.find(string.lower(v3), val_4)

                    if startIndex then
                        v4 = true
                        v3 = string.sub(v3, 1, startIndex - 1) .. val_3.Result .. string.sub(
                            v3,
                            startIndex + #val_4
                        )
                    end
                end
            end

            if v4 then
            end
        end

        if v3 == arg6.Text then
            return
        end

        v2 = Instance.new("TextChatMessageProperties")
        v2.Text = v3

        return v2
    end

    function TextChatService.OnIncomingMessage(arg7) -- line: 147
        -- upvalues:
        --  [1] get_text_chat_message_properties (copy)
        --  [2] Players (ref)
        --  [3] arg5 (copy)

        local v6 = get_text_chat_message_properties(arg7)

        if arg7.Status == Enum.TextChatMessageStatus.Success then
            local v7 = arg7.TextSource

            if v7 then
                v7 = arg7.TextSource.UserId

                if v7 then
                    v7 = Players:GetPlayerByUserId(arg7.TextSource.UserId)
                end
            end

            local v8 = if not v6 then if arg7.Translation == "" then nil else arg7.Translation or nil else if v6.Translation == "" then if arg7.Translation == "" then nil else arg7.Translation or nil else v6.Translation or (if arg7.Translation == "" then nil else arg7.Translation or nil)
            local v9 = v6 and v6.Text or arg7.Text
            task.defer(arg5._DuelInterfaceBubble, arg5, v7, v8 or v9)
        end

        return v6
    end
end

function t_12._Init(arg8) -- line: 162
    -- upvalues:
    --  [1] SpectateController_m (copy)
    --  [2] StarterGui (copy)

    SpectateController_m.DuelSubjectChanged:Connect(function() -- line: 163
        -- upvalues:
        --  [1] arg8 (copy)

        arg8:_UpdateChatBubblesEnabled()
    end)
    task.spawn(function() -- line: 167
        -- upvalues:
        --  [1] StarterGui (ref)
        --  [2] arg8 (copy)

        StarterGui:GetCore("PlayerMutedEvent").Event:Connect(function(arguments) -- line: 168
            -- upvalues:
            --  [1] arg8 (ref)

            if not table.find(arg8._muted_user_ids, arguments.UserId) then
                table.insert(arg8._muted_user_ids, arguments.UserId)
            end
        end)
        StarterGui:GetCore("PlayerUnmutedEvent").Event:Connect(function(arguments_1) -- line: 174
            -- upvalues:
            --  [1] arg8 (ref)

            if table.find(arg8._muted_user_ids, arguments_1.UserId) then
                table.remove(arg8._muted_user_ids, arguments_1.UserId)
            end
        end)
    end)
    task.defer(arg8._SetupOnIncomingMessage, arg8)
    task.defer(arg8._UpdateChatBubblesEnabled, arg8)
end

return t_12._new()
