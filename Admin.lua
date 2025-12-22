local MY_USER_ID = 9391592113

local sg = Instance.new("ScreenGui", game:GetService("CoreGui"))
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0.5, -100, 0.4, 0)
btn.Text = "Wait for System..."
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Draggable = true
btn.Active = true

local function GetAPI()
    return _G.Admins or _G.KohlAdmin or (getgenv and (getgenv().Admins or getgenv().KohlAdmin))
end

btn.MouseButton1Click:Connect(function()
    local lp = game.Players.LocalPlayer
    if lp.UserId ~= MY_USER_ID then return end

    local KAI = GetAPI()
    if KAI then
        KAI.AddAdmin(lp, 6)
        btn.Text = "Creator Active"
        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)

        if not _G.AdminCmdLoaded then
            _G.AdminCmdLoaded = true
            lp.Chatted:Connect(function(msg)
                local args = msg:split(" ")
                if #args < 2 then return end
                local cmd, targetName = args[1]:lower(), args[2]:lower()
                for _, target in ipairs(game.Players:GetPlayers()) do
                    if target.Name:lower():find(targetName) then
                        if cmd == ";give" then KAI.AddAdmin(target, 3)
                        elseif cmd == ";take" then KAI.RemoveAdmin(target) end
                    end
                end
            end)
        end
    else
        btn.Text = "Error: Not Found"
    end
end)

task.spawn(function()
    while not GetAPI() do task.wait(0.5) end
    btn.Text = "Click to Get Admin"
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)
