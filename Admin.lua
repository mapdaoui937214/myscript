local MY_USER_ID = 9391592113

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "Activate Kohl's Admin"
btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BorderSizePixel = 2
btn.Draggable = true
btn.Active = true

btn.MouseButton1Click:Connect(function()
    local KAI = _G.Admins or _G.KohlAdmin
    local lp = game.Players.LocalPlayer

    if KAI and lp.UserId == MY_USER_ID then
        KAI.AddAdmin(lp, 6)
        btn.Text = "Status: Creator"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

        if not _G.AdminCmdLoaded then
            _G.AdminCmdLoaded = true
            lp.Chatted:Connect(function(msg)
                local args = msg:split(" ")
                if #args < 2 then return end
                local cmd = args[1]:lower()
                local targetName = args[2]:lower()

                for _, target in ipairs(game.Players:GetPlayers()) do
                    if target.Name:lower():find(targetName) then
                        if cmd == ";give" then
                            KAI.AddAdmin(target, 3)
                        elseif cmd == ";take" then
                            KAI.RemoveAdmin(target)
                        end
                    end
                end
            end)
        end
    elseif not KAI then
        btn.Text = "KAI Not Found"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
