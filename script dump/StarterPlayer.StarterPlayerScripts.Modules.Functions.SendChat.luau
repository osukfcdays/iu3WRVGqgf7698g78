local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local ComplianceController_m = require(
    game:GetService("Players").LocalPlayer.PlayerScripts.Controllers:WaitForChild(
        "ComplianceController"
    )
)
local ServerMessageChannel_TextChannel = nil

if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    ServerMessageChannel_TextChannel = Instance.new("TextChannel")
    ServerMessageChannel_TextChannel.Name = "ServerMessageChannel"
    ServerMessageChannel_TextChannel.Parent = TextChatService:WaitForChild("TextChannels")
end

return function(arg1) -- line: 16
    -- upvalues:
    --  [1] ComplianceController_m (copy)
    --  [2] TextChatService (copy)
    --  [3] StarterGui (copy)
    --  [4] ServerMessageChannel_TextChannel (ref)

    assert(
        if typeof(arg1) ~= "table" then false else true,
        "Argument 1 invalid, expected a table, got " .. tostring(arg1)
    )

    if ComplianceController_m:IsChina() then
        return
    end

    if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
        arg1.Text = arg1.Text or "????????????????"
        arg1.Color = arg1.Color or Color3.fromRGB(0, 0, 0)
        arg1.Font = arg1.Font or Enum.Font.GothamMedium
        arg1.TextSize = arg1.TextSize or 14
        StarterGui:SetCore("ChatMakeSystemMessage", arg1)

        return
    end

    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        arg1.Text = arg1.Text or "NO CHAT_DATA.TEXT"
        local v5 = arg1.Font or Enum.Font.GothamBold
        arg1.Font = v5
        arg1.TextSize = arg1.TextSize or 14

        if typeof(arg1.Color) == "Color3" then
            v5 = arg1.Color

            if not v5 then
                v5 = typeof(arg1.Color) == "string" and Color3.fromHex(arg1.Color) or Color3.new()
            end
        else
            v5 = typeof(arg1.Color) == "string" and Color3.fromHex(arg1.Color) or Color3.new()
        end

        arg1.Color = v5
        v5 = "<font"

        if arg1.Color then
            local floorValue = math.floor(arg1.Color.R * 255)
            local floorValue_1 = math.floor(arg1.Color.G * 255)
            v5 = v5 .. " color=\"rgb(" .. floorValue .. "," .. floorValue_1 .. "," .. math.floor(
                arg1.Color.B * 255
            ) .. ")\""
        end

        if arg1.Font then
            v5 ..= " face=\"" .. (if typeof(arg1.Font) == "EnumItem" then arg1.Font.Name else tostring(
                arg1.Font
            )) .. "\""
        end

        if arg1.TextSize then
            v5 ..= " size=\"" .. arg1.TextSize .. "\""
        end

        ServerMessageChannel_TextChannel:DisplaySystemMessage((v5 .. ">") .. arg1.Text .. "</font>")
    end
end
