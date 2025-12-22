local MY_USER_ID = 9391592113

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 160, 0, 50)
btn.Position = UDim2.new(0, 50, 0, 50)
btn.Text = "Waiting for KAI..."
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Draggable = true
btn.Active = true

local function GetKAI()
    local found = _G.Admins or _G.KohlAdmin
    if not found and debug and debug.getregistry then
        for _, v in pairs(debug.getregistry()) do
            if type(v) == "table" and rawget(v, "AddAdmin") and rawget(v, "RemoveAdmin") then
                return v
            end
        end
    end
    return found
end

btn.MouseButton1Click:Connect(function()
    local KAI = GetKAI()
    local lp = game.Players.LocalPlayer

    if KAI and lp.UserId == MY_USER_ID then
        KAI.AddAdmin(lp, 6)
        btn.Text = "Admin: Creator"
        btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)

        if not _G.AdminCmdLoaded then
            _G.AdminCmdLoaded = true
            lp.Chatted:Connect(function(msg)
                local args = msg:split(" ")
                if #args < 2 then return end
                local cmd, targetName = args[1]:lower(), args[2]:lower()

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
    else
        btn.Text = "KAI Not Found"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        task.wait(1)
        btn.Text = "Retry Click"
    end
end)

task.spawn(function()
    while not GetKAI() do task.wait(0.5) end
    btn.Text = "Ready: Click to Activate"
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)
